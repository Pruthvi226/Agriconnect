package com.agriconnect.dao;

import com.agriconnect.model.AuditLog;
import org.springframework.stereotype.Repository;

@Repository
public class AuditLogDao extends BaseDaoImpl<AuditLog, Long> {
    public AuditLogDao() {
        super(AuditLog.class);
    }

    public java.util.List<AuditLog> findRecent(int limit) {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM AuditLog a ORDER BY a.timestamp DESC", AuditLog.class)
                .setMaxResults(Math.max(1, limit))
                .getResultList();
    }
}
