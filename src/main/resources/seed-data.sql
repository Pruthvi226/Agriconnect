-- ---------------------------------------------------------
-- AgriConnect Demo Seed Data
-- Use this after schema.sql on a fresh database.
--
-- Demo credentials:
--   Admin:        admin@agriconnect.com / Admin@123
--   Farmers:      ramesh@example.com, suresh@example.com, vikram@example.com / Farmer@123
--   Buyers:       contact@agrifoods.com, sales@freshfarm.com / Buyer@123
--   Experts:      ravi.v@kvk.edu, anita.r@uni.edu / Expert@123
-- ---------------------------------------------------------

INSERT INTO users (id, name, email, password_hash, phone, role, verification_status) VALUES
(1, 'Ramesh Kumar', 'ramesh@example.com', '$2a$12$NsFm2mYFgfZyXLudOkDRXuBY0mlTj2P1irXZv3ZpwJh43sLzesvgK', '9876543210', 'FARMER', 'VERIFIED'),
(2, 'Suresh Singh', 'suresh@example.com', '$2a$12$NsFm2mYFgfZyXLudOkDRXuBY0mlTj2P1irXZv3ZpwJh43sLzesvgK', '9876543211', 'FARMER', 'VERIFIED'),
(3, 'Amit Patel', 'amit@example.com', '$2a$12$NsFm2mYFgfZyXLudOkDRXuBY0mlTj2P1irXZv3ZpwJh43sLzesvgK', '9876543212', 'FARMER', 'PENDING'),
(4, 'Vikram Yadav', 'vikram@example.com', '$2a$12$NsFm2mYFgfZyXLudOkDRXuBY0mlTj2P1irXZv3ZpwJh43sLzesvgK', '9876543213', 'FARMER', 'VERIFIED'),
(5, 'Sunil Sharma', 'sunil@example.com', '$2a$12$NsFm2mYFgfZyXLudOkDRXuBY0mlTj2P1irXZv3ZpwJh43sLzesvgK', '9876543214', 'FARMER', 'VERIFIED'),
(6, 'AgriFoods Ltd', 'contact@agrifoods.com', '$2a$12$86Yf.FaqxINm9jkzaNDIxeeHtmAxyq60mbw5g.PIDUEVnVAVLXwVS', '8876543210', 'BUYER', 'VERIFIED'),
(7, 'FreshFarm Corp', 'sales@freshfarm.com', '$2a$12$86Yf.FaqxINm9jkzaNDIxeeHtmAxyq60mbw5g.PIDUEVnVAVLXwVS', '8876543211', 'BUYER', 'VERIFIED'),
(8, 'GreenOrg Inc', 'info@greenorg.com', '$2a$12$86Yf.FaqxINm9jkzaNDIxeeHtmAxyq60mbw5g.PIDUEVnVAVLXwVS', '8876543212', 'BUYER', 'PENDING'),
(9, 'Dr. Ravi Verma', 'ravi.v@kvk.edu', '$2a$12$hBifVCUi2g0vu9oC7voEpeREqiWAc8kSDah9vB/dwc08wVCZoKqZe', '7876543210', 'AGRI_EXPERT', 'VERIFIED'),
(10, 'Prof. Anita Rao', 'anita.r@uni.edu', '$2a$12$hBifVCUi2g0vu9oC7voEpeREqiWAc8kSDah9vB/dwc08wVCZoKqZe', '7876543211', 'AGRI_EXPERT', 'VERIFIED'),
(11, 'Admin User', 'admin@agriconnect.com', '$2a$12$3oS38aj2nZHuYz8WWk1gq.LTRuNfg1/ehjhlUUOM7oD50sD46zk9.', '9000000000', 'ADMIN', 'VERIFIED'),
(12, 'Meena Devi', 'meena@example.com', '$2a$12$NsFm2mYFgfZyXLudOkDRXuBY0mlTj2P1irXZv3ZpwJh43sLzesvgK', '9876543215', 'FARMER', 'VERIFIED'),
(13, 'Metro Organics', 'orders@metroorganics.com', '$2a$12$86Yf.FaqxINm9jkzaNDIxeeHtmAxyq60mbw5g.PIDUEVnVAVLXwVS', '8876543213', 'BUYER', 'VERIFIED');

