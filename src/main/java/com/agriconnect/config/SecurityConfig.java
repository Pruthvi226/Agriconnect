package com.agriconnect.config;

import com.agriconnect.security.JwtAuthFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import static org.springframework.security.web.util.matcher.AntPathRequestMatcher.antMatcher;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
public class SecurityConfig {

    @Autowired
    private JwtAuthFilter jwtAuthFilter;

    @Autowired
    private com.agriconnect.security.RateLimitFilter rateLimitFilter;

    @Autowired
    private UserDetailsService userDetailsService;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Disabled for simplicity/demo, should enable in true prod
            .authorizeHttpRequests(auth -> auth
                // PUBLIC
                .requestMatchers(
                    antMatcher("/api/v1/auth/**"),
                    antMatcher("/"),
                    antMatcher("/web"),
                    antMatcher("/web/login"),
                    antMatcher("/web/register"),
                    antMatcher("/web/marketplace"),
                    antMatcher("/resources/**"),
                    antMatcher("/actuator/health")
                ).permitAll()
                // FARMER
                .requestMatchers(
                    antMatcher("/api/v1/listings/**"),
                    antMatcher("/api/v1/bids/received"),
                    antMatcher("/web/dashboard/farmer")
                ).hasRole("FARMER")
                // BUYER
                .requestMatchers(
                    antMatcher("/api/v1/bids/**"),
                    antMatcher("/api/v1/orders/my"),
                    antMatcher("/web/dashboard/buyer")
                ).hasRole("BUYER")
                // EXPERT
                .requestMatchers(
                    antMatcher("/api/v1/advisories/**"),
                    antMatcher("/web/dashboard/expert")
                ).hasRole("AGRI_EXPERT")
                // ADMIN AND METRICS
                .requestMatchers(
                    antMatcher("/web/admin/**"),
                    antMatcher("/api/v1/admin/**"),
                    antMatcher("/actuator/metrics")
                ).hasRole("ADMIN")
                // ANY OTHER
                .anyRequest().authenticated()
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
            )
            .formLogin(form -> form
                .loginPage("/web/login")
                .loginProcessingUrl("/login")
                .defaultSuccessUrl("/web/marketplace", true)
                .failureUrl("/web/login?error=true")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/web/login?logout=true")
                .permitAll()
            )
            .authenticationProvider(authenticationProvider())
            .addFilterBefore(rateLimitFilter, UsernamePasswordAuthenticationFilter.class)
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }
}
