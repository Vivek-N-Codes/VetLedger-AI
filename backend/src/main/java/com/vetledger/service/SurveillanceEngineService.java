package com.vetledger.service;

import com.vetledger.dto.AnimalSummaryDto;
import com.vetledger.dto.ClusterDetailDto;
import com.vetledger.dto.SurveillanceClusterDto;
import com.vetledger.entity.Animal;
import com.vetledger.entity.Farm;
import com.vetledger.entity.Village;
import com.vetledger.entity.Visit;
import com.vetledger.entity.VisitSymptom;
import com.vetledger.exception.ResourceNotFoundException;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.VillageRepository;
import com.vetledger.repository.VisitRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class SurveillanceEngineService {

    private final VisitRepository visitRepository;
    private final VillageRepository villageRepository;
    private final AnimalRepository animalRepository;
    private final AnimalService animalService;

    @Value("${vetledger.surveillance.default-window-days:14}")
    private int defaultWindowDays;

    @Value("${vetledger.surveillance.min-affected-animals:5}")
    private int minAffectedAnimals;

    @Value("${vetledger.surveillance.min-affected-farms:3}")
    private int minAffectedFarms;

    @Value("${vetledger.surveillance.baseline-elevation-threshold:2.0}")
    private double baselineElevationThreshold;

    public SurveillanceEngineService(
            VisitRepository visitRepository,
            VillageRepository villageRepository,
            AnimalRepository animalRepository,
            AnimalService animalService) {
        this.visitRepository = visitRepository;
        this.villageRepository = villageRepository;
        this.animalRepository = animalRepository;
        this.animalService = animalService;
    }

    public List<SurveillanceClusterDto> detectClusters(Integer windowDays) {
        int window = (windowDays != null && windowDays > 0) ? windowDays : defaultWindowDays;

        LocalDate endDate = visitRepository.findLatestVisitDate();
        if (endDate == null) {
            endDate = LocalDate.now();
        }
        LocalDate startDate = endDate.minusDays(window - 1);

        // Historical baseline window: previous 2 equivalent periods (2 * window days)
        LocalDate baselineEndDate = startDate.minusDays(1);
        LocalDate baselineStartDate = baselineEndDate.minusDays((window * 2) - 1);

        List<Visit> currentVisits = visitRepository.findVisitsForSurveillance(startDate, endDate);
        List<Visit> baselineVisits = visitRepository.findVisitsForSurveillance(baselineStartDate, baselineEndDate);

        // Group current visits by village
        Map<Long, List<Visit>> visitsByVillage = currentVisits.stream()
                .filter(v -> v.getAnimal() != null && v.getAnimal().getFarm() != null && v.getAnimal().getFarm().getVillage() != null)
                .collect(Collectors.groupingBy(v -> v.getAnimal().getFarm().getVillage().getId()));

        List<SurveillanceClusterDto> clusters = new ArrayList<>();

        for (Map.Entry<Long, List<Visit>> entry : visitsByVillage.entrySet()) {
            Long villageId = entry.getKey();
            List<Visit> villageVisits = entry.getValue();
            Village village = villageVisits.get(0).getAnimal().getFarm().getVillage();

            // Count distinct animals and distinct farms
            Set<Long> distinctAnimalIds = villageVisits.stream()
                    .map(v -> v.getAnimal().getId())
                    .collect(Collectors.toSet());

            Set<Long> distinctFarmIds = villageVisits.stream()
                    .map(v -> v.getAnimal().getFarm().getId())
                    .collect(Collectors.toSet());

            // Count animals affected per symptom
            Map<String, Set<Long>> animalsPerSymptom = new HashMap<>();
            for (Visit v : villageVisits) {
                if (v.getSymptoms() != null) {
                    for (VisitSymptom s : v.getSymptoms()) {
                        animalsPerSymptom
                                .computeIfAbsent(s.getSymptomCode(), k -> new HashSet<>())
                                .add(v.getAnimal().getId());
                    }
                }
            }

            // Identify candidate shared symptoms that appear in significant portion of animals
            List<String> dominantSymptoms = animalsPerSymptom.entrySet().stream()
                    .filter(e -> e.getValue().size() >= minAffectedAnimals)
                    .sorted((e1, e2) -> Integer.compare(e2.getValue().size(), e1.getValue().size()))
                    .map(Map.Entry::getKey)
                    .collect(Collectors.toList());

            // Check if thresholds are met
            if (distinctAnimalIds.size() >= minAffectedAnimals && distinctFarmIds.size() >= minAffectedFarms && !dominantSymptoms.isEmpty()) {
                // Compute historical baseline for this village with these symptoms
                double baselineAnimalRate = computeHistoricalBaseline(villageId, baselineVisits, dominantSymptoms, window * 2, window);

                double elevationFactor = baselineAnimalRate > 0
                        ? ((double) distinctAnimalIds.size() / baselineAnimalRate)
                        : (double) distinctAnimalIds.size();

                elevationFactor = Math.round(elevationFactor * 10.0) / 10.0;

                if (elevationFactor >= baselineElevationThreshold || distinctAnimalIds.size() >= 10) {
                    SurveillanceClusterDto cluster = new SurveillanceClusterDto();
                    cluster.setClusterId("CLUST-" + village.getName().toUpperCase().substring(0, Math.min(3, village.getName().length())) + "-01");
                    cluster.setVillageId(villageId);
                    cluster.setVillageName(village.getName());
                    cluster.setObservationWindowDays(window);
                    cluster.setWindowStartDate(startDate);
                    cluster.setWindowEndDate(endDate);
                    cluster.setDistinctAnimalCount(distinctAnimalIds.size());
                    cluster.setAffectedFarmCount(distinctFarmIds.size());
                    cluster.setSharedSymptoms(dominantSymptoms);
                    cluster.setBaselineAnimalCount(Math.round(baselineAnimalRate * 10.0) / 10.0);
                    cluster.setElevationFactor(elevationFactor);

                    if (distinctAnimalIds.size() >= 15 && distinctFarmIds.size() >= 5) {
                        cluster.setRiskLevel("HIGH");
                        cluster.setRiskTitle("Potential Symptom Cluster Detected — Priority Alert");
                    } else {
                        cluster.setRiskLevel("ELEVATED");
                        cluster.setRiskTitle("Unusual Symptom Concentration — Surveillance Alert");
                    }

                    String symptomSummary = String.join(", ", dominantSymptoms);
                    cluster.setRationale(String.format(
                            "%d distinct animals across %d farms presented with %s during the %d-day window (historical baseline: %.1f animals per %d-day period; %.1fx baseline).",
                            distinctAnimalIds.size(),
                            distinctFarmIds.size(),
                            symptomSummary,
                            window,
                            cluster.getBaselineAnimalCount(),
                            window,
                            elevationFactor
                    ));

                    clusters.add(cluster);
                }
            }
        }

        // Sort by risk priority and distinct animals
        clusters.sort((c1, c2) -> Integer.compare(c2.getDistinctAnimalCount(), c1.getDistinctAnimalCount()));
        return clusters;
    }

    private double computeHistoricalBaseline(Long villageId, List<Visit> baselineVisits, List<String> targetSymptoms, int baselinePeriodDays, int targetWindowDays) {
        if (baselineVisits == null || baselineVisits.isEmpty() || baselinePeriodDays <= 0) {
            return 1.0; // Minimal default baseline
        }

        Set<Long> baselineAnimalIds = new HashSet<>();
        for (Visit v : baselineVisits) {
            if (v.getAnimal() != null && v.getAnimal().getFarm() != null && v.getAnimal().getFarm().getVillage() != null) {
                if (v.getAnimal().getFarm().getVillage().getId().equals(villageId)) {
                    if (v.getSymptoms() != null) {
                        boolean hasTargetSymptom = v.getSymptoms().stream()
                                .anyMatch(s -> targetSymptoms.contains(s.getSymptomCode()));
                        if (hasTargetSymptom) {
                            baselineAnimalIds.add(v.getAnimal().getId());
                        }
                    }
                }
            }
        }

        double normalizedPeriodRate = ((double) baselineAnimalIds.size() / (double) baselinePeriodDays) * targetWindowDays;
        return Math.max(0.5, normalizedPeriodRate);
    }

    public ClusterDetailDto getClusterDetail(String clusterId, Integer windowDays) {
        List<SurveillanceClusterDto> clusters = detectClusters(windowDays);
        SurveillanceClusterDto matchedCluster = clusters.stream()
                .filter(c -> c.getClusterId().equalsIgnoreCase(clusterId) || c.getVillageName().equalsIgnoreCase(clusterId))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Surveillance cluster not found: " + clusterId));

        int window = matchedCluster.getObservationWindowDays();
        LocalDate startDate = matchedCluster.getWindowStartDate();
        LocalDate endDate = matchedCluster.getWindowEndDate();

        List<Visit> visits = visitRepository.findVisitsByVillageAndDateRange(matchedCluster.getVillageId(), startDate, endDate);

        ClusterDetailDto detail = new ClusterDetailDto();
        detail.setClusterId(matchedCluster.getClusterId());
        detail.setVillageId(matchedCluster.getVillageId());
        detail.setVillageName(matchedCluster.getVillageName());
        detail.setObservationWindowDays(window);
        detail.setWindowStartDate(startDate);
        detail.setWindowEndDate(endDate);
        detail.setDistinctAnimalCount(matchedCluster.getDistinctAnimalCount());
        detail.setAffectedFarmCount(matchedCluster.getAffectedFarmCount());
        detail.setSharedSymptoms(matchedCluster.getSharedSymptoms());
        detail.setBaselineAnimalCount(matchedCluster.getBaselineAnimalCount());
        detail.setElevationFactor(matchedCluster.getElevationFactor());
        detail.setRiskLevel(matchedCluster.getRiskLevel());
        detail.setRiskTitle(matchedCluster.getRiskTitle());
        detail.setRationale(matchedCluster.getRationale());

        // Affected Animals
        Map<Long, Animal> distinctAnimalsMap = new LinkedHashMap<>();
        Map<Long, List<Long>> farmToAnimals = new LinkedHashMap<>();
        Map<String, Integer> symptomCounts = new LinkedHashMap<>();
        List<Long> visitIds = new ArrayList<>();

        for (Visit v : visits) {
            visitIds.add(v.getId());
            Animal a = v.getAnimal();
            distinctAnimalsMap.put(a.getId(), a);

            Farm f = a.getFarm();
            farmToAnimals.computeIfAbsent(f.getId(), k -> new ArrayList<>()).add(a.getId());

            if (v.getSymptoms() != null) {
                for (VisitSymptom vs : v.getSymptoms()) {
                    symptomCounts.put(vs.getSymptomCode(), symptomCounts.getOrDefault(vs.getSymptomCode(), 0) + 1);
                }
            }
        }

        List<AnimalSummaryDto> affectedAnimals = distinctAnimalsMap.values().stream()
                .map(animalService::mapToSummary)
                .collect(Collectors.toList());
        detail.setAffectedAnimals(affectedAnimals);

        // Affected Farms
        List<ClusterDetailDto.AffectedFarmSummary> farmSummaries = new ArrayList<>();
        for (Map.Entry<Long, List<Long>> entry : farmToAnimals.entrySet()) {
            Farm f = distinctAnimalsMap.values().stream()
                    .filter(a -> a.getFarm().getId().equals(entry.getKey()))
                    .map(Animal::getFarm)
                    .findFirst()
                    .orElse(null);

            if (f != null) {
                int distinctAnimalsInFarm = new HashSet<>(entry.getValue()).size();
                farmSummaries.add(new ClusterDetailDto.AffectedFarmSummary(
                        f.getId(),
                        f.getFarmCode(),
                        f.getFarmName(),
                        f.getOwnerName(),
                        f.getContactNumber(),
                        distinctAnimalsInFarm
                ));
            }
        }
        detail.setAffectedFarms(farmSummaries);
        detail.setSymptomCounts(symptomCounts);
        detail.setSupportingVisitIds(visitIds);

        // Recommended Field Actions
        List<String> actions = new ArrayList<>();
        actions.add("Dispatch veterinary field investigation team to " + matchedCluster.getVillageName() + " for physical clinical evaluations.");
        actions.add("Recommend voluntary animal movement restrictions and quarantine between affected farms (" + matchedCluster.getAffectedFarmCount() + " farms involved).");
        actions.add("Perform targeted swab and serum sampling to test for Bovine Respiratory Disease Complex (BRDC) and Hemorrhagic Septicemia.");
        actions.add("Review water source hygiene, communal grazing areas, and fomite disinfection protocols across " + matchedCluster.getVillageName() + ".");
        actions.add("Advise farmers on early antipyretic administration, supportive electrolyte hydration, and immediate isolation of scouring/coughing stock.");
        detail.setRecommendedFieldActions(actions);

        return detail;
    }
}
