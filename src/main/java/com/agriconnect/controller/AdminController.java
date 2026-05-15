package com.agriconnect.controller;

import com.agriconnect.dao.MspRateDao;
import com.agriconnect.model.MspRate;
import com.agriconnect.model.Order;
import com.agriconnect.model.User;
import com.agriconnect.dao.OrderDao;
import com.agriconnect.service.ListingService;
import com.agriconnect.service.MspRateService;
import com.agriconnect.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.util.List;

@Controller
@RequestMapping("/web/admin")
@Transactional
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private ListingService listingService;

    @Autowired
    private MspRateService mspRateService;

    @Autowired
    private MspRateDao mspRateDao;

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private com.agriconnect.dao.AuditLogDao auditLogDao;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        List<User> users = userService.getAllUsers();
        List<Order> orders = orderDao.findAll();
        List<com.agriconnect.model.ProduceListing> listings =
                listingService.searchListings(new com.agriconnect.dto.SearchFiltersDto());
        var belowMspListings = listingService.getBelowMspListings();

        model.addAttribute("userCount", users.size());
        model.addAttribute("pendingUserCount", users.stream()
                .filter(user -> user.getVerificationStatus() == User.VerificationStatus.PENDING)
                .count());
        model.addAttribute("listingCount", listings.size());
        model.addAttribute("belowMspCount", belowMspListings.size());
        model.addAttribute("orderCount", orders.size());
        model.addAttribute("activeOrderCount", orders.stream()
                .filter(order -> order.getOrderStatus() == Order.OrderStatus.CONFIRMED
                        || order.getOrderStatus() == Order.OrderStatus.IN_TRANSIT)
                .count());
        model.addAttribute("orderVolume", orders.stream()
                .map(Order::getTotalAmount)
                .filter(java.util.Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add));
        model.addAttribute("recentAuditCount", auditLogDao.findRecent(100).size());
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

    @GetMapping("/audit")
    public String audit(Model model) {
        model.addAttribute("logs", auditLogDao.findRecent(100));
        return "admin/audit";
    }

    @GetMapping("/msp-compliance")
    public String mspCompliance(Model model) {
        model.addAttribute("listings", listingService.getBelowMspListings());
        return "admin/msp-compliance";
    }
}
