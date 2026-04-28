package com.agriconnect.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.util.List;

public class AdvisoryRequestDto {
    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Body is required")
    private String body;

    private String cropName;

    @NotBlank(message = "Advisory type is required")
    private String advisoryType;

    @NotBlank(message = "Severity is required")
    private String severity;

    @NotNull(message = "Affected districts are required")
    private List<String> affectedDistricts;

    @NotNull(message = "Valid until date is required")
    @FutureOrPresent(message = "Valid until must be future or present")
    private LocalDate validUntil;

    // Getters and Setters
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getBody() { return body; }
    public void setBody(String body) { this.body = body; }
    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }
    public String getAdvisoryType() { return advisoryType; }
    public void setAdvisoryType(String advisoryType) { this.advisoryType = advisoryType; }
    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }
    public List<String> getAffectedDistricts() { return affectedDistricts; }
    public void setAffectedDistricts(List<String> affectedDistricts) { this.affectedDistricts = affectedDistricts; }
    public LocalDate getValidUntil() { return validUntil; }
    public void setValidUntil(LocalDate validUntil) { this.validUntil = validUntil; }
}
