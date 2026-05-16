package com.agriconnect.dao;

import com.agriconnect.model.Bid;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class BidDaoImpl implements BidDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(Bid bid) {
        sessionFactory.getCurrentSession().persist(bid);
    }

    @Override
    public void update(Bid bid) {
        sessionFactory.getCurrentSession().merge(bid);
    }

    @Override
    public Optional<Bid> findById(Long id) {
        return Optional.ofNullable(sessionFactory.getCurrentSession().get(Bid.class, id));
    }

    @Override
    public List<Bid> findByListingId(Long listingId) {
        String hql = "FROM Bid b WHERE b.listing.id = :listingId";
        return sessionFactory.getCurrentSession().createQuery(hql, Bid.class)
                .setParameter("listingId", listingId)
                .getResultList();
    }

    @Override
    public List<Bid> findByBuyerId(Long buyerId) {
        String hql = "FROM Bid b WHERE b.buyer.id = :buyerId";
        return sessionFactory.getCurrentSession().createQuery(hql, Bid.class)
                .setParameter("buyerId", buyerId)
                .getResultList();
    }

    @Override
    public List<Bid> findByListing(Long listingId) {
        String hql = "FROM Bid b WHERE b.listing.id = :listingId ORDER BY b.bidPricePerKg DESC, b.createdAt ASC";
        return sessionFactory.getCurrentSession().createQuery(hql, Bid.class)
                .setParameter("listingId", listingId)
                .getResultList();
    }

    @Override
    public List<Bid> findActiveBidsByBuyer(Long buyerId) {
        String hql = """
                FROM Bid b
                WHERE b.buyer.id = :buyerId
                  AND b.bidStatus IN (:statuses)
                ORDER BY b.createdAt DESC
                """;
        return sessionFactory.getCurrentSession().createQuery(hql, Bid.class)
                .setParameter("buyerId", buyerId)
                .setParameterList("statuses", List.of(Bid.BidStatus.PENDING, Bid.BidStatus.COUNTERED, Bid.BidStatus.ACCEPTED))
                .getResultList();
    }

    @Override
    public List<Bid> findPendingByFarmer(Long farmerId) {
        String hql = """
                FROM Bid b
                WHERE b.listing.farmerProfile.id = :farmerId
                  AND b.bidStatus = :status
                ORDER BY b.createdAt DESC
                """;
        return sessionFactory.getCurrentSession().createQuery(hql, Bid.class)
                .setParameter("farmerId", farmerId)
                .setParameter("status", Bid.BidStatus.PENDING)
                .getResultList();
    }

    @Override
    public void rejectPendingBidsForListingExcept(Long listingId, Long acceptedBidId) {
        String hql = """
                UPDATE Bid b
                SET b.bidStatus = :rejected
                WHERE b.listing.id = :listingId
                  AND b.id <> :acceptedBidId
                  AND b.bidStatus = :pending
                """;
        sessionFactory.getCurrentSession().createMutationQuery(hql)
                .setParameter("rejected", Bid.BidStatus.REJECTED)
                .setParameter("listingId", listingId)
                .setParameter("acceptedBidId", acceptedBidId)
                .setParameter("pending", Bid.BidStatus.PENDING)
                .executeUpdate();
    }
}
