package com.agriconnect.service;

import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.FpoGroupDao;
import com.agriconnect.dao.FpoListingDao;
import com.agriconnect.dao.FpoMembershipDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dto.FpoGroupDto;
import com.agriconnect.dto.FpoListingDto;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.FpoGroup;
import com.agriconnect.model.FpoMembership;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class FpoServiceTest {

    @Mock
    private FpoGroupDao fpoGroupDao;
    @Mock
    private FpoMembershipDao fpoMembershipDao;
    @Mock
    private FpoListingDao fpoListingDao;
    @Mock
    private FarmerProfileDao farmerProfileDao;
    @Mock
    private ProduceListingDao produceListingDao;

    @InjectMocks
    private FpoService fpoService;

    private FarmerProfile verifiedFarmer;

    @BeforeEach
    void setUp() {
        User user = new User();
        user.setId(1L);
        user.setVerificationStatus(User.VerificationStatus.VERIFIED);
        user.setName("Leader Farmer");

        verifiedFarmer = new FarmerProfile();
        verifiedFarmer.setId(10L);
        verifiedFarmer.setUser(user);
        verifiedFarmer.setDistrict("Nashik");
        verifiedFarmer.setState("Maharashtra");
    }

    @Test
    void createFpoGroupCreatesLeaderMembership() {
        FpoGroupDto dto = new FpoGroupDto();
        dto.setGroupName("Nashik Onion Collective");
        dto.setDistrict("Nashik");
        dto.setState("Maharashtra");
        dto.setRegistrationNumber("FPO-1001");

        when(farmerProfileDao.findByUserId(1L)).thenReturn(Optional.of(verifiedFarmer));
        when(fpoGroupDao.findByRegistrationNumber("FPO-1001")).thenReturn(Optional.empty());

        FpoGroup group = fpoService.createFpoGroup(dto, 1L);

        assertThat(group.getGroupName()).isEqualTo("Nashik Onion Collective");
        assertThat(group.getTotalMembers()).isEqualTo(1);
        verify(fpoGroupDao).save(any(FpoGroup.class));
        verify(fpoMembershipDao).save(any(FpoMembership.class));
    }

    @Test
    void approveMembershipActivatesMembershipAndIncrementsCount() {
        FpoGroup group = new FpoGroup();
        group.setLeaderFarmer(verifiedFarmer);
        group.setTotalMembers(1);

        FpoMembership membership = new FpoMembership();
        membership.setId(99L);
        membership.setFpoGroup(group);
        membership.setFarmer(verifiedFarmer);
        membership.setIsActive(Boolean.FALSE);

        when(farmerProfileDao.findByUserId(1L)).thenReturn(Optional.of(verifiedFarmer));
        when(fpoMembershipDao.findById(99L)).thenReturn(Optional.of(membership));

        FpoMembership approved = fpoService.approveMembership(99L, 1L);

        assertThat(approved.getIsActive()).isTrue();
        assertThat(group.getTotalMembers()).isEqualTo(2);
        verify(fpoMembershipDao).update(membership);
        verify(fpoGroupDao).update(group);
    }

    @Test
    void createFpoListingAggregatesMemberInventory() {
        FpoGroup group = new FpoGroup();
        group.setId(50L);
        group.setLeaderFarmer(verifiedFarmer);

        FpoMembership membership = new FpoMembership();
        membership.setFarmer(verifiedFarmer);
        membership.setIsActive(Boolean.TRUE);

        ProduceListing listing1 = new ProduceListing();
        listing1.setQuantityKg(new BigDecimal("500.00"));
        ProduceListing listing2 = new ProduceListing();
        listing2.setQuantityKg(new BigDecimal("250.00"));

        FpoListingDto dto = new FpoListingDto();
        dto.setCropName("Onion");
        dto.setMinPricePerKg(new BigDecimal("18.00"));
        dto.setQualityGrade("A");
        dto.setPoolingDeadline(LocalDate.now().plusDays(3));

        when(farmerProfileDao.findByUserId(1L)).thenReturn(Optional.of(verifiedFarmer));
        when(fpoGroupDao.findById(50L)).thenReturn(Optional.of(group));
        when(fpoMembershipDao.findActiveByFpo(50L)).thenReturn(List.of(membership));
        when(produceListingDao.findActiveListingsByFarmersAndCrop(List.of(10L), "Onion")).thenReturn(List.of(listing1, listing2));

        var fpoListing = fpoService.createFpoListing(dto, 50L, 1L);

        assertThat(fpoListing.getTotalQuantityKg()).isEqualByComparingTo("750.00");
        verify(fpoListingDao).save(any());
    }
}
