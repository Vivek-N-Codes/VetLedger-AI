package com.vetledger.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "farms")
public class Farm {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "farm_code", nullable = false, unique = true, length = 50)
    private String farmCode;

    @Column(name = "farm_name", nullable = false, length = 150)
    private String farmName;

    @Column(name = "owner_name", nullable = false, length = 150)
    private String ownerName;

    @Column(name = "contact_number", length = 30)
    private String contactNumber;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "village_id", nullable = false)
    private Village village;

    @Column
    private Double latitude;

    @Column
    private Double longitude;

    @Column(name = "created_at", insertable = false, updatable = false)
    private OffsetDateTime createdAt;

    public Farm() {}

    public Farm(Long id, String farmCode, String farmName, String ownerName, String contactNumber, Village village, Double latitude, Double longitude) {
        this.id = id;
        this.farmCode = farmCode;
        this.farmName = farmName;
        this.ownerName = ownerName;
        this.contactNumber = contactNumber;
        this.village = village;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFarmCode() {
        return farmCode;
    }

    public void setFarmCode(String farmCode) {
        this.farmCode = farmCode;
    }

    public String getFarmName() {
        return farmName;
    }

    public void setFarmName(String farmName) {
        this.farmName = farmName;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public Village getVillage() {
        return village;
    }

    public void setVillage(Village village) {
        this.village = village;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
