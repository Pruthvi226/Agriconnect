package com.agriconnect.dao;

import com.agriconnect.model.FpoListing;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class FpoListingDao extends BaseDaoImpl<FpoListing, Long> {

    public FpoListingDao() {
        super(FpoListing.class);
    }

    public List<FpoListing> findOpenListingsForBuyer() {
        String hql = "SELECT l FROM FpoListing l JOIN FETCH l.fpoGroup g " +
                "WHERE l.status = 'OPEN' ORDER BY g.isVerified DESC, l.createdAt DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, FpoListing.class).getResultList();
    }

    public List<FpoListing> findByFpo(Long fpoId) {
        String hql = "SELECT l FROM FpoListing l JOIN FETCH l.fpoGroup g WHERE g.id = :fpoId ORDER BY l.createdAt DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, FpoListing.class)
                .setParameter("fpoId", fpoId)
                .getResultList();
    }
}
