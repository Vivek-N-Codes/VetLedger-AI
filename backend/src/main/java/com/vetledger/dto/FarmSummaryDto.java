package com.vetledger.dto;

public class FarmSummaryDto {
    private Long id;
    private String farmCode;
    private String farmName;
    private Long ownerId;
    private String ownerName;
    private String contactNumber;
    private Long villageId;
    private String villageName;
    private int animalCount;
    private int recentVisitCount;
    private boolean hasActiveAlert;

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

    public int getAnimalCount() { return animalCount; }
    public void setAnimalCount(int animalCount) { this.animalCount = animalCount; }

    public int getRecentVisitCount() { return recentVisitCount; }
    public void setRecentVisitCount(int recentVisitCount) { this.recentVisitCount = recentVisitCount; }

    public boolean isHasActiveAlert() { return hasActiveAlert; }
    public void setHasActiveAlert(boolean hasActiveAlert) { this.hasActiveAlert = hasActiveAlert; }
}
