# VetLedger AI — Longitudinal Clinical Intelligence, Disease Surveillance & Owner Ledger

[![Spring Boot](https://img.shields.io/badge/Backend-Spring%20Boot%203.3-brightgreen.svg)](https://spring.io/)
[![Flutter](https://img.shields.io/badge/Mobile-Flutter%203.47-blue.svg)](https://flutter.dev/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL%2018-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-Apache%202.0-lightgrey.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-15%20Passing-success.svg)]()

> **Hackathon Prototype**: Transforms fragmented rural livestock records into longitudinal clinical continuity, proactive syndromic outbreak surveillance, and transparent owner-level financial ledger management.

---

## 📌 Project Overview & The 4 Core Pillars

In rural livestock healthcare, veterinary histories are fragmented across isolated visits, paper notebooks, and verbal handoffs. Recurring symptoms go unflagged, emerging regional clusters go undetected, and farm owners struggle with opaque billing across multiple animals.

**VetLedger AI** solves this with 4 unified, production-ready pillars:

### 1. Complete Farm & Animal Registration & Management
* **Farm Registry**: Register and manage commercial and smallholder farms with village linking, geocoordinates, total herd sizes, and owner attribution.
* **Animal Lifecycle Profiles**: Longitudinal records tracking species, breeds, ear-tag RFIDs, date of birth, lactating status, and complete health timeline.
* **Farm Profile Screen**: Dedicated hub with tabbed animal rosters, recent farm clinical encounters, and direct links to the owner financial ledger.

### 2. 5-Stage Longitudinal Clinical Intelligence
* **Draft Analysis Workflow**: Stage 1 (Select Animal) ➔ Stage 2 (Past Records Accordion) ➔ Stage 3 (Current Draft & Fee Breakdown) ➔ Stage 4 (Analyze Visit + History Preview) ➔ Stage 5 (Final Assessment & Submit).
* **7 Structured Intelligence Modules**:
  1. *Symptom Chronology & Evolution*: Tracks symptom onset, duration, and recurrence across history.
  2. *Current Clinical Presentation*: Synthesizes vitals, temperature, severity, and system findings.
  3. *Longitudinal Comparison*: Compares current draft against baseline visits and past treatment responses.
  4. *Differential Conditions to Consider*: Ranked veterinary differentials with confidence levels and clinical rationales.
  5. *Immediate Risk Indicators*: Flags hyperthermia, dehydration, systemic distress, and biosecurity threats.
  6. *Recommended Next Steps*: Evidence-based diagnostic sampling and supportive therapy suggestions.
  7. *Clinical Decision Template*: Pre-drafted SOAP summary editable by the attending veterinarian.
* **Honest Engine Fallback**: Deterministic rule-based synthesis that functions offline without crashing, paired with live LLM synthesis when Gemini API key is configured.
* **Mandatory Ethical Disclaimer**: Prominently displayed decision-support disclaimer on all clinical intelligence screens.

### 3. Population-Level Health Surveillance Center
* **Time-Window Filtering**: Dynamic observation windows (7 days, 14 days, 30 days) to evaluate acute vs sub-acute epidemiological trends.
* **Algorithmic Discrepancy Resolution**: Clearly distinguishes and mathematically explains **17 clustered animals** (syndromic fever + nasal discharge across 6 farms, 9.4x baseline) vs **22 total active animals** with any visit in Sangamner over 14 days.
* **Evidence Drill-Down**: Direct navigation from cluster alerts to affected farm rosters, individual animal histories, and standard biosecurity protocols.

### 4. Owner-Level Financial Ledger & Payment Tracking
* **Relational Hierarchy**: `Owner -> Farms -> Animals -> Visits -> Charges/Payments`.
* **Standardized Fee Breakdown**: Every visit captures Consultation Fee, Service/Procedure Fee, Medicine Fee, and Other Fee in Indian Rupees (₹).
* **Strict Owner-Level Balances**: No fragmented per-animal balances. All billing consolidates to the legal farm owner.
* **FIFO Payment Allocation**: Record partial or full payments with automatic FIFO allocation across unpaid historical visits.
* **Verifiable Payment Receipts**: Instant generation of formal, printable payment receipts (`/api/ledger/receipts/{paymentId}`) displaying transaction ID, date, payment method, allocated visits, and remaining balance.
* **Ledger Export**: One-click CSV export of owner financial statements (`/api/export/ledger/csv`).

---

## 🏗️ Technology Stack

| Layer | Technologies |
|---|---|
| **Mobile App** | Flutter 3.47+ (Dart 3.13+), Material 3, REST API client (`http`), `intl` |
| **Backend** | Java 21/25, Spring Boot 3.3.5, Spring Data JPA, Hibernate, Bean Validation |
| **Database** | PostgreSQL 18 (Relational schema, indexed Foreign Keys, reproducible seed v2) |
| **AI Integration** | Google Gemini LLM API + Zero-dependency Deterministic Clinical Engine |
| **Surveillance** | Pure Java rolling sliding-window syndromic surveillance with baseline normalization |
| **Financial Ledger** | Deterministic owner-level double-entry accounting with FIFO payment allocation |

---

## 📂 Repository Structure

```text
VetLedger-AI/
├── backend/                  # Spring Boot 3.3.5 REST API
│   ├── pom.xml               # Maven configuration (Java 21/25)
│   ├── src/main/java/        # Controllers, Services, Repositories, Entities, DTOs
│   │   └── com/vetledger/
│   │       ├── controller/   # Animal, Farm, Ledger, Surveillance, Intelligence, Export...
│   │       ├── dto/          # Structured requests & responses for 7 modules, ledgers, receipts
│   │       ├── entity/       # Owner, Farm, Animal, Visit, Payment, PaymentAllocation, FollowUp
│   │       ├── repository/   # Spring Data JPA repositories
│   │       └── service/      # Deterministic AI, Surveillance, Ledger, Export services
│   ├── src/main/resources/   # application.yml
│   └── src/test/java/        # Unit & Integration tests (Surveillance, AI, CRUD, Ledger)
├── mobile/                   # Flutter Mobile Application (Material 3)
│   ├── lib/
│   │   ├── models/           # Dart data models (OwnerLedger, Farm, Visit, CI 7 Modules)
│   │   ├── screens/          # Dashboard, Animals, Farms, Surveillance, Ledger, VisitEntry...
│   │   ├── services/         # ApiService with complete REST integration
│   │   ├── theme/            # Emerald/Teal Material 3 palette
│   │   └── widgets/          # Status badges, metric cards, receipts
│   ├── test/                 # Model and widget smoke tests
│   └── pubspec.yaml          # Dependencies: http, intl, flutter_test
├── database/                 # Database DDL & Seed scripts
│   ├── schema.sql            # Base schema (Villages, Farms, Animals, Visits)
│   ├── migration_v2.sql      # Schema v2 (Owners, Payments, Allocations, Fees, Follow-ups)
│   ├── seed_data.sql         # 5 villages, 12 farms, 80 animals, 193+ visits
│   └── generate_seed.py      # Python deterministic dataset generator
├── docs/                     # Comprehensive Hackathon Evaluation Documentation
│   ├── ARCHITECTURE.md       # Technical design, schema v2 & sequence flows
│   ├── AI_EXPLANATION.md     # Grounding strategy, 7 modules & deterministic fallback
│   ├── SURVEILLANCE_EXPLANATION.md # Mathematical proof of 17 vs 22 Sangamner counts
│   ├── HACKATHON_DEMO_SCRIPT.md    # 5-minute judge walkthrough across 4 pillars
│   ├── REMOTE_HOSTING_AND_MOBILE_GUIDE.md # Remote deployment & APK guide
│   └── EXPERIMENTAL_ML_STUDY.md    # Section 15 synthetic ML study
├── docker-compose.yml        # Multi-container orchestration (PostgreSQL + Backend)
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

# Apply Migration v2 (Owners, Financial Ledger, Fees, Follow-ups)
psql -U postgres -d vetledger_ai -f database/migration_v2.sql
```

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
* Verify farms: `curl http://localhost:8080/api/farms`
* Verify ledger summaries: `curl http://localhost:8080/api/ledger/owners`
* Verify surveillance overview: `curl http://localhost:8080/api/surveillance/overview?days=14`

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
* `VetLedgerAiApplicationTests`: Verifies Spring context loads.
* `SurveillanceEngineServiceTest`: Verifies Sangamner cluster detection (17 animals, 6 farms), distinct animal counting, and baseline isolation.
* `ClinicalIntelligenceServiceTest`: Verifies deterministic fallback synthesis and veterinary disclaimer.
* `AnimalAndVisitIntegrationTest`: Verifies search, visit fee calculations, and clinical encounter persistence.

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
1. **Dashboard**: View real database stats (80 animals, 12 farms, 5 villages, active surveillance alert).
2. **Farm Management**: Browse farms by village, view farm profiles, animal rosters, and link directly to owner financials.
3. **Animal Registry**: Register a new animal with ear-tag validation, or view Lakshmi's (`COW-SNG-101`) longitudinal timeline.
4. **5-Stage Visit Entry**: Draft a new visit, enter fee breakdown (₹), and click **"Analyze Current Visit + Medical History"**.
5. **7-Module Clinical Intelligence**: Inspect symptom chronology, current presentation, historical comparison, differentials, risk indicators, next steps, and decision template.
6. **Surveillance Center**: Toggle 7d / 14d / 30d windows, inspect the Sangamner cluster, and review the clear 17 vs 22 active animal explanation.
7. **Owner Financial Ledger**: Open Suresh Patil's ledger, review unbilled visit charges, record a partial payment in ₹, and generate a printable payment receipt.

---

## 📄 License & Attribution
VetLedger AI is released under the **Apache 2.0 License**. All demonstration records, village names, and patient IDs are completely synthetic.
