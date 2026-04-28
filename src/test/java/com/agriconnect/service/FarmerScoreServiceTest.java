package com.agriconnect.service;

import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class FarmerScoreServiceTest {

    @Mock
    private BaseDao<FarmerProfile, Long> farmerDao;
    @Mock
    private OrderDao orderDao;

    @InjectMocks
    private FarmerScoreService farmerScoreService;

    @Test
    void testRecomputeAllScores_PerfectFarmer() {
        FarmerProfile farmer = new FarmerProfile();
        farmer.setId(1L);
        farmer.setVillage("V");
        farmer.setDistrict("D");
        farmer.setState("S");
        farmer.setLandAcres(new BigDecimal("10"));
        farmer.setBankAccountEncrypted("encrypted"); // 5/5 profile = 100

        Order order1 = new Order();
        order1.setOrderStatus(Order.OrderStatus.DELIVERED);
        order1.setExpectedDelivery(LocalDate.now().plusDays(1));
        order1.setActualDelivery(LocalDate.now()); // On time
        order1.setQuantityKg(new BigDecimal("5000"));

        Order order2 = new Order();
        order2.setOrderStatus(Order.OrderStatus.DELIVERED);
        order2.setExpectedDelivery(LocalDate.now().plusDays(1));
        order2.setActualDelivery(LocalDate.now()); // On time
        order2.setQuantityKg(new BigDecimal("5000")); // Total 10000kg

        when(farmerDao.findAll()).thenReturn(List.of(farmer));
        when(orderDao.findByFarmer(eq(1L), isNull())).thenReturn(List.of(order1, order2));

        farmerScoreService.recomputeAllScores();

        // 40 + 30 + 20 + 10 = 100
        assertThat(farmer.getFarmerScore()).isEqualByComparingTo(BigDecimal.valueOf(100.0));
        verify(farmerDao, times(1)).update(farmer);
    }
    
    @Test
    void testRecomputeAllScores_NewFarmer() {
        FarmerProfile farmer = new FarmerProfile();
        farmer.setId(1L);

        when(farmerDao.findAll()).thenReturn(List.of(farmer));
        when(orderDao.findByFarmer(eq(1L), isNull())).thenReturn(List.of());

        farmerScoreService.recomputeAllScores();

        assertThat(farmer.getFarmerScore()).isEqualByComparingTo(BigDecimal.valueOf(50.0));
    }
}
