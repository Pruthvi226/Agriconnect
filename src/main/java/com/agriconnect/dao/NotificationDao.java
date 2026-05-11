package com.agriconnect.dao;

import com.agriconnect.model.Notification;
import org.springframework.stereotype.Repository;

@Repository
public class NotificationDao extends BaseDaoImpl<Notification, Long> {
    public NotificationDao() {
        super(Notification.class);
    }

    public long countUnread(Long userId) {
        String hql = "SELECT count(n) FROM Notification n WHERE n.user.id = :userId AND n.isRead = false";
        return sessionFactory.getCurrentSession().createQuery(hql, Long.class)
                .setParameter("userId", userId)
                .getSingleResult();
    }

    public java.util.List<Notification> findByUser(Long userId) {
        String hql = "FROM Notification n WHERE n.user.id = :userId ORDER BY n.createdAt DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, Notification.class)
                .setParameter("userId", userId)
                .getResultList();
    }
}
