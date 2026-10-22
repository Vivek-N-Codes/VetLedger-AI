package com.vetledger.controller;

import com.vetledger.dto.AnimalDetailDto;
import com.vetledger.dto.AnimalSummaryDto;
import com.vetledger.dto.CreateAnimalRequest;
import com.vetledger.dto.VisitDto;
import com.vetledger.service.AnimalService;
import com.vetledger.service.VisitService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/animals")
public class AnimalController {

    private final AnimalService animalService;
    private final VisitService visitService;

    public AnimalController(AnimalService animalService, VisitService visitService) {
        this.animalService = animalService;
        this.visitService = visitService;
    }

    @GetMapping
    public ResponseEntity<List<AnimalSummaryDto>> searchAnimals(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String query,
            @RequestParam(required = false) Long villageId,
            @RequestParam(required = false) Long farmId,
            @RequestParam(required = false) String species) {
        String searchQuery = (search != null && !search.trim().isEmpty()) ? search : query;
        List<AnimalSummaryDto> animals = animalService.searchAnimals(searchQuery, villageId, farmId, species);
        return ResponseEntity.ok(animals);
    }

    @GetMapping("/{id}")
    public ResponseEntity<AnimalDetailDto> getAnimalById(@PathVariable Long id) {
        return ResponseEntity.ok(animalService.getAnimalDetail(id));
    }

    @GetMapping("/{id}/visits")
    public ResponseEntity<List<VisitDto>> getAnimalVisits(@PathVariable Long id) {
        return ResponseEntity.ok(visitService.getVisitsForAnimal(id));
    }

    @PostMapping
    public ResponseEntity<AnimalDetailDto> registerAnimal(@Valid @RequestBody CreateAnimalRequest request) {
        AnimalDetailDto created = animalService.registerAnimal(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
}
