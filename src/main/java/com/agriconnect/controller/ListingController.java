package com.agriconnect.controller;

import com.agriconnect.dto.ApiResponse;
import com.agriconnect.dto.ListingRequestDto;
import com.agriconnect.dto.ListingResponseDto;
import com.agriconnect.dto.SearchFiltersDto;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.ListingService;
import com.agriconnect.service.FpoService;
import com.agriconnect.dto.FpoListingResponseDto;
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
        if (authentication == null) {
            return ResponseEntity.status(401).body(ApiResponse.error("User not authenticated"));
        }
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
    public ResponseEntity<ApiResponse<String>> getMspComparison(@PathVariable("id") Long id) {
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
    private FpoService fpoService;

    @GetMapping
    public ModelAndView getMarketplace(@ModelAttribute SearchFiltersDto filters,
                                       @RequestParam(value = "mspFilter", required = false) String mspFilter) {
        ModelAndView mav = new ModelAndView("marketplace");
        List<ProduceListing> listings = listingService.searchListings(filters);
        List<ListingResponseDto> dtos = listings.stream()
                .map(ListingResponseDto::new)
                .filter(dto -> mspFilter == null || mspFilter.isBlank() || mspFilter.equals(dto.getMspBadge()))
                .toList();
        
        List<FpoListingResponseDto> fpoListings = fpoService.getFpoListingsForBuyer();
        mav.addObject("fpoListings", fpoListings);
        mav.addObject("listings", dtos);
        mav.addObject("filters", filters);
        mav.addObject("mspFilter", mspFilter);
        return mav;
    }


}
