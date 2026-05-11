package com.agriconnect.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
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

    @Autowired
    private com.agriconnect.service.BidService bidService;

    @Autowired
    private com.agriconnect.dao.FarmerProfileDao farmerProfileDao;

    @Autowired
    private com.agriconnect.dao.BuyerProfileDao buyerProfileDao;

    @Autowired
    private com.agriconnect.service.UserService userService;

    @Autowired
    private com.agriconnect.service.EarningsService earningsService;

    @Autowired
    private com.agriconnect.service.AdvisoryAlertService advisoryAlertService;

    @GetMapping("/buyer")
    public ModelAndView buyerDashboard(Authentication authentication) {
        ModelAndView mav = new ModelAndView("buyer-dashboard");
        mav.addObject("role", "Buyer");
        com.agriconnect.security.CustomUserDetails userDetails = (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
        
        com.agriconnect.model.BuyerProfile buyer = buyerProfileDao.findByUserId(userDetails.getId())
                .orElseThrow(() -> new com.agriconnect.exception.ResourceNotFoundException("Buyer profile not found"));
        
        mav.addObject("buyer", buyer);
        mav.addObject("matches", matchmakingService.getRecommendedFarmersForBuyer(buyer.getId()));
        return mav;
    }

    @GetMapping("/buyer/bids")
    public ModelAndView buyerBids(Authentication authentication) {
        ModelAndView mav = new ModelAndView("buyer-bids");
        com.agriconnect.security.CustomUserDetails userDetails = (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
        mav.addObject("bids", bidService.getBidsForBuyerUser(userDetails.getId()));
        return mav;
    }

    @GetMapping("/buyer/orders")
    public ModelAndView buyerOrders(Authentication authentication) {
        ModelAndView mav = new ModelAndView("buyer-orders");
        com.agriconnect.security.CustomUserDetails userDetails = (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
        mav.addObject("orders", bidService.getOrdersForBuyerUser(userDetails.getId()));
        return mav;
    }

    @GetMapping("/expert")
    public ModelAndView expertDashboard() {
        ModelAndView mav = new ModelAndView("expert-dashboard");
        mav.addObject("role", "Agri-Expert");
        return mav;
    }

    @GetMapping("/admin")
    public ModelAndView adminDashboard() {
        ModelAndView mav = new ModelAndView("admin-dashboard");
        mav.addObject("role", "Administrator");
        
        // Admin panel aggregate stats
        List<com.agriconnect.model.ProduceListing> allListings = listingService.searchListings(new com.agriconnect.dto.SearchFiltersDto());
        long belowMspCount = allListings.stream()
                .filter(l -> l.getMspPricePerKg() != null && l.getAskingPricePerKg().compareTo(l.getMspPricePerKg()) < 0)
                .count();
        
        double belowMspPercentage = allListings.isEmpty() ? 0 : ((double) belowMspCount / allListings.size()) * 100;
        mav.addObject("belowMspPercentage", String.format("%.1f", belowMspPercentage));
        mav.addObject("allUsers", userService.getAllUsers());
        mav.addObject("listingCount", allListings.size());
        
        return mav;
    }

}
