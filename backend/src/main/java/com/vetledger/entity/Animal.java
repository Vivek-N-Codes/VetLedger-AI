package com.vetledger.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Entity
@Table(name = "animals")
public class Animal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "animal_code", nullable = false, unique = true, length = 50)
    private String animalCode;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, length = 50)
    private String species;

    @Column(length = 100)
    private String breed;

    @Column(name = "age_years", precision = 4, scale = 1)
    private BigDecimal ageYears;

    @Column(nullable = false, length = 20)
    private String sex;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "farm_id", nullable = false)
    private Farm farm;

    @Column(name = "tag_rfid", length = 100)
    private String tagRfid;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "created_at", insertable = false, updatable = false)
    private OffsetDateTime createdAt;

    public Animal() {}

    public Animal(Long id, String animalCode, String name, String species, String breed, BigDecimal ageYears, String sex, Farm farm, String tagRfid, String notes) {
        this.id = id;
        this.animalCode = animalCode;
        this.name = name;
        this.species = species;
        this.breed = breed;
        this.ageYears = ageYears;
        this.sex = sex;
        this.farm = farm;
        this.tagRfid = tagRfid;
        this.notes = notes;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getAnimalCode() {
        return animalCode;
    }

    public void setAnimalCode(String animalCode) {
        this.animalCode = animalCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecies() {
        return species;
    }

    public void setSpecies(String species) {
        this.species = species;
    }

    public String getBreed() {
        return breed;
    }

    public void setBreed(String breed) {
        this.breed = breed;
    }

    public BigDecimal getAgeYears() {
        return ageYears;
    }

    public void setAgeYears(BigDecimal ageYears) {
        this.ageYears = ageYears;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public Farm getFarm() {
        return farm;
    }

    public void setFarm(Farm farm) {
        this.farm = farm;
    }

    public String getTagRfid() {
        return tagRfid;
    }

    public void setTagRfid(String tagRfid) {
        this.tagRfid = tagRfid;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
