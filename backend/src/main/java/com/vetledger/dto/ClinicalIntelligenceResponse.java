package com.vetledger.dto;

import java.time.Instant;
import java.util.ArrayList;
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
    private boolean isDraftAnalysis;

    // Backward-compatible fields
    private String clinicalSummary;
    private List<String> historicalFindings = new ArrayList<>();
    private List<String> recurringSymptoms = new ArrayList<>();
    private String symptomChangesOverTime;
    private List<String> riskIndicators = new ArrayList<>();
    private List<String> possibleConditionsToConsider = new ArrayList<>();
    private List<String> recommendedObservations = new ArrayList<>();
    private String suggestedFollowUp;
    private String veterinaryReviewRecommendation;
    private String disclaimer = "AI-generated clinical decision support. Final assessment remains with a qualified veterinarian.";

    // -------------------------------------------------------------
    // MODULE 1: Longitudinal Symptom Tracker
    // -------------------------------------------------------------
    public static class SymptomTrackerItem {
        private String symptomCode;
        private String displayName;
        private int occurrenceCount;
        private int totalVisits;
        private double percentage;
        private String firstRecordedDate;
        private String lastRecordedDate;
        private String status; // RECURRENT, NEW, HISTORICAL_ONLY, RESOLVED
        private String presentationText;

        public String getSymptomCode() { return symptomCode; }
        public void setSymptomCode(String symptomCode) { this.symptomCode = symptomCode; }
        public String getDisplayName() { return displayName; }
        public void setDisplayName(String displayName) { this.displayName = displayName; }
        public int getOccurrenceCount() { return occurrenceCount; }
        public void setOccurrenceCount(int occurrenceCount) { this.occurrenceCount = occurrenceCount; }
        public int getTotalVisits() { return totalVisits; }
        public void setTotalVisits(int totalVisits) { this.totalVisits = totalVisits; }
        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
        public String getFirstRecordedDate() { return firstRecordedDate; }
        public void setFirstRecordedDate(String firstRecordedDate) { this.firstRecordedDate = firstRecordedDate; }
        public String getLastRecordedDate() { return lastRecordedDate; }
        public void setLastRecordedDate(String lastRecordedDate) { this.lastRecordedDate = lastRecordedDate; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getPresentationText() { return presentationText; }
        public void setPresentationText(String presentationText) { this.presentationText = presentationText; }
    }

    public static class Module1SymptomTracker {
        private int totalHistoricalVisits;
        private List<SymptomTrackerItem> symptomItems = new ArrayList<>();
        private String longitudinalSummary;

        public int getTotalHistoricalVisits() { return totalHistoricalVisits; }
        public void setTotalHistoricalVisits(int totalHistoricalVisits) { this.totalHistoricalVisits = totalHistoricalVisits; }
        public List<SymptomTrackerItem> getSymptomItems() { return symptomItems; }
        public void setSymptomItems(List<SymptomTrackerItem> symptomItems) { this.symptomItems = symptomItems; }
        public String getLongitudinalSummary() { return longitudinalSummary; }
        public void setLongitudinalSummary(String longitudinalSummary) { this.longitudinalSummary = longitudinalSummary; }
    }

    // -------------------------------------------------------------
    // MODULE 2: Current Clinical Presentation
    // -------------------------------------------------------------
    public static class Module2CurrentPresentation {
        private String visitDate;
        private String presentingComplaint;
        private List<String> currentSymptoms = new ArrayList<>();
        private String symptomOnsetDuration;
        private String severity;
        private String temperatureCelsius;
        private String physicalExamFindings;
        private String priorTreatmentsNoted;
        private String rawDraftSummary;

        public String getVisitDate() { return visitDate; }
        public void setVisitDate(String visitDate) { this.visitDate = visitDate; }
        public String getPresentingComplaint() { return presentingComplaint; }
        public void setPresentingComplaint(String presentingComplaint) { this.presentingComplaint = presentingComplaint; }
        public List<String> getCurrentSymptoms() { return currentSymptoms; }
        public void setCurrentSymptoms(List<String> currentSymptoms) { this.currentSymptoms = currentSymptoms; }
        public String getSymptomOnsetDuration() { return symptomOnsetDuration; }
        public void setSymptomOnsetDuration(String symptomOnsetDuration) { this.symptomOnsetDuration = symptomOnsetDuration; }
        public String getSeverity() { return severity; }
        public void setSeverity(String severity) { this.severity = severity; }
        public String getTemperatureCelsius() { return temperatureCelsius; }
        public void setTemperatureCelsius(String temperatureCelsius) { this.temperatureCelsius = temperatureCelsius; }
        public String getPhysicalExamFindings() { return physicalExamFindings; }
        public void setPhysicalExamFindings(String physicalExamFindings) { this.physicalExamFindings = physicalExamFindings; }
        public String getPriorTreatmentsNoted() { return priorTreatmentsNoted; }
        public void setPriorTreatmentsNoted(String priorTreatmentsNoted) { this.priorTreatmentsNoted = priorTreatmentsNoted; }
        public String getRawDraftSummary() { return rawDraftSummary; }
        public void setRawDraftSummary(String rawDraftSummary) { this.rawDraftSummary = rawDraftSummary; }
    }

    // -------------------------------------------------------------
    // MODULE 3: Historical Comparison
    // -------------------------------------------------------------
    public static class Module3HistoricalComparison {
        private List<String> sharedSymptoms = new ArrayList<>();
        private List<String> newlyRecordedSymptoms = new ArrayList<>();
        private List<String> previouslyRecurringSymptoms = new ArrayList<>();
        private List<String> historicalSymptomsNotPresent = new ArrayList<>();
        private String severityTrajectory;
        private List<String> documentedTreatmentResponses = new ArrayList<>();
        private List<String> missingInformation = new ArrayList<>();

        public List<String> getSharedSymptoms() { return sharedSymptoms; }
        public void setSharedSymptoms(List<String> sharedSymptoms) { this.sharedSymptoms = sharedSymptoms; }
        public List<String> getNewlyRecordedSymptoms() { return newlyRecordedSymptoms; }
        public void setNewlyRecordedSymptoms(List<String> newlyRecordedSymptoms) { this.newlyRecordedSymptoms = newlyRecordedSymptoms; }
        public List<String> getPreviouslyRecurringSymptoms() { return previouslyRecurringSymptoms; }
        public void setPreviouslyRecurringSymptoms(List<String> previouslyRecurringSymptoms) { this.previouslyRecurringSymptoms = previouslyRecurringSymptoms; }
        public List<String> getHistoricalSymptomsNotPresent() { return historicalSymptomsNotPresent; }
        public void setHistoricalSymptomsNotPresent(List<String> historicalSymptomsNotPresent) { this.historicalSymptomsNotPresent = historicalSymptomsNotPresent; }
        public String getSeverityTrajectory() { return severityTrajectory; }
        public void setSeverityTrajectory(String severityTrajectory) { this.severityTrajectory = severityTrajectory; }
        public List<String> getDocumentedTreatmentResponses() { return documentedTreatmentResponses; }
        public void setDocumentedTreatmentResponses(List<String> documentedTreatmentResponses) { this.documentedTreatmentResponses = documentedTreatmentResponses; }
        public List<String> getMissingInformation() { return missingInformation; }
        public void setMissingInformation(List<String> missingInformation) { this.missingInformation = missingInformation; }
    }

    // -------------------------------------------------------------
    // MODULE 4: Possible Conditions to Consider
    // -------------------------------------------------------------
    public static class ConditionCandidate {
        private String conditionName;
        private List<String> supportingFindings = new ArrayList<>();
        private List<String> relevantHistoricalEvidence = new ArrayList<>();
        private List<String> findingsAgainst = new ArrayList<>();
        private List<String> missingInformation = new ArrayList<>();
        private List<String> distinguishingTestsOrExams = new ArrayList<>();
        private String uncertaintyNote;

        public String getConditionName() { return conditionName; }
        public void setConditionName(String conditionName) { this.conditionName = conditionName; }
        public List<String> getSupportingFindings() { return supportingFindings; }
        public void setSupportingFindings(List<String> supportingFindings) { this.supportingFindings = supportingFindings; }
        public List<String> getRelevantHistoricalEvidence() { return relevantHistoricalEvidence; }
        public void setRelevantHistoricalEvidence(List<String> relevantHistoricalEvidence) { this.relevantHistoricalEvidence = relevantHistoricalEvidence; }
        public List<String> getFindingsAgainst() { return findingsAgainst; }
        public void setFindingsAgainst(List<String> findingsAgainst) { this.findingsAgainst = findingsAgainst; }
        public List<String> getMissingInformation() { return missingInformation; }
        public void setMissingInformation(List<String> missingInformation) { this.missingInformation = missingInformation; }
        public List<String> getDistinguishingTestsOrExams() { return distinguishingTestsOrExams; }
        public void setDistinguishingTestsOrExams(List<String> distinguishingTestsOrExams) { this.distinguishingTestsOrExams = distinguishingTestsOrExams; }
        public String getUncertaintyNote() { return uncertaintyNote; }
        public void setUncertaintyNote(String uncertaintyNote) { this.uncertaintyNote = uncertaintyNote; }
    }

    public static class Module4ConditionsToConsider {
        private List<ConditionCandidate> candidateConditions = new ArrayList<>();
        private String professionalNotice;

        public List<ConditionCandidate> getCandidateConditions() { return candidateConditions; }
        public void setCandidateConditions(List<ConditionCandidate> candidateConditions) { this.candidateConditions = candidateConditions; }
        public String getProfessionalNotice() { return professionalNotice; }
        public void setProfessionalNotice(String professionalNotice) { this.professionalNotice = professionalNotice; }
    }

    // -------------------------------------------------------------
    // MODULE 5: Risk Indicators and Clinical Concerns
    // -------------------------------------------------------------
    public static class Module5RiskIndicators {
        private List<String> recordedClinicalFacts = new ArrayList<>();
        private List<String> deterministicRuleFlags = new ArrayList<>();
        private List<String> aiInterpretations = new ArrayList<>();
        private String urgencyLevel; // ROUTINE, ELEVATED, CRITICAL_ATTENTION

        public List<String> getRecordedClinicalFacts() { return recordedClinicalFacts; }
        public void setRecordedClinicalFacts(List<String> recordedClinicalFacts) { this.recordedClinicalFacts = recordedClinicalFacts; }
        public List<String> getDeterministicRuleFlags() { return deterministicRuleFlags; }
        public void setDeterministicRuleFlags(List<String> deterministicRuleFlags) { this.deterministicRuleFlags = deterministicRuleFlags; }
        public List<String> getAiInterpretations() { return aiInterpretations; }
        public void setAiInterpretations(List<String> aiInterpretations) { this.aiInterpretations = aiInterpretations; }
        public String getUrgencyLevel() { return urgencyLevel; }
        public void setUrgencyLevel(String urgencyLevel) { this.urgencyLevel = urgencyLevel; }
    }

    // -------------------------------------------------------------
    // MODULE 6: Recommended Next Steps
    // -------------------------------------------------------------
    public static class Module6RecommendedNextSteps {
        private List<String> historyToObtain = new ArrayList<>();
        private List<String> observationsToVerify = new ArrayList<>();
        private List<String> examinationsToConsider = new ArrayList<>();
        private List<String> followUpConsiderations = new ArrayList<>();
        private String veterinaryDecisionNotice = "No autonomous prescription. Treatment and diagnostics remain strictly the veterinarian's responsibility.";

        public List<String> getHistoryToObtain() { return historyToObtain; }
        public void setHistoryToObtain(List<String> historyToObtain) { this.historyToObtain = historyToObtain; }
        public List<String> getObservationsToVerify() { return observationsToVerify; }
        public void setObservationsToVerify(List<String> observationsToVerify) { this.observationsToVerify = observationsToVerify; }
        public List<String> getExaminationsToConsider() { return examinationsToConsider; }
        public void setExaminationsToConsider(List<String> examinationsToConsider) { this.examinationsToConsider = examinationsToConsider; }
        public List<String> getFollowUpConsiderations() { return followUpConsiderations; }
        public void setFollowUpConsiderations(List<String> followUpConsiderations) { this.followUpConsiderations = followUpConsiderations; }
        public String getVeterinaryDecisionNotice() { return veterinaryDecisionNotice; }
        public void setVeterinaryDecisionNotice(String veterinaryDecisionNotice) { this.veterinaryDecisionNotice = veterinaryDecisionNotice; }
    }

    // -------------------------------------------------------------
    // MODULE 7: Clinical Decision and Follow-up
    // -------------------------------------------------------------
    public static class Module7ClinicalDecisionTemplate {
        private String suggestedAssessmentPrompt;
        private String recommendedFollowUpWindow;
        private String ownerAdviceGuidance;
        private String practitionerActionNotice = "Veterinarian records final diagnosis, actual treatment administered, and follow-up plan upon visit submission.";

        public String getSuggestedAssessmentPrompt() { return suggestedAssessmentPrompt; }
        public void setSuggestedAssessmentPrompt(String suggestedAssessmentPrompt) { this.suggestedAssessmentPrompt = suggestedAssessmentPrompt; }
        public String getRecommendedFollowUpWindow() { return recommendedFollowUpWindow; }
        public void setRecommendedFollowUpWindow(String recommendedFollowUpWindow) { this.recommendedFollowUpWindow = recommendedFollowUpWindow; }
        public String getOwnerAdviceGuidance() { return ownerAdviceGuidance; }
        public void setOwnerAdviceGuidance(String ownerAdviceGuidance) { this.ownerAdviceGuidance = ownerAdviceGuidance; }
        public String getPractitionerActionNotice() { return practitionerActionNotice; }
        public void setPractitionerActionNotice(String practitionerActionNotice) { this.practitionerActionNotice = practitionerActionNotice; }
    }

    // Module instances
    private Module1SymptomTracker module1SymptomTracker;
    private Module2CurrentPresentation module2CurrentPresentation;
    private Module3HistoricalComparison module3HistoricalComparison;
    private Module4ConditionsToConsider module4ConditionsToConsider;
    private Module5RiskIndicators module5RiskIndicators;
    private Module6RecommendedNextSteps module6RecommendedNextSteps;
    private Module7ClinicalDecisionTemplate module7ClinicalDecision;

    public ClinicalIntelligenceResponse() {
        this.generatedAt = Instant.now();
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

    public boolean isDraftAnalysis() { return isDraftAnalysis; }
    public void setDraftAnalysis(boolean draftAnalysis) { isDraftAnalysis = draftAnalysis; }

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

    public Module1SymptomTracker getModule1SymptomTracker() { return module1SymptomTracker; }
    public void setModule1SymptomTracker(Module1SymptomTracker module1SymptomTracker) { this.module1SymptomTracker = module1SymptomTracker; }

    public Module2CurrentPresentation getModule2CurrentPresentation() { return module2CurrentPresentation; }
    public void setModule2CurrentPresentation(Module2CurrentPresentation module2CurrentPresentation) { this.module2CurrentPresentation = module2CurrentPresentation; }

    public Module3HistoricalComparison getModule3HistoricalComparison() { return module3HistoricalComparison; }
    public void setModule3HistoricalComparison(Module3HistoricalComparison module3HistoricalComparison) { this.module3HistoricalComparison = module3HistoricalComparison; }

    public Module4ConditionsToConsider getModule4ConditionsToConsider() { return module4ConditionsToConsider; }
    public void setModule4ConditionsToConsider(Module4ConditionsToConsider module4ConditionsToConsider) { this.module4ConditionsToConsider = module4ConditionsToConsider; }

    public Module5RiskIndicators getModule5RiskIndicators() { return module5RiskIndicators; }
    public void setModule5RiskIndicators(Module5RiskIndicators module5RiskIndicators) { this.module5RiskIndicators = module5RiskIndicators; }

    public Module6RecommendedNextSteps getModule6RecommendedNextSteps() { return module6RecommendedNextSteps; }
    public void setModule6RecommendedNextSteps(Module6RecommendedNextSteps module6RecommendedNextSteps) { this.module6RecommendedNextSteps = module6RecommendedNextSteps; }

    public Module7ClinicalDecisionTemplate getModule7ClinicalDecision() { return module7ClinicalDecision; }
    public void setModule7ClinicalDecision(Module7ClinicalDecisionTemplate module7ClinicalDecision) { this.module7ClinicalDecision = module7ClinicalDecision; }
}
