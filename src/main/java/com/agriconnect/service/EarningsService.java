package com.agriconnect.service;

import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.dto.EarningsDto;
import com.agriconnect.model.Order;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class EarningsService {

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private FarmerProfileDao farmerProfileDao;

    public EarningsDto getEarningsForFarmer(Long userId) {
        Long farmerId = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Farmer profile not found"))
                .getId();

        List<Order> orders = orderDao.findByFarmer(farmerId, Order.OrderStatus.DELIVERED);
        
        EarningsDto dto = new EarningsDto();
        dto.setMonthlyEarnings(BigDecimal.ZERO);
        dto.setYearlyEarnings(BigDecimal.ZERO);
        dto.setAllTimeEarnings(BigDecimal.ZERO);
        dto.setRecentOrders(new ArrayList<>());

        LocalDate now = LocalDate.now();
        
        for (Order o : orders) {
            BigDecimal amount = o.getTotalAmount();
            BigDecimal qty = o.getQuantityKg();
            
            dto.setAllTimeEarnings(dto.getAllTimeEarnings().add(amount));
            dto.setAllTimeOrders(dto.getAllTimeOrders() + 1);
            dto.setAllTimeKgSold(safeAdd(dto.getAllTimeKgSold(), qty));

            if (o.getActualDelivery() != null) {
                if (o.getActualDelivery().getYear() == now.getYear()) {
                    dto.setYearlyEarnings(dto.getYearlyEarnings().add(amount));
                    dto.setYearlyOrders(dto.getYearlyOrders() + 1);
                    dto.setYearlyKgSold(safeAdd(dto.getYearlyKgSold(), qty));

                    if (o.getActualDelivery().getMonth() == now.getMonth()) {
                        dto.setMonthlyEarnings(dto.getMonthlyEarnings().add(amount));
                        dto.setMonthlyOrders(dto.getMonthlyOrders() + 1);
                        dto.setMonthlyKgSold(safeAdd(dto.getMonthlyKgSold(), qty));
                    }
                }
            }

            EarningsDto.OrderSummaryDto summary = new EarningsDto.OrderSummaryDto();
            summary.setDate(o.getActualDelivery() != null ? o.getActualDelivery().toString() : "N/A");
            summary.setCrop(o.getBid().getListing().getCropName());
            summary.setQty(o.getQuantityKg());
            summary.setPrice(o.getFinalPricePerKg());
            summary.setTotal(o.getTotalAmount());
            summary.setBuyer(o.getBuyer().getCompanyName());
            summary.setStatus(o.getOrderStatus().toString());
            dto.getRecentOrders().add(summary);
        }

        return dto;
    }

    private BigDecimal safeAdd(BigDecimal current, BigDecimal add) {
        if (current == null) return add;
        if (add == null) return current;
        return current.add(add);
    }
}
