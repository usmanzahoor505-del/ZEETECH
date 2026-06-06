package com.zeetech.backend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class OtpService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    // Cache structure: Email -> OtpData
    private final ConcurrentHashMap<String, OtpData> otpCache = new ConcurrentHashMap<>();

    private static final long OTP_VALIDITY_DURATION_MS = 5 * 60 * 1000; // 5 minutes

    private static class OtpData {
        final String code;
        final long expiryTime;

        OtpData(String code, long expiryTime) {
            this.code = code;
            this.expiryTime = expiryTime;
        }
    }

    /**
     * Generate 6-digit OTP code
     */
    public String generateOtp(String email) {
        Random random = new Random();
        String otp = String.format("%06d", random.nextInt(999999));
        
        long expiryTime = System.currentTimeMillis() + OTP_VALIDITY_DURATION_MS;
        otpCache.put(email.toLowerCase().trim(), new OtpData(otp, expiryTime));
        
        System.out.println("==================================================");
        System.out.println(" GENERATED OTP FOR: " + email);
        System.out.println(" OTP CODE IS:       " + otp);
        System.out.println("==================================================");
        
        return otp;
    }

    /**
     * Send OTP Code via SMTP mail sender
     */
    public void sendOtpEmail(String email, String otp) {
        String subject = "ZeeTech Signup Verification Code";
        String messageBody = "Dear Customer,\n\n"
                + "Thank you for registering with ZeeTech Technical Services.\n"
                + "Your 6-digit OTP Verification Code is:\n\n"
                + "   --> " + otp + " <--\n\n"
                + "This OTP is valid for 5 minutes. Please do not share this code with anyone.\n\n"
                + "Best Regards,\n"
                + "ZeeTech Technical Services Team";

        try {
            if (mailSender != null) {
                SimpleMailMessage mailMessage = new SimpleMailMessage();
                mailMessage.setTo(email.trim());
                mailMessage.setSubject(subject);
                mailMessage.setText(messageBody);
                mailSender.send(mailMessage);
                System.out.println("OTP successfully sent to email: " + email);
            } else {
                System.out.println("WARNING: MailSender bean is null. Using console fallback.");
            }
        } catch (Exception e) {
            System.err.println("CRITICAL: Failed to send email via SMTP: " + e.getMessage());
            System.err.println("Fall-back to Console verification: Use OTP code [" + otp + "] from server console log to signup.");
        }
    }

    /**
     * Send Password Reset OTP Code via SMTP mail sender
     */
    public void sendResetPasswordEmail(String email, String otp) {
        String subject = "ZeeTech Password Reset Verification Code";
        String messageBody = "Dear Customer,\n\n"
                + "We received a request to reset the password for your ZeeTech account.\n"
                + "Your 6-digit Reset Verification Code is:\n\n"
                + "   --> " + otp + " <--\n\n"
                + "This OTP is valid for 5 minutes. If you did not request a password reset, please ignore this email.\n\n"
                + "Best Regards,\n"
                + "ZeeTech Technical Services Team";

        try {
            if (mailSender != null) {
                SimpleMailMessage mailMessage = new SimpleMailMessage();
                mailMessage.setTo(email.trim());
                mailMessage.setSubject(subject);
                mailMessage.setText(messageBody);
                mailSender.send(mailMessage);
                System.out.println("Reset Password OTP successfully sent to email: " + email);
            } else {
                System.out.println("WARNING: MailSender bean is null. Using console fallback.");
            }
        } catch (Exception e) {
            System.err.println("CRITICAL: Failed to send password reset email via SMTP: " + e.getMessage());
            System.err.println("Fall-back to Console verification: Use OTP code [" + otp + "] from server console log to reset password.");
        }
    }

    /**
     * Validate user entered OTP code
     */
    public boolean validateOtp(String email, String enteredOtp) {
        String key = email.toLowerCase().trim();
        if (!otpCache.containsKey(key)) {
            return false;
        }

        OtpData otpData = otpCache.get(key);
        if (System.currentTimeMillis() > otpData.expiryTime) {
            otpCache.remove(key); // Clean up expired OTP
            return false;
        }

        boolean isValid = otpData.code.equals(enteredOtp.trim());
        if (isValid) {
            otpCache.remove(key); // Consume/Use OTP on successful verification
        }
        return isValid;
    }
}
