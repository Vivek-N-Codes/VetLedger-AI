package com.vetledger.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "visit_symptoms")
public class VisitSymptom {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "visit_id", nullable = false)
    @JsonIgnore
    private Visit visit;

    @Column(name = "symptom_code", nullable = false, length = 60)
    private String symptomCode;

    @Column(length = 30)
    private String severity; // MILD, MODERATE, SEVERE

    @Column(name = "created_at", insertable = false, updatable = false)
    private OffsetDateTime createdAt;

    public VisitSymptom() {}

    public VisitSymptom(Visit visit, String symptomCode, String severity) {
        this.visit = visit;
        this.symptomCode = symptomCode;
        this.severity = severity != null ? severity : "MODERATE";
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Visit getVisit() {
        return visit;
    }

    public void setVisit(Visit visit) {
        this.visit = visit;
    }

    public String getSymptomCode() {
        return symptomCode;
    }

    public void setSymptomCode(String symptomCode) {
        this.symptomCode = symptomCode;
    }

    public String getSeverity() {
        return severity;
    }

    public void setSeverity(String severity) {
        this.severity = severity;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
