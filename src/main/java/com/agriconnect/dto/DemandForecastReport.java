package com.agriconnect.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class DemandForecastReport {

    private List<CropDemandSnapshot> topCrops = new ArrayList<>();
    private List<DistrictDemandSnapshot> hotDistricts = new ArrayList<>();
    private List<PriceTrendSnapshot> priceTrends = new ArrayList<>();
    private List<PriceTrendSnapshot> risingPriceCrops = new ArrayList<>();
    private List<PriceTrendSnapshot> fallingPriceCrops = new ArrayList<>();
    private LocalDateTime generatedAt;

    public List<CropDemandSnapshot> getTopCrops() { return topCrops; }
    public void setTopCrops(List<CropDemandSnapshot> topCrops) { this.topCrops = topCrops; }
    public List<DistrictDemandSnapshot> getHotDistricts() { return hotDistricts; }
    public void setHotDistricts(List<DistrictDemandSnapshot> hotDistricts) { this.hotDistricts = hotDistricts; }
    public List<PriceTrendSnapshot> getPriceTrends() { return priceTrends; }
    public void setPriceTrends(List<PriceTrendSnapshot> priceTrends) { this.priceTrends = priceTrends; }
    public List<PriceTrendSnapshot> getRisingPriceCrops() { return risingPriceCrops; }
    public void setRisingPriceCrops(List<PriceTrendSnapshot> risingPriceCrops) { this.risingPriceCrops = risingPriceCrops; }
    public List<PriceTrendSnapshot> getFallingPriceCrops() { return fallingPriceCrops; }
    public void setFallingPriceCrops(List<PriceTrendSnapshot> fallingPriceCrops) { this.fallingPriceCrops = fallingPriceCrops; }
    public LocalDateTime getGeneratedAt() { return generatedAt; }
    public void setGeneratedAt(LocalDateTime generatedAt) { this.generatedAt = generatedAt; }

    public static class CropDemandSnapshot {
        private String cropName;
        private long bidCount;
        private BigDecimal avgPrice;

        public CropDemandSnapshot() { }

        public CropDemandSnapshot(String cropName, long bidCount, BigDecimal avgPrice) {
            this.cropName = cropName;
            this.bidCount = bidCount;
            this.avgPrice = avgPrice;
        }

        public String getCropName() { return cropName; }
        public void setCropName(String cropName) { this.cropName = cropName; }
        public long getBidCount() { return bidCount; }
        public void setBidCount(long bidCount) { this.bidCount = bidCount; }
        public BigDecimal getAvgPrice() { return avgPrice; }
        public void setAvgPrice(BigDecimal avgPrice) { this.avgPrice = avgPrice; }
    }

    public static class DistrictDemandSnapshot {
        private String district;
        private String cropName;
        private BigDecimal unfulfilledDemand;

        public DistrictDemandSnapshot() { }

        public DistrictDemandSnapshot(String district, String cropName, BigDecimal unfulfilledDemand) {
            this.district = district;
            this.cropName = cropName;
            this.unfulfilledDemand = unfulfilledDemand;
        }

        public String getDistrict() { return district; }
        public void setDistrict(String district) { this.district = district; }
        public String getCropName() { return cropName; }
        public void setCropName(String cropName) { this.cropName = cropName; }
        public BigDecimal getUnfulfilledDemand() { return unfulfilledDemand; }
        public void setUnfulfilledDemand(BigDecimal unfulfilledDemand) { this.unfulfilledDemand = unfulfilledDemand; }
    }

    public static class PriceTrendSnapshot {
        private String cropName;
        private BigDecimal latestPrice;
        private BigDecimal oldestPrice;
        private BigDecimal changePercent;
        private String direction;

        public PriceTrendSnapshot() { }

        public PriceTrendSnapshot(String cropName, BigDecimal latestPrice, BigDecimal oldestPrice, BigDecimal changePercent, String direction) {
            this.cropName = cropName;
            this.latestPrice = latestPrice;
            this.oldestPrice = oldestPrice;
            this.changePercent = changePercent;
            this.direction = direction;
        }

        public String getCropName() { return cropName; }
        public void setCropName(String cropName) { this.cropName = cropName; }
        public BigDecimal getLatestPrice() { return latestPrice; }
        public void setLatestPrice(BigDecimal latestPrice) { this.latestPrice = latestPrice; }
        public BigDecimal getOldestPrice() { return oldestPrice; }
        public void setOldestPrice(BigDecimal oldestPrice) { this.oldestPrice = oldestPrice; }
        public BigDecimal getChangePercent() { return changePercent; }
        public void setChangePercent(BigDecimal changePercent) { this.changePercent = changePercent; }
        public String getDirection() { return direction; }
        public void setDirection(String direction) { this.direction = direction; }
    }
}
