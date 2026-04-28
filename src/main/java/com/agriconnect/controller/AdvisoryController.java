package com.agriconnect.controller;

import com.agriconnect.dto.AdvisoryRequestDto;
import com.agriconnect.dto.ApiResponse;
import com.agriconnect.service.AdvisoryAlertService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.Collections;

@RestController
@RequestMapping("/api/v1/advisories")
public class AdvisoryController {

    @Autowired
    private AdvisoryAlertService advisoryAlertService;

    @PostMapping
    public ResponseEntity<ApiResponse<String>> publishAdvisory(@Valid @RequestBody AdvisoryRequestDto dto) {
        // Stub expertId
        advisoryAlertService.publishAdvisory(dto, 1L);
        return ResponseEntity.ok(ApiResponse.success("Advisory published", "Advisory successfully published and notifications dispatched"));
    }
}

@Controller
@RequestMapping("/web/advisories")
class AdvisoryWebController {
    @GetMapping
    public ModelAndView getAdvisories() {
        ModelAndView mav = new ModelAndView("advisories");
        mav.addObject("advisories", Collections.emptyList()); // Stub
        return mav;
    }
}
