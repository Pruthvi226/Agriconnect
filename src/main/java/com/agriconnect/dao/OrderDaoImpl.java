package com.agriconnect.dao;

import com.agriconnect.model.Order;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class OrderDaoImpl implements OrderDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(Order order) {
        sessionFactory.getCurrentSession().persist(order);
    }

    @Override
    public void update(Order order) {
        sessionFactory.getCurrentSession().merge(order);
    }

    @Override
    public Optional<Order> findById(Long id) {
        return Optional.ofNullable(sessionFactory.getCurrentSession().get(Order.class, id));
    }

    @Override
    public List<Order> findAll() {
        return sessionFactory.getCurrentSession()
                .createQuery("FROM Order o ORDER BY o.createdAt DESC", Order.class)
                .getResultList();
    }

    @Override
    public List<Order> findByFarmerId(Long farmerId) {
        String hql = "FROM Order o WHERE o.farmer.id = :farmerId";
        return sessionFactory.getCurrentSession().createQuery(hql, Order.class)
                .setParameter("farmerId", farmerId)
                .getResultList();
    }

    @Override
    public List<Order> findByBuyerId(Long buyerId) {
        String hql = "FROM Order o WHERE o.buyer.id = :buyerId";
        return sessionFactory.getCurrentSession().createQuery(hql, Order.class)
                .setParameter("buyerId", buyerId)
                .getResultList();
    }

    @Override
    public List<Order> findByFarmer(Long farmerId, Order.OrderStatus status) {
        StringBuilder hql = new StringBuilder("FROM Order o WHERE o.farmer.id = :farmerId");
        if (status != null) {
            hql.append(" AND o.orderStatus = :status");
        }
        hql.append(" ORDER BY o.createdAt DESC");
        var query = sessionFactory.getCurrentSession().createQuery(hql.toString(), Order.class)
                .setParameter("farmerId", farmerId);
        if (status != null) {
            query.setParameter("status", status);
        }
        return query.getResultList();
    }

    @Override
    public List<Order> findByBuyer(Long buyerId, Order.OrderStatus status) {
        StringBuilder hql = new StringBuilder("FROM Order o WHERE o.buyer.id = :buyerId");
        if (status != null) {
            hql.append(" AND o.orderStatus = :status");
        }
        hql.append(" ORDER BY o.createdAt DESC");
        var query = sessionFactory.getCurrentSession().createQuery(hql.toString(), Order.class)
                .setParameter("buyerId", buyerId);
        if (status != null) {
            query.setParameter("status", status);
        }
        return query.getResultList();
    }
}
