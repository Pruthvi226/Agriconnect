package com.agriconnect.service;

import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.Order;
import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.exception.ResourceNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * Service responsible for calculating and persisting farmer reputation scores.
 *
 * <p>Score formula (per specification):
 * <pre>
 *   score = (delivery_score × 0.6) + (quality_score × 0.4)
 * </pre>
 *
 * <ul>
 *   <li>{@code delivery_score} — percentage of orders delivered on time (0–100)</li>
 *   <li>{@code quality_score}  — 100 minus dispute percentage (0–100)</li>
 * </ul>
 *
 * New farmers with no completed orders default to a neutral score of 50.0.
 */
@Service
@Transactional
public class FarmerScoreService {

    private static final Logger log = LoggerFactory.getLogger(FarmerScoreService.class);

    @Autowired
    private BaseDao<FarmerProfile, Long> farmerDao;

    @Autowired
    private FarmerProfileDao farmerProfileDao;

    @Autowired
    private OrderDao orderDao;

    /**
     * Recalculates and persists scores for every farmer in the system.
     * Called nightly by {@link ScheduledTasksService}.
     */
    public void recomputeAllActiveScores() {
        log.info("Starting farmer score recomputation for all farmers");
        List<FarmerProfile> farmers = farmerDao.findAll();
        for (FarmerProfile farmer : farmers) {
            recomputeScoreForFarmer(farmer);
        }
        log.info("Score recomputation complete for {} farmers", farmers.size());
    }

    /**
     * Alias kept for backward compatibility with {@link ScheduledTasksService}.
     */
    public void recomputeAllScores() {
        recomputeAllActiveScores();
    }

    /**
     * Recalculates and persists the score for a single farmer, identified by user ID.
     * Called immediately after a delivery is marked DELIVERED via {@link BidService}.
     *
     * @param userId the authenticated user's ID (not the farmer profile ID)
     * @throws ResourceNotFoundException if no farmer profile exists for the user
     */
    public void recomputeScoreForUserId(Long userId) {
        FarmerProfile farmer = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Farmer profile not found for user " + userId));
        recomputeScoreForFarmer(farmer);
    }

    /**
     * Core scoring logic for a single farmer profile.
     *
     * <p>Formula: {@code score = (deliveryScore × 0.6) + (qualityScore × 0.4)}
     *
     * @param farmer the farmer profile to score and persist
     */
    private void recomputeScoreForFarmer(FarmerProfile farmer) {
        List<Order> orders = orderDao.findByFarmer(farmer.getId(), null);

        if (orders.isEmpty()) {
            // New farmer: default neutral score
            farmer.setFarmerScore(new BigDecimal("50.00"));
            farmerDao.update(farmer);
            return;
        }

        long totalOrders     = orders.size();
        long deliveredOrders = orders.stream()
                .filter(o -> o.getOrderStatus() == Order.OrderStatus.DELIVERED)
                .count();
        long onTimeDeliveries = orders.stream()
                .filter(o -> o.getOrderStatus() == Order.OrderStatus.DELIVERED
                        && o.getActualDelivery() != null
                        && o.getExpectedDelivery() != null
                        && !o.getActualDelivery().isAfter(o.getExpectedDelivery()))
                .count();
        long disputedOrders = orders.stream()
                .filter(o -> o.getOrderStatus() == Order.OrderStatus.DISPUTED)
                .count();

        // delivery_score: % of completed orders that were on time (0–100)
        double deliveryScore = deliveredOrders == 0
                ? 0.0
                : ((double) onTimeDeliveries / deliveredOrders) * 100.0;

        // quality_score: inverted dispute rate (0–100)
        double qualityScore = 100.0 - ((double) disputedOrders / totalOrders * 100.0);

        // Specification formula: 0.6 delivery + 0.4 quality
        double rawScore = (deliveryScore * 0.6) + (qualityScore * 0.4);

        BigDecimal finalScore = BigDecimal.valueOf(rawScore)
                .setScale(2, RoundingMode.HALF_UP);

        log.debug("Farmer {} score: delivery={}, quality={}, final={}",
                farmer.getId(), deliveryScore, qualityScore, finalScore);

        farmer.setFarmerScore(finalScore);
        farmerDao.update(farmer);
    }
}
