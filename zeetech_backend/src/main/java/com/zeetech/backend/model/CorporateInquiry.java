package com.zeetech.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "corporate_inquiries")
public class CorporateInquiry {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "business_type", nullable = false)
    private String businessType;

    @Column(name = "business_name", nullable = false)
    private String businessName;

    @Column(name = "rep_name", nullable = false)
    private String repName;

    @Column(name = "rep_number", nullable = false)
    private String repNumber;

    private String email;

    @Column(nullable = false)
    private String city;

    @Column(length = 2000)
    private String message;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "status", nullable = false)
    private String status = "Pending"; // "Pending", "Approved", "Completed", "Cancelled"

    // Constructors
    public CorporateInquiry() {}

    public CorporateInquiry(String businessType, String businessName, String repName, String repNumber, 
                            String email, String city, String message, LocalDateTime createdAt) {
        this.businessType = businessType;
        this.businessName = businessName;
        this.repName = repName;
        this.repNumber = repNumber;
        this.email = email;
        this.city = city;
        this.message = message;
        this.status = "Pending";
        this.createdAt = createdAt;
    }

    public CorporateInquiry(String businessType, String businessName, String repName, String repNumber, 
                            String email, String city, String message, String status, LocalDateTime createdAt) {
        this.businessType = businessType;
        this.businessName = businessName;
        this.repName = repName;
        this.repNumber = repNumber;
        this.email = email;
        this.city = city;
        this.message = message;
        this.status = status != null ? status : "Pending";
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getBusinessType() {
        return businessType;
    }

    public void setBusinessType(String businessType) {
        this.businessType = businessType;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getRepName() {
        return repName;
    }

    public void setRepName(String repName) {
        this.repName = repName;
    }

    public String getRepNumber() {
        return repNumber;
    }

    public void setRepNumber(String repNumber) {
        this.repNumber = repNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
