package com.agriconnect.dto;

import com.agriconnect.model.ExpertConsultation;

import java.math.BigDecimal;

public class ConsultationBookingResponseDto {

    private Long bookingId;
    private String expertName;
    private String farmerName;
    private String crop;
    private String district;
    private Integer durationMinutes;
    private BigDecimal feeAmount;
    private String razorpayOrderId;
    private String paymentStatus;
    private String consultationStatus;
    private String slotDate;
    private String startTime;
    private String sessionLink;

    public ConsultationBookingResponseDto(ExpertConsultation consultation) {
        this.bookingId = consultation.getId();
        this.expertName = consultation.getExpert().getName();
        this.farmerName = consultation.getFarmer().getUser().getName();
        this.crop = consultation.getCropFocus();
        this.district = consultation.getFarmerDistrict();
        this.durationMinutes = consultation.getDurationMinutes();
        this.feeAmount = consultation.getFeeAmount();
        this.razorpayOrderId = consultation.getRazorpayOrderId();
        this.paymentStatus = consultation.getPaymentStatus().name();
        this.consultationStatus = consultation.getConsultationStatus().name();
        this.slotDate = consultation.getSlot().getSlotDate() != null ? consultation.getSlot().getSlotDate().toString() : null;
        this.startTime = consultation.getSlot().getStartTime() != null ? consultation.getSlot().getStartTime().toString() : null;
        this.sessionLink = consultation.getSessionLink();
    }

    public Long getBookingId() { return bookingId; }
    public String getExpertName() { return expertName; }
    public String getFarmerName() { return farmerName; }
    public String getCrop() { return crop; }
    public String getDistrict() { return district; }
    public Integer getDurationMinutes() { return durationMinutes; }
    public BigDecimal getFeeAmount() { return feeAmount; }
    public String getRazorpayOrderId() { return razorpayOrderId; }
    public String getPaymentStatus() { return paymentStatus; }
    public String getConsultationStatus() { return consultationStatus; }
    public String getSlotDate() { return slotDate; }
    public String getStartTime() { return startTime; }
    public String getSessionLink() { return sessionLink; }
}
