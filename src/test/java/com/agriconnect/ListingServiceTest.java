package com.agriconnect;

import com.agriconnect.dto.ListingRequestDto;
import com.agriconnect.dto.SearchFiltersDto;
import com.agriconnect.dto.UserRegistrationDto;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.model.User;
import com.agriconnect.service.ListingService;
import com.agriconnect.service.UserService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "classpath:test-app-context.xml")
@Transactional
class ListingServiceTest {

    @Autowired
    private UserService userService;

    @Autowired
    private ListingService listingService;

    @Test
    void createListingAppearsInSearchResults() {
        User farmer = userService.register(registration());
        ProduceListing listing = listingService.createListingForUser(listingRequest(), farmer.getId());

        SearchFiltersDto filters = new SearchFiltersDto();
        filters.setCropName("Tomato");
        filters.setDistrict("Nashik");
        List<ProduceListing> results = listingService.searchListings(filters);

        assertThat(listing.getId()).isNotNull();
        assertThat(results).extracting(ProduceListing::getId).contains(listing.getId());
    }

    private UserRegistrationDto registration() {
        UserRegistrationDto dto = new UserRegistrationDto();
        dto.setName("Listing Farmer");
        dto.setEmail("listing.farmer@example.com");
        dto.setPassword("Farmer@123");
        dto.setPhone("9876543210");
        dto.setRole("FARMER");
        return dto;
    }

    private ListingRequestDto listingRequest() {
        ListingRequestDto dto = new ListingRequestDto();
        dto.setCropName("Tomato");
        dto.setVariety("Roma");
        dto.setQuantityKg(new BigDecimal("750.00"));
        dto.setAskingPricePerKg(new BigDecimal("18.50"));
        dto.setQualityGrade("A");
        dto.setAvailableFrom(LocalDate.now());
        dto.setAvailableUntil(LocalDate.now().plusDays(5));
        dto.setDescription("Fresh tomato lot");
        return dto;
    }
}
