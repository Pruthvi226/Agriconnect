package com.agriconnect.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

/**
 * Routes /web/marketplace/listing/{id} to the listing-details JSP view.
 * The "View & Bid" button in marketplace.jsp links to this controller.
 */
@Controller
@RequestMapping("/web/marketplace/listing")
public class ListingDetailWebController {

    @GetMapping("/{id}")
    public ModelAndView listingDetail(@PathVariable Long id) {
        ModelAndView mav = new ModelAndView("listing-details");
        // In a full implementation, load the specific listing by id
        mav.addObject("listingId", id);
        return mav;
    }
}
