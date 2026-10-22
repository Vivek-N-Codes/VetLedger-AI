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

    // Financial charges (Owner Ledger Pillar)
    @Column(name = "consultation_fee", precision = 10, scale = 2)
    private BigDecimal consultationFee = BigDecimal.ZERO;

    @Column(name = "service_fee", precision = 10, scale = 2)
    private BigDecimal serviceFee = BigDecimal.ZERO;

    @Column(name = "medicine_fee", precision = 10, scale = 2)
    private BigDecimal medicineFee = BigDecimal.ZERO;

    @Column(name = "other_fee", precision = 10, scale = 2)
    private BigDecimal otherFee = BigDecimal.ZERO;

    @Column(name = "total_charge", precision = 10, scale = 2)
    private BigDecimal totalCharge = BigDecimal.ZERO;

    // Clinical Decision Support & Examination Fields
    @Column(name = "symptom_onset_duration", length = 100)
    private String symptomOnsetDuration;

    @Column(name = "physical_exam_findings", columnDefinition = "TEXT")
    private String physicalExamFindings;

    @Column(name = "treatments_administered_prior", columnDefinition = "TEXT")
    private String treatmentsAdministeredPrior;

    @Column(name = "prior_treatment_response", columnDefinition = "TEXT")
    private String priorTreatmentResponse;

    @Column(name = "final_clinical_assessment", columnDefinition = "TEXT")
    private String finalClinicalAssessment;

    @Column(name = "actual_treatment_administered", columnDefinition = "TEXT")
    private String actualTreatmentAdministered;

    @Column(name = "owner_advice", columnDefinition = "TEXT")
    private String ownerAdvice;

    @Column(name = "follow_up_due_date")
    private LocalDate followUpDueDate;

    @Column(name = "follow_up_status", length = 30)
    private String followUpStatus = "NONE"; // NONE, PENDING, COMPLETED, CANCELLED

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

    public void calculateTotalCharge() {
        BigDecimal c = consultationFee != null ? consultationFee : BigDecimal.ZERO;
        BigDecimal s = serviceFee != null ? serviceFee : BigDecimal.ZERO;
        BigDecimal m = medicineFee != null ? medicineFee : BigDecimal.ZERO;
        BigDecimal o = otherFee != null ? otherFee : BigDecimal.ZERO;
        this.totalCharge = c.add(s).add(m).add(o);
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Animal getAnimal() { return animal; }
    public void setAnimal(Animal animal) { this.animal = animal; }

    public LocalDate getVisitDate() { return visitDate; }
    public void setVisitDate(LocalDate visitDate) { this.visitDate = visitDate; }

    public String getPresentingComplaint() { return presentingComplaint; }
    public void setPresentingComplaint(String presentingComplaint) { this.presentingComplaint = presentingComplaint; }

    public String getObservations() { return observations; }
    public void setObservations(String observations) { this.observations = observations; }

    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }

    public BigDecimal getTemperatureCelsius() { return temperatureCelsius; }
    public void setTemperatureCelsius(BigDecimal temperatureCelsius) { this.temperatureCelsius = temperatureCelsius; }

    public String getTreatmentNotes() { return treatmentNotes; }
    public void setTreatmentNotes(String treatmentNotes) { this.treatmentNotes = treatmentNotes; }

    public String getFollowUpNotes() { return followUpNotes; }
    public void setFollowUpNotes(String followUpNotes) { this.followUpNotes = followUpNotes; }

    public BigDecimal getConsultationFee() { return consultationFee; }
    public void setConsultationFee(BigDecimal consultationFee) { this.consultationFee = consultationFee; }

    public BigDecimal getServiceFee() { return serviceFee; }
    public void setServiceFee(BigDecimal serviceFee) { this.serviceFee = serviceFee; }

    public BigDecimal getMedicineFee() { return medicineFee; }
    public void setMedicineFee(BigDecimal medicineFee) { this.medicineFee = medicineFee; }

    public BigDecimal getOtherFee() { return otherFee; }
    public void setOtherFee(BigDecimal otherFee) { this.otherFee = otherFee; }

    public BigDecimal getTotalCharge() { return totalCharge; }
    public void setTotalCharge(BigDecimal totalCharge) { this.totalCharge = totalCharge; }

    public String getSymptomOnsetDuration() { return symptomOnsetDuration; }
    public void setSymptomOnsetDuration(String symptomOnsetDuration) { this.symptomOnsetDuration = symptomOnsetDuration; }

    public String getPhysicalExamFindings() { return physicalExamFindings; }
    public void setPhysicalExamFindings(String physicalExamFindings) { this.physicalExamFindings = physicalExamFindings; }

    public String getTreatmentsAdministeredPrior() { return treatmentsAdministeredPrior; }
    public void setTreatmentsAdministeredPrior(String treatmentsAdministeredPrior) { this.treatmentsAdministeredPrior = treatmentsAdministeredPrior; }

    public String getPriorTreatmentResponse() { return priorTreatmentResponse; }
    public void setPriorTreatmentResponse(String priorTreatmentResponse) { this.priorTreatmentResponse = priorTreatmentResponse; }

    public String getFinalClinicalAssessment() { return finalClinicalAssessment; }
    public void setFinalClinicalAssessment(String finalClinicalAssessment) { this.finalClinicalAssessment = finalClinicalAssessment; }

    public String getActualTreatmentAdministered() { return actualTreatmentAdministered; }
    public void setActualTreatmentAdministered(String actualTreatmentAdministered) { this.actualTreatmentAdministered = actualTreatmentAdministered; }

    public String getOwnerAdvice() { return ownerAdvice; }
    public void setOwnerAdvice(String ownerAdvice) { this.ownerAdvice = ownerAdvice; }

    public LocalDate getFollowUpDueDate() { return followUpDueDate; }
    public void setFollowUpDueDate(LocalDate followUpDueDate) { this.followUpDueDate = followUpDueDate; }

    public String getFollowUpStatus() { return followUpStatus; }
    public void setFollowUpStatus(String followUpStatus) { this.followUpStatus = followUpStatus; }

    public List<VisitSymptom> getSymptoms() { return symptoms; }
    public void setSymptoms(List<VisitSymptom> symptoms) { this.symptoms = symptoms; }

    public void addSymptom(String symptomCode, String severity) {
        VisitSymptom s = new VisitSymptom(this, symptomCode, severity);
        this.symptoms.add(s);
    }

    public OffsetDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }
}
