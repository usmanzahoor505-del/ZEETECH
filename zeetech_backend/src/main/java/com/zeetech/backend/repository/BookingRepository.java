package com.zeetech.backend.repository;

import com.zeetech.backend.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, String> {
    List<Booking> findByCustomerName(String customerName);
    List<Booking> findByAssignedWorker(String assignedWorker);
}
