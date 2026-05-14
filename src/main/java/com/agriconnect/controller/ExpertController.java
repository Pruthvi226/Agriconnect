package com.agriconnect.controller;

import com.agriconnect.dao.AdvisoryDao;
import com.agriconnect.dto.AdvisoryRequestDto;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.AdvisoryAlertService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.Arrays;

@Controller
@RequestMapping("/expert")
public class ExpertController {

    @Autowired
    private AdvisoryDao advisoryDao;

    @Autowired
    private AdvisoryAlertService advisoryAlertService;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("advisories", advisoryDao.findAll());
        return "expert/dashboard";
    }

    @GetMapping("/advisories")
    public String advisories(Model model) {
        model.addAttribute("advisories", advisoryDao.findAll());
        return "expert/dashboard";
    }

    @GetMapping("/advisories/new")
    public String newAdvisory() {
        return "expert/advisory-form";
    }

    @PostMapping("/advisories")
    public String create(@RequestParam String title,
                         @RequestParam String body,
                         @RequestParam(required = false) String cropName,
                         @RequestParam String advisoryType,
                         @RequestParam String severity,
                         @RequestParam String affectedDistricts,
                         @RequestParam String validUntil,
                         Authentication authentication) {
        AdvisoryRequestDto dto = new AdvisoryRequestDto();
        dto.setTitle(title);
        dto.setBody(body);
        dto.setCropName(cropName);
        dto.setAdvisoryType(advisoryType);
        dto.setSeverity(severity);
        dto.setAffectedDistricts(Arrays.stream(affectedDistricts.split(","))
                .map(String::trim)
                .filter(value -> !value.isBlank())
                .toList());
        dto.setValidUntil(LocalDate.parse(validUntil));
        advisoryAlertService.publishAdvisory(dto, ((CustomUserDetails) authentication.getPrincipal()).getId());
        return "redirect:/expert/advisories";
    }
}
