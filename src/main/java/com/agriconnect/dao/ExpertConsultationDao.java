package com.agriconnect.dao;

import com.agriconnect.model.ExpertConsultation;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class ExpertConsultationDao extends BaseDaoImpl<ExpertConsultation, Long> {

    public ExpertConsultationDao() {
        super(ExpertConsultation.class);
    }

    public List<ExpertConsultation> findByExpert(Long expertId) {
        String hql = "SELECT c FROM ExpertConsultation c " +
                "JOIN FETCH c.expert e " +
                "JOIN FETCH c.farmer f " +
                "JOIN FETCH f.user fu " +
                "JOIN FETCH c.slot s " +
                "WHERE e.id = :expertId ORDER BY s.slotDate ASC, s.startTime ASC";
        return sessionFactory.getCurrentSession().createQuery(hql, ExpertConsultation.class)
                .setParameter("expertId", expertId)
                .getResultList();
    }

    public List<ExpertConsultation> findByFarmerUser(Long userId) {
        String hql = "SELECT c FROM ExpertConsultation c " +
                "JOIN FETCH c.expert e " +
                "JOIN FETCH c.farmer f " +
                "JOIN FETCH c.slot s " +
                "WHERE f.user.id = :userId ORDER BY s.slotDate ASC, s.startTime ASC";
        return sessionFactory.getCurrentSession().createQuery(hql, ExpertConsultation.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    public Optional<ExpertConsultation> findDetailedById(Long consultationId) {
        String hql = "SELECT c FROM ExpertConsultation c " +
                "JOIN FETCH c.expert e " +
                "JOIN FETCH c.farmer f " +
                "JOIN FETCH f.user fu " +
                "JOIN FETCH c.slot s " +
                "WHERE c.id = :consultationId";
        return sessionFactory.getCurrentSession().createQuery(hql, ExpertConsultation.class)
                .setParameter("consultationId", consultationId)
                .uniqueResultOptional();
    }

    public List<ExpertConsultation> findPendingReminders(LocalDateTime from, LocalDateTime to) {
        String hql = "SELECT c FROM ExpertConsultation c " +
                "JOIN FETCH c.expert e " +
                "JOIN FETCH c.farmer f " +
                "JOIN FETCH f.user fu " +
                "JOIN FETCH c.slot s " +
                "WHERE c.consultationStatus = :status AND c.reminderSent = false " +
                "AND function('TIMESTAMP', s.slotDate, s.startTime) BETWEEN :fromTime AND :toTime";
        return sessionFactory.getCurrentSession().createQuery(hql, ExpertConsultation.class)
                .setParameter("status", ExpertConsultation.ConsultationStatus.BOOKED)
                .setParameter("fromTime", from)
                .setParameter("toTime", to)
                .getResultList();
    }
}
