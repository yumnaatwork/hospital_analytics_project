-- DATA REPORT
-- Data quality audit: billing amounts
SELECT
    'Total Records'                              AS metric,
    COUNT(*)                                     AS value
FROM patients

UNION ALL

SELECT
    'Negative Billing (excluded)',
    COUNT(*)
FROM patients WHERE billing_amount < 0

UNION ALL

SELECT
    'Valid Records (used in analysis)',
    COUNT(*)
FROM patients WHERE billing_amount > 0

UNION ALL

SELECT
    'Exclusion Rate (%)',
    ROUND(SUM(CASE WHEN billing_amount < 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2)
FROM patients;

-- Data Quality Section
-- During exploratory analysis, 108 records (0.19%) were identified with negative billing amounts. 
-- These were investigated for patterns across insurance providers, conditions, admission types, and time periods. 
-- No statistically significant clustering was found, suggesting random data entry errors rather than systematic billing adjustments. 
-- Given their negligible volume and lack of clear business meaning, these records were excluded from analysis via a base view, preserving
-- the raw data intact. In a production environment, these would be escalated to the source system team for investigation.