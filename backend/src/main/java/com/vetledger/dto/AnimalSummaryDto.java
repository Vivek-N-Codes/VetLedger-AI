package com.vetledger.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public class AnimalSummaryDto {
    private Long id;
    private String animalCode;
    private String name;
    private String species;
    private String breed;
    private BigDecimal ageYears;
    private String sex;
    private Long farmId;
    private String farmName;
    private Long villageId;
    private String villageName;
    private LocalDate lastVisitDate;
    private String lastVisitComplaint;
    private int totalVisits;

    public AnimalSummaryDto() {}

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

    public String getFarmName() { return farmName; }
    public void setFarmName(String farmName) { this.farmName = farmName; }

    public Long getVillageId() { return villageId; }
    public void setVillageId(Long villageId) { this.villageId = villageId; }

    public String getVillageName() { return villageName; }
    public void setVillageName(String villageName) { this.villageName = villageName; }

    public LocalDate getLastVisitDate() { return lastVisitDate; }
    public void setLastVisitDate(LocalDate lastVisitDate) { this.lastVisitDate = lastVisitDate; }

    public String getLastVisitComplaint() { return lastVisitComplaint; }
    public void setLastVisitComplaint(String lastVisitComplaint) { this.lastVisitComplaint = lastVisitComplaint; }

    public int getTotalVisits() { return totalVisits; }
    public void setTotalVisits(int totalVisits) { this.totalVisits = totalVisits; }
}