INSERT INTO crops (id, name, category) VALUES
(1, 'Wheat', 'Cereals'),
(2, 'Rice (Paddy)', 'Cereals'),
(3, 'Cotton', 'Cash Crop'),
(4, 'Maize', 'Cereals'),
(5, 'Onion', 'Vegetables'),
(6, 'Tomato', 'Vegetables'),
(7, 'Soybean', 'Oilseed'),
(8, 'Potato', 'Vegetables');

INSERT INTO crop_master (id, crop_name, season, category, avg_yield_per_acre, storage_life_days, cold_storage_required, common_varieties) VALUES
(1, 'Wheat', 'RABI', 'CEREAL', 1800, 365, FALSE, '["Sharbati","HD-2967","Lok-1","Raj-4120"]'),
(2, 'Rice (Paddy)', 'KHARIF', 'CEREAL', 1400, 180, FALSE, '["Basmati","Indrayani","Sona Masoori","BPT-5204"]'),
(3, 'Cotton', 'KHARIF', 'FIBER', 500, 365, FALSE, '["BT Cotton","Desi","H-6","LRA-5166"]'),
(4, 'Maize', 'KHARIF', 'CEREAL', 2200, 90, FALSE, '["Hybrid","Ganga-5","Vijay","Shaktiman-1"]'),
(5, 'Onion', 'RABI', 'VEGETABLE', 8000, 60, TRUE, '["Nashik Red","White Onion","Agrifound Dark Red"]'),
(6, 'Tomato', 'YEAR_ROUND', 'VEGETABLE', 12000, 14, TRUE, '["Hybrid","Cherry","Roma","Beefsteak"]'),
(7, 'Soybean', 'KHARIF', 'OILSEED', 800, 365, FALSE, '["JS-335","NRC-7","Shilajit"]'),
(8, 'Potato', 'RABI', 'VEGETABLE', 9000, 90, TRUE, '["Kufri Jyoti","Kufri Pukhraj","Chipsona"]');

INSERT INTO farmer_profiles (id, user_id, village, district, state, lat, lng, land_acres, farmer_score) VALUES
(1, 1, 'Palampur', 'Kangra', 'Himachal Pradesh', 32.110900, 76.536300, 12.50, 85.00),
(2, 2, 'Bardoli', 'Surat', 'Gujarat', 21.121300, 73.111900, 25.00, 92.50),
(3, 3, 'Baramati', 'Pune', 'Maharashtra', 18.152300, 74.576800, 5.00, 50.00),
(4, 4, 'Moga', 'Moga', 'Punjab', 30.816500, 75.171700, 40.00, 88.00),
(5, 5, 'Hassan', 'Hassan', 'Karnataka', 13.007200, 76.101600, 15.00, 75.00),
(6, 12, 'Lasalgaon', 'Nashik', 'Maharashtra', 20.142000, 74.240000, 9.75, 81.00);

INSERT INTO buyer_profiles (id, user_id, company_name, gstin, business_type, preferred_crops, preferred_districts, credit_limit) VALUES
(1, 6, 'AgriFoods Processing Ltd', '27AABCU9603R1ZM', 'PROCESSOR', '["Wheat","Rice (Paddy)","Maize"]', '["Kangra","Pune","Moga"]', 500000.00),
(2, 7, 'FreshFarm Retailers', '07AABCU9603R1ZN', 'RETAILER', '["Wheat","Onion","Tomato"]', '["Kangra","Moga","Nashik"]', 200000.00),
(3, 8, 'GreenOrg Exporters', '24AABCU9603R1ZO', 'EXPORTER', '["Cotton","Rice (Paddy)","Soybean"]', '["Surat","Hassan"]', 1000000.00),
(4, 13, 'Metro Organics Procurement', '29AABCU9603R1ZP', 'WHOLESALER', '["Onion","Tomato","Potato"]', '["Nashik","Pune","Surat"]', 350000.00);

