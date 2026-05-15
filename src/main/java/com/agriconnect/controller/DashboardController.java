package com.agriconnect.controller;

import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.model.Advisory;
import com.agriconnect.model.Bid;
import com.agriconnect.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;

@Controller
public class DashboardController {



    @Autowired
    private com.agriconnect.service.MatchmakingService matchmakingService;

    @Autowired
    private com.agriconnect.service.BidService bidService;


    @Autowired
    private com.agriconnect.dao.BuyerProfileDao buyerProfileDao;

    @Autowired
    private com.agriconnect.service.AdvisoryAlertService advisoryAlertService;



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
        Long userId = userDetails.getId();
        
        com.agriconnect.model.BuyerProfile buyer = buyerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new com.agriconnect.exception.ResourceNotFoundException("Buyer profile not found"));
        List<Bid> bids = bidService.getBidsForBuyerUser(userId);
        List<Order> orders = bidService.getOrdersForBuyerUser(userId);
        var matches = matchmakingService.getRecommendedFarmersForBuyer(buyer.getId());

        mav.addObject("buyer", buyer);
        mav.addObject("matches", matches);
        mav.addObject("matchCount", matches.size());
        mav.addObject("activeBidCount", bids.size());
        mav.addObject("orderCount", orders.size());
        mav.addObject("activeOrderCount", orders.stream()
                .filter(order -> order.getOrderStatus() == Order.OrderStatus.CONFIRMED
                        || order.getOrderStatus() == Order.OrderStatus.IN_TRANSIT)
                .count());
        mav.addObject("deliveredOrderCount", orders.stream()
                .filter(order -> order.getOrderStatus() == Order.OrderStatus.DELIVERED)
                .count());
        return mav;
    }

    @GetMapping("/web/buyer/bids")
    public ModelAndView buyerBids(Authentication authentication) {
        ModelAndView mav = new ModelAndView("buyer/bids");
        com.agriconnect.security.CustomUserDetails userDetails = (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
        mav.addObject("bids", bidService.getBidsForBuyerUser(userDetails.getId()));
        return mav;
    }

    @PostMapping("/web/buyer/bids")
    public String placeBuyerBid(@ModelAttribute BidRequestDto dto,
                                Authentication authentication,
                                RedirectAttributes redirectAttributes) {
        try {
            com.agriconnect.security.CustomUserDetails userDetails =
                    (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
            bidService.placeBidForUser(dto, userDetails.getId());
            redirectAttributes.addFlashAttribute("msg", "Bid placed successfully.");
            return "redirect:/web/buyer/bids";
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return dto.getListingId() != null
                    ? "redirect:/web/marketplace/listing/" + dto.getListingId()
                    : "redirect:/web/marketplace";
        }
    }

    @GetMapping("/web/buyer/orders")
    public ModelAndView buyerOrders(Authentication authentication) {
        ModelAndView mav = new ModelAndView("buyer/orders");
        com.agriconnect.security.CustomUserDetails userDetails = (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
        mav.addObject("orders", bidService.getOrdersForBuyerUser(userDetails.getId()));
        return mav;
    }

    @PostMapping("/web/buyer/orders/{id}/confirm-delivery")
    public String confirmBuyerDelivery(@PathVariable("id") Long id,
                                       Authentication authentication,
                                       RedirectAttributes redirectAttributes) {
        try {
            com.agriconnect.security.CustomUserDetails userDetails =
                    (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
            bidService.confirmDeliveryForBuyerUser(id, userDetails.getId());
            redirectAttributes.addFlashAttribute("msg", "Delivery confirmed and receipt updated.");
            return "redirect:/web/buyer/orders/" + id + "/receipt";
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/web/buyer/orders";
        }
    }

    @GetMapping("/web/buyer/orders/{id}/receipt")
    public ModelAndView buyerReceipt(@PathVariable("id") Long id, Authentication authentication) {
        ModelAndView mav = new ModelAndView("buyer/receipt");
        com.agriconnect.security.CustomUserDetails userDetails =
                (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
        mav.addObject("order", bidService.getOrderForBuyerUser(id, userDetails.getId()));
        return mav;
    }

    @PostMapping("/web/buyer/bids/{id}/accept-counter")
    public String acceptCounterOffer(@PathVariable("id") Long id,
                                     Authentication authentication,
                                     RedirectAttributes redirectAttributes) {
        try {
            com.agriconnect.security.CustomUserDetails userDetails =
                    (com.agriconnect.security.CustomUserDetails) authentication.getPrincipal();
            bidService.acceptCounterOfferForUser(id, userDetails.getId());
            redirectAttributes.addFlashAttribute("msg", "Counter offer accepted and order created.");
            return "redirect:/web/buyer/orders";
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/web/buyer/bids";
        }
    }

    @GetMapping("/web/expert/dashboard")
    public ModelAndView expertDashboard() {
        ModelAndView mav = new ModelAndView("expert/dashboard");
        mav.addObject("role", "Agri-Expert");
        List<Advisory> advisories = advisoryAlertService.getAllAdvisories();
        mav.addObject("advisories", advisories);
        mav.addObject("advisoryCount", advisories.size());
        mav.addObject("criticalAdvisoryCount", advisories.stream()
                .filter(advisory -> advisory.getSeverity() == Advisory.Severity.CRITICAL)
                .count());
        mav.addObject("activeAdvisoryCount", advisories.stream()
                .filter(advisory -> advisory.getValidUntil() == null
                        || !advisory.getValidUntil().isBefore(LocalDate.now()))
                .count());
        return mav;
    }



}
