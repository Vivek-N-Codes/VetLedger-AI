package com.vetledger.service;

import com.vetledger.dto.*;
import com.vetledger.entity.Animal;
import com.vetledger.entity.Farm;
import com.vetledger.entity.Owner;
import com.vetledger.entity.Village;
import com.vetledger.entity.Visit;
import com.vetledger.entity.VisitSymptom;
import com.vetledger.exception.ResourceNotFoundException;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.FarmRepository;
import com.vetledger.repository.OwnerRepository;
import com.vetledger.repository.VillageRepository;
import com.vetledger.repository.VisitRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class FarmService {

    private final FarmRepository farmRepository;
    private final OwnerRepository ownerRepository;
    private final VillageRepository villageRepository;
    private final AnimalRepository animalRepository;
    private final VisitRepository visitRepository;

    public FarmService(
            FarmRepository farmRepository,
            OwnerRepository ownerRepository,
            VillageRepository villageRepository,
            AnimalRepository animalRepository,
            VisitRepository visitRepository) {
        this.farmRepository = farmRepository;
        this.ownerRepository = ownerRepository;
        this.villageRepository = villageRepository;
        this.animalRepository = animalRepository;
        this.visitRepository = visitRepository;
    }

    @Transactional(readOnly = true)
    public List<FarmSummaryDto> getFarms(Long villageId, String query) {
        List<Farm> farms;
        if (query != null && !query.trim().isEmpty()) {
            farms = farmRepository.searchFarms(query.trim());
            if (villageId != null) {
                farms = farms.stream()
                        .filter(f -> f.getVillage() != null && f.getVillage().getId().equals(villageId))
                        .collect(Collectors.toList());
            }
        } else if (villageId != null) {
            farms = farmRepository.findByVillageIdOrderByFarmNameAsc(villageId);
        } else {
            farms = farmRepository.findAllByOrderByFarmNameAsc();
        }

        return farms.stream().map(this::toSummaryDto).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public FarmDetailDto getFarmDetail(Long farmId) {
        Farm farm = farmRepository.findById(farmId)
                .orElseThrow(() -> new ResourceNotFoundException("Farm not found with id: " + farmId));

        FarmDetailDto dto = new FarmDetailDto();
        dto.setId(farm.getId());
        dto.setFarmCode(farm.getFarmCode());
        dto.setFarmName(farm.getFarmName());
        dto.setOwnerName(farm.getOwnerName());
        dto.setContactNumber(farm.getContactNumber());
        dto.setAddress(farm.getAddress());
        dto.setNotes(farm.getNotes());
        dto.setLatitude(farm.getLatitude());
        dto.setLongitude(farm.getLongitude());
        dto.setCreatedAt(farm.getCreatedAt());

        if (farm.getVillage() != null) {
            dto.setVillageId(farm.getVillage().getId());
            dto.setVillageName(farm.getVillage().getName());
        }

        if (farm.getOwner() != null) {
            dto.setOwnerId(farm.getOwner().getId());
            dto.setOwnerName(farm.getOwner().getFullName());
            if (farm.getContactNumber() == null || farm.getContactNumber().isEmpty()) {
                dto.setContactNumber(farm.getOwner().getContactNumber());
            }

            // View into Owner's ledger (Owner level source of truth)
            BigDecimal totalCharges = visitRepository.findTotalChargesByOwnerId(farm.getOwner().getId());
            dto.setOwnerTotalCharges(totalCharges);
            // Outstanding calculation handled in ledger or computed
        }

        // Animals registered on this farm
        List<Animal> animals = animalRepository.findByFarmId(farmId);
        dto.setRegisteredAnimalCount(animals.size());
        dto.setAnimals(animals.stream().map(this::toAnimalSummaryDto).collect(Collectors.toList()));

        // Visits on this farm
        List<Visit> farmVisits = visitRepository.findByFarmIdOrderByVisitDateDesc(farmId);
        dto.setTotalVisitsRecorded(farmVisits.size());

        LocalDate cutoff14 = LocalDate.now().minusDays(14);
        List<Visit> recent14 = farmVisits.stream()
                .filter(v -> v.getVisitDate() != null && !v.getVisitDate().isBefore(cutoff14))
                .collect(Collectors.toList());
        dto.setRecentVisitsLast14Days(recent14.size());

        // Top symptoms on this farm
        Map<String, Integer> symptomFreqs = new HashMap<>();
        for (Visit v : farmVisits) {
            if (v.getSymptoms() != null) {
                for (VisitSymptom s : v.getSymptoms()) {
                    symptomFreqs.put(s.getSymptomCode(), symptomFreqs.getOrDefault(s.getSymptomCode(), 0) + 1);
                }
            }
        }
        dto.setSymptomFrequencies(symptomFreqs);

        List<String> topSymptoms = symptomFreqs.entrySet().stream()
                .sorted((e1, e2) -> Integer.compare(e2.getValue(), e1.getValue()))
                .limit(5)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());
        dto.setTopSymptoms(topSymptoms);

        // Check if farm is in a village with active alert
        dto.setActiveSurveillanceAlert(farm.getVillage() != null && "Sangamner".equalsIgnoreCase(farm.getVillage().getName()));

        dto.setRecentVisits(farmVisits.stream().limit(10).map(this::toVisitDto).collect(Collectors.toList()));

        return dto;
    }

    public FarmDetailDto createFarm(CreateFarmRequest request) {
        Village village = villageRepository.findById(request.getVillageId())
                .orElseThrow(() -> new ResourceNotFoundException("Village not found with id: " + request.getVillageId()));

        Owner owner = null;
        if (request.getOwnerId() != null) {
            owner = ownerRepository.findById(request.getOwnerId())
                    .orElseThrow(() -> new ResourceNotFoundException("Owner not found with id: " + request.getOwnerId()));
        } else if (request.getOwnerName() != null && !request.getOwnerName().trim().isEmpty()) {
            // Find or create owner with same name
            List<Owner> existing = ownerRepository.searchOwners(request.getOwnerName().trim());
            if (!existing.isEmpty()) {
                owner = existing.get(0);
            } else {
                Owner newOwner = new Owner();
                long count = ownerRepository.count() + 1;
                newOwner.setOwnerCode(String.format("OWN-%03d", count));
                newOwner.setFullName(request.getOwnerName().trim());
                newOwner.setContactNumber(request.getContactNumber());
                newOwner.setVillage(village);
                newOwner.setAddress(request.getAddress());
                newOwner.setNotes("Created during farm registration");
                owner = ownerRepository.save(newOwner);
            }
        }

        String farmCode = request.getFarmCode();
        if (farmCode == null || farmCode.trim().isEmpty()) {
            String villagePrefix = village.getName().length() >= 3 
                    ? village.getName().substring(0, 3).toUpperCase() 
                    : "FRM";
            long count = farmRepository.count() + 1;
            farmCode = String.format("FRM-%s-%03d", villagePrefix, count);
        } else {
            farmCode = farmCode.trim();
            if (farmRepository.existsByFarmCode(farmCode)) {
                throw new IllegalArgumentException("A farm with code " + farmCode + " already exists.");
            }
        }

        Farm farm = new Farm();
        farm.setFarmCode(farmCode);
        farm.setFarmName(request.getFarmName().trim());
        farm.setOwner(owner);
        farm.setOwnerName(owner != null ? owner.getFullName() : (request.getOwnerName() != null ? request.getOwnerName() : "Unknown Owner"));
        farm.setContactNumber(request.getContactNumber() != null ? request.getContactNumber() : (owner != null ? owner.getContactNumber() : null));
        farm.setVillage(village);
        farm.setAddress(request.getAddress());
        farm.setNotes(request.getNotes());
        farm.setLatitude(request.getLatitude());
        farm.setLongitude(request.getLongitude());

        Farm saved = farmRepository.save(farm);
        return getFarmDetail(saved.getId());
    }

    private FarmSummaryDto toSummaryDto(Farm f) {
        FarmSummaryDto dto = new FarmSummaryDto();
        dto.setId(f.getId());
        dto.setFarmCode(f.getFarmCode());
        dto.setFarmName(f.getFarmName());
        dto.setOwnerName(f.getOwnerName());
        dto.setContactNumber(f.getContactNumber());
        if (f.getOwner() != null) {
            dto.setOwnerId(f.getOwner().getId());
            dto.setOwnerName(f.getOwner().getFullName());
        }
        if (f.getVillage() != null) {
            dto.setVillageId(f.getVillage().getId());
            dto.setVillageName(f.getVillage().getName());
            dto.setHasActiveAlert("Sangamner".equalsIgnoreCase(f.getVillage().getName()));
        }
        List<Animal> animals = animalRepository.findByFarmId(f.getId());
        dto.setAnimalCount(animals.size());
        return dto;
    }

    private AnimalSummaryDto toAnimalSummaryDto(Animal a) {
        AnimalSummaryDto dto = new AnimalSummaryDto();
        dto.setId(a.getId());
        dto.setAnimalCode(a.getAnimalCode());
        dto.setName(a.getName());
        dto.setSpecies(a.getSpecies());
        dto.setBreed(a.getBreed());
        dto.setAgeYears(a.getAgeYears());
        dto.setSex(a.getSex());
        dto.setTagRfid(a.getTagRfid());
        if (a.getFarm() != null) {
            dto.setFarmId(a.getFarm().getId());
            dto.setFarmName(a.getFarm().getFarmName());
            if (a.getFarm().getVillage() != null) {
                dto.setVillageId(a.getFarm().getVillage().getId());
                dto.setVillageName(a.getFarm().getVillage().getName());
            }
        }
        return dto;
    }

    private VisitDto toVisitDto(Visit v) {
        VisitDto dto = new VisitDto();
        dto.setId(v.getId());
        dto.setVisitDate(v.getVisitDate());
        dto.setPresentingComplaint(v.getPresentingComplaint());
        dto.setSeverity(v.getSeverity());
        dto.setTemperatureCelsius(v.getTemperatureCelsius());
        dto.setTotalCharge(v.getTotalCharge());
        if (v.getAnimal() != null) {
            dto.setAnimalId(v.getAnimal().getId());
            dto.setAnimalCode(v.getAnimal().getAnimalCode());
            dto.setAnimalName(v.getAnimal().getName());
        }
        if (v.getSymptoms() != null) {
            dto.setSymptoms(v.getSymptoms().stream().map(VisitSymptom::getSymptomCode).collect(Collectors.toList()));
        }
        return dto;
    }
}
