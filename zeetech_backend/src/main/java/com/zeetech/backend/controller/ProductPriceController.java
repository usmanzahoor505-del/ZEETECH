package com.zeetech.backend.controller;

import com.zeetech.backend.model.ProductPrice;
import com.zeetech.backend.repository.ProductPriceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/product-prices")
@CrossOrigin(origins = "*")
public class ProductPriceController {

    @Autowired
    private ProductPriceRepository productPriceRepository;

    @GetMapping
    public ResponseEntity<List<ProductPrice>> getAllPrices() {
        return ResponseEntity.ok(productPriceRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPriceById(@PathVariable String id) {
        Optional<ProductPrice> priceOpt = productPriceRepository.findById(id);
        if (priceOpt.isPresent()) {
            return ResponseEntity.ok(priceOpt.get());
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping
    public ResponseEntity<?> updateOrCreatePrice(@RequestBody Map<String, Object> request) {
        String id = (String) request.get("id");
        Object priceObj = request.get("price");
        Object originalPriceObj = request.get("originalPrice");

        if (id == null || priceObj == null || originalPriceObj == null) {
            return ResponseEntity.badRequest().body("Required fields: 'id', 'price', and 'originalPrice' are missing.");
        }

        int price = Integer.parseInt(priceObj.toString());
        int originalPrice = Integer.parseInt(originalPriceObj.toString());

        String name = (String) request.get("name");
        String desc = (String) request.get("desc");
        if (desc == null) {
            desc = (String) request.get("description");
        }
        String categoryId = (String) request.get("categoryId");

        ProductPrice productPrice = new ProductPrice(id, price, originalPrice, name, desc, categoryId);
        ProductPrice saved = productPriceRepository.save(productPrice);
        return ResponseEntity.ok(saved);
    }
}
