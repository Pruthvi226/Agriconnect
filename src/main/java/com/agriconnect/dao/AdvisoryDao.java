package com.agriconnect.dao;

import com.agriconnect.model.Advisory;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public class AdvisoryDao extends BaseDaoImpl<Advisory, Long> {

    public AdvisoryDao() {
        super(Advisory.class);
    }

    public List<Advisory> findActiveAdvisories(LocalDate today) {
        String hql = "SELECT a FROM Advisory a JOIN FETCH a.expert WHERE a.validUntil >= :today ORDER BY a.createdAt DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, Advisory.class)
                .setParameter("today", today)
                .getResultList();
    }

    public List<Advisory> findByDistrictsAndCrop(List<String> districts, String crop) {
        // Simple fallback since JSON array checking in standard HQL without native functions is tricky
        // Assuming we do a basic search or native query for JSON
        String hql = "SELECT a FROM Advisory a JOIN FETCH a.expert WHERE a.cropName = :crop " +
                     "AND a.validUntil >= CURRENT_DATE ORDER BY a.createdAt DESC";
        // To precisely match JSON 'affected_districts', a NativeQuery with JSON_CONTAINS is optimal in MySQL 8.
        return sessionFactory.getCurrentSession().createQuery(hql, Advisory.class)
                .setParameter("crop", crop)
                .getResultList();
    }
}
