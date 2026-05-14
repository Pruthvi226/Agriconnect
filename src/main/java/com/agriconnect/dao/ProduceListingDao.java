package com.agriconnect.dao;

import com.agriconnect.model.ProduceListing;
import java.util.Optional;
import java.util.List;
import java.math.BigDecimal;

public interface ProduceListingDao {
    void save(ProduceListing listing);
    void update(ProduceListing listing);
    void delete(ProduceListing listing);
    Optional<ProduceListing> findById(Long id);
    List<ProduceListing> findAll();
    List<ProduceListing> findByFarmerId(Long farmerId);
    List<ProduceListing> findByFarmer(Long farmerId, ProduceListing.Status status);
    List<ProduceListing> search(String crop, String district);
    List<ProduceListing> searchByFilters(String crop, String district, BigDecimal minPrice, BigDecimal maxPrice, String qualityGrade);
    List<ProduceListing> fullTextSearch(String term);
    List<ProduceListing> findNearby(BigDecimal lat, BigDecimal lng, Double radiusKm);
    List<ProduceListing> findByField(String fieldName, Object value);
    List<ProduceListing> findActiveListingsByFarmersAndCrop(List<Long> farmerIds, String cropName);
}
