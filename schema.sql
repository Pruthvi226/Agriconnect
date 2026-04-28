-- ---------------------------------------------------------
-- AgriConnect Database Schema (MySQL 8.x)
-- Engine: InnoDB, Charset: UTF8MB4
-- ---------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS msp_rates;
DROP TABLE IF EXISTS matchmaking_scores;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS advisories;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS bids;
DROP TABLE IF EXISTS produce_listings;
DROP TABLE IF EXISTS buyer_profiles;
DROP TABLE IF EXISTS farmer_profiles;
DROP TABLE IF EXISTS users;

DROP PROCEDURE IF EXISTS sp_compute_farmer_score;
DROP PROCEDURE IF EXISTS sp_get_nearby_listings;

SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------
-- TABLES
-- ---------------------------------------------------------

CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    password_hash VARCHAR(255),
    phone VARCHAR(15),
    role ENUM('FARMER','BUYER','AGRI_EXPERT','ADMIN'),
    verification_status ENUM('PENDING','VERIFIED','REJECTED'),
    aadhaar_hash VARCHAR(64),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE farmer_profiles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    village VARCHAR(100),
    district VARCHAR(100),
    state VARCHAR(100),
    lat DECIMAL(9,6),
    lng DECIMAL(9,6),
    land_acres DECIMAL(8,2),
    bank_account_encrypted VARCHAR(500),
    farmer_score DECIMAL(4,2) DEFAULT 50.00,
    CONSTRAINT fk_farmer_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE INDEX idx_farmer_lat_lng ON farmer_profiles(lat, lng);

CREATE TABLE buyer_profiles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    company_name VARCHAR(200),
    gstin VARCHAR(20) UNIQUE,
    business_type ENUM('RETAILER','WHOLESALER','EXPORTER','PROCESSOR'),
    preferred_crops JSON,
    preferred_districts JSON,
    credit_limit DECIMAL(12,2),
    CONSTRAINT fk_buyer_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE produce_listings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farmer_id BIGINT,
    crop_name VARCHAR(100),
    variety VARCHAR(100),
    quantity_kg DECIMAL(10,2),
    available_from DATE,
    available_until DATE,
    asking_price_per_kg DECIMAL(8,2),
    msp_price_per_kg DECIMAL(8,2),
    quality_grade ENUM('A','B','C'),
    description TEXT,
    photos JSON,
    district VARCHAR(100),
    lat DECIMAL(9,6),
    lng DECIMAL(9,6),
    status ENUM('ACTIVE','BIDDING','SOLD','EXPIRED','WITHDRAWN'),
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_listing_farmer FOREIGN KEY (farmer_id) REFERENCES farmer_profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE INDEX idx_listing_lat_lng ON produce_listings(lat, lng);
CREATE FULLTEXT INDEX idx_listing_ft ON produce_listings(crop_name, description);

