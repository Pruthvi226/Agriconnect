package com.agriconnect.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;

@Entity
@Table(name = "buyer_profiles")
@Getter
@Setter
@NoArgsConstructor
public class BuyerProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "company_name", length = 200)
    private String companyName;

    @Column(length = 20, unique = true)
    private String gstin;

    @Enumerated(EnumType.STRING)
    @Column(name = "business_type")
    private BusinessType businessType;

    @Column(name = "preferred_crops", columnDefinition = "JSON")
    private String preferredCrops;

    @Column(name = "preferred_districts", columnDefinition = "JSON")
    private String preferredDistricts;

    @Column(name = "credit_limit", precision = 12, scale = 2)
    private BigDecimal creditLimit;

    public enum BusinessType { RETAILER, WHOLESALER, EXPORTER, PROCESSOR }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getGstin() {
        return gstin;
    }

    public void setGstin(String gstin) {
        this.gstin = gstin;
    }

    public BusinessType getBusinessType() {
        return businessType;
    }

    public void setBusinessType(BusinessType businessType) {
        this.businessType = businessType;
    }

    public String getPreferredCrops() {
        return preferredCrops;
    }

    public void setPreferredCrops(String preferredCrops) {
        this.preferredCrops = preferredCrops;
    }

    public String getPreferredDistricts() {
        return preferredDistricts;
    }

    public void setPreferredDistricts(String preferredDistricts) {
        this.preferredDistricts = preferredDistricts;
    }

    public BigDecimal getCreditLimit() {
        return creditLimit;
    }

    public void setCreditLimit(BigDecimal creditLimit) {
        this.creditLimit = creditLimit;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BuyerProfile that = (BuyerProfile) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
