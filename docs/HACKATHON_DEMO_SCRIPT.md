# VetLedger AI — Hackathon Live Demonstration Script (5-Minute Walkthrough)

> **Audience**: Hackathon Judges, Veterinary Health Officers, Technical Evaluators  
> **Presenter**: Senior Full-Stack / Veterinary Informatics Team  
> **Time**: ~5 Minutes  

---

## 🎤 Hook & Introduction (30 Seconds)

> *"Good afternoon, judges. In rural livestock healthcare, veterinary management is broken in three critical ways:
> 1. Clinical records are fragmented across paper slips, meaning recurring chronic conditions are missed.
> 2. Infectious outbreaks spread unnoticed across neighboring farms for weeks before district officers notice.
> 3. Farm owners suffer from chaotic, opaque finances where animal charges are scribbled without formal tracking or verifiable receipts.
>
> Today, we present **VetLedger AI** — transforming fragmented livestock records into longitudinal clinical continuity, proactive syndromic outbreak surveillance, and transparent owner-level financial ledger management.
>
> Every number and workflow you see today is live, backed by our Spring Boot 3.3 REST API and PostgreSQL database."*

---

## 📱 Step 1: Real-Time Dashboard & Synthetic Transparency (30 Seconds)

1. **Show the Dashboard screen**:
   * Point out the live database counters: **80 Total Animals**, **12 Farms**, **5 Villages Covered**, and **195+ Clinical Encounters**.
   * Highlight the **"SYNTHETIC DEMO"** badge:
     > *"As responsible software engineers, we believe in radical transparency: our demonstration records are 100% synthetic, clearly labeled across the entire system."*
   * Point out the **Red Outbreak Banner**:
     > *"Notice that the system has detected an active syndromic cluster in Sangamner. We'll examine both the outbreak and the math behind it in just a moment."*

---

## 🏡 Step 2: Farm & Animal Registry Management (45 Seconds)

1. Tap **"Farms"** in the bottom navigation bar:
   * Show the 12 farms organized with village chips (Sangamner, Rahata, Shrirampur, Kopargaon, Akole).
   * Tap **"Add Farm"** to demonstrate validation: entering Farm Name, selecting Village, Owner, and GPS coordinates.
2. Tap into **"Patil Dairy Farm"**:
   * Point out the **Farm Profile Header**: Owner name (*Suresh Patil*), total herd size, village, and a direct button **"View Owner Ledger"**.
   * Switch between the **"Animals (8)"** tab and **"Recent Visits"** tab:
     > *"A farm is not an isolated unit. It connects owners, animals, and clinical visits under a unified entity hierarchy."*
3. Tap **"Animals"** in the bottom navigation bar:
   * Use the search bar to filter by `Lakshmi` or `COW-SNG-101`.
   * Tap the **"+ Register Animal"** FAB to show the animal registration dialog: tag RFID format validation, farm pre-fill, species/breed dropdowns, and duplicate prevention.

---

## 🩺 Step 3: 5-Stage Visit Entry & 7 Clinical Intelligence Modules (90 Seconds)

1. Open **Lakshmi (COW-SNG-101)**:
   * Point out her longitudinal clinical timeline: past normal checks, prior off-feed episodes, and deworming.
2. Tap **"Record Clinical Visit"** to launch the **5-Stage Clinical Workflow**:
   * **Stage 1 (Select Patient)**: Pre-selected as Lakshmi.
   * **Stage 2 (Past Records Accordion)**: Expand to review past visits, vitals, and prior treatments right inside the consultation flow.
   * **Stage 3 (Current Draft & Fee Breakdown)**:
     * Complaint: *"Acute high fever, persistent coughing, and bilateral nasal discharge"*.
     * Rectal Temp: `40.5 °C`, Severity: **SEVERE**.
     * Symptoms: Multi-select **Fever**, **Cough**, **Nasal Discharge**, **Reduced Appetite**.
     * Physical Exam: *"Bilateral mucoid discharge, crackles in cranioventral lung lobes"*.
     * Fee Breakdown in INR (₹): Consultation `₹250`, Service `₹150`, Medicine `₹400`, Other `₹50` -> **Auto Total: ₹850**.
   * **Stage 4 (Draft Intelligence Preview)**:
     * Tap **"Analyze Current Visit + Medical History"**.
     * Show that the backend analyzes the unsaved draft in conjunction with past history *before* saving.
