package com.agriconnect;

import com.agriconnect.dao.BuyerProfileDao;
import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.model.Bid;
import com.agriconnect.model.BuyerProfile;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.Order;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.model.User;
import com.agriconnect.service.BidService;
import com.agriconnect.service.UserService;
import com.agriconnect.dto.UserRegistrationDto;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "classpath:test-app-context.xml")
@Transactional
class BidServiceTest {

    @Autowired
    private BidService bidService;

    @Autowired
    private UserService userService;

    @Autowired
    private FarmerProfileDao farmerProfileDao;

    @Autowired
    private BuyerProfileDao buyerProfileDao;

    @Autowired
    private ProduceListingDao listingDao;

    @Autowired
    private OrderDao orderDao;

    @Test
    void placeBidCreatesPendingBid() {
        Fixture fixture = fixture("place");
        Bid bid = bidService.placeBidForUser(bidRequest(fixture.listing.getId()), fixture.buyerUser.getId());

        assertThat(bid.getId()).isNotNull();
        assertThat(bid.getBidStatus()).isEqualTo(Bid.BidStatus.PENDING);
        assertThat(bid.getListing().getStatus()).isEqualTo(ProduceListing.Status.BIDDING);
    }

    @Test
    void acceptBidCreatesOrder() {
        Fixture fixture = fixture("accept");
        Bid bid = bidService.placeBidForUser(bidRequest(fixture.listing.getId()), fixture.buyerUser.getId());

        Order order = bidService.acceptBidForUser(bid.getId(), fixture.farmerUser.getId());

        assertThat(order.getId()).isNotNull();
        assertThat(order.getOrderStatus()).isEqualTo(Order.OrderStatus.CONFIRMED);
        assertThat(orderDao.findById(order.getId())).isPresent();
    }

    @Test
    void cannotAcceptAlreadyAcceptedBid() {
        Fixture fixture = fixture("repeat");
        Bid bid = bidService.placeBidForUser(bidRequest(fixture.listing.getId()), fixture.buyerUser.getId());
        bidService.acceptBidForUser(bid.getId(), fixture.farmerUser.getId());

        assertThatThrownBy(() -> bidService.acceptBidForUser(bid.getId(), fixture.farmerUser.getId()))
                .isInstanceOf(BusinessValidationException.class);
    }

    private Fixture fixture(String suffix) {
        User farmerUser = userService.register(registration("Farmer " + suffix, "farmer." + suffix + "@example.com", "FARMER"));
        User buyerUser = userService.register(registration("Buyer " + suffix, "buyer." + suffix + "@example.com", "BUYER"));
        FarmerProfile farmer = farmerProfileDao.findByUserId(farmerUser.getId()).orElseThrow();
        BuyerProfile buyer = buyerProfileDao.findByUserId(buyerUser.getId()).orElseThrow();

        ProduceListing listing = new ProduceListing();
        listing.setFarmerProfile(farmer);
        listing.setCropName("Wheat");
        listing.setVariety("Sharbati");
        listing.setQuantityKg(new BigDecimal("1000.00"));
        listing.setAskingPricePerKg(new BigDecimal("24.00"));
        listing.setQualityGrade(ProduceListing.QualityGrade.A);
        listing.setAvailableFrom(LocalDate.now());
        listing.setAvailableUntil(LocalDate.now().plusDays(10));
        listing.setDistrict(farmer.getDistrict());
        listing.setStatus(ProduceListing.Status.ACTIVE);
        listingDao.save(listing);
        return new Fixture(farmerUser, buyerUser, buyer, listing);
    }

    private UserRegistrationDto registration(String name, String email, String role) {
        UserRegistrationDto dto = new UserRegistrationDto();
        dto.setName(name);
        dto.setEmail(email);
        dto.setPassword(role.equals("FARMER") ? "Farmer@123" : "Buyer@123");
        dto.setPhone("9876543210");
        dto.setRole(role);
        return dto;
    }

    private BidRequestDto bidRequest(Long listingId) {
        BidRequestDto dto = new BidRequestDto();
        dto.setListingId(listingId);
        dto.setBidPricePerKg(new BigDecimal("25.00"));
        dto.setQuantityKg(new BigDecimal("500.00"));
        dto.setMessage("Ready to pick up");
        return dto;
    }

    private record Fixture(User farmerUser, User buyerUser, BuyerProfile buyer, ProduceListing listing) {
    }
}
