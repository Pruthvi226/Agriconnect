package com.agriconnect.rest;

import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.model.Bid;
import com.agriconnect.model.Order;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.BidService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/bids")
public class BidRestController {

    @Autowired
    private BidService bidService;

    @PostMapping
    public ResponseEntity<Map<String, Object>> placeBid(@Valid @RequestBody BidRequestDto dto,
                                                       Authentication authentication) {
        CustomUserDetails user = (CustomUserDetails) authentication.getPrincipal();
        Bid bid = bidService.placeBidForUser(dto, user.getId());
        return ResponseEntity.status(HttpStatus.CREATED).body(Map.of(
                "id", bid.getId(),
                "status", bid.getBidStatus().name()));
    }

    @PutMapping("/{id}/accept")
    public ResponseEntity<Map<String, Object>> accept(@PathVariable("id") Long id,
                                                     Authentication authentication) {
        CustomUserDetails user = (CustomUserDetails) authentication.getPrincipal();
        Order order = bidService.acceptBidForUser(id, user.getId());
        return ResponseEntity.ok(Map.of(
                "orderId", order.getId(),
                "status", order.getOrderStatus().name()));
    }

    @PutMapping("/{id}/reject")
    public ResponseEntity<Map<String, Object>> reject(@PathVariable("id") Long id,
                                                     Authentication authentication) {
        CustomUserDetails user = (CustomUserDetails) authentication.getPrincipal();
        Bid bid = bidService.rejectBidForUser(id, user.getId());
        return ResponseEntity.ok(Map.of("id", bid.getId(), "status", bid.getBidStatus().name()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handle(Exception ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", ex.getMessage()));
    }
}
