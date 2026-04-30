package com.agriconnect.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping({"/", "/web"})
    public String home() {
        return "redirect:/web/marketplace";
    }
}
