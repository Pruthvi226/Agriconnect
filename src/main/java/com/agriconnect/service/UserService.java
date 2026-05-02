package com.agriconnect.service;

import com.agriconnect.dao.UserDao;
import com.agriconnect.dto.UserRegistrationDto;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.model.User;
import com.agriconnect.security.LoginIdentity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserDao userDao;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    public User register(UserRegistrationDto dto) {
        String email = LoginIdentity.normalizeEmail(dto.getEmail());
        User.Role role = User.Role.valueOf(dto.getRole());
        if (userDao.existsByEmailAndRole(email, role)) {
            throw new BusinessValidationException("An account already exists for this email and role");
        }

        User user = new User();
        user.setName(dto.getName().trim());
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(dto.getPassword()));
        user.setPhone(dto.getPhone().trim());
        user.setRole(role);
        user.setVerificationStatus(User.VerificationStatus.PENDING);
        userDao.save(user);
        return user;
    }
}
