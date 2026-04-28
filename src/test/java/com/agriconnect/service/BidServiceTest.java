package com.agriconnect.service;

import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.BidDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.model.Bid;
import com.agriconnect.model.BuyerProfile;
import com.agriconnect.model.Order;
import com.agriconnect.model.ProduceListing;
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
    private OrderDao orderDao;
    @Mock
    private BaseDao<com.agriconnect.model.Notification, Long> notificationDao;
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

        com.agriconnect.model.FarmerProfile farmer = new com.agriconnect.model.FarmerProfile();
        farmer.setId(2L);
        listing.setFarmerProfile(farmer);

        when(bidDao.findById(1L)).thenReturn(Optional.of(bid));
        when(bidDao.findByListing(1L)).thenReturn(Collections.singletonList(bid));

        Order order = bidService.acceptBid(1L, 2L);

        assertThat(order).isNotNull();
        assertThat(order.getOrderStatus()).isEqualTo(Order.OrderStatus.CONFIRMED);
        verify(orderDao, times(1)).save(any(Order.class));
        verify(bidDao, times(1)).update(bid);
    }
}
