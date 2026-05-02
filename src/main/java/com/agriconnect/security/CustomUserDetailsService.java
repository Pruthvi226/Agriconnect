package com.agriconnect.security;

import com.agriconnect.dao.UserDao;
import com.agriconnect.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserDao userDao;

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        LoginIdentity.Parsed identity;
        try {
            identity = LoginIdentity.parse(username);
        } catch (IllegalArgumentException e) {
            throw new UsernameNotFoundException("Invalid role selected", e);
        }

        User user = identity.hasRole()
                ? userDao.findByEmailAndRole(identity.getEmail(), identity.getRole())
                    .orElseThrow(() -> new UsernameNotFoundException("User not found for email and role"))
                : userDao.findByEmail(identity.getEmail())
                    .orElseThrow(() -> new UsernameNotFoundException("Select a role to sign in with this email"));
        return new CustomUserDetails(user);
    }
}
