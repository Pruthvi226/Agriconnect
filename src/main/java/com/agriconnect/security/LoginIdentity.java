package com.agriconnect.security;

import com.agriconnect.model.User;

public final class LoginIdentity {
    private static final String SEPARATOR = "|";

    private LoginIdentity() {
    }

    public static String format(String email, User.Role role) {
        return normalizeEmail(email) + SEPARATOR + role.name();
    }

    public static String format(User user) {
        return format(user.getEmail(), user.getRole());
    }

    public static Parsed parse(String username) {
        String value = username == null ? "" : username.trim();
        int separatorIndex = value.lastIndexOf(SEPARATOR);
        if (separatorIndex < 0) {
            return new Parsed(normalizeEmail(value), null);
        }

        String email = normalizeEmail(value.substring(0, separatorIndex));
        String roleValue = value.substring(separatorIndex + 1).trim();
        User.Role role = roleValue.isEmpty() ? null : User.Role.valueOf(roleValue);
        return new Parsed(email, role);
    }

    public static String normalizeEmail(String email) {
        return email == null ? "" : email.trim().toLowerCase();
    }

    public static final class Parsed {
        private final String email;
        private final User.Role role;

        private Parsed(String email, User.Role role) {
            this.email = email;
            this.role = role;
        }

        public String getEmail() {
            return email;
        }

        public User.Role getRole() {
            return role;
        }

        public boolean hasRole() {
            return role != null;
        }
    }
}
