DROP PROCEDURE IF EXISTS sp_get_nearby_listings;

CREATE PROCEDURE sp_get_nearby_listings(
    IN p_lat DECIMAL(9, 6),
    IN p_lng DECIMAL(9, 6),
    IN p_radius_km DOUBLE
)
BEGIN
    SELECT pl.*
    FROM produce_listings pl
    WHERE pl.status IN ('ACTIVE', 'BIDDING')
      AND pl.lat IS NOT NULL
      AND pl.lng IS NOT NULL
      AND (
          6371 * ACOS(
              COS(RADIANS(p_lat)) *
              COS(RADIANS(pl.lat)) *
              COS(RADIANS(pl.lng) - RADIANS(p_lng)) +
              SIN(RADIANS(p_lat)) *
              SIN(RADIANS(pl.lat))
          )
      ) <= p_radius_km
    ORDER BY pl.created_at DESC;
END;
