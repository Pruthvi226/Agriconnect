package com.agriconnect.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.List;

public class JwtTokenProvider implements InitializingBean {

    private String jwtSecret;
    private long jwtExpirationInMs = 86400000L;
    private SecretKey secretKey;

    @Override
    public void afterPropertiesSet() {
        String secret = jwtSecret == null || jwtSecret.isBlank()
                ? "supersecretdevjwtkeythathastobeatleast256bitslong!"
                : jwtSecret.trim();
        if (secret.getBytes(StandardCharsets.UTF_8).length < 32) {
            throw new IllegalArgumentException("JWT_SECRET must be at least 256 bits (32 bytes)");
        }
        this.secretKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    public String generateToken(Authentication authentication) {
        Object principal = authentication.getPrincipal();
        String subject;
        Long userId = null;
        String role = null;

        if (principal instanceof CustomUserDetails userDetails) {
            subject = userDetails.getUsername();
            userId = userDetails.getId();
            role = userDetails.getUser().getRole().name();
        } else {
            subject = authentication.getName();
        }

        List<String> authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .toList();

        Date now = new Date();
        Date expiry = new Date(now.getTime() + jwtExpirationInMs);
        return Jwts.builder()
                .setSubject(subject)
                .claim("userId", userId)
                .claim("role", role)
                .claim("authorities", authorities)
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(secretKey)
                .compact();
    }

    public boolean validateToken(String token) {
        try {
            Claims claims = parseClaims(token);
            return claims.getExpiration() == null || claims.getExpiration().after(new Date());
        } catch (RuntimeException ex) {
            return false;
        }
    }

    public String getUserEmailFromToken(String token) {
        String subject = parseClaims(token).getSubject();
        return LoginIdentity.parse(subject).getEmail();
    }

    public String getSubjectFromToken(String token) {
        return parseClaims(token).getSubject();
    }

    private Claims parseClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public void setJwtSecret(String jwtSecret) {
        this.jwtSecret = jwtSecret;
    }

    public void setJwtExpirationInMs(long jwtExpirationInMs) {
        this.jwtExpirationInMs = jwtExpirationInMs;
    }
}
