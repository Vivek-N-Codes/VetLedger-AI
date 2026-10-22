package com.vetledger.repository;

import com.vetledger.entity.ClinicalFollowUp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ClinicalFollowUpRepository extends JpaRepository<ClinicalFollowUp, Long> {
    List<ClinicalFollowUp> findByAnimalIdOrderByDueDateAsc(Long animalId);
    List<ClinicalFollowUp> findByAnimalIdAndStatusOrderByDueDateAsc(Long animalId, String status);
    List<ClinicalFollowUp> findByStatusOrderByDueDateAsc(String status);
    List<ClinicalFollowUp> findByVisitId(Long visitId);
    long countByStatus(String status);
    List<ClinicalFollowUp> findByDueDateBetweenOrderByDueDateAsc(LocalDate start, LocalDate end);
}
