package com.agriconnect.service;

import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dto.ListingRequestDto;
import com.agriconnect.dto.SearchFiltersDto;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.exception.ResourceNotFoundException;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.MspRate;
import com.agriconnect.model.ProduceListing;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@Transactional
public class ListingService {

    @Autowired
    private ProduceListingDao listingDao;

    @Autowired
    private BaseDao<FarmerProfile, Long> farmerDao;

    @Autowired
    private MspRateService mspRateService;

    @Autowired
    private AuditService auditService;

    @org.springframework.security.access.prepost.PreAuthorize("hasRole('FARMER') and #farmerId == authentication.principal.id")
    public ProduceListing createListing(ListingRequestDto dto, Long farmerId) {
        FarmerProfile farmer = farmerDao.findById(farmerId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer not found"));

        if (dto.getAvailableFrom().isAfter(dto.getAvailableUntil())) {
            throw new BusinessValidationException("Available From date cannot be after Available Until date");
        }

        ProduceListing listing = new ProduceListing();
        listing.setFarmerProfile(farmer);
        listing.setCropName(dto.getCropName());
        listing.setVariety(dto.getVariety());
        listing.setQuantityKg(dto.getQuantityKg());
        listing.setAvailableFrom(dto.getAvailableFrom());
        listing.setAvailableUntil(dto.getAvailableUntil());
        listing.setAskingPricePerKg(dto.getAskingPricePerKg());
        listing.setDescription(dto.getDescription());
        listing.setDistrict(farmer.getDistrict());
        listing.setLat(farmer.getLat());
        listing.setLng(farmer.getLng());
        listing.setStatus(ProduceListing.Status.ACTIVE);
        
        if (dto.getQualityGrade() != null) {
            listing.setQualityGrade(ProduceListing.QualityGrade.valueOf(dto.getQualityGrade()));
        }

        // Auto-fetch current MSP using MspRateService
        MspRate currentMsp = mspRateService.getCurrentMsp(dto.getCropName());
        if (currentMsp != null) {
            listing.setMspPricePerKg(currentMsp.getMspPerKg());
        }

        listingDao.save(listing);

        auditService.log(farmerId, "CREATE", "ProduceListing", listing.getId(), "{}", "{\"cropName\":\"" + dto.getCropName() + "\"}", "127.0.0.1"); // stub IP for now

        return listing;
    }

    public String getMspComparison(Long listingId) {
        ProduceListing listing = listingDao.findById(listingId)
                .orElseThrow(() -> new ResourceNotFoundException("Listing not found"));

        if (listing.getMspPricePerKg() == null) {
            return "MSP_UNAVAILABLE";
        }

        int comparison = listing.getAskingPricePerKg().compareTo(listing.getMspPricePerKg());
        if (comparison < 0) return "BELOW_MSP";
        if (comparison == 0) return "AT_MSP";
        return "ABOVE_MSP";
    }

    public List<ProduceListing> searchListings(SearchFiltersDto filters) {
        return listingDao.searchByFilters(
            filters.getCropName(), 
            filters.getDistrict(), 
            filters.getMinPrice(), 
            filters.getMaxPrice(), 
            filters.getQualityGrade()
        );
    }

    @Scheduled(cron = "0 0 1 * * ?") // 1 AM every day
    public void expireStaleListings() {
        List<ProduceListing> activeListings = listingDao.findByField("status", ProduceListing.Status.ACTIVE);
        LocalDate today = LocalDate.now();
        int expiredCount = 0;
        
        for (ProduceListing listing : activeListings) {
            if (listing.getAvailableUntil() != null && listing.getAvailableUntil().isBefore(today)) {
                listing.setStatus(ProduceListing.Status.EXPIRED);
                listingDao.update(listing);
                expiredCount++;
            }
        }
        // In a real app, use a logger
        System.out.println("Expired " + expiredCount + " stale listings.");
    }
}
