package com.vetledger.service;

import com.vetledger.dto.DashboardStatsDto;
import com.vetledger.dto.SurveillanceClusterDto;
import com.vetledger.dto.VisitDto;
import com.vetledger.entity.Village;
import com.vetledger.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class DashboardService {

    private final AnimalRepository animalRepository;
    private final FarmRepository farmRepository;
    private final VillageRepository villageRepository;
    private final VisitRepository visitRepository;
    private final VisitSymptomRepository visitSymptomRepository;
    private final VisitService visitService;
    private final SurveillanceEngineService surveillanceEngineService;

    public DashboardService(
            AnimalRepository animalRepository,
            FarmRepository farmRepository,
            VillageRepository villageRepository,
            VisitRepository visitRepository,
            VisitSymptomRepository visitSymptomRepository,
            VisitService visitService,
            SurveillanceEngineService surveillanceEngineService) {
        this.animalRepository = animalRepository;
        this.farmRepository = farmRepository;
        this.villageRepository = villageRepository;
        this.visitRepository = visitRepository;
        this.visitSymptomRepository = visitSymptomRepository;
        this.visitService = visitService;
        this.surveillanceEngineService = surveillanceEngineService;
    }

    public DashboardStatsDto getDashboardStats() {
        DashboardStatsDto stats = new DashboardStatsDto();

        stats.setTotalAnimals(animalRepository.count());
        stats.setTotalFarms(farmRepository.count());
        stats.setTotalVillages(villageRepository.count());
        stats.setTotalVisits(visitRepository.count());

        // Surveillance clusters
        List<SurveillanceClusterDto> clusters = surveillanceEngineService.detectClusters(14);
        stats.setActiveSurveillanceAlerts(clusters.size());

        Set<Long> alertVillageIds = clusters.stream()
                .map(SurveillanceClusterDto::getVillageId)
                .collect(Collectors.toSet());

        // Recent visits
        List<VisitDto> recent = visitService.getRecentVisits();
        stats.setRecentVisits(recent);

        // Village breakdown
        List<Village> villages = villageRepository.findAllByOrderByNameAsc();
        List<DashboardStatsDto.VillageStatDto> villageStats = new ArrayList<>();

        for (Village v : villages) {
            long farmCount = farmRepository.countByVillageId(v.getId());
            long animalCount = animalRepository.findByVillageId(v.getId()).size();
            long recentVisits = recent.stream()
                    .filter(vis -> v.getName().equalsIgnoreCase(vis.getVillageName()))
                    .count();
            boolean hasAlert = alertVillageIds.contains(v.getId());

            villageStats.add(new DashboardStatsDto.VillageStatDto(
                    v.getId(),
                    v.getName(),
                    farmCount,
                    animalCount,
                    recentVisits,
                    hasAlert
            ));
        }
        stats.setVillageStats(villageStats);

        // Top symptoms
        Map<String, Long> topSymptoms = new LinkedHashMap<>();
        List<Object[]> symptomCounts = visitSymptomRepository.countTopSymptoms();
        for (Object[] row : symptomCounts) {
            String code = (String) row[0];
            Long count = ((Number) row[1]).longValue();
            topSymptoms.put(code, count);
        }
        stats.setTopSymptoms(topSymptoms);

        return stats;
    }
}
