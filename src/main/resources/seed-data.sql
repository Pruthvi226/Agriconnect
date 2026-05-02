-- ---------------------------------------------------------
-- AgriConnect Seed Data
-- Password placeholders are replaced with BCrypt hashes at startup.
-- Default admin credentials: admin@agriconnect.in / Admin@2024!
-- ---------------------------------------------------------

INSERT INTO users (id, name, email, password_hash, phone, role, verification_status) VALUES
(1, 'Ramesh Kumar', 'ramesh@example.com', '{{bcrypt:Farmer@2024!}}', '9876543210', 'FARMER', 'VERIFIED'),
(2, 'Suresh Singh', 'suresh@example.com', '{{bcrypt:Farmer@2024!}}', '9876543211', 'FARMER', 'VERIFIED'),
(3, 'Amit Patel', 'amit@example.com', '{{bcrypt:Farmer@2024!}}', '9876543212', 'FARMER', 'PENDING'),
(4, 'Vikram Yadav', 'vikram@example.com', '{{bcrypt:Farmer@2024!}}', '9876543213', 'FARMER', 'VERIFIED'),
(5, 'Sunil Sharma', 'sunil@example.com', '{{bcrypt:Farmer@2024!}}', '9876543214', 'FARMER', 'VERIFIED'),
(6, 'AgriFoods Ltd', 'contact@agrifoods.com', '{{bcrypt:Buyer@2024!}}', '8876543210', 'BUYER', 'VERIFIED'),
(7, 'FreshFarm Corp', 'sales@freshfarm.com', '{{bcrypt:Buyer@2024!}}', '8876543211', 'BUYER', 'VERIFIED'),
(8, 'GreenOrg Inc', 'info@greenorg.com', '{{bcrypt:Buyer@2024!}}', '8876543212', 'BUYER', 'PENDING'),
(9, 'Dr. Ravi Verma', 'ravi.v@kvk.edu', '{{bcrypt:Expert@2024!}}', '7876543210', 'AGRI_EXPERT', 'VERIFIED'),
(10, 'Prof. Anita Rao', 'anita.r@uni.edu', '{{bcrypt:Expert@2024!}}', '7876543211', 'AGRI_EXPERT', 'VERIFIED'),
(11, 'AgriConnect Admin', 'admin@agriconnect.in', '{{bcrypt:Admin@2024!}}', '7000000000', 'ADMIN', 'VERIFIED');

UPDATE users
SET password_hash = '$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lnm.'
WHERE email LIKE '%@example.com'
   OR email LIKE '%@agrifoods.com'
   OR email LIKE '%@freshfarm.com'
   OR email LIKE '%@greenorg.com'
   OR email LIKE '%@kvk.edu'
   OR email LIKE '%@uni.edu';

INSERT INTO crops (id, name, category) VALUES
(1, 'Wheat', 'Cereals'),
(2, 'Rice (Paddy)', 'Cereals'),
(3, 'Cotton', 'Cash Crop'),
(4, 'Maize', 'Cereals'),
(5, 'Onion', 'Vegetables'),
(6, 'Tomato', 'Vegetables'),
(7, 'Soybean', 'Oilseed');

INSERT INTO crop_master (id, crop_name, season, category, avg_yield_per_acre, storage_life_days, cold_storage_required, common_varieties) VALUES
(1, 'Wheat', 'RABI', 'CEREAL', 1800, 365, FALSE, '["Sharbati","HD-2967","Lok-1","Raj-4120"]'),
(2, 'Rice (Paddy)', 'KHARIF', 'CEREAL', 1400, 180, FALSE, '["Basmati","Indrayani","Sona Masoori","BPT-5204"]'),
(3, 'Cotton', 'KHARIF', 'FIBER', 500, 365, FALSE, '["BT Cotton","Desi","H-6","LRA-5166"]'),
(4, 'Maize', 'KHARIF', 'CEREAL', 2200, 90, FALSE, '["Hybrid","Ganga-5","Vijay","Shaktiman-1"]'),
(5, 'Onion', 'RABI', 'VEGETABLE', 8000, 60, TRUE, '["Nashik Red","White Onion","Agrifound Dark Red"]'),
(6, 'Tomato', 'YEAR_ROUND', 'VEGETABLE', 12000, 14, TRUE, '["Hybrid","Cherry","Roma","Beefsteak"]'),
(7, 'Soybean', 'KHARIF', 'OILSEED', 800, 365, FALSE, '["JS-335","NRC-7","Shilajit"]');

INSERT INTO farmer_profiles (id, user_id, village, district, state, lat, lng, land_acres, farmer_score) VALUES
(1, 1, 'Palampur', 'Kangra', 'Himachal Pradesh', 32.110900, 76.536300, 12.50, 85.00),
(2, 2, 'Bardoli', 'Surat', 'Gujarat', 21.121300, 73.111900, 25.00, 92.50),
(3, 3, 'Baramati', 'Pune', 'Maharashtra', 18.152300, 74.576800, 5.00, 50.00),
(4, 4, 'Moga', 'Moga', 'Punjab', 30.816500, 75.171700, 40.00, 88.00),
(5, 5, 'Hassan', 'Hassan', 'Karnataka', 13.007200, 76.101600, 15.00, 75.00);

