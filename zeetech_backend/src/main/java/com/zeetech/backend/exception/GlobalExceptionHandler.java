package com.zeetech.backend.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * Catches all unhandled exceptions, logs them securely on the server console,
     * and masks database / internal details from the client to prevent hacking.
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleAllExceptions(Exception ex) {
        // Log the actual error to the server console securely
        System.err.println("==================================================");
        System.err.println("[SECURITY TRIGGER] SYSTEM ERROR INTERCEPTED:");
        System.err.println("Message: " + ex.getMessage());
        ex.printStackTrace();
        System.err.println("==================================================");

        // Send a sanitized response back to the Flutter app
        Map<String, String> response = new HashMap<>();
        response.put("error", "Internal Server Error");
        response.put("message", "An unexpected system error occurred. Please try again later or contact support.");
        
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
