package com.agriconnect.controller;

import com.agriconnect.dto.ApiResponse;
import com.agriconnect.dto.DemandForecastReport;
import com.agriconnect.service.DemandForecastService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/forecast")
public class DemandForecastController {

    @Autowired
    private DemandForecastService demandForecastService;

    @GetMapping("/latest")
    public ResponseEntity<ApiResponse<DemandForecastReport>> getLatestForecast() {
        DemandForecastReport report = demandForecastService.getLatestForecast();
        return ResponseEntity.ok(ApiResponse.success(report, "Latest demand forecast retrieved"));
    }
}
