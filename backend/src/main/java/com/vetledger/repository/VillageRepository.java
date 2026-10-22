package com.vetledger.repository;

import com.vetledger.entity.Village;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VillageRepository extends JpaRepository<Village, Long> {
    List<Village> findAllByOrderByNameAsc();
    Optional<Village> findByNameIgnoreCase(String name);
}
