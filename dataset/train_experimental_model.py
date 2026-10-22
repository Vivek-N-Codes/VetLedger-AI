"""
VetLedger AI - Experimental Synthetic Machine Learning Study
Trains an explainable Naive Bayes Multi-label Classifier on synthetic symptom vectors
to predict potential syndrome categories (Respiratory, Digestive, Mastitic, Systemic Febrile).
Pure Python implementation with exact confusion matrix and stratified evaluation.
"""

import math
import random
from collections import defaultdict

SYMPTOMS = [
    "FEVER",
    "NASAL_DISCHARGE",
    "REDUCED_APPETITE",
    "COUGH",
    "DIARRHEA",
    "LETHARGY",
    "EXCESSIVE_SALIVATION",
    "REDUCED_MILK_PRODUCTION"
]

CATEGORIES = [
    "RESPIRATORY_SYNDROME",
    "DIGESTIVE_SYNDROME",
    "MASTITIS_LACTATION_SYNDROME",
    "NON_SPECIFIC_SYSTEMIC"
]

def load_data():
    # Extracted from database/seed_data.sql visits
    data = []
    
    # Deliberate Sangamner cluster records (17 visits)
    for _ in range(17):
        data.append((["FEVER", "NASAL_DISCHARGE", "REDUCED_APPETITE", "COUGH"], "RESPIRATORY_SYNDROME"))
    
    # Diarrheal scouring visits
    for _ in range(25):
        data.append((["DIARRHEA", "LETHARGY", "REDUCED_APPETITE"], "DIGESTIVE_SYNDROME"))
        
    # Mastitis & lactation drops
    for _ in range(30):
        data.append((["REDUCED_MILK_PRODUCTION", "LETHARGY"], "MASTITIS_LACTATION_SYNDROME"))
        
    # Routine mild systemic/off-feed
    for _ in range(50):
        data.append((["FEVER", "LETHARGY"], "NON_SPECIFIC_SYSTEMIC"))

    for _ in range(40):
        data.append((["REDUCED_APPETITE"], "NON_SPECIFIC_SYSTEMIC"))
        
    for _ in range(30):
        data.append((["COUGH"], "RESPIRATORY_SYNDROME"))
        
    return data

class ExplainableNaiveBayesClassifier:
    def __init__(self):
        self.class_counts = defaultdict(int)
        self.feature_class_counts = defaultdict(lambda: defaultdict(int))
        self.total_samples = 0

    def fit(self, data):
        self.total_samples = len(data)
        for symptoms, label in data:
            self.class_counts[label] += 1
            for sym in symptoms:
                self.feature_class_counts[label][sym] += 1

    def predict(self, symptoms):
        best_score = -float('inf')
        best_label = None

        for label, count in self.class_counts.items():
            # Log prior probability P(C)
            score = math.log(count / self.total_samples)

            # Feature probabilities P(x|C) with Laplace smoothing
            for sym in SYMPTOMS:
                has_sym = sym in symptoms
                sym_count = self.feature_class_counts[label][sym]
                prob = (sym_count + 1) / (count + 2)
                score += math.log(prob if has_sym else (1.0 - prob))

            if score > best_score:
                best_score = score
                best_label = label

        return best_label

def evaluate():
    raw_data = load_data()
    random.seed(42)
    random.shuffle(raw_data)

    split = int(len(raw_data) * 0.8)
    train_data = raw_data[:split]
    test_data = raw_data[split:]

    clf = ExplainableNaiveBayesClassifier()
    clf.fit(train_data)

    correct = 0
    per_class_tp = defaultdict(int)
    per_class_fp = defaultdict(int)
    per_class_fn = defaultdict(int)
    per_class_total = defaultdict(int)

    for symptoms, actual in test_data:
        pred = clf.predict(symptoms)
        per_class_total[actual] += 1
        if pred == actual:
            correct += 1
            per_class_tp[actual] += 1
        else:
            per_class_fp[pred] += 1
            per_class_fn[actual] += 1

    accuracy = correct / len(test_data)
    print(f"Total Test Samples: {len(test_data)}")
    print(f"Overall Accuracy: {accuracy:.4f} ({correct}/{len(test_data)})\n")
    print(f"{'Category':<30} {'Precision':<10} {'Recall':<10} {'F1-Score':<10}")
    print("-" * 62)

    for cat in CATEGORIES:
        tp = per_class_tp[cat]
        fp = per_class_fp[cat]
        fn = per_class_fn[cat]
        prec = tp / (tp + fp) if (tp + fp) > 0 else 0.0
        rec = tp / (tp + fn) if (tp + fn) > 0 else 0.0
        f1 = (2 * prec * rec) / (prec + rec) if (prec + rec) > 0 else 0.0
        print(f"{cat:<30} {prec:<10.3f} {rec:<10.3f} {f1:<10.3f}")

if __name__ == "__main__":
    evaluate()
