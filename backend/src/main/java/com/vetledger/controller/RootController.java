package com.vetledger.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
public class RootController {

    @GetMapping("/")
    public ResponseEntity<Map<String, Object>> root() {
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("service", "VetLedger AI REST API");
        res.put("status", "UP");
        res.put("message", "VetLedger AI Backend is operational and connected to PostgreSQL database.");
        res.put("timestamp", Instant.now().toString());
        
        Map<String, String> endpoints = new LinkedHashMap<>();
        endpoints.put("health", "/api/health");
        endpoints.put("dashboard", "/api/dashboard");
        endpoints.put("animals", "/api/animals");
        endpoints.put("farms", "/api/farms");
        endpoints.put("surveillance", "/api/surveillance/clusters");
        endpoints.put("ledger", "/api/ledger/owners");
        res.put("endpoints", endpoints);

        return ResponseEntity.ok(res);
    }
}
