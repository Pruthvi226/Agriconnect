package com.agriconnect.controller;

import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dto.ListingRequestDto;
import com.agriconnect.model.Bid;
import com.agriconnect.model.Order;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.BidService;
import com.agriconnect.service.ListingService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/farmer")
public class FarmerController {

    @Autowired
    private ListingService listingService;

    @Autowired
    private BidService bidService;

    @Autowired
    private FarmerProfileDao farmerProfileDao;

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        Long userId = userId(authentication);
        List<ProduceListing> listings = listingService.getListingsForFarmerUser(userId);
        List<Bid> bids = bidService.getPendingBookingsForFarmerUser(userId);
        List<Order> orders = bidService.getOrdersForFarmerUser(userId);
        model.addAttribute("listingCount", listings.size());
        model.addAttribute("bidCount", bids.size());
        model.addAttribute("orderCount", orders.size());
        model.addAttribute("recentListings", listings.stream().limit(5).toList());
        farmerProfileDao.findByUserId(userId).ifPresent(farmer -> model.addAttribute("farmer", farmer));
        return "farmer/dashboard";
    }

    @GetMapping("/listings")
    public String listings(Authentication authentication, Model model) {
        model.addAttribute("farmerListings", listingService.getListingsForFarmerUser(userId(authentication)));
        return "farmer/listings";
    }

    @GetMapping("/listings/new")
    public String newListing(Model model) {
        model.addAttribute("listing", new ListingRequestDto());
        return "farmer/listing-form";
    }

    @PostMapping("/listings")
    public String createListing(@Valid @ModelAttribute("listing") ListingRequestDto dto,
                                BindingResult result,
                                Authentication authentication) {
        if (result.hasErrors()) {
            return "farmer/listing-form";
        }
        listingService.createListingForUser(dto, userId(authentication));
        return "redirect:/farmer/listings";
    }

    @GetMapping("/listings/{id}")
    public String listing(@PathVariable("id") Long id, Model model) {
        model.addAttribute("listing", listingService.getListingById(id));
        return "farmer/listing-form";
    }

    @GetMapping("/bids")
    public String bids(Authentication authentication, Model model) {
        model.addAttribute("bids", bidService.getPendingBookingsForFarmerUser(userId(authentication)));
        return "farmer/bids";
    }

    @GetMapping("/orders")
    public String orders(Authentication authentication, Model model) {
        model.addAttribute("orders", bidService.getOrdersForFarmerUser(userId(authentication)));
        return "farmer/orders";
    }

    @PostMapping("/bids/{id}/accept")
    public String accept(@PathVariable("id") Long id, Authentication authentication) {
        bidService.acceptBidForUser(id, userId(authentication));
        return "redirect:/farmer/bids";
    }

    @PostMapping("/bids/{id}/reject")
    public String reject(@PathVariable("id") Long id, Authentication authentication) {
        bidService.rejectBidForUser(id, userId(authentication));
        return "redirect:/farmer/bids";
    }

    private Long userId(Authentication authentication) {
        return ((CustomUserDetails) authentication.getPrincipal()).getId();
    }
}
