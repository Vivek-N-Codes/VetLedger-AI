package com.vetledger;

import com.vetledger.dto.ClinicalIntelligenceResponse;
import com.vetledger.entity.Animal;
import com.vetledger.entity.Farm;
import com.vetledger.entity.Village;
import com.vetledger.entity.Visit;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.FarmRepository;
import com.vetledger.repository.VillageRepository;
import com.vetledger.repository.VisitRepository;
import com.vetledger.service.ClinicalIntelligenceService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class ClinicalIntelligenceServiceTest {

    @Autowired
    private ClinicalIntelligenceService clinicalIntelligenceService;

    @Autowired
    private VillageRepository villageRepository;

    @Autowired
    private FarmRepository farmRepository;

    @Autowired
    private AnimalRepository animalRepository;

    @Autowired
    private VisitRepository visitRepository;

    private Animal animal;

    @BeforeEach
    void setUp() {
        visitRepository.deleteAll();
        animalRepository.deleteAll();
        farmRepository.deleteAll();
        villageRepository.deleteAll();

        Village v = villageRepository.save(new Village(null, "Sangamner", "Ahmednagar", "Maharashtra", 19.5772, 74.2185));
        Farm f = farmRepository.save(new Farm(null, "FARM-SNG-01", "Patil Dairy", "Ramesh Patil", "9822011234", v, 19.578, 74.219));
        animal = animalRepository.save(new Animal(null, "COW-SNG-101", "Lakshmi", "Cattle", "Gir", BigDecimal.valueOf(4.5), "FEMALE", f, "RFID-001", "Milking stock"));

        // Historical visit 1
        Visit v1 = new Visit(null, animal, LocalDate.now().minusMonths(3), "Mild off-feed", "Low rumen fill", "MILD", BigDecimal.valueOf(38.8), "Digestive tonic", "Resolved");
        v1.addSymptom("REDUCED_APPETITE", "MILD");
        visitRepository.save(v1);

        // Historical visit 2 (Acute recent visit)
        Visit v2 = new Visit(null, animal, LocalDate.now().minusDays(2), "High fever, nasal discharge, off-feed", "Bilateral mucopurulent nasal exudate, lung rales", "SEVERE", BigDecimal.valueOf(40.4), "Meloxicam, Oxytetracycline", "Strict isolation pen");
        v2.addSymptom("FEVER", "SEVERE");
        v2.addSymptom("NASAL_DISCHARGE", "SEVERE");
        v2.addSymptom("REDUCED_APPETITE", "SEVERE");
        visitRepository.save(v2);
    }

    @Test
    @DisplayName("Should generate deterministic clinical intelligence fallback when API key is not present")
    void testDeterministicClinicalIntelligence() {
        ClinicalIntelligenceResponse res = clinicalIntelligenceService.generateIntelligence(animal.getId());

        assertNotNull(res);
        assertEquals(animal.getId(), res.getAnimalId());
        assertEquals("COW-SNG-101", res.getAnimalCode());
        assertEquals("DETERMINISTIC_FALLBACK", res.getSource(), "Must be clearly labelled as DETERMINISTIC_FALLBACK");
        assertNotNull(res.getClinicalSummary());
        assertTrue(res.getClinicalSummary().contains("Lakshmi"));
        assertTrue(res.getClinicalSummary().contains("COW-SNG-101"));

        // Check recurring symptoms
        assertNotNull(res.getRecurringSymptoms());
        assertFalse(res.getRecurringSymptoms().isEmpty());
        assertTrue(res.getRecurringSymptoms().stream().anyMatch(s -> s.contains("Reduced Appetite")), "Reduced Appetite appeared in both visits");

        // Check risk indicators
        assertNotNull(res.getRiskIndicators());
        assertTrue(res.getRiskIndicators().stream().anyMatch(r -> r.contains("Hyperthermia") || r.contains("40.4")), "Should detect high rectal fever risk");

        // Check differential considerations
        assertNotNull(res.getPossibleConditionsToConsider());
        assertTrue(res.getPossibleConditionsToConsider().stream().anyMatch(c -> c.contains("Respiratory") || c.contains("Pneumonia")));

        // Check recommendations & disclaimer
        assertNotNull(res.getRecommendedObservations());
        assertNotNull(res.getSuggestedFollowUp());
        assertNotNull(res.getDisclaimer());
        assertTrue(res.getDisclaimer().contains("Final assessment remains with a qualified veterinarian"));
    }
}
