package com.vetledger.dto;

import java.math.BigDecimal;
import java.util.List;

public class OwnerLedgerDetailDto {
    private Long ownerId;
    private String ownerCode;
    private String fullName;
    private String contactNumber;
    private String email;
    private String address;
    private String villageName;

    // Aggregated Financials
    private BigDecimal totalCharges;
    private BigDecimal totalPayments;
    private BigDecimal outstandingBalance;

    // Associated Entities
    private List<FarmSummaryDto> farms;
    private List<AnimalSummaryDto> animals;
    private List<VisitDto> visitsWithCharges;
    private List<PaymentDto> payments;

    public Long getOwnerId() { return ownerId; }
    public void setOwnerId(Long ownerId) { this.ownerId = ownerId; }

    public String getOwnerCode() { return ownerCode; }
    public void setOwnerCode(String ownerCode) { this.ownerCode = ownerCode; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getVillageName() { return villageName; }
    public void setVillageName(String villageName) { this.villageName = villageName; }

    public BigDecimal getTotalCharges() { return totalCharges; }
    public void setTotalCharges(BigDecimal totalCharges) { this.totalCharges = totalCharges; }

    public BigDecimal getTotalPayments() { return totalPayments; }
    public void setTotalPayments(BigDecimal totalPayments) { this.totalPayments = totalPayments; }

    public BigDecimal getOutstandingBalance() { return outstandingBalance; }
    public void setOutstandingBalance(BigDecimal outstandingBalance) { this.outstandingBalance = outstandingBalance; }

    public List<FarmSummaryDto> getFarms() { return farms; }
    public void setFarms(List<FarmSummaryDto> farms) { this.farms = farms; }

    public List<AnimalSummaryDto> getAnimals() { return animals; }
    public void setAnimals(List<AnimalSummaryDto> animals) { this.animals = animals; }

    public List<VisitDto> getVisitsWithCharges() { return visitsWithCharges; }
    public void setVisitsWithCharges(List<VisitDto> visitsWithCharges) { this.visitsWithCharges = visitsWithCharges; }

    public List<PaymentDto> getPayments() { return payments; }
    public void setPayments(List<PaymentDto> payments) { this.payments = payments; }
}
