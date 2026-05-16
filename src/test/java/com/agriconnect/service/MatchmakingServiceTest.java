package com.agriconnect.service;

import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.MatchmakingDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.model.BuyerProfile;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.ProduceListing;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Collections;

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
    private ProduceListingDao produceListingDao;
    @Mock
    private OrderDao orderDao;

    @InjectMocks
    private MatchmakingService matchmakingService;

    @Test
    void computeAllScores_ShouldPersistScores_WhenMatchesExist() {
        // Arrange
        FarmerProfile farmer = new FarmerProfile();
        farmer.setId(1L);
        farmer.setLat(new BigDecimal("32.1109"));
        farmer.setLng(new BigDecimal("76.5363"));

        BuyerProfile buyer = new BuyerProfile();
        buyer.setId(1L);
        buyer.setPreferredCrops("[\"Wheat\"]");
        buyer.setPreferredDistricts("[\"Kangra\"]");

        ProduceListing listing = new ProduceListing();
        listing.setCropName("Wheat");

        when(farmerDao.findAll()).thenReturn(Collections.singletonList(farmer));
        when(buyerDao.findAll()).thenReturn(Collections.singletonList(buyer));
        when(produceListingDao.findByFarmer(1L, ProduceListing.Status.ACTIVE))
                .thenReturn(Collections.singletonList(listing));

        // Act
        matchmakingService.computeAllScores();

        // Assert
        verify(matchmakingDao, atLeastOnce()).save(any());
    }
}
