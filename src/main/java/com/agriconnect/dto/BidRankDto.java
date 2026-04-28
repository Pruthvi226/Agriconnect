package com.agriconnect.dto;

import java.math.BigDecimal;

public class BidRankDto {
    private Long yourBidId;
    private Integer yourRank;
    private Integer totalBids;
    private BigDecimal highestBidDelta; // percentage

    // Getters and Setters
    public Long getYourBidId() { return yourBidId; }
    public void setYourBidId(Long yourBidId) { this.yourBidId = yourBidId; }
    public Integer getYourRank() { return yourRank; }
    public void setYourRank(Integer yourRank) { this.yourRank = yourRank; }
    public Integer getTotalBids() { return totalBids; }
    public void setTotalBids(Integer totalBids) { this.totalBids = totalBids; }
    public BigDecimal getHighestBidDelta() { return highestBidDelta; }
    public void setHighestBidDelta(BigDecimal highestBidDelta) { this.highestBidDelta = highestBidDelta; }
}
