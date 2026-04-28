package com.agriconnect.dao;

import com.agriconnect.model.MarketPrice;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class MarketPriceDao {

    @Autowired
    private SessionFactory sessionFactory;

    public Optional<MarketPrice> getLatestPriceForCrop(Long cropId) {
        return sessionFactory.getCurrentSession()
                .createQuery("from MarketPrice m where m.crop.id = :cropId order by m.effectiveDate desc", MarketPrice.class)
                .setParameter("cropId", cropId)
                .setMaxResults(1)
                .uniqueResultOptional();
    }
    
    public void saveMarketPrice(MarketPrice mp) {
        sessionFactory.getCurrentSession().persist(mp);
    }
}
