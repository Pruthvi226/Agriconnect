package com.agriconnect.dao;

import com.agriconnect.model.Order;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;

@Repository
public class OrderDao extends BaseDaoImpl<Order, Long> {

    public OrderDao() {
        super(Order.class);
    }

    public List<Order> findByFarmer(Long farmerId, Order.OrderStatus status) {
        String hql = "SELECT o FROM Order o JOIN FETCH o.bid bid JOIN FETCH bid.listing JOIN FETCH o.buyer WHERE o.farmer.id = :farmerId ";
        if (status != null) hql += "AND o.orderStatus = :status ";
        hql += "ORDER BY o.createdAt DESC";
        
        var query = sessionFactory.getCurrentSession().createQuery(hql, Order.class)
                .setParameter("farmerId", farmerId);
        if (status != null) query.setParameter("status", status);
        
        return query.getResultList();
    }

    public List<Order> findByBuyer(Long buyerId, Order.OrderStatus status) {
        String hql = "SELECT o FROM Order o JOIN FETCH o.bid JOIN FETCH o.farmer WHERE o.buyer.id = :buyerId ";
        if (status != null) hql += "AND o.orderStatus = :status ";
        hql += "ORDER BY o.createdAt DESC";
        
        var query = sessionFactory.getCurrentSession().createQuery(hql, Order.class)
                .setParameter("buyerId", buyerId);
        if (status != null) query.setParameter("status", status);
        
        return query.getResultList();
    }

    public Map<String, Object> getRevenueStats(Long farmerId, LocalDate fromDate, LocalDate toDate) {
        String hql = "SELECT COUNT(o), SUM(o.totalAmount) FROM Order o WHERE o.farmer.id = :farmerId AND o.orderStatus = 'DELIVERED' " +
                     "AND CAST(o.createdAt AS date) BETWEEN :fromDate AND :toDate";
        Object[] result = sessionFactory.getCurrentSession().createQuery(hql, Object[].class)
                .setParameter("farmerId", farmerId)
                .setParameter("fromDate", fromDate)
                .setParameter("toDate", toDate)
                .uniqueResult();
                
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalOrders", result[0] != null ? result[0] : 0L);
        stats.put("totalRevenue", result[1] != null ? result[1] : BigDecimal.ZERO);
        return stats;
    }
}
