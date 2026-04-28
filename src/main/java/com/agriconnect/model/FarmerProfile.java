package com.agriconnect.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "farmer_profiles")
public class FarmerProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(length = 100)
    private String village;

    @Column(length = 100)
    private String district;

    @Column(length = 100)
    private String state;

    @Column(precision = 9, scale = 6)
    private BigDecimal lat;

    @Column(precision = 9, scale = 6)
    private BigDecimal lng;

    @Column(name = "land_acres", precision = 8, scale = 2)
    private BigDecimal landAcres;

    @JsonIgnore
    @Column(name = "bank_account_encrypted", length = 500)
    private String bankAccountEncrypted;

    @JsonIgnore
    @Column(name = "aadhaar_hash", length = 64)
    private String aadhaarHash;

    @Column(name = "farmer_score", precision = 4, scale = 2)
    private BigDecimal farmerScore = new BigDecimal("50.00");

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public String getVillage() { return village; }
    public void setVillage(String village) { this.village = village; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public BigDecimal getLat() { return lat; }
    public void setLat(BigDecimal lat) { this.lat = lat; }
    public BigDecimal getLng() { return lng; }
    public void setLng(BigDecimal lng) { this.lng = lng; }
    public BigDecimal getLandAcres() { return landAcres; }
    public void setLandAcres(BigDecimal landAcres) { this.landAcres = landAcres; }
    public String getAadhaarHash() { return aadhaarHash; }
    public void setAadhaarHash(String aadhaarPlain) { 
        this.aadhaarHash = com.agriconnect.util.EncryptionUtil.hashAadhaar(aadhaarPlain); 
    }

    public String getBankAccountEncrypted() { return bankAccountEncrypted; }
    public void setBankAccountEncrypted(String bankAccountPlain) { 
        try {
            this.bankAccountEncrypted = com.agriconnect.util.EncryptionUtil.encryptBankDetails(bankAccountPlain); 
        } catch (Exception e) {
            throw new RuntimeException("Failed to encrypt bank account", e);
        }
    }
    
    public String getDecryptedBankAccount() {
        try {
            return com.agriconnect.util.EncryptionUtil.decryptBankDetails(this.bankAccountEncrypted);
        } catch (Exception e) {
            return null;
        }
    }

    public BigDecimal getFarmerScore() { return farmerScore; }
    public void setFarmerScore(BigDecimal farmerScore) { this.farmerScore = farmerScore; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FarmerProfile that = (FarmerProfile) o;
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
