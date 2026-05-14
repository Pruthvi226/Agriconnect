package com.agriconnect.dao;

import com.agriconnect.model.FarmerProfile;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class FarmerProfileDaoImpl implements FarmerProfileDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(FarmerProfile profile) {
        sessionFactory.getCurrentSession().persist(profile);
    }

    @Override
    public void update(FarmerProfile profile) {
        sessionFactory.getCurrentSession().merge(profile);
    }

    @Override
    public Optional<FarmerProfile> findById(Long id) {
        return Optional.ofNullable(sessionFactory.getCurrentSession().get(FarmerProfile.class, id));
    }

    @Override
    public Optional<FarmerProfile> findByUserId(Long userId) {
        String hql = "FROM FarmerProfile fp WHERE fp.user.id = :userId";
        return sessionFactory.getCurrentSession().createQuery(hql, FarmerProfile.class)
                .setParameter("userId", userId)
                .uniqueResultOptional();
    }

    @Override
    public List<FarmerProfile> findAll() {
        return sessionFactory.getCurrentSession().createQuery("FROM FarmerProfile", FarmerProfile.class).getResultList();
    }
}