INSERT INTO msp_rates (id, crop_name, season, marketing_year, msp_per_kg, announced_at) VALUES
(1, 'Wheat', 'RABI', 2026, 22.75, '2025-10-15'),
(2, 'Rice (Paddy)', 'KHARIF', 2026, 21.83, '2025-06-01'),
(3, 'Cotton', 'KHARIF', 2026, 66.20, '2025-06-05'),
(4, 'Maize', 'KHARIF', 2026, 19.60, '2025-06-10'),
(5, 'Soybean', 'KHARIF', 2026, 46.00, '2025-06-10'),
(6, 'Onion', 'ZAID', 2026, 16.50, '2026-04-01'),
(7, 'Tomato', 'ZAID', 2026, 14.00, '2026-04-01'),
(8, 'Potato', 'RABI', 2026, 18.00, '2025-11-01');

INSERT INTO market_prices (id, crop_id, msp, current_average_price, effective_date) VALUES
(1, 1, 22.75, 25.40, '2026-05-15'),
(2, 2, 21.83, 28.10, '2026-05-15'),
(3, 3, 66.20, 70.60, '2026-05-15'),
(4, 4, 19.60, 20.30, '2026-05-15'),
(5, 5, 16.50, 23.80, '2026-05-15'),
(6, 6, 14.00, 19.60, '2026-05-15'),
(7, 7, 46.00, 44.80, '2026-05-15'),
(8, 8, 18.00, 21.25, '2026-05-15');

INSERT INTO produce_listings (id, farmer_id, crop_name, variety, quantity_kg, available_from, available_until, asking_price_per_kg, msp_price_per_kg, quality_grade, description, district, lat, lng, status, view_count, is_urgent, urgent_reason) VALUES
(1, 1, 'Wheat', 'Sharbati', 5000.00, '2026-05-10', '2026-05-25', 25.00, 22.75, 'A', 'Premium wheat lot ready for pickup.', 'Kangra', 32.110900, 76.536300, 'SOLD', 32, FALSE, NULL),
(2, 1, 'Rice (Paddy)', 'Basmati', 2000.00, '2026-05-15', '2026-05-30', 35.00, 21.83, 'A', 'Aromatic basmati harvest for retail buyers.', 'Kangra', 32.110900, 76.536300, 'ACTIVE', 18, TRUE, 'Storage space needed for next lot'),
(3, 2, 'Cotton', 'BT Cotton', 8000.00, '2026-05-15', '2026-06-05', 70.00, 66.20, 'A', 'High quality cotton bales suitable for export.', 'Surat', 21.121300, 73.111900, 'ACTIVE', 21, FALSE, NULL),
(4, 2, 'Wheat', 'Lok-1', 4000.00, '2026-05-16', '2026-06-03', 23.50, 22.75, 'B', 'Bulk wheat lot for wholesale buyers.', 'Surat', 21.121300, 73.111900, 'ACTIVE', 13, FALSE, NULL),
(5, 3, 'Rice (Paddy)', 'Indrayani', 3000.00, '2026-05-15', '2026-05-28', 30.00, 21.83, 'B', 'Fresh Indrayani paddy, buyer discussion open.', 'Pune', 18.152300, 74.576800, 'BIDDING', 19, FALSE, NULL),
(6, 4, 'Wheat', 'HD-2967', 15000.00, '2026-05-15', '2026-06-08', 22.00, 22.75, 'A', 'Large wheat lot currently below MSP for admin review.', 'Moga', 30.816500, 75.171700, 'ACTIVE', 10, FALSE, NULL),
(7, 4, 'Cotton', 'Desi', 5000.00, '2026-05-16', '2026-06-08', 65.00, 66.20, 'B', 'Traditional cotton stock below MSP.', 'Moga', 30.816500, 75.171700, 'ACTIVE', 7, FALSE, NULL),
(8, 5, 'Rice (Paddy)', 'Sona Masoori', 6000.00, '2026-05-15', '2026-06-04', 28.00, 21.83, 'A', 'Sona Masoori suitable for retail distribution.', 'Hassan', 13.007200, 76.101600, 'ACTIVE', 14, FALSE, NULL),
(9, 5, 'Maize', 'Hybrid', 4000.00, '2026-05-15', '2026-06-04', 18.00, 19.60, 'B', 'Hybrid maize lot below MSP for urgent liquidation.', 'Hassan', 13.007200, 76.101600, 'ACTIVE', 6, FALSE, NULL),
(10, 6, 'Onion', 'Nashik Red', 7500.00, '2026-05-15', '2026-05-29', 22.50, 16.50, 'A', 'Dry Nashik red onion ready for bulk dispatch.', 'Nashik', 20.142000, 74.240000, 'ACTIVE', 27, TRUE, 'Rain expected; quick pickup preferred'),
(11, 6, 'Tomato', 'Roma', 1800.00, '2026-05-15', '2026-05-22', 18.50, 14.00, 'A', 'Fresh Roma tomato with counter offer demo available.', 'Nashik', 20.142000, 74.240000, 'BIDDING', 23, TRUE, 'Perishable crop'),
(12, 1, 'Potato', 'Kufri Jyoti', 2500.00, '2026-05-14', '2026-05-27', 21.00, 18.00, 'B', 'Was visible earlier; withdrawn by farmer for demo.', 'Kangra', 32.110900, 76.536300, 'WITHDRAWN', 4, FALSE, NULL),
(13, 2, 'Onion', 'White Onion', 3200.00, '2026-05-18', '2026-06-01', 20.00, 16.50, 'B', 'White onion batch for restaurants.', 'Surat', 21.121300, 73.111900, 'ACTIVE', 9, FALSE, NULL),
(14, 5, 'Soybean', 'JS-335', 4500.00, '2026-05-17', '2026-06-10', 42.00, 46.00, 'A', 'Soybean below MSP for compliance dashboard.', 'Hassan', 13.007200, 76.101600, 'ACTIVE', 11, FALSE, NULL);

