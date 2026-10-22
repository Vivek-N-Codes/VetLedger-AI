package com.vetledger.dto;

import java.time.LocalDate;
import java.util.List;

public class SurveillanceClusterDto {
    private String clusterId;
    private Long villageId;
    private String villageName;
    private int observationWindowDays;
    private LocalDate windowStartDate;
    private LocalDate windowEndDate;
    private int distinctAnimalCount;
    private int affectedFarmCount;
    private List<String> sharedSymptoms;
    private double baselineAnimalCount;
    private double elevationFactor;
    private String riskLevel; // ELEVATED, HIGH, WATCH
    private String riskTitle;
    private String rationale;
    private String veterinaryNotice;

    public SurveillanceClusterDto() {
        this.veterinaryNotice = "Preliminary statistical signal. Not a confirmed diagnosis or outbreak. Field veterinary assessment required.";
    }

    public String getClusterId() { return clusterId; }
    public void setClusterId(String clusterId) { this.clusterId = clusterId; }

    public Long getVillageId() { return villageId; }
    public void setVillageId(Long villageId) { this.villageId = villageId; }

    public String getVillageName() { return villageName; }
    public void setVillageName(String villageName) { this.villageName = villageName; }

    public int getObservationWindowDays() { return observationWindowDays; }
    public void setObservationWindowDays(int observationWindowDays) { this.observationWindowDays = observationWindowDays; }

    public LocalDate getWindowStartDate() { return windowStartDate; }
    public void setWindowStartDate(LocalDate windowStartDate) { this.windowStartDate = windowStartDate; }

    public LocalDate getWindowEndDate() { return windowEndDate; }
    public void setWindowEndDate(LocalDate windowEndDate) { this.windowEndDate = windowEndDate; }

    public int getDistinctAnimalCount() { return distinctAnimalCount; }
    public void setDistinctAnimalCount(int distinctAnimalCount) { this.distinctAnimalCount = distinctAnimalCount; }

    public int getAffectedFarmCount() { return affectedFarmCount; }
    public void setAffectedFarmCount(int affectedFarmCount) { this.affectedFarmCount = affectedFarmCount; }

    public List<String> getSharedSymptoms() { return sharedSymptoms; }
    public void setSharedSymptoms(List<String> sharedSymptoms) { this.sharedSymptoms = sharedSymptoms; }

    public double getBaselineAnimalCount() { return baselineAnimalCount; }
    public void setBaselineAnimalCount(double baselineAnimalCount) { this.baselineAnimalCount = baselineAnimalCount; }

    public double getElevationFactor() { return elevationFactor; }
    public void setElevationFactor(double elevationFactor) { this.elevationFactor = elevationFactor; }

    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }

    public String getRiskTitle() { return riskTitle; }
    public void setRiskTitle(String riskTitle) { this.riskTitle = riskTitle; }

    public String getRationale() { return rationale; }
    public void setRationale(String rationale) { this.rationale = rationale; }

    public String getVeterinaryNotice() { return veterinaryNotice; }
    public void setVeterinaryNotice(String veterinaryNotice) { this.veterinaryNotice = veterinaryNotice; }
}
