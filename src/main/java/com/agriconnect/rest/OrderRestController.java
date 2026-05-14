package com.agriconnect.rest;

import com.agriconnect.dao.OrderDao;
import com.agriconnect.model.Order;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.BidService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
public class OrderRestController {

    @Autowired
    private BidService bidService;

    @Autowired
    private OrderDao orderDao;

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> orders(Authentication authentication) {
        CustomUserDetails user = (CustomUserDetails) authentication.getPrincipal();
        boolean farmer = user.getAuthorities().stream().anyMatch(a -> "ROLE_FARMER".equals(a.getAuthority()));
        List<Order> orders = farmer
                ? bidService.getOrdersForFarmerUser(user.getId())
                : bidService.getOrdersForBuyerUser(user.getId());
        return ResponseEntity.ok(orders.stream().map(this::toMap).toList());
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<Map<String, Object>> update(@PathVariable("id") Long id,
                                                     @RequestParam("status") String status) {
        Order order = orderDao.findById(id).orElseThrow(() -> new IllegalArgumentException("Order not found"));
        order.setOrderStatus(Order.OrderStatus.valueOf(status.toUpperCase()));
        if (order.getOrderStatus() == Order.OrderStatus.DELIVERED) {
            order.setActualDelivery(LocalDate.now());
        }
        orderDao.update(order);
        return ResponseEntity.ok(toMap(order));
    }

    private Map<String, Object> toMap(Order order) {
        return Map.of(
                "id", order.getId(),
                "status", order.getOrderStatus().name(),
                "paymentStatus", order.getPaymentStatus().name(),
                "totalAmount", order.getTotalAmount());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handle(Exception ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("error", ex.getMessage()));
    }
}
