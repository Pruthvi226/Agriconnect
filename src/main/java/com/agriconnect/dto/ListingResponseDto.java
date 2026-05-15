package com.agriconnect.dto;

import com.agriconnect.model.ProduceListing;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

public class ListingResponseDto {
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    private Long id;
    private String cropName;
    private String variety;
    private BigDecimal quantityKg;
    private BigDecimal askingPrice;
    private BigDecimal mspPrice;
    private BigDecimal mspDiffPercent;
    private String mspBadge; // BELOW_MSP, AT_MSP, ABOVE_MSP
    private String district;
    private List<String> photos = new ArrayList<>();
    private String firstPhotoUrl;

    public ListingResponseDto(ProduceListing listing) {
        this.id = listing.getId();
        this.cropName = listing.getCropName();
        this.variety = listing.getVariety();
        this.quantityKg = listing.getQuantityKg();
        this.askingPrice = listing.getAskingPricePerKg();
        this.mspPrice = listing.getMspPricePerKg();
        this.district = listing.getDistrict();
        this.photos = readPhotos(listing.getPhotos());
        this.firstPhotoUrl = this.photos.isEmpty() ? null : this.photos.get(0);

        if (this.mspPrice != null && this.askingPrice != null) {
            BigDecimal diff = this.askingPrice.subtract(this.mspPrice);
            this.mspDiffPercent = diff.divide(this.mspPrice, 4, RoundingMode.HALF_UP).multiply(new BigDecimal("100"));
            
            if (this.mspDiffPercent.compareTo(BigDecimal.ZERO) < 0) {
                this.mspBadge = "BELOW_MSP";
            } else if (this.mspDiffPercent.compareTo(BigDecimal.ZERO) == 0) {
                this.mspBadge = "AT_MSP";
            } else {
                this.mspBadge = "ABOVE_MSP";
            }
        } else {
            this.mspBadge = "UNKNOWN";
        }
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCropName() { return cropName; }
    public void setCropName(String cropName) { this.cropName = cropName; }
    public String getVariety() { return variety; }
    public void setVariety(String variety) { this.variety = variety; }
    public BigDecimal getQuantityKg() { return quantityKg; }
    public void setQuantityKg(BigDecimal quantityKg) { this.quantityKg = quantityKg; }
    public BigDecimal getAskingPrice() { return askingPrice; }
    public void setAskingPrice(BigDecimal askingPrice) { this.askingPrice = askingPrice; }
    public BigDecimal getMspPrice() { return mspPrice; }
    public void setMspPrice(BigDecimal mspPrice) { this.mspPrice = mspPrice; }
    public BigDecimal getMspDiffPercent() { return mspDiffPercent; }
    public void setMspDiffPercent(BigDecimal mspDiffPercent) { this.mspDiffPercent = mspDiffPercent; }
    public String getMspBadge() { return mspBadge; }
    public void setMspBadge(String mspBadge) { this.mspBadge = mspBadge; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public List<String> getPhotos() { return photos; }
    public void setPhotos(List<String> photos) { this.photos = photos; }
    public String getFirstPhotoUrl() { return firstPhotoUrl; }
    public void setFirstPhotoUrl(String firstPhotoUrl) { this.firstPhotoUrl = firstPhotoUrl; }

    private List<String> readPhotos(String photosJson) {
        if (photosJson == null || photosJson.isBlank()) {
            return new ArrayList<>();
        }
        try {
            return new ArrayList<>(OBJECT_MAPPER.readValue(photosJson, new TypeReference<List<String>>() {}));
        } catch (Exception ex) {
            return new ArrayList<>();
        }
    }
}
