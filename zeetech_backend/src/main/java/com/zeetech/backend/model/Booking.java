package com.zeetech.backend.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "bookings")
public class Booking {

    @Id
    private String id; // String UUID to match client-side generated UUIDs

    @Column(name = "customer_name")
    private String customerName;

    @Column(name = "customer_phone")
    private String customerPhone;

    @Column(name = "customer_email")
    private String customerEmail;

    @Column(name = "customer_address", length = 500)
    private String customerAddress;

    @Column(name = "service_name")
    private String serviceName;

    @Column(length = 1000)
    private String message;

    private String status; // "Pending", "In Progress", "Completed", "Cancelled"

    @Column(name = "preferred_date")
    private String preferredDate;

    @Column(name = "preferred_time")
    private String preferredTime;

    @Column(name = "problem_image_path", length = 500)
    private String problemImagePath;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "rating")
    private Integer rating; // null if not rated yet

    @Column(name = "feedback_comment", length = 1000)
    private String feedbackComment;

    @Column(name = "assigned_worker")
    private String assignedWorker;

    @Column(name = "started_at")
    private LocalDateTime startedAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @Column(name = "work_summary", length = 1000)
    private String workSummary;

    // Constructors
    public Booking() {}

    public Booking(String id, String customerName, String customerPhone, String customerEmail, String customerAddress,
                   String serviceName, String message, String status, String preferredDate, String preferredTime, 
                   String problemImagePath, LocalDateTime createdAt) {
        this.id = id;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.customerEmail = customerEmail;
        this.customerAddress = customerAddress;
        this.serviceName = serviceName;
        this.message = message;
        this.status = status;
        this.preferredDate = preferredDate;
        this.preferredTime = preferredTime;
        this.problemImagePath = problemImagePath;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerAddress() {
        return customerAddress;
    }

    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
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

    public String getPreferredDate() {
        return preferredDate;
    }

    public void setPreferredDate(String preferredDate) {
        this.preferredDate = preferredDate;
    }

    public String getPreferredTime() {
        return preferredTime;
    }

    public void setPreferredTime(String preferredTime) {
        this.preferredTime = preferredTime;
    }

    public String getProblemImagePath() {
        return problemImagePath;
    }

    public void setProblemImagePath(String problemImagePath) {
        this.problemImagePath = problemImagePath;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getRating() {
        return rating;
    }

    public void setRating(Integer rating) {
        this.rating = rating;
    }

    public String getFeedbackComment() {
        return feedbackComment;
    }

    public void setFeedbackComment(String feedbackComment) {
        this.feedbackComment = feedbackComment;
    }

    public String getAssignedWorker() {
        return assignedWorker;
    }

    public void setAssignedWorker(String assignedWorker) {
        this.assignedWorker = assignedWorker;
    }

    public LocalDateTime getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(LocalDateTime startedAt) {
        this.startedAt = startedAt;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public String getWorkSummary() {
        return workSummary;
    }

    public void setWorkSummary(String workSummary) {
        this.workSummary = workSummary;
    }
}
