package com.agriconnect.dao;

import com.agriconnect.model.BookingSlot;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class BookingSlotDao extends BaseDaoImpl<BookingSlot, Long> {

    public BookingSlotDao() {
        super(BookingSlot.class);
    }

    public List<BookingSlot> findAvailableSlots(String crop, String district, LocalDate slotDate) {
        StringBuilder hql = new StringBuilder("SELECT s FROM BookingSlot s JOIN FETCH s.provider p " +
                "WHERE s.slotStatus = :slotStatus AND s.slotDate = :slotDate " +
                "AND p.role = :role AND p.verificationStatus = :verificationStatus ");
        if (crop != null && !crop.isBlank()) {
            hql.append("AND (LOWER(s.cropFocus) = :crop OR LOWER(p.specialisation) LIKE :cropLike) ");
        }
        if (district != null && !district.isBlank()) {
            hql.append("AND LOWER(s.district) = :district ");
        }
        hql.append("ORDER BY p.avgRating DESC, s.startTime ASC");

        var query = sessionFactory.getCurrentSession().createQuery(hql.toString(), BookingSlot.class)
                .setParameter("slotStatus", BookingSlot.SlotStatus.OPEN)
                .setParameter("slotDate", slotDate)
                .setParameter("role", com.agriconnect.model.User.Role.AGRI_EXPERT)
                .setParameter("verificationStatus", com.agriconnect.model.User.VerificationStatus.VERIFIED);
        if (crop != null && !crop.isBlank()) {
            query.setParameter("crop", crop.toLowerCase());
            query.setParameter("cropLike", "%" + crop.toLowerCase() + "%");
        }
        if (district != null && !district.isBlank()) {
            query.setParameter("district", district.toLowerCase());
        }
        return query.getResultList();
    }

    public List<BookingSlot> findByProvider(Long providerId) {
        String hql = "SELECT s FROM BookingSlot s WHERE s.provider.id = :providerId ORDER BY s.slotDate ASC, s.startTime ASC";
        return sessionFactory.getCurrentSession().createQuery(hql, BookingSlot.class)
                .setParameter("providerId", providerId)
                .getResultList();
    }

    public Optional<BookingSlot> findOpenSlotById(Long slotId) {
        String hql = "SELECT s FROM BookingSlot s JOIN FETCH s.provider WHERE s.id = :slotId";
        return sessionFactory.getCurrentSession().createQuery(hql, BookingSlot.class)
                .setParameter("slotId", slotId)
                .uniqueResultOptional();
    }

    public List<BookingSlot> findSlotsForReminderWindow(LocalDateTime from, LocalDateTime to) {
        String hql = "SELECT s FROM BookingSlot s JOIN FETCH s.provider p JOIN ExpertConsultation c ON c.slot.id = s.id " +
                "WHERE c.reminderSent = false AND c.consultationStatus = :status " +
                "AND function('TIMESTAMP', s.slotDate, s.startTime) BETWEEN :fromTime AND :toTime";
        return sessionFactory.getCurrentSession().createQuery(hql, BookingSlot.class)
                .setParameter("status", com.agriconnect.model.ExpertConsultation.ConsultationStatus.BOOKED)
                .setParameter("fromTime", from)
                .setParameter("toTime", to)
                .getResultList();
    }
}
