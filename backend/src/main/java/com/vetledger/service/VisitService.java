package com.vetledger.service;

import com.vetledger.dto.CreateVisitRequest;
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
@Transactional
public class VisitService {

    private final VisitRepository visitRepository;
    private final AnimalRepository animalRepository;
    private final AnimalService animalService;

    public VisitService(VisitRepository visitRepository, AnimalRepository animalRepository, AnimalService animalService) {
        this.visitRepository = visitRepository;
        this.animalRepository = animalRepository;
        this.animalService = animalService;
    }

    @Transactional(readOnly = true)
    public List<VisitDto> getVisitsForAnimal(Long animalId) {
        if (!animalRepository.existsById(animalId)) {
            throw new ResourceNotFoundException("Animal not found with id: " + animalId);
        }
        return visitRepository.findByAnimalIdOrderByVisitDateDesc(animalId)
                .stream()
                .map(animalService::mapVisitToDto)
                .collect(Collectors.toList());
    }

    public VisitDto createVisit(CreateVisitRequest request) {
        Animal animal = animalRepository.findById(request.getAnimalId())
                .orElseThrow(() -> new ResourceNotFoundException("Animal not found with id: " + request.getAnimalId()));

        Visit visit = new Visit();
        visit.setAnimal(animal);
        visit.setVisitDate(request.getVisitDate());
        visit.setPresentingComplaint(request.getPresentingComplaint());
        visit.setObservations(request.getObservations());
        visit.setSeverity(request.getSeverity() != null ? request.getSeverity() : "MODERATE");
        visit.setTemperatureCelsius(request.getTemperatureCelsius());
        visit.setTreatmentNotes(request.getTreatmentNotes());
        visit.setFollowUpNotes(request.getFollowUpNotes());

        if (request.getSymptoms() != null) {
            for (String symptomCode : request.getSymptoms()) {
                if (symptomCode != null && !symptomCode.trim().isEmpty()) {
                    visit.addSymptom(symptomCode.trim().toUpperCase(), visit.getSeverity());
                }
            }
        }

        Visit saved = visitRepository.save(visit);
        return animalService.mapVisitToDto(saved);
    }

    @Transactional(readOnly = true)
    public List<VisitDto> getRecentVisits() {
        return visitRepository.findTop10ByOrderByVisitDateDescIdDesc()
                .stream()
                .map(animalService::mapVisitToDto)
                .collect(Collectors.toList());
    }
}