INSERT INTO bids (id, listing_id, buyer_id, bid_price_per_kg, quantity_kg, bid_status, message, counter_price_per_kg, counter_message, created_at) VALUES
(1, 1, 1, 24.50, 5000.00, 'ACCEPTED', 'Ready to arrange pickup immediately.', NULL, NULL, '2026-05-13 09:15:00'),
(2, 1, 2, 24.00, 3000.00, 'REJECTED', 'Can split logistics if needed.', NULL, NULL, '2026-05-13 09:40:00'),
(3, 3, 3, 68.00, 8000.00, 'PENDING', 'Export grade cotton required.', NULL, NULL, '2026-05-15 09:30:00'),
(4, 5, 1, 31.00, 3000.00, 'PENDING', 'Need full lot for processing.', NULL, NULL, '2026-05-15 10:15:00'),
(5, 6, 2, 22.50, 5000.00, 'PENDING', 'Can confirm within 24 hours.', NULL, NULL, '2026-05-15 10:45:00'),
(6, 10, 4, 22.75, 2500.00, 'ACCEPTED', 'Pickup vehicle available tomorrow morning.', NULL, NULL, '2026-05-14 12:10:00'),
(7, 8, 1, 28.25, 2000.00, 'ACCEPTED', 'Need clean bags and invoice.', NULL, NULL, '2026-05-12 14:25:00'),
(8, 11, 2, 17.50, 900.00, 'COUNTERED', 'Can collect today if price works.', 18.00, 'Quality is Grade A; please accept Rs 18/kg.', '2026-05-15 11:00:00'),
(9, 14, 3, 43.00, 3000.00, 'PENDING', 'Export lot subject to moisture check.', NULL, NULL, '2026-05-15 11:30:00');

INSERT INTO orders (id, bid_id, farmer_id, buyer_id, final_price_per_kg, quantity_kg, total_amount, order_status, expected_delivery, actual_delivery, payment_status) VALUES
(1, 1, 1, 1, 24.50, 5000.00, 122500.00, 'CONFIRMED', '2026-05-17', NULL, 'PAID'),
(2, 6, 6, 4, 22.75, 2500.00, 56875.00, 'IN_TRANSIT', '2026-05-16', NULL, 'PAID'),
(3, 7, 5, 1, 28.25, 2000.00, 56500.00, 'DELIVERED', '2026-05-14', '2026-05-14', 'PAID');

