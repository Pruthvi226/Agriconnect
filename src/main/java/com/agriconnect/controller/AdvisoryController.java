package com.agriconnect.controller;

import com.agriconnect.dto.AdvisoryRequestDto;
import com.agriconnect.dto.ApiResponse;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.AdvisoryAlertService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/api/v1/advisories")
public class AdvisoryController {

    @Autowired
    private AdvisoryAlertService advisoryAlertService;

    @PostMapping
    public ResponseEntity<ApiResponse<String>> publishAdvisory(@Valid @RequestBody AdvisoryRequestDto dto,
                                                               Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        advisoryAlertService.publishAdvisory(dto, userDetails.getId());
        return ResponseEntity.ok(ApiResponse.success("Advisory published", "Advisory successfully published and notifications dispatched"));
    }
}

@Controller
@RequestMapping({"/web/advisories", "/web/expert/advisories"})
class AdvisoryWebController {
    @Autowired
    private AdvisoryAlertService advisoryAlertService;

    @GetMapping
    public ModelAndView getAdvisories() {
        ModelAndView mav = new ModelAndView("advisories");
        mav.addObject("advisories", advisoryAlertService.getAllAdvisories());
        mav.addObject("defaultValidUntil", LocalDate.now().plusDays(7));
        return mav;
    }

    @GetMapping("/{id}")
    public ModelAndView getAdvisoryDetail(@PathVariable("id") Long id) {
        ModelAndView mav = new ModelAndView("advisory-detail");
        mav.addObject("advisory", advisoryAlertService.getAdvisory(id));
        return mav;
    }

    @PostMapping
    public String publishAdvisoryWeb(@RequestParam("title") String title,
                                     @RequestParam("body") String body,
                                     @RequestParam(value = "cropName", required = false) String cropName,
                                     @RequestParam("advisoryType") String advisoryType,
                                     @RequestParam("severity") String severity,
                                     @RequestParam("affectedDistricts") String affectedDistricts,
                                     @RequestParam("validUntil") LocalDate validUntil,
                                     Authentication authentication,
                                     RedirectAttributes redirectAttributes) {
        List<String> districts = Arrays.stream(affectedDistricts.split(","))
                .map(String::trim)
                .filter(value -> !value.isBlank())
                .toList();
        if (districts.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Add at least one affected district.");
            return "redirect:/web/advisories";
        }

        AdvisoryRequestDto dto = new AdvisoryRequestDto();
        dto.setTitle(title);
        dto.setBody(body);
        dto.setCropName(cropName);
        dto.setAdvisoryType(advisoryType);
        dto.setSeverity(severity);
        dto.setAffectedDistricts(districts);
        dto.setValidUntil(validUntil);

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        advisoryAlertService.publishAdvisory(dto, userDetails.getId());
        redirectAttributes.addFlashAttribute("msg", "Advisory published and matching farmers notified.");
        return "redirect:/web/advisories";
    }
}
