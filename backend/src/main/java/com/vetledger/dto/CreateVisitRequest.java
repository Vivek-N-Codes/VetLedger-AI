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
}
