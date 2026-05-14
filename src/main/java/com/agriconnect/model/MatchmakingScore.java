package com.agriconnect.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "matchmaking_scores")
@Getter
@Setter
@NoArgsConstructor
public class MatchmakingScore {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "farmer_id", nullable = false)
    private FarmerProfile farmer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "buyer_id", nullable = false)
    private BuyerProfile buyer;

    @Column(precision = 5, scale = 2)
    private BigDecimal score;

    @Column(columnDefinition = "JSON")
    private String factors;

    @Column(name = "computed_at", updatable = false)
    private LocalDateTime computedAt;

    @PrePersist
    protected void onCreate() {
        this.computedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public String getFactors() {
        return factors;
    }

    public void setFactors(String factors) {
        this.factors = factors;
    }

    public LocalDateTime getComputedAt() {
        return computedAt;
    }

    public void setComputedAt(LocalDateTime computedAt) {
        this.computedAt = computedAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MatchmakingScore that = (MatchmakingScore) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
