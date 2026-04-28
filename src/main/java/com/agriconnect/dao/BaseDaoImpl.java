package com.agriconnect.dao;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import java.util.List;
import java.util.Optional;

public abstract class BaseDaoImpl<T, ID> implements BaseDao<T, ID> {

    @Autowired
    protected SessionFactory sessionFactory;

    private final Class<T> entityClass;

    protected BaseDaoImpl(Class<T> entityClass) {
        this.entityClass = entityClass;
    }

    @Override
    public Optional<T> findById(ID id) {
        return Optional.ofNullable(sessionFactory.getCurrentSession().get(entityClass, (java.io.Serializable) id));
    }

    @Override
    public List<T> findAll() {
        CriteriaBuilder cb = sessionFactory.getCurrentSession().getCriteriaBuilder();
        CriteriaQuery<T> cq = cb.createQuery(entityClass);
        Root<T> root = cq.from(entityClass);
        cq.select(root);
        return sessionFactory.getCurrentSession().createQuery(cq).getResultList();
    }

    @Override
    public void save(T entity) {
        sessionFactory.getCurrentSession().persist(entity);
    }

    @Override
    public void update(T entity) {
        sessionFactory.getCurrentSession().merge(entity);
    }

    @Override
    public void delete(T entity) {
        sessionFactory.getCurrentSession().remove(entity);
    }

    @Override
    public List<T> findByField(String fieldName, Object value) {
        CriteriaBuilder cb = sessionFactory.getCurrentSession().getCriteriaBuilder();
        CriteriaQuery<T> cq = cb.createQuery(entityClass);
        Root<T> root = cq.from(entityClass);
        cq.select(root).where(cb.equal(root.get(fieldName), value));
        return sessionFactory.getCurrentSession().createQuery(cq).getResultList();
    }
}
