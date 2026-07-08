-- KEY PERFORMANCE INDICATORS FOR THE HOSPITAL PROJECT
-- KPI 1: Average billing by insurance provider 
SELECT
    insurance_provider,
    COUNT(*)                        AS total_patients,
    ROUND(SUM(billing_amount), 2)   AS total_revenue,
    ROUND(AVG(billing_amount), 2)   AS avg_billing_per_patient,
    ROUND(MIN(billing_amount), 2)   AS min_bill,
    ROUND(MAX(billing_amount), 2)   AS max_bill
FROM vw_clean_patients
GROUP BY insurance_provider
ORDER BY avg_billing_per_patient DESC;
-- This indicates which insurer pays most per patient on average, which has the widest billing range, and how many patients each covers.

-- KPI 2: Revenue by medical condition
SELECT
    medical_condition,
    COUNT(*)                        AS patient_count,
    ROUND(SUM(billing_amount), 2)   AS total_revenue,
    ROUND(AVG(billing_amount), 2)   AS avg_billing,
    ROUND(AVG(length_of_stay), 1)   AS avg_stay_days
FROM vw_clean_patients
GROUP BY medical_condition
ORDER BY total_revenue DESC;
-- The combination of avg_billing and avg_stay_days in one query is particularly powerful as it shows whether high-cost conditions 
-- also mean longer stays, or whether some conditions have high bills but short stays
-- (which might indicate expensive treatments delivered quickly).

-- KPI 3: Average length of stay by condition and admission type
SELECT
    medical_condition,
    admission_type,
    COUNT(*)                        AS patient_count,
    ROUND(AVG(length_of_stay), 1)   AS avg_stay_days,
    ROUND(MIN(length_of_stay), 0)   AS min_stay,
    ROUND(MAX(length_of_stay), 0)   AS max_stay
FROM vw_clean_patients
GROUP BY medical_condition, admission_type
ORDER BY medical_condition, avg_stay_days DESC;
-- Length of stay is one of the biggest operational levers in healthcare. 
-- Longer stays cost more, occupy beds, and reduce capacity for new patients. 

-- KPI 4: Test result outcomes by condition
SELECT
    medical_condition,
    test_result,
    COUNT(*) AS patient_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY medical_condition),1) AS pct_of_condition
FROM vw_clean_patients
GROUP BY medical_condition, test_result
ORDER BY medical_condition, patient_count DESC;

-- KPI 5: Doctor workload and revenue performance
SELECT
    doctor,
    COUNT(*)                                AS total_patients,
    ROUND(SUM(billing_amount), 2)           AS total_revenue_generated,
    ROUND(AVG(billing_amount), 2)           AS avg_billing_per_patient,
    ROUND(AVG(length_of_stay), 1)           AS avg_patient_stay,
    COUNT(DISTINCT medical_condition)       AS conditions_treated
FROM vw_clean_patients
GROUP BY doctor
ORDER BY total_patients DESC
LIMIT 15;

-- KPI 6: Monthly admission trends by type
SELECT
    DATE_FORMAT(admission_date, '%Y-%m')    AS month,
    admission_type,
    COUNT(*)                                AS admissions,
    ROUND(AVG(billing_amount), 2)           AS avg_billing,
    ROUND(AVG(length_of_stay), 1)           AS avg_stay
FROM vw_clean_patients
GROUP BY month, admission_type
ORDER BY month, admission_type;
-- This KPI shows how patient volume changes month to month and whether the mix of admission types shifts over time.

-- KPI 7: Age group analysis
SELECT
    age_group,
    COUNT(*)                        AS patient_count,
    ROUND(AVG(billing_amount), 2)   AS avg_billing,
    ROUND(AVG(length_of_stay), 1)   AS avg_stay_days,
    -- Most common condition per age group using a subquery
    (SELECT medical_condition
     FROM vw_clean_patients p2
     WHERE p2.age_group = p1.age_group
     GROUP BY medical_condition
     ORDER BY COUNT(*) DESC
     LIMIT 1)                       AS most_common_condition
FROM vw_clean_patients p1
GROUP BY age_group
ORDER BY FIELD(age_group, 'Under 18', '18–34', '35–49', '50–64', '65+');

-- CREATING VIEWS FOR POWERBI
-- Summary view for the executive dashboard page
CREATE VIEW vw_executive_summary AS
SELECT
    insurance_provider,
    medical_condition,
    admission_type,
    COUNT(*)                        AS patient_count,
    ROUND(SUM(billing_amount), 2)   AS total_revenue,
    ROUND(AVG(billing_amount), 2)   AS avg_billing,
    ROUND(AVG(length_of_stay), 1)   AS avg_stay_days
FROM vw_clean_patients
GROUP BY insurance_provider, medical_condition, admission_type;

-- Monthly trend view for the time series charts
CREATE VIEW vw_monthly_trends AS
SELECT
    DATE_FORMAT(admission_date, '%Y-%m')    AS month,
    YEAR(admission_date)                    AS year,
    MONTH(admission_date)                   AS month_num,
    admission_type,
    COUNT(*)                                AS admissions,
    ROUND(SUM(billing_amount), 2)           AS total_billing,
    ROUND(AVG(length_of_stay), 1)           AS avg_stay
FROM vw_clean_patients
GROUP BY month, year, month_num, admission_type;

-- Doctor performance view
CREATE VIEW vw_doctor_performance AS
SELECT
    doctor,
    COUNT(*)                        AS total_patients,
    ROUND(SUM(billing_amount), 2)   AS total_revenue,
    ROUND(AVG(billing_amount), 2)   AS avg_billing,
    ROUND(AVG(length_of_stay), 1)   AS avg_stay,
    COUNT(DISTINCT medical_condition) AS conditions_treated
FROM vw_clean_patients
GROUP BY doctor;

SELECT *
FROM vw_executive_summary;

SELECT *
FROM vw_monthly_trends;

SELECT *
FROM vw_doctor_performance;

-- FINAL CHECKS BEFORE MOVING TO POWERBI

-- Confirm all views exist
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Test each view returns sensible data
SELECT * FROM vw_executive_summary LIMIT 5;
SELECT * FROM vw_monthly_trends LIMIT 5;
SELECT * FROM vw_doctor_performance LIMIT 5;

-- Final row count check
SELECT COUNT(*) FROM patients;

-- Check no negative or zero stays exist
SELECT COUNT(*) AS bad_stays
FROM patients
WHERE length_of_stay <= 0;










