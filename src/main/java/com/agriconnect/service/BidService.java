package com.agriconnect.service;

import com.agriconnect.dao.BidDao;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dao.BaseDao;
import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.exception.ResourceNotFoundException;
import com.agriconnect.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
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
    private BaseDao<Notification, Long> notificationDao;

    @Autowired
    private AuditService auditService;

    @org.springframework.security.access.prepost.PreAuthorize("hasRole('BUYER') and #buyerId == authentication.principal.id")
    public Bid placeBid(BidRequestDto dto, Long buyerId) {
        ProduceListing listing = listingDao.findById(dto.getListingId())
                .orElseThrow(() -> new ResourceNotFoundException("Listing not found"));

        if (listing.getStatus() != ProduceListing.Status.ACTIVE && listing.getStatus() != ProduceListing.Status.BIDDING) {
            throw new BusinessValidationException("Listing is not available for bidding");
        }

        BuyerProfile buyer = buyerDao.findById(buyerId)
                .orElseThrow(() -> new ResourceNotFoundException("Buyer not found"));

        // Buyer cannot bid on their own listing (if they somehow have one) - not really possible with roles but good check
        // Check duplicate active bid
        List<Bid> existingBids = bidDao.findActiveBidsByBuyer(buyerId);
        boolean hasActiveBidForListing = existingBids.stream()
                .anyMatch(b -> b.getListing().getId().equals(dto.getListingId()));
        if (hasActiveBidForListing) {
            throw new BusinessValidationException("You already have an active bid for this listing");
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

        // Notify farmer
        Notification notification = new Notification();
        notification.setUser(listing.getFarmerProfile().getUser());
        notification.setTitle("New Bid Placed");
        notification.setBody("Buyer " + buyer.getCompanyName() + " placed a bid of ₹" + bid.getBidPricePerKg() + "/kg.");
        notification.setType("BID_UPDATE");
        notificationDao.save(notification);

        auditService.log(buyerId, "CREATE", "Bid", bid.getId(), "{}", "{\"bidPrice\":" + dto.getBidPricePerKg() + "}", "127.0.0.1");

        return bid;
    }

    @org.springframework.security.access.prepost.PreAuthorize("hasRole('FARMER') and #farmerId == authentication.principal.id")
    public Order acceptBid(Long bidId, Long farmerId) {
        Bid bid = bidDao.findById(bidId)
                .orElseThrow(() -> new ResourceNotFoundException("Bid not found"));

        if (!bid.getListing().getFarmerProfile().getId().equals(farmerId)) {
            throw new BusinessValidationException("You do not own this listing");
        }
        
        if (bid.getBidStatus() != Bid.BidStatus.PENDING) {
            throw new BusinessValidationException("Only PENDING bids can be accepted");
        }

        bid.setBidStatus(Bid.BidStatus.ACCEPTED);
        bidDao.update(bid);

        ProduceListing listing = bid.getListing();
        listing.setStatus(ProduceListing.Status.SOLD);
        listingDao.update(listing);

        // Reject other bids
        List<Bid> otherBids = bidDao.findByListing(listing.getId());
        for (Bid other : otherBids) {
            if (!other.getId().equals(bidId) && other.getBidStatus() == Bid.BidStatus.PENDING) {
                other.setBidStatus(Bid.BidStatus.REJECTED);
                bidDao.update(other);
            }
        }

        // Create Order
        Order order = new Order();
        order.setBid(bid);
        order.setFarmer(listing.getFarmerProfile());
        order.setBuyer(bid.getBuyer());
        order.setFinalPricePerKg(bid.getBidPricePerKg());
        order.setQuantityKg(bid.getQuantityKg());
        order.setTotalAmount(bid.getBidPricePerKg().multiply(bid.getQuantityKg()));
        
        orderDao.save(order);

        // Notify buyer
        Notification notification = new Notification();
        notification.setUser(bid.getBuyer().getUser());
        notification.setTitle("Bid Accepted!");
        notification.setBody("Your bid for " + listing.getCropName() + " has been accepted.");
        notification.setType("ORDER_CREATED");
        notificationDao.save(notification);

        auditService.log(farmerId, "ACCEPT_BID", "Bid", bidId, "{\"status\":\"PENDING\"}", "{\"status\":\"ACCEPTED\"}", "127.0.0.1");

        return order;
    }

    public com.agriconnect.dto.BidRankDto getAnonymisedBidRankingFull(Long listingId, Long buyerId) {
        List<Bid> allBids = bidDao.findByListing(listingId);
        if (allBids.isEmpty()) throw new ResourceNotFoundException("No bids on this listing");

        Bid myBid = allBids.stream()
                .filter(b -> b.getBuyer().getId().equals(buyerId) && (b.getBidStatus() == Bid.BidStatus.PENDING || b.getBidStatus() == Bid.BidStatus.ACCEPTED))
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
}
