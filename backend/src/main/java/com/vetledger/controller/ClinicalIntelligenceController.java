package com.vetledger.controller;

import com.vetledger.dto.AnalyzeDraftRequest;
import com.vetledger.dto.ClinicalIntelligenceResponse;
import com.vetledger.service.ClinicalIntelligenceService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class ClinicalIntelligenceController {

    private final ClinicalIntelligenceService clinicalIntelligenceService;

    public ClinicalIntelligenceController(ClinicalIntelligenceService clinicalIntelligenceService) {
        this.clinicalIntelligenceService = clinicalIntelligenceService;
    }

    @PostMapping("/api/animals/{id}/clinical-intelligence")
    public ResponseEntity<ClinicalIntelligenceResponse> getClinicalIntelligence(@PathVariable Long id) {
        ClinicalIntelligenceResponse response = clinicalIntelligenceService.generateIntelligence(id);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/api/animals/{id}/clinical-intelligence")
    public ResponseEntity<ClinicalIntelligenceResponse> getClinicalIntelligenceGet(@PathVariable Long id) {
        ClinicalIntelligenceResponse response = clinicalIntelligenceService.generateIntelligence(id);
        return ResponseEntity.ok(response);
    }

    @PostMapping({"/api/intelligence/analyze-draft", "/api/animals/draft-analysis"})
    public ResponseEntity<ClinicalIntelligenceResponse> analyzeDraft(@Valid @RequestBody AnalyzeDraftRequest draft) {
        ClinicalIntelligenceResponse response = clinicalIntelligenceService.generateDraftIntelligence(draft);
        return ResponseEntity.ok(response);
    }
}
