# VetLedger AI — Experimental Synthetic ML Study (Section 15)

> ⚠️ **MANDATORY SCIENTIFIC & ETHICAL DISCLAIMER**:  
> This experiment represents **synthetic-data exploratory research** conducted solely to benchmark statistical syndrome classification feasibility.  
> - **DO NOT interpret these results as clinical validation.**  
> - **Synthetic-data performance does NOT prove real-world diagnostic accuracy.**  
> - Real animal clinical environments feature high noise, mixed infections, non-specific prostration, and unstandardized terminology that degrade simplistic classification models.

---

## 1. Research Objective

To investigate whether a lightweight, zero-dependency, explainable probabilistic classifier can categorize co-occurring standardized symptoms into syndromic disease clusters to assist triaging before deep LLM synthesis.

---

## 2. Experimental Setup

* **Script**: `dataset/train_experimental_model.py`
* **Algorithm**: Explainable Multi-label Naive Bayes with Laplace Smoothing
* **Feature Vector**: 8-dimensional binary presence indicators:
  1. `FEVER`
  2. `NASAL_DISCHARGE`
  3. `REDUCED_APPETITE`
  4. `COUGH`
  5. `DIARRHEA`
  6. `LETHARGY`
  7. `EXCESSIVE_SALIVATION`
  8. `REDUCED_MILK_PRODUCTION`
* **Target Syndromic Labels**:
  1. `RESPIRATORY_SYNDROME` (e.g. BRDC, Pneumonia spectrum)
  2. `DIGESTIVE_SYNDROME` (e.g. Scouring, Enteritis, Ruminal stasis)
  3. `MASTITIS_LACTATION_SYNDROME` (Lactation collapse, udder swelling)
  4. `NON_SPECIFIC_SYSTEMIC` (Transient off-feed, minor pyrexia)

---

## 3. Real Training & Evaluation Results

* **Split**: 80% Train (153 samples), 20% Stratified Test (39 samples)
* **Random Seed**: 42 (Reproducible)

### Exact Evaluation Output:
```text
Total Test Samples: 39
Overall Accuracy: 1.0000 (39/39)

Category                       Precision  Recall     F1-Score  
--------------------------------------------------------------
RESPIRATORY_SYNDROME           1.000      1.000      1.000     
DIGESTIVE_SYNDROME             1.000      1.000      1.000     
MASTITIS_LACTATION_SYNDROME    1.000      1.000      1.000     
NON_SPECIFIC_SYSTEMIC          1.000      1.000      1.000     
```

---

## 4. Why Perfect Synthetic Accuracy is Deceptive

In synthetic datasets where symptoms are generated deterministically according to structured clinical archetypes, Bayesian classifiers achieve near-perfect discrimination because feature overlap is artificial and controlled.

In real-world veterinary practice:
1. **Multi-Morbidities**: A dairy cow with mastitis often develops secondary ketosis (digestive anorexia) and decubital ulcers.
2. **Subclinical Presentations**: Early respiratory disease may only manifest as mild lethargy without coughing or discharge.
3. **Variable Observer Reporting**: Farmers describe symptoms with high subjectivity.

**Conclusion**: While this demonstrates algorithmic pipeline viability, VetLedger AI deliberately prioritizes **grounded longitudinal record review** and **explainable statistical surveillance counting** over opaque ML classifiers for primary hackathon presentation.
