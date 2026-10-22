package com.vetledger.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
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

        // Check if API key is present
        String apiKey = geminiApiKey != null ? geminiApiKey.trim() : "";
        if (apiKey.isEmpty()) {
            String envKey = System.getenv("GEMINI_API_KEY");
            if (envKey != null && !envKey.trim().isEmpty()) {
                apiKey = envKey.trim();
            }
        }

        if (apiKey.isEmpty()) {
            log.info("No Gemini API key detected. Using deterministic clinical intelligence engine for animal {}", animal.getAnimalCode());
            return generateDeterministicFallback(animal, visits);
        }

        try {
            return callGeminiApi(animal, visits, apiKey);
        } catch (Exception ex) {
            log.warn("Gemini LLM call failed or timed out ({}). Seamlessly switching to deterministic clinical fallback.", ex.getMessage());
            ClinicalIntelligenceResponse fallback = generateDeterministicFallback(animal, visits);
            fallback.setVeterinaryReviewRecommendation(
                    "Note: Remote LLM provider unavailable (" + ex.getClass().getSimpleName() + "). Evaluated by local clinical rules engine."
            );
            return fallback;
        }
    }

    private ClinicalIntelligenceResponse callGeminiApi(Animal animal, List<Visit> visits, String apiKey) throws Exception {
        String prompt = buildPrompt(animal, visits);

        String url = String.format(
                "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s",
                geminiModel, apiKey
        );

        Map<String, Object> textPart = new HashMap<>();
        textPart.put("text", prompt);

        Map<String, Object> contentObj = new HashMap<>();
        contentObj.put("parts", Collections.singletonList(textPart));

        Map<String, Object> generationConfig = new HashMap<>();
        generationConfig.put("response_mime_type", "application/json");
        generationConfig.put("temperature", 0.2);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("contents", Collections.singletonList(contentObj));
        requestBody.put("generationConfig", generationConfig);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);

        if (!response.getStatusCode().is2xxSuccessful() || response.getBody() == null) {
            throw new IllegalStateException("Gemini API returned status " + response.getStatusCode());
        }

        JsonNode root = objectMapper.readTree(response.getBody());
        JsonNode candidate = root.path("candidates").get(0);
        String jsonText = candidate.path("content").path("parts").get(0).path("text").asText();

        // Parse structured JSON returned by LLM
        JsonNode parsed = objectMapper.readTree(jsonText);

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

        res.setSource("LIVE_LLM");
        res.setModelName(geminiModel);
        res.setGeneratedAt(Instant.now());

        res.setClinicalSummary(parsed.path("clinicalSummary").asText());
        res.setHistoricalFindings(nodeToList(parsed.path("historicalFindings")));
        res.setRecurringSymptoms(nodeToList(parsed.path("recurringSymptoms")));
        res.setSymptomChangesOverTime(parsed.path("symptomChangesOverTime").asText());
        res.setRiskIndicators(nodeToList(parsed.path("riskIndicators")));
        res.setPossibleConditionsToConsider(nodeToList(parsed.path("possibleConditionsToConsider")));
        res.setRecommendedObservations(nodeToList(parsed.path("recommendedObservations")));
        res.setSuggestedFollowUp(parsed.path("suggestedFollowUp").asText());
        res.setVeterinaryReviewRecommendation(parsed.path("veterinaryReviewRecommendation").asText());

        return res;
    }

    private List<String> nodeToList(JsonNode arrayNode) {
        List<String> list = new ArrayList<>();
        if (arrayNode != null && arrayNode.isArray()) {
            for (JsonNode n : arrayNode) {
                list.add(n.asText());
            }
        }
        return list;
    }

    private String buildPrompt(Animal animal, List<Visit> visits) {
        StringBuilder sb = new StringBuilder();
        sb.append("You are a specialized veterinary clinical intelligence system providing decision support for licensed veterinarians.\n");
        sb.append("GROUNDING RULES:\n");
        sb.append("- Ground all analysis strictly in the provided animal records.\n");
        sb.append("- Do not invent symptoms, lab values, or dates.\n");
        sb.append("- Do NOT prescribe medications or make definitive diagnostic claims.\n");
        sb.append("- Frame conditions as 'Differential Considerations' for veterinary review.\n\n");

        sb.append(String.format("ANIMAL PROFILE:\nCode: %s\nName: %s\nSpecies: %s\nBreed: %s\nAge: %s yrs\nSex: %s\nFarm: %s\nVillage: %s\n\n",
                animal.getAnimalCode(), animal.getName(), animal.getSpecies(), animal.getBreed(),
                animal.getAgeYears(), animal.getSex(),
                animal.getFarm() != null ? animal.getFarm().getFarmName() : "Unknown",
                animal.getFarm() != null && animal.getFarm().getVillage() != null ? animal.getFarm().getVillage().getName() : "Unknown"
        ));

        sb.append("CLINICAL ENCOUNTER TIMELINE (Chronological, latest first):\n");
        for (Visit v : visits) {
            String symptoms = v.getSymptoms() != null
                    ? v.getSymptoms().stream().map(VisitSymptom::getSymptomCode).collect(Collectors.joining(", "))
                    : "None recorded";
            sb.append(String.format("- Date: %s | Complaint: %s | Severity: %s | Temp: %s°C | Symptoms: [%s] | Obs: %s | Treatment: %s\n",
                    v.getVisitDate(), v.getPresentingComplaint(), v.getSeverity(),
                    v.getTemperatureCelsius() != null ? v.getTemperatureCelsius() : "N/A",
                    symptoms, v.getObservations(), v.getTreatmentNotes()
            ));
        }

        sb.append("\nReturn a valid JSON object matching exactly this schema:\n");
        sb.append("{\n");
        sb.append("  \"clinicalSummary\": \"string\",\n");
        sb.append("  \"historicalFindings\": [\"string\"],\n");
        sb.append("  \"recurringSymptoms\": [\"string\"],\n");
        sb.append("  \"symptomChangesOverTime\": \"string\",\n");
        sb.append("  \"riskIndicators\": [\"string\"],\n");
        sb.append("  \"possibleConditionsToConsider\": [\"string\"],\n");
        sb.append("  \"recommendedObservations\": [\"string\"],\n");
        sb.append("  \"suggestedFollowUp\": \"string\",\n");
        sb.append("  \"veterinaryReviewRecommendation\": \"string\"\n");
        sb.append("}\n");

        return sb.toString();
    }

    /**
     * Deterministic, explainable fallback engine that analyzes actual stored records.
     */
    public ClinicalIntelligenceResponse generateDeterministicFallback(Animal animal, List<Visit> visits) {
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
        res.setModelName("VetLedger-Heuristics-Engine-v1");
        res.setGeneratedAt(Instant.now());

        if (visits == null || visits.isEmpty()) {
            res.setClinicalSummary("No historical clinical visits recorded for " + animal.getName() + " (" + animal.getAnimalCode() + "). Baseline longitudinal profile is empty.");
            res.setHistoricalFindings(Collections.singletonList("Initial registry entry only. No prior clinical episodes documented."));
            res.setRecurringSymptoms(Collections.emptyList());
            res.setSymptomChangesOverTime("Insufficient longitudinal data points to establish a trajectory.");
            res.setRiskIndicators(Collections.singletonList("Baseline record: uncharacterized veterinary history."));
            res.setPossibleConditionsToConsider(Collections.singletonList("Routine herd health baseline screening recommended."));
            res.setRecommendedObservations(Collections.singletonList("Establish baseline TPR (temperature, pulse, respiration) and ruminal motility score."));
            res.setSuggestedFollowUp("Schedule routine periodic herd health visit.");
            res.setVeterinaryReviewRecommendation("Conduct physical baseline examination upon next farm visit.");
            return res;
        }

        Visit latest = visits.get(0);
        int totalVisits = visits.size();

        // Analyze symptom frequencies across history
        Map<String, Integer> symptomFreq = new HashMap<>();
        int severeCount = 0;
        double maxTemp = 0.0;

        for (Visit v : visits) {
            if ("SEVERE".equalsIgnoreCase(v.getSeverity())) {
                severeCount++;
            }
            if (v.getTemperatureCelsius() != null && v.getTemperatureCelsius().doubleValue() > maxTemp) {
                maxTemp = v.getTemperatureCelsius().doubleValue();
            }
            if (v.getSymptoms() != null) {
                for (VisitSymptom s : v.getSymptoms()) {
                    symptomFreq.put(s.getSymptomCode(), symptomFreq.getOrDefault(s.getSymptomCode(), 0) + 1);
                }
            }
        }

        List<String> recurring = symptomFreq.entrySet().stream()
                .filter(e -> e.getValue() >= 2)
                .sorted((e1, e2) -> Integer.compare(e2.getValue(), e1.getValue()))
                .map(e -> String.format("%s (detected in %d of %d visits)", formatSymptomName(e.getKey()), e.getValue(), totalVisits))
                .collect(Collectors.toList());

        if (recurring.isEmpty() && !symptomFreq.isEmpty()) {
            recurring.add(formatSymptomName(symptomFreq.keySet().iterator().next()) + " (isolated occurrence in recent encounter)");
        }

        // Longitudinal trajectory
        String trajectory;
        if (latest.getSeverity().equalsIgnoreCase("SEVERE") && severeCount == 1) {
            trajectory = "Acute onset: Animal had mild/routine history previously but transitioned to acute presentation in recent encounter (" + latest.getVisitDate() + ").";
        } else if (severeCount > 1) {
            trajectory = "Recurrent / Chronic: Multiple severe presentations documented across historical timeline, indicating chronic vulnerability.";
        } else {
            trajectory = "Sub-acute / Stable: Clinical encounters reflect mild-to-moderate episodes with documented resolution between visits.";
        }

        // Summary
        String latestSymptoms = latest.getSymptoms() != null
                ? latest.getSymptoms().stream().map(s -> formatSymptomName(s.getSymptomCode())).collect(Collectors.joining(", "))
                : "None recorded";
        res.setClinicalSummary(String.format(
                "%s (%s), a %.1f-year-old %s %s, has %d recorded clinical visits dating back to %s. The most recent presentation on %s documented '%s' with symptoms: [%s]. Current status is classified as %s severity with recorded temperature of %s°C.",
                animal.getName(), animal.getAnimalCode(),
                animal.getAgeYears() != null ? animal.getAgeYears() : 0.0,
                animal.getBreed() != null ? animal.getBreed() : animal.getSpecies(),
                animal.getSpecies(),
                totalVisits,
                visits.get(visits.size() - 1).getVisitDate(),
                latest.getVisitDate(),
                latest.getPresentingComplaint(),
                latestSymptoms,
                latest.getSeverity(),
                latest.getTemperatureCelsius() != null ? latest.getTemperatureCelsius() : "N/A"
        ));

        // Historical findings
        List<String> findings = new ArrayList<>();
        findings.add(String.format("Longitudinal span: %d encounters over %s to %s.", totalVisits, visits.get(visits.size() - 1).getVisitDate(), latest.getVisitDate()));
        if (maxTemp > 39.5) {
            findings.add(String.format("Peak recorded body temperature: %.1f°C (indicating clinical febrile episodes).", maxTemp));
        }
        if (severeCount > 0) {
            findings.add(String.format("%d of %d visits required intensive veterinary intervention (severe classification).", severeCount, totalVisits));
        } else {
            findings.add("All historical encounters managed conservatively with mild/moderate presentation.");
        }
        res.setHistoricalFindings(findings);
        res.setRecurringSymptoms(recurring);
        res.setSymptomChangesOverTime(trajectory);

        // Risk indicators
        List<String> risks = new ArrayList<>();
        if (latest.getTemperatureCelsius() != null && latest.getTemperatureCelsius().doubleValue() >= 40.0) {
            risks.add(String.format("Hyperthermia: High rectal temperature (%.1f°C) indicates active systemic inflammatory or infectious response.", latest.getTemperatureCelsius()));
        }
        if (symptomFreq.containsKey("REDUCED_APPETITE") && (symptomFreq.containsKey("FEVER") || symptomFreq.containsKey("NASAL_DISCHARGE"))) {
            risks.add("Synergistic respiratory & metabolic stress: Co-occurrence of anorexia and respiratory/febrile indicators poses acute dehydration risk.");
        }
        if (symptomFreq.containsKey("REDUCED_MILK_PRODUCTION")) {
            risks.add("Economic lactation impact: Drop in milking output indicates significant systemic metabolic burden.");
        }
        if (risks.isEmpty()) {
            risks.add("Low acute risk profile based on current vital indicators and absence of high fever.");
        }
        res.setRiskIndicators(risks);

        // Differential considerations (carefully non-diagnostic)
        List<String> diffs = new ArrayList<>();
        if (symptomFreq.containsKey("FEVER") && symptomFreq.containsKey("NASAL_DISCHARGE")) {
            diffs.add("Bovine Respiratory Disease Complex (BRDC) / Enzootic Pneumonia spectrum (due to concurrent fever, nasal exudate, and off-feed status)");
            diffs.add("Early Hemorrhagic Septicemia (HS) prodromal phase (warrants active monitoring given regional endemicity)");
        }
        if (symptomFreq.containsKey("DIARRHEA")) {
            diffs.add("Infectious or parasitic enteritis (coccidiosis, colibacillosis, or nutritional scouring)");
        }
        if (symptomFreq.containsKey("REDUCED_MILK_PRODUCTION")) {
            diffs.add("Subclinical mastitis or systemic toxemia secondary to primary infection");
        }
        if (diffs.isEmpty()) {
            diffs.add("Non-specific sub-acute systemic indisposition");
            diffs.add("Transient dietary / environmental adaptation stress");
        }
        res.setPossibleConditionsToConsider(diffs);

        // Recommended observations
        List<String> obs = new ArrayList<>();
        obs.add("Auscultate lungs twice daily for abnormal bronchial rales, wheezes, or pleural friction rubs.");
        obs.add("Measure rectal temperature every 12 hours before morning and evening feeding.");
        obs.add("Assess hydration status via skin tent elasticity and eyeball recession.");
        obs.add("Monitor rumen contraction frequency (normal: 2–3 contractions per 2 minutes in left paralumbar fossa).");
        res.setRecommendedObservations(obs);

        // Follow up
        res.setSuggestedFollowUp("Isolate the animal in a well-ventilated, dry recovery stall. Re-evaluate within 24 to 48 hours. If rectal temperature fails to decrease after antipyretic administration, adjust therapeutic regimen.");
        res.setVeterinaryReviewRecommendation("Decision-Support Output: Final clinical diagnosis, pathogen verification, and drug selection remain the sole responsibility of the attending registered veterinarian.");

        return res;
    }

    private String formatSymptomName(String code) {
        if (code == null) return "";
        return Arrays.stream(code.split("_"))
                .map(word -> word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase())
                .collect(Collectors.joining(" "));
    }
}
