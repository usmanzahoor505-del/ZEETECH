package com.zeetech.backend.controller;

import com.zeetech.backend.model.User;
import com.zeetech.backend.repository.UserRepository;
import com.zeetech.backend.util.HashUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private com.zeetech.backend.service.OtpService otpService;

    @PostMapping("/send-otp")
    public ResponseEntity<?> sendOtp(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        if (email == null || email.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Email is required to send OTP");
        }

        Optional<User> existing = userRepository.findByEmail(email.trim());
        if (existing.isPresent()) {
            return ResponseEntity.badRequest().body("Email already registered");
        }

        String otp = otpService.generateOtp(email);
        otpService.sendOtpEmail(email, otp);

        Map<String, String> response = new HashMap<>();
        response.put("message", "OTP sent successfully to " + email);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@RequestBody Map<String, String> request) {
        String fullName = request.get("fullName");
        String email = request.get("email");
        String phone = request.get("phone");
        String password = request.get("password");
        String otp = request.get("otp");

        if (email == null || password == null) {
            return ResponseEntity.badRequest().body("Email and Password are required");
        }

        if (otp == null || otp.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Verification code (OTP) is required");
        }

        boolean isOtpValid = otpService.validateOtp(email, otp);
        if (!isOtpValid) {
            return ResponseEntity.badRequest().body("Invalid or expired verification code (OTP)");
        }

        Optional<User> existing = userRepository.findByEmail(email);
        if (existing.isPresent()) {
            return ResponseEntity.badRequest().body("Email already registered");
        }

        String passwordHash = HashUtil.hash(password);
        User user = new User(fullName, email, phone, passwordHash, "USER");
        userRepository.save(user);

        Map<String, String> response = new HashMap<>();
        response.put("message", "User registered successfully");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@RequestBody Map<String, String> request) {
        String email = request.get("email");
        String password = request.get("password");

        if (email == null || password == null) {
            return ResponseEntity.badRequest().body("Email and Password are required");
        }

        // Predefined admin credentials check
        if ("admin".equalsIgnoreCase(email) && "admin123".equals(password)) {
            Map<String, String> adminResponse = new HashMap<>();
            adminResponse.put("email", "admin");
            adminResponse.put("fullName", "Admin Administrator");
            adminResponse.put("phone", "0000000000");
            adminResponse.put("role", "ADMIN");
            return ResponseEntity.ok(adminResponse);
        }

        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return ResponseEntity.status(401).body("Invalid credentials");
        }

        User user = userOpt.get();
        String passwordHash = HashUtil.hash(password);
        if (!user.getPasswordHash().equals(passwordHash)) {
            return ResponseEntity.status(401).body("Invalid credentials");
        }

        Map<String, String> userResponse = new HashMap<>();
        userResponse.put("email", user.getEmail());
        userResponse.put("fullName", user.getFullName());
        userResponse.put("phone", user.getPhone());
        userResponse.put("role", user.getRole());
        return ResponseEntity.ok(userResponse);
    }
}
