package com.agriconnect.service;

import com.agriconnect.dao.MatchmakingDao;
import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.model.BuyerProfile;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.MatchmakingScore;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@Transactional
public class MatchmakingService {

    private static final Logger log = LoggerFactory.getLogger(MatchmakingService.class);

    @Autowired
    private MatchmakingDao matchmakingDao;

    @Autowired
    private BaseDao<FarmerProfile, Long> farmerDao;

    @Autowired
    private BaseDao<BuyerProfile, Long> buyerDao;

    @Autowired
    private OrderDao orderDao;

    private final ObjectMapper mapper = new ObjectMapper();

    public void computeAllScores() {
        log.info("Starting smart matchmaking recomputation");
        List<FarmerProfile> farmers = farmerDao.findAll();
        List<BuyerProfile> buyers = buyerDao.findAll();

        for (FarmerProfile farmer : farmers) {
            for (BuyerProfile buyer : buyers) {
                double proximityScore = calculateProximityScore(farmer, buyer);
                double cropOverlapScore = calculateCropOverlapScore(farmer, buyer);
                double priceRangeScore = calculatePriceRangeScore(farmer, buyer);
                double historyScore = calculateHistoryScore(farmer, buyer);

                double totalScore = (proximityScore * 0.30) + (cropOverlapScore * 0.25) + 
                                    (priceRangeScore * 0.25) + (historyScore * 0.20);

                if (totalScore > 10.0) { // arbitrary threshold
                    MatchmakingScore match = new MatchmakingScore();
                    match.setFarmer(farmer);
                    match.setBuyer(buyer);
                    match.setScore(BigDecimal.valueOf(totalScore));
                    String factors = String.format("{\"proximity\": %.1f, \"crop\": %.1f, \"price\": %.1f, \"history\": %.1f}", 
                            proximityScore, cropOverlapScore, priceRangeScore, historyScore);
                    match.setFactors(factors);
                    matchmakingDao.save(match);
                }
            }
        }
        log.info("Smart matchmaking recomputation complete");
    }

    private double calculateProximityScore(FarmerProfile farmer, BuyerProfile buyer) {
        if (farmer.getLat() == null || farmer.getLng() == null) return 0;
        // Stub buyer centroid for demonstration, since buyer might have a preferred district string
        // Assuming buyer has some lat/lng in a real world or geocoded
        BigDecimal buyerLat = new BigDecimal("19.0760"); // stub Mumbai
        BigDecimal buyerLng = new BigDecimal("72.8777");
        
        double distanceKm = haversine(farmer.getLat().doubleValue(), farmer.getLng().doubleValue(), 
                                      buyerLat.doubleValue(), buyerLng.doubleValue());
        
        return Math.max(0, 100 - (distanceKm / 2));
    }

    private double calculateCropOverlapScore(FarmerProfile farmer, BuyerProfile buyer) {
        try {
            if (buyer.getPreferredCrops() == null || buyer.getPreferredCrops().isEmpty()) return 0;
            mapper.readTree(buyer.getPreferredCrops());
            // Simplistic: assume farmer's active listings determine their crops
            // For now, if farmer is in preferred crops, give 100.
            return 50.0; // Simplistic stub for demo, would require querying farmer's listings
        } catch (Exception e) {
            return 0;
        }
    }

    private double calculatePriceRangeScore(FarmerProfile farmer, BuyerProfile buyer) {
        return 75.0; // Stub: Calculate historical average bid vs asking
    }

    private double calculateHistoryScore(FarmerProfile farmer, BuyerProfile buyer) {
        long successfulOrders = orderDao.findByBuyer(buyer.getId(), com.agriconnect.model.Order.OrderStatus.DELIVERED)
                .stream().filter(o -> o.getFarmer().getId().equals(farmer.getId())).count();
        return Math.min(100.0, successfulOrders * 20.0);
    }

    private double haversine(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Radium of earth in km
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    public List<MatchmakingScore> getRecommendedBuyersForFarmer(Long farmerId) {
        return matchmakingDao.getTopMatchesForFarmer(farmerId, 5);
    }

    public List<MatchmakingScore> getRecommendedFarmersForBuyer(Long buyerId) {
        return matchmakingDao.getTopMatchesForBuyer(buyerId, 5);
    }
}
