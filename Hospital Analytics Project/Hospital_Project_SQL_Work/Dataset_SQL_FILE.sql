LOAD DATA LOCAL INFILE 'C:/Users/USER/OneDrive/Desktop/Data Analytics/Hospital Analytics Project/healthcare_dataset/healthcare_dataset.csv'
INTO TABLE patients
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
name,
age,
gender,
blood_type,
medical_condition,
admission_date,
doctor,
hospital,
insurance_provider,
billing_amount,
room_number,
admission_type,
discharge_date,
medication,
test_result
);

DESCRIBE patients;

SELECT billing_amount
FROM patients
WHERE billing_amount IS NULL
LIMIT 20;

SELECT billing_amount
FROM patients
ORDER BY billing_amount DESC
LIMIT 10;

SELECT COUNT(*), COUNT(DISTINCT billing_amount)
FROM patients;

SELECT MIN(billing_amount), MAX(billing_amount)
FROM patients;

SELECT *
FROM patients
WHERE billing_amount <= 0;