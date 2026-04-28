package com.agriconnect.controller;

import com.agriconnect.dto.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<String>> register() {
        // Implementation stub for JWT registration
        return ResponseEntity.ok(ApiResponse.success("Registration successful", "User registered"));
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<String>> login() {
        // Implementation stub for JWT login
        return ResponseEntity.ok(ApiResponse.success("jwt_token_here", "Login successful"));
    }

    @PostMapping("/refresh-token")
    public ResponseEntity<ApiResponse<String>> refreshToken() {
        return ResponseEntity.ok(ApiResponse.success("new_jwt_token_here", "Token refreshed"));
    }

    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<String>> logout() {
        return ResponseEntity.ok(ApiResponse.success(null, "Logged out successfully"));
    }
}
