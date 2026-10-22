package com.vetledger.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class HealthController {

    private final JdbcTemplate jdbcTemplate;

    public HealthController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> getHealth() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("timestamp", Instant.now());
        response.put("application", "VetLedger AI");
        response.put("version", "1.0.0-hackathon");

        try {
            Integer result = jdbcTemplate.queryForObject("SELECT 1", Integer.class);
            response.put("database", result != null && result == 1 ? "CONNECTED" : "UNKNOWN");
        } catch (Exception ex) {
            response.put("database", "DISCONNECTED: " + ex.getMessage());
        }

        return ResponseEntity.ok(response);
    }
}
