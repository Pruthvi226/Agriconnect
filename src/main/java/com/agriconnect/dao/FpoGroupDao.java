package com.agriconnect.dao;

import com.agriconnect.model.FpoGroup;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class FpoGroupDao extends BaseDaoImpl<FpoGroup, Long> {

    public FpoGroupDao() {
        super(FpoGroup.class);
    }

    public List<FpoGroup> findByLeader(Long farmerId) {
        String hql = "SELECT g FROM FpoGroup g JOIN FETCH g.leaderFarmer leader WHERE leader.id = :farmerId ORDER BY g.createdAt DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, FpoGroup.class)
                .setParameter("farmerId", farmerId)
                .getResultList();
    }

    public Optional<FpoGroup> findByRegistrationNumber(String registrationNumber) {
        String hql = "SELECT g FROM FpoGroup g WHERE g.registrationNumber = :registrationNumber";
        return sessionFactory.getCurrentSession().createQuery(hql, FpoGroup.class)
                .setParameter("registrationNumber", registrationNumber)
                .uniqueResultOptional();
    }
}
