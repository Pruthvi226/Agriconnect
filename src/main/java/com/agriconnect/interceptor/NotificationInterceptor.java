package com.agriconnect.interceptor;

import com.agriconnect.dao.NotificationDao;
import com.agriconnect.security.CustomUserDetails;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Component
public class NotificationInterceptor implements HandlerInterceptor {

    @Autowired
    private NotificationDao notificationDao;

    @Override
    public void postHandle(@org.springframework.lang.NonNull HttpServletRequest request, 
                           @org.springframework.lang.NonNull HttpServletResponse response, 
                           @org.springframework.lang.NonNull Object handler, 
                           @org.springframework.lang.Nullable ModelAndView modelAndView) throws Exception {
        if (modelAndView != null) {
            String viewName = modelAndView.getViewName();
            if (viewName != null && !viewName.startsWith("redirect:")) {
                Authentication auth = SecurityContextHolder.getContext().getAuthentication();
                if (auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
                    CustomUserDetails user = (CustomUserDetails) auth.getPrincipal();
                    long unreadCount = notificationDao.countUnread(user.getId());
                    modelAndView.addObject("unreadCount", unreadCount);
                }
            }
        }
    }
}
