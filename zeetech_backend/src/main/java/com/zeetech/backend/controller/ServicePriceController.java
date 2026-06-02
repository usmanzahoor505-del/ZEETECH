package com.zeetech.backend.controller;

import com.zeetech.backend.model.ServicePrice;
import com.zeetech.backend.repository.ServicePriceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/service-prices")
@CrossOrigin(origins = "*")
public class ServicePriceController {

    @Autowired
    private ServicePriceRepository servicePriceRepository;

    @GetMapping
    public ResponseEntity<List<ServicePrice>> getAllPrices() {
        return ResponseEntity.ok(servicePriceRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPriceById(@PathVariable String id) {
        Optional<ServicePrice> priceOpt = servicePriceRepository.findById(id);
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

        Object onSaleObj = request.get("onSale");
        boolean onSale = false;
        if (onSaleObj != null) {
            onSale = Boolean.parseBoolean(onSaleObj.toString());
        }

        Object salePercentObj = request.get("salePercent");
        int salePercent = 0;
        if (salePercentObj != null) {
            salePercent = Integer.parseInt(salePercentObj.toString());
        }

        ServicePrice servicePrice = new ServicePrice(id, price, originalPrice, name, desc, categoryId, onSale, salePercent);
        ServicePrice saved = servicePriceRepository.save(servicePrice);
        return ResponseEntity.ok(saved);
    }
}
