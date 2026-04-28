package com.agriconnect.service;

import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dto.ListingRequestDto;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.MspRate;
import com.agriconnect.model.ProduceListing;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class ListingServiceTest {

    @Mock
    private ProduceListingDao listingDao;

    @Mock
    private BaseDao<FarmerProfile, Long> farmerDao;

    @Mock
    private MspRateService mspRateService;

    @Mock
    private AuditService auditService;

    @InjectMocks
    private ListingService listingService;

    private ListingRequestDto dto;
    private FarmerProfile farmer;

    @BeforeEach
    void setUp() {
        dto = new ListingRequestDto();
        dto.setCropName("Wheat");
        dto.setQuantityKg(BigDecimal.valueOf(100));
        dto.setAskingPricePerKg(BigDecimal.valueOf(25));
        dto.setAvailableFrom(LocalDate.now().plusDays(1));
        dto.setAvailableUntil(LocalDate.now().plusDays(10));

        farmer = new FarmerProfile();
        farmer.setId(1L);
    }

    @Test
    void testCreateListing_ValidData() {
        when(farmerDao.findById(1L)).thenReturn(Optional.of(farmer));
        
        MspRate msp = new MspRate();
        msp.setMspPerKg(BigDecimal.valueOf(20));
        when(mspRateService.getCurrentMsp("Wheat")).thenReturn(msp);

        ProduceListing listing = listingService.createListing(dto, 1L);

        assertThat(listing).isNotNull();
        assertThat(listing.getCropName()).isEqualTo("Wheat");
        assertThat(listing.getMspPricePerKg()).isEqualByComparingTo(BigDecimal.valueOf(20));
        verify(listingDao, times(1)).save(any(ProduceListing.class));
        verify(auditService, times(1)).log(eq(1L), eq("CREATE"), eq("ProduceListing"), any(), anyString(), anyString(), anyString());
    }

    @Test
    void testExpireStaleListings() {
        ProduceListing staleListing = new ProduceListing();
        staleListing.setAvailableUntil(LocalDate.now().minusDays(1));
        staleListing.setStatus(ProduceListing.Status.ACTIVE);
        
        when(listingDao.findByField("status", ProduceListing.Status.ACTIVE)).thenReturn(java.util.List.of(staleListing));
        
        listingService.expireStaleListings();
        
        assertThat(staleListing.getStatus()).isEqualTo(ProduceListing.Status.EXPIRED);
        verify(listingDao, times(1)).update(staleListing);
    }
}
