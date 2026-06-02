package com.zeetech.backend.controller;

import com.zeetech.backend.model.CorporateInquiry;
import com.zeetech.backend.repository.CorporateInquiryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/corporate-inquiries")
@CrossOrigin(origins = "*")
public class CorporateInquiryController {

    @Autowired
    private CorporateInquiryRepository inquiryRepository;

    @GetMapping
    public ResponseEntity<List<CorporateInquiry>> getAllInquiries(
            @RequestParam(required = false) String email,
            @RequestParam(required = false) String repNumber) {
        
        if (email != null && !email.trim().isEmpty()) {
            return ResponseEntity.ok(inquiryRepository.findByEmailOrRepNumberOrderByIdDesc(email, email));
        }
        if (repNumber != null && !repNumber.trim().isEmpty()) {
            return ResponseEntity.ok(inquiryRepository.findByEmailOrRepNumberOrderByIdDesc(repNumber, repNumber));
        }
        
        return ResponseEntity.ok(inquiryRepository.findAll(Sort.by(Sort.Direction.DESC, "id")));
    }

    @PostMapping
    public ResponseEntity<?> submitInquiry(@RequestBody Map<String, String> request) {
        String businessType = request.get("businessType");
        String businessName = request.get("businessName");
        String repName = request.get("repName");
        String repNumber = request.get("repNumber");
        String email = request.get("email");
        String city = request.get("city");
        String message = request.get("message");

        if (businessType == null || businessName == null || repName == null || repNumber == null || city == null) {
            return ResponseEntity.badRequest().body("Required fields are missing");
        }

        CorporateInquiry inquiry = new CorporateInquiry(
            businessType,
            businessName,
            repName,
            repNumber,
            email != null ? email : "",
            city,
            message != null ? message : "",
            LocalDateTime.now()
        );

        CorporateInquiry saved = inquiryRepository.save(inquiry);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateStatus(@PathVariable Long id, @RequestBody Map<String, String> request) {
        String status = request.get("status");
        if (status == null) {
            return ResponseEntity.badRequest().body("Status is required");
        }

        java.util.Optional<CorporateInquiry> inquiryOpt = inquiryRepository.findById(id);
        if (inquiryOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        CorporateInquiry inquiry = inquiryOpt.get();
        inquiry.setStatus(status);
        inquiryRepository.save(inquiry);

        return ResponseEntity.ok(inquiry);
    }
}
