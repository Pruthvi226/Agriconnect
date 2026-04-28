# Must match maven.compiler.release=21 in pom.xml.
# Using jdk17 here would cause UnsupportedClassVersionError at startup.
FROM tomcat:10.1-jdk21-temurin

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the generated WAR file into the ROOT context
COPY target/agriconnect.war /usr/local/tomcat/webapps/ROOT.war

# Set default active profile to production
ENV SPRING_PROFILES_ACTIVE=production

EXPOSE 8080

CMD ["catalina.sh", "run"]
