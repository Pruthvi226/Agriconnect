package com.agriconnect.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "bids")
public class Bid {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "listing_id")
    private ProduceListing listing;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "buyer_id")
    private BuyerProfile buyer;

    @Column(name = "bid_price_per_kg", precision = 8, scale = 2)
    private BigDecimal bidPricePerKg;

    @Column(name = "quantity_kg", precision = 10, scale = 2)
    private BigDecimal quantityKg;

    @Enumerated(EnumType.STRING)
    @Column(name = "bid_status")
    private BidStatus bidStatus = BidStatus.PENDING;

    @Column(columnDefinition = "TEXT")
    private String message;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "counter_price_per_kg", precision = 8, scale = 2)
    private BigDecimal counterPricePerKg;

    @Column(name = "counter_message", length = 300)
    private String counterMessage;

    public enum BidStatus { PENDING, ACCEPTED, REJECTED, WITHDRAWN, EXPIRED, COUNTERED }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.bidStatus == null) {
            this.bidStatus = BidStatus.PENDING;
        }
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public ProduceListing getListing() { return listing; }
    public void setListing(ProduceListing listing) { this.listing = listing; }
    public BuyerProfile getBuyer() { return buyer; }
    public void setBuyer(BuyerProfile buyer) { this.buyer = buyer; }
    public BigDecimal getBidPricePerKg() { return bidPricePerKg; }
    public void setBidPricePerKg(BigDecimal bidPricePerKg) { this.bidPricePerKg = bidPricePerKg; }
    public BigDecimal getQuantityKg() { return quantityKg; }
    public void setQuantityKg(BigDecimal quantityKg) { this.quantityKg = quantityKg; }
    public BidStatus getBidStatus() { return bidStatus; }
    public void setBidStatus(BidStatus bidStatus) { this.bidStatus = bidStatus; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getExpiresAt() { return expiresAt; }
    public void setExpiresAt(LocalDateTime expiresAt) { this.expiresAt = expiresAt; }
    public BigDecimal getCounterPricePerKg() { return counterPricePerKg; }
    public void setCounterPricePerKg(BigDecimal counterPricePerKg) { this.counterPricePerKg = counterPricePerKg; }
    public String getCounterMessage() { return counterMessage; }
    public void setCounterMessage(String counterMessage) { this.counterMessage = counterMessage; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Bid bid = (Bid) o;
        return id != null && id.equals(bid.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
