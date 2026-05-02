package com.agriconnect.service;

import com.agriconnect.dao.BookingSlotDao;
import com.agriconnect.dao.ConsultationReviewDao;
import com.agriconnect.dao.ExpertConsultationDao;
import com.agriconnect.dao.ExpertWalletTransactionDao;
import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.NotificationDao;
import com.agriconnect.dao.UserDao;
import com.agriconnect.dto.BookingSlotDto;
import com.agriconnect.dto.ConsultationBookingRequestDto;
import com.agriconnect.dto.ConsultationBookingResponseDto;
import com.agriconnect.dto.ConsultationReviewDto;
import com.agriconnect.dto.ExpertAvailabilityDto;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.exception.ResourceNotFoundException;
import com.agriconnect.model.BookingSlot;
import com.agriconnect.model.ConsultationReview;
import com.agriconnect.model.ExpertConsultation;
import com.agriconnect.model.ExpertWalletTransaction;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.Notification;
import com.agriconnect.model.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.regex.Pattern;

@Service
@Transactional
public class ExpertConsultationService {

    private static final Logger log = LoggerFactory.getLogger(ExpertConsultationService.class);
    private static final Pattern GOOGLE_MEET_PATTERN = Pattern.compile("^https://meet\\.google\\.com/[a-z]{3}-[a-z]{4}-[a-z]{3}(\\?.*)?$");
    private static final BigDecimal PLATFORM_FEE_RATE = new BigDecimal("0.10");

    @Autowired
    private UserDao userDao;

    @Autowired
    private FarmerProfileDao farmerProfileDao;

    @Autowired
    private BookingSlotDao bookingSlotDao;

    @Autowired
    private ExpertConsultationDao expertConsultationDao;

    @Autowired
    private ConsultationReviewDao consultationReviewDao;

    @Autowired
    private ExpertWalletTransactionDao expertWalletTransactionDao;

    @Autowired
    private NotificationDao notificationDao;

    @Autowired
    private RazorpayOrderService razorpayOrderService;

    @PreAuthorize("hasRole('AGRI_EXPERT') and #expertUserId == authentication.principal.id")
    public BookingSlot createAvailabilitySlot(BookingSlotDto dto, Long expertUserId) {
        User expert = userDao.findVerifiedExpertById(expertUserId)
                .orElseThrow(() -> new BusinessValidationException("Only verified agricultural experts can publish slots"));
        validateSlotWindow(dto.getStartTime(), dto.getEndTime());

        BookingSlot slot = new BookingSlot();
        slot.setProvider(expert);
        slot.setSlotDate(dto.getSlotDate());
        slot.setStartTime(dto.getStartTime());
        slot.setEndTime(dto.getEndTime());
        slot.setDistrict(dto.getDistrict().trim());
        slot.setCropFocus(dto.getCropFocus().trim());
        slot.setNotes(dto.getNotes());
        slot.setSlotStatus(BookingSlot.SlotStatus.OPEN);
        bookingSlotDao.save(slot);
        return slot;
    }

    @PreAuthorize("hasRole('AGRI_EXPERT') and #expertUserId == authentication.principal.id")
    public BookingSlot blockSlot(Long slotId, Long expertUserId) {
        BookingSlot slot = bookingSlotDao.findById(slotId)
                .orElseThrow(() -> new ResourceNotFoundException("Slot not found"));
        if (!slot.getProvider().getId().equals(expertUserId)) {
            throw new BusinessValidationException("You do not own this slot");
        }
        slot.setSlotStatus(BookingSlot.SlotStatus.BLOCKED);
        bookingSlotDao.update(slot);
        return slot;
    }

    @Transactional(readOnly = true)
    public List<ExpertAvailabilityDto> getAvailableExperts(String crop, String district, LocalDate date) {
        return bookingSlotDao.findAvailableSlots(crop, district, date == null ? LocalDate.now() : date).stream()
                .map(slot -> new ExpertAvailabilityDto(slot.getProvider(), slot))
                .toList();
    }

