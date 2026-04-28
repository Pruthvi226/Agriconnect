package com.agriconnect.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;

public class BidRequestDto {
    @NotNull(message = "Listing ID is required")
    private Long listingId;

    @NotNull(message = "Bid price is required")
    @Positive(message = "Bid price must be greater than zero")
    private BigDecimal bidPricePerKg;

    @NotNull(message = "Quantity is required")
    @Positive(message = "Quantity must be greater than zero")
    private BigDecimal quantityKg;

    @Size(max = 200, message = "Message must not exceed 200 characters")
    private String message;

    // Getters and Setters
    public Long getListingId() { return listingId; }
    public void setListingId(Long listingId) { this.listingId = listingId; }
    public BigDecimal getBidPricePerKg() { return bidPricePerKg; }
    public void setBidPricePerKg(BigDecimal bidPricePerKg) { this.bidPricePerKg = bidPricePerKg; }
    public BigDecimal getQuantityKg() { return quantityKg; }
    public void setQuantityKg(BigDecimal quantityKg) { this.quantityKg = quantityKg; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
}
