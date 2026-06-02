package com.zeetech.backend.repository;

import com.zeetech.backend.model.CorporateInquiry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CorporateInquiryRepository extends JpaRepository<CorporateInquiry, Long> {
    List<CorporateInquiry> findByEmailOrRepNumberOrderByIdDesc(String email, String repNumber);
}
