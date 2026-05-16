package com.agriconnect.service;

import com.agriconnect.dao.FarmerProfileDao;
import com.agriconnect.dao.FpoGroupDao;
import com.agriconnect.dao.FpoListingDao;
import com.agriconnect.dao.FpoMembershipDao;
import com.agriconnect.dao.ProduceListingDao;
import com.agriconnect.dto.FpoGroupDto;
import com.agriconnect.dto.FpoListingDto;
import com.agriconnect.dto.FpoListingResponseDto;
import com.agriconnect.exception.BusinessValidationException;
import com.agriconnect.exception.ResourceNotFoundException;
import com.agriconnect.model.FarmerProfile;
import com.agriconnect.model.FpoGroup;
import com.agriconnect.model.FpoListing;
import com.agriconnect.model.FpoMembership;
import com.agriconnect.model.ProduceListing;
import com.agriconnect.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Service
@Transactional
public class FpoService {

    @Autowired
    private FpoGroupDao fpoGroupDao;

    @Autowired
    private FpoMembershipDao fpoMembershipDao;

    @Autowired
    private FpoListingDao fpoListingDao;

    @Autowired
    private FarmerProfileDao farmerProfileDao;

    @Autowired
    private ProduceListingDao produceListingDao;

    @PreAuthorize("hasRole('FARMER') and #leaderUserId == authentication.principal.id")
    public FpoGroup createFpoGroup(FpoGroupDto dto, Long leaderUserId) {
        FarmerProfile leader = loadVerifiedFarmer(leaderUserId);
        if (fpoGroupDao.findByRegistrationNumber(dto.getRegistrationNumber()).isPresent()) {
            throw new BusinessValidationException("An FPO with this registration number already exists");
        }

        FpoGroup group = new FpoGroup();
        group.setGroupName(dto.getGroupName());
        group.setLeaderFarmer(leader);
        group.setDistrict(dto.getDistrict() != null ? dto.getDistrict() : leader.getDistrict());
        group.setState(dto.getState() != null ? dto.getState() : leader.getState());
        group.setRegistrationNumber(dto.getRegistrationNumber());
        group.setIsVerified(Boolean.TRUE);
        group.setTotalMembers(1);
        fpoGroupDao.save(group);

        FpoMembership leaderMembership = new FpoMembership();
        leaderMembership.setFpoGroup(group);
        leaderMembership.setFarmer(leader);
        leaderMembership.setIsActive(Boolean.TRUE);
        fpoMembershipDao.save(leaderMembership);
        return group;
    }

    @PreAuthorize("hasRole('FARMER') and #farmerUserId == authentication.principal.id")
    public FpoMembership joinFpo(Long fpoId, Long farmerUserId) {
        FarmerProfile farmer = farmerProfileDao.findByUserId(farmerUserId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        FpoGroup group = fpoGroupDao.findById(fpoId)
                .orElseThrow(() -> new ResourceNotFoundException("FPO group not found"));

        FpoMembership existing = fpoMembershipDao.findByFpoAndFarmer(fpoId, farmer.getId()).orElse(null);
        if (existing != null) {
            return existing;
        }

        FpoMembership membership = new FpoMembership();
        membership.setFpoGroup(group);
        membership.setFarmer(farmer);
        membership.setIsActive(Boolean.FALSE);
        fpoMembershipDao.save(membership);
        return membership;
    }

    @PreAuthorize("hasRole('FARMER') and #leaderUserId == authentication.principal.id")
    public FpoMembership approveMembership(Long membershipId, Long leaderUserId) {
        FarmerProfile leader = farmerProfileDao.findByUserId(leaderUserId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        FpoMembership membership = fpoMembershipDao.findById(membershipId)
                .orElseThrow(() -> new ResourceNotFoundException("Membership not found"));

        if (!membership.getFpoGroup().getLeaderFarmer().getId().equals(leader.getId())) {
            throw new BusinessValidationException("Only the FPO leader can approve members");
        }

        membership.setIsActive(Boolean.TRUE);
        fpoMembershipDao.update(membership);

        FpoGroup group = membership.getFpoGroup();
        group.setTotalMembers(group.getTotalMembers() == null ? 1 : group.getTotalMembers() + 1);
        fpoGroupDao.update(group);
        return membership;
    }

    @PreAuthorize("hasRole('FARMER') and #leaderUserId == authentication.principal.id")
    public FpoListing createFpoListing(FpoListingDto dto, Long fpoId, Long leaderUserId) {
        FarmerProfile leader = farmerProfileDao.findByUserId(leaderUserId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        FpoGroup group = fpoGroupDao.findById(fpoId)
                .orElseThrow(() -> new ResourceNotFoundException("FPO group not found"));

        if (!group.getLeaderFarmer().getId().equals(leader.getId())) {
            throw new BusinessValidationException("Only the FPO leader can create collective listings");
        }
        if (dto.getPoolingDeadline() == null || dto.getPoolingDeadline().isBefore(LocalDate.now())) {
            throw new BusinessValidationException("Pooling deadline must be today or later");
        }

        List<Long> memberFarmerIds = fpoMembershipDao.findActiveByFpo(fpoId).stream()
                .map(membership -> membership.getFarmer().getId())
                .toList();
        if (memberFarmerIds.isEmpty()) {
            throw new BusinessValidationException("No active FPO members found for pooling");
        }

        BigDecimal totalQuantity = produceListingDao.findActiveListingsByFarmersAndCrop(memberFarmerIds, dto.getCropName()).stream()
                .map(ProduceListing::getQuantityKg)
                .filter(quantity -> quantity != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        if (totalQuantity.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessValidationException("No active member listings found for this crop");
        }

        FpoListing listing = new FpoListing();
        listing.setFpoGroup(group);
        listing.setCropName(dto.getCropName());
        listing.setTotalQuantityKg(totalQuantity);
        listing.setMinPricePerKg(dto.getMinPricePerKg());
        listing.setQualityGrade(dto.getQualityGrade());
        listing.setPoolingDeadline(dto.getPoolingDeadline());
        listing.setStatus(FpoListing.Status.OPEN);
        fpoListingDao.save(listing);
        return listing;
    }

    @Transactional(readOnly = true)
    public List<FpoListingResponseDto> getFpoListingsForBuyer() {
        return fpoListingDao.findOpenListingsForBuyer().stream()
                .map(FpoListingResponseDto::new)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<FpoGroup> getGroupsLedByUser(Long userId) {
        FarmerProfile farmer = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        return fpoGroupDao.findByLeader(farmer.getId());
    }

    @Transactional(readOnly = true)
    public List<FpoMembership> getMembershipsForUser(Long userId) {
        FarmerProfile farmer = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        return fpoMembershipDao.findByFarmer(farmer.getId());
    }

    @Transactional(readOnly = true)
    public List<FpoMembership> getPendingApprovalsForLeader(Long userId) {
        FarmerProfile farmer = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        return fpoMembershipDao.findPendingByLeader(farmer.getId());
    }

    @Transactional(readOnly = true)
    public List<FpoListing> getListingsForGroup(Long fpoId) {
        return fpoListingDao.findByFpo(fpoId);
    }

    private FarmerProfile loadVerifiedFarmer(Long userId) {
        FarmerProfile farmer = farmerProfileDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Farmer profile not found"));
        if (farmer.getUser() == null || farmer.getUser().getVerificationStatus() != User.VerificationStatus.VERIFIED) {
            throw new BusinessValidationException("Only VERIFIED farmers can perform this FPO action");
        }
        return farmer;
    }
}
