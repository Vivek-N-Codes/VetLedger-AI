package com.vetledger.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "visits")
public class Visit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "animal_id", nullable = false)
    private Animal animal;

    @Column(name = "visit_date", nullable = false)
    private LocalDate visitDate;

    @Column(name = "presenting_complaint", nullable = false, length = 255)
    private String presentingComplaint;

    @Column(columnDefinition = "TEXT")
    private String observations;

    @Column(nullable = false, length = 30)
    private String severity; // MILD, MODERATE, SEVERE

    @Column(name = "temperature_celsius", precision = 4, scale = 1)
    private BigDecimal temperatureCelsius;

    @Column(name = "treatment_notes", columnDefinition = "TEXT")
    private String treatmentNotes;

    @Column(name = "follow_up_notes", columnDefinition = "TEXT")
    private String followUpNotes;

    @OneToMany(mappedBy = "visit", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    private List<VisitSymptom> symptoms = new ArrayList<>();

    @Column(name = "created_at", insertable = false, updatable = false)
    private OffsetDateTime createdAt;

    public Visit() {}

    public Visit(Long id, Animal animal, LocalDate visitDate, String presentingComplaint, String observations, String severity, BigDecimal temperatureCelsius, String treatmentNotes, String followUpNotes) {
        this.id = id;
        this.animal = animal;
        this.visitDate = visitDate;
        this.presentingComplaint = presentingComplaint;
        this.observations = observations;
        this.severity = severity;
        this.temperatureCelsius = temperatureCelsius;
        this.treatmentNotes = treatmentNotes;
        this.followUpNotes = followUpNotes;
    }

    public void addSymptom(String symptomCode, String severity) {
        VisitSymptom symptom = new VisitSymptom(this, symptomCode, severity);
        this.symptoms.add(symptom);
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Animal getAnimal() {
        return animal;
    }

    public void setAnimal(Animal animal) {
        this.animal = animal;
    }

    public LocalDate getVisitDate() {
        return visitDate;
    }

    public void setVisitDate(LocalDate visitDate) {
        this.visitDate = visitDate;
    }

    public String getPresentingComplaint() {
        return presentingComplaint;
    }

    public void setPresentingComplaint(String presentingComplaint) {
        this.presentingComplaint = presentingComplaint;
    }

    public String getObservations() {
        return observations;
    }

    public void setObservations(String observations) {
        this.observations = observations;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public BigDecimal getTemperatureCelsius() {
        return temperatureCelsius;
    }

    public void setTemperatureCelsius(BigDecimal temperatureCelsius) {
        this.temperatureCelsius = temperatureCelsius;
    }

    public String getTreatmentNotes() {
        return treatmentNotes;
    }

    public void setTreatmentNotes(String treatmentNotes) {
        this.treatmentNotes = treatmentNotes;
    }

    public String getFollowUpNotes() {
        return followUpNotes;
    }

    public void setFollowUpNotes(String followUpNotes) {
        this.followUpNotes = followUpNotes;
    }

    public List<VisitSymptom> getSymptoms() {
        return symptoms;
    }

    public void setSymptoms(List<VisitSymptom> symptoms) {
        this.symptoms = symptoms;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
