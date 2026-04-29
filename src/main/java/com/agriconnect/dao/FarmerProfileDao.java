package com.agriconnect.dao;

import com.agriconnect.model.FarmerProfile;
import org.springframework.stereotype.Repository;

@Repository
public class FarmerProfileDao extends BaseDaoImpl<FarmerProfile, Long> {
    public FarmerProfileDao() {
        super(FarmerProfile.class);
    }
}
