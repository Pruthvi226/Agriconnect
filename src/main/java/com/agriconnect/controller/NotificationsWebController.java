package com.agriconnect.controller;

import com.agriconnect.dao.NotificationDao;
import com.agriconnect.model.Notification;
import com.agriconnect.security.CustomUserDetails;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/web/notifications")
@Transactional
public class NotificationsWebController {

    @Autowired
    private NotificationDao notificationDao;

    @GetMapping
    public ModelAndView getNotifications(Authentication authentication) {
        Long userId = currentUserId(authentication);
        ModelAndView mav = new ModelAndView("notifications");
        mav.addObject("notifications", notificationDao.findByUser(userId));
        mav.addObject("unreadCount", notificationDao.countUnread(userId));
        return mav;
    }

    @PostMapping("/{id}/read")
    public String markAsRead(@PathVariable("id") Long id,
                             Authentication authentication,
                             RedirectAttributes redirectAttributes) {
        Long userId = currentUserId(authentication);
        Notification notification = notificationDao.findByUserAndId(userId, id)
                .orElseThrow(() -> new IllegalArgumentException("Notification not found"));
        notification.setIsRead(true);
        notificationDao.update(notification);
        redirectAttributes.addFlashAttribute("msg", "Notification marked as read.");
        return "redirect:/web/notifications";
    }

    @PostMapping("/read-all")
    public String markAllRead(Authentication authentication, RedirectAttributes redirectAttributes) {
        int updated = notificationDao.markAllRead(currentUserId(authentication));
        redirectAttributes.addFlashAttribute("msg", updated + " notifications marked as read.");
        return "redirect:/web/notifications";
    }

    private Long currentUserId(Authentication authentication) {
        return ((CustomUserDetails) authentication.getPrincipal()).getId();
    }
}
