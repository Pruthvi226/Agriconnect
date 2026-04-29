package com.agriconnect.dao;

import com.agriconnect.model.BuyerProfile;
import org.springframework.stereotype.Repository;

@Repository
public class BuyerProfileDao extends BaseDaoImpl<BuyerProfile, Long> {
    public BuyerProfileDao() {
        super(BuyerProfile.class);
    }
}
