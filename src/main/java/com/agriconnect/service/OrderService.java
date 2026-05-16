package com.agriconnect.service;

import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.NotificationDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.exception.ResourceNotFoundException;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.Notification;
import com.agriconnect.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

@Service
@Transactional
public class OrderService {

    @Autowired
    private FarmerProfileDao farmerProfileDao;

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private NotificationDao notificationDao;

    @Autowired
    private SupplyChainService supplyChainService;

    @Autowired
    private AuditService auditService;

    public Order updateDeliveryStatus(Long orderId, String action, Long userId) {
        FarmerProfile farmer = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        Order order = orderDao.findDetailedById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found"));

        if (!order.getFarmer().getId().equals(farmer.getId())) {
            throw new BusinessValidationException("You do not own this order");
        }

        Order.OrderStatus oldStatus = order.getOrderStatus();
        String normalized = action == null ? "" : action.trim().toUpperCase();
        switch (normalized) {
            case "CAN_DELIVER":
            case "IN_TRANSIT":
                order.setOrderStatus(Order.OrderStatus.IN_TRANSIT);
                break;
            case "DELIVERED":
                markAsCompleted(order);
                break;
            case "CANNOT_DELIVER":
            case "CANCELLED":
                order.setOrderStatus(Order.OrderStatus.CANCELLED);
                order.setPaymentStatus(Order.PaymentStatus.REFUNDED);
                break;
            default:
                throw new BusinessValidationException("Unsupported delivery action");
        }

        orderDao.update(order);

        Notification notification = new Notification();
        notification.setUser(order.getBuyer().getUser());
        notification.setTitle("Order Delivery Updated");
        notification.setBody("Your " + order.getBid().getListing().getCropName() + " order is now "
                + order.getOrderStatus().name().replace('_', ' ').toLowerCase() + ".");
        notification.setType("ORDER_UPDATE");
        notificationDao.save(notification);

        auditService.log(userId, "UPDATE_DELIVERY", "Order", orderId,
                "{\"status\":\"" + oldStatus + "\"}",
                "{\"status\":\"" + order.getOrderStatus() + "\"}", "127.0.0.1");

        return order;
    }

    public void markAsCompleted(Order order) {
        order.setOrderStatus(Order.OrderStatus.DELIVERED);
        order.setActualDelivery(LocalDate.now());
        order.setPaymentStatus(Order.PaymentStatus.PAID);
        supplyChainService.generateQrForOrder(order.getId());
    }
}
