package com.vetledger;

import com.vetledger.dto.ClusterDetailDto;
import com.vetledger.dto.SurveillanceClusterDto;
import com.vetledger.entity.Animal;
import com.vetledger.entity.Farm;
import com.vetledger.entity.Village;
import com.vetledger.entity.Visit;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.FarmRepository;
import com.vetledger.repository.VillageRepository;
import com.vetledger.repository.VisitRepository;
import com.vetledger.service.SurveillanceEngineService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class SurveillanceEngineServiceTest {

    @Autowired
    private SurveillanceEngineService surveillanceEngineService;

    @Autowired
    private VillageRepository villageRepository;

    @Autowired
    private FarmRepository farmRepository;

    @Autowired
    private AnimalRepository animalRepository;

    @Autowired
    private VisitRepository visitRepository;

    private Village sangamner;
    private Village rahata;

    @BeforeEach
    void setUp() {
        visitRepository.deleteAll();
        animalRepository.deleteAll();
        farmRepository.deleteAll();
        villageRepository.deleteAll();

        sangamner = villageRepository.save(new Village(null, "Sangamner", "Ahmednagar", "Maharashtra", 19.5772, 74.2185));
        rahata = villageRepository.save(new Village(null, "Rahata", "Ahmednagar", "Maharashtra", 19.6976, 74.4921));
    }

    @Test
    @DisplayName("Should detect seeded cluster: 17 distinct animals across 6 farms within 14-day window")
    void testDetectSeededCluster() {
        // Create 6 farms in Sangamner
        Farm[] farms = new Farm[6];
        for (int i = 0; i < 6; i++) {
            farms[i] = farmRepository.save(new Farm(null, "FARM-SNG-0" + (i + 1), "Farm " + (i + 1), "Owner " + (i + 1), "982200000" + i, sangamner, 19.57, 74.21));
        }

        // Seed 17 distinct animals across the 6 farms
        LocalDate now = LocalDate.of(2026, 10, 22);
        for (int i = 0; i < 17; i++) {
            Farm f = farms[i % 6];
            Animal a = animalRepository.save(new Animal(null, "COW-SNG-" + (100 + i), "Animal " + i, "Cattle", "Gir", BigDecimal.valueOf(3.5), "FEMALE", f, "RFID-" + i, "Notes"));

            Visit v = new Visit(null, a, now.minusDays(i % 10), "Acute fever and nasal discharge", "Lung rales present", "SEVERE", BigDecimal.valueOf(40.2), "Supportive", "Isolate");
            v.addSymptom("FEVER", "SEVERE");
            v.addSymptom("NASAL_DISCHARGE", "MODERATE");
            v.addSymptom("REDUCED_APPETITE", "SEVERE");
            visitRepository.save(v);
        }

        // Add repeat visit for animal 0 (must NOT increase distinct animal count!)
        Animal firstAnimal = animalRepository.findByAnimalCode("COW-SNG-100").orElseThrow();
        Visit repeatVisit = new Visit(null, firstAnimal, now.minusDays(1), "Follow up check", "Still febrile", "MODERATE", BigDecimal.valueOf(39.8), "Continued therapy", "Review");
        repeatVisit.addSymptom("FEVER", "MODERATE");
        repeatVisit.addSymptom("NASAL_DISCHARGE", "MODERATE");
        visitRepository.save(repeatVisit);

        // Run surveillance engine
        List<SurveillanceClusterDto> clusters = surveillanceEngineService.detectClusters(14);

        assertNotNull(clusters);
        assertFalse(clusters.isEmpty(), "Cluster must be detected for Sangamner");

        SurveillanceClusterDto cluster = clusters.get(0);
        assertEquals("Sangamner", cluster.getVillageName());
        assertEquals(17, cluster.getDistinctAnimalCount(), "Distinct animal count must be exactly 17 despite repeat visits");
        assertEquals(6, cluster.getAffectedFarmCount(), "Must span 6 distinct farms");
        assertTrue(cluster.getSharedSymptoms().contains("FEVER"));
        assertTrue(cluster.getSharedSymptoms().contains("NASAL_DISCHARGE"));
        assertTrue(cluster.getSharedSymptoms().contains("REDUCED_APPETITE"));
        assertEquals("HIGH", cluster.getRiskLevel());
    }

    @Test
    @DisplayName("Should return cluster detail with affected animals and farms")
    void testGetClusterDetail() {
        Farm f1 = farmRepository.save(new Farm(null, "FARM-SNG-01", "Patil Farm", "Ramesh", "9822000001", sangamner, 19.57, 74.21));
        Farm f2 = farmRepository.save(new Farm(null, "FARM-SNG-02", "Shinde Farm", "Balasaheb", "9822000002", sangamner, 19.57, 74.21));
        Farm f3 = farmRepository.save(new Farm(null, "FARM-SNG-03", "Deshmukh Farm", "Sunil", "9822000003", sangamner, 19.57, 74.21));

        LocalDate now = LocalDate.of(2026, 10, 22);
        for (int i = 0; i < 6; i++) {
            Farm f = (i < 2) ? f1 : (i < 4 ? f2 : f3);
            Animal a = animalRepository.save(new Animal(null, "ANM-" + i, "Name " + i, "Cattle", "Gir", BigDecimal.valueOf(3.0), "FEMALE", f, "RFID-" + i, ""));
            Visit v = new Visit(null, a, now.minusDays(i), "Complaint", "Obs", "SEVERE", BigDecimal.valueOf(40.1), "Rx", "Fx");
            v.addSymptom("FEVER", "SEVERE");
            v.addSymptom("NASAL_DISCHARGE", "SEVERE");
            visitRepository.save(v);
        }

        ClusterDetailDto detail = surveillanceEngineService.getClusterDetail("Sangamner", 14);

        assertNotNull(detail);
        assertEquals("Sangamner", detail.getVillageName());
        assertEquals(6, detail.getDistinctAnimalCount());
        assertEquals(3, detail.getAffectedFarmCount());
        assertEquals(6, detail.getAffectedAnimals().size());
        assertEquals(3, detail.getAffectedFarms().size());
        assertFalse(detail.getRecommendedFieldActions().isEmpty());
    }

    @Test
    @DisplayName("Should NOT trigger alert when cases are below threshold or isolated")
    void testNoAlertWhenCasesBelowThreshold() {
        Farm f = farmRepository.save(new Farm(null, "FARM-RHT-01", "Sai Farm", "Ganesh", "9822000005", rahata, 19.69, 74.49));
        Animal a = animalRepository.save(new Animal(null, "COW-RHT-01", "Gauri", "Cattle", "HF Cross", BigDecimal.valueOf(4.0), "FEMALE", f, "RFID-RHT", ""));

        Visit v = new Visit(null, a, LocalDate.now(), "Isolated mild diarrhea", "Normal lungs", "MILD", BigDecimal.valueOf(38.6), "Electrolytes", "None");
        v.addSymptom("DIARRHEA", "MILD");
        visitRepository.save(v);

        List<SurveillanceClusterDto> clusters = surveillanceEngineService.detectClusters(14);
        assertTrue(clusters.isEmpty(), "Single isolated case must not trigger a surveillance cluster");
    }
}
