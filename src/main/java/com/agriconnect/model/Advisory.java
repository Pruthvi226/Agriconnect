package com.agriconnect.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "advisories")
@Getter
@Setter
@NoArgsConstructor
public class Advisory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "expert_id", nullable = false)
    private User expert;

    @Column(length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String body;

    @Column(name = "crop_name", length = 100)
    private String cropName;

    @Convert(converter = AdvisoryTypeConverter.class)
    @Column(name = "advisory_type")
    private AdvisoryType advisoryType;

    @Convert(converter = SeverityConverter.class)
    private Severity severity;

    @Column(name = "affected_districts", columnDefinition = "JSON")
    private String affectedDistricts;

    @Column(name = "valid_until")
    private LocalDate validUntil;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public enum AdvisoryType {
        PEST, DISEASE, WEATHER, MARKET, TECHNIQUE;

        public static AdvisoryType fromExternalValue(String value) {
            String normalized = normalizeEnumValue(value, "Advisory type");
            return switch (normalized) {
                case "PEST_ALERT", "PEST_WARNING" -> PEST;
                case "DISEASE_ALERT", "DISEASE_WARNING" -> DISEASE;
                case "WEATHER_ALERT", "WEATHER_WARNING" -> WEATHER;
                case "MARKET_ALERT", "MARKET_UPDATE" -> MARKET;
                case "BEST_PRACTICES", "GOVERNMENT", "GOVERNMENT_SCHEME" -> TECHNIQUE;
                default -> AdvisoryType.valueOf(normalized);
            };
        }
    }

    public enum Severity {
        INFO, WARNING, CRITICAL;

        public static Severity fromExternalValue(String value) {
            String normalized = normalizeEnumValue(value, "Severity");
            return switch (normalized) {
                case "LOW", "NORMAL" -> INFO;
                case "HIGH", "MEDIUM" -> WARNING;
                case "URGENT" -> CRITICAL;
                default -> Severity.valueOf(normalized);
            };
        }
    }

    public static class AdvisoryTypeConverter implements AttributeConverter<AdvisoryType, String> {
        @Override
        public String convertToDatabaseColumn(AdvisoryType attribute) {
            return attribute == null ? null : attribute.name();
        }

        @Override
        public AdvisoryType convertToEntityAttribute(String dbData) {
            if (dbData == null || dbData.isBlank()) {
                return null;
            }
            return AdvisoryType.fromExternalValue(dbData);
        }
    }

    public static class SeverityConverter implements AttributeConverter<Severity, String> {
        @Override
        public String convertToDatabaseColumn(Severity attribute) {
            return attribute == null ? null : attribute.name();
        }

        @Override
        public Severity convertToEntityAttribute(String dbData) {
            if (dbData == null || dbData.isBlank()) {
                return null;
            }
            return Severity.fromExternalValue(dbData);
        }
    }

    private static String normalizeEnumValue(String value, String label) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException(label + " is required");
        }
        return value.trim()
                .toUpperCase()
                .replace('-', '_')
                .replace(' ', '_');
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getExpert() {
        return expert;
    }

    public void setExpert(User expert) {
        this.expert = expert;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getCropName() {
        return cropName;
    }

    public void setCropName(String cropName) {
        this.cropName = cropName;
    }

    public AdvisoryType getAdvisoryType() {
        return advisoryType;
    }

    public void setAdvisoryType(AdvisoryType advisoryType) {
        this.advisoryType = advisoryType;
    }

    public Severity getSeverity() {
        return severity;
    }

    public void setSeverity(Severity severity) {
        this.severity = severity;
    }

    public String getAffectedDistricts() {
        return affectedDistricts;
    }

    public void setAffectedDistricts(String affectedDistricts) {
        this.affectedDistricts = affectedDistricts;
    }

    public LocalDate getValidUntil() {
        return validUntil;
    }

    public void setValidUntil(LocalDate validUntil) {
        this.validUntil = validUntil;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Advisory advisory = (Advisory) o;
        return id != null && id.equals(advisory.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}
