package com.agriconnect.dao;

import com.agriconnect.model.PriceHistory;
import org.springframework.stereotype.Repository;

@Repository
public class PriceHistoryDao extends BaseDaoImpl<PriceHistory, Long> {

    public PriceHistoryDao() {
        super(PriceHistory.class);
    }
}
