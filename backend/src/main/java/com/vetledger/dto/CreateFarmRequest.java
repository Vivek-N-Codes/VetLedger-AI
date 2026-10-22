package com.vetledger.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class CreateFarmRequest {
    private String farmCode; // Optional; if blank, backend generates unique FARM-xxx

    @NotBlank(message = "Farm name is required")
    private String farmName;

    private Long ownerId; // Optional if ownerName provided
    private String ownerName;
    private String contactNumber;

    @NotNull(message = "Village ID is required")
    private Long villageId;

    private String address;
    private String notes;
    private Double latitude;
    private Double longitude;

    public String getFarmCode() { return farmCode; }
    public void setFarmCode(String farmCode) { this.farmCode = farmCode; }

    public String getFarmName() { return farmName; }
    public void setFarmName(String farmName) { this.farmName = farmName; }

    public Long getOwnerId() { return ownerId; }
    public void setOwnerId(Long ownerId) { this.ownerId = ownerId; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public Long getVillageId() { return villageId; }
    public void setVillageId(Long villageId) { this.villageId = villageId; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
}
