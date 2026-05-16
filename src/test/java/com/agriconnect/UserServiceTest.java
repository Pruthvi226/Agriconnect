package com.agriconnect;

import com.agriconnect.dao.UserDao;
import com.agriconnect.dto.UserRegistrationDto;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.model.User;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.security.LoginIdentity;
import com.agriconnect.service.UserService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "classpath:test-app-context.xml")
@Transactional
class UserServiceTest {

    @Autowired
    private UserService userService;

    @Autowired
    private UserDao userDao;

    @Autowired
    private UserDetailsService userDetailsService;

    @Test
    void registrationCreatesUserWithProfileAndHashedPassword() {
        User user = userService.register(registration("Farmer One", "farmer.one@example.com", "FARMER"));

        User saved = userDao.findById(user.getId()).orElseThrow();
        assertThat(saved.getEmail()).isEqualTo("farmer.one@example.com");
        assertThat(saved.getRole()).isEqualTo(User.Role.FARMER);
        assertThat(saved.getPasswordHash()).startsWith("$2a$12$");
    }

    @Test
    void duplicateEmailForSameRoleThrows() {
        userService.register(registration("Buyer One", "buyer.one@example.com", "BUYER"));

        assertThatThrownBy(() -> userService.register(registration("Buyer Duplicate", "buyer.one@example.com", "BUYER")))
                .isInstanceOf(BusinessValidationException.class);
    }

    @Test
    void loginIdentityLoadsUserDetailsByEmailAndRole() {
        User user = userService.register(registration("Buyer Two", "buyer.two@example.com", "BUYER"));

        UserDetails details = userDetailsService.loadUserByUsername(LoginIdentity.format(user));

        assertThat(details).isInstanceOf(CustomUserDetails.class);
        assertThat(details.getAuthorities()).extracting("authority").containsExactly("ROLE_BUYER");
    }

    @Test
    void customUserDetailsKeepsIdentitySnapshotWithoutEntityReference() {
        User user = new User();
        user.setId(42L);
        user.setEmail("farmer.snapshot@example.com");
        user.setRole(User.Role.FARMER);
        user.setPasswordHash("hash");

        CustomUserDetails details = new CustomUserDetails(user);
        details.setUser(null);

        assertThat(details.getId()).isEqualTo(42L);
        assertThat(details.getUsername()).isEqualTo("farmer.snapshot@example.com|FARMER");
        assertThat(details.getAuthorities()).extracting("authority").containsExactly("ROLE_FARMER");
    }

    private UserRegistrationDto registration(String name, String email, String role) {
        UserRegistrationDto dto = new UserRegistrationDto();
        dto.setName(name);
        dto.setEmail(email);
        dto.setPassword(role.equals("FARMER") ? "Farmer@123" : "Buyer@123");
        dto.setPhone("9876543210");
        dto.setRole(role);
        return dto;
    }
}
