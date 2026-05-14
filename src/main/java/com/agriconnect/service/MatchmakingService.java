package com.agriconnect.service;

import com.agriconnect.dao.MatchmakingDao;
import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.model.BuyerProfile;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.MatchmakingScore;
import com.agriconnect.model.ProduceListing;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Matchmaking engine that scores farmer–buyer compatibility pairs.
 *
 * <p>Score formula (per specification):
 * <pre>
 *   score = (cropTypeMatch × 0.4) + (locationProximity × 0.3) + (historicalScore × 0.3)
 * </pre>
 * Each sub-score is normalized to 0–100 before weighting.
 */
@Service
@Transactional
public class MatchmakingService {

    private static final Logger log = LoggerFactory.getLogger(MatchmakingService.class);

    /** Radius within which proximity score is considered "near" (in km). */
    private static final double PROXIMITY_MAX_KM = 500.0;

    @Autowired
    private MatchmakingDao matchmakingDao;

    @Autowired
    private BaseDao<FarmerProfile, Long> farmerDao;

    @Autowired
    private BaseDao<BuyerProfile, Long> buyerDao;

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private ProduceListingDao produceListingDao;

    private final ObjectMapper mapper = new ObjectMapper();

    public MatchmakingScore computeAndSaveScore(Long farmerId, Long buyerId) {
        FarmerProfile farmer = farmerDao.findById(farmerId)
                .orElseThrow(() -> new com.agriconnect.exception.ResourceNotFoundException("Farmer not found"));
        BuyerProfile buyer = buyerDao.findById(buyerId)
                .orElseThrow(() -> new com.agriconnect.exception.ResourceNotFoundException("Buyer not found"));

        List<ProduceListing> listings = produceListingDao.findByFarmer(farmerId, ProduceListing.Status.ACTIVE);
        Set<String> farmerCrops = listings.stream()
                .map(ProduceListing::getCropName)
                .filter(java.util.Objects::nonNull)
                .map(value -> value.trim().toLowerCase())
                .collect(Collectors.toSet());
        Set<String> preferredCrops = parseJsonArray(buyer.getPreferredCrops()).stream()
                .map(value -> value.trim().toLowerCase())
                .collect(Collectors.toSet());
        Set<String> preferredDistricts = parseJsonArray(buyer.getPreferredDistricts()).stream()
                .map(value -> value.trim().toLowerCase())
                .collect(Collectors.toSet());

        double cropPoints = 0.0;
        if (!farmerCrops.isEmpty() && !preferredCrops.isEmpty()) {
            long overlap = farmerCrops.stream().filter(preferredCrops::contains).count();
            cropPoints = ((double) overlap / preferredCrops.size()) * 40.0;
        }

        double districtPoints;
        String farmerDistrict = farmer.getDistrict() == null ? "" : farmer.getDistrict().trim().toLowerCase();
        if (!farmerDistrict.isBlank() && preferredDistricts.contains(farmerDistrict)) {
            districtPoints = 30.0;
        } else {
            districtPoints = calculateProximityScore(farmer, buyer) * 0.30;
        }

        double farmerScorePoints = farmer.getFarmerScore() == null
                ? 15.0
                : Math.min(30.0, farmer.getFarmerScore().doubleValue() / 100.0 * 30.0);
        double total = Math.min(100.0, cropPoints + districtPoints + farmerScorePoints);

        MatchmakingScore score = new MatchmakingScore();
        score.setFarmer(farmer);
        score.setBuyer(buyer);
        score.setScore(BigDecimal.valueOf(total).setScale(2, java.math.RoundingMode.HALF_UP));
        score.setFactors(String.format(
                "{\"cropMatch\":%.2f,\"districtMatch\":%.2f,\"farmerScore\":%.2f}",
                cropPoints, districtPoints, farmerScorePoints));
        matchmakingDao.save(score);
        return score;
    }

    public double computeScore(Long farmerId, Long buyerId) {
        return computeAndSaveScore(farmerId, buyerId).getScore().doubleValue();
    }

