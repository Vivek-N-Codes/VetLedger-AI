package com.vetledger.dto;

import java.util.List;
import java.util.Map;

public class DashboardStatsDto {
    private long totalAnimals;
    private long totalFarms;
    private long totalVillages;
    private long totalVisits;
    private int activeSurveillanceAlerts;
    private List<VisitDto> recentVisits;
    private List<VillageStatDto> villageStats;
    private Map<String, Long> topSymptoms;
    private String syntheticDataNotice;

    public DashboardStatsDto() {
        this.syntheticDataNotice = "VetLedger AI Prototype: All data is synthetic for demonstration and decision support only.";
    }

    public static class VillageStatDto {
        private Long villageId;
        private String villageName;
        private long farmCount;
        private long animalCount;
        private long recentVisitCount;
        private boolean hasAlert;

        public VillageStatDto() {}

        public VillageStatDto(Long villageId, String villageName, long farmCount, long animalCount, long recentVisitCount, boolean hasAlert) {
            this.villageId = villageId;
            this.villageName = villageName;
            this.farmCount = farmCount;
            this.animalCount = animalCount;
            this.recentVisitCount = recentVisitCount;
            this.hasAlert = hasAlert;
        }

        public Long getVillageId() { return villageId; }
        public void setVillageId(Long villageId) { this.villageId = villageId; }

        public String getVillageName() { return villageName; }
        public void setVillageName(String villageName) { this.villageName = villageName; }

        public long getFarmCount() { return farmCount; }
        public void setFarmCount(long farmCount) { this.farmCount = farmCount; }

        public long getAnimalCount() { return animalCount; }
        public void setAnimalCount(long animalCount) { this.animalCount = animalCount; }

        public long getRecentVisitCount() { return recentVisitCount; }
        public void setRecentVisitCount(long recentVisitCount) { this.recentVisitCount = recentVisitCount; }

        public boolean isHasAlert() { return hasAlert; }
        public void setHasAlert(boolean hasAlert) { this.hasAlert = hasAlert; }
    }

    public static class FarmStatDto {
        private Long farmId;
        private String farmCode;
        private String farmName;
        private String villageName;
        private String ownerName;
        private long animalCount;
        private long visitCount;

        public FarmStatDto() {}

        public FarmStatDto(Long farmId, String farmCode, String farmName, String villageName, String ownerName, long animalCount, long visitCount) {
            this.farmId = farmId;
            this.farmCode = farmCode;
            this.farmName = farmName;
            this.villageName = villageName;
            this.ownerName = ownerName;
            this.animalCount = animalCount;
            this.visitCount = visitCount;
        }

        public Long getFarmId() { return farmId; }
        public void setFarmId(Long farmId) { this.farmId = farmId; }

        public String getFarmCode() { return farmCode; }
        public void setFarmCode(String farmCode) { this.farmCode = farmCode; }

        public String getFarmName() { return farmName; }
        public void setFarmName(String farmName) { this.farmName = farmName; }

        public String getVillageName() { return villageName; }
        public void setVillageName(String villageName) { this.villageName = villageName; }

        public String getOwnerName() { return ownerName; }
        public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

        public long getAnimalCount() { return animalCount; }
        public void setAnimalCount(long animalCount) { this.animalCount = animalCount; }

        public long getVisitCount() { return visitCount; }
        public void setVisitCount(long visitCount) { this.visitCount = visitCount; }
    }

    private List<FarmStatDto> farmStats;

    public long getTotalAnimals() { return totalAnimals; }
    public void setTotalAnimals(long totalAnimals) { this.totalAnimals = totalAnimals; }

    public long getTotalFarms() { return totalFarms; }
    public void setTotalFarms(long totalFarms) { this.totalFarms = totalFarms; }

    public long getTotalVillages() { return totalVillages; }
    public void setTotalVillages(long totalVillages) { this.totalVillages = totalVillages; }

    public long getTotalVisits() { return totalVisits; }
    public void setTotalVisits(long totalVisits) { this.totalVisits = totalVisits; }

    public int getActiveSurveillanceAlerts() { return activeSurveillanceAlerts; }
    public void setActiveSurveillanceAlerts(int activeSurveillanceAlerts) { this.activeSurveillanceAlerts = activeSurveillanceAlerts; }

    public List<VisitDto> getRecentVisits() { return recentVisits; }
    public void setRecentVisits(List<VisitDto> recentVisits) { this.recentVisits = recentVisits; }

    public List<VillageStatDto> getVillageStats() { return villageStats; }
    public void setVillageStats(List<VillageStatDto> villageStats) { this.villageStats = villageStats; }

    public List<FarmStatDto> getFarmStats() { return farmStats; }
    public void setFarmStats(List<FarmStatDto> farmStats) { this.farmStats = farmStats; }

    public Map<String, Long> getTopSymptoms() { return topSymptoms; }
    public void setTopSymptoms(Map<String, Long> topSymptoms) { this.topSymptoms = topSymptoms; }

    public String getSyntheticDataNotice() { return syntheticDataNotice; }
    public void setSyntheticDataNotice(String syntheticDataNotice) { this.syntheticDataNotice = syntheticDataNotice; }
}
