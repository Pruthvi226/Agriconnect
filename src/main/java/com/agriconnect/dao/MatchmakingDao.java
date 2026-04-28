package com.agriconnect.dao;

import com.agriconnect.model.MatchmakingScore;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class MatchmakingDao extends BaseDaoImpl<MatchmakingScore, Long> {

    public MatchmakingDao() {
        super(MatchmakingScore.class);
    }

    public List<MatchmakingScore> getTopMatchesForBuyer(Long buyerId, int limit) {
        String hql = "SELECT m FROM MatchmakingScore m JOIN FETCH m.farmer JOIN FETCH m.farmer.user " +
                     "WHERE m.buyer.id = :buyerId ORDER BY m.score DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, MatchmakingScore.class)
                .setParameter("buyerId", buyerId)
                .setMaxResults(limit)
                .getResultList();
    }

    public List<MatchmakingScore> getTopMatchesForFarmer(Long farmerId, int limit) {
        String hql = "SELECT m FROM MatchmakingScore m JOIN FETCH m.buyer JOIN FETCH m.buyer.user " +
                     "WHERE m.farmer.id = :farmerId ORDER BY m.score DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, MatchmakingScore.class)
                .setParameter("farmerId", farmerId)
                .setMaxResults(limit)
                .getResultList();
    }
}
