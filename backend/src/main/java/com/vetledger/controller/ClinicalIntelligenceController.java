package com.vetledger.controller;

import com.vetledger.dto.ClinicalIntelligenceResponse;
import com.vetledger.service.ClinicalIntelligenceService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/animals")
public class ClinicalIntelligenceController {

    private final ClinicalIntelligenceService clinicalIntelligenceService;

    public ClinicalIntelligenceController(ClinicalIntelligenceService clinicalIntelligenceService) {
        this.clinicalIntelligenceService = clinicalIntelligenceService;
    }

    @PostMapping("/{id}/clinical-intelligence")
    public ResponseEntity<ClinicalIntelligenceResponse> getClinicalIntelligence(@PathVariable Long id) {
        ClinicalIntelligenceResponse response = clinicalIntelligenceService.generateIntelligence(id);
        return ResponseEntity.ok(response);
    }
}
