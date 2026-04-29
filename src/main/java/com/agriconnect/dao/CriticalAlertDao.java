package com.agriconnect.dao;

import com.agriconnect.model.CriticalAlert;
import org.springframework.stereotype.Repository;

@Repository
public class CriticalAlertDao extends BaseDaoImpl<CriticalAlert, Long> {
    public CriticalAlertDao() {
        super(CriticalAlert.class);
    }
}
