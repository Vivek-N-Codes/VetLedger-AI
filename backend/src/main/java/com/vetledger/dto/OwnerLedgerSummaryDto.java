package com.vetledger.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public class OwnerLedgerSummaryDto {
    private Long ownerId;
    private String ownerCode;
    private String fullName;
    private String contactNumber;
    private String villageName;
    private int farmCount;
    private int animalCount;
    private int totalVisits;
    private BigDecimal totalBilled;
    private BigDecimal totalPaid;
    private BigDecimal outstandingBalance;
    private LocalDate lastPaymentDate;
    private LocalDate lastVisitDate;
    private String status; // "CLEAR", "OUTSTANDING", "CREDIT"

    public Long getOwnerId() { return ownerId; }
    public void setOwnerId(Long ownerId) { this.ownerId = ownerId; }

    public String getOwnerCode() { return ownerCode; }
    public void setOwnerCode(String ownerCode) { this.ownerCode = ownerCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getVillageName() { return villageName; }
    public void setVillageName(String villageName) { this.villageName = villageName; }

    public int getFarmCount() { return farmCount; }
    public void setFarmCount(int farmCount) { this.farmCount = farmCount; }

    public int getAnimalCount() { return animalCount; }
    public void setAnimalCount(int animalCount) { this.animalCount = animalCount; }

    public int getTotalVisits() { return totalVisits; }
    public void setTotalVisits(int totalVisits) { this.totalVisits = totalVisits; }

    public BigDecimal getTotalBilled() { return totalBilled; }
    public void setTotalBilled(BigDecimal totalBilled) { this.totalBilled = totalBilled; }

    public BigDecimal getTotalPaid() { return totalPaid; }
    public void setTotalPaid(BigDecimal totalPaid) { this.totalPaid = totalPaid; }

    public BigDecimal getOutstandingBalance() { return outstandingBalance; }
    public void setOutstandingBalance(BigDecimal outstandingBalance) { this.outstandingBalance = outstandingBalance; }

    public LocalDate getLastPaymentDate() { return lastPaymentDate; }
    public void setLastPaymentDate(LocalDate lastPaymentDate) { this.lastPaymentDate = lastPaymentDate; }

    public LocalDate getLastVisitDate() { return lastVisitDate; }
    public void setLastVisitDate(LocalDate lastVisitDate) { this.lastVisitDate = lastVisitDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
