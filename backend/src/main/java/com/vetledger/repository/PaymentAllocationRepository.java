package com.vetledger.repository;

import com.vetledger.entity.PaymentAllocation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface PaymentAllocationRepository extends JpaRepository<PaymentAllocation, Long> {
    List<PaymentAllocation> findByPaymentId(Long paymentId);
    List<PaymentAllocation> findByVisitId(Long visitId);

    @Query("SELECT COALESCE(SUM(pa.allocatedAmount), 0) FROM PaymentAllocation pa WHERE pa.visit.id = :visitId")
    BigDecimal findTotalAllocatedForVisit(@Param("visitId") Long visitId);
}
