package com.zeetech.backend.repository;

import com.zeetech.backend.model.ProductPrice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductPriceRepository extends JpaRepository<ProductPrice, String> {
}
