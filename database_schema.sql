-- ==========================================
-- ZEETECH Technical Services Database Schema
-- Generated on: 2026-06-04
-- ==========================================

-- 1. users Table (Users, Admins, and Technicians)
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(255),
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(255), -- 'USER', 'ADMIN', or 'TECHNICIAN'
    specialty VARCHAR(255) -- e.g., 'AC Repair' for technicians
);

-- 2. bookings Table (Services Orders and Bookings)
CREATE TABLE bookings (
    id VARCHAR(255) PRIMARY KEY, -- Client-side generated unique UUID
    customer_name VARCHAR(255),
    customer_phone VARCHAR(255),
    customer_email VARCHAR(255),
    customer_address VARCHAR(500),
    service_name VARCHAR(255),
    message VARCHAR(1000), -- Items summary, TID, and payment screenshot reference
    status VARCHAR(255), -- 'Pending', 'In Progress', 'Completed', 'Cancelled'
    preferred_date VARCHAR(255),
    preferred_time VARCHAR(255),
    problem_image_path VARCHAR(500),
    created_at DATETIME,
    rating INT,
    feedback_comment VARCHAR(1000),
    assigned_worker VARCHAR(255), -- Assigned Technician details
    started_at DATETIME,
    completed_at DATETIME,
    work_summary VARCHAR(1000)
);

-- 3. corporate_inquiries Table (B2B Business Inquiries)
CREATE TABLE corporate_inquiries (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    business_type VARCHAR(255) NOT NULL,
    business_name VARCHAR(255) NOT NULL,
    rep_name VARCHAR(255) NOT NULL,
    rep_number VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    city VARCHAR(255) NOT NULL,
    message VARCHAR(2000),
    created_at DATETIME,
    status VARCHAR(255) NOT NULL DEFAULT 'Pending' -- 'Pending', 'Approved', 'Completed'
);

-- 4. membership_applications Table (Premium Memberships)
CREATE TABLE membership_applications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(255) NOT NULL, -- 'Domestic' or 'Commercial'
    plan_name VARCHAR(255) NOT NULL, -- 'Silver', 'Gold', 'Premium'
    discount VARCHAR(255) NOT NULL,
    validity VARCHAR(255) NOT NULL, -- e.g., '3 Months', '1 Year'
    created_at DATETIME,
    status VARCHAR(255) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Approved', 'Rejected'
    full_name VARCHAR(255) NOT NULL,
    father_name VARCHAR(255) NOT NULL,
    cnic VARCHAR(255) NOT NULL,
    dob VARCHAR(255) NOT NULL,
    occupation VARCHAR(255),
    mobile VARCHAR(255) NOT NULL,
    alt_contact VARCHAR(255),
    email VARCHAR(255),
    address VARCHAR(1000) NOT NULL,
    preferred_services VARCHAR(1000),
    membership_id VARCHAR(255),
    initiated_by VARCHAR(255),
    remarks VARCHAR(1000),
    officer_name VARCHAR(255),
    officer_designation VARCHAR(255),
    officer_emp_id VARCHAR(255),
    processed_at DATETIME
);

-- 5. service_prices Table (Services Rates and Discount Toggles)
CREATE TABLE service_prices (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    price INT,
    original_price INT,
    description VARCHAR(1000),
    category_id VARCHAR(255),
    on_sale BIT NOT NULL DEFAULT 0,
    sale_percent INT NOT NULL DEFAULT 0
);

-- 6. product_prices Table (Store Hardware and Products)
CREATE TABLE product_prices (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    price INT,
    original_price INT,
    description VARCHAR(1000),
    category_id VARCHAR(255)
);
