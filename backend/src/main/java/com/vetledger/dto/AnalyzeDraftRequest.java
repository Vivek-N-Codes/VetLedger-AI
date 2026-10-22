package com.vetledger.dto;

import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class AnalyzeDraftRequest {

    @NotNull(message = "Animal ID is required")
    private Long animalId;

    private LocalDate visitDate;
    private String presentingComplaint;
    private List<String> currentSymptoms;
    private String symptomOnsetDuration;
    private String severity;
    private BigDecimal temperatureCelsius;
    private String physicalExamFindings;
    private String treatmentsAdministeredPrior;
    private String priorTreatmentResponse;
    private String treatmentNotes;

    public Long getAnimalId() { return animalId; }
    public void setAnimalId(Long animalId) { this.animalId = animalId; }

    public LocalDate getVisitDate() { return visitDate; }
    public void setVisitDate(LocalDate visitDate) { this.visitDate = visitDate; }

    public String getPresentingComplaint() { return presentingComplaint; }
    public void setPresentingComplaint(String presentingComplaint) { this.presentingComplaint = presentingComplaint; }

    public List<String> getCurrentSymptoms() { return currentSymptoms; }
    public void setCurrentSymptoms(List<String> currentSymptoms) { this.currentSymptoms = currentSymptoms; }

    public String getSymptomOnsetDuration() { return symptomOnsetDuration; }
    public void setSymptomOnsetDuration(String symptomOnsetDuration) { this.symptomOnsetDuration = symptomOnsetDuration; }

    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }

    public BigDecimal getTemperatureCelsius() { return temperatureCelsius; }
    public void setTemperatureCelsius(BigDecimal temperatureCelsius) { this.temperatureCelsius = temperatureCelsius; }

    public String getPhysicalExamFindings() { return physicalExamFindings; }
    public void setPhysicalExamFindings(String physicalExamFindings) { this.physicalExamFindings = physicalExamFindings; }

    public String getTreatmentsAdministeredPrior() { return treatmentsAdministeredPrior; }
    public void setTreatmentsAdministeredPrior(String treatmentsAdministeredPrior) { this.treatmentsAdministeredPrior = treatmentsAdministeredPrior; }

    public String getPriorTreatmentResponse() { return priorTreatmentResponse; }
    public void setPriorTreatmentResponse(String priorTreatmentResponse) { this.priorTreatmentResponse = priorTreatmentResponse; }

    public String getTreatmentNotes() { return treatmentNotes; }
    public void setTreatmentNotes(String treatmentNotes) { this.treatmentNotes = treatmentNotes; }
}
