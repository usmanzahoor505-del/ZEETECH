package com.zeetech.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "membership_applications")
public class MembershipApplication {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Membership Plan Details
    @Column(nullable = false)
    private String category; // 'Domestic' or 'Commercial'

    @Column(name = "plan_name", nullable = false)
    private String planName; // 'Silver', 'Gold', 'Premium'

    @Column(nullable = false)
    private String discount; // '10%', '20%', '30%'

    @Column(nullable = false)
    private String validity; // '3 Months', '6 Months', '1 Year'

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private String status = "Pending"; // 'Pending', 'Approved', 'Rejected'

    // Applicant Information
    @Column(name = "full_name", nullable = false)
    private String fullName;

    @Column(name = "father_name", nullable = false)
    private String fatherName;

    @Column(nullable = false)
    private String cnic;

    @Column(nullable = false)
    private String dob;

    private String occupation;

    // Contact Information
    @Column(nullable = false)
    private String mobile;

    @Column(name = "alt_contact")
    private String altContact;

    private String email;

    @Column(nullable = false, length = 1000)
    private String address;

    @Column(name = "preferred_services", length = 1000)
    private String preferredServices;

    // For Official Use Only (Internal Admin Fields)
    @Column(name = "membership_id")
    private String membershipId; // e.g. ZEE-MEM-1001

    @Column(name = "initiated_by")
    private String initiatedBy;

    @Column(length = 1000)
    private String remarks;

    @Column(name = "officer_name")
    private String officerName;

    @Column(name = "officer_designation")
    private String officerDesignation;

    @Column(name = "officer_emp_id")
    private String officerEmpId;

    @Column(name = "processed_at")
    private LocalDateTime processedAt;

    // Constructors
    public MembershipApplication() {}

    public MembershipApplication(String category, String planName, String discount, String validity, 
                                 String fullName, String fatherName, String cnic, String dob, 
                                 String occupation, String mobile, String altContact, String email, 
                                 String address, String preferredServices, LocalDateTime createdAt) {
        this.category = category;
        this.planName = planName;
        this.discount = discount;
        this.validity = validity;
        this.fullName = fullName;
        this.fatherName = fatherName;
        this.cnic = cnic;
        this.dob = dob;
        this.occupation = occupation;
        this.mobile = mobile;
        this.altContact = altContact;
        this.email = email;
        this.address = address;
        this.preferredServices = preferredServices;
        this.createdAt = createdAt;
        this.status = "Pending";
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getPlanName() {
        return planName;
    }

    public void setPlanName(String planName) {
        this.planName = planName;
    }

    public String getDiscount() {
        return discount;
    }

    public void setDiscount(String discount) {
        this.discount = discount;
    }

    public String getValidity() {
        return validity;
    }

    public void setValidity(String validity) {
        this.validity = validity;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getFatherName() {
        return fatherName;
    }

    public void setFatherName(String fatherName) {
        this.fatherName = fatherName;
    }

    public String getCnic() {
        return cnic;
    }

    public void setCnic(String cnic) {
        this.cnic = cnic;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getAltContact() {
        return altContact;
    }

    public void setAltContact(String altContact) {
        this.altContact = altContact;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPreferredServices() {
        return preferredServices;
    }

    public void setPreferredServices(String preferredServices) {
        this.preferredServices = preferredServices;
    }

    public String getMembershipId() {
        return membershipId;
    }

    public void setMembershipId(String membershipId) {
        this.membershipId = membershipId;
    }

    public String getInitiatedBy() {
        return initiatedBy;
    }

    public void setInitiatedBy(String initiatedBy) {
        this.initiatedBy = initiatedBy;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getOfficerName() {
        return officerName;
    }

    public void setOfficerName(String officerName) {
        this.officerName = officerName;
    }

    public String getOfficerDesignation() {
        return officerDesignation;
    }

    public void setOfficerDesignation(String officerDesignation) {
        this.officerDesignation = officerDesignation;
    }

    public String getOfficerEmpId() {
        return officerEmpId;
    }

    public void setOfficerEmpId(String officerEmpId) {
        this.officerEmpId = officerEmpId;
    }

    public LocalDateTime getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(LocalDateTime processedAt) {
        this.processedAt = processedAt;
    }
}
