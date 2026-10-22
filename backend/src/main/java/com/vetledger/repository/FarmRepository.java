package com.vetledger.repository;

import com.vetledger.entity.Farm;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FarmRepository extends JpaRepository<Farm, Long> {
    List<Farm> findByVillageIdOrderByFarmNameAsc(Long villageId);
    List<Farm> findAllByOrderByFarmNameAsc();
    Optional<Farm> findByFarmCode(String farmCode);
    long countByVillageId(Long villageId);
}
