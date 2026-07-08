-- Create a dedicated database for this project
CREATE DATABASE hospital_analytics;

-- Switch into it
USE hospital_analytics;

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    blood_type VARCHAR(5),
    medical_condition VARCHAR(100),
    admission_date DATE,
    doctor VARCHAR(100),
    hospital VARCHAR(150),
    insurance_provider VARCHAR(100),
    billing_amount DECIMAL(15,6),
    room_number INT,
    admission_type VARCHAR(50),
    discharge_date DATE,
    medication VARCHAR(100),
    test_result VARCHAR(50)
);

DESCRIBE patients;

