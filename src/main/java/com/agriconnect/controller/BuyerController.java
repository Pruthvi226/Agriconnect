package com.agriconnect.controller;

import com.agriconnect.dao.BuyerProfileDao;
import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.dto.SearchFiltersDto;
import com.agriconnect.model.Bid;
import com.agriconnect.model.Order;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.BidService;
import com.agriconnect.service.ListingService;
import com.agriconnect.service.MatchmakingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/buyer")
public class BuyerController {

    @Autowired
    private ListingService listingService;

    @Autowired
    private BidService bidService;

    @Autowired
    private MatchmakingService matchmakingService;

    @Autowired
    private BuyerProfileDao buyerProfileDao;

    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        Long userId = userId(authentication);
        List<Bid> bids = bidService.getBidsForBuyerUser(userId);
        List<Order> orders = bidService.getOrdersForBuyerUser(userId);
        model.addAttribute("activeBidCount", bids.size());
        model.addAttribute("orderCount", orders.size());
        buyerProfileDao.findByUserId(userId).ifPresent(buyer -> {
            model.addAttribute("buyer", buyer);
            model.addAttribute("matches", matchmakingService.getRecommendedFarmersForBuyer(buyer.getId()));
            model.addAttribute("matchCount", matchmakingService.getRecommendedFarmersForBuyer(buyer.getId()).size());
        });
        return "buyer/dashboard";
    }

    @GetMapping("/search")
    public String search(@ModelAttribute SearchFiltersDto filters, Model model) {
        List<ProduceListing> results = listingService.searchListings(filters);
        model.addAttribute("filters", filters);
        model.addAttribute("results", results);
        model.addAttribute("bid", new BidRequestDto());
        return "buyer/search";
    }

    @PostMapping("/bids")
    public String placeBid(@ModelAttribute BidRequestDto dto, Authentication authentication) {
        bidService.placeBidForUser(dto, userId(authentication));
        return "redirect:/buyer/bids";
    }

    @GetMapping("/matches")
    public String matches(Authentication authentication, Model model) {
        buyerProfileDao.findByUserId(userId(authentication))
                .ifPresent(buyer -> model.addAttribute("matches", matchmakingService.getRecommendedFarmersForBuyer(buyer.getId())));
        return "buyer/search";
    }

    @GetMapping("/bids")
    public String bids(Authentication authentication, Model model) {
        model.addAttribute("bids", bidService.getBidsForBuyerUser(userId(authentication)));
        return "buyer/bids";
    }

    @GetMapping("/orders")
    public String orders(Authentication authentication, Model model) {
        model.addAttribute("orders", bidService.getOrdersForBuyerUser(userId(authentication)));
        return "buyer/orders";
    }

    private Long userId(Authentication authentication) {
        return ((CustomUserDetails) authentication.getPrincipal()).getId();
    }
}
