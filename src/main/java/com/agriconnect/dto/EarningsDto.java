package com.agriconnect.dto;

import java.math.BigDecimal;
import java.util.List;

public class EarningsDto {
    private BigDecimal monthlyEarnings;
    private int monthlyOrders;
    private BigDecimal monthlyKgSold;
    private BigDecimal yearlyEarnings;
    private int yearlyOrders;
    private BigDecimal yearlyKgSold;
    private BigDecimal allTimeEarnings;
    private int allTimeOrders;
    private BigDecimal allTimeKgSold;
    private List<OrderSummaryDto> recentOrders;

    // Getters and Setters
    public BigDecimal getMonthlyEarnings() { return monthlyEarnings; }
    public void setMonthlyEarnings(BigDecimal monthlyEarnings) { this.monthlyEarnings = monthlyEarnings; }
    public int getMonthlyOrders() { return monthlyOrders; }
    public void setMonthlyOrders(int monthlyOrders) { this.monthlyOrders = monthlyOrders; }
    public BigDecimal getMonthlyKgSold() { return monthlyKgSold; }
    public void setMonthlyKgSold(BigDecimal monthlyKgSold) { this.monthlyKgSold = monthlyKgSold; }
    public BigDecimal getYearlyEarnings() { return yearlyEarnings; }
    public void setYearlyEarnings(BigDecimal yearlyEarnings) { this.yearlyEarnings = yearlyEarnings; }
    public int getYearlyOrders() { return yearlyOrders; }
    public void setYearlyOrders(int yearlyOrders) { this.yearlyOrders = yearlyOrders; }
    public BigDecimal getYearlyKgSold() { return yearlyKgSold; }
    public void setYearlyKgSold(BigDecimal yearlyKgSold) { this.yearlyKgSold = yearlyKgSold; }
    public BigDecimal getAllTimeEarnings() { return allTimeEarnings; }
    public void setAllTimeEarnings(BigDecimal allTimeEarnings) { this.allTimeEarnings = allTimeEarnings; }
    public int getAllTimeOrders() { return allTimeOrders; }
    public void setAllTimeOrders(int allTimeOrders) { this.allTimeOrders = allTimeOrders; }
    public BigDecimal getAllTimeKgSold() { return allTimeKgSold; }
    public void setAllTimeKgSold(BigDecimal allTimeKgSold) { this.allTimeKgSold = allTimeKgSold; }
    public List<OrderSummaryDto> getRecentOrders() { return recentOrders; }
    public void setRecentOrders(List<OrderSummaryDto> recentOrders) { this.recentOrders = recentOrders; }

    public static class OrderSummaryDto {
        private String date;
        private String crop;
        private BigDecimal qty;
        private BigDecimal price;
        private BigDecimal total;
        private String buyer;
        private String status;

        // Getters and Setters
        public String getDate() { return date; }
        public void setDate(String date) { this.date = date; }
        public String getCrop() { return crop; }
        public void setCrop(String crop) { this.crop = crop; }
        public BigDecimal getQty() { return qty; }
        public void setQty(BigDecimal qty) { this.qty = qty; }
        public BigDecimal getPrice() { return price; }
        public void setPrice(BigDecimal price) { this.price = price; }
        public BigDecimal getTotal() { return total; }
        public void setTotal(BigDecimal total) { this.total = total; }
        public String getBuyer() { return buyer; }
        public void setBuyer(String buyer) { this.buyer = buyer; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }
}
