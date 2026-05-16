package com.agriconnect.dao;

import com.agriconnect.model.ProduceListing;
import org.hibernate.SessionFactory;
import org.hibernate.query.NativeQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class ProduceListingDaoImpl implements ProduceListingDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(ProduceListing listing) {
        sessionFactory.getCurrentSession().persist(listing);
    }

    @Override
    public void update(ProduceListing listing) {
        sessionFactory.getCurrentSession().merge(listing);
    }

    @Override
    public void delete(ProduceListing listing) {
        sessionFactory.getCurrentSession().remove(listing);
    }

    @Override
    public Optional<ProduceListing> findById(Long id) {
        return Optional.ofNullable(sessionFactory.getCurrentSession().get(ProduceListing.class, id));
    }

    @Override
    public List<ProduceListing> findAll() {
        return sessionFactory.getCurrentSession().createQuery("FROM ProduceListing", ProduceListing.class).getResultList();
    }

    @Override
    public List<ProduceListing> findByFarmerId(Long farmerId) {
        String hql = "FROM ProduceListing pl WHERE pl.farmerProfile.id = :farmerId";
        return sessionFactory.getCurrentSession().createQuery(hql, ProduceListing.class)
                .setParameter("farmerId", farmerId)
                .getResultList();
    }

    @Override
    public List<ProduceListing> findByFarmer(Long farmerId, ProduceListing.Status status) {
        StringBuilder hql = new StringBuilder("FROM ProduceListing pl WHERE pl.farmerProfile.id = :farmerId");
        if (status != null) {
            hql.append(" AND pl.status = :status");
        }
        hql.append(" ORDER BY pl.createdAt DESC");
        var query = sessionFactory.getCurrentSession().createQuery(hql.toString(), ProduceListing.class)
                .setParameter("farmerId", farmerId);
        if (status != null) {
            query.setParameter("status", status);
        }
        return query.getResultList();
    }

    @Override
    public List<ProduceListing> search(String crop, String district) {
        StringBuilder hql = new StringBuilder("FROM ProduceListing pl WHERE 1=1");
        if (crop != null && !crop.isEmpty()) hql.append(" AND pl.cropName LIKE :crop");
        if (district != null && !district.isEmpty()) hql.append(" AND pl.district = :district");
        
        var query = sessionFactory.getCurrentSession().createQuery(hql.toString(), ProduceListing.class);
        if (crop != null && !crop.isEmpty()) query.setParameter("crop", "%" + crop + "%");
        if (district != null && !district.isEmpty()) query.setParameter("district", district);
        
        return query.getResultList();
    }

    @Override
    public List<ProduceListing> searchByFilters(String crop, String district, BigDecimal minPrice, BigDecimal maxPrice, String qualityGrade) {
        StringBuilder hql = new StringBuilder("FROM ProduceListing pl WHERE pl.status IN (:statuses)");
        if (crop != null && !crop.isBlank()) {
            hql.append(" AND LOWER(pl.cropName) LIKE :crop");
        }
        if (district != null && !district.isBlank()) {
            hql.append(" AND LOWER(pl.district) = :district");
        }
        if (minPrice != null) {
            hql.append(" AND pl.askingPricePerKg >= :minPrice");
        }
        if (maxPrice != null) {
            hql.append(" AND pl.askingPricePerKg <= :maxPrice");
        }
        if (qualityGrade != null && !qualityGrade.isBlank()) {
            hql.append(" AND pl.qualityGrade = :qualityGrade");
        }
        hql.append(" ORDER BY pl.createdAt DESC");

        var query = sessionFactory.getCurrentSession().createQuery(hql.toString(), ProduceListing.class)
                .setParameterList("statuses", List.of(ProduceListing.Status.ACTIVE, ProduceListing.Status.BIDDING));
        if (crop != null && !crop.isBlank()) {
            query.setParameter("crop", "%" + crop.toLowerCase() + "%");
        }
        if (district != null && !district.isBlank()) {
            query.setParameter("district", district.toLowerCase());
        }
        if (minPrice != null) {
            query.setParameter("minPrice", minPrice);
        }
        if (maxPrice != null) {
            query.setParameter("maxPrice", maxPrice);
        }
        if (qualityGrade != null && !qualityGrade.isBlank()) {
            query.setParameter("qualityGrade", ProduceListing.QualityGrade.valueOf(qualityGrade.toUpperCase()));
        }
        return query.getResultList();
    }

    @Override
    public List<ProduceListing> fullTextSearch(String term) {
        // MySQL Full-Text search
        String sql = "SELECT * FROM produce_listings WHERE MATCH(crop_name, description) AGAINST(:term IN BOOLEAN MODE)";
        return sessionFactory.getCurrentSession().createNativeQuery(sql, ProduceListing.class)
                .setParameter("term", term)
                .getResultList();
    }

    @Override
    public List<ProduceListing> findNearby(BigDecimal lat, BigDecimal lng, Double radiusKm) {
        // Using stored procedure sp_get_nearby_listings
        NativeQuery<ProduceListing> query = sessionFactory.getCurrentSession().createNativeQuery(
                "CALL sp_get_nearby_listings(:lat, :lng, :radius)", ProduceListing.class);
        query.setParameter("lat", lat);
        query.setParameter("lng", lng);
        query.setParameter("radius", radiusKm);
        return query.getResultList();
    }

    @Override
    public List<ProduceListing> findByField(String fieldName, Object value) {
        String hql = "FROM ProduceListing pl WHERE pl." + fieldName + " = :value";
        return sessionFactory.getCurrentSession().createQuery(hql, ProduceListing.class)
                .setParameter("value", value)
                .getResultList();
    }

    @Override
    public List<ProduceListing> findActiveListingsByFarmersAndCrop(List<Long> farmerIds, String cropName) {
        if (farmerIds == null || farmerIds.isEmpty()) {
            return List.of();
        }
        String hql = """
                FROM ProduceListing pl
                WHERE pl.farmerProfile.id IN (:farmerIds)
                  AND pl.status = :status
                  AND LOWER(pl.cropName) = :cropName
                ORDER BY pl.askingPricePerKg ASC
                """;
        return sessionFactory.getCurrentSession().createQuery(hql, ProduceListing.class)
                .setParameterList("farmerIds", farmerIds)
                .setParameter("status", ProduceListing.Status.ACTIVE)
                .setParameter("cropName", cropName == null ? "" : cropName.toLowerCase())
                .getResultList();
    }
}
