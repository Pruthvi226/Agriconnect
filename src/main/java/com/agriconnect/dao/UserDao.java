package com.agriconnect.dao;

import com.agriconnect.model.User;
import org.springframework.stereotype.Repository;

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
}
