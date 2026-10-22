package com.vetledger.service;

import com.vetledger.dto.AnimalDetailDto;
import com.vetledger.dto.AnimalSummaryDto;
import com.vetledger.dto.VisitDto;
import com.vetledger.entity.Animal;
import com.vetledger.entity.Visit;
import com.vetledger.exception.ResourceNotFoundException;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.VisitRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class AnimalService {

    private final AnimalRepository animalRepository;
    private final VisitRepository visitRepository;

    public AnimalService(AnimalRepository animalRepository, VisitRepository visitRepository) {
        this.animalRepository = animalRepository;
        this.visitRepository = visitRepository;
    }

    public List<AnimalSummaryDto> searchAnimals(String query, Long villageId, Long farmId, String species) {
        List<Animal> animals = animalRepository.searchAnimals(query, villageId, farmId, species);
        return animals.stream().map(this::mapToSummary).collect(Collectors.toList());
    }

    public AnimalDetailDto getAnimalDetail(Long id) {
        Animal animal = animalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Animal not found with id: " + id));

        List<Visit> visits = visitRepository.findByAnimalIdOrderByVisitDateDesc(id);

        AnimalDetailDto dto = new AnimalDetailDto();
        dto.setId(animal.getId());
        dto.setAnimalCode(animal.getAnimalCode());
        dto.setName(animal.getName());
        dto.setSpecies(animal.getSpecies());
        dto.setBreed(animal.getBreed());
        dto.setAgeYears(animal.getAgeYears());
        dto.setSex(animal.getSex());
        dto.setTagRfid(animal.getTagRfid());
        dto.setNotes(animal.getNotes());

        if (animal.getFarm() != null) {
            dto.setFarmId(animal.getFarm().getId());
            dto.setFarmCode(animal.getFarm().getFarmCode());
            dto.setFarmName(animal.getFarm().getFarmName());
            dto.setOwnerName(animal.getFarm().getOwnerName());
            dto.setContactNumber(animal.getFarm().getContactNumber());
            if (animal.getFarm().getVillage() != null) {
                dto.setVillageId(animal.getFarm().getVillage().getId());
                dto.setVillageName(animal.getFarm().getVillage().getName());
            }
        }

        List<VisitDto> visitDtos = visits.stream().map(this::mapVisitToDto).collect(Collectors.toList());
        dto.setVisits(visitDtos);

        return dto;
    }

    public AnimalSummaryDto mapToSummary(Animal a) {
        AnimalSummaryDto dto = new AnimalSummaryDto();
        dto.setId(a.getId());
        dto.setAnimalCode(a.getAnimalCode());
        dto.setName(a.getName());
        dto.setSpecies(a.getSpecies());
        dto.setBreed(a.getBreed());
        dto.setAgeYears(a.getAgeYears());
        dto.setSex(a.getSex());

        if (a.getFarm() != null) {
            dto.setFarmId(a.getFarm().getId());
            dto.setFarmName(a.getFarm().getFarmName());
            if (a.getFarm().getVillage() != null) {
                dto.setVillageId(a.getFarm().getVillage().getId());
                dto.setVillageName(a.getFarm().getVillage().getName());
            }
        }

        List<Visit> visits = visitRepository.findByAnimalIdOrderByVisitDateDesc(a.getId());
        dto.setTotalVisits(visits.size());
        if (!visits.isEmpty()) {
            Visit latest = visits.get(0);
            dto.setLastVisitDate(latest.getVisitDate());
            dto.setLastVisitComplaint(latest.getPresentingComplaint());
        }

        return dto;
    }

    public VisitDto mapVisitToDto(Visit v) {
        VisitDto dto = new VisitDto();
        dto.setId(v.getId());
        dto.setAnimalId(v.getAnimal().getId());
        dto.setAnimalCode(v.getAnimal().getAnimalCode());
        dto.setAnimalName(v.getAnimal().getName());
        if (v.getAnimal().getFarm() != null) {
            dto.setFarmName(v.getAnimal().getFarm().getFarmName());
            if (v.getAnimal().getFarm().getVillage() != null) {
                dto.setVillageName(v.getAnimal().getFarm().getVillage().getName());
            }
        }
        dto.setVisitDate(v.getVisitDate());
        dto.setPresentingComplaint(v.getPresentingComplaint());
        dto.setObservations(v.getObservations());
        dto.setSeverity(v.getSeverity());
        dto.setTemperatureCelsius(v.getTemperatureCelsius());
        dto.setTreatmentNotes(v.getTreatmentNotes());
        dto.setFollowUpNotes(v.getFollowUpNotes());
        dto.setCreatedAt(v.getCreatedAt());

        if (v.getSymptoms() != null) {
            dto.setSymptoms(v.getSymptoms().stream()
                    .map(s -> s.getSymptomCode())
                    .collect(Collectors.toList()));
        }

        return dto;
    }
}
