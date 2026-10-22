-- ============================================================================
-- VETLEDGER AI - RELATIONAL DATABASE SCHEMA (PostgreSQL)
-- Target Database: vetledger_ai
-- Hackathon Prototype: Longitudinal Clinical Intelligence & Livestock Surveillance
-- ============================================================================

-- Drop tables in reverse dependency order if needed for clean re-creation
DROP TABLE IF EXISTS visit_symptoms CASCADE;
DROP TABLE IF EXISTS visits CASCADE;
DROP TABLE IF EXISTS animals CASCADE;
DROP TABLE IF EXISTS farms CASCADE;
DROP TABLE IF EXISTS villages CASCADE;

-- 1. VILLAGES
CREATE TABLE villages (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    district VARCHAR(100) NOT NULL DEFAULT 'Ahmednagar',
    state VARCHAR(100) NOT NULL DEFAULT 'Maharashtra',
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. FARMS
CREATE TABLE farms (
    id BIGSERIAL PRIMARY KEY,
    farm_code VARCHAR(50) NOT NULL UNIQUE,
    farm_name VARCHAR(150) NOT NULL,
    owner_name VARCHAR(150) NOT NULL,
    contact_number VARCHAR(30),
    village_id BIGINT NOT NULL REFERENCES villages(id) ON DELETE RESTRICT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_farms_village_id ON farms(village_id);

-- 3. ANIMALS
CREATE TABLE animals (
    id BIGSERIAL PRIMARY KEY,
    animal_code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    species VARCHAR(50) NOT NULL, -- Cattle, Buffalo, Goat, Sheep
    breed VARCHAR(100),           -- Gir, Murrah, HF Cross, Osmanabadi, etc.
    age_years NUMERIC(4, 1),
    sex VARCHAR(20) NOT NULL,     -- FEMALE, MALE
    farm_id BIGINT NOT NULL REFERENCES farms(id) ON DELETE RESTRICT,
    tag_rfid VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_animals_farm_id ON animals(farm_id);
CREATE INDEX idx_animals_species ON animals(species);
CREATE INDEX idx_animals_code ON animals(animal_code);

-- 4. VISITS
CREATE TABLE visits (
    id BIGSERIAL PRIMARY KEY,
    animal_id BIGINT NOT NULL REFERENCES animals(id) ON DELETE CASCADE,
    visit_date DATE NOT NULL,
    presenting_complaint VARCHAR(255) NOT NULL,
    observations TEXT,
    severity VARCHAR(30) NOT NULL DEFAULT 'MODERATE', -- MILD, MODERATE, SEVERE
    temperature_celsius NUMERIC(4, 1),
    treatment_notes TEXT,
    follow_up_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_visits_animal_id ON visits(animal_id);
CREATE INDEX idx_visits_visit_date ON visits(visit_date);

-- 5. VISIT SYMPTOMS (Normalized representation of multiple symptoms per visit)
CREATE TABLE visit_symptoms (
    id BIGSERIAL PRIMARY KEY,
    visit_id BIGINT NOT NULL REFERENCES visits(id) ON DELETE CASCADE,
    symptom_code VARCHAR(60) NOT NULL, -- FEVER, NASAL_DISCHARGE, REDUCED_APPETITE, etc.
    severity VARCHAR(30) DEFAULT 'MODERATE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_visit_symptom UNIQUE (visit_id, symptom_code)
);

CREATE INDEX idx_visit_symptoms_visit_id ON visit_symptoms(visit_id);
CREATE INDEX idx_visit_symptoms_code ON visit_symptoms(symptom_code);

-- Comments for documentation & judge inspection
COMMENT ON TABLE villages IS 'Geographic village administrative unit for spatial clustering';
COMMENT ON TABLE farms IS 'Livestock farms mapped to specific villages';
COMMENT ON TABLE animals IS 'Longitudinal animal records tracked across multiple farm visits';
COMMENT ON TABLE visits IS 'Veterinary clinical encounter records';
COMMENT ON TABLE visit_symptoms IS 'Normalized standardized clinical symptom manifestations per visit';
