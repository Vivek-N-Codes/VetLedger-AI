package com.vetledger.controller;

import com.vetledger.dto.CreateVisitRequest;
import com.vetledger.dto.VisitDto;
import com.vetledger.service.VisitService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/visits")
public class VisitController {

    private final VisitService visitService;

    public VisitController(VisitService visitService) {
        this.visitService = visitService;
    }

    @PostMapping
    public ResponseEntity<VisitDto> createVisit(@Valid @RequestBody CreateVisitRequest request) {
        VisitDto created = visitService.createVisit(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @GetMapping("/recent")
    public ResponseEntity<List<VisitDto>> getRecentVisits() {
        return ResponseEntity.ok(visitService.getRecentVisits());
    }
}
