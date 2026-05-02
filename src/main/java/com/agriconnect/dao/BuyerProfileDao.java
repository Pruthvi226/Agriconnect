package com.agriconnect.dao;

import com.agriconnect.model.BuyerProfile;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class BuyerProfileDao extends BaseDaoImpl<BuyerProfile, Long> {
    public BuyerProfileDao() {
        super(BuyerProfile.class);
    }

    public Optional<BuyerProfile> findByUserId(Long userId) {
        String hql = "SELECT b FROM BuyerProfile b JOIN FETCH b.user WHERE b.user.id = :userId";
        return sessionFactory.getCurrentSession().createQuery(hql, BuyerProfile.class)
                .setParameter("userId", userId)
                .uniqueResultOptional();
    }
}
