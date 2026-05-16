-- ---------------------------------------------------------
-- AgriConnect Database Schema
-- Compatible with MySQL 8.x and H2 (MODE=MySQL)
-- Seed data is intentionally separated into seed-data.sql
-- ---------------------------------------------------------

DROP TABLE IF EXISTS critical_alerts;
DROP TABLE IF EXISTS expert_wallet_transactions;
DROP TABLE IF EXISTS consultation_reviews;
DROP TABLE IF EXISTS expert_consultations;
DROP TABLE IF EXISTS booking_slots;
DROP TABLE IF EXISTS wallet_transactions;
DROP TABLE IF EXISTS supply_chain_tokens;
DROP TABLE IF EXISTS price_history;
DROP TABLE IF EXISTS demand_forecast_cache;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS market_prices;
DROP TABLE IF EXISTS crop_master;
DROP TABLE IF EXISTS matchmaking_scores;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS advisories;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS bids;
DROP TABLE IF EXISTS produce_listings;
DROP TABLE IF EXISTS buyer_profiles;
DROP TABLE IF EXISTS farmer_profiles;
DROP TABLE IF EXISTS msp_rates;
DROP TABLE IF EXISTS crops;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    role VARCHAR(30) NOT NULL,
    verification_status VARCHAR(30) NOT NULL,
    specialisation VARCHAR(200),
    consultation_fee_30min DECIMAL(8, 2),
    consultation_fee_60min DECIMAL(8, 2),
    languages_spoken TEXT,
    total_sessions INT DEFAULT 0,
    avg_rating DECIMAL(3, 2) DEFAULT 0.00,
    aadhaar_hash VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    CONSTRAINT uk_users_email_role UNIQUE (email, role)
);

CREATE TABLE crops (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(100),
    CONSTRAINT uk_crops_name UNIQUE (name)
);

CREATE TABLE crop_master (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    crop_name VARCHAR(100) NOT NULL,
    season VARCHAR(20) NOT NULL,
    category VARCHAR(30) NOT NULL,
    avg_yield_per_acre INT,
    storage_life_days INT,
    cold_storage_required BOOLEAN DEFAULT FALSE,
    common_varieties TEXT,
    CONSTRAINT uk_crop_master_name UNIQUE (crop_name)
);

CREATE TABLE farmer_profiles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    village VARCHAR(100),
    district VARCHAR(100),
    state VARCHAR(100),
    lat DECIMAL(9, 6),
    lng DECIMAL(9, 6),
    land_acres DECIMAL(8, 2),
    bank_account_encrypted VARCHAR(500),
    aadhaar_hash VARCHAR(64),
    farmer_score DECIMAL(4, 2) DEFAULT 50.00,
    CONSTRAINT fk_farmer_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE buyer_profiles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    company_name VARCHAR(200),
    gstin VARCHAR(20),
    business_type VARCHAR(30),
    preferred_crops TEXT,
    preferred_districts TEXT,
    credit_limit DECIMAL(12, 2),
    CONSTRAINT uk_buyer_profiles_gstin UNIQUE (gstin),
    CONSTRAINT fk_buyer_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE produce_listings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farmer_id BIGINT NOT NULL,
    crop_name VARCHAR(100) NOT NULL,
    variety VARCHAR(100),
    quantity_kg DECIMAL(10, 2),
    available_from DATE,
    available_until DATE,
    asking_price_per_kg DECIMAL(8, 2),
    msp_price_per_kg DECIMAL(8, 2),
    quality_grade VARCHAR(5),
    description TEXT,
    photos TEXT,
    district VARCHAR(100),
    lat DECIMAL(9, 6),
    lng DECIMAL(9, 6),
    status VARCHAR(20) NOT NULL,
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_listing_farmer FOREIGN KEY (farmer_id) REFERENCES farmer_profiles(id) ON DELETE CASCADE
);

CREATE TABLE bids (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    listing_id BIGINT NOT NULL,
    buyer_id BIGINT NOT NULL,
    bid_price_per_kg DECIMAL(8, 2) NOT NULL,
    quantity_kg DECIMAL(10, 2) NOT NULL,
    bid_status VARCHAR(20) NOT NULL,
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    CONSTRAINT fk_bid_listing FOREIGN KEY (listing_id) REFERENCES produce_listings(id) ON DELETE CASCADE,
    CONSTRAINT fk_bid_buyer FOREIGN KEY (buyer_id) REFERENCES buyer_profiles(id) ON DELETE CASCADE
);

CREATE TABLE orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bid_id BIGINT NOT NULL,
    farmer_id BIGINT NOT NULL,
    buyer_id BIGINT NOT NULL,
    final_price_per_kg DECIMAL(8, 2) NOT NULL,
    quantity_kg DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    expected_delivery DATE,
    actual_delivery DATE,
    payment_status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_orders_bid UNIQUE (bid_id),
    CONSTRAINT fk_order_bid FOREIGN KEY (bid_id) REFERENCES bids(id) ON DELETE RESTRICT,
    CONSTRAINT fk_order_farmer FOREIGN KEY (farmer_id) REFERENCES farmer_profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_buyer FOREIGN KEY (buyer_id) REFERENCES buyer_profiles(id) ON DELETE CASCADE
);