INSERT INTO wallet_transactions (id, farmer_id, order_id, transaction_type, amount, commission_amount, net_amount, remarks) VALUES
(1, 1, 1, 'CREDIT', 122500.00, 2450.00, 120050.00, 'Seeded accepted bid payout'),
(2, 6, 2, 'CREDIT', 56875.00, 1137.50, 55737.50, 'Onion order payout in transit'),
(3, 5, 3, 'CREDIT', 56500.00, 1130.00, 55370.00, 'Delivered rice order payout');

INSERT INTO price_history (id, crop_name, district, accepted_price, price_date, source) VALUES
(1, 'Wheat', 'Kangra', 24.50, '2026-05-13', 'ACCEPTED_BID'),
(2, 'Onion', 'Nashik', 22.75, '2026-05-14', 'ACCEPTED_BID'),
(3, 'Rice (Paddy)', 'Hassan', 28.25, '2026-05-12', 'ACCEPTED_BID'),
(4, 'Tomato', 'Nashik', 19.60, '2026-05-15', 'MARKET_FEED'),
(5, 'Soybean', 'Hassan', 44.80, '2026-05-15', 'MARKET_FEED');

INSERT INTO notifications (id, user_id, title, body, type, is_read, reference_id) VALUES
(1, 6, 'Bid Accepted', 'Your wheat bid was accepted. Pickup is confirmed.', 'ORDER_CREATED', FALSE, 1),
(2, 1, 'Bid Accepted Successfully', 'You accepted a bid. Your earnings have been credited.', 'WALLET_CREDIT', FALSE, 1),
(3, 12, 'Order In Transit', 'Metro Organics pickup vehicle is on the way for your onion order.', 'ORDER_UPDATE', FALSE, 2),
(4, 13, 'Delivery Confirmation Pending', 'Confirm delivery after onion stock reaches your warehouse.', 'ORDER_UPDATE', FALSE, 2),
(5, 7, 'Counter Offer Received', 'Meena Devi countered your tomato bid at Rs 18/kg.', 'BID_UPDATE', FALSE, 8),
(6, 5, 'Rice Order Delivered', 'AgriFoods confirmed delivery of your Sona Masoori lot.', 'ORDER_UPDATE', TRUE, 3),
(7, 4, 'MSP Review Needed', 'Two active listings from your district are below MSP.', 'SYSTEM', FALSE, NULL),
(8, 9, 'Critical Advisory Sent', 'Fall armyworm advisory notified matching maize farmers.', 'ADVISORY_ALERT', TRUE, 2),
(9, 11, 'Daily Admin Snapshot', '4 active listings are below MSP and need review.', 'SYSTEM', FALSE, NULL);

INSERT INTO advisories (id, expert_id, title, body, crop_name, advisory_type, severity, affected_districts, valid_until) VALUES
(1, 9, 'Heavy Rainfall Alert', 'Expected heavy rainfall over the next 48 hours. Secure harvested wheat and delay pesticide application.', 'Wheat', 'WEATHER', 'WARNING', '["Kangra", "Moga"]', '2026-06-05'),
(2, 10, 'Pest Warning: Fall Armyworm', 'Initial signs of Fall Armyworm detected in maize crops. Preventive spraying is recommended immediately.', 'Maize', 'PEST', 'CRITICAL', '["Hassan"]', '2026-06-10'),
(3, 9, 'Optimal Sowing Window', 'Current soil moisture levels are ideal for early Kharif sowing. Recommended for paddy varieties.', 'Rice (Paddy)', 'TECHNIQUE', 'INFO', '["Pune", "Surat"]', '2026-06-15'),
(4, 10, 'Tomato Blight Watch', 'High humidity in Nashik may trigger early blight. Inspect leaves daily and avoid overhead irrigation.', 'Tomato', 'DISEASE', 'WARNING', '["Nashik", "Pune"]', '2026-05-30'),
(5, 9, 'Onion Market Update', 'Restaurant demand is rising. Farmers with dry onion stock can target bulk buyers this week.', 'Onion', 'MARKET', 'INFO', '["Nashik", "Surat"]', '2026-06-01');

