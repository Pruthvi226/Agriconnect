package com.agriconnect.controller;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Lightweight liveness probe endpoint for Render / cloud load-balancers.
 *
 * This endpoint has ZERO external dependencies (no DB, no Hibernate, no cache).
 * It returns HTTP 200 as long as the JVM and Tomcat are running.
 *
 * render.yaml should point healthCheckPath here:
 *   healthCheckPath: /health
 *
 * The richer readiness/DB check lives at /actuator/health.
 */
public class HealthController {

    /** Captures the exact moment this instance started serving requests. */
    private static final Instant START_TIME = Instant.now();

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> ping() {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("status", "UP");
        body.put("service", "AgriConnect");
        body.put("version", "1.0");
        body.put("timestamp", Instant.now().toString());
        body.put("uptime_seconds", java.time.Duration.between(START_TIME, Instant.now()).getSeconds());
        return ResponseEntity.ok(body);
    }
}
