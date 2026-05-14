package com.agriconnect.controller;

import com.agriconnect.dao.MspRateDao;
import com.agriconnect.model.MspRate;
import com.agriconnect.service.ListingService;
import com.agriconnect.service.MspRateService;
import com.agriconnect.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/web/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private ListingService listingService;

    @Autowired
    private MspRateService mspRateService;

    @Autowired
    private MspRateDao mspRateDao;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("userCount", userService.getAllUsers().size());
        model.addAttribute("listingCount", listingService.searchListings(new com.agriconnect.dto.SearchFiltersDto()).size());
        model.addAttribute("orderVolume", 0);
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String users(Model model) {
        model.addAttribute("users", userService.getAllUsers());
        return "admin/users";
    }

    @PostMapping("/users/{id}/verify")
    public String verify(@PathVariable("id") Long id, @RequestParam("status") String status) {
        userService.verifyUser(id, status);
        return "redirect:/web/admin/users";
    }

    @GetMapping("/msp")
    public String msp(Model model) {
        model.addAttribute("rates", mspRateService.getAllRates());
        model.addAttribute("rate", new MspRate());
        return "admin/msp";
    }

    @PostMapping("/msp")
    public String addMsp(@ModelAttribute MspRate rate) {
        mspRateDao.save(rate);
        return "redirect:/web/admin/msp";
    }
}
