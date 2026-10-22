# VetLedger AI — System Architecture & Design Specification

## 1. Architectural Philosophy

**VetLedger AI** is engineered as a resilient, decoupled HealthTech decision-support platform designed specifically for rural livestock veterinary care and district-level disease surveillance.

The system addresses three critical operational gaps in animal healthcare:
1. **Fragmented Longitudinal Records**: Animal health events are historically recorded in isolation, preventing veterinarians from identifying chronic or evolving clinical patterns.
2. **Delayed Emerging Disease Recognition**: Symptom patterns spread across multiple smallholder farms and villages often escape manual observation until an outbreak has progressed.
3. **Connectivity & AI Fragility**: Rural clinics face intermittent internet connectivity and volatile LLM rate limits. VetLedger AI enforces a zero-dependency deterministic fallback engine to guarantee uninterrupted service.

```mermaid
graph TD
    subgraph Mobile ["Mobile Client (Flutter / Dart)"]
        UI_Dash["Dashboard (KPIs & Alerts)"]
        UI_Animals["Animal Search & Timeline"]
        UI_Visit["Clinical Visit Entry"]
        UI_AI["AI Clinical Intelligence"]
        UI_Surv["Surveillance & Cluster Investigation"]
    end

    subgraph Backend ["Spring Boot REST API (Java 21/25)"]
        API_Gateway["Controllers & Validation"]
        Service_Clinical["Clinical Intelligence Service"]
        Service_Surv["Surveillance Engine (Java-based)"]
        Service_Data["Animal & Visit Services"]
    end

    subgraph DataStore ["Database & Persistence"]
        PG["PostgreSQL (Relational Schema & Indexes)"]
    end

    subgraph ExternalAI ["External AI Provider"]
        Gemini["Google Gemini LLM API"]
    end

    UI_Dash -->|REST / JSON| API_Gateway
    UI_Animals -->|REST / JSON| API_Gateway
    UI_Visit -->|POST /api/visits| API_Gateway
    UI_AI -->|POST /clinical-intelligence| API_Gateway
    UI_Surv -->|GET /surveillance/clusters| API_Gateway

    API_Gateway --> Service_Clinical
    API_Gateway --> Service_Surv
    API_Gateway --> Service_Data

    Service_Data --> PG
    Service_Surv -->|Read Window & Baseline Records| PG
    Service_Clinical -->|Read Animal History| PG
    Service_Clinical -.->|Live Calls When Key Present| Gemini
    Service_Clinical -->|Deterministic Heuristics Fallback| Service_Clinical
```

---

## 2. Component Architecture

### 2.1 Mobile Application (`mobile/`)
* **Framework**: Flutter 3.47+ (Dart 3.13+)
* **Design System**: Material 3 HealthTech theme
* **Color Palette**:
  - Primary: Deep Teal (`#006A60`)
  - Primary Light: Soft Mint (`#E6F5F2`)
  - Accent / Monitoring: Emerald (`#0F766E`), Sage (`#2DD4BF`)
  - Alert / Priority: Crimson (`#DC2626`), Amber (`#D97706`)
  - Surface: Neutral Slate (`#F8FAF9`, `#FFFFFF`)
