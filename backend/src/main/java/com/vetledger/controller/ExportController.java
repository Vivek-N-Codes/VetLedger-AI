package com.vetledger.controller;

import com.vetledger.service.ExportService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/export")
public class ExportController {

    private final ExportService exportService;

    public ExportController(ExportService exportService) {
        this.exportService = exportService;
    }

    @GetMapping(value = "/animals.csv", produces = "text/csv")
    public ResponseEntity<String> exportAnimals() {
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"vetledger_animals.csv\"")
                .contentType(MediaType.parseMediaType("text/csv"))
                .body(exportService.exportAnimalsCsv());
    }

    @GetMapping(value = "/visits.csv", produces = "text/csv")
    public ResponseEntity<String> exportVisits() {
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"vetledger_visits.csv\"")
                .contentType(MediaType.parseMediaType("text/csv"))
                .body(exportService.exportVisitsCsv());
    }

    @GetMapping(value = "/ledger.csv", produces = "text/csv")
    public ResponseEntity<String> exportLedger() {
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"vetledger_owner_ledger.csv\"")
                .contentType(MediaType.parseMediaType("text/csv"))
                .body(exportService.exportLedgerCsv());
    }
}
