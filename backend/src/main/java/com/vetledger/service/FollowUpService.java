package com.vetledger.service;

import com.vetledger.dto.ClinicalFollowUpDto;
import com.vetledger.dto.CreateFollowUpRequest;
import com.vetledger.entity.Animal;
import com.vetledger.entity.ClinicalFollowUp;
import com.vetledger.entity.Visit;
import com.vetledger.exception.ResourceNotFoundException;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.ClinicalFollowUpRepository;
import com.vetledger.repository.VisitRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class FollowUpService {

    private final ClinicalFollowUpRepository followUpRepository;
    private final AnimalRepository animalRepository;
    private final VisitRepository visitRepository;

    public FollowUpService(ClinicalFollowUpRepository followUpRepository, AnimalRepository animalRepository, VisitRepository visitRepository) {
        this.followUpRepository = followUpRepository;
        this.animalRepository = animalRepository;
        this.visitRepository = visitRepository;
    }

    @Transactional(readOnly = true)
    public List<ClinicalFollowUpDto> getFollowUps(Long animalId, String status) {
        List<ClinicalFollowUp> list;
        if (animalId != null) {
            if (status != null && !status.trim().isEmpty()) {
                list = followUpRepository.findByAnimalIdAndStatusOrderByDueDateAsc(animalId, status.toUpperCase());
            } else {
                list = followUpRepository.findByAnimalIdOrderByDueDateAsc(animalId);
            }
        } else if (status != null && !status.trim().isEmpty()) {
            list = followUpRepository.findByStatusOrderByDueDateAsc(status.toUpperCase());
        } else {
            list = followUpRepository.findAll();
        }
        return list.stream().map(this::toDto).collect(Collectors.toList());
    }

    public ClinicalFollowUpDto createFollowUp(CreateFollowUpRequest req) {
        Animal animal = animalRepository.findById(req.getAnimalId())
                .orElseThrow(() -> new ResourceNotFoundException("Animal not found with id: " + req.getAnimalId()));

        Visit visit = null;
        if (req.getVisitId() != null) {
            visit = visitRepository.findById(req.getVisitId()).orElse(null);
        }

        ClinicalFollowUp fu = new ClinicalFollowUp();
        fu.setAnimal(animal);
        fu.setVisit(visit);
        fu.setReason(req.getReason());
        fu.setDueDate(req.getDueDate());
        fu.setStatus("PENDING");
        fu.setCompletionNotes(req.getNotes());

        ClinicalFollowUp saved = followUpRepository.save(fu);
        return toDto(saved);
    }

    public ClinicalFollowUpDto updateStatus(Long id, String status, String notes) {
        ClinicalFollowUp fu = followUpRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Follow-up not found with id: " + id));

        fu.setStatus(status.toUpperCase());
        if (notes != null && !notes.trim().isEmpty()) {
            fu.setCompletionNotes(notes);
        }
        if ("COMPLETED".equalsIgnoreCase(status)) {
            fu.setCompletedAt(OffsetDateTime.now());
        }

        ClinicalFollowUp saved = followUpRepository.save(fu);
        return toDto(saved);
    }

    private ClinicalFollowUpDto toDto(ClinicalFollowUp fu) {
        ClinicalFollowUpDto dto = new ClinicalFollowUpDto();
        dto.setId(fu.getId());
        dto.setAnimalId(fu.getAnimal().getId());
        dto.setAnimalCode(fu.getAnimal().getAnimalCode());
        dto.setAnimalName(fu.getAnimal().getName());
        if (fu.getAnimal().getFarm() != null) {
            dto.setFarmName(fu.getAnimal().getFarm().getFarmName());
            if (fu.getAnimal().getFarm().getVillage() != null) {
                dto.setVillageName(fu.getAnimal().getFarm().getVillage().getName());
            }
        }
        if (fu.getVisit() != null) {
            dto.setVisitId(fu.getVisit().getId());
        }
        dto.setReason(fu.getReason());
        dto.setDueDate(fu.getDueDate());
        dto.setStatus(fu.getStatus());
        dto.setCompletionNotes(fu.getCompletionNotes());
        dto.setCompletedAt(fu.getCompletedAt());
        dto.setCreatedAt(fu.getCreatedAt());
        return dto;
    }
}
