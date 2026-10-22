package com.vetledger.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class CreateVisitRequest {

    @NotNull(message = "Animal ID is required")
    private Long animalId;

    @NotNull(message = "Visit date is required")
    private LocalDate visitDate;

    @NotBlank(message = "Presenting complaint is required")
    private String presentingComplaint;

    private String observations;
    private String severity = "MODERATE";
    private BigDecimal temperatureCelsius;
    private String treatmentNotes;
    private String followUpNotes;

    @NotEmpty(message = "At least one symptom must be selected")
    private List<String> symptoms;

    // Financial charges entry
    private BigDecimal consultationFee = BigDecimal.ZERO;
    private BigDecimal serviceFee = BigDecimal.ZERO;
    private BigDecimal medicineFee = BigDecimal.ZERO;
    private BigDecimal otherFee = BigDecimal.ZERO;

    // Modular Clinical Decision Fields
    private String symptomOnsetDuration;
    private String physicalExamFindings;
    private String treatmentsAdministeredPrior;
    private String priorTreatmentResponse;
    private String finalClinicalAssessment;
    private String actualTreatmentAdministered;
    private String ownerAdvice;
    private LocalDate followUpDueDate;
    private String followUpStatus = "NONE";

    public CreateVisitRequest() {}

    public Long getAnimalId() { return animalId; }
    public void setAnimalId(Long animalId) { this.animalId = animalId; }

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

    public BigDecimal getConsultationFee() { return consultationFee; }
    public void setConsultationFee(BigDecimal consultationFee) { this.consultationFee = consultationFee; }

    public BigDecimal getServiceFee() { return serviceFee; }
    public void setServiceFee(BigDecimal serviceFee) { this.serviceFee = serviceFee; }

    public BigDecimal getMedicineFee() { return medicineFee; }
    public void setMedicineFee(BigDecimal medicineFee) { this.medicineFee = medicineFee; }

    public BigDecimal getOtherFee() { return otherFee; }
    public void setOtherFee(BigDecimal otherFee) { this.otherFee = otherFee; }

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
