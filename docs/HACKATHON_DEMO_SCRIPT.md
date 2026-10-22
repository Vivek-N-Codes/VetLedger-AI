# VetLedger AI — Hackathon Live Demonstration Script (5-Minute Walkthrough)

> **Audience**: Hackathon Judges, Veterinary Health Officers, Technical Evaluators  
> **Presenter**: Engineering Student / Full-Stack Developer  
> **Time**: ~5 Minutes  

---

## 🎤 Hook & Introduction (30 Seconds)

> *"Good afternoon, judges. In rural livestock farming, veterinary care is historically fragmented. Animals are treated for isolated complaints, and paper logs mean recurring symptoms get missed. More critically, when an infectious pathogen begins spreading across neighboring farms, weeks pass before regional health officers notice the cluster.*
>
> *Today, we present **VetLedger AI** — transforming fragmented livestock records into longitudinal clinical intelligence and early syndromic disease surveillance.*
>
> *Every single data point you will see today is backed by our live Spring Boot REST API and PostgreSQL database."*

---

## 📱 Step 1: Real-Time Dashboard & Synthetic Transparency (30 Seconds)

1. **Show the Dashboard screen**:
   * Point out the real database counters: **80 Total Animals**, **12 Farms**, **5 Villages Covered**, and **193+ Clinical Encounters**.
   * Highlight the **"SYNTHETIC DEMO"** badge:
     > *"As responsible engineers, we believe in radical transparency: all records are 100% synthetic demonstration data, clearly flagged across the system."*
   * Point out the **Red Alert Banner**:
     > *"Notice that the system is already flagging an active surveillance signal in Sangamner. We will investigate that in a moment."*

---

## 🔍 Step 2 & 3: Longitudinal Animal Record (45 Seconds)

1. Tap **"Animals"** in the bottom navigation bar.
2. In the search bar, type `Lakshmi` or `101`.
   * Show that search filters dynamically across codes, names, breeds, and farm names.
   * Toggle the **"Sangamner"** and **"Cattle"** filter chips to show instant multi-dimensional filtering.
3. Tap on **Lakshmi (COW-SNG-101)** to open her **Longitudinal Profile**:
   > *"Unlike traditional transactional apps that only store the latest visit, VetLedger AI tracks the complete lifetime health timeline of each animal across its farm, RFID ear-tag, breed, and age."*

---

## 🩺 Step 4 & 5: Record a New Clinical Encounter (60 Seconds)

1. Scroll through Lakshmi's historical encounters:
   * Point out prior visits: notice past episodes of mild off-feed and deworming.
2. Tap **"Record Visit"**:
   * Show the intuitive Material 3 clinical form.
   * Date: Auto-set to today.
   * Complaint: Enter *"Acute high fever, persistent coughing, and anorexia"*.
   * Rectal Temperature: Enter `40.5`.
   * Severity: Tap **"SEVERE"** (pill turns red).
   * Standardized Symptoms: Multi-select **"Fever"**, **"Cough"**, **"Reduced Appetite"**, and **"Nasal Discharge"**.
   * Physical Exam: Enter *"Auscultation shows bronchial rales in right lung lobe"*.
   * Treatment: Enter *"Administered Flunixin meglumine and oxytetracycline supportive cover"*.
3. Tap **"Save Clinical Encounter"**:
   * The confirmation dialog appears: *"Clinical visit recorded successfully and persisted to PostgreSQL"*.
4. Return to the timeline:
   * Show that the new encounter immediately appears at the top of Lakshmi's timeline with its symptoms, temperature pill, and severity badge.

---

## 🤖 Step 6: AI Clinical Intelligence with Honest Fallback (60 Seconds)

1. On Lakshmi's profile, tap **"AI Intelligence"**:
   * The app sends her entire longitudinal encounter history to the backend.
2. Highlight the **AI Engine Source Badge**:
   > *"Notice the badge: `DETERMINISTIC FALLBACK ENGINE` (or `LIVE LLM INTELLIGENCE` if an API key is configured). In rural clinics where external LLMs suffer rate limits or connectivity loss, VetLedger AI never crashes or fakes a response. Our deterministic clinical engine synthesizes the stored database records directly."*
3. Walk through the structured intelligence output:
   * **Clinical Longitudinal Summary**: Grounded in Lakshmi's exact visit dates.
   * **Recurring Symptoms**: Detects that *Reduced Appetite* has recurred in multiple encounters.
   * **Symptom Trajectory**: Flags the acute transition from mild history to severe febrile respiratory distress.
   * **Potential Risk Indicators**: Flags hyperthermia (40.5°C) and dehydration risks.
   * **Differential Conditions to Consider**: Bovine Respiratory Disease Complex (BRDC) differential suggestions.
   * **Mandatory Veterinary Disclaimer**:
     > *"We explicitly adhere to veterinary ethics: this is a decision-support tool, not an autonomous prescribing agent. Final diagnosis rests strictly with the licensed veterinarian."*

---

## 🚨 Step 7 & 8: Data-Driven Surveillance & Sangamner Cluster (60 Seconds)

1. Tap **"Surveillance"** in the bottom navigation bar:
   > *"Now let's examine the village-level surveillance engine. This is not a hardcoded alert — our Java service queries the database, applies a rolling 14-day sliding window, groups visits by village, and compares against historical baselines."*
2. Show the **Sangamner Cluster Card**:
   * **17 Distinct Affected Animals**
   * **6 Distinct Farms**
   * **Dominant Symptoms**: Fever, Nasal Discharge, Reduced Appetite
   * **Baseline Elevation**: **9.4x above historical baseline**
3. Tap **"Investigate Sangamner Evidence"**:
   * Show the statistical comparison card: Current (17 animals) vs Historical Baseline (1.8 animals).
   * Show the **Affected Farms list**: See Patil Dairy, Shinde Livestock, Deshmukh Yard with animal counts.
   * Show the **Distinct Affected Animals list**: 17 distinct animals.
   * Tap on any affected animal (e.g. `COW-SNG-108`) to drill straight back into that cow's longitudinal history!
   * Review the **Recommended Field Veterinary Protocol**: On-site mucosal swabs, voluntary movement quarantine, and biosecurity audits.

---

## 🎯 Step 9 & 10: Algorithmic Rigor & Persistence Proof (30 Seconds)

1. Explain the algorithmic nuance:
   > *"Our algorithm counts distinct animals using unique ID sets. If one cow had 3 emergency visits this week, it is counted as 1 affected animal, avoiding false alarms from a single sick cow. Furthermore, it requires multiple affected farms, ensuring a localized barn problem isn't falsely labeled as a community cluster."*
2. Navigate back to the Dashboard:
   * Show that all counters and newly recorded visits are persisted in PostgreSQL.
3. Conclude with confidence:
   > *"VetLedger AI delivers end-to-end clinical continuity for the individual animal, and proactive early warning for the entire community. Thank you, and we welcome your questions!"*
