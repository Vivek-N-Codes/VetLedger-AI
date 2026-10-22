package com.vetledger.controller;

import com.vetledger.dto.*;
import com.vetledger.service.LedgerService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ledger")
public class LedgerController {

    private final LedgerService ledgerService;

    public LedgerController(LedgerService ledgerService) {
        this.ledgerService = ledgerService;
    }

    @GetMapping("/owners")
    public ResponseEntity<List<OwnerLedgerSummaryDto>> getOwnerLedgers(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String search) {
        String effectiveQuery = (query != null && !query.trim().isEmpty()) ? query.trim()
                : (search != null && !search.trim().isEmpty()) ? search.trim() : null;
        return ResponseEntity.ok(ledgerService.getOwnerLedgers(effectiveQuery));
    }

    @GetMapping("/owners/{id}")
    public ResponseEntity<OwnerLedgerDetailDto> getOwnerLedgerDetail(@PathVariable Long id) {
        return ResponseEntity.ok(ledgerService.getOwnerLedgerDetail(id));
    }

    @PostMapping("/owners")
    public ResponseEntity<OwnerDto> createOwner(@Valid @RequestBody CreateOwnerRequest request) {
        OwnerDto created = ledgerService.createOwner(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PostMapping("/payments")
    public ResponseEntity<PaymentReceiptDto> recordPayment(@Valid @RequestBody CreatePaymentRequest request) {
        PaymentReceiptDto receipt = ledgerService.recordPayment(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(receipt);
    }

    @GetMapping("/payments/{id}/receipt")
    public ResponseEntity<PaymentReceiptDto> getPaymentReceipt(@PathVariable Long id) {
        return ResponseEntity.ok(ledgerService.getPaymentReceipt(id));
    }
}
