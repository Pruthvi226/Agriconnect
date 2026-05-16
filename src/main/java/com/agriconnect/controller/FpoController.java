package com.agriconnect.controller;

import com.agriconnect.dto.ApiResponse;
import com.agriconnect.dto.FpoGroupDto;
import com.agriconnect.dto.FpoListingDto;
import com.agriconnect.dto.FpoListingResponseDto;
import com.agriconnect.model.FpoGroup;
import com.agriconnect.model.FpoListing;
import com.agriconnect.model.FpoMembership;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.FpoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@RestController
@RequestMapping("/api/v1/fpo")
public class FpoController {

    @Autowired
    private FpoService fpoService;

    @PostMapping("/groups")
    public ResponseEntity<ApiResponse<FpoGroup>> createGroup(@RequestBody FpoGroupDto dto, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        return ResponseEntity.ok(ApiResponse.success(
                fpoService.createFpoGroup(dto, userDetails.getId()),
                "FPO group created successfully"
        ));
    }

    @PostMapping("/{fpoId}/join")
    public ResponseEntity<ApiResponse<FpoMembership>> joinFpo(@PathVariable Long fpoId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        return ResponseEntity.ok(ApiResponse.success(
                fpoService.joinFpo(fpoId, userDetails.getId()),
                "FPO join request submitted"
        ));
    }

    @PutMapping("/memberships/{membershipId}/approve")
    public ResponseEntity<ApiResponse<FpoMembership>> approveMembership(@PathVariable Long membershipId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        return ResponseEntity.ok(ApiResponse.success(
                fpoService.approveMembership(membershipId, userDetails.getId()),
                "FPO membership approved"
        ));
    }

    @PostMapping("/{fpoId}/listings")
    public ResponseEntity<ApiResponse<FpoListing>> createFpoListing(@PathVariable Long fpoId,
                                                                    @RequestBody FpoListingDto dto,
                                                                    Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        return ResponseEntity.ok(ApiResponse.success(
                fpoService.createFpoListing(dto, fpoId, userDetails.getId()),
                "FPO listing created successfully"
        ));
    }

    @GetMapping("/listings")
    public ResponseEntity<ApiResponse<List<FpoListingResponseDto>>> getFpoListingsForBuyer() {
        return ResponseEntity.ok(ApiResponse.success(
                fpoService.getFpoListingsForBuyer(),
                "FPO listings retrieved"
        ));
    }
}

@Controller
@RequestMapping("/web/farmer/fpo")
class FpoWebController {

    @Autowired
    private FpoService fpoService;

    @GetMapping("/dashboard")
    public ModelAndView dashboard(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        ModelAndView mav = new ModelAndView("farmer-fpo-dashboard");
        mav.addObject("groupsLed", fpoService.getGroupsLedByUser(userDetails.getId()));
        mav.addObject("memberships", fpoService.getMembershipsForUser(userDetails.getId()));
        mav.addObject("pendingApprovals", fpoService.getPendingApprovalsForLeader(userDetails.getId()));
        mav.addObject("buyerFacingListings", fpoService.getFpoListingsForBuyer());
        return mav;
    }

    @PostMapping("/groups")
    public String createGroup(FpoGroupDto dto, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        fpoService.createFpoGroup(dto, userDetails.getId());
        return "redirect:/web/farmer/fpo/dashboard";
    }

    @PostMapping("/{fpoId}/join")
    public String join(@PathVariable Long fpoId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        fpoService.joinFpo(fpoId, userDetails.getId());
        return "redirect:/web/farmer/fpo/dashboard";
    }

    @PostMapping("/memberships/{membershipId}/approve")
    public String approve(@PathVariable Long membershipId, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        fpoService.approveMembership(membershipId, userDetails.getId());
        return "redirect:/web/farmer/fpo/dashboard";
    }

    @PostMapping("/{fpoId}/listings")
    public String createListing(@PathVariable Long fpoId, FpoListingDto dto, Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        fpoService.createFpoListing(dto, fpoId, userDetails.getId());
        return "redirect:/web/farmer/fpo/dashboard";
    }
}
