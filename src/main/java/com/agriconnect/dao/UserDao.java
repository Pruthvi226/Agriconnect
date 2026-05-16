package com.agriconnect.dao;

import com.agriconnect.model.User;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public class UserDao extends BaseDaoImpl<User, Long> {

    public UserDao() {
        super(User.class);
    }

    public Optional<User> findByEmail(String email) {
        String hql = "SELECT u FROM User u WHERE u.email = :email";
        List<User> users = sessionFactory.getCurrentSession().createQuery(hql, User.class)
                .setParameter("email", email)
                .setMaxResults(2)
                .getResultList();
        return users.size() == 1 ? Optional.of(users.get(0)) : Optional.empty();
    }

    public Optional<User> findByEmailAndRole(String email, User.Role role) {
        String hql = "SELECT u FROM User u WHERE u.email = :email AND u.role = :role";
        return sessionFactory.getCurrentSession().createQuery(hql, User.class)
                .setParameter("email", email)
                .setParameter("role", role)
                .uniqueResultOptional();
    }

    public boolean existsByEmailAndRole(String email, User.Role role) {
        String hql = "SELECT COUNT(u.id) FROM User u WHERE u.email = :email AND u.role = :role";
        Long count = sessionFactory.getCurrentSession().createQuery(hql, Long.class)
                .setParameter("email", email)
                .setParameter("role", role)
                .uniqueResult();
        return count != null && count > 0;
    }

    public Optional<User> findVerifiedExpertById(Long userId) {
        String hql = "SELECT u FROM User u WHERE u.id = :userId AND u.role = :role AND u.verificationStatus = :status";
        return sessionFactory.getCurrentSession().createQuery(hql, User.class)
                .setParameter("userId", userId)
                .setParameter("role", User.Role.AGRI_EXPERT)
                .setParameter("status", User.VerificationStatus.VERIFIED)
                .uniqueResultOptional();
    }

    public List<User> findVerifiedExpertsWithOpenSlots(String crop, String district, LocalDate slotDate) {
        StringBuilder hql = new StringBuilder("SELECT DISTINCT u FROM User u JOIN BookingSlot s ON s.provider.id = u.id " +
                "WHERE u.role = :role AND u.verificationStatus = :status AND s.slotStatus = :slotStatus AND s.slotDate = :slotDate ");
        if (crop != null && !crop.isBlank()) {
            hql.append("AND (LOWER(u.specialisation) LIKE :cropLike OR LOWER(s.cropFocus) = :cropExact) ");
        }
        if (district != null && !district.isBlank()) {
            hql.append("AND LOWER(s.district) = :district ");
        }
        hql.append("ORDER BY u.avgRating DESC, u.totalSessions DESC, u.name ASC");

        var query = sessionFactory.getCurrentSession().createQuery(hql.toString(), User.class)
                .setParameter("role", User.Role.AGRI_EXPERT)
                .setParameter("status", User.VerificationStatus.VERIFIED)
                .setParameter("slotStatus", com.agriconnect.model.BookingSlot.SlotStatus.OPEN)
                .setParameter("slotDate", slotDate);

        if (crop != null && !crop.isBlank()) {
            query.setParameter("cropLike", "%" + crop.toLowerCase() + "%");
            query.setParameter("cropExact", crop.toLowerCase());
        }
        if (district != null && !district.isBlank()) {
            query.setParameter("district", district.toLowerCase());
        }
        return query.getResultList();
    }
}
