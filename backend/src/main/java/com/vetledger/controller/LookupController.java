package com.vetledger.controller;

import com.vetledger.entity.Farm;
import com.vetledger.entity.Village;
import com.vetledger.repository.FarmRepository;
import com.vetledger.repository.VillageRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api")
public class LookupController {

    private final VillageRepository villageRepository;
    private final FarmRepository farmRepository;

    public LookupController(VillageRepository villageRepository, FarmRepository farmRepository) {
        this.villageRepository = villageRepository;
        this.farmRepository = farmRepository;
    }

    @GetMapping("/villages")
    public ResponseEntity<List<Village>> getVillages() {
        return ResponseEntity.ok(villageRepository.findAllByOrderByNameAsc());
    }

    @PostMapping("/villages")
    public ResponseEntity<Village> createVillage(@RequestBody Map<String, Object> req) {
        String name = (String) req.get("name");
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Village name is required");
        }
        String cleanName = name.trim();
        Optional<Village> existing = villageRepository.findByName(cleanName);
        if (existing.isPresent()) {
            return ResponseEntity.ok(existing.get()); // Prevent duplicate records, return existing
        }

        String district = (String) req.getOrDefault("district", "Ahmednagar");
        String state = (String) req.getOrDefault("state", "Maharashtra");
        Double lat = req.containsKey("latitude") ? Double.valueOf(req.get("latitude").toString()) : 19.5761;
        Double lng = req.containsKey("longitude") ? Double.valueOf(req.get("longitude").toString()) : 74.2070;

        Village v = new Village(null, cleanName, district, state, lat, lng);
        Village saved = villageRepository.save(v);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @GetMapping("/farms-lookup")
    public ResponseEntity<List<Farm>> getFarmsLookup(@RequestParam(required = false) Long villageId) {
        if (villageId != null) {
            return ResponseEntity.ok(farmRepository.findByVillageIdOrderByFarmNameAsc(villageId));
        }
        return ResponseEntity.ok(farmRepository.findAllByOrderByFarmNameAsc());
    }

    @GetMapping("/symptoms")
    public ResponseEntity<List<Map<String, String>>> getStandardSymptoms() {
        List<Map<String, String>> symptoms = new ArrayList<>();
        symptoms.add(Map.of("code", "FEVER", "label", "Fever / Hyperthermia", "description", "Elevated rectal temperature >39.5°C"));
        symptoms.add(Map.of("code", "NASAL_DISCHARGE", "label", "Nasal Discharge", "description", "Bilateral seromucous or purulent discharge"));
        symptoms.add(Map.of("code", "REDUCED_APPETITE", "label", "Reduced Appetite", "description", "Partial or complete anorexia, ruminal stasis"));
        symptoms.add(Map.of("code", "COUGH", "label", "Cough / Respiratory Rales", "description", "Dry or moist cough with bronchial sounds"));
        symptoms.add(Map.of("code", "DIARRHEA", "label", "Diarrhea / Scouring", "description", "Watery or hemorrhagic enteritis"));
        symptoms.add(Map.of("code", "LETHARGY", "label", "Lethargy / Dull Demeanor", "description", "Depression, reluctance to rise, drooping ears"));
        symptoms.add(Map.of("code", "EXCESSIVE_SALIVATION", "label", "Excessive Salivation", "description", "Frothy or stringy drooling from oral lesions"));
        symptoms.add(Map.of("code", "REDUCED_MILK_PRODUCTION", "label", "Reduced Milk Yield", "description", "Acute drop in daily milk production"));
        return ResponseEntity.ok(symptoms);
    }
}
