package com.vetledger.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;

public class PaymentReceiptDto {
    private String practiceName = "VetLedger Rural Veterinary Clinic";
    private String practiceAddress = "Ahmednagar District Mobile Veterinary Unit, Maharashtra";
    private String receiptNumber;
    private Long paymentId;
    private Long ownerId;
    private String ownerCode;
    private String ownerName;
    private String contactNumber;
    private String address;
    private LocalDate paymentDate;
    private BigDecimal amountReceived;
    private String paymentMethod;
    private String referenceNumber;
    private String notes;
    private BigDecimal previousBalance;
    private BigDecimal remainingBalance;
    private OffsetDateTime issuedAt;

    public static class AllocationItem {
        private String visitDate;
        private String animalCode;
        private String animalName;
        private String complaint;
        private BigDecimal visitTotal;
        private BigDecimal allocatedAmount;

        public AllocationItem() {}
        public AllocationItem(String visitDate, String animalCode, String animalName, String complaint, BigDecimal visitTotal, BigDecimal allocatedAmount) {
            this.visitDate = visitDate;
            this.animalCode = animalCode;
            this.animalName = animalName;
            this.complaint = complaint;
            this.visitTotal = visitTotal;
            this.allocatedAmount = allocatedAmount;
        }

        public String getVisitDate() { return visitDate; }
        public void setVisitDate(String visitDate) { this.visitDate = visitDate; }
        public String getAnimalCode() { return animalCode; }
        public void setAnimalCode(String animalCode) { this.animalCode = animalCode; }
        public String getAnimalName() { return animalName; }
        public void setAnimalName(String animalName) { this.animalName = animalName; }
        public String getComplaint() { return complaint; }
        public void setComplaint(String complaint) { this.complaint = complaint; }
        public BigDecimal getVisitTotal() { return visitTotal; }
        public void setVisitTotal(BigDecimal visitTotal) { this.visitTotal = visitTotal; }
        public BigDecimal getAllocatedAmount() { return allocatedAmount; }
        public void setAllocatedAmount(BigDecimal allocatedAmount) { this.allocatedAmount = allocatedAmount; }
    }

    private List<AllocationItem> allocatedVisits;

    public String getPracticeName() { return practiceName; }
    public void setPracticeName(String practiceName) { this.practiceName = practiceName; }

    public String getPracticeAddress() { return practiceAddress; }
    public void setPracticeAddress(String practiceAddress) { this.practiceAddress = practiceAddress; }

    public String getReceiptNumber() { return receiptNumber; }
    public void setReceiptNumber(String receiptNumber) { this.receiptNumber = receiptNumber; }

    public Long getPaymentId() { return paymentId; }
    public void setPaymentId(Long paymentId) { this.paymentId = paymentId; }

    public Long getOwnerId() { return ownerId; }
    public void setOwnerId(Long ownerId) { this.ownerId = ownerId; }

    public String getOwnerCode() { return ownerCode; }
    public void setOwnerCode(String ownerCode) { this.ownerCode = ownerCode; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public LocalDate getPaymentDate() { return paymentDate; }
    public void setPaymentDate(LocalDate paymentDate) { this.paymentDate = paymentDate; }

    public BigDecimal getAmountReceived() { return amountReceived; }
    public void setAmountReceived(BigDecimal amountReceived) { this.amountReceived = amountReceived; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getReferenceNumber() { return referenceNumber; }
    public void setReferenceNumber(String referenceNumber) { this.referenceNumber = referenceNumber; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public BigDecimal getPreviousBalance() { return previousBalance; }
    public void setPreviousBalance(BigDecimal previousBalance) { this.previousBalance = previousBalance; }

    public BigDecimal getRemainingBalance() { return remainingBalance; }
    public void setRemainingBalance(BigDecimal remainingBalance) { this.remainingBalance = remainingBalance; }

    public OffsetDateTime getIssuedAt() { return issuedAt; }
    public void setIssuedAt(OffsetDateTime issuedAt) { this.issuedAt = issuedAt; }

    public List<AllocationItem> getAllocatedVisits() { return allocatedVisits; }
    public void setAllocatedVisits(List<AllocationItem> allocatedVisits) { this.allocatedVisits = allocatedVisits; }
}
