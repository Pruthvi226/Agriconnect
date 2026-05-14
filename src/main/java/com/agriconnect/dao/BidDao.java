package com.agriconnect.dao;

import com.agriconnect.model.Bid;
import java.util.Optional;
import java.util.List;

public interface BidDao {
    void save(Bid bid);
    void update(Bid bid);
    Optional<Bid> findById(Long id);
    List<Bid> findByListingId(Long listingId);
    List<Bid> findByBuyerId(Long buyerId);
    List<Bid> findByListing(Long listingId);
    List<Bid> findActiveBidsByBuyer(Long buyerId);
    List<Bid> findPendingByFarmer(Long farmerId);
    void rejectPendingBidsForListingExcept(Long listingId, Long acceptedBidId);
}
