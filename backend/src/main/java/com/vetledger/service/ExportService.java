package com.vetledger.service;

import com.vetledger.entity.Animal;
import com.vetledger.entity.Owner;
import com.vetledger.entity.Visit;
import com.vetledger.entity.VisitSymptom;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.OwnerRepository;
import com.vetledger.repository.PaymentRepository;
import com.vetledger.repository.VisitRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class ExportService {

    private final AnimalRepository animalRepository;
    private final VisitRepository visitRepository;
    private final OwnerRepository ownerRepository;
    private final PaymentRepository paymentRepository;

    public ExportService(
            AnimalRepository animalRepository,
            VisitRepository visitRepository,
            OwnerRepository ownerRepository,
            PaymentRepository paymentRepository) {
        this.animalRepository = animalRepository;
        this.visitRepository = visitRepository;
        this.ownerRepository = ownerRepository;
        this.paymentRepository = paymentRepository;
    }

    public String exportAnimalsCsv() {
        StringBuilder sb = new StringBuilder();
        sb.append("# VetLedger AI — Animal Records Export\n");
        sb.append("ID,AnimalCode,Name,Species,Breed,AgeYears,Sex,FarmCode,FarmName,Village,TagRFID\n");

        List<Animal> animals = animalRepository.findAll();
        for (Animal a : animals) {
            sb.append(a.getId()).append(",")
              .append(escapeCsv(a.getAnimalCode())).append(",")
              .append(escapeCsv(a.getName())).append(",")
              .append(escapeCsv(a.getSpecies())).append(",")
              .append(escapeCsv(a.getBreed())).append(",")
              .append(a.getAgeYears() != null ? a.getAgeYears() : "").append(",")
              .append(escapeCsv(a.getSex())).append(",")
              .append(a.getFarm() != null ? escapeCsv(a.getFarm().getFarmCode()) : "").append(",")
              .append(a.getFarm() != null ? escapeCsv(a.getFarm().getFarmName()) : "").append(",")
              .append((a.getFarm() != null && a.getFarm().getVillage() != null) ? escapeCsv(a.getFarm().getVillage().getName()) : "").append(",")
              .append(escapeCsv(a.getTagRfid()))
              .append("\n");
        }
        return sb.toString();
    }

    public String exportVisitsCsv() {
        StringBuilder sb = new StringBuilder();
        sb.append("# VetLedger AI — Clinical Encounters Export\n");
        sb.append("VisitID,VisitDate,AnimalCode,AnimalName,Severity,TempC,Complaint,Symptoms,ConsultationFee,MedicineFee,ServiceFee,TotalCharge\n");

        List<Visit> visits = visitRepository.findAll();
        for (Visit v : visits) {
            String sym = v.getSymptoms() != null 
                    ? v.getSymptoms().stream().map(VisitSymptom::getSymptomCode).collect(Collectors.joining(";")) 
                    : "";
            sb.append(v.getId()).append(",")
              .append(v.getVisitDate()).append(",")
              .append(v.getAnimal() != null ? escapeCsv(v.getAnimal().getAnimalCode()) : "").append(",")
              .append(v.getAnimal() != null ? escapeCsv(v.getAnimal().getName()) : "").append(",")
              .append(escapeCsv(v.getSeverity())).append(",")
              .append(v.getTemperatureCelsius() != null ? v.getTemperatureCelsius() : "").append(",")
              .append(escapeCsv(v.getPresentingComplaint())).append(",")
              .append(escapeCsv(sym)).append(",")
              .append(v.getConsultationFee() != null ? v.getConsultationFee() : "0.00").append(",")
              .append(v.getMedicineFee() != null ? v.getMedicineFee() : "0.00").append(",")
              .append(v.getServiceFee() != null ? v.getServiceFee() : "0.00").append(",")
              .append(v.getTotalCharge() != null ? v.getTotalCharge() : "0.00")
              .append("\n");
        }
        return sb.toString();
    }

    public String exportLedgerCsv() {
        StringBuilder sb = new StringBuilder();
        sb.append("# VetLedger AI — Owner-Level Financial Ledger Statement Export\n");
        sb.append("OwnerCode,FullName,ContactNumber,Village,TotalBilledINR,TotalPaidINR,OutstandingBalanceINR,Status\n");

        List<Owner> owners = ownerRepository.findAllByOrderByFullNameAsc();
        for (Owner o : owners) {
            BigDecimal totalCharges = visitRepository.findTotalChargesByOwnerId(o.getId());
            BigDecimal totalPaid = paymentRepository.findTotalPaidByOwnerId(o.getId());
            BigDecimal balance = totalCharges.subtract(totalPaid);
            String status = balance.compareTo(BigDecimal.ZERO) > 0 ? "OUTSTANDING" : "CLEAR";

            sb.append(escapeCsv(o.getOwnerCode())).append(",")
              .append(escapeCsv(o.getFullName())).append(",")
              .append(escapeCsv(o.getContactNumber())).append(",")
              .append(o.getVillage() != null ? escapeCsv(o.getVillage().getName()) : "").append(",")
              .append(totalCharges).append(",")
              .append(totalPaid).append(",")
              .append(balance).append(",")
              .append(status)
              .append("\n");
        }
        return sb.toString();
    }

    private String escapeCsv(String val) {
        if (val == null) return "";
        if (val.contains(",") || val.contains("\"") || val.contains("\n")) {
            return "\"" + val.replace("\"", "\"\"") + "\"";
        }
        return val;
    }
}
