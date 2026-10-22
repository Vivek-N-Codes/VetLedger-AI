package com.vetledger.controller;

import com.vetledger.dto.ClinicalFollowUpDto;
import com.vetledger.dto.CreateFollowUpRequest;
import com.vetledger.service.FollowUpService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/follow-ups")
public class FollowUpController {

    private final FollowUpService followUpService;

    public FollowUpController(FollowUpService followUpService) {
        this.followUpService = followUpService;
    }

    @GetMapping
    public ResponseEntity<List<ClinicalFollowUpDto>> getFollowUps(
            @RequestParam(required = false) Long animalId,
            @RequestParam(required = false) String status) {
        return ResponseEntity.ok(followUpService.getFollowUps(animalId, status));
    }

    @PostMapping
    public ResponseEntity<ClinicalFollowUpDto> createFollowUp(@Valid @RequestBody CreateFollowUpRequest request) {
        ClinicalFollowUpDto created = followUpService.createFollowUp(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<ClinicalFollowUpDto> updateStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body) {
        String status = body.getOrDefault("status", "COMPLETED");
        String notes = body.get("notes");
        return ResponseEntity.ok(followUpService.updateStatus(id, status, notes));
    }
}
