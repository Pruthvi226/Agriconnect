package com.agriconnect.dto;

import com.agriconnect.model.FpoListing;

import java.math.BigDecimal;
import java.time.LocalDate;

public class FpoListingResponseDto {
    private Long id;
    private Long fpoId;
    private String groupName;
    private String district;
    private String state;
    private String cropName;
    private BigDecimal totalQuantityKg;
    private BigDecimal minPricePerKg;
    private String qualityGrade;
    private LocalDate poolingDeadline;
    private boolean verified;
    private int totalMembers;
    private String badgeLabel;

    public FpoListingResponseDto(FpoListing listing) {
        this.id = listing.getId();
        this.fpoId = listing.getFpoGroup().getId();
        this.groupName = listing.getFpoGroup().getGroupName();
        this.district = listing.getFpoGroup().getDistrict();
        this.state = listing.getFpoGroup().getState();
        this.cropName = listing.getCropName();
        this.totalQuantityKg = listing.getTotalQuantityKg();
        this.minPricePerKg = listing.getMinPricePerKg();
        this.qualityGrade = listing.getQualityGrade();
        this.poolingDeadline = listing.getPoolingDeadline();
        this.verified = Boolean.TRUE.equals(listing.getFpoGroup().getIsVerified());
        this.totalMembers = listing.getFpoGroup().getTotalMembers() == null ? 0 : listing.getFpoGroup().getTotalMembers();
        this.badgeLabel = this.verified ? "FPO Verified" : "FPO";
    }

    public Long getId() { return id; }
    public Long getFpoId() { return fpoId; }
    public String getGroupName() { return groupName; }
    public String getDistrict() { return district; }
    public String getState() { return state; }
    public String getCropName() { return cropName; }
    public BigDecimal getTotalQuantityKg() { return totalQuantityKg; }
    public BigDecimal getMinPricePerKg() { return minPricePerKg; }
    public String getQualityGrade() { return qualityGrade; }
    public LocalDate getPoolingDeadline() { return poolingDeadline; }
    public boolean isVerified() { return verified; }
    public int getTotalMembers() { return totalMembers; }
    public String getBadgeLabel() { return badgeLabel; }
}
