package com.agriconnect.controller;

import com.agriconnect.dto.ApiResponse;
import com.agriconnect.dto.ListingRequestDto;
import com.agriconnect.dto.ListingResponseDto;
import com.agriconnect.dto.SearchFiltersDto;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.ListingService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@RestController
@RequestMapping("/api/v1/listings")
public class ListingController {

    @Autowired
    private ListingService listingService;

    @PostMapping
    public ResponseEntity<ApiResponse<ListingResponseDto>> createListing(@Valid @RequestBody ListingRequestDto dto,
                                                                         Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        ProduceListing listing = listingService.createListingForUser(dto, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success(new ListingResponseDto(listing), "Listing created successfully"));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<ListingResponseDto>>> searchListings(SearchFiltersDto filters) {
        List<ProduceListing> results = listingService.searchListings(filters);
        List<ListingResponseDto> dtos = results.stream().map(ListingResponseDto::new).toList();
        return ResponseEntity.ok(ApiResponse.success(dtos, "Search completed"));
    }

    @GetMapping("/{id}/msp-comparison")
    public ResponseEntity<ApiResponse<String>> getMspComparison(@PathVariable Long id) {
        String comparison = listingService.getMspComparison(id);
        return ResponseEntity.ok(ApiResponse.success(comparison, "MSP comparison retrieved"));
    }
}

// Additional Web Controller for JSP rendering
@Controller
@RequestMapping("/web/marketplace")
class MarketplaceWebController {
    @Autowired
    private ListingService listingService;
    @Autowired
    private com.agriconnect.service.FpoService fpoService;

    @GetMapping
    public ModelAndView getMarketplace() {
        ModelAndView mav = new ModelAndView("marketplace");
        List<ProduceListing> listings = listingService.searchListings(new SearchFiltersDto());
        List<com.agriconnect.dto.ListingResponseDto> dtos = listings.stream().map(com.agriconnect.dto.ListingResponseDto::new).toList();
        mav.addObject("fpoListings", fpoService.getFpoListingsForBuyer());
        mav.addObject("listings", dtos);
        return mav;
    }
}
