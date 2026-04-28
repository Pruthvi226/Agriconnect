package com.agriconnect.controller;

import com.agriconnect.dto.ApiResponse;
import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.model.Bid;
import com.agriconnect.model.Order;
import com.agriconnect.service.BidService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/bids")
public class BidController {

    @Autowired
    private BidService bidService;

    @PostMapping
    public ResponseEntity<ApiResponse<Bid>> placeBid(@Valid @RequestBody BidRequestDto dto) {
        // Stub buyerId
        Bid bid = bidService.placeBid(dto, 1L);
        return ResponseEntity.ok(ApiResponse.success(bid, "Bid placed successfully"));
    }

    @PutMapping("/{id}/accept")
    public ResponseEntity<ApiResponse<Order>> acceptBid(@PathVariable Long id) {
        // Stub farmerId
        Order order = bidService.acceptBid(id, 1L);
        return ResponseEntity.ok(ApiResponse.success(order, "Bid accepted and order created"));
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
