package com.vetledger.service;

import com.vetledger.dto.AnimalDetailDto;
import com.vetledger.dto.AnimalSummaryDto;
import com.vetledger.dto.CreateAnimalRequest;
import com.vetledger.dto.VisitDto;
import com.vetledger.entity.Animal;
import com.vetledger.entity.Farm;
import com.vetledger.entity.Visit;
import com.vetledger.entity.VisitSymptom;
import com.vetledger.exception.ResourceNotFoundException;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.FarmRepository;
import com.vetledger.repository.VisitRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class AnimalService {

    private final AnimalRepository animalRepository;
    private final VisitRepository visitRepository;
    private final FarmRepository farmRepository;

    public AnimalService(AnimalRepository animalRepository, VisitRepository visitRepository, FarmRepository farmRepository) {
        this.animalRepository = animalRepository;
        this.visitRepository = visitRepository;
        this.farmRepository = farmRepository;
    }

    @Transactional(readOnly = true)
    public List<AnimalSummaryDto> searchAnimals(String query, Long villageId, Long farmId, String species) {
        List<Animal> animals = animalRepository.searchAnimals(query, villageId, farmId, species);
        return animals.stream().map(this::mapToSummary).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
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

        dto.setTotalVisitsRecorded(visits.size());
        dto.setVisits(visits.stream().map(this::mapToVisitDto).collect(Collectors.toList()));

        return dto;
    }

    public AnimalDetailDto registerAnimal(CreateAnimalRequest request) {
        Farm farm = farmRepository.findById(request.getFarmId())
                .orElseThrow(() -> new ResourceNotFoundException("Registered Farm not found with id: " + request.getFarmId()));

        String code = request.getAnimalCode();
        if (code == null || code.trim().isEmpty()) {
            String speciesPrefix = "ANM";
            String spec = request.getSpecies() != null ? request.getSpecies().toUpperCase() : "";
            if (spec.contains("CATTLE") || spec.contains("COW")) speciesPrefix = "COW";
            else if (spec.contains("BUFFALO")) speciesPrefix = "BUF";
            else if (spec.contains("GOAT")) speciesPrefix = "GOA";
            else if (spec.contains("SHEEP")) speciesPrefix = "SHP";

            String vilPrefix = (farm.getVillage() != null && farm.getVillage().getName().length() >= 3)
                    ? farm.getVillage().getName().substring(0, 3).toUpperCase()
                    : "RUR";

            long count = animalRepository.count() + 1;
            code = String.format("%s-%s-%03d", speciesPrefix, vilPrefix, count);
            while (animalRepository.existsByAnimalCode(code)) {
                count++;
                code = String.format("%s-%s-%03d", speciesPrefix, vilPrefix, count);
            }
        } else {
            code = code.trim();
            if (animalRepository.existsByAnimalCode(code)) {
                throw new IllegalArgumentException("An animal with identifier '" + code + "' already exists. Duplicate IDs are rejected.");
            }
        }

        Animal animal = new Animal();
        animal.setAnimalCode(code);
        animal.setName(request.getName().trim());
        animal.setSpecies(request.getSpecies().trim());
        animal.setBreed(request.getBreed() != null ? request.getBreed().trim() : null);
        animal.setAgeYears(request.getAgeYears());
        animal.setSex(request.getSex().trim());
        animal.setFarm(farm);
        animal.setTagRfid(request.getTagRfid() != null ? request.getTagRfid().trim() : null);
        animal.setNotes(request.getNotes());

        Animal saved = animalRepository.save(animal);
        return getAnimalDetail(saved.getId());
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

    private VisitDto mapToVisitDto(Visit v) {
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

        // Clinical fields
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
        }
        if (v.getSymptoms() != null) {
            dto.setSymptoms(v.getSymptoms().stream().map(VisitSymptom::getSymptomCode).collect(Collectors.toList()));
        }
        return dto;
    }
}
