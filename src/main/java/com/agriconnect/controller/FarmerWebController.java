package com.agriconnect.controller;

import com.agriconnect.dto.EarningsDto;
import com.agriconnect.dto.ListingRequestDto;
import com.agriconnect.model.*;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.*;
import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.exception.ResourceNotFoundException;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/web/farmer")
public class FarmerWebController {

    @Autowired
    private ListingService listingService;

    @Autowired
    private MatchmakingService matchmakingService;

    @Autowired
    private BidService bidService;

    @Autowired
    private FarmerProfileDao farmerProfileDao;

    @Autowired
    private EarningsService earningsService;

    @Autowired
    private AdvisoryAlertService advisoryAlertService;

    @GetMapping("/dashboard")
    public ModelAndView farmerDashboard(Authentication authentication) {
        ModelAndView mav = new ModelAndView("farmer-dashboard");
        mav.addObject("role", "Farmer");
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getId();

        FarmerProfile farmer = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));

        List<Bid> pendingBookings = bidService.getPendingBookingsForFarmerUser(userId);
        List<Order> farmerOrders = bidService.getOrdersForFarmerUser(userId);
        List<ProduceListing> farmerListings = listingService.getListingsForFarmerUser(userId);

        mav.addObject("farmer", farmer);
        mav.addObject("pendingBookings", pendingBookings);
        mav.addObject("farmerOrders", farmerOrders);
        mav.addObject("farmerListings", farmerListings);
        mav.addObject("pendingBookingCount", pendingBookings.size());
        mav.addObject("listingCount", farmerListings.size());
        mav.addObject("activeOrderCount", farmerOrders.stream()
                .filter(order -> order.getOrderStatus() == Order.OrderStatus.CONFIRMED
                        || order.getOrderStatus() == Order.OrderStatus.IN_TRANSIT)
                .count());
        mav.addObject("deliveredOrderCount", farmerOrders.stream()
                .filter(order -> order.getOrderStatus() == Order.OrderStatus.DELIVERED)
                .count());

        mav.addObject("earnings", earningsService.getEarningsForFarmer(userId));
        mav.addObject("advisories", advisoryAlertService.getActiveAdvisoriesForDistrict(farmer.getDistrict()));
        
        List<Bid> latestBids = pendingBookings.stream()
                .sorted((b1, b2) -> {
                    if (b1.getCreatedAt() == null) return 1;
                    if (b2.getCreatedAt() == null) return -1;
                    return b2.getCreatedAt().compareTo(b1.getCreatedAt());
                })
                .limit(3)
                .toList();
        mav.addObject("latestBids", latestBids);
        mav.addObject("matches", matchmakingService.getRecommendedBuyersForFarmer(farmer.getId()));
        
        return mav;
    }

    @GetMapping("/listings")
    public ModelAndView farmerListings(Authentication authentication) {
        ModelAndView mav = new ModelAndView("farmer-listings");
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        mav.addObject("farmerListings", listingService.getListingsForFarmerUser(userId));
        return mav;
    }

    @PostMapping("/listings")
    public String createListing(@Valid @ModelAttribute ListingRequestDto dto,
                                BindingResult bindingResult,
                                Authentication authentication,
                                RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("error", bindingResult.getAllErrors().get(0).getDefaultMessage());
            return "redirect:/web/farmer/listings";
        }

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        ProduceListing listing = listingService.createListingForUser(dto, userDetails.getId());
        redirectAttributes.addFlashAttribute("msg", "Listing created. Add photos to improve buyer trust.");
        return "redirect:/web/farmer/listings/" + listing.getId() + "/photos";
    }

    @PostMapping("/listings/{id}/withdraw")
    public String withdrawListing(@PathVariable("id") Long id,
                                  Authentication authentication,
                                  RedirectAttributes redirectAttributes) {
        try {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            listingService.withdrawListingForUser(id, userDetails.getId());
            redirectAttributes.addFlashAttribute("msg", "Listing withdrawn from the marketplace.");
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/web/farmer/listings";
    }

    @PostMapping("/listings/{id}/reactivate")
    public String reactivateListing(@PathVariable("id") Long id,
                                    Authentication authentication,
                                    RedirectAttributes redirectAttributes) {
        try {
            CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
            listingService.reactivateListingForUser(id, userDetails.getId());
            redirectAttributes.addFlashAttribute("msg", "Listing reactivated and visible to buyers.");
        } catch (RuntimeException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/web/farmer/listings";
    }

    @GetMapping("/listings/{id}/photos")
    public ModelAndView getListingPhotos(@PathVariable("id") Long id) {
        ModelAndView mav = new ModelAndView("farmer/listing-photos");
        mav.addObject("listingId", id);
        return mav;
    }

    @GetMapping("/bookings")
    public ModelAndView farmerBookings(Authentication authentication) {
        ModelAndView mav = new ModelAndView("farmer-bookings");
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        List<Bid> pendingBookings = bidService.getPendingBookingsForFarmerUser(userId);
        List<Order> farmerOrders = bidService.getOrdersForFarmerUser(userId);
        mav.addObject("pendingBookings", pendingBookings);
        mav.addObject("farmerOrders", farmerOrders);
        mav.addObject("pendingBookingCount", pendingBookings.size());
        mav.addObject("activeOrderCount", farmerOrders.stream()
                .filter(order -> order.getOrderStatus() == Order.OrderStatus.CONFIRMED
                        || order.getOrderStatus() == Order.OrderStatus.IN_TRANSIT)
                .count());
        return mav;
    }

    @GetMapping("/earnings")
    public String showEarnings(@AuthenticationPrincipal CustomUserDetails user, Model model) {
        if (user == null) return "redirect:/web/login";
        EarningsDto earnings = earningsService.getEarningsForFarmer(user.getId());
        model.addAttribute("earnings", earnings);
        return "farmer/earnings";
    }

    @GetMapping("/profile")
    public ModelAndView getFarmerProfile(Authentication authentication) {
        ModelAndView mav = new ModelAndView("farmer-profile");
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        FarmerProfile farmer = farmerProfileDao.findByUserId(userDetails.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        
        mav.addObject("farmer", farmer);
        
        double score = farmer.getFarmerScore() != null ? farmer.getFarmerScore().doubleValue() : 50.0;
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

    // Bid Actions (Merged from BidWebController)
    @PostMapping("/bids/{id}/accept")
    public String acceptBid(@PathVariable("id") Long id, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        bidService.acceptBidForUser(id, userDetails.getId());
        return "redirect:/web/farmer/bookings";
    }

    @PostMapping("/bids/{id}/reject")
    public String rejectBid(@PathVariable("id") Long id, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        bidService.rejectBidForUser(id, userDetails.getId());
        return "redirect:/web/farmer/bookings";
    }

    @PostMapping("/bids/{id}/counter")
    public String counterBid(@PathVariable("id") Long id, 
                             @RequestParam("counterPrice") BigDecimal counterPrice,
                             @RequestParam("counterMessage") String counterMessage,
                             Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        bidService.counterBid(id, counterPrice, counterMessage, userDetails.getId());
        return "redirect:/web/farmer/bookings";
    }

    @PostMapping("/orders/{id}/status")
    public String updateStatus(@PathVariable("id") Long id, @RequestParam("action") String action, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        bidService.updateOrderDeliveryStatus(id, action, userDetails.getId());
        return "redirect:/web/farmer/bookings";
    }
}
