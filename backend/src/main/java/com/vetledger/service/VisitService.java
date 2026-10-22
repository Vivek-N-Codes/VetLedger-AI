package com.vetledger.service;

import com.vetledger.dto.CreateVisitRequest;
import com.vetledger.dto.VisitDto;
import com.vetledger.entity.Animal;
import com.vetledger.entity.ClinicalFollowUp;
import com.vetledger.entity.Visit;
import com.vetledger.entity.VisitSymptom;
import com.vetledger.exception.ResourceNotFoundException;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.ClinicalFollowUpRepository;
import com.vetledger.repository.VisitRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class VisitService {

    private final VisitRepository visitRepository;
    private final AnimalRepository animalRepository;
    private final ClinicalFollowUpRepository followUpRepository;

    public VisitService(VisitRepository visitRepository, AnimalRepository animalRepository, ClinicalFollowUpRepository followUpRepository) {
        this.visitRepository = visitRepository;
        this.animalRepository = animalRepository;
        this.followUpRepository = followUpRepository;
    }

    @Transactional(readOnly = true)
    public List<VisitDto> getVisitsForAnimal(Long animalId) {
        if (!animalRepository.existsById(animalId)) {
            throw new ResourceNotFoundException("Animal not found with id: " + animalId);
        }
        return visitRepository.findByAnimalIdOrderByVisitDateDesc(animalId)
                .stream()
                .map(this::mapVisitToDto)
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

        // Financial Charges (Owner Ledger)
        visit.setConsultationFee(request.getConsultationFee() != null ? request.getConsultationFee() : BigDecimal.ZERO);
        visit.setServiceFee(request.getServiceFee() != null ? request.getServiceFee() : BigDecimal.ZERO);
        visit.setMedicineFee(request.getMedicineFee() != null ? request.getMedicineFee() : BigDecimal.ZERO);
        visit.setOtherFee(request.getOtherFee() != null ? request.getOtherFee() : BigDecimal.ZERO);
        visit.calculateTotalCharge();

        // Clinical Decision Support & Examination Fields
        visit.setSymptomOnsetDuration(request.getSymptomOnsetDuration());
        visit.setPhysicalExamFindings(request.getPhysicalExamFindings());
        visit.setTreatmentsAdministeredPrior(request.getTreatmentsAdministeredPrior());
        visit.setPriorTreatmentResponse(request.getPriorTreatmentResponse());
        visit.setFinalClinicalAssessment(request.getFinalClinicalAssessment());
        visit.setActualTreatmentAdministered(request.getActualTreatmentAdministered());
        visit.setOwnerAdvice(request.getOwnerAdvice());
        visit.setFollowUpDueDate(request.getFollowUpDueDate());
        visit.setFollowUpStatus(request.getFollowUpDueDate() != null ? "SCHEDULED" : "NONE");

        if (request.getSymptoms() != null) {
            for (String symptomCode : request.getSymptoms()) {
                if (symptomCode != null && !symptomCode.trim().isEmpty()) {
                    visit.addSymptom(symptomCode.trim().toUpperCase(), visit.getSeverity());
                }
            }
        }

        Visit saved = visitRepository.save(visit);

        // Mark previously pending follow-ups for this animal as completed
        List<ClinicalFollowUp> pending = followUpRepository.findByAnimalIdAndStatusOrderByDueDateAsc(animal.getId(), "PENDING");
        for (ClinicalFollowUp p : pending) {
            p.setStatus("COMPLETED");
            p.setCompletedAt(OffsetDateTime.now());
            p.setCompletionNotes("Resolved / evaluated in clinical encounter on " + saved.getVisitDate());
            followUpRepository.save(p);
        }

        // If veterinarian scheduled a new follow-up date, record it
        if (request.getFollowUpDueDate() != null) {
            ClinicalFollowUp fu = new ClinicalFollowUp();
            fu.setAnimal(animal);
            fu.setVisit(saved);
            fu.setDueDate(request.getFollowUpDueDate());
            fu.setReason(request.getFollowUpNotes() != null && !request.getFollowUpNotes().trim().isEmpty() 
                    ? request.getFollowUpNotes() 
                    : "Follow-up review for: " + request.getPresentingComplaint());
            fu.setStatus("PENDING");
            followUpRepository.save(fu);
        }

        return mapVisitToDto(saved);
    }

    @Transactional(readOnly = true)
    public List<VisitDto> getRecentVisits() {
        return visitRepository.findTop10ByOrderByVisitDateDescIdDesc()
                .stream()
                .map(this::mapVisitToDto)
                .collect(Collectors.toList());
    }

    public VisitDto mapVisitToDto(Visit v) {
        VisitDto dto = new VisitDto();
        dto.setId(v.getId());
        dto.setVisitDate(v.getVisitDate());
        dto.setPresentingComplaint(v.getPresentingComplaint());
        dto.setObservations(v.getObservations());
        dto.setSeverity(v.getSeverity());
        dto.setTemperatureCelsius(v.getTemperatureCelsius());
        dto.setTreatmentNotes(v.getTreatmentNotes());
        dto.setFollowUpNotes(v.getFollowUpNotes());
        dto.setCreatedAt(v.getCreatedAt());

        // Financial
        dto.setConsultationFee(v.getConsultationFee());
        dto.setServiceFee(v.getServiceFee());
        dto.setMedicineFee(v.getMedicineFee());
        dto.setOtherFee(v.getOtherFee());
        dto.setTotalCharge(v.getTotalCharge());

        // Clinical
        dto.setSymptomOnsetDuration(v.getSymptomOnsetDuration());
        dto.setPhysicalExamFindings(v.getPhysicalExamFindings());
        dto.setTreatmentsAdministeredPrior(v.getTreatmentsAdministeredPrior());
        dto.setPriorTreatmentResponse(v.getPriorTreatmentResponse());
        dto.setFinalClinicalAssessment(v.getFinalClinicalAssessment());
        dto.setActualTreatmentAdministered(v.getActualTreatmentAdministered());
        dto.setOwnerAdvice(v.getOwnerAdvice());
        dto.setFollowUpDueDate(v.getFollowUpDueDate());
        dto.setFollowUpStatus(v.getFollowUpStatus());

        if (v.getAnimal() != null) {
            dto.setAnimalId(v.getAnimal().getId());
            dto.setAnimalCode(v.getAnimal().getAnimalCode());
            dto.setAnimalName(v.getAnimal().getName());
            if (v.getAnimal().getFarm() != null) {
                dto.setFarmName(v.getAnimal().getFarm().getFarmName());
                if (v.getAnimal().getFarm().getVillage() != null) {
                    dto.setVillageName(v.getAnimal().getFarm().getVillage().getName());
                }
            }
        }
        if (v.getSymptoms() != null) {
            dto.setSymptoms(v.getSymptoms().stream().map(VisitSymptom::getSymptomCode).collect(Collectors.toList()));
        }
        return dto;
    }
}
