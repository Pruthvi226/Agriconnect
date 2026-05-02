package com.agriconnect.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "fpo_listings")
public class FpoListing {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fpo_id", nullable = false)
    private FpoGroup fpoGroup;

    @Column(name = "crop_name", nullable = false, length = 100)
    private String cropName;

    @Column(name = "total_quantity_kg", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalQuantityKg;

    @Column(name = "min_price_per_kg", nullable = false, precision = 8, scale = 2)
    private BigDecimal minPricePerKg;

    @Column(name = "quality_grade", length = 10)
    private String qualityGrade;

    @Column(name = "pooling_deadline", nullable = false)
    private LocalDate poolingDeadline;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Status status = Status.OPEN;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public enum Status { OPEN, CLOSED, SOLD }

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (status == null) {
            status = Status.OPEN;
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public FpoGroup getFpoGroup() { return fpoGroup; }
    public void setFpoGroup(FpoGroup fpoGroup) { this.fpoGroup = fpoGroup; }
    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }
    public BigDecimal getTotalQuantityKg() { return totalQuantityKg; }
    public void setTotalQuantityKg(BigDecimal totalQuantityKg) { this.totalQuantityKg = totalQuantityKg; }
    public BigDecimal getMinPricePerKg() { return minPricePerKg; }
    public void setMinPricePerKg(BigDecimal minPricePerKg) { this.minPricePerKg = minPricePerKg; }
    public String getQualityGrade() { return qualityGrade; }
    public void setQualityGrade(String qualityGrade) { this.qualityGrade = qualityGrade; }
    public LocalDate getPoolingDeadline() { return poolingDeadline; }
    public void setPoolingDeadline(LocalDate poolingDeadline) { this.poolingDeadline = poolingDeadline; }
    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
