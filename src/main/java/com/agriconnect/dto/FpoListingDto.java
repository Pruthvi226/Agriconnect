package com.agriconnect.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public class FpoListingDto {
    private String cropName;
    private BigDecimal minPricePerKg;
    private String qualityGrade;
    private LocalDate poolingDeadline;

    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }
    public BigDecimal getMinPricePerKg() { return minPricePerKg; }
    public void setMinPricePerKg(BigDecimal minPricePerKg) { this.minPricePerKg = minPricePerKg; }
    public String getQualityGrade() { return qualityGrade; }
    public void setQualityGrade(String qualityGrade) { this.qualityGrade = qualityGrade; }
    public LocalDate getPoolingDeadline() { return poolingDeadline; }
    public void setPoolingDeadline(LocalDate poolingDeadline) { this.poolingDeadline = poolingDeadline; }
}
