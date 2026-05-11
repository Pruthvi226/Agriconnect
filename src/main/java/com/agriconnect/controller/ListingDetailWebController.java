package com.agriconnect.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Routes /web/marketplace/listing/{id} to the listing-details JSP view.
 * The "View & Bid" button in marketplace.jsp links to this controller.
 */
@Controller
@RequestMapping("/web/marketplace/listing")
public class ListingDetailWebController {

    @Autowired
    private com.agriconnect.service.ListingService listingService;

    @GetMapping("/{id}")
    public ModelAndView listingDetail(@PathVariable("id") Long id) {
        ModelAndView mav = new ModelAndView("listing-details");
        com.agriconnect.model.ProduceListing listing = listingService.getListingById(id);
        mav.addObject("listing", listing);
        mav.addObject("listingId", id);
        return mav;
    }
}
