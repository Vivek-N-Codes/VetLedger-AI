package com.vetledger.controller;

import com.vetledger.dto.GlobalSearchResponse;
import com.vetledger.service.GlobalSearchService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/search")
public class SearchController {

    private final GlobalSearchService searchService;

    public SearchController(GlobalSearchService searchService) {
        this.searchService = searchService;
    }

    @GetMapping
    public ResponseEntity<GlobalSearchResponse> search(@RequestParam(required = false, defaultValue = "") String q) {
        return ResponseEntity.ok(searchService.search(q));
    }
}
