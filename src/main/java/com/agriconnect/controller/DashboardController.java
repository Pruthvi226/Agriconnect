package com.agriconnect.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import java.util.List;

@Controller
@RequestMapping("/web/dashboard")
public class DashboardController {

    @Autowired
    private com.agriconnect.service.ListingService listingService;

    @Autowired
    private com.agriconnect.service.MatchmakingService matchmakingService;

    @GetMapping("/farmer")
    public ModelAndView farmerDashboard() {
        ModelAndView mav = new ModelAndView("dashboard");
        mav.addObject("role", "Farmer");
        // Feature 2: Smart Matchmaking
        mav.addObject("matches", matchmakingService.getRecommendedBuyersForFarmer(1L)); // stub farmer 1L
        return mav;
    }

    @GetMapping("/buyer")
    public ModelAndView buyerDashboard() {
        ModelAndView mav = new ModelAndView("dashboard");
        mav.addObject("role", "Buyer");
        // Feature 2: Smart Matchmaking
        mav.addObject("matches", matchmakingService.getRecommendedFarmersForBuyer(1L)); // stub buyer 1L
        return mav;
    }

    @GetMapping("/expert")
    public ModelAndView expertDashboard() {
        ModelAndView mav = new ModelAndView("dashboard");
        mav.addObject("role", "Agri-Expert");
        return mav;
    }

    @GetMapping("/admin")
    public ModelAndView adminDashboard() {
        ModelAndView mav = new ModelAndView("dashboard");
        mav.addObject("role", "Administrator");
        
        // Feature 1: Admin panel aggregate stats
        List<com.agriconnect.model.ProduceListing> allListings = listingService.searchListings(new com.agriconnect.dto.SearchFiltersDto());
        long belowMspCount = 0;
        for (com.agriconnect.model.ProduceListing listing : allListings) {
            if (listing.getMspPricePerKg() != null && listing.getAskingPricePerKg().compareTo(listing.getMspPricePerKg()) < 0) {
                belowMspCount++;
            }
        }
        double belowMspPercentage = allListings.isEmpty() ? 0 : ((double) belowMspCount / allListings.size()) * 100;
        mav.addObject("belowMspPercentage", String.format("%.1f", belowMspPercentage));
        
        return mav;
    }

    @GetMapping("/farmer/profile")
    public ModelAndView getFarmerProfile() {
        ModelAndView mav = new ModelAndView("farmer-profile");
        // Stub farmer
        com.agriconnect.model.FarmerProfile farmer = new com.agriconnect.model.FarmerProfile();
        farmer.setFarmerScore(new java.math.BigDecimal("82.50"));
        mav.addObject("farmer", farmer);
        
        double score = farmer.getFarmerScore().doubleValue();
        String color = "red";
        if (score >= 40 && score < 70) color = "orange";
        else if (score >= 70) color = "green";
        
        String badge = "New Farmer";
        if (score >= 40 && score < 70) badge = "Reliable";
        else if (score >= 70 && score < 90) badge = "Top Seller";
        else if (score >= 90) badge = "Elite";
        
        mav.addObject("scoreColor", color);
        mav.addObject("scoreBadge", badge);
        
        return mav;
    }
}
