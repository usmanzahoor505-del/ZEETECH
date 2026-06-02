package com.zeetech.backend.repository;

import com.zeetech.backend.model.ServicePrice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServicePriceRepository extends JpaRepository<ServicePrice, String> {
}
