package com.vetledger.controller;

import com.vetledger.dto.ClusterDetailDto;
import com.vetledger.dto.SurveillanceClusterDto;
import com.vetledger.service.SurveillanceEngineService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/surveillance")
public class SurveillanceController {

    private final SurveillanceEngineService surveillanceEngineService;

    public SurveillanceController(SurveillanceEngineService surveillanceEngineService) {
        this.surveillanceEngineService = surveillanceEngineService;
    }

    @GetMapping("/clusters")
    public ResponseEntity<List<SurveillanceClusterDto>> getClusters(
            @RequestParam(required = false, defaultValue = "14") Integer windowDays) {
        List<SurveillanceClusterDto> clusters = surveillanceEngineService.detectClusters(windowDays);
        return ResponseEntity.ok(clusters);
    }

    @GetMapping("/clusters/{id}")
    public ResponseEntity<ClusterDetailDto> getClusterDetail(
            @PathVariable String id,
            @RequestParam(required = false, defaultValue = "14") Integer windowDays) {
        ClusterDetailDto detail = surveillanceEngineService.getClusterDetail(id, windowDays);
        return ResponseEntity.ok(detail);
    }
}
