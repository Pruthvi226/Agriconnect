package com.agriconnect.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "market_prices")
public class MarketPrice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "crop_id", nullable = false)
    private Crop crop;

    @Column(nullable = false)
    private double msp; // Minimum Support Price

    @Column(nullable = false)
    private double currentAveragePrice;

    @Column(nullable = false)
    private LocalDate effectiveDate;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Crop getCrop() { return crop; }
    public void setCrop(Crop crop) { this.crop = crop; }
    public double getMsp() { return msp; }
    public void setMsp(double msp) { this.msp = msp; }
    public double getCurrentAveragePrice() { return currentAveragePrice; }
    public void setCurrentAveragePrice(double currentAveragePrice) { this.currentAveragePrice = currentAveragePrice; }
    public LocalDate getEffectiveDate() { return effectiveDate; }
    public void setEffectiveDate(LocalDate effectiveDate) { this.effectiveDate = effectiveDate; }
}
