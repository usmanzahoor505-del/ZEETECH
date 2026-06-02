package com.zeetech.backend.util;

import org.mindrot.jbcrypt.BCrypt;

public class HashUtil {

    /**
     * Hash password with BCrypt (generates dynamic salt)
     */
    public static String hash(String input) {
        if (input == null) return null;
        return BCrypt.hashpw(input, BCrypt.gensalt(12));
    }

    /**
     * Securely verify a raw password against the BCrypt hash
     */
    public static boolean verify(String input, String hashed) {
        if (input == null || hashed == null) return false;
        try {
            // Check if the hash starts with $2a$ or similar BCrypt patterns.
            // If it is an old SHA-256 hash or plain password, we fall back or fail gracefully.
            if (hashed.startsWith("$2a$") || hashed.startsWith("$2y$") || hashed.startsWith("$2b$")) {
                return BCrypt.checkpw(input, hashed);
            }
            // Fallback for pre-existing SHA-256 passwords so users aren't locked out.
            // This is critical for bug-free smooth migration!
            return hashed.equalsIgnoreCase(sha256Fallback(input));
        } catch (Exception e) {
            return false;
        }
    }

    private static String sha256Fallback(String input) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            return "";
        }
    }
}
