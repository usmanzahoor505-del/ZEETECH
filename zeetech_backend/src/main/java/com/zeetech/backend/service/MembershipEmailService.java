package com.zeetech.backend.service;

import com.zeetech.backend.model.MembershipApplication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class MembershipEmailService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    public void sendApprovalEmail(MembershipApplication application) {
        if (application.getEmail() == null || application.getEmail().trim().isEmpty()) {
            System.out.println("Skipping approval email: No email address provided for applicant " + application.getFullName());
            return;
        }

        String recipientEmail = application.getEmail().trim();
        String subject = "ZEETECH Membership Approved - Registered Member ID: " + application.getMembershipId();
        
        String messageBody = "Dear " + application.getFullName() + ",\n\n"
                + "We are thrilled to inform you that your application for ZEETECH Membership has been officially APPROVED! 🎉\n\n"
                + "Welcome to the elite circle of ZEETECH members. Below are your official registered membership details:\n\n"
                + "--------------------------------------------------\n"
                + "  🪪 MEMBERSHIP ID:     " + application.getMembershipId() + "\n"
                + "  📋 CATEGORY:          " + application.getCategory() + "\n"
                + "  🥇 PLAN:              " + application.getPlanName() + " Membership\n"
                + "  🎁 BENEFITS:          " + application.getDiscount() + " OFF on all eligible services\n"
                + "  🗓️ VALIDITY:          " + application.getValidity() + "\n"
                + "--------------------------------------------------\n\n"
                + "Your membership discount is now active. Simply present your digital Membership ID or mention it when booking your home or commercial maintenance services to avail your exclusive discount!\n\n"
                + "If you have any questions or require support, please feel free to reach out to us at ismailathar002@gmail.com or call our helpline.\n\n"
                + "Thank you for choosing ZEETECH. We look forward to serving you with excellence!\n\n"
                + "Best Regards,\n"
                + application.getOfficerName() + "\n"
                + application.getOfficerDesignation() + "\n"
                + "ZEETECH26 (Pvt.) Ltd.";

        try {
            if (mailSender != null) {
                SimpleMailMessage mailMessage = new SimpleMailMessage();
                mailMessage.setTo(recipientEmail);
                mailMessage.setSubject(subject);
                mailMessage.setText(messageBody);
                mailMessage.setFrom("ismailathar002@gmail.com");
                mailSender.send(mailMessage);
                System.out.println("SUCCESS: Membership approval email successfully sent to: " + recipientEmail);
            } else {
                System.out.println("WARNING: MailSender bean is null. Approval email logged to console below:\n");
                System.out.println("==================================================");
                System.out.println("SUBJECT: " + subject);
                System.out.println(messageBody);
                System.out.println("==================================================");
            }
        } catch (Exception e) {
            System.err.println("CRITICAL: Failed to send membership approval email via SMTP: " + e.getMessage());
            System.err.println("Fall-back: Logged approval to console successfully.");
        }
    }
}
