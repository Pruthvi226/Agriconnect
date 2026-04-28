package com.agriconnect.dao;

import com.agriconnect.model.User;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public class UserDao extends BaseDaoImpl<User, Long> {

    public UserDao() {
        super(User.class);
    }

    public Optional<User> findByEmail(String email) {
        String hql = "SELECT u FROM User u WHERE u.email = :email";
        return sessionFactory.getCurrentSession().createQuery(hql, User.class)
                .setParameter("email", email)
                .uniqueResultOptional();
    }
}
