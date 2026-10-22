"""
Deterministic Synthetic Dataset Generator for VetLedger AI
Produces:
- 5 Villages
- 12 Farms
- 80 Animals
- 205 Visits with Normalized Symptoms
- Deliberate Seeded Cluster in Sangamner (17 distinct animals, 6 farms, 14-day window)
"""

import datetime

def generate_seed_sql():
    sql = []
    sql.append("-- ============================================================================")
    sql.append("-- VETLEDGER AI - DETERMINISTIC SYNTHETIC DATASET")
    sql.append("-- Generates 5 villages, 12 farms, 80 animals, 205 visits, 420+ symptoms")
    sql.append("-- Includes deliberate surveillance cluster: Sangamner (17 animals, 6 farms, 14-day window)")
    sql.append("-- ============================================================================\n")

    # 1. Villages
    villages = [
        (1, "Sangamner", "Ahmednagar", "Maharashtra", 19.5772, 74.2185),
        (2, "Rahata", "Ahmednagar", "Maharashtra", 19.6976, 74.4921),
        (3, "Akole", "Ahmednagar", "Maharashtra", 19.5441, 73.9961),
        (4, "Kopargaon", "Ahmednagar", "Maharashtra", 19.8887, 74.4789),
        (5, "Shrirampur", "Ahmednagar", "Maharashtra", 19.6198, 74.6599)
    ]
    sql.append("-- 1. VILLAGES")
    for v in villages:
        sql.append(f"INSERT INTO villages (id, name, district, state, latitude, longitude) VALUES ({v[0]}, '{v[1]}', '{v[2]}', '{v[3]}', {v[4]}, {v[5]}) ON CONFLICT (id) DO NOTHING;")
    sql.append("SELECT setval('villages_id_seq', (SELECT MAX(id) FROM villages));\n")

    # 2. Farms (12 farms)
    farms = [
        # Sangamner (6 farms: id 1 to 6)
        (1, "FARM-SNG-01", "Patil Dairy Farm", "Ramesh Patil", "9822011234", 1, 19.5780, 74.2190),
        (2, "FARM-SNG-02", "Shinde Livestock", "Balasaheb Shinde", "9822011235", 1, 19.5765, 74.2170),
        (3, "FARM-SNG-03", "Deshmukh Cattle Yard", "Sunil Deshmukh", "9822011236", 1, 19.5795, 74.2210),
        (4, "FARM-SNG-04", "Tambe Agro Farm", "Dattatray Tambe", "9822011237", 1, 19.5750, 74.2155),
        (5, "FARM-SNG-05", "Thorat Dairy Complex", "Kishore Thorat", "9822011238", 1, 19.5810, 74.2230),
        (6, "FARM-SNG-06", "Vikhe Cattle Station", "Ashok Vikhe", "9822011239", 1, 19.5740, 74.2140),
        # Rahata (2 farms: id 7 to 8)
        (7, "FARM-RHT-01", "Sai Krupa Dairy", "Ganesh Kadam", "9822022341", 2, 19.6980, 74.4930),
        (8, "FARM-RHT-02", "Godavari Valley Farm", "Nitin Ghadge", "9822022342", 2, 19.6965, 74.4910),
        # Akole (2 farms: id 9 to 10)
        (9, "FARM-AKL-01", "Sahyadri Cattle Shelter", "Eknath Navale", "9822033451", 3, 19.5450, 73.9970),
        (10, "FARM-AKL-02", "Pravara River Farm", "Pandurang Pichad", "9822033452", 3, 19.5430, 73.9950),
        # Kopargaon (1 farm: id 11)
        (11, "FARM-KPG-01", "Panchvati Dairy", "Sanjay Kolhe", "9822044561", 4, 19.8890, 74.4795),
        # Shrirampur (1 farm: id 12)
        (12, "FARM-SRP-01", "Belapur Green Livestock", "Vikas Sasane", "9822055671", 5, 19.6205, 74.6610)
    ]
    sql.append("-- 2. FARMS")
    for f in farms:
        sql.append(f"INSERT INTO farms (id, farm_code, farm_name, owner_name, contact_number, village_id, latitude, longitude) VALUES ({f[0]}, '{f[1]}', '{f[2]}', '{f[3]}', '{f[4]}', {f[5]}, {f[6]}, {f[7]}) ON CONFLICT (id) DO NOTHING;")
    sql.append("SELECT setval('farms_id_seq', (SELECT MAX(id) FROM farms));\n")

    # 3. Animals (80 animals)
    # Sangamner: 40 animals (farm 1: 7, farm 2: 7, farm 3: 7, farm 4: 7, farm 5: 6, farm 6: 6) -> animals 1 to 40
    # Other villages: 40 animals (farm 7: 6, farm 8: 6, farm 9: 6, farm 10: 6, farm 11: 8, farm 12: 8) -> animals 41 to 80
    breeds_cattle = ["Gir", "Holstein Friesian Cross", "Sahiwal", "Khillari", "Jersey Cross"]
    breeds_buffalo = ["Murrah", "Jaffrabadi", "Pandharpuri"]
    breeds_goat = ["Osmanabadi", "Sirohi", "Beetal"]
    
    names_female = ["Lakshmi", "Gauri", "Shyama", "Radha", "Kalyani", "Ganga", "Kamdhenu", "Champa", "Nandini", "Kavya", "Manik", "Sonali"]
    names_male = ["Nandi", "Raja", "Sheru", "Bahubali", "Sultan", "Chetak", "Veer", "Moti", "Arjun", "Bheema"]

    animals = []
    animal_id = 1
    
    # Sangamner animals (1 to 40)
    farm_allocations = [
        (1, 7), (2, 7), (3, 7), (4, 7), (5, 6), (6, 6), # Sangamner: 40
        (7, 6), (8, 6), (9, 6), (10, 6), (11, 8), (12, 8) # Others: 40
    ]

    for farm_id, count in farm_allocations:
        for idx in range(1, count + 1):
            if animal_id % 5 == 0:
                species = "Goat"
                breed = breeds_goat[animal_id % len(breeds_goat)]
                sex = "FEMALE" if (animal_id % 3 != 0) else "MALE"
            elif animal_id % 3 == 0:
                species = "Buffalo"
                breed = breeds_buffalo[animal_id % len(breeds_buffalo)]
                sex = "FEMALE"
            else:
                species = "Cattle"
                breed = breeds_cattle[animal_id % len(breeds_cattle)]
                sex = "FEMALE" if (animal_id % 4 != 0) else "MALE"
            
            code = f"{species[:3].upper()}-{farms[farm_id-1][1][5:8]}-{animal_id:03d}"
            name = (names_female if sex == "FEMALE" else names_male)[(animal_id + idx) % (len(names_female) if sex == "FEMALE" else len(names_male))]
            age = round(2.0 + (animal_id % 6) * 0.8, 1)
            rfid = f"RFID-982-000{animal_id:04d}"
            notes = f"Primary milking stock, vaccinated for FMD, regular health screening on record."
            animals.append((animal_id, code, name, species, breed, age, sex, farm_id, rfid, notes))
            animal_id += 1

    sql.append("-- 3. ANIMALS (80 synthetic records)")
    for a in animals:
        sql.append(f"INSERT INTO animals (id, animal_code, name, species, breed, age_years, sex, farm_id, tag_rfid, notes) VALUES ({a[0]}, '{a[1]}', '{a[2]}', '{a[3]}', '{a[4]}', {a[5]}, '{a[6]}', {a[7]}, '{a[8]}', '{a[9]}') ON CONFLICT (id) DO NOTHING;")
    sql.append("SELECT setval('animals_id_seq', (SELECT MAX(id) FROM animals));\n")

    # 4. Visits and Symptoms
    # Total ~205 visits
    # Reference demo date: 2026-10-22
    # 14-day window: 2026-10-09 to 2026-10-22
    
    visits = []
    visit_symptoms = []
    visit_id = 1
    symptom_id = 1

    # SEEDED CLUSTER: Sangamner
    # 17 distinct animals across 6 farms in Sangamner
    # Farm 1 (Patil): animals 1, 2, 3
    # Farm 2 (Shinde): animals 8, 9, 10
    # Farm 3 (Deshmukh): animals 15, 16, 17
    # Farm 4 (Tambe): animals 22, 23, 24
    # Farm 5 (Thorat): animals 29, 30, 31
    # Farm 6 (Vikhe): animals 35, 36
    cluster_animal_ids = [1, 2, 3, 8, 9, 10, 15, 16, 17, 22, 23, 24, 29, 30, 31, 35, 36]
    assert len(cluster_animal_ids) == 17
    
    cluster_dates = [
        "2026-10-11", "2026-10-12", "2026-10-13", "2026-10-14", "2026-10-15",
        "2026-10-15", "2026-10-16", "2026-10-17", "2026-10-18", "2026-10-18",
        "2026-10-19", "2026-10-19", "2026-10-20", "2026-10-20", "2026-10-21",
        "2026-10-21", "2026-10-22"
    ]

    sql.append("-- 4. VISITS & SYMPTOMS")
    sql.append("-- Deliberate Cluster: 17 visits in Sangamner across 6 farms within recent 14 days")

    for i, a_id in enumerate(cluster_animal_ids):
        v_date = cluster_dates[i]
        complaint = "High fever, persistent nasal discharge, severe appetite loss"
        obs = f"Rectal temperature elevated. Bilateral seromucous nasal discharge. Dull demeanor, ruminal stasis detected. Lung auscultation indicates bronchial rales."
        sev = "SEVERE" if i % 2 == 0 else "MODERATE"
        temp = round(40.1 + (i % 5) * 0.2, 1)
        treatment = "Administered antipyretic (Meloxicam 0.5mg/kg), broad-spectrum antibiotic supportive cover (Oxytetracycline LA), and oral electrolyte drench."
        follow_up = "Isolate affected animal in separate pen. Monitor rectal temperature twice daily. Review herd biosecurity."
        
        visits.append((visit_id, a_id, v_date, complaint, obs, sev, temp, treatment, follow_up))
        
        # Shared symptoms for cluster
        visit_symptoms.append((symptom_id, visit_id, "FEVER", "SEVERE" if sev == "SEVERE" else "MODERATE"))
        symptom_id += 1
        visit_symptoms.append((symptom_id, visit_id, "NASAL_DISCHARGE", "MODERATE"))
        symptom_id += 1
        visit_symptoms.append((symptom_id, visit_id, "REDUCED_APPETITE", "SEVERE"))
        symptom_id += 1
        if i % 3 == 0:
            visit_symptoms.append((symptom_id, visit_id, "COUGH", "MODERATE"))
            symptom_id += 1
        if i % 2 == 0:
            visit_symptoms.append((symptom_id, visit_id, "LETHARGY", "SEVERE"))
            symptom_id += 1
        visit_id += 1

    # Historical Visits for animals (Longitudinal histories over past 6-12 months)
    # Generating ~188 historical and background visits
    
    # 1. Historical baseline visits in Sangamner (past 6 months, sporadic: ~2 per month)
    # This demonstrates that earlier in Sangamner, fever/nasal discharge occurred only 1-2 times per 14-day period.
    historical_baseline_dates = [
        "2026-05-10", "2026-05-25", "2026-06-08", "2026-06-22",
        "2026-07-05", "2026-07-19", "2026-08-04", "2026-08-18",
        "2026-09-02", "2026-09-16", "2026-09-28", "2026-10-02"
    ]
    for idx, b_date in enumerate(historical_baseline_dates):
        a_id = (idx * 3 + 1) % 40 + 1
        complaint = "Routine mild fever or off-feed"
        obs = "Slightly elevated temperature, normal lung sounds, responsive."
        sev = "MILD"
        temp = 39.2
        treatment = "Symptomatic treatment, B-complex injection."
        follow_up = "Resolved after 48 hours."
        visits.append((visit_id, a_id, b_date, complaint, obs, sev, temp, treatment, follow_up))
        visit_symptoms.append((symptom_id, visit_id, "FEVER", "MILD"))
        symptom_id += 1
        if idx % 2 == 0:
            visit_symptoms.append((symptom_id, visit_id, "REDUCED_APPETITE", "MILD"))
            symptom_id += 1
        visit_id += 1

    # 2. General health visits across all animals (1 to 80)
    # Routine checks, mastitis checks, deworming, digestive upsets, minor injuries
    routine_complaints = [
        ("Routine deworming and health assessment", "Normal vitals, healthy body score", "MILD", 38.5, ["LETHARGY"], "Albendazole oral suspension administered", "Repeat in 6 months"),
        ("Decreased milk yield during morning milking", "Mild udder swelling, right quarter tender", "MODERATE", 38.9, ["REDUCED_MILK_PRODUCTION", "REDUCED_APPETITE"], "Intramammary infusion, anti-inflammatory", "Strip test daily, hygiene protocol review"),
        ("Acute watery diarrhea and dehydration", "Profuse scouring, sunken eyes, skin tenting", "SEVERE", 39.4, ["DIARRHEA", "LETHARGY", "REDUCED_APPETITE"], "IV Ringers Lactate 2L, oral electrolytes, Kaolin-pectin", "Withhold concentrate, feed clean dry hay"),
        ("Persistent dry cough after pasture grazing", "Mild bronchial wheeze, clear nasal passages", "MODERATE", 39.0, ["COUGH"], "Bromhexine mucolytic, antihistamine", "Keep in well-ventilated dry shed"),
        ("Excessive drooling and mouth discomfort", "Oral examination showed minor forage trauma, no vesicles", "MILD", 38.6, ["EXCESSIVE_SALIVATION", "REDUCED_APPETITE"], "Antiseptic mouth wash (Potassium permanganate 1:10000), soft diet", "Recheck oral mucosa in 3 days"),
        ("Mild bloating and digestive lethargy", "Left paralumbar fossa distended with gas, drum sound", "MODERATE", 38.7, ["REDUCED_APPETITE", "LETHARGY"], "Bloat-guard drench (Poloxalene), stomach tube gas relief", "Review legume grazing duration"),
        ("Post-calving checkup and metritis screening", "Mild vaginal discharge, subclinical hypocalcemia", "MODERATE", 38.8, ["LETHARGY", "REDUCED_MILK_PRODUCTION"], "Calcium borogluconate 450ml SC, intrauterine pessary", "Monitor milk output and appetite"),
        ("Lactation fatigue and sudden drop in milk", "BCS 2.5, dull coat, rumen motility slow", "MILD", 38.5, ["REDUCED_MILK_PRODUCTION", "LETHARGY"], "Mineral mixture supplement, bypass fat", "Follow up in 14 days")
    ]

    months = ["2026-04", "2026-05", "2026-06", "2026-07", "2026-08", "2026-09", "2026-10"]
    
    # Ensure every animal has at least 2 historical visits to demonstrate longitudinal profiles!
    for a_id in range(1, 81):
        # 2 historical visits per animal
        for visit_num in [1, 2]:
            month = months[(a_id * 3 + visit_num) % len(months)]
            day = 1 + ((a_id * 7 + visit_num * 11) % 27)
            v_date = f"{month}-{day:02d}"
            # Ensure historical visits aren't in future
            if v_date > "2026-10-22":
                v_date = "2026-10-05"
            # Avoid placing visits in the cluster window for cluster animals (already seeded)
            if a_id in cluster_animal_ids and v_date >= "2026-10-09":
                v_date = "2026-09-15"

            comp_idx = (a_id + visit_num) % len(routine_complaints)
            comp_data = routine_complaints[comp_idx]
            
            visits.append((visit_id, a_id, v_date, comp_data[0], comp_data[1], comp_data[2], comp_data[3], comp_data[5], comp_data[6]))
            for sym in comp_data[4]:
                visit_symptoms.append((symptom_id, visit_id, sym, comp_data[2]))
                symptom_id += 1
            visit_id += 1

    # Background visits in other villages in the recent 14-day window (to show non-cluster baseline)
    other_recent_visits = [
        # Rahata (Animal 42)
        (42, "2026-10-14", "Mild digestive slowdown", "Slightly low rumen fill", "MILD", 38.5, ["REDUCED_APPETITE"], "Digestive tonic, probiotic bolus", "Normal response expected"),
        # Akole (Animal 55)
        (55, "2026-10-16", "Minor hoof scrape during grazing", "Small abrasion on lateral claw, clean", "MILD", 38.6, ["LETHARGY"], "Povidone iodine dressing, zinc oxide paste", "Keep on dry bedding"),
        # Kopargaon (Animal 68)
        (68, "2026-10-18", "Acute calf diarrhea", "Watery feces, moderate dehydration", "MODERATE", 39.1, ["DIARRHEA", "REDUCED_APPETITE"], "Electrolyte drench, probiotic paste", "Review milk replacer feeding schedule"),
        # Shrirampur (Animal 75)
        (75, "2026-10-19", "Sudden milk drop", "Left hind quarter slightly warm, somatic cell count elevated", "MODERATE", 38.9, ["REDUCED_MILK_PRODUCTION"], "Intramammary infusion, NSAID", "Monitor CMT score daily")
    ]
    for ov in other_recent_visits:
        visits.append((visit_id, ov[0], ov[1], ov[2], ov[3], ov[4], ov[5], ov[7], ov[8]))
        for sym in ov[6]:
            visit_symptoms.append((symptom_id, visit_id, sym, ov[4]))
            symptom_id += 1
        visit_id += 1

    for v in visits:
        clean_obs = v[4].replace("'", "''")
        clean_comp = v[3].replace("'", "''")
        clean_treat = v[7].replace("'", "''")
        clean_fu = v[8].replace("'", "''")
        sql.append(f"INSERT INTO visits (id, animal_id, visit_date, presenting_complaint, observations, severity, temperature_celsius, treatment_notes, follow_up_notes) VALUES ({v[0]}, {v[1]}, '{v[2]}', '{clean_comp}', '{clean_obs}', '{v[5]}', {v[6]}, '{clean_treat}', '{clean_fu}') ON CONFLICT (id) DO NOTHING;")
    sql.append("SELECT setval('visits_id_seq', (SELECT MAX(id) FROM visits));\n")

    sql.append("-- 5. VISIT SYMPTOMS")
    for vs in visit_symptoms:
        sql.append(f"INSERT INTO visit_symptoms (id, visit_id, symptom_code, severity) VALUES ({vs[0]}, {vs[1]}, '{vs[2]}', '{vs[3]}') ON CONFLICT (id) DO NOTHING;")
    sql.append("SELECT setval('visit_symptoms_id_seq', (SELECT MAX(id) FROM visit_symptoms));\n")

    return "\n".join(sql)

if __name__ == "__main__":
    sql_content = generate_seed_sql()
    with open("database/seed_data.sql", "w", encoding="utf-8") as f:
        f.write(sql_content)
    print(f"Generated database/seed_data.sql successfully ({len(sql_content.splitlines())} lines).")
