-- Redesign Schema Updates
ALTER TABLE produce_listings 
  ADD COLUMN is_urgent BOOLEAN DEFAULT FALSE,
  ADD COLUMN urgent_reason VARCHAR(200) NULL;

ALTER TABLE bids 
  ADD COLUMN counter_price_per_kg DECIMAL(8,2) NULL,
  ADD COLUMN counter_message VARCHAR(300) NULL;

-- Update bid_status ENUM would be tricky in H2/MySQL via ALTER
-- If using enum, we might need to recreate the column or just use string
-- Assuming string-based or existing enum can be extended
