package com.vetledger.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;

public class VisitDto {
    private Long id;
    private Long animalId;
    private String animalCode;
    private String animalName;
    private String farmName;
    private String villageName;
    private LocalDate visitDate;
    private String presentingComplaint;
    private String observations;
    private String severity;
    private BigDecimal temperatureCelsius;
    private String treatmentNotes;
    private String followUpNotes;
    private List<String> symptoms;
    private OffsetDateTime createdAt;

    // Financial charges
    private BigDecimal consultationFee;
    private BigDecimal serviceFee;
    private BigDecimal medicineFee;
    private BigDecimal otherFee;
    private BigDecimal totalCharge;

    // Modular Clinical Decision Fields
    private String symptomOnsetDuration;
    private String physicalExamFindings;
    private String treatmentsAdministeredPrior;
    private String priorTreatmentResponse;
    private String finalClinicalAssessment;
    private String actualTreatmentAdministered;
    private String ownerAdvice;
    private LocalDate followUpDueDate;
    private String followUpStatus;

    public VisitDto() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getAnimalId() { return animalId; }
    public void setAnimalId(Long animalId) { this.animalId = animalId; }

    public String getAnimalCode() { return animalCode; }
    public void setAnimalCode(String animalCode) { this.animalCode = animalCode; }

    public String getAnimalName() { return animalName; }
    public void setAnimalName(String animalName) { this.animalName = animalName; }

    public String getFarmName() { return farmName; }
    public void setFarmName(String farmName) { this.farmName = farmName; }

    public String getVillageName() { return villageName; }
    public void setVillageName(String villageName) { this.villageName = villageName; }

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

    public List<String> getSymptoms() { return symptoms; }
    public void setSymptoms(List<String> symptoms) { this.symptoms = symptoms; }

    public OffsetDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(OffsetDateTime createdAt) { this.createdAt = createdAt; }

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
}
