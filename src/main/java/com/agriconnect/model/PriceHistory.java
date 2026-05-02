package com.agriconnect.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "price_history")
public class PriceHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "crop_name", nullable = false, length = 100)
    private String cropName;

    @Column(nullable = false, length = 100)
    private String district;

    @Column(name = "accepted_price", nullable = false, precision = 8, scale = 2)
    private BigDecimal acceptedPrice;

    @Column(name = "price_date", nullable = false)
    private LocalDate priceDate;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private Source source;

    public enum Source { ACCEPTED_BID, MARKET_FEED, MANUAL }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public BigDecimal getAcceptedPrice() { return acceptedPrice; }
    public void setAcceptedPrice(BigDecimal acceptedPrice) { this.acceptedPrice = acceptedPrice; }
    public LocalDate getPriceDate() { return priceDate; }
    public void setPriceDate(LocalDate priceDate) { this.priceDate = priceDate; }
    public Source getSource() { return source; }
    public void setSource(Source source) { this.source = source; }
}
