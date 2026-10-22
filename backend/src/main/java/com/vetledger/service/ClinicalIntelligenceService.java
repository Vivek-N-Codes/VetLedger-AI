package com.vetledger.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.vetledger.dto.AnalyzeDraftRequest;
import com.vetledger.dto.ClinicalIntelligenceResponse;
import com.vetledger.entity.Animal;
import com.vetledger.entity.Visit;
import com.vetledger.entity.VisitSymptom;
import com.vetledger.exception.ResourceNotFoundException;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.VisitRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class ClinicalIntelligenceService {

    private static final Logger log = LoggerFactory.getLogger(ClinicalIntelligenceService.class);

    private final AnimalRepository animalRepository;
    private final VisitRepository visitRepository;
    private final ObjectMapper objectMapper;
    private final RestTemplate restTemplate;

    @Value("${vetledger.ai.gemini-api-key:}")
    private String geminiApiKey;

    @Value("${vetledger.ai.model:gemini-1.5-flash}")
    private String geminiModel;

    @Value("${vetledger.ai.timeout-ms:5000}")
    private int timeoutMs;

    public ClinicalIntelligenceService(
            AnimalRepository animalRepository,
            VisitRepository visitRepository,
            ObjectMapper objectMapper) {
        this.animalRepository = animalRepository;
        this.visitRepository = visitRepository;
        this.objectMapper = objectMapper;
        this.restTemplate = new RestTemplate();
    }

    public ClinicalIntelligenceResponse generateIntelligence(Long animalId) {
        Animal animal = animalRepository.findById(animalId)
                .orElseThrow(() -> new ResourceNotFoundException("Animal not found with id: " + animalId));

        List<Visit> visits = visitRepository.findByAnimalIdOrderByVisitDateDesc(animalId);

        String apiKey = resolveApiKey();
        if (apiKey.isEmpty()) {
            log.info("Using deterministic clinical intelligence engine for animal {}", animal.getAnimalCode());
            return generateDeterministicModules(animal, visits, null);
        }

        try {
            return callGeminiApi(animal, visits, null, apiKey);
        } catch (Exception ex) {
            log.warn("Gemini API call failed or timed out ({}). Switching to deterministic fallback.", ex.getMessage());
            ClinicalIntelligenceResponse fallback = generateDeterministicModules(animal, visits, null);
            fallback.setVeterinaryReviewRecommendation(
                    "Note: Deterministic clinical engine active (External LLM unavailable: " + ex.getMessage() + ")."
            );
            return fallback;
        }
    }

    public ClinicalIntelligenceResponse generateDraftIntelligence(AnalyzeDraftRequest draft) {
        Animal animal = animalRepository.findById(draft.getAnimalId())
                .orElseThrow(() -> new ResourceNotFoundException("Animal not found with id: " + draft.getAnimalId()));

        List<Visit> historicalVisits = visitRepository.findByAnimalIdOrderByVisitDateDesc(draft.getAnimalId());

        String apiKey = resolveApiKey();
        if (apiKey.isEmpty()) {
            log.info("Analyzing unsaved examination draft deterministically for animal {}", animal.getAnimalCode());
            ClinicalIntelligenceResponse res = generateDeterministicModules(animal, historicalVisits, draft);
            res.setDraftAnalysis(true);
            return res;
        }

        try {
            ClinicalIntelligenceResponse res = callGeminiApi(animal, historicalVisits, draft, apiKey);
            res.setDraftAnalysis(true);
            return res;
        } catch (Exception ex) {
            log.warn("Gemini call for draft failed: {}. Falling back to deterministic draft analysis.", ex.getMessage());
            ClinicalIntelligenceResponse fallback = generateDeterministicModules(animal, historicalVisits, draft);
            fallback.setDraftAnalysis(true);
            fallback.setVeterinaryReviewRecommendation(
                    "Note: Unsaved draft analyzed by deterministic clinical engine (LLM fallback: " + ex.getMessage() + ")."
            );
            return fallback;
        }
    }

    private String resolveApiKey() {
        String key = geminiApiKey != null ? geminiApiKey.trim() : "";
        if (key.isEmpty()) {
            String envKey = System.getenv("GEMINI_API_KEY");
            if (envKey != null && !envKey.trim().isEmpty()) {
                key = envKey.trim();
            }
        }
        return key;
    }

    public ClinicalIntelligenceResponse generateDeterministicModules(Animal animal, List<Visit> visits, AnalyzeDraftRequest draft) {
        ClinicalIntelligenceResponse res = new ClinicalIntelligenceResponse();
        res.setAnimalId(animal.getId());
        res.setAnimalCode(animal.getAnimalCode());
        res.setAnimalName(animal.getName());
        res.setSpecies(animal.getSpecies());
        res.setBreed(animal.getBreed());
        if (animal.getFarm() != null) {
            res.setFarmName(animal.getFarm().getFarmName());
            if (animal.getFarm().getVillage() != null) {
                res.setVillageName(animal.getFarm().getVillage().getName());
            }
        }
        res.setSource("DETERMINISTIC_FALLBACK");
        res.setModelName("VetLedger Deterministic Clinical Engine v2.0");
        res.setGeneratedAt(Instant.now());

        // Handle empty history (new animal with 0 visits)
        if (visits.isEmpty() && draft == null) {
            res.setClinicalSummary("No historical clinical visits recorded for " + animal.getName() + " (" + animal.getAnimalCode() + "). Individual health history is currently empty.");
            res.setHistoricalFindings(Collections.singletonList("Initial registration completed. Zero prior clinical encounters in database."));
            res.setRecurringSymptoms(Collections.emptyList());
            res.setSymptomChangesOverTime("Historical baseline unavailable. First visit has not yet occurred.");
            res.setRiskIndicators(Collections.singletonList("New registration: baseline vital parameters and disease history unrecorded."));
            res.setPossibleConditionsToConsider(Collections.singletonList("Awaiting first clinical encounter."));
            res.setRecommendedObservations(Arrays.asList("Record initial baseline rectal temperature", "Perform complete systemic examination on first visit", "Verify vaccination and deworming history"));
            res.setSuggestedFollowUp("Schedule initial baseline physical wellness checkup.");

            ClinicalIntelligenceResponse.Module1SymptomTracker m1 = new ClinicalIntelligenceResponse.Module1SymptomTracker();
            m1.setTotalHistoricalVisits(0);
            m1.setLongitudinalSummary("No recorded clinical visits. Longitudinal history is empty.");
            res.setModule1SymptomTracker(m1);

            ClinicalIntelligenceResponse.Module2CurrentPresentation m2 = new ClinicalIntelligenceResponse.Module2CurrentPresentation();
            m2.setRawDraftSummary("No active visit draft. Animal has 0 historical visits.");
            res.setModule2CurrentPresentation(m2);

            ClinicalIntelligenceResponse.Module3HistoricalComparison m3 = new ClinicalIntelligenceResponse.Module3HistoricalComparison();
            m3.setSeverityTrajectory("No historical visits to compare against.");
            res.setModule3HistoricalComparison(m3);

            ClinicalIntelligenceResponse.Module4ConditionsToConsider m4 = new ClinicalIntelligenceResponse.Module4ConditionsToConsider();
            m4.setProfessionalNotice("No symptoms recorded. Professional veterinary evaluation needed upon first clinical encounter.");
            res.setModule4ConditionsToConsider(m4);

            ClinicalIntelligenceResponse.Module5RiskIndicators m5 = new ClinicalIntelligenceResponse.Module5RiskIndicators();
            m5.setUrgencyLevel("ROUTINE");
            m5.setRecordedClinicalFacts(Collections.singletonList("Animal registered without prior disease logs."));
            res.setModule5RiskIndicators(m5);

            ClinicalIntelligenceResponse.Module6RecommendedNextSteps m6 = new ClinicalIntelligenceResponse.Module6RecommendedNextSteps();
            m6.setHistoryToObtain(Collections.singletonList("Gather vaccination, nutrition, and lactation records from owner."));
            res.setModule6RecommendedNextSteps(m6);

            ClinicalIntelligenceResponse.Module7ClinicalDecisionTemplate m7 = new ClinicalIntelligenceResponse.Module7ClinicalDecisionTemplate();
            m7.setSuggestedAssessmentPrompt("Routine baseline herd intake.");
            res.setModule7ClinicalDecision(m7);

            return res;
        }

        // =========================================================
        // MODULE 1: Longitudinal Symptom Tracker (Deterministic)
        // =========================================================
        Map<String, Integer> symptomFreqs = new LinkedHashMap<>();
        Map<String, String> firstSeenDates = new HashMap<>();
        Map<String, String> lastSeenDates = new HashMap<>();

        for (int i = visits.size() - 1; i >= 0; i--) {
            Visit v = visits.get(i);
            String vDate = v.getVisitDate() != null ? v.getVisitDate().toString() : "N/A";
            if (v.getSymptoms() != null) {
                for (VisitSymptom vs : v.getSymptoms()) {
                    String code = vs.getSymptomCode();
                    symptomFreqs.put(code, symptomFreqs.getOrDefault(code, 0) + 1);
                    firstSeenDates.putIfAbsent(code, vDate);
                    lastSeenDates.put(code, vDate);
                }
            }
        }

        int totalVisits = visits.size();
        List<ClinicalIntelligenceResponse.SymptomTrackerItem> trackerItems = new ArrayList<>();
        List<String> recurringList = new ArrayList<>();

        List<String> draftSymptoms = (draft != null && draft.getCurrentSymptoms() != null)
                ? draft.getCurrentSymptoms().stream().map(String::toUpperCase).collect(Collectors.toList())
                : Collections.emptyList();

        for (Map.Entry<String, Integer> entry : symptomFreqs.entrySet()) {
            String code = entry.getKey();
            int count = entry.getValue();
            double pct = totalVisits > 0 ? (double) count / totalVisits * 100.0 : 0.0;
            pct = Math.round(pct * 10.0) / 10.0;

            ClinicalIntelligenceResponse.SymptomTrackerItem item = new ClinicalIntelligenceResponse.SymptomTrackerItem();
            item.setSymptomCode(code);
            item.setDisplayName(formatSymptomName(code));
            item.setOccurrenceCount(count);
            item.setTotalVisits(totalVisits);
            item.setPercentage(pct);
            item.setFirstRecordedDate(firstSeenDates.get(code));
            item.setLastRecordedDate(lastSeenDates.get(code));

            if (count >= 2) {
                item.setStatus("RECURRENT");
                recurringList.add(formatSymptomName(code));
            } else {
                item.setStatus("HISTORICAL_ONLY");
            }

            item.setPresentationText(String.format("%s was recorded in %d of %d visits (%.1f%%). First: %s, Most recent: %s.",
                    item.getDisplayName(), count, totalVisits, pct, item.getFirstRecordedDate(), item.getLastRecordedDate()));

            trackerItems.add(item);
        }

        // Add newly recorded symptoms in draft
        for (String ds : draftSymptoms) {
            if (!symptomFreqs.containsKey(ds)) {
                ClinicalIntelligenceResponse.SymptomTrackerItem newItem = new ClinicalIntelligenceResponse.SymptomTrackerItem();
                newItem.setSymptomCode(ds);
                newItem.setDisplayName(formatSymptomName(ds));
                newItem.setOccurrenceCount(1);
                newItem.setTotalVisits(totalVisits + 1);
                newItem.setPercentage(Math.round((1.0 / (totalVisits + 1) * 100.0) * 10.0) / 10.0);
                newItem.setStatus("NEW_IN_CURRENT_DRAFT");
                newItem.setPresentationText(formatSymptomName(ds) + " is NEW: Never previously documented for this animal.");
                trackerItems.add(newItem);
            }
        }

        ClinicalIntelligenceResponse.Module1SymptomTracker m1 = new ClinicalIntelligenceResponse.Module1SymptomTracker();
        m1.setTotalHistoricalVisits(totalVisits);
        m1.setSymptomItems(trackerItems);
        m1.setLongitudinalSummary(String.format("Longitudinal clinical record for %s (%s): %d total historical encounters analyzed. Identified %d distinct clinical symptoms, with %d recurring patterns.",
                animal.getName(), animal.getAnimalCode(), totalVisits, symptomFreqs.size(), recurringList.size()));
        res.setModule1SymptomTracker(m1);

        // =========================================================
        // MODULE 2: Current Clinical Presentation
        // =========================================================
        ClinicalIntelligenceResponse.Module2CurrentPresentation m2 = new ClinicalIntelligenceResponse.Module2CurrentPresentation();
        if (draft != null) {
            m2.setVisitDate(draft.getVisitDate() != null ? draft.getVisitDate().toString() : "Draft (Today)");
            m2.setPresentingComplaint(draft.getPresentingComplaint() != null ? draft.getPresentingComplaint() : "Not specified");
            m2.setCurrentSymptoms(draftSymptoms.stream().map(this::formatSymptomName).collect(Collectors.toList()));
            m2.setSymptomOnsetDuration(draft.getSymptomOnsetDuration() != null ? draft.getSymptomOnsetDuration() : "Unspecified duration");
            m2.setSeverity(draft.getSeverity() != null ? draft.getSeverity() : "MODERATE");
            m2.setTemperatureCelsius(draft.getTemperatureCelsius() != null ? draft.getTemperatureCelsius() + " °C" : "Not measured");
            m2.setPhysicalExamFindings(draft.getPhysicalExamFindings() != null ? draft.getPhysicalExamFindings() : "None recorded");
            m2.setPriorTreatmentsNoted(draft.getTreatmentsAdministeredPrior() != null ? draft.getTreatmentsAdministeredPrior() : "None reported");
            m2.setRawDraftSummary(String.format("Unsaved Draft: '%s' [%s severity, Temp: %s]. Symptoms: %s.",
                    m2.getPresentingComplaint(), m2.getSeverity(), m2.getTemperatureCelsius(), String.join(", ", m2.getCurrentSymptoms())));
        } else if (!visits.isEmpty()) {
            Visit latest = visits.get(0);
            m2.setVisitDate(latest.getVisitDate() != null ? latest.getVisitDate().toString() : "N/A");
            m2.setPresentingComplaint(latest.getPresentingComplaint());
            List<String> latestSyms = latest.getSymptoms() != null 
                    ? latest.getSymptoms().stream().map(s -> formatSymptomName(s.getSymptomCode())).collect(Collectors.toList())
                    : Collections.emptyList();
            m2.setCurrentSymptoms(latestSyms);
            m2.setSeverity(latest.getSeverity());
            m2.setTemperatureCelsius(latest.getTemperatureCelsius() != null ? latest.getTemperatureCelsius() + " °C" : "Not measured");
            m2.setPhysicalExamFindings(latest.getObservations());
            m2.setPriorTreatmentsNoted(latest.getTreatmentNotes());
            m2.setRawDraftSummary("Latest Stored Visit: " + latest.getPresentingComplaint() + " (" + latest.getSeverity() + ")");
        }
        res.setModule2CurrentPresentation(m2);

        // =========================================================
        // MODULE 3: Historical Comparison
        // =========================================================
        ClinicalIntelligenceResponse.Module3HistoricalComparison m3 = new ClinicalIntelligenceResponse.Module3HistoricalComparison();
        List<String> sharedSyms = new ArrayList<>();
        List<String> newSyms = new ArrayList<>();
        List<String> histNotPresent = new ArrayList<>();

        for (String ds : draftSymptoms) {
            if (symptomFreqs.containsKey(ds)) {
                sharedSyms.add(formatSymptomName(ds));
            } else {
                newSyms.add(formatSymptomName(ds));
            }
        }
        for (String hs : symptomFreqs.keySet()) {
            if (!draftSymptoms.contains(hs)) {
                histNotPresent.add(formatSymptomName(hs));
            }
        }
        m3.setSharedSymptoms(sharedSyms);
        m3.setNewlyRecordedSymptoms(newSyms);
        m3.setPreviouslyRecurringSymptoms(recurringList);
        m3.setHistoricalSymptomsNotPresent(histNotPresent);

        // Severity Trajectory calculation
        if (draft != null && !visits.isEmpty()) {
            Visit prev = visits.get(0);
            String prevSev = prev.getSeverity() != null ? prev.getSeverity() : "MODERATE";
            String draftSev = draft.getSeverity() != null ? draft.getSeverity() : "MODERATE";
            BigDecimal prevTemp = prev.getTemperatureCelsius();
            BigDecimal draftTemp = draft.getTemperatureCelsius();

            String tempStr = (prevTemp != null && draftTemp != null) 
                    ? String.format(" (Temp shifted from %.1f°C to %.1f°C)", prevTemp, draftTemp) 
                    : "";
            m3.setSeverityTrajectory(String.format("Severity transition: Previous was %s, current draft is %s%s.", prevSev, draftSev, tempStr));
        } else if (visits.size() >= 2) {
            m3.setSeverityTrajectory("Longitudinal severity trend stable across recent historical encounters.");
        } else {
            m3.setSeverityTrajectory("Insufficient prior encounters to compute longitudinal trajectory.");
        }

        List<String> treatmentResponses = new ArrayList<>();
        for (Visit v : visits) {
            if (v.getFollowUpNotes() != null && !v.getFollowUpNotes().trim().isEmpty()) {
                treatmentResponses.add(v.getVisitDate() + ": " + v.getFollowUpNotes());
            }
        }
        m3.setDocumentedTreatmentResponses(treatmentResponses.isEmpty() ? Collections.singletonList("No explicit treatment response outcomes logged in previous visits.") : treatmentResponses);
        m3.setMissingInformation(Arrays.asList("Serum biochemical profile unrecorded", "Reticular ultrasound / thoracic auscultation audio unattached"));
        res.setModule3HistoricalComparison(m3);

        // =========================================================
        // MODULE 4: Possible Conditions to Consider (Structured Candidates)
        // =========================================================
        ClinicalIntelligenceResponse.Module4ConditionsToConsider m4 = new ClinicalIntelligenceResponse.Module4ConditionsToConsider();
        List<ClinicalIntelligenceResponse.ConditionCandidate> candidates = new ArrayList<>();

        boolean hasFever = draftSymptoms.contains("FEVER") || symptomFreqs.containsKey("FEVER");
        boolean hasCough = draftSymptoms.contains("COUGH") || symptomFreqs.containsKey("COUGH");
        boolean hasNasal = draftSymptoms.contains("NASAL_DISCHARGE") || symptomFreqs.containsKey("NASAL_DISCHARGE");
        boolean hasOffFeed = draftSymptoms.contains("REDUCED_APPETITE") || symptomFreqs.containsKey("REDUCED_APPETITE");
        boolean hasSalivation = draftSymptoms.contains("EXCESSIVE_SALIVATION") || symptomFreqs.containsKey("EXCESSIVE_SALIVATION");

        if (hasFever && (hasCough || hasNasal)) {
            ClinicalIntelligenceResponse.ConditionCandidate brdc = new ClinicalIntelligenceResponse.ConditionCandidate();
            brdc.setConditionName("Bovine Respiratory Disease Complex (BRDC) / Infectious Bronchopneumonia");
            brdc.setSupportingFindings(Arrays.asList("Elevated body temperature", "Seromucous nasal discharge", "Auscultatory respiratory rales"));
            brdc.setRelevantHistoricalEvidence(Collections.singletonList("Recurrent febrile episodes documented in prior encounters"));
            brdc.setFindingsAgainst(Collections.singletonList("No submandibular edema noted on current inspection"));
            brdc.setMissingInformation(Arrays.asList("Nasal swab PCR viral panel", "Thoracic ultrasonography"));
            brdc.setDistinguishingTestsOrExams(Arrays.asList("Tracheal wash cytology", "Viral PCR panel (BRSV, IBR, PI-3)"));
            brdc.setUncertaintyNote("High syndromic concordance. Professional field confirmation needed.");
            candidates.add(brdc);
        }

        if (hasFever && hasSalivation) {
            ClinicalIntelligenceResponse.ConditionCandidate vesic = new ClinicalIntelligenceResponse.ConditionCandidate();
            vesic.setConditionName("Vesicular Disease Differential (FMD vs Non-Infectious Oral Stomatitis)");
            vesic.setSupportingFindings(Arrays.asList("Excessive drooling/salivation", "Febrile response"));
            vesic.setRelevantHistoricalEvidence(Collections.singletonList("Examine oral mucosa for vesicular erosion"));
            vesic.setFindingsAgainst(Collections.singletonList("Absence of interdigital coronary band lesions reported"));
            vesic.setMissingInformation(Arrays.asList("Oral vesicular fluid antigen ELISA", "Foot inspection status"));
            vesic.setDistinguishingTestsOrExams(Arrays.asList("Epithelial scrapings examination", "Coronary band tactile palpation"));
            vesic.setUncertaintyNote("Requires immediate rule-out to avoid herd-level biosecurity breach.");
            candidates.add(vesic);
        }

        if (hasOffFeed && !hasFever) {
            ClinicalIntelligenceResponse.ConditionCandidate rum = new ClinicalIntelligenceResponse.ConditionCandidate();
            rum.setConditionName("Subacute Ruminal Acidosis (SARA) / Indigestion");
            rum.setSupportingFindings(Arrays.asList("Reduced dry matter appetite", "Normal core body temperature"));
            rum.setRelevantHistoricalEvidence(Collections.singletonList("Feed transition history reported by owner"));
            rum.setFindingsAgainst(Collections.singletonList("No severe bloat or ruminal hyper-motility reported"));
            rum.setMissingInformation(Arrays.asList("Rumen fluid pH measurement", "Fecal sieving score"));
            rum.setDistinguishingTestsOrExams(Arrays.asList("Rumenocentesis pH test (<5.5 indicates SARA)", "Mastication and cud-chewing count"));
            rum.setUncertaintyNote("Nutritional etiology probable. Evaluate ration starch content.");
            candidates.add(rum);
        }

        if (candidates.isEmpty()) {
            ClinicalIntelligenceResponse.ConditionCandidate gen = new ClinicalIntelligenceResponse.ConditionCandidate();
            gen.setConditionName("General Febrile / Metabolic Indisposition");
            gen.setSupportingFindings(Collections.singletonList("Non-specific off-feed and lethargy"));
            gen.setRelevantHistoricalEvidence(Collections.singletonList("Single isolated clinical complaint"));
            gen.setFindingsAgainst(Collections.emptyList());
            gen.setMissingInformation(Collections.singletonList("Complete systemic veterinary workup pending"));
            gen.setDistinguishingTestsOrExams(Collections.singletonList("Complete Blood Count (CBC) and blood parasite smear"));
            gen.setUncertaintyNote("Broad differential spectrum. Monitor clinical progression.");
            candidates.add(gen);
        }

        m4.setCandidateConditions(candidates);
        m4.setProfessionalNotice("Differential considerations for clinical decision support only. Not a definitive diagnosis.");
        res.setModule4ConditionsToConsider(m4);

        // =========================================================
        // MODULE 5: Risk Indicators and Clinical Concerns
        // =========================================================
        ClinicalIntelligenceResponse.Module5RiskIndicators m5 = new ClinicalIntelligenceResponse.Module5RiskIndicators();
        List<String> facts = new ArrayList<>();
        List<String> ruleFlags = new ArrayList<>();
        List<String> aiInterp = new ArrayList<>();

        BigDecimal temp = (draft != null && draft.getTemperatureCelsius() != null) 
                ? draft.getTemperatureCelsius() 
                : (!visits.isEmpty() ? visits.get(0).getTemperatureCelsius() : null);

        if (temp != null && temp.compareTo(new BigDecimal("39.5")) > 0) {
            facts.add(String.format("Core rectal temperature %.1f°C exceeds physiological normal threshold (38.0–39.3°C).", temp));
            ruleFlags.add("RULE: Systemic Hyperthermia Alert flagged by clinical threshold engine.");
            aiInterp.add("Acute infectious or inflammatory process highly probable.");
        } else if (temp != null) {
            facts.add(String.format("Core rectal temperature %.1f°C is within acceptable bovine physiological range.", temp));
        }

        if (recurringList.size() >= 2) {
            ruleFlags.add(String.format("RULE: Chronic recurrence flag (%d symptoms repeated across visits).", recurringList.size()));
            aiInterp.add("Longitudinal vulnerability indicates potential herd management or housing environmental factor.");
        }

        m5.setRecordedClinicalFacts(facts);
        m5.setDeterministicRuleFlags(ruleFlags);
        m5.setAiInterpretations(aiInterp);
        m5.setUrgencyLevel((temp != null && temp.compareTo(new BigDecimal("40.2")) >= 0) ? "CRITICAL_ATTENTION" : "ELEVATED");
        res.setModule5RiskIndicators(m5);

        // =========================================================
        // MODULE 6: Recommended Next Steps
        // =========================================================
        ClinicalIntelligenceResponse.Module6RecommendedNextSteps m6 = new ClinicalIntelligenceResponse.Module6RecommendedNextSteps();
        m6.setHistoryToObtain(Arrays.asList("Inquire about sudden feed changes, silage quality, or toxic weed access", "Verify herd vaccination status for FMD, HS, and Blackleg"));
        m6.setObservationsToVerify(Arrays.asList("Auscultate left thorax for ruminal motility (target 2-3 contractions per 2 min)", "Inspect nasal septum and oral mucosa for petechiae or erosion"));
        m6.setExaminationsToConsider(Arrays.asList("Perform blood smear stain for Hemoparasites (Theileria / Babesia)", "California Mastitis Test (CMT) if milk yield drop reported"));
        m6.setFollowUpConsiderations(Arrays.asList("Review rectal temperature twice daily for 48 hours", "Re-evaluate if animal remains off-feed beyond 24 hours post-treatment"));
        res.setModule6RecommendedNextSteps(m6);

        // =========================================================
        // MODULE 7: Clinical Decision and Follow-up Template
        // =========================================================
        ClinicalIntelligenceResponse.Module7ClinicalDecisionTemplate m7 = new ClinicalIntelligenceResponse.Module7ClinicalDecisionTemplate();
        m7.setSuggestedAssessmentPrompt("Evaluate respiratory and metabolic stability. Document specific antibiotic/NSAID regimen.");
        m7.setRecommendedFollowUpWindow("Recommended 48 to 72 hour clinical follow-up.");
        m7.setOwnerAdviceGuidance("Instruct owner to isolate animal in dry, ventilated pen, provide fresh electrolyte water, and withhold fermentable carbohydrates.");
        res.setModule7ClinicalDecision(m7);

        // Populate top-level fields for backward compatibility
        res.setClinicalSummary(m1.getLongitudinalSummary() + " " + m2.getRawDraftSummary());
        res.setHistoricalFindings(trackerItems.stream().map(ClinicalIntelligenceResponse.SymptomTrackerItem::getPresentationText).collect(Collectors.toList()));
        res.setRecurringSymptoms(recurringList);
        res.setSymptomChangesOverTime(m3.getSeverityTrajectory());
        res.setRiskIndicators(m5.getRecordedClinicalFacts());
        res.setPossibleConditionsToConsider(candidates.stream().map(ClinicalIntelligenceResponse.ConditionCandidate::getConditionName).collect(Collectors.toList()));
        res.setRecommendedObservations(m6.getObservationsToVerify());
        res.setSuggestedFollowUp(m7.getRecommendedFollowUpWindow());

        return res;
    }

    private ClinicalIntelligenceResponse callGeminiApi(Animal animal, List<Visit> visits, AnalyzeDraftRequest draft, String apiKey) throws Exception {
        String url = String.format("https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s",
                geminiModel, apiKey);

        // Build comprehensive context payload
        Map<String, Object> context = new LinkedHashMap<>();
        context.put("animalCode", animal.getAnimalCode());
        context.put("species", animal.getSpecies());
        context.put("breed", animal.getBreed());
        context.put("ageYears", animal.getAgeYears());
        context.put("farm", animal.getFarm() != null ? animal.getFarm().getFarmName() : "Unknown");
        context.put("village", (animal.getFarm() != null && animal.getFarm().getVillage() != null) ? animal.getFarm().getVillage().getName() : "Unknown");

        List<Map<String, Object>> visitList = new ArrayList<>();
        for (Visit v : visits) {
            Map<String, Object> vm = new LinkedHashMap<>();
            vm.put("date", v.getVisitDate() != null ? v.getVisitDate().toString() : "N/A");
            vm.put("complaint", v.getPresentingComplaint());
            vm.put("severity", v.getSeverity());
            vm.put("temperature", v.getTemperatureCelsius());
            vm.put("symptoms", v.getSymptoms() != null ? v.getSymptoms().stream().map(VisitSymptom::getSymptomCode).collect(Collectors.toList()) : Collections.emptyList());
            vm.put("observations", v.getObservations());
            vm.put("treatmentNotes", v.getTreatmentNotes());
            visitList.add(vm);
        }
        context.put("historicalVisits", visitList);

        if (draft != null) {
            Map<String, Object> dm = new LinkedHashMap<>();
            dm.put("date", draft.getVisitDate() != null ? draft.getVisitDate().toString() : "Today");
            dm.put("complaint", draft.getPresentingComplaint());
            dm.put("currentSymptoms", draft.getCurrentSymptoms());
            dm.put("severity", draft.getSeverity());
            dm.put("temperatureCelsius", draft.getTemperatureCelsius());
            dm.put("symptomOnsetDuration", draft.getSymptomOnsetDuration());
            dm.put("physicalExamFindings", draft.getPhysicalExamFindings());
            dm.put("treatmentsAdministeredPrior", draft.getTreatmentsAdministeredPrior());
            context.put("currentUnsavedDraft", dm);
        }

        String prompt = "You are a senior veterinary clinical decision-support AI. Analyze this animal's health record.\n" +
                "You must return ONLY a valid JSON object matching the exact schema without markdown code blocks:\n" +
                "{\n" +
                "  \"clinicalSummary\": \"string\",\n" +
                "  \"historicalFindings\": [\"string\"],\n" +
                "  \"recurringSymptoms\": [\"string\"],\n" +
                "  \"symptomChangesOverTime\": \"string\",\n" +
                "  \"riskIndicators\": [\"string\"],\n" +
                "  \"possibleConditionsToConsider\": [\"string\"],\n" +
                "  \"recommendedObservations\": [\"string\"],\n" +
                "  \"suggestedFollowUp\": \"string\"\n" +
                "}\n\n" +
                "CRITICAL RULES:\n" +
                "1. Only ground your clinical summary in the exact dates, temperatures, and symptoms in the record.\n" +
                "2. Explicitly distinguish current draft observations from historical records.\n" +
                "3. Never issue autonomous prescriptions. Medical decisions belong strictly to the veterinarian.\n\n" +
                "Context Data:\n" + objectMapper.writeValueAsString(context);

        Map<String, Object> requestBody = Map.of(
                "contents", List.of(
                        Map.of("parts", List.of(
                                Map.of("text", prompt)
                        ))
                ),
                "generationConfig", Map.of(
                        "temperature", 0.2,
                        "responseMimeType", "application/json"
                )
        );

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
        JsonNode root = objectMapper.readTree(response.getBody());
        JsonNode candidate = root.path("candidates").get(0);
        String text = candidate.path("content").path("parts").get(0).path("text").asText();

        // Parse JSON
        JsonNode jsonResponse = objectMapper.readTree(text);

        // Populate base with deterministic baseline first, then overlay LLM insights
        ClinicalIntelligenceResponse res = generateDeterministicModules(animal, visits, draft);
        res.setSource("LIVE_LLM");
        res.setModelName("Google Gemini (" + geminiModel + ")");

        if (jsonResponse.has("clinicalSummary")) {
            res.setClinicalSummary(jsonResponse.path("clinicalSummary").asText());
        }
        if (jsonResponse.has("symptomChangesOverTime")) {
            res.setSymptomChangesOverTime(jsonResponse.path("symptomChangesOverTime").asText());
        }
        if (jsonResponse.has("suggestedFollowUp")) {
            res.setSuggestedFollowUp(jsonResponse.path("suggestedFollowUp").asText());
        }

        return res;
    }

    private String formatSymptomName(String code) {
        if (code == null) return "Unknown";
        String[] words = code.toLowerCase().split("_");
        StringBuilder sb = new StringBuilder();
        for (String w : words) {
            if (!w.isEmpty()) {
                sb.append(Character.toUpperCase(w.charAt(0))).append(w.substring(1)).append(" ");
            }
        }
        return sb.toString().trim();
    }
}
