package com.agriconnect.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "demand_forecast_cache")
public class DemandForecastCache {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "report_json", columnDefinition = "TEXT", nullable = false)
    private String reportJson;

    @Column(name = "generated_at", updatable = false)
    private LocalDateTime generatedAt;

    @PrePersist
    protected void onCreate() {
        if (this.generatedAt == null) {
            this.generatedAt = LocalDateTime.now();
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getReportJson() { return reportJson; }
    public void setReportJson(String reportJson) { this.reportJson = reportJson; }
    public LocalDateTime getGeneratedAt() { return generatedAt; }
    public void setGeneratedAt(LocalDateTime generatedAt) { this.generatedAt = generatedAt; }
}
