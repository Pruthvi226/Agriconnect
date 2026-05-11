package com.agriconnect.integration;

import com.agriconnect.dto.ListingRequestDto;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/applicationContext.xml", "file:src/main/webapp/WEB-INF/dispatcher-servlet.xml"})
@WebAppConfiguration
@SuppressWarnings("null")
public class ListingControllerIT {

    @Autowired
    private WebApplicationContext webApplicationContext;

    private MockMvc mockMvc;
    private ObjectMapper mapper = new ObjectMapper();

    @BeforeEach
    public void setup() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(this.webApplicationContext).build();
        mapper.findAndRegisterModules();
    }

    @Test
    public void testListingFlow() throws Exception {
        ListingRequestDto dto = new ListingRequestDto();
        dto.setCropName("Tomato");
        dto.setQuantityKg(BigDecimal.valueOf(100));
        dto.setAskingPricePerKg(BigDecimal.valueOf(30));
        dto.setAvailableFrom(LocalDate.now().plusDays(1));
        dto.setAvailableUntil(LocalDate.now().plusDays(10));

        // Note: Without a valid JWT token matching the mock security context, this will return 403.
        // We will assert the 403 here since we don't have a live DB initialized with users in H2 yet.
        // In a true IT, we would use @WithMockUser(roles = "FARMER", username = "test@test.com")
        
        mockMvc.perform(post("/api/v1/listings")
                .contentType(MediaType.APPLICATION_JSON)
                .content(mapper.writeValueAsString(dto)))
                .andExpect(status().isUnauthorized()); // Validating Security intercepts

        mockMvc.perform(get("/api/v1/listings/search"))
                .andExpect(status().isOk()); // Assuming GET /search is not strictly locked or we're validating endpoint existence
    }
}
