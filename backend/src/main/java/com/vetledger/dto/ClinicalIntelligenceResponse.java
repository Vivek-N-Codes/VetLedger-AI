package com.vetledger.dto;

import java.time.Instant;
import java.util.List;

public class ClinicalIntelligenceResponse {
    private Long animalId;
    private String animalCode;
    private String animalName;
    private String species;
    private String breed;
    private String farmName;
    private String villageName;

    // AI Status
    private String source; // "LIVE_LLM" or "DETERMINISTIC_FALLBACK"
    private String modelName;
    private Instant generatedAt;

    // Core Clinical Fields
    private String clinicalSummary;
    private List<String> historicalFindings;
    private List<String> recurringSymptoms;
    private String symptomChangesOverTime;
    private List<String> riskIndicators;
    private List<String> possibleConditionsToConsider;
    private List<String> recommendedObservations;
    private String suggestedFollowUp;
    private String veterinaryReviewRecommendation;
    private String disclaimer;

    public ClinicalIntelligenceResponse() {
        this.generatedAt = Instant.now();
        this.disclaimer = "AI-generated clinical decision support. Final assessment remains with a qualified veterinarian.";
    }

    public Long getAnimalId() { return animalId; }
    public void setAnimalId(Long animalId) { this.animalId = animalId; }

    public String getAnimalCode() { return animalCode; }
    public void setAnimalCode(String animalCode) { this.animalCode = animalCode; }

    public String getAnimalName() { return animalName; }
    public void setAnimalName(String animalName) { this.animalName = animalName; }

    public String getSpecies() { return species; }
    public void setSpecies(String species) { this.species = species; }

    public String getBreed() { return breed; }
    public void setBreed(String breed) { this.breed = breed; }

    public String getFarmName() { return farmName; }
    public void setFarmName(String farmName) { this.farmName = farmName; }

    public String getVillageName() { return villageName; }
    public void setVillageName(String villageName) { this.villageName = villageName; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public String getModelName() { return modelName; }
    public void setModelName(String modelName) { this.modelName = modelName; }

    public Instant getGeneratedAt() { return generatedAt; }
    public void setGeneratedAt(Instant generatedAt) { this.generatedAt = generatedAt; }

    public String getClinicalSummary() { return clinicalSummary; }
    public void setClinicalSummary(String clinicalSummary) { this.clinicalSummary = clinicalSummary; }

    public List<String> getHistoricalFindings() { return historicalFindings; }
    public void setHistoricalFindings(List<String> historicalFindings) { this.historicalFindings = historicalFindings; }

    public List<String> getRecurringSymptoms() { return recurringSymptoms; }
    public void setRecurringSymptoms(List<String> recurringSymptoms) { this.recurringSymptoms = recurringSymptoms; }

    public String getSymptomChangesOverTime() { return symptomChangesOverTime; }
    public void setSymptomChangesOverTime(String symptomChangesOverTime) { this.symptomChangesOverTime = symptomChangesOverTime; }

    public List<String> getRiskIndicators() { return riskIndicators; }
    public void setRiskIndicators(List<String> riskIndicators) { this.riskIndicators = riskIndicators; }

    public List<String> getPossibleConditionsToConsider() { return possibleConditionsToConsider; }
    public void setPossibleConditionsToConsider(List<String> possibleConditionsToConsider) { this.possibleConditionsToConsider = possibleConditionsToConsider; }

    public List<String> getRecommendedObservations() { return recommendedObservations; }
    public void setRecommendedObservations(List<String> recommendedObservations) { this.recommendedObservations = recommendedObservations; }

    public String getSuggestedFollowUp() { return suggestedFollowUp; }
    public void setSuggestedFollowUp(String suggestedFollowUp) { this.suggestedFollowUp = suggestedFollowUp; }

    public String getVeterinaryReviewRecommendation() { return veterinaryReviewRecommendation; }
    public void setVeterinaryReviewRecommendation(String veterinaryReviewRecommendation) { this.veterinaryReviewRecommendation = veterinaryReviewRecommendation; }

    public String getDisclaimer() { return disclaimer; }
    public void setDisclaimer(String disclaimer) { this.disclaimer = disclaimer; }
}
