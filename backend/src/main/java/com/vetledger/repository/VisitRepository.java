package com.vetledger.repository;

import com.vetledger.entity.Visit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface VisitRepository extends JpaRepository<Visit, Long> {

    List<Visit> findByAnimalIdOrderByVisitDateDesc(Long animalId);

    List<Visit> findTop10ByOrderByVisitDateDescIdDesc();

    List<Visit> findByVisitDateBetweenOrderByVisitDateDesc(LocalDate startDate, LocalDate endDate);

    @Query("SELECT DISTINCT v FROM Visit v " +
           "JOIN FETCH v.animal a " +
           "JOIN FETCH a.farm f " +
           "JOIN FETCH f.village vil " +
           "LEFT JOIN FETCH v.symptoms s " +
           "WHERE v.visitDate BETWEEN :startDate AND :endDate " +
           "ORDER BY v.visitDate DESC")
    List<Visit> findVisitsForSurveillance(
        @Param("startDate") LocalDate startDate,
        @Param("endDate") LocalDate endDate
    );

    @Query("SELECT DISTINCT v FROM Visit v " +
           "JOIN FETCH v.animal a " +
           "JOIN FETCH a.farm f " +
           "JOIN FETCH f.village vil " +
           "LEFT JOIN FETCH v.symptoms s " +
           "WHERE vil.id = :villageId AND v.visitDate BETWEEN :startDate AND :endDate")
    List<Visit> findVisitsByVillageAndDateRange(
        @Param("villageId") Long villageId,
        @Param("startDate") LocalDate startDate,
        @Param("endDate") LocalDate endDate
    );

    @Query("SELECT MAX(v.visitDate) FROM Visit v")
    LocalDate findLatestVisitDate();
}
