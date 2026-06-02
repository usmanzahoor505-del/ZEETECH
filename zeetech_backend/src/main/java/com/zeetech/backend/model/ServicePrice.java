package com.zeetech.backend.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Column;

@Entity
@Table(name = "service_prices")
public class ServicePrice {

    @Id
    private String id; // e.g. "ac_1" or "service_custom_1718293849"
    private int price;
    private int originalPrice;
    
    private String name;
    
    @Column(name = "description", length = 1000)
    private String description;
    
    private String categoryId;

    @Column(name = "on_sale", nullable = false, columnDefinition = "BIT DEFAULT 0")
    private boolean onSale;

    @Column(name = "sale_percent", nullable = false, columnDefinition = "INT DEFAULT 0")
    private int salePercent;

    public ServicePrice() {
    }

    public ServicePrice(String id, int price, int originalPrice) {
        this.id = id;
        this.price = price;
        this.originalPrice = originalPrice;
    }

    public ServicePrice(String id, int price, int originalPrice, String name, String description, String categoryId) {
        this.id = id;
        this.price = price;
        this.originalPrice = originalPrice;
        this.name = name;
        this.description = description;
        this.categoryId = categoryId;
        this.onSale = false;
        this.salePercent = 0;
    }

    public ServicePrice(String id, int price, int originalPrice, String name, String description, String categoryId, boolean onSale, int salePercent) {
        this.id = id;
        this.price = price;
        this.originalPrice = originalPrice;
        this.name = name;
        this.description = description;
        this.categoryId = categoryId;
        this.onSale = onSale;
        this.salePercent = salePercent;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(int originalPrice) {
        this.originalPrice = originalPrice;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public boolean getOnSale() {
        return onSale;
    }

    public void setOnSale(boolean onSale) {
        this.onSale = onSale;
    }

    public int getSalePercent() {
        return salePercent;
    }

    public void setSalePercent(int salePercent) {
        this.salePercent = salePercent;
    }
}