3. Walk through the **7 Structured Clinical Intelligence Modules**:
   * **Module 1 (Symptom Chronology & Evolution)**: Flags acute 2-day onset and notes recurrence of reduced appetite.
   * **Module 2 (Current Clinical Presentation)**: Synthesizes high fever (40.5°C) and severe respiratory profile.
   * **Module 3 (Longitudinal Comparison)**: Compares against past baseline visits, noting acute divergence from prior routine health.
   * **Module 4 (Differential Conditions to Consider)**: Bovine Respiratory Disease Complex (BRDC), Infectious Bovine Rhinotracheitis (IBR), Pasteurellosis.
   * **Module 5 (Immediate Risk Indicators)**: High fever hyperthermia alert, dehydration risk, and farm herd transmission risk.
   * **Module 6 (Recommended Next Steps)**: Deep nasopharyngeal swabs, isolation of affected cow, NSAID antipyretic cover.
   * **Module 7 (Pre-Drafted Clinical Template)**: SOAP template ready for the veterinarian.
   * Highlight the **Veterinary Ethics Disclaimer**:
     > *"VetLedger AI provides decision support, not autonomous prescribing. Final clinical assessment remains strictly with the qualified veterinary practitioner."*
4. Complete **Stage 5 (Save Encounter)**:
   * Tap Save. Encounter immediately persists to PostgreSQL, updating Lakshmi's timeline and generating owner charges!

---

## 🚨 Step 4: Population Surveillance & Resolving the 17 vs 22 Sangamner Cluster (60 Seconds)

1. Tap **"Surveillance"** in the bottom navigation bar:
   * Toggle between the observation windows: **7 Days**, **14 Days**, and **30 Days**.
   * Show that the surveillance engine calculates rolling statistical baselines in pure Java.
2. Address the **Sangamner Syndromic Outbreak**:
   * Point out the dedicated **Epidemiological Explanatory Banner**:
     > *"Judges, look closely at this distinction: over the past 14 days in Sangamner, there are **22 total active animals** with veterinary visits. But exactly **17 animals across 6 farms** exhibit the specific clustered syndromic signature: Fever + Nasal Discharge. The other 5 animals had unrelated individual issues like mechanical lameness and routine calving checks."*
   * Show the **Cluster Metric Card**:
     * **17 Clustered Animals**
     * **6 Affected Farms**
     * **9.4x Baseline Elevation** (17 vs 1.8 expected)
3. Tap **"Investigate Sangamner Evidence"**:
   * Show the affected farms (Patil Dairy, Shinde Livestock, Deshmukh Yard).
   * Tap any affected cow to drill directly into her longitudinal record.
   * Review the recommended outbreak containment protocol.

---

## 💰 Step 5: Owner Financial Ledger & INR Payment Receipts (45 Seconds)

1. Tap **"Ledger"** in the bottom navigation bar:
   * Show the directory of 12 owners with total charges, payments, and outstanding balances in Indian Rupees (₹).
   * Search for **"Suresh Patil"** (Owner of Patil Dairy Farm).
2. Tap on Suresh Patil to open the **Owner Statement**:
   * Explain the financial architecture:
     > *"Notice that billing is strictly at the owner level (`Owner -> Farms -> Animals -> Visits`). We do NOT store fractured per-animal balances. A farmer owns multiple cows across farms, and pays as a single business entity."*
   * View the itemized charges: Lakshmi's visits, Gauri's visits, Krishna's visits with fee breakdowns (Consultation, Medicine, Procedures).
3. Tap **"Record Payment"**:
   * Enter Amount: `₹2,000` via UPI / Bank Transfer.
   * Save Payment: The backend automatically allocates the payment to unpaid visits using FIFO (First-In-First-Out) ordering!
4. Tap **"View Receipt"**:
   * Open the formal, printable **Payment Receipt**:
     * Organization Header: VetLedger AI Veterinary Clinical Network.
     * Receipt Number & Timestamp.
     * Payer Name & Farm affiliation.
     * Amount Paid: `₹2,000.00`.
     * Itemized table of allocated visit invoices.
     * Remaining Outstanding Balance.

---

## 🎯 Step 6: Conclusion & System Verification (30 Seconds)

1. Highlight the engineering quality:
   * 15/15 automated tests passing (`mvn test` and `flutter test`).
   * Clean separation between Spring Boot 3.3 backend and Flutter Material 3 client.
   * Zero mock data: all aggregations and receipts calculate deterministically from database rows.
2. Conclude:
   > *"VetLedger AI provides complete clinical continuity for the individual animal, proactive biosecurity early warning for the community, and transparent financial operations for the farmer. Thank you!"*
