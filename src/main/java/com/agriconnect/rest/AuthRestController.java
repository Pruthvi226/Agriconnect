package com.agriconnect.rest;

import com.agriconnect.dao.UserDao;
import com.agriconnect.model.User;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.security.JwtTokenProvider;
import com.agriconnect.security.LoginIdentity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthRestController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Autowired
    private UserDao userDao;

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> request) {
        String email = LoginIdentity.normalizeEmail(request.get("email"));
        User user = resolveUser(email, request.get("role"));
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(LoginIdentity.format(user), request.get("password")));
        String token = jwtTokenProvider.generateToken(authentication);
        CustomUserDetails details = (CustomUserDetails) authentication.getPrincipal();
        return ResponseEntity.ok(Map.of(
                "token", token,
                "role", details.getUser().getRole().name(),
                "userId", details.getId()));
    }

    private User resolveUser(String email, String roleValue) {
        if (roleValue != null && !roleValue.isBlank()) {
            return userDao.findByEmailAndRole(email, User.Role.valueOf(roleValue.toUpperCase()))
                    .orElseThrow(() -> new IllegalArgumentException("Invalid email or role"));
        }
        return userDao.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Invalid email or role"));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handle(Exception ex) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", ex.getMessage()));
    }
}
