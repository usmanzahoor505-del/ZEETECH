package com.zeetech.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.*;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api")
public class UploadController {

    private final Path root = Paths.get("uploads");

    public UploadController() {
        try {
            Files.createDirectories(root);
        } catch (IOException e) {
            System.err.println("Could not initialize folder for uploads: " + e.getMessage());
        }
    }

    @PostMapping("/upload")
    public ResponseEntity<?> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "File is empty"));
            }

            // Ensure uploads folder exists
            Files.createDirectories(root);

            // Extract original file extension
            String extension = "";
            String originalFilename = file.getOriginalFilename();
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            } else {
                extension = ".jpg"; // fallback
            }

            // Unique filename using UUID
            String filename = UUID.randomUUID().toString() + extension;
            Files.copy(file.getInputStream(), this.root.resolve(filename), StandardCopyOption.REPLACE_EXISTING);

            // Return relative URL to dynamically construct IP client-side
            Map<String, String> response = new HashMap<>();
            response.put("url", "/uploads/" + filename);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("error", "File upload failed: " + e.getMessage());
            return ResponseEntity.internalServerError().body(response);
        }
    }
}
