package com.agriconnect.controller;

import com.agriconnect.dto.UserRegistrationDto;
import com.agriconnect.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class WebAuthController {

    @Autowired
    private UserService userService;

    @GetMapping({"/auth/login", "/web/login"})
    public ModelAndView loginPage() {
        return new ModelAndView("login");
    }

    @GetMapping({"/auth/register", "/web/register"})
    public ModelAndView registerPage() {
        ModelAndView mav = new ModelAndView("register");
        mav.addObject("registration", new UserRegistrationDto());
        return mav;
    }

    @PostMapping({"/auth/register", "/web/register"})
    public String register(@Valid @ModelAttribute UserRegistrationDto dto,
                           BindingResult bindingResult,
                           RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("error", bindingResult.getAllErrors().get(0).getDefaultMessage());
            return "redirect:/auth/register";
        }

        try {
            userService.register(dto);
            redirectAttributes.addFlashAttribute("msg", "Registration successful. Please log in.");
            return "redirect:/auth/login?registered=true";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/auth/register";
        }
    }
}
