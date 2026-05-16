package com.agriconnect.controller;

import com.agriconnect.dao.AdvisoryDao;
import com.agriconnect.dto.ApiResponse;
import com.agriconnect.dto.BookingSlotDto;
import com.agriconnect.dto.ConsultationBookingRequestDto;
import com.agriconnect.dto.ConsultationBookingResponseDto;
import com.agriconnect.dto.ConsultationReviewDto;
import com.agriconnect.dto.ExpertAvailabilityDto;
import com.agriconnect.dto.SessionLinkDto;
import com.agriconnect.model.BookingSlot;
import com.agriconnect.model.ExpertConsultation;
import com.agriconnect.model.ExpertWalletTransaction;
import com.agriconnect.security.CustomUserDetails;
import com.agriconnect.service.ExpertConsultationService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@org.springframework.web.bind.annotation.RestController
@RequestMapping("/api/v1/consultations")
class ExpertConsultationRestController {

    @Autowired
    private ExpertConsultationService expertConsultationService;

    @GetMapping("/experts")
    public ResponseEntity<ApiResponse<List<ExpertAvailabilityDto>>> getAvailableExperts(
            @RequestParam(required = false) String crop,
            @RequestParam(required = false) String district,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return ResponseEntity.ok(ApiResponse.success(
                expertConsultationService.getAvailableExperts(crop, district, date),
                "Available experts fetched"));
    }

    @PostMapping("/book")
    public ResponseEntity<ApiResponse<ConsultationBookingResponseDto>> bookConsultation(
            @Valid @RequestBody ConsultationBookingRequestDto dto,
            Authentication authentication) {
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        return ResponseEntity.ok(ApiResponse.success(
                expertConsultationService.bookConsultation(dto, userId),
                "Consultation booked successfully"));
    }

    @PutMapping("/{bookingId}/session-link")
    public ResponseEntity<ApiResponse<ConsultationBookingResponseDto>> addSessionLink(
            @PathVariable Long bookingId,
            @Valid @RequestBody SessionLinkDto dto,
            Authentication authentication) {
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        return ResponseEntity.ok(ApiResponse.success(
                expertConsultationService.addSessionLink(bookingId, userId, dto.getSessionLink()),
                "Session link added"));
    }

    @PutMapping("/{bookingId}/complete")
    public ResponseEntity<ApiResponse<ConsultationBookingResponseDto>> completeSession(
            @PathVariable Long bookingId,
            Authentication authentication) {
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        return ResponseEntity.ok(ApiResponse.success(
                expertConsultationService.completeSession(bookingId, userId),
                "Consultation marked complete"));
    }

    @PostMapping("/{bookingId}/review")
    public ResponseEntity<ApiResponse<Void>> reviewConsultation(
            @PathVariable Long bookingId,
            @Valid @RequestBody ConsultationReviewDto dto,
            Authentication authentication) {
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        expertConsultationService.submitReview(bookingId, userId, dto);
        return ResponseEntity.ok(ApiResponse.success(null, "Review submitted"));
    }
}

@org.springframework.web.bind.annotation.RestController
@RequestMapping("/api/v1/expert/slots")
class ExpertSlotRestController {

    @Autowired
    private ExpertConsultationService expertConsultationService;

    @Autowired
    private AdvisoryDao advisoryDao;

    @PostMapping
    public ResponseEntity<ApiResponse<BookingSlot>> createSlot(@Valid @RequestBody BookingSlotDto dto,
                                                               Authentication authentication) {
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        return ResponseEntity.ok(ApiResponse.success(
                expertConsultationService.createAvailabilitySlot(dto, userId),
                "Slot created"));
    }

    @PutMapping("/{slotId}/block")
    public ResponseEntity<ApiResponse<BookingSlot>> blockSlot(@PathVariable Long slotId,
                                                              Authentication authentication) {
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        return ResponseEntity.ok(ApiResponse.success(
                expertConsultationService.blockSlot(slotId, userId),
                "Slot blocked"));
    }
}

@Controller
class ExpertConsultationWebController {

    @Autowired
    private ExpertConsultationService expertConsultationService;

    @Autowired
    private AdvisoryDao advisoryDao;

    @GetMapping("/web/farmer/consultations")
    public ModelAndView farmerConsultations(Authentication authentication,
                                            @RequestParam(required = false) String crop,
                                            @RequestParam(required = false) String district,
                                            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        ModelAndView mav = new ModelAndView("farmer-consultations");
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        LocalDate searchDate = date != null ? date : LocalDate.now().plusDays(1);
        List<ExpertAvailabilityDto> experts = expertConsultationService.getAvailableExperts(crop, district, searchDate);
        List<ExpertConsultation> bookings = expertConsultationService.getConsultationsForFarmer(userId);
        mav.addObject("availableExperts", experts);
        mav.addObject("consultationBookings", bookings);
        mav.addObject("searchDate", searchDate);
        mav.addObject("selectedCrop", crop);
        mav.addObject("selectedDistrict", district);
        return mav;
    }

    @GetMapping("/web/expert/dashboard")
    public String expertDashboard(Authentication authentication, Model model) {
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        List<ExpertConsultation> bookings = expertConsultationService.getBookingsForExpert(userId);
        List<ExpertWalletTransaction> walletTransactions = expertConsultationService.getWalletTransactionsForExpert(userId);
        BigDecimal totalEarnings = walletTransactions.stream()
                .map(ExpertWalletTransaction::getNetAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        long upcomingCount = bookings.stream()
                .filter(b -> b.getConsultationStatus() == ExpertConsultation.ConsultationStatus.BOOKED)
                .count();
        model.addAttribute("bookings", bookings);
        model.addAttribute("walletTransactions", walletTransactions);
        model.addAttribute("totalEarnings", totalEarnings);
        model.addAttribute("upcomingCount", upcomingCount);
        model.addAttribute("advisories", advisoryDao.findAll());
        return "expert/dashboard";
    }

    @GetMapping("/web/expert/slots")
    public String expertSlots(Authentication authentication, Model model) {
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        model.addAttribute("slots", expertConsultationService.getSlotsForExpert(userId));
        return "expert-slots";
    }

    @GetMapping("/web/expert/sessions/{id}")
    public String expertSessionDetail(@PathVariable Long id, Authentication authentication, Model model) {
        Long userId = ((CustomUserDetails) authentication.getPrincipal()).getId();
        model.addAttribute("consultation", expertConsultationService.getConsultationDetail(id, userId));
        return "expert-session-detail";
    }
}
