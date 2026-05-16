package com.agriconnect.dao;

import com.agriconnect.model.FpoMembership;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class FpoMembershipDao extends BaseDaoImpl<FpoMembership, Long> {

    public FpoMembershipDao() {
        super(FpoMembership.class);
    }

    public Optional<FpoMembership> findByFpoAndFarmer(Long fpoId, Long farmerId) {
        String hql = "SELECT m FROM FpoMembership m JOIN FETCH m.fpoGroup g JOIN FETCH m.farmer f WHERE g.id = :fpoId AND f.id = :farmerId";
        return sessionFactory.getCurrentSession().createQuery(hql, FpoMembership.class)
                .setParameter("fpoId", fpoId)
                .setParameter("farmerId", farmerId)
                .uniqueResultOptional();
    }

    public List<FpoMembership> findPendingByLeader(Long leaderFarmerId) {
        String hql = "SELECT m FROM FpoMembership m JOIN FETCH m.fpoGroup g JOIN FETCH m.farmer f JOIN FETCH f.user " +
                "WHERE g.leaderFarmer.id = :leaderFarmerId AND m.isActive = false ORDER BY m.joinedAt ASC";
        return sessionFactory.getCurrentSession().createQuery(hql, FpoMembership.class)
                .setParameter("leaderFarmerId", leaderFarmerId)
                .getResultList();
    }

    public List<FpoMembership> findActiveByFpo(Long fpoId) {
        String hql = "SELECT m FROM FpoMembership m JOIN FETCH m.farmer f JOIN FETCH f.user WHERE m.fpoGroup.id = :fpoId AND m.isActive = true";
        return sessionFactory.getCurrentSession().createQuery(hql, FpoMembership.class)
                .setParameter("fpoId", fpoId)
                .getResultList();
    }

    public List<FpoMembership> findByFarmer(Long farmerId) {
        String hql = "SELECT m FROM FpoMembership m JOIN FETCH m.fpoGroup g JOIN FETCH g.leaderFarmer leader WHERE m.farmer.id = :farmerId ORDER BY m.joinedAt DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, FpoMembership.class)
                .setParameter("farmerId", farmerId)
                .getResultList();
    }
}
