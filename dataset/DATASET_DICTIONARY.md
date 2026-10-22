# VetLedger AI — Synthetic Dataset Dictionary

> **Disclaimer**: All data in this repository is **100% synthetic** generated exclusively for demonstration, algorithmic benchmarking, and hackathon evaluation. No real farm, animal, veterinarian, or patient health information is used or represented.

---

## 1. Overview & Statistics

| Entity | Count | Description |
|---|---|---|
| **Villages** | 5 | Geographic administrative units in Ahmednagar district, Maharashtra |
| **Farms** | 12 | Dairy and livestock farming establishments distributed across villages |
| **Animals** | 80 | Individual livestock records (Cattle, Buffalo, Goat) with longitudinal history |
| **Visits** | 193+ | Longitudinal clinical encounters with complaints, observations, vitals, treatments |
| **Visit Symptoms** | 389+ | Normalized symptom tags mapped per visit for aggregation and surveillance |

---

## 2. Standardized Demonstration Symptoms

The application uses 8 standardized clinical demonstration symptom categories:

| Symptom Code | Display Name | Clinical Context | Typical Severity |
|---|---|---|---|
| `FEVER` | Fever / Hyperthermia | Rectal temperature > 39.5°C in cattle/buffalo | Moderate to Severe |
| `NASAL_DISCHARGE` | Nasal Discharge | Bilateral serous, mucopurulent, or catarrhal exudate | Mild to Severe |
| `REDUCED_APPETITE` | Reduced Appetite / Anorexia | Complete or partial off-feed, ruminal stasis | Mild to Severe |
| `COUGH` | Cough / Respiratory Rales | Dry, hacking, or moist respiratory cough | Mild to Moderate |
| `DIARRHEA` | Diarrhea / Scouring | Watery, foul, or hemorrhagic enteritis | Moderate to Severe |
| `LETHARGY` | Lethargy / Dull Demeanor | Decreased alertness, drooping ears, reluctant to rise | Mild to Severe |
| `EXCESSIVE_SALIVATION` | Excessive Salivation / Drooling | Frothy or stringy saliva from oral lesions or dysphagia | Mild to Severe |
| `REDUCED_MILK_PRODUCTION` | Reduced Milk Yield | Acute drop in daily milking output (>20% decline) | Mild to Moderate |

---

## 3. Deliberately Seeded Surveillance Scenario

A synthetic epidemiological signal has been deliberately seeded into the dataset to demonstrate the surveillance engine's real-time pattern detection capabilities:

### Scenario Specifications:
* **Target Village**: **Sangamner** (Village ID: 1, Lat: 19.5772, Lon: 74.2185)
* **Observation Window**: Recent 14 Days (Rolling window)
* **Affected Farms**: **6 distinct farms** (`FARM-SNG-01` to `FARM-SNG-06`)
* **Distinct Affected Animals**: **17 distinct animals**
* **Predominant Symptom Cluster**: `FEVER` + `NASAL_DISCHARGE` + `REDUCED_APPETITE` (with occasional `COUGH` and `LETHARGY`)
* **Historical Baseline**: Historically in Sangamner, nasal discharge and fever presentations averaged **~1.5 to 2.0 animals** per 14-day period.
* **Signal Elevation**: **17 / 1.8 ≈ 9.4x above historical baseline**
* **Algorithmic Classification**: **Unusual Symptom Concentration / Potential Cluster** (Priority: HIGH)

### Why this is authentic:
The surveillance algorithm does not read a hardcoded alert. Instead, it queries the actual visit records in PostgreSQL, groups visits by village and symptom signatures, computes unique animal counts using sets, computes unique farm counts, compares against historical windows, and generates the alert dynamically from stored evidence.

---

## 4. Entity Field Definitions

### 4.1 Villages (`villages`)
* `id` (BIGINT): Unique identifier
* `name` (VARCHAR): Village name (Sangamner, Rahata, Akole, Kopargaon, Shrirampur)
* `district` (VARCHAR): District administrative zone (Ahmednagar)
* `state` (VARCHAR): State (Maharashtra)
* `latitude`, `longitude` (FLOAT): Geographic centroid coordinates

### 4.2 Farms (`farms`)
* `id` (BIGINT): Unique identifier
* `farm_code` (VARCHAR): Standardized farm code (e.g., `FARM-SNG-01`)
* `farm_name` (VARCHAR): Name of farm establishment
* `owner_name` (VARCHAR): Registered livestock keeper
* `contact_number` (VARCHAR): Synthetic contact number
* `village_id` (BIGINT, FK): Associated village
* `latitude`, `longitude` (FLOAT): Farm location coordinates

### 4.3 Animals (`animals`)
* `id` (BIGINT): Primary key
* `animal_code` (VARCHAR, UNIQUE): Visual tag identifier (e.g., `CAT-SNG-001`, `BUF-SNG-015`)
* `name` (VARCHAR): Local animal identifier (e.g., Lakshmi, Gauri, Shyama)
* `species` (VARCHAR): Cattle, Buffalo, Goat
* `breed` (VARCHAR): Gir, Murrah, Holstein Friesian Cross, Osmanabadi, etc.
* `age_years` (NUMERIC): Age in years (e.g. 4.2)
* `sex` (VARCHAR): FEMALE, MALE
* `farm_id` (BIGINT, FK): Registered farm
* `tag_rfid` (VARCHAR): Electronic ear-tag RFID string
* `notes` (TEXT): Baseline management notes

### 4.4 Visits (`visits`)
* `id` (BIGINT): Primary key
* `animal_id` (BIGINT, FK): Animal attended
* `visit_date` (DATE): Date of veterinary clinical encounter
* `presenting_complaint` (VARCHAR): Primary reason for call
* `observations` (TEXT): Physical examination, auscultation, mucosal exam, rumen motility
* `severity` (VARCHAR): MILD, MODERATE, SEVERE
* `temperature_celsius` (NUMERIC): Rectal temperature in Celsius (normal: 38.0–39.3°C)
* `treatment_notes` (TEXT): Administered therapies, antipyretics, fluid resuscitation
* `follow_up_notes` (TEXT): Isolation instructions, monitoring schedules

### 4.5 Visit Symptoms (`visit_symptoms`)
* `id` (BIGINT): Primary key
* `visit_id` (BIGINT, FK): Associated visit
* `symptom_code` (VARCHAR): Standardized enum code
* `severity` (VARCHAR): Individual symptom intensity
