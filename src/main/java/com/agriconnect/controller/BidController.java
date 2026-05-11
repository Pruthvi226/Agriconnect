package com.agriconnect.controller;

import com.agriconnect.dto.ApiResponse;
import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.model.Bid;
import com.agriconnect.model.Order;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.BidService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/bids")
public class BidController {

    @Autowired
    private BidService bidService;

    @PostMapping
    public ResponseEntity<ApiResponse<Bid>> placeBid(@Valid @RequestBody BidRequestDto dto,
                                                     Authentication authentication) {
        if (authentication == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("User not authenticated"));
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Bid bid = bidService.placeBidForUser(dto, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(bid, "Booking request sent successfully"));
    }

    @PutMapping("/{id}/accept")
    public ResponseEntity<ApiResponse<Order>> acceptBid(@PathVariable("id") Long id,
                                                       Authentication authentication) {
        if (authentication == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("User not authenticated"));
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Order order = bidService.acceptBidForUser(id, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(order, "Booking accepted and order created"));
    }

    @PutMapping("/{id}/accept-counter")
    public ResponseEntity<ApiResponse<Order>> acceptCounterOffer(@PathVariable("id") Long id,
                                                               Authentication authentication) {
        if (authentication == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("User not authenticated"));
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Order order = bidService.acceptCounterOfferForUser(id, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(order, "Counter offer accepted and order created"));
    }

    @PutMapping("/{id}/reject")
    public ResponseEntity<ApiResponse<Bid>> rejectBid(@PathVariable("id") Long id,
                                                     Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Bid bid = bidService.rejectBidForUser(id, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(bid, "Booking request rejected"));
    }

    @PutMapping("/orders/{id}/delivery/{action}")
    public ResponseEntity<ApiResponse<Order>> updateDelivery(@PathVariable("id") Long id,
                                                            @PathVariable("action") String action,
                                                            Authentication authentication) {
        if (authentication == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("User not authenticated"));
        }
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Order order = bidService.updateOrderDeliveryStatus(id, action, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(order, "Delivery status updated"));
    }

    @GetMapping("/my")
    public ResponseEntity<ApiResponse<List<Bid>>> getMyBids(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        List<Bid> bids = bidService.getBidsForBuyerUser(userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(bids, "Your active bids"));
    }

    @GetMapping("/listings/{listingId}/bid-rank")
    public ResponseEntity<ApiResponse<com.agriconnect.dto.BidRankDto>> getBidRank(@PathVariable("listingId") Long listingId,
                                                                                 Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        com.agriconnect.dto.BidRankDto dto = bidService.getBidRankForUser(listingId, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(dto, "Bid rank fetched"));
    }
}


