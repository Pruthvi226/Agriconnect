package com.agriconnect.dao;

import com.agriconnect.model.Advisory;
import java.util.Optional;
import java.util.List;

public interface AdvisoryDao {
    void save(Advisory advisory);
    void update(Advisory advisory);
    Optional<Advisory> findById(Long id);
    List<Advisory> findAll();
    List<Advisory> findByExpertId(Long expertId);
}
