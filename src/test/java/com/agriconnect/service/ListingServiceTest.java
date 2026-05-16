package com.agriconnect.service;

import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dto.ListingRequestDto;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.MspRate;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;
import java.util.List;

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
    private FarmerProfileDao farmerProfileDao;

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

    @Test
    void getBelowMspListings_ReturnsOnlyActiveBelowMspListings() {
        ProduceListing below = listingWithPrice("Wheat", "ACTIVE", "18.00", "20.00");
        ProduceListing above = listingWithPrice("Maize", "ACTIVE", "22.00", "20.00");
        ProduceListing soldBelow = listingWithPrice("Rice", "SOLD", "18.00", "20.00");

        when(listingDao.findAll()).thenReturn(List.of(above, below, soldBelow));

        List<ProduceListing> result = listingService.getBelowMspListings();

        assertThat(result).containsExactly(below);
    }

    @Test
    void withdrawListingForUser_UpdatesOwnedActiveListing() {
        User user = new User();
        user.setId(99L);
        farmer.setUser(user);
        ProduceListing listing = listingWithPrice("Wheat", "ACTIVE", "18.00", "20.00");
        listing.setId(10L);
        listing.setFarmerProfile(farmer);

        when(farmerProfileDao.findByUserId(99L)).thenReturn(Optional.of(farmer));
        when(listingDao.findById(10L)).thenReturn(Optional.of(listing));

        listingService.withdrawListingForUser(10L, 99L);

        assertThat(listing.getStatus()).isEqualTo(ProduceListing.Status.WITHDRAWN);
        verify(listingDao).update(listing);
        verify(auditService).log(eq(99L), eq("WITHDRAW_LISTING"), eq("ProduceListing"), eq(10L), anyString(), anyString(), anyString());
    }

    @Test
    void reactivateListingForUser_UpdatesOwnedWithdrawnListing() {
        User user = new User();
        user.setId(99L);
        farmer.setUser(user);
        ProduceListing listing = listingWithPrice("Wheat", "WITHDRAWN", "18.00", "20.00");
        listing.setId(11L);
        listing.setFarmerProfile(farmer);
        listing.setAvailableUntil(LocalDate.now().plusDays(5));

        when(farmerProfileDao.findByUserId(99L)).thenReturn(Optional.of(farmer));
        when(listingDao.findById(11L)).thenReturn(Optional.of(listing));

        listingService.reactivateListingForUser(11L, 99L);

        assertThat(listing.getStatus()).isEqualTo(ProduceListing.Status.ACTIVE);
        verify(listingDao).update(listing);
        verify(auditService).log(eq(99L), eq("REACTIVATE_LISTING"), eq("ProduceListing"), eq(11L), anyString(), anyString(), anyString());
    }

    private ProduceListing listingWithPrice(String crop, String status, String asking, String msp) {
        ProduceListing listing = new ProduceListing();
        listing.setCropName(crop);
        listing.setStatus(ProduceListing.Status.valueOf(status));
        listing.setAskingPricePerKg(new BigDecimal(asking));
        listing.setMspPricePerKg(new BigDecimal(msp));
        return listing;
    }
}
