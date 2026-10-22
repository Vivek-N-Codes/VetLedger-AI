package com.vetledger.dto;

import java.time.OffsetDateTime;

public class OwnerDto {
    private Long id;
    private String ownerCode;
    private String fullName;
    private String contactNumber;
    private String email;
    private String address;
    private Long villageId;
    private String villageName;
    private String notes;
    private OffsetDateTime createdAt;
    private int farmCount;
    private int animalCount;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getOwnerCode() { return ownerCode; }
    public void setOwnerCode(String ownerCode) { this.ownerCode = ownerCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Long getVillageId() { return villageId; }
    public void setVillageId(Long villageId) { this.villageId = villageId; }

    public String getVillageName() { return villageName; }
    public void setVillageName(String villageName) { this.villageName = villageName; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public OffsetDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }

    public int getFarmCount() { return farmCount; }
    public void setFarmCount(int farmCount) { this.farmCount = farmCount; }

    public int getAnimalCount() { return animalCount; }
    public void setAnimalCount(int animalCount) { this.animalCount = animalCount; }
}
