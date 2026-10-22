package com.vetledger.service;

import com.vetledger.dto.AnimalSummaryDto;
import com.vetledger.dto.FarmSummaryDto;
import com.vetledger.dto.GlobalSearchResponse;
import com.vetledger.dto.OwnerDto;
import com.vetledger.entity.Animal;
import com.vetledger.entity.Farm;
import com.vetledger.entity.Owner;
import com.vetledger.entity.Village;
import com.vetledger.repository.AnimalRepository;
import com.vetledger.repository.FarmRepository;
import com.vetledger.repository.OwnerRepository;
import com.vetledger.repository.VillageRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class GlobalSearchService {

    private final AnimalRepository animalRepository;
    private final FarmRepository farmRepository;
    private final OwnerRepository ownerRepository;
    private final VillageRepository villageRepository;

    public GlobalSearchService(
            AnimalRepository animalRepository,
            FarmRepository farmRepository,
            OwnerRepository ownerRepository,
            VillageRepository villageRepository) {
        this.animalRepository = animalRepository;
        this.farmRepository = farmRepository;
        this.ownerRepository = ownerRepository;
        this.villageRepository = villageRepository;
    }

    public GlobalSearchResponse search(String query) {
        GlobalSearchResponse res = new GlobalSearchResponse();
        res.setQuery(query);
        if (query == null || query.trim().isEmpty()) {
            return res;
        }

        String q = query.trim();

        // 1. Animals
        List<Animal> animals = animalRepository.searchAnimals(q, null, null, null);
        List<AnimalSummaryDto> animalDtos = animals.stream().limit(10).map(a -> {
            AnimalSummaryDto dto = new AnimalSummaryDto();
            dto.setId(a.getId());
            dto.setAnimalCode(a.getAnimalCode());
            dto.setName(a.getName());
            dto.setSpecies(a.getSpecies());
            dto.setBreed(a.getBreed());
            dto.setAgeYears(a.getAgeYears());
            dto.setSex(a.getSex());
            dto.setTagRfid(a.getTagRfid());
            if (a.getFarm() != null) {
                dto.setFarmId(a.getFarm().getId());
                dto.setFarmName(a.getFarm().getFarmName());
                if (a.getFarm().getVillage() != null) {
                    dto.setVillageName(a.getFarm().getVillage().getName());
                }
            }
            return dto;
        }).collect(Collectors.toList());
        res.setAnimals(animalDtos);

        // 2. Farms
        List<Farm> farms = farmRepository.searchFarms(q);
        List<FarmSummaryDto> farmDtos = farms.stream().limit(10).map(f -> {
            FarmSummaryDto dto = new FarmSummaryDto();
            dto.setId(f.getId());
            dto.setFarmCode(f.getFarmCode());
            dto.setFarmName(f.getFarmName());
            dto.setOwnerName(f.getOwnerName());
            dto.setContactNumber(f.getContactNumber());
            if (f.getVillage() != null) {
                dto.setVillageId(f.getVillage().getId());
                dto.setVillageName(f.getVillage().getName());
            }
            dto.setAnimalCount(animalRepository.findByFarmId(f.getId()).size());
            return dto;
        }).collect(Collectors.toList());
        res.setFarms(farmDtos);

        // 3. Owners
        List<Owner> owners = ownerRepository.searchOwners(q);
        List<OwnerDto> ownerDtos = owners.stream().limit(10).map(o -> {
            OwnerDto dto = new OwnerDto();
            dto.setId(o.getId());
            dto.setOwnerCode(o.getOwnerCode());
            dto.setFullName(o.getFullName());
            dto.setContactNumber(o.getContactNumber());
            dto.setEmail(o.getEmail());
            dto.setAddress(o.getAddress());
            if (o.getVillage() != null) {
                dto.setVillageName(o.getVillage().getName());
            }
            dto.setFarmCount(farmRepository.findByOwnerIdOrderByFarmNameAsc(o.getId()).size());
            return dto;
        }).collect(Collectors.toList());
        res.setOwners(ownerDtos);

        // 4. Villages
        List<Village> villages = villageRepository.findAll().stream()
                .filter(v -> v.getName().toLowerCase().contains(q.toLowerCase()))
                .limit(5)
                .collect(Collectors.toList());
        List<GlobalSearchResponse.VillageDto> villageDtos = villages.stream().map(v -> {
            GlobalSearchResponse.VillageDto dto = new GlobalSearchResponse.VillageDto();
            dto.setId(v.getId());
            dto.setName(v.getName());
            dto.setDistrict(v.getDistrict());
            dto.setState(v.getState());
            dto.setFarmCount((int) farmRepository.countByVillageId(v.getId()));
            dto.setAnimalCount(animalRepository.findByVillageId(v.getId()).size());
            return dto;
        }).collect(Collectors.toList());
        res.setVillages(villageDtos);

        res.setTotalMatches(animalDtos.size() + farmDtos.size() + ownerDtos.size() + villageDtos.size());
        return res;
    }
}
