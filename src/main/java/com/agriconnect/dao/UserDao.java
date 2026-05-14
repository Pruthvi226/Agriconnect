package com.agriconnect.dao;

import com.agriconnect.model.User;
import java.util.Optional;
import java.util.List;

public interface UserDao {
    void save(User user);
    void update(User user);
    void delete(User user);
    Optional<User> findById(Long id);
    Optional<User> findByEmail(String email);
    Optional<User> findByEmailAndRole(String email, User.Role role);
    boolean existsByEmailAndRole(String email, User.Role role);
    List<User> findAll();
}
