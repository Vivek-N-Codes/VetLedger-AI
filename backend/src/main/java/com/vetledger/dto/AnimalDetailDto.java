package com.vetledger.dto;

import java.math.BigDecimal;
import java.util.List;

public class AnimalDetailDto {
    private Long id;
    private String animalCode;
    private String name;
    private String species;
    private String breed;
    private BigDecimal ageYears;
    private String sex;
    private Long farmId;
    private String farmCode;
    private String farmName;
    private String ownerName;
    private String contactNumber;
    private Long villageId;
    private String villageName;
    private String tagRfid;
    private String notes;
    private List<VisitDto> visits;
    private int totalVisitsRecorded;

    public AnimalDetailDto() {}

    public int getTotalVisitsRecorded() { return totalVisitsRecorded; }
    public void setTotalVisitsRecorded(int totalVisitsRecorded) { this.totalVisitsRecorded = totalVisitsRecorded; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getAnimalCode() { return animalCode; }
    public void setAnimalCode(String animalCode) { this.animalCode = animalCode; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSpecies() { return species; }
    public void setSpecies(String species) { this.species = species; }

    public String getBreed() { return breed; }
    public void setBreed(String breed) { this.breed = breed; }

    public BigDecimal getAgeYears() { return ageYears; }
    public void setAgeYears(BigDecimal ageYears) { this.ageYears = ageYears; }

    public String getSex() { return sex; }
    public void setSex(String sex) { this.sex = sex; }

    public Long getFarmId() { return farmId; }
    public void setFarmId(Long farmId) { this.farmId = farmId; }

    public String getFarmCode() { return farmCode; }
    public void setFarmCode(String farmCode) { this.farmCode = farmCode; }

    public String getFarmName() { return farmName; }
    public void setFarmName(String farmName) { this.farmName = farmName; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public Long getVillageId() { return villageId; }
    public void setVillageId(Long villageId) { this.villageId = villageId; }

    public String getVillageName() { return villageName; }
    public void setVillageName(String villageName) { this.villageName = villageName; }

    public String getTagRfid() { return tagRfid; }
    public void setTagRfid(String tagRfid) { this.tagRfid = tagRfid; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public List<VisitDto> getVisits() { return visits; }
    public void setVisits(List<VisitDto> visits) { this.visits = visits; }
}
