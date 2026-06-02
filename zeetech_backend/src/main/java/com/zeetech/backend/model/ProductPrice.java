package com.zeetech.backend.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Column;

@Entity
@Table(name = "product_prices")
public class ProductPrice {

    @Id
    private String id; // e.g. "ac_products_split_ac_1_ton__gree_" or "product_custom_1718293849"
    private int price;
    private int originalPrice;
    
    private String name;
    
    @Column(name = "description", length = 1000)
    private String description;
    
    private String categoryId;

    public ProductPrice() {
    }

    public ProductPrice(String id, int price, int originalPrice) {
        this.id = id;
        this.price = price;
        this.originalPrice = originalPrice;
    }

    public ProductPrice(String id, int price, int originalPrice, String name, String description, String categoryId) {
        this.id = id;
        this.price = price;
        this.originalPrice = originalPrice;
        this.name = name;
        this.description = description;
        this.categoryId = categoryId;
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
}