CREATE TABLE bids (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    listing_id BIGINT,
    buyer_id BIGINT,
    bid_price_per_kg DECIMAL(8,2),
    quantity_kg DECIMAL(10,2),
    bid_status ENUM('PENDING','ACCEPTED','REJECTED','WITHDRAWN','EXPIRED'),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    CONSTRAINT fk_bid_listing FOREIGN KEY (listing_id) REFERENCES produce_listings(id) ON DELETE CASCADE,
    CONSTRAINT fk_bid_buyer FOREIGN KEY (buyer_id) REFERENCES buyer_profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE INDEX idx_bid_listing_status ON bids(listing_id, bid_status);

CREATE TABLE orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bid_id BIGINT UNIQUE,
    farmer_id BIGINT,
    buyer_id BIGINT,
    final_price_per_kg DECIMAL(8,2),
    quantity_kg DECIMAL(10,2),
    total_amount DECIMAL(12,2),
    order_status ENUM('CONFIRMED','IN_TRANSIT','DELIVERED','DISPUTED','CANCELLED'),
    expected_delivery DATE,
    actual_delivery DATE,
    payment_status ENUM('PENDING','PAID','REFUNDED'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_bid FOREIGN KEY (bid_id) REFERENCES bids(id) ON DELETE RESTRICT,
    CONSTRAINT fk_order_farmer FOREIGN KEY (farmer_id) REFERENCES farmer_profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_order_buyer FOREIGN KEY (buyer_id) REFERENCES buyer_profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE advisories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    expert_id BIGINT,
    title VARCHAR(200),
    body TEXT,
    crop_name VARCHAR(100),
    advisory_type ENUM('PEST','DISEASE','WEATHER','MARKET','TECHNIQUE'),
    severity ENUM('INFO','WARNING','CRITICAL'),
    affected_districts JSON,
    valid_until DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_advisory_expert FOREIGN KEY (expert_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    title VARCHAR(200),
    body TEXT,
    type VARCHAR(50),
    is_read BOOLEAN DEFAULT FALSE,
    reference_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE matchmaking_scores (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farmer_id BIGINT,
    buyer_id BIGINT,
    score DECIMAL(5,2),
    factors JSON,
    computed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_match_farmer FOREIGN KEY (farmer_id) REFERENCES farmer_profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_match_buyer FOREIGN KEY (buyer_id) REFERENCES buyer_profiles(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE INDEX idx_farmer_score ON matchmaking_scores(farmer_id, score DESC);

CREATE TABLE msp_rates (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    crop_name VARCHAR(100),
    season ENUM('KHARIF','RABI','ZAID'),
    year YEAR,
    msp_per_kg DECIMAL(8,2),
    announced_at DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ---------------------------------------------------------
-- STORED PROCEDURES
-- ---------------------------------------------------------

DELIMITER $$

-- 1. sp_compute_farmer_score
CREATE PROCEDURE sp_compute_farmer_score(IN p_farmer_id BIGINT)
BEGIN
    DECLARE v_total_orders INT DEFAULT 0;
    DECLARE v_on_time_orders INT DEFAULT 0;
    DECLARE v_disputed_orders INT DEFAULT 0;
    
    DECLARE v_on_time_score DECIMAL(5,2) DEFAULT 0.00;
    DECLARE v_quality_score DECIMAL(5,2) DEFAULT 30.00;
    DECLARE v_volume_score DECIMAL(5,2) DEFAULT 0.00;
    DECLARE v_profile_score DECIMAL(5,2) DEFAULT 0.00;
    DECLARE v_final_score DECIMAL(5,2) DEFAULT 0.00;

    -- Fetch order statistics
    SELECT 
        COUNT(*), 
        COALESCE(SUM(IF(actual_delivery <= expected_delivery, 1, 0)), 0),
        COALESCE(SUM(IF(order_status = 'DISPUTED', 1, 0)), 0)
    INTO v_total_orders, v_on_time_orders, v_disputed_orders
    FROM orders 
    WHERE farmer_id = p_farmer_id AND order_status IN ('DELIVERED', 'DISPUTED');

    -- Compute dynamic scores based on weights
    IF v_total_orders > 0 THEN
        SET v_on_time_score = (v_on_time_orders / v_total_orders) * 40.0;
        SET v_quality_score = ((v_total_orders - v_disputed_orders) / v_total_orders) * 30.0;
        SET v_volume_score = IF(v_total_orders >= 10, 20.0, (v_total_orders / 10.0) * 20.0);
    ELSE
        -- Baseline defaults for new farmers
        SET v_on_time_score = 20.0;
        SET v_quality_score = 15.0;
        SET v_volume_score = 5.0;
    END IF;

    -- Compute profile completeness
    SELECT IF(land_acres IS NOT NULL AND bank_account_encrypted IS NOT NULL, 10.0, 5.0)
    INTO v_profile_score
    FROM farmer_profiles WHERE id = p_farmer_id;

    -- Calculate final
    SET v_final_score = v_on_time_score + v_quality_score + v_volume_score + v_profile_score;
    
    -- Cap at 100
    IF v_final_score > 100.0 THEN SET v_final_score = 100.0; END IF;

    UPDATE farmer_profiles 
    SET farmer_score = v_final_score 
    WHERE id = p_farmer_id;
END$$

-- 2. sp_get_nearby_listings
CREATE PROCEDURE sp_get_nearby_listings(
    IN p_buyer_lat DECIMAL(9,6), 
    IN p_buyer_lng DECIMAL(9,6), 
    IN p_radius_km INT, 
    IN p_crop VARCHAR(100)
)
BEGIN
    SELECT 
        pl.id AS listing_id,
        pl.farmer_id,
        pl.crop_name,
        pl.variety,
        pl.quantity_kg,
        pl.asking_price_per_kg,
        (SELECT msp_per_kg FROM msp_rates m WHERE m.crop_name = pl.crop_name ORDER BY announced_at DESC LIMIT 1) AS current_msp,
        pl.status,
        -- Haversine formula for distance in KM
        (6371 * acos(
            cos(radians(p_buyer_lat)) 
            * cos(radians(pl.lat)) 
            * cos(radians(pl.lng) - radians(p_buyer_lng)) 
            + sin(radians(p_buyer_lat)) * sin(radians(pl.lat))
        )) AS distance_km
    FROM produce_listings pl
    WHERE pl.crop_name = p_crop
      AND pl.status = 'ACTIVE'
    HAVING distance_km <= p_radius_km
    ORDER BY distance_km ASC;
END$$

DELIMITER ;


-- ---------------------------------------------------------
-- SEED DATA
-- ---------------------------------------------------------

-- 1. Users
INSERT INTO users (name, email, password_hash, phone, role, verification_status) VALUES
('Ramesh Kumar', 'ramesh@example.com', 'hash1', '9876543210', 'FARMER', 'VERIFIED'),
('Suresh Singh', 'suresh@example.com', 'hash2', '9876543211', 'FARMER', 'VERIFIED'),
('Amit Patel', 'amit@example.com', 'hash3', '9876543212', 'FARMER', 'PENDING'),
('Vikram Yadav', 'vikram@example.com', 'hash4', '9876543213', 'FARMER', 'VERIFIED'),
('Sunil Sharma', 'sunil@example.com', 'hash5', '9876543214', 'FARMER', 'VERIFIED'),
('AgriFoods Ltd', 'contact@agrifoods.com', 'hash6', '8876543210', 'BUYER', 'VERIFIED'),
('FreshFarm Corp', 'sales@freshfarm.com', 'hash7', '8876543211', 'BUYER', 'VERIFIED'),
('GreenOrg Inc', 'info@greenorg.com', 'hash8', '8876543212', 'BUYER', 'PENDING'),
('Dr. Ravi Verma', 'ravi.v@kvk.edu', 'hash9', '7876543210', 'AGRI_EXPERT', 'VERIFIED'),
('Prof. Anita Rao', 'anita.r@uni.edu', 'hash10', '7876543211', 'AGRI_EXPERT', 'VERIFIED');

-- 2. Farmer Profiles
INSERT INTO farmer_profiles (user_id, village, district, state, lat, lng, land_acres, farmer_score) VALUES
(1, 'Palampur', 'Kangra', 'Himachal Pradesh', 32.1109, 76.5363, 12.5, 85.0),
(2, 'Bardoli', 'Surat', 'Gujarat', 21.1213, 73.1119, 25.0, 92.5),
(3, 'Baramati', 'Pune', 'Maharashtra', 18.1523, 74.5768, 5.0, 50.0),
(4, 'Moga', 'Moga', 'Punjab', 30.8165, 75.1717, 40.0, 88.0),
(5, 'Hassan', 'Hassan', 'Karnataka', 13.0072, 76.1016, 15.0, 75.0);

-- 3. Buyer Profiles
INSERT INTO buyer_profiles (user_id, company_name, gstin, business_type, credit_limit) VALUES
(6, 'AgriFoods Processing Ltd', '27AABCU9603R1ZM', 'PROCESSOR', 500000.00),
(7, 'FreshFarm Retailers', '07AABCU9603R1ZN', 'RETAILER', 200000.00),
(8, 'GreenOrg Exporters', '24AABCU9603R1ZO', 'EXPORTER', 1000000.00);

-- 4. MSP Rates
INSERT INTO msp_rates (crop_name, season, year, msp_per_kg, announced_at) VALUES
('Wheat', 'RABI', 2024, 22.75, '2023-10-15'),
('Rice (Paddy)', 'KHARIF', 2024, 21.83, '2024-06-01'),
('Cotton', 'KHARIF', 2024, 66.20, '2024-06-05');

-- 5. Produce Listings
INSERT INTO produce_listings (farmer_id, crop_name, variety, quantity_kg, asking_price_per_kg, msp_price_per_kg, district, lat, lng, status) VALUES
(1, 'Wheat', 'Sharbati', 5000.00, 25.00, 22.75, 'Kangra', 32.1109, 76.5363, 'ACTIVE'),
(1, 'Rice (Paddy)', 'Basmati', 2000.00, 35.00, 21.83, 'Kangra', 32.1109, 76.5363, 'ACTIVE'),
(2, 'Cotton', 'BT Cotton', 8000.00, 70.00, 66.20, 'Surat', 21.1213, 73.1119, 'ACTIVE'),
(2, 'Wheat', 'Lok-1', 4000.00, 23.50, 22.75, 'Surat', 21.1213, 73.1119, 'ACTIVE'),
(3, 'Rice (Paddy)', 'Indrayani', 3000.00, 30.00, 21.83, 'Pune', 18.1523, 74.5768, 'BIDDING'),
(4, 'Wheat', 'HD-2967', 15000.00, 22.00, 22.75, 'Moga', 30.8165, 75.1717, 'ACTIVE'),
(4, 'Cotton', 'Desi', 5000.00, 65.00, 66.20, 'Moga', 30.8165, 75.1717, 'ACTIVE'),
(5, 'Rice (Paddy)', 'Sona Masoori', 6000.00, 28.00, 21.83, 'Hassan', 13.0072, 76.1016, 'ACTIVE'),
(5, 'Maize', 'Hybrid', 4000.00, 18.00, 19.60, 'Hassan', 13.0072, 76.1016, 'ACTIVE'),
(3, 'Onion', 'Nashik Red', 2000.00, 15.00, NULL, 'Pune', 18.1523, 74.5768, 'ACTIVE');

-- 6. Bids
INSERT INTO bids (listing_id, buyer_id, bid_price_per_kg, quantity_kg, bid_status) VALUES
(1, 1, 24.50, 5000.00, 'PENDING'),
(1, 2, 25.00, 2000.00, 'ACCEPTED'),
(3, 3, 68.00, 8000.00, 'PENDING'),
(5, 1, 31.00, 3000.00, 'PENDING'),
(6, 2, 22.50, 5000.00, 'PENDING');
