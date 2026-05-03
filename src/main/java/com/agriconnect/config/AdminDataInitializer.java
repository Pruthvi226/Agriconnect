package com.agriconnect.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.lang.NonNull;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.EncodedResource;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.util.StreamUtils;

import javax.sql.DataSource;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class AdminDataInitializer implements ApplicationListener<ContextRefreshedEvent> {

    private static final Logger log = LoggerFactory.getLogger(AdminDataInitializer.class);
    private static final Pattern BCRYPT_TOKEN = Pattern.compile("\\{\\{bcrypt:([^}]+)}}");
    private static final AtomicBoolean INITIALIZED = new AtomicBoolean(false);

    @Autowired
    private DataSource dataSource;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    @Value("classpath:schema.sql")
    private Resource schemaScript;

    @Value("classpath:seed-data.sql")
    private Resource seedScript;

    @Override
    @SuppressWarnings("null")
    public void onApplicationEvent(@NonNull ContextRefreshedEvent event) {
        if (event.getApplicationContext().getParent() != null || !INITIALIZED.compareAndSet(false, true)) {
            return;
        }

        try (Connection connection = dataSource.getConnection()) {
            if (!shouldInitialize(connection)) {
                log.info("AdminDataInitializer skipped because users table already contains data");
                return;
            }

            boolean originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            try {
                Resource schemaRes = schemaScript;
                ScriptUtils.executeSqlScript(connection, new EncodedResource(schemaRes, StandardCharsets.UTF_8));
                byte[] seedBytes = renderSeedScript().getBytes(StandardCharsets.UTF_8);
                ScriptUtils.executeSqlScript(connection, new EncodedResource(
                        new ByteArrayResource(seedBytes),
                        StandardCharsets.UTF_8));
                connection.commit();
                log.info("Database schema and seed data initialized successfully");
            } catch (Exception ex) {
                connection.rollback();
                throw ex;
            } finally {
                connection.setAutoCommit(originalAutoCommit);
            }
        } catch (Exception ex) {
            throw new IllegalStateException("Failed to initialize AgriConnect seed data", ex);
        }
    }

    private boolean shouldInitialize(Connection connection) {
        try (Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery("SELECT COUNT(*) FROM users")) {
            resultSet.next();
            return resultSet.getLong(1) == 0L;
        } catch (SQLException ex) {
            log.info("Users table not available yet; schema initialization will run");
            return true;
        }
    }

    @SuppressWarnings("null")
    private String renderSeedScript() throws IOException {
        String template = StreamUtils.copyToString(seedScript.getInputStream(), StandardCharsets.UTF_8);
        Matcher matcher = BCRYPT_TOKEN.matcher(template);
        StringBuffer rendered = new StringBuffer();
        while (matcher.find()) {
            matcher.appendReplacement(rendered, Matcher.quoteReplacement(passwordEncoder.encode(matcher.group(1))));
        }
        matcher.appendTail(rendered);
        return rendered.toString();
    }
}
