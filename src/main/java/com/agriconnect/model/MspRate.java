package com.agriconnect.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "msp_rates")
@Getter
@Setter
@NoArgsConstructor
public class MspRate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "crop_name", length = 100, nullable = false)
    private String cropName;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Season season;

    @Column(name = "marketing_year", nullable = false)
    private Integer year;

    @Column(name = "msp_per_kg", precision = 8, scale = 2, nullable = false)
    private BigDecimal mspPerKg;

    @Column(name = "announced_at", nullable = false)
    private LocalDate announcedAt;

    public enum Season { KHARIF, RABI, ZAID }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCropName() {
        return cropName;
    }

    public void setCropName(String cropName) {
        this.cropName = cropName;
    }

    public Season getSeason() {
        return season;
    }

    public void setSeason(Season season) {
        this.season = season;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
    }

    public BigDecimal getMspPerKg() {
        return mspPerKg;
    }

    public void setMspPerKg(BigDecimal mspPerKg) {
        this.mspPerKg = mspPerKg;
    }

    public LocalDate getAnnouncedAt() {
        return announcedAt;
    }

    public void setAnnouncedAt(LocalDate announcedAt) {
        this.announcedAt = announcedAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MspRate mspRate = (MspRate) o;
        return id != null && id.equals(mspRate.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
