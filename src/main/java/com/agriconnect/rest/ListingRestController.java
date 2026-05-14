package com.agriconnect.rest;

import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dto.ListingRequestDto;
import com.agriconnect.dto.ListingResponseDto;
import com.agriconnect.dto.SearchFiltersDto;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.ListingService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/listings")
public class ListingRestController {

    @Autowired
    private ListingService listingService;

    @Autowired
    private ProduceListingDao listingDao;

    @GetMapping
    public ResponseEntity<List<ListingResponseDto>> list(SearchFiltersDto filters) {
        return ResponseEntity.ok(listingService.searchListings(filters).stream()
                .map(ListingResponseDto::new)
                .toList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ListingResponseDto> get(@PathVariable("id") Long id) {
        return ResponseEntity.ok(new ListingResponseDto(listingService.getListingById(id)));
    }

    @PostMapping
    public ResponseEntity<ListingResponseDto> create(@Valid @RequestBody ListingRequestDto dto,
                                                     Authentication authentication) {
        CustomUserDetails user = (CustomUserDetails) authentication.getPrincipal();
        ProduceListing listing = listingService.createListingForUser(dto, user.getId());
        return ResponseEntity.status(HttpStatus.CREATED).body(new ListingResponseDto(listing));
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<Map<String, Object>> updateStatus(@PathVariable("id") Long id,
                                                           @RequestParam("status") String status) {
        ProduceListing listing = listingService.getListingById(id);
        listing.setStatus(ProduceListing.Status.valueOf(status.toUpperCase()));
        listingDao.update(listing);
        return ResponseEntity.ok(Map.of("id", listing.getId(), "status", listing.getStatus().name()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handle(Exception ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", ex.getMessage()));
    }
}
