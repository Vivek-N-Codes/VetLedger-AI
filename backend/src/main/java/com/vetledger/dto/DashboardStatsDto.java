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

    public Map<String, Long> getTopSymptoms() { return topSymptoms; }
    public void setTopSymptoms(Map<String, Long> topSymptoms) { this.topSymptoms = topSymptoms; }

    public String getSyntheticDataNotice() { return syntheticDataNotice; }
    public void setSyntheticDataNotice(String syntheticDataNotice) { this.syntheticDataNotice = syntheticDataNotice; }
}
