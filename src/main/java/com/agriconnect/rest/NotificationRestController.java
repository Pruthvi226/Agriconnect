package com.agriconnect.rest;

import com.agriconnect.dao.NotificationDao;
import com.agriconnect.model.Notification;
import com.agriconnect.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
public class NotificationRestController {

    @Autowired
    private NotificationDao notificationDao;

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> notifications(Authentication authentication) {
        CustomUserDetails user = (CustomUserDetails) authentication.getPrincipal();
        return ResponseEntity.ok(notificationDao.findByUser(user.getId()).stream()
                .map(this::toMap)
                .toList());
    }

    @PutMapping("/{id}/read")
    public ResponseEntity<Map<String, Object>> markAsRead(@PathVariable("id") Long id) {
        Notification notification = notificationDao.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Notification not found"));
        notification.setIsRead(true);
        notificationDao.update(notification);
        return ResponseEntity.ok(toMap(notification));
    }

    private Map<String, Object> toMap(Notification notification) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("id", notification.getId());
        body.put("title", notification.getTitle());
        body.put("body", notification.getBody());
        body.put("type", notification.getType());
        body.put("read", notification.getIsRead());
        return body;
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handle(Exception ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", ex.getMessage()));
    }
}
