package com.agriconnect.security;

import com.agriconnect.model.User;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.beans.ConstructorProperties;
import java.io.Serial;
import java.util.Collection;
import java.util.Collections;

@JsonIgnoreProperties(ignoreUnknown = true)
public class CustomUserDetails implements UserDetails {

    @Serial
    private static final long serialVersionUID = 1L;

    @JsonIgnore
    private transient User user;
    private Long id;
    private String email;
    private User.Role role;
    @JsonIgnore
    private String passwordHash;

    public CustomUserDetails() {
        // No-arg constructor for deserialization
        this.user = null;
    }

    @ConstructorProperties({"user"})
    public CustomUserDetails(User user) {
        setUser(user);
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        if (role == null) return Collections.emptyList();
        return Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + role.name()));
    }

    @Override
    public String getPassword() {
        return passwordHash;
    }

    @Override
    public String getUsername() {
        if (email == null) return null;
        return role != null ? LoginIdentity.format(email, role) : LoginIdentity.normalizeEmail(email);
    }

    public Long getId() {
        return id;
    }

    @JsonIgnore
    public User getUser() {
        if (user == null && (id != null || email != null || role != null)) {
            User snapshot = new User();
            snapshot.setId(id);
            snapshot.setEmail(email);
            snapshot.setRole(role);
            snapshot.setPasswordHash(passwordHash);
            user = snapshot;
        }
        return user;
    }

    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.id = user.getId();
            this.email = user.getEmail();
            this.role = user.getRole();
            this.passwordHash = user.getPasswordHash();
        }
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = LoginIdentity.normalizeEmail(email);
    }

    public User.Role getRole() {
        return role;
    }

    public void setRole(User.Role role) {
        this.role = role;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    @Override
    public boolean isAccountNonExpired() { return true; }
    @Override
    public boolean isAccountNonLocked() { return true; }
    @Override
    public boolean isCredentialsNonExpired() { return true; }
    @Override
    public boolean isEnabled() { return true; }
}
