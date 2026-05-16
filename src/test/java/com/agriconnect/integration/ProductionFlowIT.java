package com.agriconnect.integration;

import com.agriconnect.dto.BidRequestDto;
import com.agriconnect.dto.ListingRequestDto;
import com.agriconnect.model.*;
import com.agriconnect.security.CustomUserDetails;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {
        "classpath:test-app-context.xml",
        "file:src/main/webapp/WEB-INF/spring/security-context.xml",
        "file:src/main/webapp/WEB-INF/spring/mvc-context.xml"
})
@WebAppConfiguration
@Transactional
@DirtiesContext
@SuppressWarnings("null")
public class ProductionFlowIT {
    
    static {
        System.setProperty("DB_DRIVER", "org.h2.Driver");
        System.setProperty("DB_URL", "jdbc:h2:mem:agriconnect;DB_CLOSE_DELAY=-1;MODE=MySQL");
        System.setProperty("DB_USER", "sa");
        System.setProperty("DB_PASS", "");
        System.setProperty("HIBERNATE_DDL_AUTO", "update");
    }

    @Autowired
    private WebApplicationContext webApplicationContext;
    
    @Autowired
    private com.agriconnect.dao.UserDao userDao;
    
    @Autowired
    private com.agriconnect.dao.FarmerProfileDao farmerProfileDao;
    
    @Autowired
    private com.agriconnect.dao.BuyerProfileDao buyerProfileDao;

    private MockMvc mockMvc;
    private ObjectMapper mapper = new ObjectMapper();
    private Long farmerUserId;
    private Long buyerUserId;

    @BeforeEach
    public void setup() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(this.webApplicationContext)
                .apply(springSecurity())
                .build();
        mapper.findAndRegisterModules();
        mapper.setPropertyNamingStrategy(com.fasterxml.jackson.databind.PropertyNamingStrategies.SNAKE_CASE);
        seedData();
    }

    private void seedData() {
        // Clear old data to be safe (though @DirtiesContext should handle it)
        
        User farmerUser = new User();
        farmerUser.setEmail("farmer@test.com");
        farmerUser.setRole(User.Role.FARMER);
        farmerUser.setPasswordHash("pass");
        userDao.save(farmerUser);
        this.farmerUserId = farmerUser.getId();

        FarmerProfile farmer = new FarmerProfile();
        farmer.setUser(farmerUser);
        farmer.setDistrict("Nashik");
        farmerProfileDao.save(farmer);

        User buyerUser = new User();
        buyerUser.setEmail("buyer@test.com");
        buyerUser.setRole(User.Role.BUYER);
        buyerUser.setPasswordHash("pass");
        userDao.save(buyerUser);
        this.buyerUserId = buyerUser.getId();

        BuyerProfile buyer = new BuyerProfile();
        buyer.setUser(buyerUser);
        buyer.setCompanyName("Test Buyer");
        buyerProfileDao.save(buyer);
    }

    private CustomUserDetails getPrincipal(Long id, String email, String role) {
        User user = new User();
        user.setId(id);
        user.setEmail(email);
        user.setRole(User.Role.valueOf(role));
        return new CustomUserDetails(user);
    }

    @Test
    public void testProductionTradeFlow() throws Exception {
        CustomUserDetails farmer = getPrincipal(farmerUserId, "farmer@test.com", "FARMER");
        CustomUserDetails buyer = getPrincipal(buyerUserId, "buyer@test.com", "BUYER");

        // 1. Farmer creates an Urgent Listing
        ListingRequestDto listingDto = new ListingRequestDto();
        listingDto.setCropName("Wheat");
        listingDto.setVariety("Sharbati");
        listingDto.setQuantityKg(BigDecimal.valueOf(1000));
        listingDto.setAskingPricePerKg(BigDecimal.valueOf(25.5));
        listingDto.setAvailableFrom(LocalDate.now());
        listingDto.setAvailableUntil(LocalDate.now().plusDays(30));
        listingDto.setIsUrgent(true);
        listingDto.setUrgentReason("IMMEDIATE_CASH");

        MvcResult listingResult = mockMvc.perform(post("/api/v1/listings")
                .with(user(farmer))
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(listingDto)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.crop_name").value("Wheat"))
                .andReturn();
        
        // Extract Listing ID
        String responseBody = listingResult.getResponse().getContentAsString();
        Integer listingIdInt = mapper.readTree(responseBody).path("data").path("id").asInt();
        Long listingId = Long.valueOf(listingIdInt);

        // 2. Buyer searches for listings and sees the urgent one
        mockMvc.perform(get("/api/v1/listings/search")
                .with(user(buyer))
                .param("cropName", "Wheat"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data[0].id").value(listingId));

        // 3. Buyer places a bid
        BidRequestDto bidDto = new BidRequestDto();
        bidDto.setListingId(listingId);
        bidDto.setBidPricePerKg(BigDecimal.valueOf(24.0));
        bidDto.setQuantityKg(BigDecimal.valueOf(500));

        MvcResult bidResult = mockMvc.perform(post("/api/v1/bids")
                .with(user(buyer))
                .with(csrf())
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(bidDto)))
                .andExpect(status().isOk())
                .andReturn();

        Integer bidIdInt = mapper.readTree(bidResult.getResponse().getContentAsString()).path("data").path("id").asInt();
        Long bidId = Long.valueOf(bidIdInt);

        // 4. Farmer sends a counter-offer
        mockMvc.perform(post("/web/farmer/bids/" + bidId + "/counter")
                .with(user(farmer))
                .with(csrf())
                .param("counterPrice", "25.0")
                .param("counterMessage", "Please consider Grade A quality"))
                .andExpect(status().is3xxRedirection());

        // 5. Buyer accepts the counter-offer
        mockMvc.perform(put("/api/v1/bids/" + bidId + "/accept-counter")
                .with(user(buyer))
                .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.order_status").value("CONFIRMED"));
    }
}
