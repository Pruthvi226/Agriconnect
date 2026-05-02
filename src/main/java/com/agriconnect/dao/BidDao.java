package com.agriconnect.dao;

import com.agriconnect.model.Bid;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;

@Repository
public class BidDao extends BaseDaoImpl<Bid, Long> {

    public BidDao() {
        super(Bid.class);
    }

    public List<Bid> findByListing(Long listingId) {
        String hql = "SELECT b FROM Bid b JOIN FETCH b.buyer JOIN FETCH b.listing WHERE b.listing.id = :listingId ORDER BY b.bidPricePerKg DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, Bid.class)
                .setParameter("listingId", listingId)
                .getResultList();
    }

    public List<Bid> findPendingByFarmer(Long farmerId) {
        String hql = "SELECT b FROM Bid b " +
                "JOIN FETCH b.buyer buyer " +
                "JOIN FETCH b.listing listing " +
                "WHERE listing.farmerProfile.id = :farmerId AND b.bidStatus = :status " +
                "ORDER BY b.createdAt DESC";
        return sessionFactory.getCurrentSession().createQuery(hql, Bid.class)
                .setParameter("farmerId", farmerId)
                .setParameter("status", Bid.BidStatus.PENDING)
                .getResultList();
    }

    public List<Bid> findActiveBidsByBuyer(Long buyerId) {
        String hql = "SELECT b FROM Bid b JOIN FETCH b.listing WHERE b.buyer.id = :buyerId AND b.bidStatus IN ('PENDING', 'ACCEPTED')";
        return sessionFactory.getCurrentSession().createQuery(hql, Bid.class)
                .setParameter("buyerId", buyerId)
                .getResultList();
    }

    public Integer getAnonymisedRankForBid(Long bidId) {
        String hql = "SELECT b.id FROM Bid b WHERE b.listing.id = (SELECT b2.listing.id FROM Bid b2 WHERE b2.id = :bidId) " +
                     "ORDER BY b.bidPricePerKg DESC, b.createdAt ASC";
        List<Long> rankedBids = sessionFactory.getCurrentSession().createQuery(hql, Long.class)
                .setParameter("bidId", bidId)
                .getResultList();
        
        int rank = rankedBids.indexOf(bidId);
        return rank != -1 ? rank + 1 : null;
    }

    public int rejectPendingBidsForListingExcept(Long listingId, Long acceptedBidId) {
        String hql = "UPDATE Bid b SET b.bidStatus = :rejectedStatus " +
                "WHERE b.listing.id = :listingId AND b.bidStatus = :pendingStatus AND b.id NOT IN (:acceptedIds)";
        return sessionFactory.getCurrentSession().createMutationQuery(hql)
                .setParameter("rejectedStatus", Bid.BidStatus.REJECTED)
                .setParameter("pendingStatus", Bid.BidStatus.PENDING)
                .setParameter("listingId", listingId)
                .setParameter("acceptedIds", Set.of(acceptedBidId))
                .executeUpdate();
    }
}
