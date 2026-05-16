package com.agriconnect.service;

import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.NotificationDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.model.Bid;
import com.agriconnect.model.BuyerProfile;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.Order;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.model.User;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

    @Mock
    private FarmerProfileDao farmerProfileDao;

    @Mock
    private OrderDao orderDao;

    @Mock
    private NotificationDao notificationDao;

    @Mock
    private SupplyChainService supplyChainService;

    @Mock
    private AuditService auditService;

    @InjectMocks
    private OrderService orderService;

    @Test
    void deliveredOrderGeneratesSupplyChainQr() {
        FarmerProfile farmer = new FarmerProfile();
        farmer.setId(7L);
        User farmerUser = new User();
        farmerUser.setId(21L);
        farmer.setUser(farmerUser);

        User buyerUser = new User();
        buyerUser.setId(33L);

        BuyerProfile buyer = new BuyerProfile();
        buyer.setId(9L);
        buyer.setUser(buyerUser);

        ProduceListing listing = new ProduceListing();
        listing.setCropName("Tomato");

        Bid bid = new Bid();
        bid.setListing(listing);

        Order order = new Order();
        order.setId(1L);
        order.setFarmer(farmer);
        order.setBuyer(buyer);
        order.setBid(bid);
        order.setOrderStatus(Order.OrderStatus.IN_TRANSIT);

        when(farmerProfileDao.findByUserId(21L)).thenReturn(Optional.of(farmer));
        when(orderDao.findDetailedById(1L)).thenReturn(Optional.of(order));

        Order updated = orderService.updateDeliveryStatus(1L, "DELIVERED", 21L);

        assertThat(updated.getOrderStatus()).isEqualTo(Order.OrderStatus.DELIVERED);
        verify(orderDao).update(order);
        verify(supplyChainService).generateQrForOrder(1L);
        verify(notificationDao).save(any());
    }
}