INSERT INTO buyer_profiles (id, user_id, company_name, gstin, business_type, preferred_crops, preferred_districts, credit_limit) VALUES
(1, 6, 'AgriFoods Processing Ltd', '27AABCU9603R1ZM', 'PROCESSOR', '["Wheat","Rice (Paddy)"]', '["Kangra","Pune"]', 500000.00),
(2, 7, 'FreshFarm Retailers', '07AABCU9603R1ZN', 'RETAILER', '["Wheat","Onion"]', '["Kangra","Moga"]', 200000.00),
(3, 8, 'GreenOrg Exporters', '24AABCU9603R1ZO', 'EXPORTER', '["Cotton","Rice (Paddy)"]', '["Surat","Hassan"]', 1000000.00);

INSERT INTO msp_rates (id, crop_name, season, year, msp_per_kg, announced_at) VALUES
(1, 'Wheat', 'RABI', 2024, 22.75, '2023-10-15'),
(2, 'Rice (Paddy)', 'KHARIF', 2024, 21.83, '2024-06-01'),
(3, 'Cotton', 'KHARIF', 2024, 66.20, '2024-06-05'),
(4, 'Maize', 'KHARIF', 2024, 19.60, '2024-06-10');

INSERT INTO produce_listings (id, farmer_id, crop_name, variety, quantity_kg, available_from, available_until, asking_price_per_kg, msp_price_per_kg, quality_grade, description, district, lat, lng, status, view_count) VALUES
(1, 1, 'Wheat', 'Sharbati', 5000.00, '2026-05-01', '2026-05-15', 25.00, 22.75, 'A', 'Premium wheat lot ready for pickup.', 'Kangra', 32.110900, 76.536300, 'SOLD', 12),
(2, 1, 'Rice (Paddy)', 'Basmati', 2000.00, '2026-05-03', '2026-05-16', 35.00, 21.83, 'A', 'Aromatic basmati harvest.', 'Kangra', 32.110900, 76.536300, 'ACTIVE', 5),
(3, 2, 'Cotton', 'BT Cotton', 8000.00, '2026-05-03', '2026-05-18', 70.00, 66.20, 'A', 'High quality cotton bales.', 'Surat', 21.121300, 73.111900, 'ACTIVE', 8),
(4, 2, 'Wheat', 'Lok-1', 4000.00, '2026-05-03', '2026-05-18', 23.50, 22.75, 'B', 'Bulk wheat lot for wholesale buyers.', 'Surat', 21.121300, 73.111900, 'ACTIVE', 2),
(5, 3, 'Rice (Paddy)', 'Indrayani', 3000.00, '2026-05-02', '2026-05-12', 30.00, 21.83, 'B', 'Fresh Indrayani paddy.', 'Pune', 18.152300, 74.576800, 'BIDDING', 7),
(6, 4, 'Wheat', 'HD-2967', 15000.00, '2026-05-03', '2026-05-20', 22.00, 22.75, 'A', 'Large wheat lot available.', 'Moga', 30.816500, 75.171700, 'ACTIVE', 4),
(7, 4, 'Cotton', 'Desi', 5000.00, '2026-05-03', '2026-05-21', 65.00, 66.20, 'B', 'Traditional cotton stock.', 'Moga', 30.816500, 75.171700, 'ACTIVE', 3),
(8, 5, 'Rice (Paddy)', 'Sona Masoori', 6000.00, '2026-05-03', '2026-05-19', 28.00, 21.83, 'A', 'Sona Masoori suitable for retail distribution.', 'Hassan', 13.007200, 76.101600, 'ACTIVE', 6),
(9, 5, 'Maize', 'Hybrid', 4000.00, '2026-05-03', '2026-05-19', 18.00, 19.60, 'B', 'Hybrid maize lot.', 'Hassan', 13.007200, 76.101600, 'ACTIVE', 1),
(10, 3, 'Onion', 'Nashik Red', 2000.00, '2026-05-03', '2026-05-13', 15.00, NULL, 'B', 'Fresh Nashik onions.', 'Pune', 18.152300, 74.576800, 'ACTIVE', 9);

INSERT INTO bids (id, listing_id, buyer_id, bid_price_per_kg, quantity_kg, bid_status, message) VALUES
(1, 1, 1, 24.50, 5000.00, 'ACCEPTED', 'Ready to arrange pickup immediately.'),
(2, 1, 2, 24.00, 3000.00, 'REJECTED', 'Can split logistics if needed.'),
(3, 3, 3, 68.00, 8000.00, 'PENDING', 'Export grade cotton required.'),
(4, 5, 1, 31.00, 3000.00, 'PENDING', 'Need full lot for processing.'),
(5, 6, 2, 22.50, 5000.00, 'PENDING', 'Can confirm within 24 hours.');

INSERT INTO orders (id, bid_id, farmer_id, buyer_id, final_price_per_kg, quantity_kg, total_amount, order_status, expected_delivery, actual_delivery, payment_status) VALUES
(1, 1, 1, 1, 24.50, 5000.00, 122500.00, 'CONFIRMED', '2026-05-04', NULL, 'PAID');

INSERT INTO wallet_transactions (id, farmer_id, order_id, transaction_type, amount, commission_amount, net_amount, remarks) VALUES
(1, 1, 1, 'CREDIT', 122500.00, 2450.00, 120050.00, 'Seeded accepted bid payout');

INSERT INTO price_history (id, crop_name, district, accepted_price, price_date, source) VALUES
(1, 'Wheat', 'Kangra', 24.50, CURRENT_DATE, 'ACCEPTED_BID');

INSERT INTO notifications (id, user_id, title, body, type, is_read, reference_id) VALUES
(1, 6, 'Bid Accepted', 'Your bid was accepted. Pickup confirmed.', 'ORDER_CREATED', FALSE, 1),
(2, 1, 'Bid Accepted Successfully', 'You accepted a bid. Your earnings have been credited.', 'WALLET_CREDIT', FALSE, 1);
