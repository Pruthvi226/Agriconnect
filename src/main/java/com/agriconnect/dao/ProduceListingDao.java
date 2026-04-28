package com.agriconnect.dao;

import com.agriconnect.model.ProduceListing;
import org.springframework.stereotype.Repository;
import java.math.BigDecimal;
import java.util.List;

@Repository
public class ProduceListingDao extends BaseDaoImpl<ProduceListing, Long> {

    public ProduceListingDao() {
        super(ProduceListing.class);
    }

    public List<Object[]> findNearbyListings(BigDecimal lat, BigDecimal lng, Integer radiusKm, String crop) {
        String sql = "CALL sp_get_nearby_listings(:lat, :lng, :radius, :crop)";
        return sessionFactory.getCurrentSession().createNativeQuery(sql, Object[].class)
                .setParameter("lat", lat)
                .setParameter("lng", lng)
                .setParameter("radius", radiusKm)
                .setParameter("crop", crop)
                .getResultList();
    }

    public List<ProduceListing> findByFarmer(Long farmerId, ProduceListing.Status status) {
        String hql = "SELECT l FROM ProduceListing l JOIN FETCH l.farmerProfile f WHERE f.id = :farmerId " +
                     (status != null ? "AND l.status = :status" : "");
        var query = sessionFactory.getCurrentSession().createQuery(hql, ProduceListing.class)
                .setParameter("farmerId", farmerId);
        if (status != null) {
            query.setParameter("status", status);
        }
        return query.getResultList();
    }

    public List<ProduceListing> searchByFilters(String crop, String district, BigDecimal minPrice, BigDecimal maxPrice, String grade) {
        StringBuilder hql = new StringBuilder("SELECT l FROM ProduceListing l JOIN FETCH l.farmerProfile f WHERE l.status = 'ACTIVE' ");
        
        if (crop != null) hql.append("AND l.cropName = :crop ");
        if (district != null) hql.append("AND l.district = :district ");
        if (minPrice != null) hql.append("AND l.askingPricePerKg >= :minPrice ");
        if (maxPrice != null) hql.append("AND l.askingPricePerKg <= :maxPrice ");
        if (grade != null) hql.append("AND l.qualityGrade = :grade ");

        var query = sessionFactory.getCurrentSession().createQuery(hql.toString(), ProduceListing.class);
        
        if (crop != null) query.setParameter("crop", crop);
        if (district != null) query.setParameter("district", district);
        if (minPrice != null) query.setParameter("minPrice", minPrice);
        if (maxPrice != null) query.setParameter("maxPrice", maxPrice);
        if (grade != null) query.setParameter("grade", ProduceListing.QualityGrade.valueOf(grade));

        return query.getResultList();
    }
}
