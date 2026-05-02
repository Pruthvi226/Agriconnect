package com.agriconnect.service;

import com.agriconnect.dao.OrderDao;
import com.agriconnect.dao.SupplyChainTokenDao;
import com.agriconnect.dto.SupplyChainTraceView;
import com.agriconnect.model.Bid;
import com.agriconnect.model.BuyerProfile;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.Order;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.model.SupplyChainToken;
import com.agriconnect.model.User;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SupplyChainServiceTest {

    @Mock
    private SupplyChainTokenDao supplyChainTokenDao;

    @Mock
    private OrderDao orderDao;

    @InjectMocks
    private SupplyChainService supplyChainService;

    private Path tempQrDir;
    private Order order;

    @BeforeEach
    void setUp() throws Exception {
        tempQrDir = Files.createTempDirectory("agriconnect-qr");
        ReflectionTestUtils.setField(supplyChainService, "baseUrl", "http://localhost:8080/agriconnect");
        ReflectionTestUtils.setField(supplyChainService, "qrStorageDir", tempQrDir.toString());
        order = buildOrder();
    }

    @AfterEach
    void tearDown() throws Exception {
        if (tempQrDir != null) {
            try (var paths = Files.list(tempQrDir)) {
                paths.forEach(path -> {
                    try {
                        Files.deleteIfExists(path);
                    } catch (Exception ignored) {
                    }
                });
            }
            Files.deleteIfExists(tempQrDir);
        }
    }

    @Test
    void generateQrForOrderCreatesTokenAndPngFile() {
        when(orderDao.findDetailedById(1L)).thenReturn(Optional.of(order));
        when(supplyChainTokenDao.findByOrderId(1L)).thenReturn(Optional.empty());

        String qrUrl = supplyChainService.generateQrForOrder(1L);

        ArgumentCaptor<SupplyChainToken> tokenCaptor = ArgumentCaptor.forClass(SupplyChainToken.class);
        verify(supplyChainTokenDao).save(tokenCaptor.capture());
        SupplyChainToken savedToken = tokenCaptor.getValue();
        assertThat(savedToken.getToken()).isNotBlank();
        assertThat(qrUrl).contains("/qr/");
        assertThat(Files.exists(tempQrDir.resolve(savedToken.getToken() + ".png"))).isTrue();
        verify(supplyChainTokenDao).update(any(SupplyChainToken.class));
    }

    @Test
    void resolveSupplyChainTraceIncrementsScanCount() {
        SupplyChainToken token = new SupplyChainToken();
        token.setToken("trace-token");
        token.setOrder(order);
        token.setQrImagePath("trace-token.png");
        token.setScanCount(0);

        when(supplyChainTokenDao.findByToken("trace-token")).thenReturn(Optional.of(token));
        when(orderDao.findDetailedById(1L)).thenReturn(Optional.of(order));

        SupplyChainTraceView view = supplyChainService.resolveSupplyChainTrace("trace-token");

        assertThat(token.getScanCount()).isEqualTo(1);
        assertThat(view.getFarmerName()).isEqualTo("Ravi Farmer");
        assertThat(view.getCropName()).isEqualTo("Onion");
        verify(supplyChainTokenDao).update(token);
    }

    private Order buildOrder() {
        User farmerUser = new User();
        farmerUser.setId(10L);
        farmerUser.setName("Ravi Farmer");

        FarmerProfile farmer = new FarmerProfile();
        farmer.setId(2L);
        farmer.setUser(farmerUser);
        farmer.setDistrict("Nashik");
        farmer.setState("Maharashtra");
        farmer.setFarmerScore(new BigDecimal("82.50"));

        User buyerUser = new User();
        buyerUser.setId(11L);
        buyerUser.setName("Buyer");

        BuyerProfile buyer = new BuyerProfile();
        buyer.setId(3L);
        buyer.setUser(buyerUser);

        ProduceListing listing = new ProduceListing();
        listing.setId(4L);
        listing.setCropName("Onion");
        listing.setVariety("Nashik Red");
        listing.setQualityGrade(ProduceListing.QualityGrade.A);
        listing.setCreatedAt(LocalDateTime.now().minusDays(4));

        Bid bid = new Bid();
        bid.setId(5L);
        bid.setListing(listing);

        Order builtOrder = new Order();
        builtOrder.setId(1L);
        builtOrder.setBid(bid);
        builtOrder.setFarmer(farmer);
        builtOrder.setBuyer(buyer);
        builtOrder.setQuantityKg(new BigDecimal("500.00"));
        builtOrder.setActualDelivery(LocalDate.now());
        return builtOrder;
    }
}
