package com.agriconnect.service;

import com.agriconnect.dao.UserDao;
import com.agriconnect.dto.UserRegistrationDto;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserDao userDao;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User register(UserRegistrationDto dto) {
        String email = dto.getEmail().trim().toLowerCase();
        if (userDao.findByEmail(email).isPresent()) {
            throw new BusinessValidationException("An account already exists for this email");
        }

        User user = new User();
        user.setName(dto.getName().trim());
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(dto.getPassword()));
        user.setPhone(dto.getPhone().trim());
        user.setRole(User.Role.valueOf(dto.getRole()));
        user.setVerificationStatus(User.VerificationStatus.PENDING);
        userDao.save(user);
        return user;
    }
}
