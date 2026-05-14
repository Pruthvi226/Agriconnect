package com.agriconnect.dao;

import com.agriconnect.model.FarmerProfile;
import org.springframework.stereotype.Repository;

@Repository
public class FarmerProfileBaseDao extends BaseDaoImpl<FarmerProfile, Long> {
    public FarmerProfileBaseDao() {
        super(FarmerProfile.class);
    }
}
