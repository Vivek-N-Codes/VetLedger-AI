package com.vetledger.dto;

import java.util.ArrayList;
import java.util.List;

public class GlobalSearchResponse {
    private String query;
    private int totalMatches;
    private List<AnimalSummaryDto> animals = new ArrayList<>();
    private List<FarmSummaryDto> farms = new ArrayList<>();
    private List<OwnerDto> owners = new ArrayList<>();
    private List<VillageDto> villages = new ArrayList<>();

    public static class VillageDto {
        private Long id;
        private String name;
        private String district;
        private String state;
        private int farmCount;
        private int animalCount;

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getDistrict() { return district; }
        public void setDistrict(String district) { this.district = district; }
        public String getState() { return state; }
        public void setState(String state) { this.state = state; }
        public int getFarmCount() { return farmCount; }
        public void setFarmCount(int farmCount) { this.farmCount = farmCount; }
        public int getAnimalCount() { return animalCount; }
        public void setAnimalCount(int animalCount) { this.animalCount = animalCount; }
    }

    public String getQuery() { return query; }
    public void setQuery(String query) { this.query = query; }

    public int getTotalMatches() { return totalMatches; }
    public void setTotalMatches(int totalMatches) { this.totalMatches = totalMatches; }

    public List<AnimalSummaryDto> getAnimals() { return animals; }
    public void setAnimals(List<AnimalSummaryDto> animals) { this.animals = animals; }

    public List<FarmSummaryDto> getFarms() { return farms; }
    public void setFarms(List<FarmSummaryDto> farms) { this.farms = farms; }

    public List<OwnerDto> getOwners() { return owners; }
    public void setOwners(List<OwnerDto> owners) { this.owners = owners; }

    public List<VillageDto> getVillages() { return villages; }
    public void setVillages(List<VillageDto> villages) { this.villages = villages; }
}
