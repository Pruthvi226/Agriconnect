package com.agriconnect.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "expert_consultations")
public class ExpertConsultation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "expert_id", nullable = false)
    private User expert;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "farmer_id", nullable = false)
    private FarmerProfile farmer;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "slot_id", nullable = false, unique = true)
    private BookingSlot slot;

    @Column(name = "crop_focus", length = 100)
    private String cropFocus;

    @Column(name = "farmer_district", length = 100)
    private String farmerDistrict;

    @Column(name = "duration_minutes", nullable = false)
    private Integer durationMinutes;

    @Column(name = "fee_amount", nullable = false, precision = 8, scale = 2)
    private BigDecimal feeAmount;

    @Enumerated(EnumType.STRING)
    @Column(name = "consultation_status", nullable = false)
    private ConsultationStatus consultationStatus = ConsultationStatus.BOOKED;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false)
    private PaymentStatus paymentStatus = PaymentStatus.PENDING;

    @Column(name = "razorpay_order_id", length = 100)
    private String razorpayOrderId;

    @Column(name = "razorpay_payment_id", length = 100)
    private String razorpayPaymentId;

    @Column(name = "session_link", length = 500)
    private String sessionLink;

    @Column(name = "reminder_sent")
    private Boolean reminderSent = false;

    @Column(name = "review_requested")
    private Boolean reviewRequested = false;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    public enum ConsultationStatus { BOOKED, COMPLETED, CANCELLED }
    public enum PaymentStatus { PENDING, PAID, REFUNDED }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.consultationStatus == null) this.consultationStatus = ConsultationStatus.BOOKED;
        if (this.paymentStatus == null) this.paymentStatus = PaymentStatus.PENDING;
        if (this.reminderSent == null) this.reminderSent = false;
        if (this.reviewRequested == null) this.reviewRequested = false;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getExpert() { return expert; }
    public void setExpert(User expert) { this.expert = expert; }
    public FarmerProfile getFarmer() { return farmer; }
    public void setFarmer(FarmerProfile farmer) { this.farmer = farmer; }
    public BookingSlot getSlot() { return slot; }
    public void setSlot(BookingSlot slot) { this.slot = slot; }
    public String getCropFocus() { return cropFocus; }
    public void setCropFocus(String cropFocus) { this.cropFocus = cropFocus; }
    public String getFarmerDistrict() { return farmerDistrict; }
    public void setFarmerDistrict(String farmerDistrict) { this.farmerDistrict = farmerDistrict; }
    public Integer getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(Integer durationMinutes) { this.durationMinutes = durationMinutes; }
    public BigDecimal getFeeAmount() { return feeAmount; }
    public void setFeeAmount(BigDecimal feeAmount) { this.feeAmount = feeAmount; }
    public ConsultationStatus getConsultationStatus() { return consultationStatus; }
    public void setConsultationStatus(ConsultationStatus consultationStatus) { this.consultationStatus = consultationStatus; }
    public PaymentStatus getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }
    public String getRazorpayOrderId() { return razorpayOrderId; }
    public void setRazorpayOrderId(String razorpayOrderId) { this.razorpayOrderId = razorpayOrderId; }
    public String getRazorpayPaymentId() { return razorpayPaymentId; }
    public void setRazorpayPaymentId(String razorpayPaymentId) { this.razorpayPaymentId = razorpayPaymentId; }
    public String getSessionLink() { return sessionLink; }
    public void setSessionLink(String sessionLink) { this.sessionLink = sessionLink; }
    public Boolean getReminderSent() { return reminderSent; }
    public void setReminderSent(Boolean reminderSent) { this.reminderSent = reminderSent; }
    public Boolean getReviewRequested() { return reviewRequested; }
    public void setReviewRequested(Boolean reviewRequested) { this.reviewRequested = reviewRequested; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(LocalDateTime completedAt) { this.completedAt = completedAt; }
}
