package com.vetledger;

import com.vetledger.dto.AnimalDetailDto;
import com.vetledger.dto.AnimalSummaryDto;
import com.vetledger.dto.CreateVisitRequest;
import com.vetledger.dto.VisitDto;
import com.vetledger.entity.Animal;
import com.vetledger.entity.Farm;
import com.vetledger.entity.Village;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.FarmRepository;
import com.vetledger.repository.VillageRepository;
import com.vetledger.repository.VisitRepository;
import com.vetledger.service.AnimalService;
import com.vetledger.service.VisitService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AnimalAndVisitIntegrationTest {

    @Autowired
    private AnimalService animalService;

    @Autowired
    private VisitService visitService;

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
        animal = animalRepository.save(new Animal(null, "COW-SNG-101", "Lakshmi", "Cattle", "Gir", BigDecimal.valueOf(4.5), "FEMALE", f, "RFID-001", "Healthy milker"));
    }

    @Test
    @DisplayName("Should search animals by query keyword")
    void testSearchAnimals() {
        List<AnimalSummaryDto> results = animalService.searchAnimals("Lakshmi", null, null, null);
        assertFalse(results.isEmpty());
        assertEquals("COW-SNG-101", results.get(0).getAnimalCode());

        List<AnimalSummaryDto> byCode = animalService.searchAnimals("101", null, null, null);
        assertFalse(byCode.isEmpty());
        assertEquals("Lakshmi", byCode.get(0).getName());
    }

    @Test
    @DisplayName("Should persist new clinical visit and refresh animal timeline")
    void testCreateVisitAndPersist() {
        CreateVisitRequest req = new CreateVisitRequest();
        req.setAnimalId(animal.getId());
        req.setVisitDate(LocalDate.now());
        req.setPresentingComplaint("Sudden onset fever and appetite reduction");
        req.setObservations("Rectal temperature 40.1°C, dull demeanor");
        req.setSeverity("SEVERE");
        req.setTemperatureCelsius(BigDecimal.valueOf(40.1));
        req.setTreatmentNotes("Administered NSAID and hydration fluid");
        req.setFollowUpNotes("Re-evaluate in 24 hours");
        req.setSymptoms(Arrays.asList("FEVER", "REDUCED_APPETITE"));

        VisitDto created = visitService.createVisit(req);

        assertNotNull(created);
        assertNotNull(created.getId());
        assertEquals(animal.getId(), created.getAnimalId());
        assertEquals("SEVERE", created.getSeverity());
        assertEquals(2, created.getSymptoms().size());
        assertTrue(created.getSymptoms().contains("FEVER"));

        // Verify retrieval via animal detail
        AnimalDetailDto detail = animalService.getAnimalDetail(animal.getId());
        assertNotNull(detail);
        assertEquals(1, detail.getVisits().size());
        assertEquals("Sudden onset fever and appetite reduction", detail.getVisits().get(0).getPresentingComplaint());
    }
}