* **State & Networking**: REST API integration via `http` client with auto-detection of Android Emulator (`10.0.2.2`), Desktop/Web (`localhost`), or configurable LAN IP.
* **Core Screens & Workflows**:
  1. `DashboardScreen`: System overview, key performance indicators, active alerts banner, quick clinical actions, recent visits timeline.
  2. `AnimalListScreen`: Full-text search by animal code, name, breed, or farm; village and species filter chips; "Register Animal" action with validation.
  3. `AnimalProfileScreen`: Complete longitudinal health profile, farm linkage, RFID tag, chronological encounter history with vitals and symptom tags.
  4. `FarmsScreen`: Complete farm management directory with village filtering, search, and "Add Farm" registration dialog.
  5. `FarmProfileScreen`: Farm profile with owner details, direct link to owner financial ledger, registered livestock list, and recent clinical history.
  6. `VisitEntryScreen`: 5-Stage Clinical Intelligence Workflow:
     - Stage 1: Animal Identification & Context
     - Stage 2: Previous Health Records Accordion (past diagnoses, recurring symptoms)
     - Stage 3: Current Visit Draft Entry & Fee Breakdown (Consultation ₹, Services ₹, Meds ₹, Other ₹ -> Auto Total Charge ₹)
     - Stage 4: "Analyze Current Visit + Medical History" Draft Intelligence Preview (calling non-persisting `/api/animals/draft-analysis`)
     - Stage 5: Final Veterinary Assessment & Action (Assessment, actual treatment administered, owner advice, follow-up scheduling, and persistence)
  7. `ClinicalIntelligenceScreen`: Structured AI clinical decision-support displaying **7 modular sections**:
     - Module 1: Longitudinal Symptom Tracker (recurrent vs new symptoms, occurrence rates, first & last recorded dates)
     - Module 2: Current Clinical Presentation (vitals, onset, exam findings, prior home treatments)
     - Module 3: Historical Comparison & Severity Trajectory
     - Module 4: Possible Conditions to Consider (differential diagnoses, supporting findings, tests to distinguish)
     - Module 5: Risk Indicators & Clinical Concerns (urgency level, deterministic rule flags, clinical insights)
     - Module 6: Recommended Next Steps (chute observations, examinations to consider, veterinary notice)
     - Module 7: Clinical Decision & Follow-Up Template
  8. `SurveillanceDashboardScreen`: Real-time syndromic surveillance cluster cards, sliding observation window selector (7, 14, 30 days), population overview metrics, and dedicated discrepancy clarification banner (17 cluster cases vs 22 total active animals).
  9. `ClusterInvestigationScreen`: Drill-down cluster investigation showing why the cluster was detected, affected distinct animals (with direct profile navigation), affected farms, baseline comparison metrics, and recommended field veterinary actions.
  10. `LedgerScreen`: Complete Owner-Level Financial Ledger:
      - Owner directory with total billed, total paid, and outstanding balances
      - Owner Statement view detailing all clinical encounter charges and payments
      - Record Payment dialog with payment methods (CASH, UPI, BANK_TRANSFER, CHEQUE)
      - Printable/viewable formal payment receipts with automatic FIFO allocation to visits

---

### 2.2 Backend Service (`backend/`)
* **Framework**: Spring Boot 3.3.5 / Java 21 / 25
* **Architecture**: Clean 4-tier layered architecture (Controller -> Service -> Repository -> Entity)
* **API Standards**: RESTful JSON with Bean Validation (`@Valid`, `@NotNull`, `@NotEmpty`), RFC 7807 compliant error handling via `@RestControllerAdvice`.
* **CORS**: Universally configured for seamless local mobile development, emulator testing, and desktop/web clients via `CorsConfig` (`allowedOriginPatterns("*")` and `allowCredentials(true)`).

---

### 2.3 Database Layer (`database/`)
* **Engine**: PostgreSQL (Production) / In-Memory H2 (Testing)
* **Schema Evolution (v2 Migration)**:
  - `villages`: Spatial centroids, administrative districts
  - `owners`: Farmer entities with contact numbers, addresses, and village mapping
  - `farms`: Registered livestock units mapped to owners and villages
  - `animals`: Individual livestock records with longitudinal foreign keys
  - `visits`: Clinical encounters, vitals, observations, treatments, fees (`consultation_fee`, `service_fee`, `medicine_fee`, `other_fee`, `total_charge`), and follow-up tracking
  - `visit_symptoms`: Normalized junction entity for flexible, index-accelerated symptom aggregation and clustering
  - `payments`: Financial payment receipts in INR (₹) recorded at owner level
  - `payment_allocations`: Automatic FIFO allocations of payments to specific unpaid visits
  - `clinical_follow_ups`: Scheduled clinical follow-ups with due dates and statuses
* **Reproducibility**: Pre-seeded with 5 villages, 12 owners, 12 farms, 80 animals, 195 visits, 12 payments, and realistic clinical fees. Idempotent initialization via `DataSeederService` prevents duplicate records upon restart.

---

## 3. Security, Boundaries & Compliance

1. **Synthetic Isolation**:
   - The hackathon prototype resides strictly in `D:\Hackathons\VetLedger-AI\`.
   - Never accesses or modifies any external production codebase or database.
   - All demonstration data is visibly and programmatically flagged as synthetic.
2. **Credential Management**:
   - API keys are injected exclusively via environment variables (`GEMINI_API_KEY`).
   - Secrets are never embedded in mobile code, git history, or client API responses.
   - Zero-key startup: The entire system functions fully out of the box using deterministic intelligence when no API key is provided.
3. **Veterinary Decision Support Disclaimers**:
   - The platform strictly produces advisory decision support.
   - Mandatory disclaimers are enforced across all AI responses and surveillance alerts: *"AI-generated clinical decision support. Final assessment remains with a qualified veterinarian."*

