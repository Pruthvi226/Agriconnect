DROP PROCEDURE IF EXISTS sp_compute_farmer_score;

CREATE PROCEDURE sp_compute_farmer_score(IN p_farmer_id BIGINT)
BEGIN
    UPDATE farmer_profiles fp
    LEFT JOIN (
        SELECT farmer_id,
               COUNT(*) AS total_orders,
               SUM(CASE WHEN order_status = 'DELIVERED' THEN 1 ELSE 0 END) AS delivered_orders,
               SUM(CASE WHEN order_status = 'CANCELLED' THEN 1 ELSE 0 END) AS cancelled_orders
        FROM orders
        WHERE farmer_id = p_farmer_id
        GROUP BY farmer_id
    ) stats ON stats.farmer_id = fp.id
    SET fp.farmer_score = LEAST(
        100.00,
        GREATEST(
            0.00,
            50.00
            + COALESCE(stats.delivered_orders, 0) * 8
            - COALESCE(stats.cancelled_orders, 0) * 10
            + CASE
                WHEN COALESCE(stats.total_orders, 0) >= 5
                THEN (COALESCE(stats.delivered_orders, 0) / stats.total_orders) * 20
                ELSE 0
              END
        )
    )
    WHERE fp.id = p_farmer_id;
END;
