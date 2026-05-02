package com.agriconnect.dto;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.time.LocalTime;

public class BookingSlotDto {

    @NotNull
    @FutureOrPresent
    private LocalDate slotDate;

    @NotNull
    private LocalTime startTime;

    @NotNull
    private LocalTime endTime;

    @NotBlank
    private String district;

    @NotBlank
    private String cropFocus;

    private String notes;

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
}
