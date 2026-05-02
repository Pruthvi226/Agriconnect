package com.agriconnect.model;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "booking_slots")
public class BookingSlot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "provider_id", nullable = false)
    private User provider;

    @Column(name = "slot_date", nullable = false)
    private LocalDate slotDate;

    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalTime endTime;

    @Column(length = 100)
    private String district;

    @Column(name = "crop_focus", length = 100)
    private String cropFocus;

    @Column(length = 255)
    private String notes;

    @Enumerated(EnumType.STRING)
    @Column(name = "slot_status", nullable = false)
    private SlotStatus slotStatus = SlotStatus.OPEN;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    public enum SlotStatus { OPEN, BOOKED, BLOCKED }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        if (this.slotStatus == null) {
            this.slotStatus = SlotStatus.OPEN;
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public User getProvider() { return provider; }
    public void setProvider(User provider) { this.provider = provider; }
    public LocalDate getSlotDate() { return slotDate; }
    public void setSlotDate(LocalDate slotDate) { this.slotDate = slotDate; }
    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }
    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getCropFocus() { return cropFocus; }
    public void setCropFocus(String cropFocus) { this.cropFocus = cropFocus; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public SlotStatus getSlotStatus() { return slotStatus; }
    public void setSlotStatus(SlotStatus slotStatus) { this.slotStatus = slotStatus; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
