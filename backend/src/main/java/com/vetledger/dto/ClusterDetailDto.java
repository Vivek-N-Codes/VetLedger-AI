package com.vetledger.dto;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class ClusterDetailDto {
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
    private String riskLevel;
    private String riskTitle;
    private String rationale;
    private String veterinaryNotice;

    // Detailed investigation breakdown
    private List<AnimalSummaryDto> affectedAnimals;
    private List<AffectedFarmSummary> affectedFarms;
    private Map<String, Integer> symptomCounts;
    private List<Long> supportingVisitIds;
    private List<String> recommendedFieldActions;

    public ClusterDetailDto() {
        this.veterinaryNotice = "Preliminary statistical signal. Not a confirmed diagnosis or outbreak. Field veterinary assessment required.";
    }

    public static class AffectedFarmSummary {
        private Long farmId;
        private String farmCode;
        private String farmName;
        private String ownerName;
        private String contactNumber;
        private int affectedAnimalCount;

        public AffectedFarmSummary() {}

        public AffectedFarmSummary(Long farmId, String farmCode, String farmName, String ownerName, String contactNumber, int affectedAnimalCount) {
            this.farmId = farmId;
            this.farmCode = farmCode;
            this.farmName = farmName;
            this.ownerName = ownerName;
            this.contactNumber = contactNumber;
            this.affectedAnimalCount = affectedAnimalCount;
        }

        public Long getFarmId() { return farmId; }
        public void setFarmId(Long farmId) { this.farmId = farmId; }

        public String getFarmCode() { return farmCode; }
        public void setFarmCode(String farmCode) { this.farmCode = farmCode; }

        public String getFarmName() { return farmName; }
        public void setFarmName(String farmName) { this.farmName = farmName; }

        public String getOwnerName() { return ownerName; }
        public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

        public String getContactNumber() { return contactNumber; }
        public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

        public int getAffectedAnimalCount() { return affectedAnimalCount; }
        public void setAffectedAnimalCount(int affectedAnimalCount) { this.affectedAnimalCount = affectedAnimalCount; }
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

    public List<AnimalSummaryDto> getAffectedAnimals() { return affectedAnimals; }
    public void setAffectedAnimals(List<AnimalSummaryDto> affectedAnimals) { this.affectedAnimals = affectedAnimals; }

    public List<AffectedFarmSummary> getAffectedFarms() { return affectedFarms; }
    public void setAffectedFarms(List<AffectedFarmSummary> affectedFarms) { this.affectedFarms = affectedFarms; }

    public Map<String, Integer> getSymptomCounts() { return symptomCounts; }
    public void setSymptomCounts(Map<String, Integer> symptomCounts) { this.symptomCounts = symptomCounts; }

    public List<Long> getSupportingVisitIds() { return supportingVisitIds; }
    public void setSupportingVisitIds(List<Long> supportingVisitIds) { this.supportingVisitIds = supportingVisitIds; }

    public List<String> getRecommendedFieldActions() { return recommendedFieldActions; }
    public void setRecommendedFieldActions(List<String> recommendedFieldActions) { this.recommendedFieldActions = recommendedFieldActions; }
}
