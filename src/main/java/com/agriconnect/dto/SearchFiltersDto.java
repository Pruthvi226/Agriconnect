package com.agriconnect.dto;

import java.math.BigDecimal;

public class SearchFiltersDto {
    private String cropName;
    private String district;
    private BigDecimal minPrice;
    private BigDecimal maxPrice;
    private String qualityGrade;
    private Integer radiusKm;
    private BigDecimal buyerLat;
    private BigDecimal buyerLng;

    // Getters and Setters
    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public BigDecimal getMinPrice() { return minPrice; }
    public void setMinPrice(BigDecimal minPrice) { this.minPrice = minPrice; }
    public BigDecimal getMaxPrice() { return maxPrice; }
    public void setMaxPrice(BigDecimal maxPrice) { this.maxPrice = maxPrice; }
    public String getQualityGrade() { return qualityGrade; }
    public void setQualityGrade(String qualityGrade) { this.qualityGrade = qualityGrade; }
    public Integer getRadiusKm() { return radiusKm; }
    public void setRadiusKm(Integer radiusKm) { this.radiusKm = radiusKm; }
    public BigDecimal getBuyerLat() { return buyerLat; }
    public void setBuyerLat(BigDecimal buyerLat) { this.buyerLat = buyerLat; }
    public BigDecimal getBuyerLng() { return buyerLng; }
    public void setBuyerLng(BigDecimal buyerLng) { this.buyerLng = buyerLng; }
}
