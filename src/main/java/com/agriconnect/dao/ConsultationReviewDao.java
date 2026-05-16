package com.agriconnect.dao;

import com.agriconnect.model.ConsultationReview;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.Optional;

@Repository
public class ConsultationReviewDao extends BaseDaoImpl<ConsultationReview, Long> {

    public ConsultationReviewDao() {
        super(ConsultationReview.class);
    }

    public Optional<ConsultationReview> findByConsultationId(Long consultationId) {
        String hql = "SELECT r FROM ConsultationReview r JOIN FETCH r.consultation c WHERE c.id = :consultationId";
        return sessionFactory.getCurrentSession().createQuery(hql, ConsultationReview.class)
                .setParameter("consultationId", consultationId)
                .uniqueResultOptional();
    }

    public BigDecimal getAverageRatingForExpert(Long expertId) {
        String hql = "SELECT AVG(r.rating) FROM ConsultationReview r WHERE r.consultation.expert.id = :expertId";
        Double average = sessionFactory.getCurrentSession().createQuery(hql, Double.class)
                .setParameter("expertId", expertId)
                .uniqueResult();
        return average == null ? BigDecimal.ZERO : BigDecimal.valueOf(average);
    }
}
