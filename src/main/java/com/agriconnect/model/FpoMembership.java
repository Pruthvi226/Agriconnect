package com.agriconnect.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "fpo_memberships")
public class FpoMembership {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fpo_id", nullable = false)
    private FpoGroup fpoGroup;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "farmer_id", nullable = false)
    private FarmerProfile farmer;

    @Column(name = "joined_at", updatable = false)
    private LocalDateTime joinedAt;

    @Column(name = "is_active")
    private Boolean isActive = Boolean.FALSE;

    @PrePersist
    protected void onCreate() {
        if (joinedAt == null) {
            joinedAt = LocalDateTime.now();
        }
        if (isActive == null) {
            isActive = Boolean.FALSE;
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public FpoGroup getFpoGroup() { return fpoGroup; }
    public void setFpoGroup(FpoGroup fpoGroup) { this.fpoGroup = fpoGroup; }
    public FarmerProfile getFarmer() { return farmer; }
    public void setFarmer(FarmerProfile farmer) { this.farmer = farmer; }
    public LocalDateTime getJoinedAt() { return joinedAt; }
    public void setJoinedAt(LocalDateTime joinedAt) { this.joinedAt = joinedAt; }
    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean active) { isActive = active; }
}
