package com.agriconnect.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;

@com.agriconnect.validation.ValidDateRange
public class ListingRequestDto {
    @NotBlank(message = "Crop name is required")
    private String cropName;

    @NotBlank(message = "Variety is required")
    private String variety;

    @NotNull(message = "Quantity is required")
    @Positive(message = "Quantity must be greater than zero")
    private BigDecimal quantityKg;

    @NotNull(message = "Available from date is required")
    @FutureOrPresent(message = "Available from date must be in the future or present")
    private LocalDate availableFrom;

    @NotNull(message = "Available until date is required")
    @FutureOrPresent(message = "Available until date must be in the future or present")
    private LocalDate availableUntil;

    @NotNull(message = "Asking price is required")
    @Positive(message = "Price must be greater than zero")
    private BigDecimal askingPricePerKg;

    private String qualityGrade; // A, B, C
    
    @Size(max = 500, message = "Description must not exceed 500 characters")
    private String description;

    private String district;

    private Boolean isUrgent = false;

    @Size(max = 200, message = "Reason must not exceed 200 characters")
    private String urgentReason;
    
    // Getters and Setters
    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }
    public String getVariety() { return variety; }
    public void setVariety(String variety) { this.variety = variety; }
    public BigDecimal getQuantityKg() { return quantityKg; }
    public void setQuantityKg(BigDecimal quantityKg) { this.quantityKg = quantityKg; }
    public LocalDate getAvailableFrom() { return availableFrom; }
    public void setAvailableFrom(LocalDate availableFrom) { this.availableFrom = availableFrom; }
    public LocalDate getAvailableUntil() { return availableUntil; }
    public void setAvailableUntil(LocalDate availableUntil) { this.availableUntil = availableUntil; }
    public BigDecimal getAskingPricePerKg() { return askingPricePerKg; }
    public void setAskingPricePerKg(BigDecimal askingPricePerKg) { this.askingPricePerKg = askingPricePerKg; }
    public String getQualityGrade() { return qualityGrade; }
    public void setQualityGrade(String qualityGrade) { this.qualityGrade = qualityGrade; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public Boolean getIsUrgent() { return isUrgent; }
    public void setIsUrgent(Boolean isUrgent) { this.isUrgent = isUrgent; }
    public String getUrgentReason() { return urgentReason; }
    public void setUrgentReason(String urgentReason) { this.urgentReason = urgentReason; }
}
