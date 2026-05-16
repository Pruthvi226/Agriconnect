package com.agriconnect.dao;

import com.agriconnect.model.User;
import java.time.LocalDate;
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
    Optional<User> findVerifiedExpertById(Long userId);
    List<User> findVerifiedExpertsWithOpenSlots(String crop, String district, LocalDate slotDate);
    List<User> findAll();
}
