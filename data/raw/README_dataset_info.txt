===========================================
DATASET INFORMATION — Healthcare Readmission Analytics
===========================================

📁 File Name: healthcare_raw.csv  
🩺 Project: Healthcare Readmission Analytics  
🎯 Goal: Predict 30-day patient readmission likelihood based on clinical and operational variables.

-------------------------------------------
DATA OVERVIEW
-------------------------------------------
- Source: Hospital encounters dataset (based on publicly available diabetic patient readmission data).
- Total Rows: 101,766
- Total Columns: 47
- Data Type: Structured CSV file (comma-separated)
- Target Variable: readmit_30d (Binary: "Yes" = readmitted within 30 days, "No" = not readmitted)

-------------------------------------------
COLUMN DETAILS
-------------------------------------------
- encounter_id — Unique patient encounter identifier
- patient_nbr — Unique patient number
- race — Patient race/ethnicity (categorical)
- gender — Gender of patient
- age — Age bucket (e.g., [40-50))
- admission_type_id — Type of hospital admission (Emergency, Elective, etc.)
- discharge_disposition_id — Patient discharge category
- admission_source_id — Source of patient admission
- time_in_hospital — Length of stay in days
- num_lab_procedures — Number of lab tests performed
- num_procedures — Number of procedures undertaken
- num_medications — Count of medications prescribed
- number_diagnoses — Total number of diagnoses assigned
- diag_1, diag_2, diag_3 — Primary, secondary, tertiary diagnosis codes
- max_glu_serum — Glucose level category (Normal / >200 / >300 / None)
- A1Cresult — HbA1c blood sugar indicator (Normal / >7 / >8 / None)
- insulin — Insulin prescription flag (No / Steady / Up / Down)
- change — Indicates if medication was changed during encounter
- diabetesMed — Whether any diabetes medication was prescribed
- readmitted — Original string flag (">30", "<30", "No")
- readmit_30d — Derived binary field ("Yes" if <30, else "No")

-------------------------------------------
DATA CLEANING NOTES
-------------------------------------------
- Columns with >30% missing values (weight, payer_code, medical_specialty) were removed.
- Placeholder values ("?", "Unknown", "None") replaced with NULL or "Not Measured".
- Duplicates removed based on encounter_id + patient_nbr combination.
- Data exported to `healthcare_raw.csv` after Excel and SQL cleaning.
- Processed dataset exported as `healthcare_processed.csv` for Tableau visualization.

-------------------------------------------
TARGET DESCRIPTION
-------------------------------------------
- Variable: `readmit_30d`
- Type: Binary (Yes / No)
- Positive class: "Yes" → Patient readmitted within 30 days of discharge
- Negative class: "No" → Patient not readmitted within 30 days

-------------------------------------------
REFERENCE
-------------------------------------------
Dataset prepared as part of “Healthcare Readmission Analytics” capstone project.  
Cleaned and analyzed using Excel, MySQL, Python, and Tableau.

Author: Ashish Chamel  
Date: October 2025
