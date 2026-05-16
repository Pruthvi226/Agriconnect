package com.agriconnect.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import org.springframework.lang.NonNull;

import java.io.IOException;
import java.util.Deque;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedDeque;

@Component
public class RateLimitFilter extends OncePerRequestFilter {

    private final int MAX_REQUESTS_PER_MINUTE = 100;
    private final ConcurrentHashMap<String, Deque<Long>> requestCounts = new ConcurrentHashMap<>();

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request, @NonNull HttpServletResponse response, @NonNull FilterChain filterChain)
            throws ServletException, IOException {

        if (request.getRequestURI().startsWith(request.getContextPath() + "/api/")) {
            String clientIp = getClientIp(request);
            long currentTime = System.currentTimeMillis();

            Deque<Long> requests = requestCounts.computeIfAbsent(clientIp, k -> new ConcurrentLinkedDeque<>());

            // Remove timestamps older than 1 minute
            while (!requests.isEmpty() && currentTime - requests.peekFirst() > 60000) {
                requests.pollFirst();
            }

            if (requests.size() >= MAX_REQUESTS_PER_MINUTE) {
                response.setStatus(429); // Too Many Requests
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.setHeader("Retry-After", "60");
                response.getWriter().write("{\"error\":\"Too many requests. Please try again later.\"}");
                return;
            }

            requests.addLast(currentTime);
        }

        filterChain.doFilter(request, response);
    }

    private String getClientIp(HttpServletRequest request) {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null) {
            return request.getRemoteAddr();
        }
        return xfHeader.split(",")[0];
    }
}
