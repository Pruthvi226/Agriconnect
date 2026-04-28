package com.agriconnect.service;

import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.Order;
import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.OrderDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Service
@Transactional
public class FarmerScoreService {

    @Autowired
    private BaseDao<FarmerProfile, Long> farmerDao;

    @Autowired
    private OrderDao orderDao;

    @Scheduled(cron = "0 0 3 * * ?") // 3 AM every day
    public void recomputeAllScores() {
        System.out.println("Starting Nightly Farmer Score Computation in Java...");
        List<FarmerProfile> farmers = farmerDao.findAll();
        for (FarmerProfile farmer : farmers) {
            double finalScore = calculateScoreForFarmer(farmer);
            farmer.setFarmerScore(BigDecimal.valueOf(finalScore));
            farmerDao.update(farmer);
        }
        System.out.println("Computed scores for " + farmers.size() + " farmers.");
    }

    private double calculateScoreForFarmer(FarmerProfile farmer) {
        List<Order> orders = orderDao.findByFarmer(farmer.getId(), null);
        
        long totalOrders = orders.size();
        if (totalOrders == 0) return 50.0; // Default for new farmers

        long deliveredOrders = orders.stream().filter(o -> o.getOrderStatus() == Order.OrderStatus.DELIVERED).count();
        long onTimeOrders = orders.stream().filter(o -> o.getOrderStatus() == Order.OrderStatus.DELIVERED && 
                            (o.getActualDelivery() != null && o.getExpectedDelivery() != null && !o.getActualDelivery().isAfter(o.getExpectedDelivery()))).count();
        long disputedOrders = orders.stream().filter(o -> o.getOrderStatus() == Order.OrderStatus.DISPUTED).count();
        
        double totalKg = orders.stream().filter(o -> o.getOrderStatus() == Order.OrderStatus.DELIVERED)
                .mapToDouble(o -> o.getQuantityKg().doubleValue()).sum();

        double deliveryScore = deliveredOrders == 0 ? 0 : ((double) onTimeOrders / deliveredOrders) * 100.0;
        double qualityScore = 100.0 - (((double) disputedOrders / totalOrders) * 100.0);
        double volumeScore = Math.min(100.0, (totalKg / 10000.0) * 100.0);
        
        // Profile Score
        int totalFields = 5;
        int filled = 0;
        if (farmer.getVillage() != null) filled++;
        if (farmer.getDistrict() != null) filled++;
        if (farmer.getState() != null) filled++;
        if (farmer.getLandAcres() != null) filled++;
        if (farmer.getBankAccountEncrypted() != null) filled++;
        double profileScore = ((double) filled / totalFields) * 100.0;

        return (deliveryScore * 0.40) + (qualityScore * 0.30) + (volumeScore * 0.20) + (profileScore * 0.10);
    }
}
