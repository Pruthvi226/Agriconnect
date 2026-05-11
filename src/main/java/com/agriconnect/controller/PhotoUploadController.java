package com.agriconnect.controller;

import com.agriconnect.service.PhotoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@Controller
public class PhotoUploadController {

    @Autowired
    private PhotoService photoService;

    @PostMapping("/api/farmer/listings/{id}/photos")
    public ResponseEntity<Map<String, String>> uploadPhoto(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file) {
        try {
            String filename = photoService.save(id, file);
            return ResponseEntity.ok(Map.of("filename", filename));
        } catch (IOException | IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
}
