package com.agriconnect.dao;

import com.agriconnect.model.MspRate;
import org.springframework.stereotype.Repository;

@Repository
public class MspRateDao extends BaseDaoImpl<MspRate, Long> {
    public MspRateDao() {
        super(MspRate.class);
    }
}
