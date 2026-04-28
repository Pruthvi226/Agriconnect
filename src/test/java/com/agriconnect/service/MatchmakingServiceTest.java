package com.agriconnect.service;

import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.MatchmakingDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.model.BuyerProfile;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.MatchmakingScore;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class MatchmakingServiceTest {

    @Mock
    private MatchmakingDao matchmakingDao;
    @Mock
    private BaseDao<FarmerProfile, Long> farmerDao;
    @Mock
    private BaseDao<BuyerProfile, Long> buyerDao;
    @Mock
    private OrderDao orderDao;

    @InjectMocks
    private MatchmakingService matchmakingService;

    @Test
    void testComputeAllScores_SavesMatch() {
        FarmerProfile farmer = new FarmerProfile();
        farmer.setId(1L);
        farmer.setLat(new BigDecimal("19.0760")); // Exact match with buyer stub
        farmer.setLng(new BigDecimal("72.8777"));

        BuyerProfile buyer = new BuyerProfile();
        buyer.setId(1L);
        buyer.setPreferredCrops("[\"Wheat\"]");

        when(farmerDao.findAll()).thenReturn(List.of(farmer));
        when(buyerDao.findAll()).thenReturn(List.of(buyer));
        when(orderDao.findByBuyer(anyLong(), any())).thenReturn(Collections.emptyList());

        matchmakingService.computeAllScores();

        verify(matchmakingDao, times(1)).save(any(MatchmakingScore.class));
    }
}
