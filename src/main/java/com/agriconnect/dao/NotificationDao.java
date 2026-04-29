package com.agriconnect.dao;

import com.agriconnect.model.Notification;
import org.springframework.stereotype.Repository;

@Repository
public class NotificationDao extends BaseDaoImpl<Notification, Long> {
    public NotificationDao() {
        super(Notification.class);
    }
}
