# VetLedger AI — Longitudinal Clinical Intelligence & Livestock Disease Surveillance

[![Spring Boot](https://img.shields.io/badge/Backend-Spring%20Boot%203.3-brightgreen.svg)](https://spring.io/)
[![Flutter](https://img.shields.io/badge/Mobile-Flutter%203.47-blue.svg)](https://flutter.dev/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2018-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-Apache%202.0-lightgrey.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-15%20Passing-success.svg)]()

> **Hackathon Prototype**: Transforms fragmented rural livestock records into longitudinal clinical continuity and early syndromic outbreak surveillance.

---

## 📌 Project Overview

In rural livestock healthcare, veterinary histories are fragmented across isolated visits. Important recurring symptoms and multi-farm symptom concentrations often go unnoticed until diseases spread widely.

**VetLedger AI** provides:
1. **Longitudinal Animal Health Histories**: Real-time chronological tracking of livestock encounters across ear-tag RFIDs, vitals, standardized symptoms, and treatments.
2. **Record-Grounded Clinical AI**: Structured clinical intelligence with automatic fallback to an explainable deterministic heuristics engine when external LLMs are unavailable.
3. **Data-Driven Symptom Surveillance**: Java-based syndromic surveillance detecting anomalous concentrations across distinct animals and farms, dynamically discovering our seeded Sangamner cluster (17 animals, 6 farms, 9.4x baseline elevation).
4. **Professional HealthTech Mobile UI**: 7 complete, polished screens designed in Material 3 with deep teal/emerald aesthetics.

---

## 🏗️ Technology Stack

| Layer | Technologies |
|---|---|
| **Mobile App** | Flutter 3.47+ (Dart 3.13+), Material 3, REST API client (`http`), `intl` |
| **Backend** | Java 21/25, Spring Boot 3.3.5, Spring Data JPA, Hibernate, Bean Validation |
| **Database** | PostgreSQL 18 (Relational schema, indexed Foreign Keys, reproducible seed) |
| **AI Integration** | Google Gemini LLM API + Zero-dependency Deterministic Clinical Engine |
| **Surveillance** | Pure Java rolling 14-day sliding window algorithm with baseline normalization |

---

## 📂 Repository Structure

```text
VetLedger-AI/
├── backend/                  # Spring Boot 3.3.5 REST API
│   ├── pom.xml               # Maven configuration (Java 21/25)
│   ├── src/main/java/        # Entities, Repositories, Services, Controllers
│   ├── src/main/resources/   # application.yml
│   └── src/test/java/        # Unit & Integration tests (Surveillance, AI, CRUD)
├── mobile/                   # Flutter Mobile Application
│   ├── lib/                  # Screens, Services, Models, Themes, Widgets
│   ├── test/                 # Widget and model unit tests
│   └── pubspec.yaml          # Flutter dependencies
├── database/                 # Database DDL & Seed scripts
│   ├── schema.sql            # PostgreSQL DDL table definitions
│   ├── seed_data.sql         # 5 villages, 12 farms, 80 animals, 193+ visits
│   └── generate_seed.py      # Python deterministic dataset generator
├── dataset/                  # Dataset Documentation & Studies
│   ├── DATASET_DICTIONARY.md # Field dictionary, symptoms, seeded cluster details
│   └── train_experimental_model.py # Experimental ML study script
├── docs/                     # Comprehensive Hackathon Evaluation Documentation
│   ├── ARCHITECTURE.md       # Technical design & sequence flows
│   ├── AI_EXPLANATION.md     # Grounding strategy & deterministic fallback
│   ├── SURVEILLANCE_EXPLANATION.md # Statistical detection algorithm & mathematics
│   ├── HACKATHON_DEMO_SCRIPT.md    # 5-minute judge walkthrough
│   └── EXPERIMENTAL_ML_STUDY.md    # Section 15 synthetic ML study
├── .env.example              # Environment variables template
├── .gitignore                # Clean source control exclusions
└── README.md                 # Primary project guide
```

---

## 🚀 Quickstart Guide

### 1. Prerequisites Check
Verify your installed tools:
```powershell
java -version       # OpenJDK 21 or 25
mvn -v              # Apache Maven 3.8+
flutter --version   # Flutter 3.20+
psql --version      # PostgreSQL 14+
```

---

### 2. Database Setup (PostgreSQL)
Create the dedicated hackathon database and initialize the schema and seed data:

```powershell
# Create database
psql -U postgres -c "CREATE DATABASE vetledger_ai;"

# Load schema and deterministic dataset
psql -U postgres -d vetledger_ai -f database/schema.sql
psql -U postgres -d vetledger_ai -f database/seed_data.sql
```

*Note: The backend also contains an automatic `DataSeederService` that safely loads the seed data on startup if the database is unpopulated.*

---

### 3. Start the Backend API
Navigate to `backend/` and run Spring Boot:

```powershell
cd backend
mvn spring-boot:run
```

The API starts on `http://localhost:8080`.
* Verify health: `curl http://localhost:8080/api/health`
* Verify dashboard: `curl http://localhost:8080/api/dashboard`
* Verify surveillance clusters: `curl http://localhost:8080/api/surveillance/clusters`

---

### 4. Optional: Configure Gemini API Key
To enable live LLM synthesis, set the environment variable before starting the backend:
```powershell
$env:GEMINI_API_KEY="your-gemini-api-key"
```
*If left blank, the application automatically uses the **Deterministic Clinical Fallback Engine**, which synthesizes actual stored records without crashing or faking responses.*

---

### 5. Launch the Flutter Mobile App
Navigate to `mobile/` and run Flutter:

```powershell
cd mobile

# Run on Windows Desktop
flutter run -d windows

# Or run on Chrome / Web
flutter run -d chrome

# Or launch on Android Emulator
flutter emulators --launch Medium_Phone_API_37.0
flutter run
```

#### Mobile Network Configuration:
* **Desktop / Web**: Connects to `http://localhost:8080/api` automatically.
* **Android Emulator**: Connects to `http://10.0.2.2:8080/api` automatically.
* **Physical Device**: Tap the network settings icon (top-right of app bar) and enter `http://<YOUR_LAN_IP>:8080/api`.

---

## 🧪 Testing and Verification

### Backend Tests (Spring Boot)
Run all 7 automated unit and integration tests:
```powershell
cd backend
mvn clean test
```
* `VetLedgerAiApplicationTests`: Verifies context loads.
* `SurveillanceEngineServiceTest`: Verifies Sangamner cluster detection (17 animals, 6 farms), distinct animal counting, and baseline isolation.
* `ClinicalIntelligenceServiceTest`: Verifies deterministic fallback synthesis and veterinary disclaimer.
* `AnimalAndVisitIntegrationTest`: Verifies search and clinical encounter persistence.

### Flutter Tests
Run Flutter static analysis and widget/model tests:
```powershell
cd mobile
flutter analyze  # 0 issues found
flutter test     # 8 passing tests
```

---

## 🏆 Hackathon Demonstration Workflow

Follow the step-by-step walkthrough in [`docs/HACKATHON_DEMO_SCRIPT.md`](docs/HACKATHON_DEMO_SCRIPT.md):
1. **Dashboard**: View real database stats (80 animals, 12 farms, 5 villages, 1 active alert).
2. **Search Animals**: Filter by village (Sangamner) or search `Lakshmi` (`COW-SNG-101`).
3. **Longitudinal Profile**: View complete chronological encounter history with vitals and symptom tags.
4. **Record New Visit**: Enter symptoms (Fever, Cough, Reduced Appetite), save, and watch the timeline refresh immediately.
5. **AI Clinical Intelligence**: View clinical summary, recurring symptoms, trajectory, risk indicators, differential considerations, and honest engine source badge.
6. **Surveillance Dashboard**: Inspect the Sangamner cluster (17 animals, 6 farms, 9.4x baseline elevation).
7. **Cluster Investigation**: Drill down into affected farms, distinct animals, statistical proof, and recommended field protocol.

---

## 📄 License & Attribution
VetLedger AI is released under the **Apache 2.0 License**. All demonstration records, village names, and patient IDs are completely synthetic.
