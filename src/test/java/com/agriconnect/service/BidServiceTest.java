package com.agriconnect.service;

import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.BidDao;
import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.NotificationDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.dao.PriceHistoryDao;
import com.agriconnect.dao.WalletTransactionDao;
import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.model.Bid;
import com.agriconnect.model.BuyerProfile;
import com.agriconnect.model.Order;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class BidServiceTest {

    @Mock
    private BidDao bidDao;
    @Mock
    private ProduceListingDao listingDao;
    @Mock
    private BaseDao<BuyerProfile, Long> buyerDao;
    @Mock
    private FarmerProfileDao farmerProfileDao;
    @Mock
    private OrderDao orderDao;
    @Mock
    private NotificationDao notificationDao;
    @Mock
    private WalletTransactionDao walletTransactionDao;
    @Mock
    private PriceHistoryDao priceHistoryDao;
    @Mock
    private AuditService auditService;

    @InjectMocks
    private BidService bidService;

    private BidRequestDto dto;
    private ProduceListing listing;
    private BuyerProfile buyer;

    @BeforeEach
    void setUp() {
        dto = new BidRequestDto();
        dto.setListingId(1L);
        dto.setBidPricePerKg(BigDecimal.valueOf(22));
        dto.setQuantityKg(BigDecimal.valueOf(50));

        listing = new ProduceListing();
        listing.setId(1L);

        buyer = new BuyerProfile();
        buyer.setId(1L);
    }

    @Test
    void testPlaceBid_DuplicatePrevented() {
        when(listingDao.findById(1L)).thenReturn(Optional.of(listing));
        when(buyerDao.findById(1L)).thenReturn(Optional.of(buyer));
        when(bidDao.findActiveBidsByBuyer(1L)).thenReturn(List.of(new Bid())); // Pretend buyer already has active bids, need to mock carefully

        Bid existingBid = new Bid();
        existingBid.setListing(listing);
        when(bidDao.findActiveBidsByBuyer(1L)).thenReturn(List.of(existingBid));

        RuntimeException exception = assertThrows(RuntimeException.class, () -> {
            bidService.placeBid(dto, 1L);
        });
        assertThat(exception.getMessage()).contains("You already have an active bid");
    }

    @Test
    void testAcceptBid_CreatesOrder() {
        Bid bid = new Bid();
        bid.setId(1L);
        bid.setListing(listing);
        bid.setBuyer(buyer);
        bid.setQuantityKg(BigDecimal.valueOf(50));
        bid.setBidPricePerKg(BigDecimal.valueOf(22));
        bid.setBidStatus(Bid.BidStatus.PENDING);

        com.agriconnect.model.FarmerProfile farmer = new com.agriconnect.model.FarmerProfile();
        farmer.setId(2L);
        User farmerUser = new User();
        farmerUser.setId(20L);
        farmer.setUser(farmerUser);
        listing.setFarmerProfile(farmer);
        listing.setStatus(ProduceListing.Status.ACTIVE);
        listing.setQuantityKg(BigDecimal.valueOf(50));

        User buyerUser = new User();
        buyerUser.setId(10L);
        buyer.setUser(buyerUser);

        when(bidDao.findById(1L)).thenReturn(Optional.of(bid));
        when(farmerProfileDao.findById(2L)).thenReturn(Optional.of(farmer));

        Order order = bidService.acceptBid(1L, 2L);

        assertThat(order).isNotNull();
        assertThat(order.getOrderStatus()).isEqualTo(Order.OrderStatus.CONFIRMED);
        assertThat(order.getPaymentStatus()).isEqualTo(Order.PaymentStatus.PAID);
        assertThat(listing.getStatus()).isEqualTo(ProduceListing.Status.SOLD);
        verify(orderDao, times(1)).save(any(Order.class));
        verify(bidDao, times(1)).update(bid);
        verify(bidDao, times(1)).rejectPendingBidsForListingExcept(1L, 1L);
        verify(walletTransactionDao, times(1)).save(any());
        verify(priceHistoryDao, times(1)).save(any());
        verify(notificationDao, times(2)).save(any());
    }
}
