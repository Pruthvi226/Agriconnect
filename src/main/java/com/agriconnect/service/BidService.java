package com.agriconnect.service;

import com.agriconnect.dao.BaseDao;
import com.agriconnect.dao.BidDao;
import com.agriconnect.dao.BuyerProfileDao;
import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.NotificationDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.dao.PriceHistoryDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dao.UserDao;
import com.agriconnect.dao.WalletTransactionDao;
import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.exception.ResourceNotFoundException;
import com.agriconnect.model.Bid;
import com.agriconnect.model.BuyerProfile;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.Notification;
import com.agriconnect.model.Order;
import com.agriconnect.model.PriceHistory;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.model.User;
import com.agriconnect.model.WalletTransaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.hibernate.SessionFactory;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.List;

@Service
@Transactional
public class BidService {

    @Autowired
    private BidDao bidDao;

    @Autowired
    private ProduceListingDao listingDao;

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private BaseDao<BuyerProfile, Long> buyerDao;

    @Autowired
    private BuyerProfileDao buyerProfileDao;

    @Autowired
    private FarmerProfileDao farmerProfileDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private NotificationDao notificationDao;

    @Autowired
    private WalletTransactionDao walletTransactionDao;

    @Autowired
    private PriceHistoryDao priceHistoryDao;

    @Autowired
    private AuditService auditService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private SessionFactory sessionFactory;

    @PreAuthorize("hasRole('BUYER')")
    public Bid placeBidForUser(BidRequestDto dto, Long userId) {
        BuyerProfile buyer = buyerProfileDao.findByUserId(userId)
                .orElseGet(() -> createStarterBuyerProfile(userId));
        return placeBidForProfile(dto, buyer);
    }

    @PreAuthorize("hasRole('BUYER') and #buyerId == authentication.principal.id")
    public Bid placeBid(BidRequestDto dto, Long buyerId) {
        BuyerProfile buyer = buyerDao.findById(buyerId)
                .orElseThrow(() -> new ResourceNotFoundException("Buyer not found"));
        return placeBidForProfile(dto, buyer);
    }

    private Bid placeBidForProfile(BidRequestDto dto, BuyerProfile buyer) {
        ProduceListing listing = listingDao.findById(dto.getListingId())
                .orElseThrow(() -> new ResourceNotFoundException("Listing not found"));

        if (listing.getStatus() != ProduceListing.Status.ACTIVE && listing.getStatus() != ProduceListing.Status.BIDDING) {
            throw new BusinessValidationException("Listing is not available for booking");
        }

        if (listing.getQuantityKg() != null && dto.getQuantityKg().compareTo(listing.getQuantityKg()) > 0) {
            throw new BusinessValidationException("Requested quantity is higher than the available listing quantity");
        }

        List<Bid> existingBids = bidDao.findActiveBidsByBuyer(buyer.getId());
        boolean hasActiveBidForListing = existingBids.stream()
                .anyMatch(b -> b.getListing().getId().equals(dto.getListingId()));
        if (hasActiveBidForListing) {
            throw new BusinessValidationException("You already have an active bid / booking request for this listing");
        }

        Bid bid = new Bid();
        bid.setListing(listing);
        bid.setBuyer(buyer);
        bid.setBidPricePerKg(dto.getBidPricePerKg());
        bid.setQuantityKg(dto.getQuantityKg());
        bid.setMessage(dto.getMessage());
        bid.setBidStatus(Bid.BidStatus.PENDING);

        bidDao.save(bid);

        listing.setStatus(ProduceListing.Status.BIDDING);
        listingDao.update(listing);

        Notification notification = new Notification();
        notification.setUser(listing.getFarmerProfile().getUser());
        notification.setTitle("New Booking Request");
        notification.setBody("Buyer " + buyer.getCompanyName() + " requested " + bid.getQuantityKg()
                + " kg at Rs " + bid.getBidPricePerKg() + "/kg.");
        notification.setType("BID_UPDATE");
        notificationDao.save(notification);

        Long actorId = buyer.getUser() != null ? buyer.getUser().getId() : buyer.getId();
        auditService.log(actorId, "CREATE", "Bid", bid.getId(),
                "{}", "{\"bidPrice\":" + dto.getBidPricePerKg() + "}", "127.0.0.1");

        return bid;
    }

    @PreAuthorize("hasRole('FARMER')")
    public Order acceptBidForUser(Long bidId, Long userId) {
        FarmerProfile farmer = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        return acceptBidForProfile(bidId, farmer, userId);
    }

