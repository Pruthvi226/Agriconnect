package com.agriconnect.dao;

import com.agriconnect.model.DemandForecastCache;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class DemandForecastDao extends BaseDaoImpl<DemandForecastCache, Long> {

    public DemandForecastDao() {
        super(DemandForecastCache.class);
    }

    public List<Object[]> findTopCropDemandSince(LocalDateTime cutoff) {
        String sql = "SELECT l.crop_name, COUNT(*) AS bid_count, AVG(b.bid_price_per_kg) AS avg_price " +
                "FROM bids b " +
                "JOIN produce_listings l ON b.listing_id = l.id " +
                "WHERE b.created_at > :cutoff " +
                "GROUP BY l.crop_name " +
                "ORDER BY bid_count DESC, avg_price DESC";
        return sessionFactory.getCurrentSession().createNativeQuery(sql, Object[].class)
                .setParameter("cutoff", cutoff)
                .setMaxResults(8)
                .getResultList();
    }

    public List<Object[]> findHotDistrictDemand() {
        String sql = "SELECT l.district, l.crop_name, SUM(b.quantity_kg) AS unfulfilled_demand " +
                "FROM bids b " +
                "JOIN produce_listings l ON b.listing_id = l.id " +
                "WHERE b.bid_status = 'PENDING' AND l.status = 'ACTIVE' " +
                "GROUP BY l.district, l.crop_name " +
                "ORDER BY unfulfilled_demand DESC";
        return sessionFactory.getCurrentSession().createNativeQuery(sql, Object[].class)
                .setMaxResults(8)
                .getResultList();
    }

    public List<Object[]> findPriceHistorySince(LocalDate sinceDate) {
        String sql = "SELECT crop_name, accepted_price, price_date " +
                "FROM price_history " +
                "WHERE price_date >= :sinceDate " +
                "ORDER BY crop_name ASC, price_date ASC, id ASC";
        return sessionFactory.getCurrentSession().createNativeQuery(sql, Object[].class)
                .setParameter("sinceDate", sinceDate)
                .getResultList();
    }

    public Optional<DemandForecastCache> findLatestCache() {
        String hql = "FROM DemandForecastCache c ORDER BY c.generatedAt DESC, c.id DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, DemandForecastCache.class)
                .setMaxResults(1)
                .uniqueResultOptional();
    }
}
