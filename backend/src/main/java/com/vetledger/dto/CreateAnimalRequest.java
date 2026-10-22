package com.vetledger.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public class CreateAnimalRequest {

    private String animalCode; // Optional; if blank, backend generates species-prefix code

    @NotBlank(message = "Animal name or local identifier is required")
    private String name;

    @NotBlank(message = "Species is required (e.g. Cattle, Buffalo, Goat, Sheep)")
    private String species;

    private String breed;
    private BigDecimal ageYears;

    @NotBlank(message = "Sex is required (e.g. FEMALE, MALE)")
    private String sex;

    @NotNull(message = "Registered Farm ID is required")
    private Long farmId;

    private String tagRfid;
    private String notes;

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

    public String getTagRfid() { return tagRfid; }
    public void setTagRfid(String tagRfid) { this.tagRfid = tagRfid; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