    @PreAuthorize("hasRole('FARMER') and #farmerUserId == authentication.principal.id")
    public ConsultationBookingResponseDto bookConsultation(ConsultationBookingRequestDto dto, Long farmerUserId) {
        User expert = userDao.findVerifiedExpertById(dto.getExpertId())
                .orElseThrow(() -> new ResourceNotFoundException("Expert not found"));
        FarmerProfile farmer = farmerProfileDao.findByUserId(farmerUserId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        if (farmer.getUser() != null && farmer.getUser().getVerificationStatus() != User.VerificationStatus.VERIFIED) {
            throw new BusinessValidationException("Only verified farmers can book expert consultations");
        }

        BookingSlot slot = bookingSlotDao.findOpenSlotById(dto.getSlotId())
                .orElseThrow(() -> new ResourceNotFoundException("Slot not found"));
        if (!slot.getProvider().getId().equals(expert.getId())) {
            throw new BusinessValidationException("Slot does not belong to the selected expert");
        }
        if (slot.getSlotStatus() != BookingSlot.SlotStatus.OPEN) {
            throw new BusinessValidationException("Selected slot is no longer available");
        }
        if (slot.getSlotDate().isBefore(LocalDate.now())) {
            throw new BusinessValidationException("Cannot book an expired consultation slot");
        }

        BigDecimal feeAmount = resolveFee(expert, dto.getDuration());
        String receipt = "consult_" + expert.getId() + "_" + farmer.getId() + "_" + System.currentTimeMillis();
        String razorpayOrderId = razorpayOrderService.createConsultationOrder(feeAmount, receipt);

        ExpertConsultation consultation = new ExpertConsultation();
        consultation.setExpert(expert);
        consultation.setFarmer(farmer);
        consultation.setSlot(slot);
        consultation.setCropFocus(dto.getCrop().trim());
        consultation.setFarmerDistrict(dto.getDistrict().trim());
        consultation.setDurationMinutes(dto.getDuration());
        consultation.setFeeAmount(feeAmount);
        consultation.setConsultationStatus(ExpertConsultation.ConsultationStatus.BOOKED);
        consultation.setPaymentStatus(ExpertConsultation.PaymentStatus.PAID);
        consultation.setRazorpayOrderId(razorpayOrderId);
        consultation.setRazorpayPaymentId(razorpayOrderId.startsWith("offline_") ? razorpayOrderId : null);
        expertConsultationDao.save(consultation);

        slot.setSlotStatus(BookingSlot.SlotStatus.BOOKED);
        bookingSlotDao.update(slot);

        notifyUser(expert, "New Consultation Booked",
                "A farmer booked your " + dto.getDuration() + "-minute consultation slot for " + dto.getCrop() + ".");
        notifyUser(farmer.getUser(), "Consultation Confirmed",
                "Your expert consultation is confirmed. Payment reference: " + razorpayOrderId + ".");

        return new ConsultationBookingResponseDto(consultation);
    }

    @PreAuthorize("hasRole('AGRI_EXPERT') and #expertUserId == authentication.principal.id")
    public ConsultationBookingResponseDto addSessionLink(Long bookingId, Long expertUserId, String sessionLink) {
        ExpertConsultation consultation = expertConsultationDao.findDetailedById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Consultation booking not found"));
        if (!consultation.getExpert().getId().equals(expertUserId)) {
            throw new BusinessValidationException("You do not own this consultation");
        }
        if (!GOOGLE_MEET_PATTERN.matcher(sessionLink.trim()).matches()) {
            throw new BusinessValidationException("Session link must be a valid Google Meet URL");
        }

        consultation.setSessionLink(sessionLink.trim());
        expertConsultationDao.update(consultation);

        notifyUser(consultation.getFarmer().getUser(), "Session Link Added",
                "Your expert consultation now has a Google Meet link ready to join.");
        return new ConsultationBookingResponseDto(consultation);
    }

    @PreAuthorize("hasRole('AGRI_EXPERT') and #expertUserId == authentication.principal.id")
    public ConsultationBookingResponseDto completeSession(Long bookingId, Long expertUserId) {
        ExpertConsultation consultation = expertConsultationDao.findDetailedById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Consultation booking not found"));
        if (!consultation.getExpert().getId().equals(expertUserId)) {
            throw new BusinessValidationException("You do not own this consultation");
        }
        if (consultation.getConsultationStatus() == ExpertConsultation.ConsultationStatus.COMPLETED) {
            return new ConsultationBookingResponseDto(consultation);
        }

        consultation.setConsultationStatus(ExpertConsultation.ConsultationStatus.COMPLETED);
        consultation.setCompletedAt(LocalDateTime.now());
        consultation.setReviewRequested(true);
        expertConsultationDao.update(consultation);

        creditExpertWallet(consultation);

        User expert = consultation.getExpert();
        expert.setTotalSessions((expert.getTotalSessions() == null ? 0 : expert.getTotalSessions()) + 1);
        userDao.update(expert);

        notifyUser(consultation.getFarmer().getUser(), "Review Your Expert Session",
                "Your consultation is complete. Please rate the expert and share feedback.");
        return new ConsultationBookingResponseDto(consultation);
    }

    @PreAuthorize("hasRole('FARMER') and #farmerUserId == authentication.principal.id")
    public ConsultationReview submitReview(Long bookingId, Long farmerUserId, ConsultationReviewDto dto) {
        ExpertConsultation consultation = expertConsultationDao.findDetailedById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Consultation booking not found"));
        if (!consultation.getFarmer().getUser().getId().equals(farmerUserId)) {
            throw new BusinessValidationException("You can only review your own consultations");
        }
        if (consultation.getConsultationStatus() != ExpertConsultation.ConsultationStatus.COMPLETED) {
            throw new BusinessValidationException("Only completed consultations can be reviewed");
        }
        consultationReviewDao.findByConsultationId(bookingId).ifPresent(existing -> {
            throw new BusinessValidationException("Review already submitted for this consultation");
        });

        ConsultationReview review = new ConsultationReview();
        review.setConsultation(consultation);
        review.setRating(dto.getRating());
        review.setReviewText(dto.getReviewText());
        consultationReviewDao.save(review);

        BigDecimal average = consultationReviewDao.getAverageRatingForExpert(consultation.getExpert().getId())
                .setScale(2, RoundingMode.HALF_UP);
        User expert = consultation.getExpert();
        expert.setAvgRating(average);
        userDao.update(expert);
        return review;
    }

    @Transactional(readOnly = true)
    @PreAuthorize("hasRole('AGRI_EXPERT') and #expertUserId == authentication.principal.id")
    public List<ExpertConsultation> getBookingsForExpert(Long expertUserId) {
        return expertConsultationDao.findByExpert(expertUserId);
    }

    @Transactional(readOnly = true)
    @PreAuthorize("hasRole('AGRI_EXPERT') and #expertUserId == authentication.principal.id")
    public List<BookingSlot> getSlotsForExpert(Long expertUserId) {
        return bookingSlotDao.findByProvider(expertUserId);
    }

    @Transactional(readOnly = true)
    @PreAuthorize("(hasRole('AGRI_EXPERT') and #userId == authentication.principal.id) or (hasRole('FARMER') and #userId == authentication.principal.id)")
    public ExpertConsultation getConsultationDetail(Long consultationId, Long userId) {
        ExpertConsultation consultation = expertConsultationDao.findDetailedById(consultationId)
                .orElseThrow(() -> new ResourceNotFoundException("Consultation booking not found"));
        boolean isExpert = consultation.getExpert().getId().equals(userId);
        boolean isFarmer = consultation.getFarmer().getUser().getId().equals(userId);
        if (!isExpert && !isFarmer) {
            throw new BusinessValidationException("You do not have access to this consultation");
        }
        return consultation;
    }

    @Transactional(readOnly = true)
    @PreAuthorize("hasRole('FARMER') and #farmerUserId == authentication.principal.id")
    public List<ExpertConsultation> getConsultationsForFarmer(Long farmerUserId) {
        return expertConsultationDao.findByFarmerUser(farmerUserId);
    }

    @Transactional(readOnly = true)
    @PreAuthorize("hasRole('AGRI_EXPERT') and #expertUserId == authentication.principal.id")
    public List<ExpertWalletTransaction> getWalletTransactionsForExpert(Long expertUserId) {
        return expertWalletTransactionDao.findByExpert(expertUserId);
    }

    @Scheduled(cron = "0 */15 * * * ?")
    public void sendSessionReminders() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime oneHourAhead = now.plusHours(1);
        List<ExpertConsultation> consultations = expertConsultationDao.findPendingReminders(now, oneHourAhead);
        for (ExpertConsultation consultation : consultations) {
            String linkText = consultation.getSessionLink() == null ? "Session link will be shared shortly." : consultation.getSessionLink();
            notifyUser(consultation.getExpert(), "Consultation Reminder",
                    "Your session with " + consultation.getFarmer().getUser().getName() + " starts within 1 hour. " + linkText);
            notifyUser(consultation.getFarmer().getUser(), "Consultation Reminder",
                    "Your session with expert " + consultation.getExpert().getName() + " starts within 1 hour. " + linkText);
            consultation.setReminderSent(true);
            expertConsultationDao.update(consultation);
        }
        if (!consultations.isEmpty()) {
            log.info("Sent {} expert consultation reminders", consultations.size());
        }
    }

