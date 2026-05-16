package com.agriconnect.config;

import com.agriconnect.security.JwtAuthFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.io.IOException;
import java.util.Collection;

import static org.springframework.security.web.util.matcher.AntPathRequestMatcher.antMatcher;

@Configuration
@EnableAsync
@EnableScheduling
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
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        // PUBLIC - liveness + readiness probes must be accessible without auth
                        .requestMatchers(
                                antMatcher("/health"), // Render liveness probe (no DB dependency)
                                antMatcher("/actuator/health"), // detailed readiness probe
                                antMatcher("/auth/**"),
                                antMatcher("/api/auth/**"),
                                antMatcher("/api/v1/auth/**"),
                                antMatcher("/"),
                                antMatcher("/web"),
                                antMatcher("/web/login"),
                                antMatcher("/web/register"),
                                antMatcher("/web/marketplace"),
                                antMatcher("/web/marketplace/listing/**"),
                                antMatcher("/web/msp-checker"),
                                antMatcher("/chain/**"),
                                antMatcher("/qr/**"),
                                antMatcher("/api/msp"),
                                antMatcher("/api/v1/listings/search"),
                                antMatcher("/api/v1/listings/*/msp-comparison"),
                                antMatcher("/resources/**"))
                        .permitAll()
                        // FARMER
                        .requestMatchers(
                                antMatcher("/api/farmer/**"),
                                antMatcher("/api/v1/listings"),
                                antMatcher("/api/v1/fpo/groups"),
                                antMatcher("/api/v1/fpo/*/join"),
                                antMatcher("/api/v1/fpo/memberships/*/approve"),
                                antMatcher("/api/v1/fpo/*/listings"),
                                antMatcher("/api/v1/bids/received"),
                                antMatcher("/api/v1/bids/*/accept"),
                                antMatcher("/api/v1/bids/*/reject"),
                                antMatcher("/api/v1/bids/orders/**"),
                                antMatcher("/farmer/**"),
                                antMatcher("/web/farmer"),
                                antMatcher("/web/farmer/**"))
                        .hasRole("FARMER")
                        // BUYER
                        .requestMatchers(
                                antMatcher("/api/v1/bids"),
                                antMatcher("/api/v1/bids/**"),
                                antMatcher("/api/v1/orders/my"),
                                antMatcher("/buyer/**"),
                                antMatcher("/web/buyer/**"),
                                antMatcher("/web/dashboard/buyer"))
                        .hasRole("BUYER")
                        // EXPERT
                        .requestMatchers(
                                antMatcher("/api/v1/advisories/**"),
                                antMatcher("/api/v1/expert/**"),
                                antMatcher("/expert/**"),
                                antMatcher("/web/expert/**"),
                                antMatcher("/web/dashboard/expert"))
                        .hasRole("AGRI_EXPERT")
                        .requestMatchers(
                                antMatcher("/api/v1/consultations/**"))
                        .authenticated()
                        // ADMIN
                        .requestMatchers(
                                antMatcher("/web/admin/**"),
                                antMatcher("/web/dashboard/admin"),
                                antMatcher("/api/v1/admin/**"),
                                antMatcher("/api/v1/orders/*/qr-download"),
                                antMatcher("/api/v1/orders/*/supply-chain"),
                                antMatcher("/actuator/metrics"))
                        .hasRole("ADMIN")
                        // Notifications for authenticated users
                        .requestMatchers(
                                antMatcher("/web/notifications/**"),
                                antMatcher("/web/advisories/**"))
                        .authenticated()
                        // ANY OTHER
                        .anyRequest().authenticated())
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))
                .formLogin(form -> form
                        .loginPage("/auth/login")
                        .loginProcessingUrl("/auth/login")
                        .successHandler(roleBasedSuccessHandler())
                        .failureUrl("/auth/login?error=true")
                        .permitAll())
                .logout(logout -> logout
                        .logoutUrl("/auth/logout")
                        .logoutSuccessUrl("/auth/login?logout=true")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .permitAll())
                .authenticationProvider(authenticationProvider())
                .addFilterBefore(rateLimitFilter, UsernamePasswordAuthenticationFilter.class)
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public AuthenticationSuccessHandler roleBasedSuccessHandler() {
        return new AuthenticationSuccessHandler() {
            @Override
            public void onAuthenticationSuccess(HttpServletRequest request,
                    HttpServletResponse response,
                    Authentication authentication) throws IOException {
                Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
                String redirectUrl = "/web/marketplace";
                for (GrantedAuthority authority : authorities) {
                    String role = authority.getAuthority();
                    if (role.equals("ROLE_FARMER")) {
                        redirectUrl = "/web/farmer/dashboard";
                        break;
                    } else if (role.equals("ROLE_BUYER")) {
                        redirectUrl = "/web/buyer/dashboard";
                        break;
                    } else if (role.equals("ROLE_AGRI_EXPERT")) {
                        redirectUrl = "/web/expert/dashboard";
                        break;
                    } else if (role.equals("ROLE_ADMIN")) {
                        redirectUrl = "/web/admin/dashboard";
                        break;
                    }
                }
                response.sendRedirect(request.getContextPath() + redirectUrl);
            }
        };
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
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(12);
    }
}
