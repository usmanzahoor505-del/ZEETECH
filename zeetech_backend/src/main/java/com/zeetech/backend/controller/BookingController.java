package com.zeetech.backend.controller;

import com.zeetech.backend.model.Booking;
import com.zeetech.backend.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    @Autowired
    private BookingRepository bookingRepository;

    @GetMapping
    public ResponseEntity<List<Booking>> getBookings(@RequestParam(required = false) String customerName) {
        if (customerName != null && !customerName.trim().isEmpty()) {
            return ResponseEntity.ok(bookingRepository.findByCustomerName(customerName));
        }
        return ResponseEntity.ok(bookingRepository.findAll());
    }

    @PostMapping
    public ResponseEntity<?> createBooking(@RequestBody Map<String, String> request) {
        String id = request.get("id");
        String customerName = request.get("customerName");
        String customerPhone = request.get("customerPhone");
        String customerEmail = request.get("customerEmail");
        String customerAddress = request.get("customerAddress");
        String serviceName = request.get("serviceName");
        String message = request.get("message");
        String status = request.get("status");
        String preferredDate = request.get("preferredDate");
        String preferredTime = request.get("preferredTime");
        String problemImagePath = request.get("problemImagePath");

        if (id == null || serviceName == null || customerName == null) {
            return ResponseEntity.badRequest().body("ID, Service Name, and Customer Name are required");
        }

        Booking booking = new Booking(id, customerName, customerPhone, customerEmail, customerAddress,
                                      serviceName, message, status != null ? status : "Pending", 
                                      preferredDate, preferredTime, 
                                      problemImagePath != null ? problemImagePath : "", 
                                      LocalDateTime.now());
        
        Booking saved = bookingRepository.save(booking);
        return ResponseEntity.ok(saved);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateStatus(@PathVariable String id, @RequestBody Map<String, String> request) {
        String status = request.get("status");
        if (status == null) {
            return ResponseEntity.badRequest().body("Status is required");
        }

        Optional<Booking> bookingOpt = bookingRepository.findById(id);
        if (bookingOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Booking booking = bookingOpt.get();
        booking.setStatus(status);
        bookingRepository.save(booking);

        return ResponseEntity.ok(booking);
    }

    @PutMapping("/{id}/feedback")
    public ResponseEntity<?> submitFeedback(@PathVariable String id, @RequestBody Map<String, Object> request) {
        Object ratingObj = request.get("rating");
        String feedbackComment = (String) request.get("feedbackComment");

        if (ratingObj == null) {
            return ResponseEntity.badRequest().body("Rating is required");
        }

        Integer rating = null;
        if (ratingObj instanceof Number) {
            rating = ((Number) ratingObj).intValue();
        } else if (ratingObj instanceof String) {
            try {
                rating = Integer.parseInt((String) ratingObj);
            } catch (NumberFormatException e) {
                return ResponseEntity.badRequest().body("Rating must be a valid integer");
            }
        }

        if (rating == null || rating < 1 || rating > 5) {
            return ResponseEntity.badRequest().body("Rating must be between 1 and 5");
        }

        Optional<Booking> bookingOpt = bookingRepository.findById(id);
        if (bookingOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Booking booking = bookingOpt.get();
        booking.setRating(rating);
        booking.setFeedbackComment(feedbackComment != null ? feedbackComment : "");
        bookingRepository.save(booking);

        return ResponseEntity.ok(booking);
    }
}
