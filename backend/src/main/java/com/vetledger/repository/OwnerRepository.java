package com.vetledger.repository;

import com.vetledger.entity.Owner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OwnerRepository extends JpaRepository<Owner, Long> {
    Optional<Owner> findByOwnerCode(String ownerCode);
    boolean existsByOwnerCode(String ownerCode);
    List<Owner> findAllByOrderByFullNameAsc();

    @Query("SELECT o FROM Owner o WHERE " +
           "LOWER(o.fullName) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(o.ownerCode) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(o.contactNumber) LIKE LOWER(CONCAT('%', :query, '%')) " +
           "ORDER BY o.fullName ASC")
    List<Owner> searchOwners(@Param("query") String query);
}
