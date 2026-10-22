package com.vetledger.repository;

import com.vetledger.entity.VisitSymptom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VisitSymptomRepository extends JpaRepository<VisitSymptom, Long> {

    List<VisitSymptom> findByVisitId(Long visitId);

    @Query("SELECT vs.symptomCode, COUNT(vs) FROM VisitSymptom vs GROUP BY vs.symptomCode ORDER BY COUNT(vs) DESC")
    List<Object[]> countTopSymptoms();
}
