-- ============================================================================
-- VETLEDGER AI — V2 ENHANCEMENT MIGRATION (Idempotent)
-- Adds Owners, Financial Ledger, Charges, Payments, Follow-ups
-- ============================================================================

-- 1. Create OWNERS table
CREATE TABLE IF NOT EXISTS owners (
    id BIGSERIAL PRIMARY KEY,
    owner_code VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    contact_number VARCHAR(30),
    email VARCHAR(100),
    address TEXT,
    village_id BIGINT REFERENCES villages(id) ON DELETE SET NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_owners_code ON owners(owner_code);
CREATE INDEX IF NOT EXISTS idx_owners_village ON owners(village_id);

-- 2. Alter FARMS table to add owner_id, address, notes
ALTER TABLE farms ADD COLUMN IF NOT EXISTS owner_id BIGINT REFERENCES owners(id) ON DELETE SET NULL;
ALTER TABLE farms ADD COLUMN IF NOT EXISTS address TEXT;
ALTER TABLE farms ADD COLUMN IF NOT EXISTS notes TEXT;

-- 3. Populate OWNERS from existing FARMS if owners table is empty
INSERT INTO owners (owner_code, full_name, contact_number, village_id, address, notes)
SELECT 
    'OWN-' || LPAD(ROW_NUMBER() OVER (ORDER BY id)::TEXT, 3, '0') AS owner_code,
    owner_name AS full_name,
    contact_number,
    village_id,
    farm_name || ', ' || (SELECT name FROM villages WHERE id = farms.village_id) AS address,
    'Registered farm owner for ' || farm_name AS notes
FROM farms
ON CONFLICT (owner_code) DO NOTHING;

-- Link farms to owners based on owner_name and contact_number
UPDATE farms f
SET owner_id = o.id
FROM owners o
WHERE f.owner_name = o.full_name AND (f.owner_id IS NULL);

-- 4. Alter VISITS table to add financial charges and modular clinical fields
ALTER TABLE visits ADD COLUMN IF NOT EXISTS consultation_fee NUMERIC(10, 2) DEFAULT 0.00;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS service_fee NUMERIC(10, 2) DEFAULT 0.00;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS medicine_fee NUMERIC(10, 2) DEFAULT 0.00;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS other_fee NUMERIC(10, 2) DEFAULT 0.00;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS total_charge NUMERIC(10, 2) DEFAULT 0.00;

ALTER TABLE visits ADD COLUMN IF NOT EXISTS symptom_onset_duration VARCHAR(100);
ALTER TABLE visits ADD COLUMN IF NOT EXISTS physical_exam_findings TEXT;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS treatments_administered_prior TEXT;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS prior_treatment_response TEXT;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS final_clinical_assessment TEXT;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS actual_treatment_administered TEXT;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS owner_advice TEXT;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS follow_up_due_date DATE;
ALTER TABLE visits ADD COLUMN IF NOT EXISTS follow_up_status VARCHAR(30) DEFAULT 'NONE';

-- Update existing visits with realistic synthetic charges if total_charge is 0
UPDATE visits
SET 
    consultation_fee = 200.00,
    medicine_fee = CASE 
        WHEN severity = 'SEVERE' THEN 550.00
        WHEN severity = 'MODERATE' THEN 350.00
        ELSE 150.00
    END,
    service_fee = CASE 
        WHEN severity = 'SEVERE' THEN 250.00
        WHEN severity = 'MODERATE' THEN 100.00
        ELSE 50.00
    END,
    other_fee = 0.00,
    total_charge = 200.00 + (CASE 
        WHEN severity = 'SEVERE' THEN 800.00
        WHEN severity = 'MODERATE' THEN 450.00
        ELSE 200.00
    END)
WHERE total_charge = 0.00 OR total_charge IS NULL;

-- 5. Create PAYMENTS table
CREATE TABLE IF NOT EXISTS payments (
    id BIGSERIAL PRIMARY KEY,
    payment_number VARCHAR(60) NOT NULL UNIQUE,
    owner_id BIGINT NOT NULL REFERENCES owners(id) ON DELETE RESTRICT,
    amount NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
    payment_date DATE NOT NULL,
    payment_method VARCHAR(50) NOT NULL DEFAULT 'CASH', -- CASH, UPI, BANK_TRANSFER, CHEQUE
    reference_number VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_payments_owner_id ON payments(owner_id);
CREATE INDEX IF NOT EXISTS idx_payments_date ON payments(payment_date);

-- 6. Create PAYMENT_ALLOCATIONS table (tracks allocation of payments against specific visit charges)
CREATE TABLE IF NOT EXISTS payment_allocations (
    id BIGSERIAL PRIMARY KEY,
    payment_id BIGINT NOT NULL REFERENCES payments(id) ON DELETE CASCADE,
    visit_id BIGINT NOT NULL REFERENCES visits(id) ON DELETE RESTRICT,
    allocated_amount NUMERIC(10, 2) NOT NULL CHECK (allocated_amount > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_allocations_payment ON payment_allocations(payment_id);
CREATE INDEX IF NOT EXISTS idx_allocations_visit ON payment_allocations(visit_id);

-- 7. Create CLINICAL_FOLLOW_UPS table
CREATE TABLE IF NOT EXISTS clinical_follow_ups (
    id BIGSERIAL PRIMARY KEY,
    animal_id BIGINT NOT NULL REFERENCES animals(id) ON DELETE CASCADE,
    visit_id BIGINT REFERENCES visits(id) ON DELETE SET NULL,
    reason TEXT NOT NULL,
    due_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING', -- PENDING, COMPLETED, CANCELLED
    completion_notes TEXT,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_follow_ups_animal ON clinical_follow_ups(animal_id);
CREATE INDEX IF NOT EXISTS idx_follow_ups_due_date ON clinical_follow_ups(due_date);
CREATE INDEX IF NOT EXISTS idx_follow_ups_status ON clinical_follow_ups(status);

-- Seed realistic payments for owners so ledgers show real paid vs outstanding balances
DO $$
DECLARE
    rec RECORD;
    v_total NUMERIC;
    v_pay NUMERIC;
    v_pay_id BIGINT;
    p_num INT := 1;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM payments LIMIT 1) THEN
        FOR rec IN SELECT o.id, o.owner_code, o.full_name FROM owners o LOOP
            SELECT COALESCE(SUM(v.total_charge), 0) INTO v_total
            FROM visits v
            JOIN animals a ON v.animal_id = a.id
            JOIN farms f ON a.farm_id = f.id
            WHERE f.owner_id = rec.id;

            IF v_total > 0 THEN
                v_pay := ROUND(v_total * 0.70, 2);
                
                INSERT INTO payments (payment_number, owner_id, amount, payment_date, payment_method, reference_number, notes)
                VALUES (
                    'REC-2026-' || LPAD(p_num::TEXT, 4, '0'),
                    rec.id,
                    v_pay,
                    '2026-10-18',
                    CASE WHEN p_num % 2 = 0 THEN 'UPI' ELSE 'CASH' END,
                    'REF-ONB-' || LPAD(p_num::TEXT, 4, '0'),
                    'Initial ledger account payment'
                ) RETURNING id INTO v_pay_id;

                p_num := p_num + 1;
            END IF;
        END LOOP;
    END IF;
END $$;
