package com.vetledger.controller;

import com.vetledger.dto.DashboardStatsDto;
import com.vetledger.service.DashboardService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/dashboard")
    public ResponseEntity<DashboardStatsDto> getDashboard() {
        return ResponseEntity.ok(dashboardService.getDashboardStats());
    }
}