CREATE TABLE booking_slots (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    provider_id BIGINT NOT NULL,
    slot_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    district VARCHAR(100),
    crop_focus VARCHAR(100),
    notes VARCHAR(255),
    slot_status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_booking_slot_provider UNIQUE (provider_id, slot_date, start_time),
    CONSTRAINT fk_booking_slot_provider FOREIGN KEY (provider_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE expert_consultations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    expert_id BIGINT NOT NULL,
    farmer_id BIGINT NOT NULL,
    slot_id BIGINT NOT NULL,
    crop_focus VARCHAR(100),
    farmer_district VARCHAR(100),
    duration_minutes INT NOT NULL,
    fee_amount DECIMAL(8, 2) NOT NULL,
    consultation_status VARCHAR(30) NOT NULL,
    payment_status VARCHAR(30) NOT NULL,
    razorpay_order_id VARCHAR(100),
    razorpay_payment_id VARCHAR(100),
    session_link VARCHAR(500),
    reminder_sent BOOLEAN DEFAULT FALSE,
    review_requested BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    CONSTRAINT uk_expert_consultation_slot UNIQUE (slot_id),
    CONSTRAINT fk_consultation_expert FOREIGN KEY (expert_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_consultation_farmer FOREIGN KEY (farmer_id) REFERENCES farmer_profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_consultation_slot FOREIGN KEY (slot_id) REFERENCES booking_slots(id) ON DELETE CASCADE
);

CREATE TABLE consultation_reviews (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    consultation_id BIGINT NOT NULL,
    rating INT NOT NULL,
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_consultation_review UNIQUE (consultation_id),
    CONSTRAINT fk_consultation_review_booking FOREIGN KEY (consultation_id) REFERENCES expert_consultations(id) ON DELETE CASCADE
);

CREATE TABLE expert_wallet_transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    expert_id BIGINT NOT NULL,
    consultation_id BIGINT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    gross_amount DECIMAL(10, 2) NOT NULL,
    platform_fee DECIMAL(10, 2) NOT NULL,
    net_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_expert_wallet_user FOREIGN KEY (expert_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_expert_wallet_consultation FOREIGN KEY (consultation_id) REFERENCES expert_consultations(id) ON DELETE CASCADE
);

CREATE TABLE advisories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    expert_id BIGINT NOT NULL,
    title VARCHAR(200),
    body TEXT,
    crop_name VARCHAR(100),
    advisory_type VARCHAR(30),
    severity VARCHAR(20),
    affected_districts TEXT,
    valid_until DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_advisory_expert FOREIGN KEY (expert_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE critical_alerts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    advisory_id BIGINT NOT NULL,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_critical_alert_advisory FOREIGN KEY (advisory_id) REFERENCES advisories(id) ON DELETE CASCADE
);

CREATE TABLE notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(200),
    body TEXT,
    type VARCHAR(50),
    is_read BOOLEAN DEFAULT FALSE,
    reference_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE matchmaking_scores (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farmer_id BIGINT NOT NULL,
    buyer_id BIGINT NOT NULL,
    score DECIMAL(5, 2),
    factors TEXT,
    computed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_match_farmer FOREIGN KEY (farmer_id) REFERENCES farmer_profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_match_buyer FOREIGN KEY (buyer_id) REFERENCES buyer_profiles(id) ON DELETE CASCADE
);

CREATE TABLE msp_rates (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    crop_name VARCHAR(100) NOT NULL,
    season VARCHAR(20) NOT NULL,
    year INT NOT NULL,
    msp_per_kg DECIMAL(8, 2) NOT NULL,
    announced_at DATE NOT NULL
);

CREATE TABLE market_prices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    crop_id BIGINT NOT NULL,
    msp DOUBLE NOT NULL,
    current_average_price DOUBLE NOT NULL,
    effective_date DATE NOT NULL,
    CONSTRAINT fk_market_price_crop FOREIGN KEY (crop_id) REFERENCES crops(id) ON DELETE CASCADE
);

CREATE TABLE audit_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    action VARCHAR(100),
    entity_type VARCHAR(100),
    entity_id BIGINT,
    old_value TEXT,
    new_value TEXT,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE wallet_transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farmer_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    commission_amount DECIMAL(12, 2) NOT NULL,
    net_amount DECIMAL(12, 2) NOT NULL,
    remarks VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_wallet_farmer FOREIGN KEY (farmer_id) REFERENCES farmer_profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_wallet_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE TABLE price_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    crop_name VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    accepted_price DECIMAL(8, 2) NOT NULL,
    price_date DATE NOT NULL,
    source VARCHAR(30) NOT NULL
);

CREATE TABLE demand_forecast_cache (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    report_json TEXT NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE supply_chain_tokens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(64) NOT NULL,
    order_id BIGINT NOT NULL,
    qr_image_path VARCHAR(500),
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    scan_count INT DEFAULT 0,
    CONSTRAINT uk_supply_chain_token UNIQUE (token),
    CONSTRAINT uk_supply_chain_order UNIQUE (order_id),
    CONSTRAINT fk_supply_chain_order FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE INDEX idx_farmer_lat_lng ON farmer_profiles(lat, lng);
CREATE INDEX idx_listing_lat_lng ON produce_listings(lat, lng);
CREATE INDEX idx_bid_listing_status ON bids(listing_id, bid_status);
CREATE INDEX idx_match_farmer_score ON matchmaking_scores(farmer_id, score);
CREATE INDEX idx_price_history_lookup ON price_history(crop_name, district, price_date);
CREATE INDEX idx_booking_slot_lookup ON booking_slots(slot_date, district, crop_focus, slot_status);
CREATE INDEX idx_expert_consultation_lookup ON expert_consultations(expert_id, consultation_status, payment_status);
