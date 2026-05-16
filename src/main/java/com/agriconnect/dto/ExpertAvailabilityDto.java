package com.agriconnect.dto;

import com.agriconnect.model.BookingSlot;
import com.agriconnect.model.User;

import java.math.BigDecimal;

public class ExpertAvailabilityDto {

    private Long expertId;
    private String expertName;
    private String specialisation;
    private String languagesSpoken;
    private BigDecimal fee30min;
    private BigDecimal fee60min;
    private Integer totalSessions;
    private BigDecimal avgRating;
    private Long slotId;
    private String district;
    private String cropFocus;
    private String startTime;
    private String endTime;

    public ExpertAvailabilityDto(User expert, BookingSlot slot) {
        this.expertId = expert.getId();
        this.expertName = expert.getName();
        this.specialisation = expert.getSpecialisation();
        this.languagesSpoken = expert.getLanguagesSpoken();
        this.fee30min = expert.getConsultationFee30min();
        this.fee60min = expert.getConsultationFee60min();
        this.totalSessions = expert.getTotalSessions();
        this.avgRating = expert.getAvgRating();
        this.slotId = slot.getId();
        this.district = slot.getDistrict();
        this.cropFocus = slot.getCropFocus();
        this.startTime = slot.getStartTime() != null ? slot.getStartTime().toString() : null;
        this.endTime = slot.getEndTime() != null ? slot.getEndTime().toString() : null;
    }

    public Long getExpertId() { return expertId; }
    public String getExpertName() { return expertName; }
    public String getSpecialisation() { return specialisation; }
    public String getLanguagesSpoken() { return languagesSpoken; }
    public BigDecimal getFee30min() { return fee30min; }
    public BigDecimal getFee60min() { return fee60min; }
    public Integer getTotalSessions() { return totalSessions; }
    public BigDecimal getAvgRating() { return avgRating; }
    public Long getSlotId() { return slotId; }
    public String getDistrict() { return district; }
    public String getCropFocus() { return cropFocus; }
    public String getStartTime() { return startTime; }
    public String getEndTime() { return endTime; }
}