INSERT INTO critical_alerts (id, advisory_id) VALUES
(1, 2);

INSERT INTO matchmaking_scores (id, farmer_id, buyer_id, score, factors) VALUES
(1, 1, 1, 92.50, '{"distance_km": 12.5, "quality_match": true, "volume_match": true, "farmer_rating": 85.0}'),
(2, 1, 2, 78.00, '{"distance_km": 45.0, "quality_match": true, "volume_match": false, "farmer_rating": 85.0}'),
(3, 2, 3, 95.00, '{"distance_km": 8.0, "quality_match": true, "volume_match": true, "farmer_rating": 92.5}'),
(4, 4, 2, 88.50, '{"distance_km": 25.0, "quality_match": true, "volume_match": true, "farmer_rating": 88.0}'),
(5, 5, 3, 82.00, '{"distance_km": 60.0, "quality_match": true, "volume_match": true, "farmer_rating": 75.0}'),
(6, 6, 4, 96.00, '{"distance_km": 18.0, "quality_match": true, "volume_match": true, "farmer_rating": 81.0}'),
(7, 6, 2, 91.00, '{"distance_km": 32.0, "quality_match": true, "volume_match": true, "farmer_rating": 81.0}');

INSERT INTO fpo_groups (id, group_name, leader_farmer_id, district, state, registration_number, is_verified, total_members) VALUES
(1, 'Kangra Grain Collective', 1, 'Kangra', 'Himachal Pradesh', 'FPO-HP-KGR-001', TRUE, 2),
(2, 'Nashik Fresh Produce FPO', 6, 'Nashik', 'Maharashtra', 'FPO-MH-NSK-014', TRUE, 2);

INSERT INTO fpo_memberships (id, fpo_id, farmer_id, is_active) VALUES
(1, 1, 1, TRUE),
(2, 1, 4, TRUE),
(3, 2, 6, TRUE),
(4, 2, 3, FALSE);

INSERT INTO fpo_listings (id, fpo_id, crop_name, total_quantity_kg, min_price_per_kg, quality_grade, pooling_deadline, status) VALUES
(1, 1, 'Wheat', 19000.00, 22.75, 'A', '2026-05-24', 'OPEN'),
(2, 2, 'Onion', 10700.00, 20.00, 'A', '2026-05-26', 'OPEN'),
(3, 2, 'Tomato', 1800.00, 18.00, 'A', '2026-05-20', 'OPEN');

INSERT INTO audit_logs (id, user_id, action, entity_type, entity_id, old_value, new_value, ip_address, timestamp) VALUES
(1, 6, 'CREATE', 'Bid', 1, '{}', '{"bidPrice":24.50}', '127.0.0.1', '2026-05-13 09:15:00'),
(2, 1, 'ACCEPT_BID', 'Bid', 1, '{"status":"PENDING"}', '{"status":"ACCEPTED","orderId":1}', '127.0.0.1', '2026-05-13 10:00:00'),
(3, 12, 'ACCEPT_BID', 'Bid', 6, '{"status":"PENDING"}', '{"status":"ACCEPTED","orderId":2}', '127.0.0.1', '2026-05-14 13:00:00'),
(4, 5, 'UPDATE_DELIVERY', 'Order', 3, '{"status":"IN_TRANSIT"}', '{"status":"DELIVERED"}', '127.0.0.1', '2026-05-14 18:20:00'),
(5, 11, 'VERIFY_USER', 'User', 3, '{"verificationStatus":"PENDING"}', '{"verificationStatus":"PENDING"}', '127.0.0.1', '2026-05-15 09:00:00'),
(6, 10, 'PUBLISH_ADVISORY', 'Advisory', 2, '{}', '{"severity":"CRITICAL"}', '127.0.0.1', '2026-05-15 10:05:00'),
(7, 1, 'WITHDRAW_LISTING', 'ProduceListing', 12, '{"status":"ACTIVE"}', '{"status":"WITHDRAWN"}', '127.0.0.1', '2026-05-15 11:10:00');
