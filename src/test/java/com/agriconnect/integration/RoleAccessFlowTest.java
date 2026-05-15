package com.agriconnect.integration;

import com.agriconnect.model.User;
import com.agriconnect.security.CustomUserDetails;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.UUID;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.forwardedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
        "classpath:test-app-context.xml",
        "file:src/main/webapp/WEB-INF/spring/security-context.xml",
        "file:src/main/webapp/WEB-INF/spring/mvc-context.xml"
})
@WebAppConfiguration
@SuppressWarnings("null")
class RoleAccessFlowTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    private MockMvc mockMvc;

    @BeforeEach
    void setup() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(this.webApplicationContext)
                .apply(springSecurity())
                .build();
    }

    @Test
    void publicWebPagesAreReachableWithoutLogin() throws Exception {
        mockMvc.perform(get("/web/register"))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/register.jsp"));

        mockMvc.perform(get("/auth/register"))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/register.jsp"));

        mockMvc.perform(get("/web/login"))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/login.jsp"));

        mockMvc.perform(get("/web/msp-checker"))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/msp-checker.jsp"));

        mockMvc.perform(get("/web/marketplace"))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/marketplace.jsp"));
    }

    @Test
    void webRegistrationPostsEndToEndWithCsrf() throws Exception {
        String suffix = UUID.randomUUID().toString().replace("-", "");

        mockMvc.perform(post("/web/register")
                .with(csrf())
                .param("name", "Role Flow Farmer")
                .param("email", "role.flow." + suffix + "@example.com")
                .param("password", "securePassword123")
                .param("phone", "9876543210")
                .param("role", "FARMER"))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/auth/login?registered=true"));
    }

    @Test
    void protectedPagesRedirectAnonymousUsersToLogin() throws Exception {
        mockMvc.perform(get("/web/farmer/listings"))
                .andExpect(status().is3xxRedirection());

        mockMvc.perform(get("/web/buyer/orders"))
                .andExpect(status().is3xxRedirection());

        mockMvc.perform(get("/web/admin/audit"))
                .andExpect(status().is3xxRedirection());

        mockMvc.perform(get("/web/notifications"))
                .andExpect(status().is3xxRedirection());
    }

    @Test
    void eachRoleCanOpenItsOwnWebFlow() throws Exception {
        mockMvc.perform(get("/web/farmer/listings").with(user(principal(101L, "farmer.flow@example.com", User.Role.FARMER))))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/farmer-listings.jsp"));

        mockMvc.perform(get("/web/buyer/orders").with(user(principal(102L, "buyer.flow@example.com", User.Role.BUYER))))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/buyer/orders.jsp"));

        mockMvc.perform(get("/web/expert/dashboard").with(user(principal(103L, "expert.flow@example.com", User.Role.AGRI_EXPERT))))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/expert/dashboard.jsp"));

        mockMvc.perform(get("/web/expert/advisories").with(user(principal(103L, "expert.flow@example.com", User.Role.AGRI_EXPERT))))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/advisories.jsp"));

        mockMvc.perform(get("/web/admin/audit").with(user(principal(104L, "admin.flow@example.com", User.Role.ADMIN))))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/admin/audit.jsp"));
    }

    @Test
    void legacyRoleRoutesAreStillRoleProtected() throws Exception {
        mockMvc.perform(get("/farmer/listings").with(user(principal(201L, "legacy.farmer@example.com", User.Role.FARMER))))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/farmer/listings.jsp"));

        mockMvc.perform(get("/buyer/orders").with(user(principal(202L, "legacy.buyer@example.com", User.Role.BUYER))))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/buyer/orders.jsp"));

        mockMvc.perform(get("/expert/advisories").with(user(principal(203L, "legacy.expert@example.com", User.Role.AGRI_EXPERT))))
                .andExpect(status().isOk())
                .andExpect(forwardedUrl("/WEB-INF/views/expert/dashboard.jsp"));

        mockMvc.perform(get("/expert/advisories").with(user(principal(204L, "wrong.buyer@example.com", User.Role.BUYER))))
                .andExpect(status().isForbidden());
    }

    @Test
    void crossRoleAccessIsForbidden() throws Exception {
        mockMvc.perform(get("/web/admin/audit").with(user(principal(301L, "buyer.noadmin@example.com", User.Role.BUYER))))
                .andExpect(status().isForbidden());

        mockMvc.perform(get("/web/buyer/orders").with(user(principal(302L, "farmer.nobuyer@example.com", User.Role.FARMER))))
                .andExpect(status().isForbidden());

        mockMvc.perform(get("/web/farmer/listings").with(user(principal(303L, "expert.nofarmer@example.com", User.Role.AGRI_EXPERT))))
                .andExpect(status().isForbidden());
    }

    private CustomUserDetails principal(Long id, String email, User.Role role) {
        User user = new User();
        user.setId(id);
        user.setName(role.name() + " User");
        user.setEmail(email);
        user.setPasswordHash("password");
        user.setPhone("9876543210");
        user.setRole(role);
        return new CustomUserDetails(user);
    }
}
