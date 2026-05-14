package com.agriconnect.dao;

import com.agriconnect.model.BuyerProfile;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class BuyerProfileDaoImpl implements BuyerProfileDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(BuyerProfile profile) {
        sessionFactory.getCurrentSession().persist(profile);
    }

    @Override
    public void update(BuyerProfile profile) {
        sessionFactory.getCurrentSession().merge(profile);
    }

    @Override
    public Optional<BuyerProfile> findById(Long id) {
        return Optional.ofNullable(sessionFactory.getCurrentSession().get(BuyerProfile.class, id));
    }

    @Override
    public Optional<BuyerProfile> findByUserId(Long userId) {
        String hql = "FROM BuyerProfile bp WHERE bp.user.id = :userId";
        return sessionFactory.getCurrentSession().createQuery(hql, BuyerProfile.class)
                .setParameter("userId", userId)
                .uniqueResultOptional();
    }

    @Override
    public List<BuyerProfile> findAll() {
        return sessionFactory.getCurrentSession().createQuery("FROM BuyerProfile", BuyerProfile.class).getResultList();
    }
}
