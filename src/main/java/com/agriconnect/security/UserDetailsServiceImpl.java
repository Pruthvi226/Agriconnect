package com.agriconnect.security;

import com.agriconnect.dao.UserDao;
import com.agriconnect.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

@Service("userDetailsService")
public class UserDetailsServiceImpl implements UserDetailsService {

    @Autowired
    private UserDao userDao;

    @Autowired
    private PlatformTransactionManager transactionManager;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        LoginIdentity.Parsed identity;
        try {
            identity = LoginIdentity.parse(username);
        } catch (IllegalArgumentException ex) {
            throw new UsernameNotFoundException("Invalid login identity", ex);
        }

        TransactionTemplate transaction = new TransactionTemplate(transactionManager);
        transaction.setReadOnly(true);
        return transaction.execute(status -> {
            User user = identity.hasRole()
                    ? userDao.findByEmailAndRole(identity.getEmail(), identity.getRole())
                        .orElseThrow(() -> new UsernameNotFoundException("User not found"))
                    : userDao.findByEmail(identity.getEmail())
                        .orElseThrow(() -> new UsernameNotFoundException("User not found"));
            return new CustomUserDetails(user);
        });
    }
}
