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
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Bid bid = bidService.placeBidForUser(dto, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(bid, "Booking request sent successfully"));
    }

    @PutMapping("/{id}/accept")
    public ResponseEntity<ApiResponse<Order>> acceptBid(@PathVariable Long id,
                                                       Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Order order = bidService.acceptBidForUser(id, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(order, "Booking accepted and order created"));
    }

    @PutMapping("/{id}/reject")
    public ResponseEntity<ApiResponse<Bid>> rejectBid(@PathVariable Long id,
                                                     Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Bid bid = bidService.rejectBidForUser(id, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(bid, "Booking request rejected"));
    }

    @PutMapping("/orders/{id}/delivery/{action}")
    public ResponseEntity<ApiResponse<Order>> updateDelivery(@PathVariable Long id,
                                                            @PathVariable String action,
                                                            Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Order order = bidService.updateOrderDeliveryStatus(id, action, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(order, "Delivery status updated"));
    }

    @GetMapping("/my")
    public ResponseEntity<ApiResponse<List<Bid>>> getMyBids() {
        // Stub retrieving bids for buyer 1L
        return ResponseEntity.ok(ApiResponse.success(null, "Not implemented - stub"));
    }

    @GetMapping("/listings/{listingId}/bid-rank")
    public ResponseEntity<ApiResponse<com.agriconnect.dto.BidRankDto>> getBidRank(@PathVariable Long listingId) {
        // Stub buyerId = 1L
        com.agriconnect.dto.BidRankDto dto = bidService.getAnonymisedBidRankingFull(listingId, 1L);
        return ResponseEntity.ok(ApiResponse.success(dto, "Bid rank fetched"));
    }
}
