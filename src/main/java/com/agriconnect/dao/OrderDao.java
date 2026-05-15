package com.agriconnect.dao;

import com.agriconnect.model.Order;
import java.util.Optional;
import java.util.List;

public interface OrderDao {
    void save(Order order);
    void update(Order order);
    Optional<Order> findById(Long id);
    List<Order> findAll();
    List<Order> findByFarmerId(Long farmerId);
    List<Order> findByBuyerId(Long buyerId);
    List<Order> findByFarmer(Long farmerId, Order.OrderStatus status);
    List<Order> findByBuyer(Long buyerId, Order.OrderStatus status);
}
