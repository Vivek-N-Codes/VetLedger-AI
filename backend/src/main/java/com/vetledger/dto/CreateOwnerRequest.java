package com.vetledger.dto;

import jakarta.validation.constraints.NotBlank;

public class CreateOwnerRequest {
    private String ownerCode;

    @NotBlank(message = "Owner full name is required")
    private String fullName;

    private String contactNumber;
    private String email;
    private String address;
    private Long villageId;
    private String notes;

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

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