    private void validateSlotWindow(LocalTime startTime, LocalTime endTime) {
        if (startTime == null || endTime == null || !endTime.isAfter(startTime)) {
            throw new BusinessValidationException("End time must be after start time");
        }
    }

    private BigDecimal resolveFee(User expert, Integer duration) {
        if (duration == null) {
            throw new BusinessValidationException("Consultation duration is required");
        }
        if (duration <= 30) {
            if (expert.getConsultationFee30min() == null) {
                throw new BusinessValidationException("Expert has not configured a 30-minute consultation fee");
            }
            return expert.getConsultationFee30min();
        }
        if (duration <= 60) {
            if (expert.getConsultationFee60min() == null) {
                throw new BusinessValidationException("Expert has not configured a 60-minute consultation fee");
            }
            return expert.getConsultationFee60min();
        }
        throw new BusinessValidationException("Only 30 or 60 minute consultations are supported");
    }

    private void creditExpertWallet(ExpertConsultation consultation) {
        if (expertWalletTransactionDao.existsByConsultation(consultation.getId())) {
            return;
        }
        BigDecimal gross = consultation.getFeeAmount().setScale(2, RoundingMode.HALF_UP);
        BigDecimal platformFee = gross.multiply(PLATFORM_FEE_RATE).setScale(2, RoundingMode.HALF_UP);
        BigDecimal net = gross.subtract(platformFee);

        ExpertWalletTransaction transaction = new ExpertWalletTransaction();
        transaction.setExpert(consultation.getExpert());
        transaction.setConsultation(consultation);
        transaction.setTransactionType(ExpertWalletTransaction.TransactionType.CREDIT);
        transaction.setGrossAmount(gross);
        transaction.setPlatformFee(platformFee);
        transaction.setNetAmount(net);
        expertWalletTransactionDao.save(transaction);

        notifyUser(consultation.getExpert(), "Consultation Earnings Credited",
                "Your wallet has been credited with Rs " + net + " for the completed session.");
    }

    private void notifyUser(User user, String title, String body) {
        if (user == null) {
            return;
        }
        Notification notification = new Notification();
        notification.setUser(user);
        notification.setTitle(title);
        notification.setBody(body);
        notification.setType("CONSULTATION");
        notificationDao.save(notification);
    }
}
