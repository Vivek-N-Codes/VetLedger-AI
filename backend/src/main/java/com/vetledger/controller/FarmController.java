package com.vetledger.controller;

import com.vetledger.dto.CreateFarmRequest;
import com.vetledger.dto.FarmDetailDto;
import com.vetledger.dto.FarmSummaryDto;
import com.vetledger.service.FarmService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/farms")
public class FarmController {

    private final FarmService farmService;

    public FarmController(FarmService farmService) {
        this.farmService = farmService;
    }

    @GetMapping
    public ResponseEntity<List<FarmSummaryDto>> getFarms(
            @RequestParam(required = false) Long villageId,
            @RequestParam(required = false) String query) {
        return ResponseEntity.ok(farmService.getFarms(villageId, query));
    }

    @GetMapping("/{id}")
    public ResponseEntity<FarmDetailDto> getFarmDetail(@PathVariable Long id) {
        return ResponseEntity.ok(farmService.getFarmDetail(id));
    }

    @PostMapping
    public ResponseEntity<FarmDetailDto> createFarm(@Valid @RequestBody CreateFarmRequest request) {
        FarmDetailDto created = farmService.createFarm(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
}
