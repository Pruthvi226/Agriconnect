package com.agriconnect.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class DashboardController {



    @Autowired
    private com.agriconnect.service.MatchmakingService matchmakingService;

    @Autowired
    private com.agriconnect.service.BidService bidService;


    @Autowired
    private com.agriconnect.dao.BuyerProfileDao buyerProfileDao;




    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/auth/login";
        }
        for (GrantedAuthority authority : authentication.getAuthorities()) {
            String role = authority.getAuthority();
            if ("ROLE_FARMER".equals(role)) {
                return "redirect:/web/farmer/dashboard";
            }
            if ("ROLE_BUYER".equals(role)) {
                return "redirect:/web/buyer/dashboard";
            }
            if ("ROLE_ADMIN".equals(role)) {
                return "redirect:/web/admin/dashboard";
            }
            if ("ROLE_AGRI_EXPERT".equals(role)) {
                return "redirect:/web/expert/dashboard";
            }
        }
        return "redirect:/auth/login";
    }

    @GetMapping("/web/buyer/dashboard")
    public ModelAndView buyerDashboard(Authentication authentication) {
        ModelAndView mav = new ModelAndView("buyer/dashboard");
        mav.addObject("role", "Buyer");
        com.agriconnect.security.CustomUserDetails userDetails = (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
        
        com.agriconnect.model.BuyerProfile buyer = buyerProfileDao.findByUserId(userDetails.getId())
                .orElseThrow(() -> new com.agriconnect.exception.ResourceNotFoundException("Buyer profile not found"));
        
        mav.addObject("buyer", buyer);
        mav.addObject("matches", matchmakingService.getRecommendedFarmersForBuyer(buyer.getId()));
        return mav;
    }

    @GetMapping("/web/buyer/bids")
    public ModelAndView buyerBids(Authentication authentication) {
        ModelAndView mav = new ModelAndView("buyer/bids");
        com.agriconnect.security.CustomUserDetails userDetails = (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
        mav.addObject("bids", bidService.getBidsForBuyerUser(userDetails.getId()));
        return mav;
    }

    @GetMapping("/web/buyer/orders")
    public ModelAndView buyerOrders(Authentication authentication) {
        ModelAndView mav = new ModelAndView("buyer/orders");
        com.agriconnect.security.CustomUserDetails userDetails = (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
        mav.addObject("orders", bidService.getOrdersForBuyerUser(userDetails.getId()));
        return mav;
    }

    @GetMapping("/web/expert/dashboard")
    public ModelAndView expertDashboard() {
        ModelAndView mav = new ModelAndView("expert/dashboard");
        mav.addObject("role", "Agri-Expert");
        return mav;
    }



}