    @PreAuthorize("hasRole('FARMER') and #farmerId == authentication.principal.id")
    public Order acceptBid(Long bidId, Long farmerId) {
        FarmerProfile farmer = farmerProfileDao.findById(farmerId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        Long actorId = farmer.getUser() != null ? farmer.getUser().getId() : farmer.getId();
        return acceptBidForProfile(bidId, farmer, actorId);
    }

    private Order acceptBidForProfile(Long bidId, FarmerProfile farmer, Long actorUserId) {
        Bid bid = bidDao.findById(bidId)
                .orElseThrow(() -> new ResourceNotFoundException("Bid not found"));

        if (!bid.getListing().getFarmerProfile().getId().equals(farmer.getId())) {
            throw new BusinessValidationException("You do not own this listing");
        }

        if (bid.getBidStatus() != Bid.BidStatus.PENDING) {
            throw new BusinessValidationException("Only PENDING booking requests can be accepted");
        }

        ProduceListing listing = bid.getListing();
        if (listing.getStatus() == ProduceListing.Status.SOLD || listing.getStatus() == ProduceListing.Status.EXPIRED) {
            throw new BusinessValidationException("This listing can no longer accept bids");
        }

        if (listing.getQuantityKg() != null && bid.getQuantityKg() != null
                && bid.getQuantityKg().compareTo(listing.getQuantityKg()) > 0) {
            throw new BusinessValidationException("This request is above the remaining available quantity");
        }

        bid.setBidStatus(Bid.BidStatus.ACCEPTED);
        bidDao.update(bid);
        bidDao.rejectPendingBidsForListingExcept(listing.getId(), bidId);

        BigDecimal totalAmount = bid.getBidPricePerKg().multiply(bid.getQuantityKg()).setScale(2, RoundingMode.HALF_UP);
        Order order = new Order();
        order.setBid(bid);
        order.setFarmer(listing.getFarmerProfile());
        order.setBuyer(bid.getBuyer());
        order.setFinalPricePerKg(bid.getBidPricePerKg());
        order.setQuantityKg(bid.getQuantityKg());
        order.setTotalAmount(totalAmount);
        order.setOrderStatus(Order.OrderStatus.CONFIRMED);
        order.setExpectedDelivery(LocalDate.now().plusDays(2));
        order.setPaymentStatus(Order.PaymentStatus.PAID);

        orderDao.save(order);

        listing.setStatus(ProduceListing.Status.SOLD);
        listingDao.update(listing);

        BigDecimal commissionAmount = totalAmount.multiply(new BigDecimal("0.02")).setScale(2, RoundingMode.HALF_UP);
        WalletTransaction walletTransaction = new WalletTransaction();
        walletTransaction.setFarmer(farmer);
        walletTransaction.setOrder(order);
        walletTransaction.setTransactionType(WalletTransaction.TransactionType.CREDIT);
        walletTransaction.setAmount(totalAmount);
        walletTransaction.setCommissionAmount(commissionAmount);
        walletTransaction.setNetAmount(totalAmount.subtract(commissionAmount));
        walletTransaction.setRemarks("Accepted bid settlement for listing #" + listing.getId());
        walletTransactionDao.save(walletTransaction);

        PriceHistory priceHistory = new PriceHistory();
        priceHistory.setCropName(listing.getCropName());
        priceHistory.setDistrict(listing.getDistrict());
        priceHistory.setAcceptedPrice(bid.getBidPricePerKg());
        priceHistory.setPriceDate(LocalDate.now());
        priceHistory.setSource(PriceHistory.Source.ACCEPTED_BID);
        priceHistoryDao.save(priceHistory);

        Notification buyerNotification = new Notification();
        buyerNotification.setUser(bid.getBuyer().getUser());
        buyerNotification.setTitle("Bid Accepted");
        buyerNotification.setBody("Your bid was accepted. Pickup confirmed.");
        buyerNotification.setType("ORDER_CREATED");
        buyerNotification.setReferenceId(order.getId());
        notificationDao.save(buyerNotification);

        Notification farmerNotification = new Notification();
        farmerNotification.setUser(listing.getFarmerProfile().getUser());
        farmerNotification.setTitle("Bid Accepted Successfully");
        farmerNotification.setBody("You accepted a bid. Your earnings have been credited.");
        farmerNotification.setType("WALLET_CREDIT");
        farmerNotification.setReferenceId(order.getId());
        notificationDao.save(farmerNotification);

        auditService.log(actorUserId, "ACCEPT_BID", "Bid", bidId,
                "{\"status\":\"PENDING\"}",
                "{\"status\":\"ACCEPTED\",\"orderId\":" + order.getId() + "}", "127.0.0.1");

        return order;
    }

    @PreAuthorize("hasRole('FARMER')")
    public Bid counterBid(Long bidId, BigDecimal counterPrice, String counterMessage, Long userId) {
        FarmerProfile farmer = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        Bid bid = bidDao.findById(bidId)
                .orElseThrow(() -> new ResourceNotFoundException("Bid not found"));

        if (!bid.getListing().getFarmerProfile().getId().equals(farmer.getId())) {
            throw new BusinessValidationException("You do not own this listing");
        }

        if (bid.getBidStatus() != Bid.BidStatus.PENDING) {
            throw new BusinessValidationException("Only PENDING booking requests can be countered");
        }

        bid.setBidStatus(Bid.BidStatus.COUNTERED);
        bid.setCounterPricePerKg(counterPrice);
        bid.setCounterMessage(counterMessage);
        bidDao.update(bid);

        Notification notification = new Notification();
        notification.setUser(bid.getBuyer().getUser());
        notification.setTitle("New Counter Offer Received");
        notification.setBody("Farmer offered ₹" + counterPrice + "/kg for " + bid.getListing().getCropName() + ". Check your dashboard.");
        notification.setType("BID_UPDATE");
        notification.setReferenceId(bid.getId());
        notificationDao.save(notification);

        auditService.log(userId, "COUNTER_BID", "Bid", bidId,
                "{\"price\":" + bid.getBidPricePerKg() + "}",
                "{\"counterPrice\":" + counterPrice + "}", "127.0.0.1");

        return bid;
    }

    @PreAuthorize("hasRole('BUYER')")
    public Order acceptCounterOfferForUser(Long bidId, Long userId) {
        BuyerProfile buyer = buyerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Buyer profile not found"));
        Bid bid = bidDao.findById(bidId)
                .orElseThrow(() -> new ResourceNotFoundException("Bid not found"));

        if (!bid.getBuyer().getId().equals(buyer.getId())) {
            throw new BusinessValidationException("You do not own this bid");
        }

        if (bid.getBidStatus() != Bid.BidStatus.COUNTERED) {
            throw new BusinessValidationException("Only COUNTERED booking requests can be accepted by buyer");
        }

        // Update bid price to counter price
        bid.setBidPricePerKg(bid.getCounterPricePerKg());
        bid.setBidStatus(Bid.BidStatus.PENDING); // Temporarily set to PENDING so acceptBidForProfile works

        // Use the existing accept logic
        return acceptBidForProfile(bidId, bid.getListing().getFarmerProfile(), userId);
    }

    @PreAuthorize("hasRole('FARMER')")
    public Bid rejectBidForUser(Long bidId, Long userId) {
        FarmerProfile farmer = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        Bid bid = bidDao.findById(bidId)
                .orElseThrow(() -> new ResourceNotFoundException("Bid not found"));

        if (!bid.getListing().getFarmerProfile().getId().equals(farmer.getId())) {
            throw new BusinessValidationException("You do not own this listing");
        }

        if (bid.getBidStatus() != Bid.BidStatus.PENDING) {
            throw new BusinessValidationException("Only PENDING booking requests can be rejected");
        }

        bid.setBidStatus(Bid.BidStatus.REJECTED);
        bidDao.update(bid);

        Notification notification = new Notification();
        notification.setUser(bid.getBuyer().getUser());
        notification.setTitle("Booking Request Declined");
        notification.setBody("Your request for " + bid.getListing().getCropName()
                + " was declined. Try a different quantity or price.");
        notification.setType("BID_UPDATE");
        notificationDao.save(notification);

        auditService.log(userId, "REJECT_BID", "Bid", bidId,
                "{\"status\":\"PENDING\"}", "{\"status\":\"REJECTED\"}", "127.0.0.1");

        return bid;
    }

    @PreAuthorize("hasRole('FARMER') and #userId == authentication.principal.id")
    public Order updateOrderDeliveryStatus(Long orderId, String action, Long userId) {
        Order order = orderService.updateDeliveryStatus(orderId, action, userId);
        if (order.getOrderStatus() == Order.OrderStatus.DELIVERED) {
            recomputeFarmerScoreQuietly(order.getFarmer().getId());
        }
        return order;
    }

    @PreAuthorize("hasRole('BUYER')")
    public Order confirmDeliveryForBuyerUser(Long orderId, Long userId) {
        BuyerProfile buyer = buyerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Buyer profile not found"));
        Order order = orderDao.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found"));

        if (!order.getBuyer().getId().equals(buyer.getId())) {
            throw new BusinessValidationException("You do not own this order");
        }
        if (order.getOrderStatus() == Order.OrderStatus.CANCELLED || order.getOrderStatus() == Order.OrderStatus.DISPUTED) {
            throw new BusinessValidationException("This order cannot be confirmed as delivered");
        }

        Order.OrderStatus oldStatus = order.getOrderStatus();
        order.setOrderStatus(Order.OrderStatus.DELIVERED);
        order.setActualDelivery(LocalDate.now());
        order.setPaymentStatus(Order.PaymentStatus.PAID);
        orderDao.update(order);
        recomputeFarmerScoreQuietly(order.getFarmer().getId());

        Notification notification = new Notification();
        notification.setUser(order.getFarmer().getUser());
        notification.setTitle("Buyer Confirmed Delivery");
        notification.setBody("Delivery was confirmed for " + order.getBid().getListing().getCropName()
                + ". The order is now marked delivered.");
        notification.setType("ORDER_UPDATE");
        notification.setReferenceId(order.getId());
        notificationDao.save(notification);

        auditService.log(userId, "CONFIRM_DELIVERY", "Order", orderId,
                "{\"status\":\"" + oldStatus + "\"}",
                "{\"status\":\"DELIVERED\"}", "127.0.0.1");

        return order;
    }

    public List<Bid> getPendingBookingsForFarmerUser(Long userId) {
        return farmerProfileDao.findByUserId(userId)
                .map(farmer -> bidDao.findPendingByFarmer(farmer.getId()))
                .orElseGet(java.util.Collections::emptyList);
    }

    public List<Order> getOrdersForFarmerUser(Long userId) {
        return farmerProfileDao.findByUserId(userId)
                .map(farmer -> orderDao.findByFarmer(farmer.getId(), null))
                .orElseGet(java.util.Collections::emptyList);
    }

    public com.agriconnect.dto.BidRankDto getAnonymisedBidRankingFull(Long listingId, Long buyerId) {
        List<Bid> allBids = bidDao.findByListing(listingId);
        if (allBids.isEmpty()) {
            throw new ResourceNotFoundException("No bids on this listing");
        }

        Bid myBid = allBids.stream()
                .filter(b -> b.getBuyer().getId().equals(buyerId)
                        && (b.getBidStatus() == Bid.BidStatus.PENDING || b.getBidStatus() == Bid.BidStatus.ACCEPTED))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("No active bid found for you"));

        BigDecimal highestBid = allBids.get(0).getBidPricePerKg();
        BigDecimal myBidPrice = myBid.getBidPricePerKg();

        com.agriconnect.dto.BidRankDto dto = new com.agriconnect.dto.BidRankDto();
        dto.setYourBidId(myBid.getId());
        dto.setYourRank(allBids.indexOf(myBid) + 1);
        dto.setTotalBids(allBids.size());

        if (highestBid.compareTo(myBidPrice) == 0) {
            dto.setHighestBidDelta(BigDecimal.ZERO);
        } else {
            BigDecimal delta = highestBid.subtract(myBidPrice);
            dto.setHighestBidDelta(delta.divide(myBidPrice, 4, java.math.RoundingMode.HALF_UP).multiply(new BigDecimal("100")));
        }

        return dto;
    }

