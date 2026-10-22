package com.vetledger.service;

import com.vetledger.repository.VillageRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.FileSystemResource;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.io.File;

@Service
public class DataSeederService implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataSeederService.class);

    private final VillageRepository villageRepository;
    private final DataSource dataSource;

    public DataSeederService(VillageRepository villageRepository, DataSource dataSource) {
        this.villageRepository = villageRepository;
        this.dataSource = dataSource;
    }

    @Override
    public void run(String... args) {
        long villageCount = villageRepository.count();
        if (villageCount > 0) {
            log.info("Database already seeded ({} villages present). Skipping seed data loading.", villageCount);
            return;
        }

        log.info("Database is empty. Initializing synthetic demonstration dataset...");
        try {
            // Check for database/seed_data.sql in standard relative paths
            File seedFile = new File("database/seed_data.sql");
            if (!seedFile.exists()) {
                seedFile = new File("../database/seed_data.sql");
            }

            if (seedFile.exists()) {
                log.info("Executing seed file: {}", seedFile.getAbsolutePath());
                ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
                populator.setContinueOnError(true);
                populator.setIgnoreFailedDrops(true);
                populator.addScript(new FileSystemResource(seedFile));
                populator.execute(dataSource);
                log.info("Database seeded successfully from SQL script. Total villages: {}", villageRepository.count());
            } else {
                log.warn("Seed file database/seed_data.sql not found at expected path: {}", seedFile.getAbsolutePath());
            }
        } catch (Exception ex) {
            log.error("Failed to seed database automatically: {}", ex.getMessage(), ex);
        }
    }
}
