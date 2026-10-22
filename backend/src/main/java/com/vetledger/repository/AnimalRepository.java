package com.vetledger.repository;

import com.vetledger.entity.Animal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AnimalRepository extends JpaRepository<Animal, Long> {

    Optional<Animal> findByAnimalCode(String animalCode);

    @Query("SELECT a FROM Animal a " +
           "JOIN a.farm f " +
           "JOIN f.village v " +
           "WHERE (:query IS NULL OR :query = '' OR " +
           "       LOWER(a.animalCode) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "       LOWER(a.name) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "       LOWER(a.tagRfid) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "       LOWER(f.farmName) LIKE LOWER(CONCAT('%', :query, '%'))) " +
           "  AND (:villageId IS NULL OR v.id = :villageId) " +
           "  AND (:farmId IS NULL OR f.id = :farmId) " +
           "  AND (:species IS NULL OR :species = '' OR LOWER(a.species) = LOWER(:species)) " +
           "ORDER BY a.animalCode ASC")
    List<Animal> searchAnimals(
        @Param("query") String query,
        @Param("villageId") Long villageId,
        @Param("farmId") Long farmId,
        @Param("species") String species
    );

    List<Animal> findByFarmId(Long farmId);

    @Query("SELECT a FROM Animal a JOIN a.farm f WHERE f.village.id = :villageId")
    List<Animal> findByVillageId(@Param("villageId") Long villageId);
}
