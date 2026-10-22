package com.vetledger.service;

import com.vetledger.dto.*;
import com.vetledger.entity.*;
import com.vetledger.exception.ResourceNotFoundException;
import com.vetledger.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class LedgerService {

    private final OwnerRepository ownerRepository;
    private final FarmRepository farmRepository;
    private final AnimalRepository animalRepository;
    private final VisitRepository visitRepository;
    private final PaymentRepository paymentRepository;
    private final PaymentAllocationRepository allocationRepository;
    private final VillageRepository villageRepository;

    public LedgerService(
            OwnerRepository ownerRepository,
            FarmRepository farmRepository,
            AnimalRepository animalRepository,
            VisitRepository visitRepository,
            PaymentRepository paymentRepository,
            PaymentAllocationRepository allocationRepository,
            VillageRepository villageRepository) {
        this.ownerRepository = ownerRepository;
        this.farmRepository = farmRepository;
        this.animalRepository = animalRepository;
        this.visitRepository = visitRepository;
        this.paymentRepository = paymentRepository;
        this.allocationRepository = allocationRepository;
        this.villageRepository = villageRepository;
    }

    @Transactional(readOnly = true)
    public List<OwnerLedgerSummaryDto> getOwnerLedgers(String query) {
        List<Owner> owners;
        if (query != null && !query.trim().isEmpty()) {
            owners = ownerRepository.searchOwners(query.trim());
        } else {
            owners = ownerRepository.findAllByOrderByFullNameAsc();
        }

        return owners.stream().map(this::computeOwnerSummary).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public OwnerLedgerDetailDto getOwnerLedgerDetail(Long ownerId) {
        Owner owner = ownerRepository.findById(ownerId)
                .orElseThrow(() -> new ResourceNotFoundException("Owner not found with id: " + ownerId));

        OwnerLedgerDetailDto dto = new OwnerLedgerDetailDto();
        dto.setOwnerId(owner.getId());
        dto.setOwnerCode(owner.getOwnerCode());
        dto.setFullName(owner.getFullName());
        dto.setContactNumber(owner.getContactNumber());
        dto.setEmail(owner.getEmail());
        dto.setAddress(owner.getAddress());
        if (owner.getVillage() != null) {
            dto.setVillageName(owner.getVillage().getName());
        }

        // Farms
        List<Farm> farms = farmRepository.findByOwnerIdOrderByFarmNameAsc(ownerId);
        dto.setFarms(farms.stream().map(f -> {
            FarmSummaryDto fs = new FarmSummaryDto();
            fs.setId(f.getId());
            fs.setFarmCode(f.getFarmCode());
            fs.setFarmName(f.getFarmName());
            fs.setOwnerId(owner.getId());
            fs.setOwnerName(owner.getFullName());
            if (f.getVillage() != null) {
                fs.setVillageName(f.getVillage().getName());
            }
            fs.setAnimalCount(animalRepository.findByFarmId(f.getId()).size());
            return fs;
        }).collect(Collectors.toList()));

        // Animals across all owner's farms
        List<AnimalSummaryDto> animalDtos = new ArrayList<>();
        for (Farm f : farms) {
            List<Animal> farmAnimals = animalRepository.findByFarmId(f.getId());
            for (Animal a : farmAnimals) {
                AnimalSummaryDto adto = new AnimalSummaryDto();
                adto.setId(a.getId());
                adto.setAnimalCode(a.getAnimalCode());
                adto.setName(a.getName());
                adto.setSpecies(a.getSpecies());
                adto.setBreed(a.getBreed());
                adto.setFarmId(f.getId());
                adto.setFarmName(f.getFarmName());
                animalDtos.add(adto);
            }
        }
        dto.setAnimals(animalDtos);

        // Visits with charges (Owner level source of truth)
        List<Visit> visits = visitRepository.findByOwnerIdOrderByVisitDateDesc(ownerId);
        dto.setVisitsWithCharges(visits.stream().map(this::toVisitDto).collect(Collectors.toList()));

        // Payments
        List<Payment> payments = paymentRepository.findByOwnerIdOrderByPaymentDateDescCreatedAtDesc(ownerId);
        dto.setPayments(payments.stream().map(this::toPaymentDto).collect(Collectors.toList()));

        // Computed balances
        BigDecimal totalCharges = visits.stream()
                .map(v -> v.getTotalCharge() != null ? v.getTotalCharge() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal totalPayments = payments.stream()
                .map(p -> p.getAmount() != null ? p.getAmount() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        dto.setTotalCharges(totalCharges);
        dto.setTotalPayments(totalPayments);
        dto.setOutstandingBalance(totalCharges.subtract(totalPayments));

        return dto;
    }

    public PaymentReceiptDto recordPayment(CreatePaymentRequest request) {
        Owner owner = ownerRepository.findById(request.getOwnerId())
                .orElseThrow(() -> new ResourceNotFoundException("Owner not found with id: " + request.getOwnerId()));

        if (request.getAmount() == null || request.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Payment amount must be greater than zero.");
        }

        // Calculate previous outstanding balance
        BigDecimal prevCharges = visitRepository.findTotalChargesByOwnerId(owner.getId());
        BigDecimal prevPayments = paymentRepository.findTotalPaidByOwnerId(owner.getId());
        BigDecimal previousBalance = prevCharges.subtract(prevPayments);

        // Generate unique payment number
        long count = paymentRepository.count() + 1;
        String paymentNumber = String.format("REC-%d-%04d", LocalDate.now().getYear(), count);
        while (paymentRepository.existsByPaymentNumber(paymentNumber)) {
            count++;
            paymentNumber = String.format("REC-%d-%04d", LocalDate.now().getYear(), count);
        }

        Payment payment = new Payment();
        payment.setPaymentNumber(paymentNumber);
        payment.setOwner(owner);
        payment.setAmount(request.getAmount());
        payment.setPaymentDate(request.getPaymentDate() != null ? request.getPaymentDate() : LocalDate.now());
        payment.setPaymentMethod(request.getPaymentMethod() != null ? request.getPaymentMethod().toUpperCase() : "CASH");
        payment.setReferenceNumber(request.getReferenceNumber());
        payment.setNotes(request.getNotes());

        Payment savedPayment = paymentRepository.save(payment);

        // Allocate payment to outstanding visits chronologically
        List<Visit> unpaidVisits = visitRepository.findByOwnerIdOrderByVisitDateDesc(owner.getId());
        Collections.reverse(unpaidVisits); // Oldest first for FIFO settlement

        BigDecimal remainingToAllocate = request.getAmount();
        List<PaymentReceiptDto.AllocationItem> allocationItems = new ArrayList<>();

        for (Visit v : unpaidVisits) {
            if (remainingToAllocate.compareTo(BigDecimal.ZERO) <= 0) break;

            BigDecimal vTotal = v.getTotalCharge() != null ? v.getTotalCharge() : BigDecimal.ZERO;
            BigDecimal alreadyAllocated = allocationRepository.findTotalAllocatedForVisit(v.getId());
            BigDecimal vOutstanding = vTotal.subtract(alreadyAllocated);

            if (vOutstanding.compareTo(BigDecimal.ZERO) > 0) {
                BigDecimal allocateNow = remainingToAllocate.min(vOutstanding);
                PaymentAllocation pa = new PaymentAllocation(null, savedPayment, v, allocateNow);
                allocationRepository.save(pa);

                remainingToAllocate = remainingToAllocate.subtract(allocateNow);

                allocationItems.add(new PaymentReceiptDto.AllocationItem(
                        v.getVisitDate() != null ? v.getVisitDate().toString() : "N/A",
                        v.getAnimal() != null ? v.getAnimal().getAnimalCode() : "N/A",
                        v.getAnimal() != null ? v.getAnimal().getName() : "N/A",
                        v.getPresentingComplaint(),
                        vTotal,
                        allocateNow
                ));
            }
        }

        // Generate receipt DTO
        BigDecimal remainingBalance = previousBalance.subtract(request.getAmount());

        PaymentReceiptDto receipt = new PaymentReceiptDto();
        receipt.setReceiptNumber(savedPayment.getPaymentNumber());
        receipt.setPaymentId(savedPayment.getId());
        receipt.setOwnerId(owner.getId());
        receipt.setOwnerCode(owner.getOwnerCode());
        receipt.setOwnerName(owner.getFullName());
        receipt.setContactNumber(owner.getContactNumber());
        receipt.setAddress(owner.getAddress());
        receipt.setPaymentDate(savedPayment.getPaymentDate());
        receipt.setAmountReceived(savedPayment.getAmount());
        receipt.setPaymentMethod(savedPayment.getPaymentMethod());
        receipt.setReferenceNumber(savedPayment.getReferenceNumber());
        receipt.setNotes(savedPayment.getNotes());
        receipt.setPreviousBalance(previousBalance);
        receipt.setRemainingBalance(remainingBalance);
        receipt.setIssuedAt(OffsetDateTime.now());
        receipt.setAllocatedVisits(allocationItems);

        return receipt;
    }

    @Transactional(readOnly = true)
    public PaymentReceiptDto getPaymentReceipt(Long paymentId) {
        Payment payment = paymentRepository.findById(paymentId)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with id: " + paymentId));
        Owner owner = payment.getOwner();

        BigDecimal prevCharges = visitRepository.findTotalChargesByOwnerId(owner.getId());
        BigDecimal allPayments = paymentRepository.findTotalPaidByOwnerId(owner.getId());

        List<PaymentAllocation> allocations = allocationRepository.findByPaymentId(paymentId);
        List<PaymentReceiptDto.AllocationItem> allocationItems = allocations.stream().map(pa -> {
            Visit v = pa.getVisit();
            return new PaymentReceiptDto.AllocationItem(
                    v.getVisitDate() != null ? v.getVisitDate().toString() : "N/A",
                    v.getAnimal() != null ? v.getAnimal().getAnimalCode() : "N/A",
                    v.getAnimal() != null ? v.getAnimal().getName() : "N/A",
                    v.getPresentingComplaint(),
                    v.getTotalCharge(),
                    pa.getAllocatedAmount()
            );
        }).collect(Collectors.toList());

        PaymentReceiptDto receipt = new PaymentReceiptDto();
        receipt.setReceiptNumber(payment.getPaymentNumber());
        receipt.setPaymentId(payment.getId());
        receipt.setOwnerId(owner.getId());
        receipt.setOwnerCode(owner.getOwnerCode());
        receipt.setOwnerName(owner.getFullName());
        receipt.setContactNumber(owner.getContactNumber());
        receipt.setAddress(owner.getAddress());
        receipt.setPaymentDate(payment.getPaymentDate());
        receipt.setAmountReceived(payment.getAmount());
        receipt.setPaymentMethod(payment.getPaymentMethod());
        receipt.setReferenceNumber(payment.getReferenceNumber());
        receipt.setNotes(payment.getNotes());
        receipt.setPreviousBalance(prevCharges.subtract(allPayments).add(payment.getAmount()));
        receipt.setRemainingBalance(prevCharges.subtract(allPayments));
        receipt.setIssuedAt(payment.getCreatedAt() != null ? payment.getCreatedAt() : OffsetDateTime.now());
        receipt.setAllocatedVisits(allocationItems);

        return receipt;
    }

    public OwnerDto createOwner(CreateOwnerRequest req) {
        String code = req.getOwnerCode();
        if (code == null || code.trim().isEmpty()) {
            long count = ownerRepository.count() + 1;
            code = String.format("OWN-%03d", count);
        } else {
            code = code.trim();
            if (ownerRepository.existsByOwnerCode(code)) {
                throw new IllegalArgumentException("An owner with code " + code + " already exists.");
            }
        }

        Village village = null;
        if (req.getVillageId() != null) {
            village = villageRepository.findById(req.getVillageId()).orElse(null);
        }

        Owner owner = new Owner();
        owner.setOwnerCode(code);
        owner.setFullName(req.getFullName().trim());
        owner.setContactNumber(req.getContactNumber());
        owner.setEmail(req.getEmail());
        owner.setAddress(req.getAddress());
        owner.setVillage(village);
        owner.setNotes(req.getNotes());

        Owner saved = ownerRepository.save(owner);
        OwnerDto dto = new OwnerDto();
        dto.setId(saved.getId());
        dto.setOwnerCode(saved.getOwnerCode());
        dto.setFullName(saved.getFullName());
        dto.setContactNumber(saved.getContactNumber());
        dto.setEmail(saved.getEmail());
        dto.setAddress(saved.getAddress());
        if (saved.getVillage() != null) {
            dto.setVillageId(saved.getVillage().getId());
            dto.setVillageName(saved.getVillage().getName());
        }
        return dto;
    }

    private OwnerLedgerSummaryDto computeOwnerSummary(Owner o) {
        OwnerLedgerSummaryDto dto = new OwnerLedgerSummaryDto();
        dto.setOwnerId(o.getId());
        dto.setOwnerCode(o.getOwnerCode());
        dto.setFullName(o.getFullName());
        dto.setContactNumber(o.getContactNumber());
        if (o.getVillage() != null) {
            dto.setVillageName(o.getVillage().getName());
        }

        List<Farm> farms = farmRepository.findByOwnerIdOrderByFarmNameAsc(o.getId());
        dto.setFarmCount(farms.size());

        int animalCount = 0;
        for (Farm f : farms) {
            animalCount += animalRepository.findByFarmId(f.getId()).size();
        }
        dto.setAnimalCount(animalCount);

        List<Visit> visits = visitRepository.findByOwnerIdOrderByVisitDateDesc(o.getId());
        dto.setTotalVisits(visits.size());
        if (!visits.isEmpty()) {
            dto.setLastVisitDate(visits.get(0).getVisitDate());
        }

        BigDecimal totalBilled = visits.stream()
                .map(v -> v.getTotalCharge() != null ? v.getTotalCharge() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        dto.setTotalBilled(totalBilled);

        BigDecimal totalPaid = paymentRepository.findTotalPaidByOwnerId(o.getId());
        dto.setTotalPaid(totalPaid);

        BigDecimal balance = totalBilled.subtract(totalPaid);
        dto.setOutstandingBalance(balance);

        if (balance.compareTo(BigDecimal.ZERO) > 0) {
            dto.setStatus("OUTSTANDING");
        } else if (balance.compareTo(BigDecimal.ZERO) < 0) {
            dto.setStatus("CREDIT");
        } else {
            dto.setStatus("CLEAR");
        }

        List<Payment> payments = paymentRepository.findByOwnerIdOrderByPaymentDateDescCreatedAtDesc(o.getId());
        if (!payments.isEmpty()) {
            dto.setLastPaymentDate(payments.get(0).getPaymentDate());
        }

        return dto;
    }

    private VisitDto toVisitDto(Visit v) {
        VisitDto dto = new VisitDto();
        dto.setId(v.getId());
        dto.setVisitDate(v.getVisitDate());
        dto.setPresentingComplaint(v.getPresentingComplaint());
        dto.setSeverity(v.getSeverity());
        dto.setConsultationFee(v.getConsultationFee());
        dto.setServiceFee(v.getServiceFee());
        dto.setMedicineFee(v.getMedicineFee());
        dto.setOtherFee(v.getOtherFee());
        dto.setTotalCharge(v.getTotalCharge());
        if (v.getAnimal() != null) {
            dto.setAnimalId(v.getAnimal().getId());
            dto.setAnimalCode(v.getAnimal().getAnimalCode());
            dto.setAnimalName(v.getAnimal().getName());
            if (v.getAnimal().getFarm() != null) {
                dto.setFarmName(v.getAnimal().getFarm().getFarmName());
            }
        }
        return dto;
    }

    private PaymentDto toPaymentDto(Payment p) {
        PaymentDto dto = new PaymentDto();
        dto.setId(p.getId());
        dto.setPaymentNumber(p.getPaymentNumber());
        dto.setOwnerId(p.getOwner().getId());
        dto.setOwnerName(p.getOwner().getFullName());
        dto.setAmount(p.getAmount());
        dto.setPaymentDate(p.getPaymentDate());
        dto.setPaymentMethod(p.getPaymentMethod());
        dto.setReferenceNumber(p.getReferenceNumber());
        dto.setNotes(p.getNotes());
        dto.setCreatedAt(p.getCreatedAt());
        return dto;
    }
}
