package com.agriconnect.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "orders")
@Getter
@Setter
@NoArgsConstructor
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "bid_id", unique = true, nullable = false)
    private Bid bid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "farmer_id", nullable = false)
    private FarmerProfile farmer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "buyer_id", nullable = false)
    private BuyerProfile buyer;

    @Column(name = "final_price_per_kg", precision = 8, scale = 2, nullable = false)
    private BigDecimal finalPricePerKg;

    @Column(name = "quantity_kg", precision = 10, scale = 2, nullable = false)
    private BigDecimal quantityKg;

    @Column(name = "total_amount", precision = 12, scale = 2, nullable = false)
    private BigDecimal totalAmount;

    @Enumerated(EnumType.STRING)
    @Column(name = "order_status", nullable = false)
    private OrderStatus orderStatus = OrderStatus.CONFIRMED;

    @Column(name = "expected_delivery")
    private LocalDate expectedDelivery;

    @Column(name = "actual_delivery")
    private LocalDate actualDelivery;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false)
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public enum OrderStatus { CONFIRMED, IN_TRANSIT, DELIVERED, DISPUTED, CANCELLED }
    public enum PaymentStatus { PENDING, PAID, REFUNDED }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.orderStatus == null) this.orderStatus = OrderStatus.CONFIRMED;
        if (this.paymentStatus == null) this.paymentStatus = PaymentStatus.PENDING;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Bid getBid() {
        return bid;
    }

    public void setBid(Bid bid) {
        this.bid = bid;
    }

    public FarmerProfile getFarmer() {
        return farmer;
    }

    public void setFarmer(FarmerProfile farmer) {
        this.farmer = farmer;
    }

    public BuyerProfile getBuyer() {
        return buyer;
    }

    public void setBuyer(BuyerProfile buyer) {
        this.buyer = buyer;
    }

    public BigDecimal getFinalPricePerKg() {
        return finalPricePerKg;
    }

    public void setFinalPricePerKg(BigDecimal finalPricePerKg) {
        this.finalPricePerKg = finalPricePerKg;
    }

    public BigDecimal getQuantityKg() {
        return quantityKg;
    }

    public void setQuantityKg(BigDecimal quantityKg) {
        this.quantityKg = quantityKg;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public OrderStatus getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(OrderStatus orderStatus) {
        this.orderStatus = orderStatus;
    }

    public LocalDate getExpectedDelivery() {
        return expectedDelivery;
    }

    public void setExpectedDelivery(LocalDate expectedDelivery) {
        this.expectedDelivery = expectedDelivery;
    }

    public LocalDate getActualDelivery() {
        return actualDelivery;
    }

    public void setActualDelivery(LocalDate actualDelivery) {
        this.actualDelivery = actualDelivery;
    }

    public PaymentStatus getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(PaymentStatus paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Order order = (Order) o;
        return id != null && id.equals(order.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
