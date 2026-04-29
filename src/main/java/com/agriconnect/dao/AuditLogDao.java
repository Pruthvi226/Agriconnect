package com.agriconnect.dao;

import com.agriconnect.model.AuditLog;
import org.springframework.stereotype.Repository;

@Repository
public class AuditLogDao extends BaseDaoImpl<AuditLog, Long> {
    public AuditLogDao() {
        super(AuditLog.class);
    }
}
