package com.vetledger.repository;

import com.vetledger.entity.Farm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FarmRepository extends JpaRepository<Farm, Long> {
    List<Farm> findByVillageIdOrderByFarmNameAsc(Long villageId);
    List<Farm> findAllByOrderByFarmNameAsc();
    Optional<Farm> findByFarmCode(String farmCode);
    boolean existsByFarmCode(String farmCode);
    long countByVillageId(Long villageId);
    List<Farm> findByOwnerIdOrderByFarmNameAsc(Long ownerId);

    @Query("SELECT f FROM Farm f WHERE " +
           "LOWER(f.farmName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(f.farmCode) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(f.ownerName) LIKE LOWER(CONCAT('%', :query, '%')) " +
           "ORDER BY f.farmName ASC")
    List<Farm> searchFarms(@Param("query") String query);
}
