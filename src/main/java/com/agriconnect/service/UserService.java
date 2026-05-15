package com.agriconnect.service;

import com.agriconnect.dao.UserDao;
import com.agriconnect.dto.UserRegistrationDto;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.exception.ResourceNotFoundException;
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

    @Autowired
    private com.agriconnect.dao.FarmerProfileDao farmerProfileDao;

    @Autowired
    private com.agriconnect.dao.BaseDao<com.agriconnect.model.BuyerProfile, Long> buyerProfileDao;

    public User register(UserRegistrationDto dto) {
        String email = LoginIdentity.normalizeEmail(dto.getEmail());
        User.Role role = User.Role.valueOf(dto.getRole());
        if (userDao.existsByEmailAndRole(email, role)) {
            throw new BusinessValidationException("An account already exists for this email and role");
        }

        User user = new User();
        user.setName(dto.getName() != null ? dto.getName().trim() : "Anonymous");
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(dto.getPassword()));
        user.setPhone(normalizePhone(dto.getPhone()));
        user.setRole(role);
        user.setVerificationStatus(User.VerificationStatus.PENDING);
        userDao.save(user);

        if (role == User.Role.FARMER) {
            com.agriconnect.model.FarmerProfile profile = new com.agriconnect.model.FarmerProfile();
            profile.setUser(user);
            profile.setFarmerScore(new java.math.BigDecimal("50.00"));
            profile.setVillage("Not specified");
            profile.setDistrict("Nashik"); // Default to a major agri district
            profile.setState("Maharashtra");
            // profileDao is needed
            farmerProfileDao.save(profile);
        } else if (role == User.Role.BUYER) {
            com.agriconnect.model.BuyerProfile profile = new com.agriconnect.model.BuyerProfile();
            profile.setUser(user);
            buyerProfileDao.save(profile);
        }

        return user;
    }

    private String normalizePhone(String phone) {
        if (phone == null) {
            return "";
        }
        String digits = phone.replaceAll("[^0-9]", "");
        return digits.startsWith("91") && digits.length() == 12 ? digits.substring(2) : digits;
    }

    /**
     * Lists all users for admin dashboard.
     */
    public java.util.List<User> getAllUsers() {
        return userDao.findAll();
    }

    /**
     * Verifies or rejects a user (Admin only).
     */
    public void verifyUser(Long userId, String status) {
        User user = userDao.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        user.setVerificationStatus(User.VerificationStatus.valueOf(status.toUpperCase()));
        userDao.update(user);
    }
}