    /**
     * Recomputes match scores for all farmer–buyer pairs and persists them.
     * Skips pairs that score below the minimum threshold of 5.0.
     */
    public void computeAllScores() {
        log.info("Starting smart matchmaking recomputation");
        List<FarmerProfile> farmers = farmerDao.findAll();
        List<BuyerProfile> buyers = buyerDao.findAll();

        for (FarmerProfile farmer : farmers) {
            for (BuyerProfile buyer : buyers) {
                double cropOverlapScore  = calculateCropOverlapScore(farmer, buyer);
                double proximityScore    = calculateProximityScore(farmer, buyer);
                double historyScore      = calculateHistoryScore(farmer, buyer);

                // Weighted formula per specification: 0.4 crop + 0.3 proximity + 0.3 history
                double totalScore = (cropOverlapScore * 0.4)
                                  + (proximityScore   * 0.3)
                                  + (historyScore      * 0.3);

                if (totalScore > 5.0) {
                    MatchmakingScore match = new MatchmakingScore();
                    match.setFarmer(farmer);
                    match.setBuyer(buyer);
                    match.setScore(BigDecimal.valueOf(Math.round(totalScore * 100.0) / 100.0));
                    String factors = String.format(
                        "{\"crop\": %.1f, \"proximity\": %.1f, \"history\": %.1f, \"total\": %.1f}",
                        cropOverlapScore, proximityScore, historyScore, totalScore);
                    match.setFactors(factors);
                    matchmakingDao.save(match);
                }
            }
        }
        log.info("Matchmaking recomputation complete for {} farmers × {} buyers",
                farmers.size(), buyers.size());
    }

    /**
     * Calculates a crop-type overlap score (0–100) between a farmer's active listings
     * and the buyer's declared preferred crops.
     *
     * @param farmer the farmer profile
     * @param buyer  the buyer profile
     * @return score from 0 (no overlap) to 100 (full overlap)
     */
    private double calculateCropOverlapScore(FarmerProfile farmer, BuyerProfile buyer) {
        if (buyer.getPreferredCrops() == null || buyer.getPreferredCrops().isBlank()) {
            return 0.0;
        }

        Set<String> preferredCrops;
        try {
            List<String> parsed = mapper.readValue(
                buyer.getPreferredCrops(), new TypeReference<List<String>>() {});
            preferredCrops = parsed.stream()
                    .map(String::toLowerCase)
                    .collect(Collectors.toSet());
        } catch (Exception e) {
            log.warn("Failed to parse buyer preferred_crops JSON for buyer {}: {}", buyer.getId(), e.getMessage());
            return 0.0;
        }

        // Fetch farmer's active crop names to check real overlap
        List<ProduceListing> activeListings = produceListingDao.findByFarmer(farmer.getId(), ProduceListing.Status.ACTIVE);
        if (activeListings.isEmpty()) {
            // Also check BIDDING listings
            activeListings = produceListingDao.findByFarmer(farmer.getId(), ProduceListing.Status.BIDDING);
        }

        Set<String> farmerCrops = activeListings.stream()
                .map(l -> l.getCropName().toLowerCase())
                .collect(Collectors.toSet());

        if (farmerCrops.isEmpty()) return 0.0;

        long matchCount = farmerCrops.stream().filter(preferredCrops::contains).count();
        return Math.min(100.0, (double) matchCount / preferredCrops.size() * 100.0);
    }

    /**
     * Calculates a proximity score (0–100) using the Haversine formula.
     * Uses the farmer's GPS coordinates and maps buyer's preferred districts
     * to a representative centroid. Falls back to 50 when buyer has no location data.
     *
     * @param farmer the farmer profile (must have lat/lng)
     * @param buyer  the buyer profile (preferred_districts JSON array)
     * @return score from 0 (>500 km away) to 100 (same location)
     */
    private double calculateProximityScore(FarmerProfile farmer, BuyerProfile buyer) {
        if (farmer.getLat() == null || farmer.getLng() == null) {
            return 0.0;
        }

        // Map buyer's preferred district to an approximate centroid
        // In production this would use a geocoding API; here we use a lookup table
        double buyerLat = getDistrictCentroidLat(buyer);
        double buyerLng = getDistrictCentroidLng(buyer);

        if (buyerLat == 0.0) {
            // No district data — give neutral score
            return 50.0;
        }

        double distanceKm = haversine(
            farmer.getLat().doubleValue(), farmer.getLng().doubleValue(),
            buyerLat, buyerLng);

        // Linear decay: 100 at 0 km → 0 at PROXIMITY_MAX_KM
        return Math.max(0.0, 100.0 - (distanceKm / PROXIMITY_MAX_KM * 100.0));
    }

