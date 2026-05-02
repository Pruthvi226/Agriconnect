package com.agriconnect.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public class SupplyChainTraceView {

    private String token;
    private String publicUrl;
    private String qrImageUrl;
    private int scanCount;
    private String farmerName;
    private String district;
    private String state;
    private BigDecimal farmerScore;
    private String farmerScoreBadge;
    private String cropName;
    private String variety;
    private String qualityGrade;
    private LocalDate listingDate;
    private LocalDate pickupDate;
    private BigDecimal quantityKg;

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }
    public String getPublicUrl() { return publicUrl; }
    public void setPublicUrl(String publicUrl) { this.publicUrl = publicUrl; }
    public String getQrImageUrl() { return qrImageUrl; }
    public void setQrImageUrl(String qrImageUrl) { this.qrImageUrl = qrImageUrl; }
    public int getScanCount() { return scanCount; }
    public void setScanCount(int scanCount) { this.scanCount = scanCount; }
    public String getFarmerName() { return farmerName; }
    public void setFarmerName(String farmerName) { this.farmerName = farmerName; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public BigDecimal getFarmerScore() { return farmerScore; }
    public void setFarmerScore(BigDecimal farmerScore) { this.farmerScore = farmerScore; }
    public String getFarmerScoreBadge() { return farmerScoreBadge; }
    public void setFarmerScoreBadge(String farmerScoreBadge) { this.farmerScoreBadge = farmerScoreBadge; }
    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }
    public String getVariety() { return variety; }
    public void setVariety(String variety) { this.variety = variety; }
    public String getQualityGrade() { return qualityGrade; }
    public void setQualityGrade(String qualityGrade) { this.qualityGrade = qualityGrade; }
    public LocalDate getListingDate() { return listingDate; }
    public void setListingDate(LocalDate listingDate) { this.listingDate = listingDate; }
    public LocalDate getPickupDate() { return pickupDate; }
    public void setPickupDate(LocalDate pickupDate) { this.pickupDate = pickupDate; }
    public BigDecimal getQuantityKg() { return quantityKg; }
    public void setQuantityKg(BigDecimal quantityKg) { this.quantityKg = quantityKg; }
}
