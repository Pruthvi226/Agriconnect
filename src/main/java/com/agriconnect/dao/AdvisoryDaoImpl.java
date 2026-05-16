package com.agriconnect.dao;

import com.agriconnect.model.Advisory;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class AdvisoryDaoImpl implements AdvisoryDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(Advisory advisory) {
        sessionFactory.getCurrentSession().persist(advisory);
    }

    @Override
    public void update(Advisory advisory) {
        sessionFactory.getCurrentSession().merge(advisory);
    }

    @Override
    public Optional<Advisory> findById(Long id) {
        return Optional.ofNullable(sessionFactory.getCurrentSession().get(Advisory.class, id));
    }

    @Override
    public List<Advisory> findAll() {
        return sessionFactory.getCurrentSession().createQuery("FROM Advisory ORDER BY createdAt DESC", Advisory.class).getResultList();
    }

    @Override
    public List<Advisory> findByExpertId(Long expertId) {
        return sessionFactory.getCurrentSession().createQuery("FROM Advisory a WHERE a.expert.id = :expertId ORDER BY a.createdAt DESC", Advisory.class)
                .setParameter("expertId", expertId)
                .getResultList();
    }
}
