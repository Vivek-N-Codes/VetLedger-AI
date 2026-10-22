package com.vetledger.dto;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public class PopulationOverviewDto {
    private int windowDays;
    private LocalDate startDate;
    private LocalDate endDate;
    private long totalRegisteredAnimals;
    private long totalFarms;
    private long totalVillages;

    // Database-backed metrics during selected window
    private int animalsWithVisitsInWindow;
    private int farmsWithVisitsInWindow;
    private int villagesWithVisitsInWindow;
    private int totalVisitsInWindow;

    private Map<String, Integer> topSymptomsInWindow;
    private List<SurveillanceClusterDto> activeClusters;
    private String dataCoverageNote = "Database-backed surveillance metrics computed over selected sliding observation window.";
    private String verifiedDiscrepancyExplanation;

    public int getWindowDays() { return windowDays; }
    public void setWindowDays(int windowDays) { this.windowDays = windowDays; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public long getTotalRegisteredAnimals() { return totalRegisteredAnimals; }
    public void setTotalRegisteredAnimals(long totalRegisteredAnimals) { this.totalRegisteredAnimals = totalRegisteredAnimals; }

    public long getTotalFarms() { return totalFarms; }
    public void setTotalFarms(long totalFarms) { this.totalFarms = totalFarms; }

    public long getTotalVillages() { return totalVillages; }
    public void setTotalVillages(long totalVillages) { this.totalVillages = totalVillages; }

    public int getAnimalsWithVisitsInWindow() { return animalsWithVisitsInWindow; }
    public void setAnimalsWithVisitsInWindow(int animalsWithVisitsInWindow) { this.animalsWithVisitsInWindow = animalsWithVisitsInWindow; }

    public int getFarmsWithVisitsInWindow() { return farmsWithVisitsInWindow; }
    public void setFarmsWithVisitsInWindow(int farmsWithVisitsInWindow) { this.farmsWithVisitsInWindow = farmsWithVisitsInWindow; }

    public int getVillagesWithVisitsInWindow() { return villagesWithVisitsInWindow; }
    public void setVillagesWithVisitsInWindow(int villagesWithVisitsInWindow) { this.villagesWithVisitsInWindow = villagesWithVisitsInWindow; }

    public int getTotalVisitsInWindow() { return totalVisitsInWindow; }
    public void setTotalVisitsInWindow(int totalVisitsInWindow) { this.totalVisitsInWindow = totalVisitsInWindow; }

    public Map<String, Integer> getTopSymptomsInWindow() { return topSymptomsInWindow; }
    public void setTopSymptomsInWindow(Map<String, Integer> topSymptomsInWindow) { this.topSymptomsInWindow = topSymptomsInWindow; }

    public List<SurveillanceClusterDto> getActiveClusters() { return activeClusters; }
    public void setActiveClusters(List<SurveillanceClusterDto> activeClusters) { this.activeClusters = activeClusters; }

    public String getDataCoverageNote() { return dataCoverageNote; }
    public void setDataCoverageNote(String dataCoverageNote) { this.dataCoverageNote = dataCoverageNote; }

    public String getVerifiedDiscrepancyExplanation() { return verifiedDiscrepancyExplanation; }
    public void setVerifiedDiscrepancyExplanation(String verifiedDiscrepancyExplanation) { this.verifiedDiscrepancyExplanation = verifiedDiscrepancyExplanation; }
}
