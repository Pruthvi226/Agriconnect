package com.agriconnect.dao;

import com.agriconnect.model.User;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

@Repository
@Transactional
public class UserDaoImpl implements UserDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(User user) {
        sessionFactory.getCurrentSession().persist(user);
    }

    @Override
    public void update(User user) {
        sessionFactory.getCurrentSession().merge(user);
    }

    @Override
    public void delete(User user) {
        sessionFactory.getCurrentSession().remove(user);
    }

    @Override
    public Optional<User> findById(Long id) {
        return Optional.ofNullable(sessionFactory.getCurrentSession().get(User.class, id));
    }

    @Override
    public Optional<User> findByEmail(String email) {
        String hql = "FROM User u WHERE u.email = :email";
        return sessionFactory.getCurrentSession().createQuery(hql, User.class)
                .setParameter("email", email)
                .setMaxResults(1)
                .uniqueResultOptional();
    }

    @Override
    public Optional<User> findByEmailAndRole(String email, User.Role role) {
        String hql = "FROM User u WHERE u.email = :email AND u.role = :role";
        return sessionFactory.getCurrentSession().createQuery(hql, User.class)
                .setParameter("email", email)
                .setParameter("role", role)
                .uniqueResultOptional();
    }

    @Override
    public boolean existsByEmailAndRole(String email, User.Role role) {
        String hql = "SELECT COUNT(u.id) FROM User u WHERE u.email = :email AND u.role = :role";
        Long count = sessionFactory.getCurrentSession().createQuery(hql, Long.class)
                .setParameter("email", email)
                .setParameter("role", role)
                .uniqueResult();
        return count != null && count > 0;
    }

    @Override
    public List<User> findAll() {
        return sessionFactory.getCurrentSession().createQuery("FROM User", User.class).getResultList();
    }
}