    public List<Bid> getBidsForBuyerUser(Long userId) {
        return buyerProfileDao.findByUserId(userId)
                .map(buyer -> bidDao.findActiveBidsByBuyer(buyer.getId()))
                .orElseGet(java.util.Collections::emptyList);
    }

    public com.agriconnect.dto.BidRankDto getBidRankForUser(Long listingId, Long userId) {
        BuyerProfile buyer = buyerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Buyer profile not found"));
        return getAnonymisedBidRankingFull(listingId, buyer.getId());
    }

    public List<Order> getOrdersForBuyerUser(Long userId) {
        return buyerProfileDao.findByUserId(userId)
                .map(buyer -> orderDao.findByBuyer(buyer.getId(), null))
                .orElseGet(java.util.Collections::emptyList);
    }

    public Order getOrderForBuyerUser(Long orderId, Long userId) {
        BuyerProfile buyer = buyerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Buyer profile not found"));
        Order order = orderDao.findById(orderId)
                .orElseThrow(() -> new ResourceNotFoundException("Order not found"));
        if (!order.getBuyer().getId().equals(buyer.getId())) {
            throw new BusinessValidationException("You do not own this order");
        }
        return order;
    }

    private BuyerProfile createStarterBuyerProfile(Long userId) {
        User user = userDao.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        BuyerProfile buyer = new BuyerProfile();
        buyer.setUser(user);
        buyer.setCompanyName(user.getName() != null ? user.getName() : "AgriConnect Buyer");
        buyer.setBusinessType(BuyerProfile.BusinessType.WHOLESALER);
        buyer.setCreditLimit(new BigDecimal("50000.00"));
        buyerDao.save(buyer);
        return buyer;
    }

    private void recomputeFarmerScoreQuietly(Long farmerId) {
        try {
            sessionFactory.getCurrentSession()
                    .createNativeMutationQuery("CALL sp_compute_farmer_score(:farmerId)")
                    .setParameter("farmerId", farmerId)
                    .executeUpdate();
        } catch (RuntimeException ignored) {
            // H2 tests and fresh Docker schemas may not have the stored procedure loaded yet.
        }
    }
}
