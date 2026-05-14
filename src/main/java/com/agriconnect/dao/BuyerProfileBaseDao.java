package com.agriconnect.dao;

import com.agriconnect.model.BuyerProfile;
import org.springframework.stereotype.Repository;

@Repository
public class BuyerProfileBaseDao extends BaseDaoImpl<BuyerProfile, Long> {
    public BuyerProfileBaseDao() {
        super(BuyerProfile.class);
    }
}
