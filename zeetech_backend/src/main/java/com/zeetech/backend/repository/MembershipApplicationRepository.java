package com.zeetech.backend.repository;

import com.zeetech.backend.model.MembershipApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MembershipApplicationRepository extends JpaRepository<MembershipApplication, Long> {
    List<MembershipApplication> findByEmailOrMobileOrderByIdDesc(String email, String mobile);
    List<MembershipApplication> findByCnic(String cnic);
}
