package com.vetledger.dto;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

public class FarmDetailDto {
    private Long id;
    private String farmCode;
    private String farmName;
    private Long ownerId;
    private String ownerName;
    private String contactNumber;
    private Long villageId;
    private String villageName;
    private String address;
    private String notes;
    private Double latitude;
    private Double longitude;
    private OffsetDateTime createdAt;

    // Health Summary (calculated from stored records)
    private int registeredAnimalCount;
    private int totalVisitsRecorded;
    private int recentVisitsLast14Days;
    private boolean activeSurveillanceAlert;
    private List<String> topSymptoms;
    private Map<String, Integer> symptomFrequencies;

    // Associated Entities
    private List<AnimalSummaryDto> animals;
    private List<VisitDto> recentVisits;

    // Owner-Level Financial Summary (View into Owner's ledger, NOT independent farm balance)
    private BigDecimal ownerTotalCharges;
    private BigDecimal ownerTotalPayments;
    private BigDecimal ownerOutstandingBalance;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

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

    public String getVillageName() { return villageName; }
    public void setVillageName(String villageName) { this.villageName = villageName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public OffsetDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }

    public int getRegisteredAnimalCount() { return registeredAnimalCount; }
    public void setRegisteredAnimalCount(int registeredAnimalCount) { this.registeredAnimalCount = registeredAnimalCount; }

    public int getTotalVisitsRecorded() { return totalVisitsRecorded; }
    public void setTotalVisitsRecorded(int totalVisitsRecorded) { this.totalVisitsRecorded = totalVisitsRecorded; }

    public int getRecentVisitsLast14Days() { return recentVisitsLast14Days; }
    public void setRecentVisitsLast14Days(int recentVisitsLast14Days) { this.recentVisitsLast14Days = recentVisitsLast14Days; }

    public boolean isActiveSurveillanceAlert() { return activeSurveillanceAlert; }
    public void setActiveSurveillanceAlert(boolean activeSurveillanceAlert) { this.activeSurveillanceAlert = activeSurveillanceAlert; }

    public List<String> getTopSymptoms() { return topSymptoms; }
    public void setTopSymptoms(List<String> topSymptoms) { this.topSymptoms = topSymptoms; }

    public Map<String, Integer> getSymptomFrequencies() { return symptomFrequencies; }
    public void setSymptomFrequencies(Map<String, Integer> symptomFrequencies) { this.symptomFrequencies = symptomFrequencies; }

    public List<AnimalSummaryDto> getAnimals() { return animals; }
    public void setAnimals(List<AnimalSummaryDto> animals) { this.animals = animals; }

    public List<VisitDto> getRecentVisits() { return recentVisits; }
    public void setRecentVisits(List<VisitDto> recentVisits) { this.recentVisits = recentVisits; }

    public BigDecimal getOwnerTotalCharges() { return ownerTotalCharges; }
    public void setOwnerTotalCharges(BigDecimal ownerTotalCharges) { this.ownerTotalCharges = ownerTotalCharges; }

    public BigDecimal getOwnerTotalPayments() { return ownerTotalPayments; }
    public void setOwnerTotalPayments(BigDecimal ownerTotalPayments) { this.ownerTotalPayments = ownerTotalPayments; }

    public BigDecimal getOwnerOutstandingBalance() { return ownerOutstandingBalance; }
    public void setOwnerOutstandingBalance(BigDecimal ownerOutstandingBalance) { this.ownerOutstandingBalance = ownerOutstandingBalance; }
}