    /**
     * Calculates historical transaction success score (0–100) between a specific
     * farmer and buyer based on completed DELIVERED orders.
     *
     * @param farmer the farmer profile
     * @param buyer  the buyer profile
     * @return score: each completed order adds 20 points, capped at 100
     */
    private double calculateHistoryScore(FarmerProfile farmer, BuyerProfile buyer) {
        long successfulOrders = orderDao
            .findByBuyer(buyer.getId(), com.agriconnect.model.Order.OrderStatus.DELIVERED)
            .stream()
            .filter(o -> o.getFarmer().getId().equals(farmer.getId()))
            .count();
        return Math.min(100.0, successfulOrders * 20.0);
    }

    /**
     * Returns top match recommendations for a specific farmer (by profile ID).
     *
     * @param farmerId the farmer profile ID
     * @return list of up to 5 MatchmakingScore records, best score first
     */
    public List<MatchmakingScore> getRecommendedBuyersForFarmer(Long farmerId) {
        if (farmerId == null) return Collections.emptyList();
        return matchmakingDao.getTopMatchesForFarmer(farmerId, 5);
    }

    /**
     * Returns top match recommendations for a specific buyer (by profile ID).
     *
     * @param buyerId the buyer profile ID
     * @return list of up to 5 MatchmakingScore records, best score first
     */
    public List<MatchmakingScore> getRecommendedFarmersForBuyer(Long buyerId) {
        if (buyerId == null) return Collections.emptyList();
        return matchmakingDao.getTopMatchesForBuyer(buyerId, 5);
    }

    // ─── Private helpers ───────────────────────────────────────────────────────

    /**
     * Haversine formula to calculate the great-circle distance between two lat/lng points.
     *
     * @return distance in kilometres
     */
    private double haversine(double lat1, double lon1, double lat2, double lon2) {
        final int R = 6371; // Earth radius in km
        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }

    /**
     * Lightweight district→centroid lookup table.
     * Returns representative latitude for buyer's first preferred district.
     */
    private double getDistrictCentroidLat(BuyerProfile buyer) {
        String firstDistrict = parseFirstDistrict(buyer);
        if (firstDistrict == null) return 0.0;
        return switch (firstDistrict.toLowerCase()) {
            case "kangra"   -> 32.1109;
            case "pune"     -> 18.5204;
            case "surat"    -> 21.1702;
            case "moga"     -> 30.8165;
            case "hassan"   -> 13.0072;
            case "nashik"   -> 19.9975;
            case "mumbai"   -> 19.0760;
            default         -> 20.5937; // India centroid as fallback
        };
    }

    private double getDistrictCentroidLng(BuyerProfile buyer) {
        String firstDistrict = parseFirstDistrict(buyer);
        if (firstDistrict == null) return 0.0;
        return switch (firstDistrict.toLowerCase()) {
            case "kangra"   -> 76.5363;
            case "pune"     -> 73.8567;
            case "surat"    -> 72.8311;
            case "moga"     -> 75.1717;
            case "hassan"   -> 76.1016;
            case "nashik"   -> 73.7898;
            case "mumbai"   -> 72.8777;
            default         -> 78.9629; // India centroid as fallback
        };
    }

    private String parseFirstDistrict(BuyerProfile buyer) {
        if (buyer.getPreferredDistricts() == null || buyer.getPreferredDistricts().isBlank()) {
            return null;
        }
        try {
            List<String> districts = mapper.readValue(
                buyer.getPreferredDistricts(), new TypeReference<List<String>>() {});
            return districts.isEmpty() ? null : districts.get(0);
        } catch (Exception e) {
            // Try plain string (non-JSON)
            return buyer.getPreferredDistricts().trim();
        }
    }

    private List<String> parseJsonArray(String json) {
        if (json == null || json.isBlank()) {
            return Collections.emptyList();
        }
        try {
            return mapper.readValue(json, new TypeReference<List<String>>() {});
        } catch (Exception ex) {
            return List.of(json);
        }
    }
}
