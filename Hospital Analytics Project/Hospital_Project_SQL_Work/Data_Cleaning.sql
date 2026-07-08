-- DATA CLEANING
-- Trim whitespace from text columns (common import problem)
UPDATE patients SET
    gender             = TRIM(gender),
    medical_condition  = TRIM(medical_condition),
    admission_type     = TRIM(admission_type),
    insurance_provider = TRIM(insurance_provider),
    test_result        = TRIM(test_result);

-- Standardise capitalisation (make consistent)
UPDATE patients SET
    gender        = CONCAT(UPPER(LEFT(gender, 1)), LOWER(SUBSTRING(gender, 2))),
    admission_type = CONCAT(UPPER(LEFT(admission_type, 1)), LOWER(SUBSTRING(admission_type, 2)));

-- Check for illogical dates (discharge before admission)
SELECT COUNT(*) AS bad_dates
FROM patients
WHERE discharge_date < admission_date;

-- Check billing outliers (bills below $0 or above $1 million)
SELECT COUNT(*) AS outliers
FROM patients
WHERE billing_amount <= 0;

-- Checking which rows have bill outliers (bills below $0 or above $1 million)
-- THERE ARE NO ROWS WHICH ARE GREATER THAN A MILLION
SELECT *
FROM patients
WHERE billing_amount <= 0;

-- Length of stay in days (derived from two date columns)
ALTER TABLE patients
ADD COLUMN length_of_stay INT
GENERATED ALWAYS AS (DATEDIFF(discharge_date, admission_date)) STORED;

-- Age group bucket (useful for demographic analysis)
ALTER TABLE patients
ADD COLUMN age_group VARCHAR(20)
GENERATED ALWAYS AS (
    CASE
        WHEN age < 18  THEN 'Under 18'
        WHEN age < 35  THEN '18–34'
        WHEN age < 50  THEN '35–49'
        WHEN age < 65  THEN '50–64'
        ELSE                '65+'
    END
) STORED;

SELECT name, age, age_group, admission_date, discharge_date, length_of_stay
FROM patients
LIMIT 10;

-- Capitalizing first letters in name and making all others small
UPDATE patients 
SET name = CONCAT( 
UPPER(LEFT(SUBSTRING_INDEX(name, ' ', 1), 1)), 
LOWER(SUBSTRING(SUBSTRING_INDEX(name, ' ', 1), 2)), ' ', 
UPPER(LEFT(SUBSTRING_INDEX(name, ' ', -1), 1)), 
LOWER(SUBSTRING(SUBSTRING_INDEX(name, ' ', -1), 2)) )
;

SELECT COUNT(*) AS total_rows FROM patients;

-- CREATING VIEWS FIRST

CREATE VIEW vw_clean_patients AS
SELECT
    patient_id,
    name,
    age,
    gender,
    blood_type,
    medical_condition,
    admission_date,
    discharge_date,
    doctor,
    hospital,
    insurance_provider,
    billing_amount,
    room_number,
    admission_type,
    medication,
    test_result,
    length_of_stay,
    age_group
FROM patients
WHERE billing_amount > 0;

SELECT *
FROM vw_clean_patients
where billing_amount < 0;

