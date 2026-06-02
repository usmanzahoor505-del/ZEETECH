package com.zeetech.backend.controller;

import com.zeetech.backend.model.MembershipApplication;
import com.zeetech.backend.repository.MembershipApplicationRepository;
import com.zeetech.backend.service.MembershipEmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/memberships")
@CrossOrigin(origins = "*")
public class MembershipApplicationController {

    @Autowired
    private MembershipApplicationRepository membershipRepository;

    @Autowired
    private MembershipEmailService emailService;

    @GetMapping
    public ResponseEntity<List<MembershipApplication>> getAllApplications(
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String mobile) {
        
        if (email != null && !email.trim().isEmpty()) {
            return ResponseEntity.ok(membershipRepository.findByEmailOrMobileOrderByIdDesc(email, email));
        }
        if (mobile != null && !mobile.trim().isEmpty()) {
            return ResponseEntity.ok(membershipRepository.findByEmailOrMobileOrderByIdDesc(mobile, mobile));
        }
        
        return ResponseEntity.ok(membershipRepository.findAll(Sort.by(Sort.Direction.DESC, "id")));
    }

    @PostMapping
    public ResponseEntity<?> submitApplication(@RequestBody Map<String, String> request) {
        String category = request.get("category");
        String planName = request.get("planName");
        String discount = request.get("discount");
        String validity = request.get("validity");
        
        // Applicant Info
        String fullName = request.get("fullName");
        String fatherName = request.get("fatherName");
        String cnic = request.get("cnic");
        String dob = request.get("dob");
        String occupation = request.get("occupation");
        
        // Contact Info
        String mobile = request.get("mobile");
        String altContact = request.get("altContact");
        String email = request.get("email");
        String address = request.get("address");
        String preferredServices = request.get("preferredServices");

        if (category == null || planName == null || discount == null || validity == null ||
            fullName == null || fatherName == null || cnic == null || dob == null ||
            mobile == null || address == null) {
            return ResponseEntity.badRequest().body("Required fields are missing");
        }

        // Check if there is an active/pending membership with the same CNIC (sanitized to ignore dashes and spaces)
        String requestedSanitized = cnic.replaceAll("[\\s-]", "").toLowerCase();
        System.out.println("[CNIC Validation] Checking requested: " + requestedSanitized);
        List<MembershipApplication> allApps = membershipRepository.findAll();
        for (MembershipApplication app : allApps) {
            if (app.getCnic() != null) {
                String existingSanitized = app.getCnic().replaceAll("[\\s-]", "").toLowerCase();
                System.out.println("[CNIC Validation] Comparing with DB record ID " + app.getId() + " (" + app.getStatus() + "): " + existingSanitized);
                if (requestedSanitized.equals(existingSanitized)) {
                    if ("Pending".equalsIgnoreCase(app.getStatus()) || "Approved".equalsIgnoreCase(app.getStatus())) {
                        System.out.println("[CNIC Validation] MATCH FOUND & BLOCKED: " + app.getCnic() + " is " + app.getStatus());
                        return ResponseEntity.badRequest().body("This CNIC is already active member");
                    }
                }
            }
        }

        // Check if there is an active/pending application in the same category for the same email/mobile
        List<MembershipApplication> existing = membershipRepository.findByEmailOrMobileOrderByIdDesc(
            email != null ? email.trim() : "", 
            mobile.trim()
        );
        for (MembershipApplication app : existing) {
            if (category.equalsIgnoreCase(app.getCategory()) && 
                ("Pending".equalsIgnoreCase(app.getStatus()) || 
                 ("Approved".equalsIgnoreCase(app.getStatus()) && isMembershipActive(app)))) {
                return ResponseEntity.badRequest().body("You already have an active or pending " + category + " membership!");
            }
        }

        MembershipApplication application = new MembershipApplication(
            category,
            planName,
            discount,
            validity,
            fullName,
            fatherName,
            cnic,
            dob,
            occupation != null ? occupation : "",
            mobile,
            altContact != null ? altContact : "",
            email != null ? email : "",
            address,
            preferredServices != null ? preferredServices : "",
            LocalDateTime.now()
        );

        MembershipApplication saved = membershipRepository.save(application);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}/approve")
    public ResponseEntity<?> approveApplication(@PathVariable Long id, @RequestBody Map<String, String> request) {
        Optional<MembershipApplication> appOpt = membershipRepository.findById(id);
        if (appOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        String membershipId = request.get("membershipId");
        String initiatedBy = request.get("initiatedBy");
        String remarks = request.get("remarks");
        String officerName = request.get("officerName");
        String officerDesignation = request.get("officerDesignation");
        String officerEmpId = request.get("officerEmpId");

        if (membershipId == null || membershipId.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Membership ID is required for approval");
        }

        MembershipApplication application = appOpt.get();
        application.setMembershipId(membershipId);
        application.setInitiatedBy(initiatedBy != null ? initiatedBy : "");
        application.setRemarks(remarks != null ? remarks : "");
        application.setOfficerName(officerName != null ? officerName : "");
        application.setOfficerDesignation(officerDesignation != null ? officerDesignation : "");
        application.setOfficerEmpId(officerEmpId != null ? officerEmpId : "");
        application.setStatus("Approved");
        application.setProcessedAt(LocalDateTime.now());

        MembershipApplication saved = membershipRepository.save(application);
        
        // Trigger email notification in a separate thread so it doesn't block the API response
        try {
            new Thread(() -> emailService.sendApprovalEmail(saved)).start();
        } catch (Exception e) {
            System.err.println("Email thread starting failed: " + e.getMessage());
        }

        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateStatus(@PathVariable Long id, @RequestBody Map<String, String> request) {
        String status = request.get("status");
        if (status == null || status.trim().isEmpty()) {
            return ResponseEntity.badRequest().body("Status is required");
        }

        Optional<MembershipApplication> appOpt = membershipRepository.findById(id);
        if (appOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        MembershipApplication application = appOpt.get();
        application.setStatus(status);
        if ("Approved".equalsIgnoreCase(status) && (application.getMembershipId() == null || application.getMembershipId().trim().isEmpty())) {
            // Generate a default membership ID if status is approved but not provided
            application.setMembershipId("ZEE-MEM-" + (1000 + id));
        }
        application.setProcessedAt(LocalDateTime.now());

        MembershipApplication saved = membershipRepository.save(application);

        // Trigger email notification if approved
        if ("Approved".equalsIgnoreCase(status)) {
            try {
                new Thread(() -> emailService.sendApprovalEmail(saved)).start();
            } catch (Exception e) {
                System.err.println("Email thread starting failed: " + e.getMessage());
            }
        }

        return ResponseEntity.ok(saved);
    }

    private boolean isMembershipActive(MembershipApplication application) {
        if (!"Approved".equalsIgnoreCase(application.getStatus()) || application.getProcessedAt() == null) {
            return false;
        }
        
        LocalDateTime start = application.getProcessedAt();
        int months = 3;
        if ("6 Months".equalsIgnoreCase(application.getValidity())) {
            months = 6;
        } else if ("1 Year".equalsIgnoreCase(application.getValidity())) {
            months = 12;
        }
        
        LocalDateTime expirationDate = start.plusMonths(months);
        return LocalDateTime.now().isBefore(expirationDate);
    }
}
