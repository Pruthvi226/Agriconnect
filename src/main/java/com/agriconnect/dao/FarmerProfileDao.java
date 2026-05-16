package com.agriconnect.dao;

import com.agriconnect.model.FarmerProfile;
import java.util.Optional;
import java.util.List;

public interface FarmerProfileDao {
    void save(FarmerProfile profile);
    void update(FarmerProfile profile);
    Optional<FarmerProfile> findById(Long id);
    Optional<FarmerProfile> findByUserId(Long userId);
    List<FarmerProfile> findAll();
}
