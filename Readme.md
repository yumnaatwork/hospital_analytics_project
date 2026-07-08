Hospital Operations Analytics Dashboard
Business Data Analytics Portfolio Project
Tools: MySQL | Power BI
Domain: Healthcare
Level: Intermediate
Dataset: Healthcare Dataset - Kaggle
Project Overview
This project is a comprehensive end-to-end business data analytics solution for a hospital network. It covers the complete analytics lifecycle: data acquisition, database design, data cleaning, SQL-based analysis, and interactive Power BI dashboard development.

The goal is to provide hospital management with actionable insights across four operational areas: financial performance, clinical outcomes, patient demographics, and operational efficiency. 
Business Problem
Which insurance providers generate the most revenue per patient?
Which medical conditions result in the longest and most expensive hospital stays?
Are there patterns in patient test results that signal quality concerns?
Which doctors handle the highest patient volumes and generate the most revenue?
How do admissions trend over time and does the mix of emergency versus elective admissions shift seasonally?
Do older patients cost significantly more than younger patients?

Dataset Description
Source: Kaggle - Healthcare Dataset by Prasad
Size: 55,500 rows, 15 columns
Time period: 2019 to 2024
Format: CSV

ColumnsMedical Conditions Covered
Arthritis, Asthma, Cancer, Diabetes, Hypertension, Obesity

Insurance Providers Covered
Aetna, Blue Cross, Cigna, Medicare, UnitedHealthcare

The raw data layer is kept completely untouched. All transformation logic lives in SQL views. Power BI connects directly to the views and adds DAX measures on top. This separation of concerns mirrors how analytics is structured in professional data environments.

SQL Analysis and KPIs
All KPI queries are built on top of vw_clean_patients and saved as views for direct use in Power BI.
KPI 1: Billing by Insurance Provider
KPI 2: Executive Summary (Financial + Clinical Combined)
KPI 3: Length of Stay by Condition and Admission Type
KPI 4: Test Result Outcomes by Condition
KPI 5: Doctor Performance
KPI 6: Monthly Admission Trends
KPI 7: Age Group Demographics

Dashboard Pages
Page 1: Executive Overview 
Page 2: Clinical Analysis 
Page 3: Financial Performance
Page 4: Operational Efficiency 

Key Findings
Total revenue across 55,392 patients exceeds $1.42 billion over the 2019 to 2024 period
Average billing per patient is approximately $25,590
Average length of stay is 15.51 days across all conditions and admission types
Admission types are distributed almost equally at roughly 33% each across Emergency, Elective, and Urgent, which is a characteristic of the synthetic dataset
All five insurance providers show similar average billing, suggesting the dataset does not model real-world insurer negotiation differences
Test results are distributed across Normal, Abnormal, and Inconclusive with no single condition showing a dramatically different pattern, again reflecting the synthetic nature of the data


