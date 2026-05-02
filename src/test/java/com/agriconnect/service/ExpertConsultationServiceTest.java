package com.agriconnect.service;

import com.agriconnect.dao.BookingSlotDao;
import com.agriconnect.dao.ConsultationReviewDao;
import com.agriconnect.dao.ExpertConsultationDao;
import com.agriconnect.dao.ExpertWalletTransactionDao;
import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.NotificationDao;
import com.agriconnect.dao.UserDao;
import com.agriconnect.dto.ConsultationBookingRequestDto;
import com.agriconnect.dto.ConsultationBookingResponseDto;
import com.agriconnect.dto.ConsultationReviewDto;
import com.agriconnect.model.BookingSlot;
import com.agriconnect.model.ConsultationReview;
import com.agriconnect.model.ExpertConsultation;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class ExpertConsultationServiceTest {

    @Mock
    private UserDao userDao;
    @Mock
    private FarmerProfileDao farmerProfileDao;
    @Mock
    private BookingSlotDao bookingSlotDao;
    @Mock
    private ExpertConsultationDao expertConsultationDao;
    @Mock
    private ConsultationReviewDao consultationReviewDao;
    @Mock
    private ExpertWalletTransactionDao expertWalletTransactionDao;
    @Mock
    private NotificationDao notificationDao;
    @Mock
    private RazorpayOrderService razorpayOrderService;

    @InjectMocks
    private ExpertConsultationService expertConsultationService;

    private User expert;
    private FarmerProfile farmer;
    private BookingSlot slot;

    @BeforeEach
    void setUp() {
        expert = new User();
        expert.setId(9L);
        expert.setRole(User.Role.AGRI_EXPERT);
        expert.setVerificationStatus(User.VerificationStatus.VERIFIED);
        expert.setName("Expert");
        expert.setConsultationFee30min(new BigDecimal("499.00"));
        expert.setConsultationFee60min(new BigDecimal("899.00"));
        expert.setTotalSessions(3);

        User farmerUser = new User();
        farmerUser.setId(1L);
        farmerUser.setName("Farmer");
        farmerUser.setVerificationStatus(User.VerificationStatus.VERIFIED);

        farmer = new FarmerProfile();
        farmer.setId(1L);
        farmer.setUser(farmerUser);
        farmer.setDistrict("Kangra");

        slot = new BookingSlot();
        slot.setId(11L);
        slot.setProvider(expert);
        slot.setSlotDate(LocalDate.now().plusDays(1));
        slot.setStartTime(LocalTime.of(10, 0));
        slot.setEndTime(LocalTime.of(10, 30));
        slot.setDistrict("Kangra");
        slot.setCropFocus("Wheat");
        slot.setSlotStatus(BookingSlot.SlotStatus.OPEN);
    }

    @Test
    void bookConsultation_locksSlotAndCreatesRazorpayReference() {
        ConsultationBookingRequestDto dto = new ConsultationBookingRequestDto();
        dto.setExpertId(9L);
        dto.setSlotId(11L);
        dto.setCrop("Wheat");
        dto.setDistrict("Kangra");
        dto.setDuration(30);

        when(userDao.findVerifiedExpertById(9L)).thenReturn(Optional.of(expert));
        when(farmerProfileDao.findByUserId(1L)).thenReturn(Optional.of(farmer));
        when(bookingSlotDao.findOpenSlotById(11L)).thenReturn(Optional.of(slot));
        when(razorpayOrderService.createConsultationOrder(eq(new BigDecimal("499.00")), anyString()))
                .thenReturn("order_123");

        ConsultationBookingResponseDto response = expertConsultationService.bookConsultation(dto, 1L);

        assertThat(response.getRazorpayOrderId()).isEqualTo("order_123");
        assertThat(slot.getSlotStatus()).isEqualTo(BookingSlot.SlotStatus.BOOKED);
        verify(expertConsultationDao, times(1)).save(any(ExpertConsultation.class));
        verify(bookingSlotDao, times(1)).update(slot);
        verify(notificationDao, times(2)).save(any());
    }

    @Test
    void completeSession_creditsWalletAndRequestsReview() {
        ExpertConsultation consultation = new ExpertConsultation();
        consultation.setId(42L);
        consultation.setExpert(expert);
        consultation.setFarmer(farmer);
        consultation.setSlot(slot);
        consultation.setCropFocus("Wheat");
        consultation.setFarmerDistrict("Kangra");
        consultation.setFeeAmount(new BigDecimal("499.00"));
        consultation.setDurationMinutes(30);
        consultation.setConsultationStatus(ExpertConsultation.ConsultationStatus.BOOKED);
        consultation.setPaymentStatus(ExpertConsultation.PaymentStatus.PAID);

        when(expertConsultationDao.findDetailedById(42L)).thenReturn(Optional.of(consultation));
        when(expertWalletTransactionDao.existsByConsultation(42L)).thenReturn(false);

        ConsultationBookingResponseDto response = expertConsultationService.completeSession(42L, 9L);

        assertThat(response.getConsultationStatus()).isEqualTo("COMPLETED");
        assertThat(consultation.getReviewRequested()).isTrue();
        verify(expertWalletTransactionDao, times(1)).save(any());
        verify(userDao, times(1)).update(expert);
    }

    @Test
    void submitReview_updatesExpertAverageRating() {
        ExpertConsultation consultation = new ExpertConsultation();
        consultation.setId(50L);
        consultation.setExpert(expert);
        consultation.setFarmer(farmer);
        consultation.setConsultationStatus(ExpertConsultation.ConsultationStatus.COMPLETED);

        ConsultationReviewDto dto = new ConsultationReviewDto();
        dto.setRating(5);
        dto.setReviewText("Very useful");

        when(expertConsultationDao.findDetailedById(50L)).thenReturn(Optional.of(consultation));
        when(consultationReviewDao.findByConsultationId(50L)).thenReturn(Optional.empty());
        when(consultationReviewDao.getAverageRatingForExpert(9L)).thenReturn(new BigDecimal("4.75"));

        ConsultationReview review = expertConsultationService.submitReview(50L, 1L, dto);

        assertThat(review.getRating()).isEqualTo(5);
        assertThat(expert.getAvgRating()).isEqualByComparingTo("4.75");
        verify(consultationReviewDao, times(1)).save(any(ConsultationReview.class));
        verify(userDao, times(1)).update(expert);
        verify(expertWalletTransactionDao, never()).save(any());
    }
}
