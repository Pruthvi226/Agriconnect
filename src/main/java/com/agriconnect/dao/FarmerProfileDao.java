package com.agriconnect.dao;

import com.agriconnect.model.FarmerProfile;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class FarmerProfileDao extends BaseDaoImpl<FarmerProfile, Long> {
    public FarmerProfileDao() {
        super(FarmerProfile.class);
    }

    public Optional<FarmerProfile> findByUserId(Long userId) {
        String hql = "SELECT f FROM FarmerProfile f JOIN FETCH f.user WHERE f.user.id = :userId";
        return sessionFactory.getCurrentSession().createQuery(hql, FarmerProfile.class)
                .setParameter("userId", userId)
                .uniqueResultOptional();
    }
}
