package com.agriconnect.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.Collections;

@Controller
@RequestMapping("/web/notifications")
public class NotificationsWebController {

    @GetMapping
    public ModelAndView getNotifications() {
        ModelAndView mav = new ModelAndView("notifications");
        // Stub: in a full implementation, load from NotificationDao for current user
        mav.addObject("notifications", Collections.emptyList());
        return mav;
    }
}
