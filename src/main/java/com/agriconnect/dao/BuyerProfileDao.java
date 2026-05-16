package com.agriconnect.dao;

import com.agriconnect.model.BuyerProfile;
import java.util.Optional;
import java.util.List;

public interface BuyerProfileDao {
    void save(BuyerProfile profile);
    void update(BuyerProfile profile);
    Optional<BuyerProfile> findById(Long id);
    Optional<BuyerProfile> findByUserId(Long userId);
    List<BuyerProfile> findAll();
}
