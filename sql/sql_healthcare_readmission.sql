CREATE DATABASE healthcare_project;
USE healthcare_project;

CREATE TABLE readmitguard_data (
  encounter_id BIGINT,
  patient_nbr BIGINT,
  race VARCHAR(50),
  gender VARCHAR(20),
  age VARCHAR(20),
  age_bucket VARCHAR(20),
  admission_type_id INT,
  discharge_disposition_id INT,
  admission_source_id INT,
  time_in_hospital INT,
  num_lab_procedures INT,
  num_procedures INT,
  num_medications INT,
  number_outpatient INT,
  number_emergency INT,
  number_inpatient INT,
  diag_1 VARCHAR(50),
  diag_2 VARCHAR(50),
  diag_3 VARCHAR(50),
  number_diagnoses INT,
  max_glu_serum VARCHAR(20),
  a1cresult VARCHAR(20),
  insulin VARCHAR(20),
  `change` VARCHAR(10),
  diabetesMed VARCHAR(10),
  readmitted VARCHAR(10),
  readmit_30d VARCHAR(5),
  stay_days_flag VARCHAR(10),
  encounter_key VARCHAR(100)
);

SHOW VARIABLES LIKE 'secure_file_priv';

-- loaded data via cmd as its fast and easy
--  Verify row count
SELECT COUNT(*) FROM readmitguard_data;

-- spotcheck the first few rows
SELECT * FROM readmitguard_data LIMIT 5;

-- Optional cleanup (remove “?” or “None”)

SET SQL_SAFE_UPDATES = 0;

UPDATE readmitguard_data
SET race = NULLIF(race, '?'),
    diag_1 = NULLIF(diag_1, '?'),
    diag_2 = NULLIF(diag_2, '?'),
    diag_3 = NULLIF(diag_3, '?'),
    max_glu_serum = NULLIF(max_glu_serum, '?'),
    a1cresult = NULLIF(a1cresult, '?');

SET SQL_SAFE_UPDATES = 1;

-- Check one numeric field for sanity
SELECT MIN(time_in_hospital), MAX(time_in_hospital) FROM readmitguard_data;

SHOW INDEXES FROM readmitguard_data;

CREATE INDEX idx_readmit ON readmitguard_data (readmit_30d);
CREATE INDEX idx_age ON readmitguard_data (age_bucket);
CREATE INDEX idx_gender ON readmitguard_data (gender);
CREATE INDEX idx_diag1 ON readmitguard_data (diag_1);

-- Confirm that they exist now
SHOW INDEXES FROM readmitguard_data;

-- master kpi
SELECT
  COUNT(*) AS total_encounters,
  COUNT(DISTINCT patient_nbr) AS unique_patients,
  SUM(CASE WHEN readmit_30d='Yes' THEN 1 ELSE 0 END) AS readmit_count,
  ROUND(100.0*SUM(CASE WHEN readmit_30d='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS readmit_pct
FROM readmitguard_data;

-- Q2 — by age bucket (ordered)
SELECT
  age_bucket,
  COUNT(*) AS encounters,
  SUM(CASE WHEN readmit_30d='Yes' THEN 1 ELSE 0 END) AS readmit_count,
  ROUND(100.0*SUM(CASE WHEN readmit_30d='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS readmit_pct
FROM readmitguard_data
GROUP BY age_bucket
ORDER BY CAST(SUBSTRING_INDEX(age_bucket,'-',1) AS UNSIGNED);

-- fixes
-- step a 1) See unique values in age_bucket and counts
SELECT age_bucket, COUNT(*) AS n
FROM readmitguard_data
GROUP BY age_bucket
ORDER BY CAST(age_bucket AS UNSIGNED), age_bucket
LIMIT 50;

-- 2) See exactly what values readmitted and readmit_30d contain
SELECT readmitted, readmit_30d, COUNT(*) AS n
FROM readmitguard_data
GROUP BY readmitted, readmit_30d
ORDER BY n DESC;

-- Step B — Fix your readmission flag
SET SQL_SAFE_UPDATES = 0;

UPDATE readmitguard_data
SET readmit_30d = CASE
    WHEN UPPER(TRIM(readmitted)) IN ('UP','DOWN') THEN 'Yes'
    ELSE 'No'
END;

SET SQL_SAFE_UPDATES = 1;

-- Step C — Re-running Q2 with readable age ranges 

SELECT
  CASE TRIM(age_bucket)
    WHEN '1' THEN '0-10'
    WHEN '2' THEN '10-20'
    WHEN '3' THEN '20-30'
    WHEN '4' THEN '30-40'
    WHEN '5' THEN '40-50'
    WHEN '6' THEN '50-60'
    WHEN '7' THEN '60-70'
    WHEN '8' THEN '70-80'
    ELSE age_bucket
  END AS age_range,
  COUNT(*) AS encounters,
  SUM(CASE WHEN readmit_30d='Yes' THEN 1 ELSE 0 END) AS readmit_count,
  ROUND(100.0 * SUM(CASE WHEN readmit_30d='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS readmit_pct
FROM readmitguard_data
GROUP BY age_range
ORDER BY CAST(SUBSTRING_INDEX(age_range,'-',1) AS UNSIGNED);

#Show distinct raw age values and frequency:
SELECT age, COUNT(*) AS n
FROM readmitguard_data
GROUP BY age
ORDER BY n DESC
LIMIT 50;

-- Show a sample of rows for a tiny bucket (e.g., age_bucket = '4' which mapped to 30–40):
SELECT encounter_id, patient_nbr, age, age_bucket, readmitted, readmit_30d
FROM readmitguard_data
WHERE age_bucket = '4'
LIMIT 20;

--  Fix Plan ----Let’s correct two things once and for all:
-- Step 1 — Recreate readmit_30d from readmitted
SET SQL_SAFE_UPDATES = 0;

UPDATE readmitguard_data
SET readmit_30d = CASE
    WHEN UPPER(TRIM(readmitted)) IN ('UP', 'DOWN') THEN 'Yes'
    ELSE 'No'
END;

SET SQL_SAFE_UPDATES = 1;

-- Step 2 — Re-run the clean age-based readmission query using age
SELECT
  age AS age_range,
  COUNT(*) AS encounters,
  SUM(CASE WHEN readmit_30d = 'Yes' THEN 1 ELSE 0 END) AS readmit_count,
  ROUND(100.0 * SUM(CASE WHEN readmit_30d = 'Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS readmit_pct
FROM readmitguard_data
GROUP BY age
ORDER BY CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(age, '-', 1), '[', -1) AS UNSIGNED);

-- Admission Type vs Average Stay & Readmission % --- identify which types of hospital admissions lead to longer stays and higher re-hospitalization.
SELECT 
    admission_type_id,
    COUNT(*) AS encounters,
    ROUND(AVG(time_in_hospital), 2) AS avg_stay_days,
    ROUND(100.0 * SUM(CASE
                WHEN readmit_30d = 'Yes' THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS readmit_pct
FROM
    readmitguard_data
GROUP BY admission_type_id
ORDER BY avg_stay_days DESC;



-- Top 10 Primary Diagnoses (diag_1) and Readmission %.
SELECT
  diag_1,
  COUNT(*) AS encounters,
  SUM(CASE WHEN readmit_30d='Yes' THEN 1 ELSE 0 END) AS readmit_count,
  ROUND(100.0 * SUM(CASE WHEN readmit_30d='Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS readmit_pct
FROM readmitguard_data
WHERE diag_1 IS NOT NULL AND TRIM(diag_1) <> ''
GROUP BY diag_1
ORDER BY encounters DESC
LIMIT 10;

SELECT 
  CASE
    WHEN diag_1 LIKE '250%' THEN 'Diabetes'
    WHEN diag_1 BETWEEN '390' AND '459' THEN 'Circulatory System Disorders'
    WHEN diag_1 BETWEEN '460' AND '519' THEN 'Respiratory Diseases'
    WHEN diag_1 BETWEEN '520' AND '579' THEN 'Digestive Disorders'
    WHEN diag_1 BETWEEN '580' AND '629' THEN 'Genitourinary Disorders'
    WHEN diag_1 BETWEEN '780' AND '799' THEN 'Symptoms & Ill-defined Conditions'
    WHEN diag_1 BETWEEN '800' AND '999' THEN 'Injury or Poisoning'
    WHEN diag_1 BETWEEN '710' AND '739' THEN 'Musculoskeletal Disorders'
    WHEN diag_1 BETWEEN '140' AND '239' THEN 'Neoplasms (Cancer)'
    ELSE 'Other/Unspecified'
  END AS diagnosis_category,
  
  COUNT(*) AS encounters,
  SUM(CASE WHEN readmit_30d = 'Yes' THEN 1 ELSE 0 END) AS readmit_count,
  ROUND(100.0 * SUM(CASE WHEN readmit_30d = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS readmit_pct
FROM readmitguard_data
WHERE diag_1 IS NOT NULL AND TRIM(diag_1) <> ''
GROUP BY diagnosis_category
ORDER BY encounters DESC
LIMIT 10;

-- Q5 — Gender vs Re-admission
SELECT
  gender,
  COUNT(*) AS encounters,
  ROUND(100.0 * SUM(CASE WHEN readmit_30d='Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS readmit_pct
FROM readmitguard_data
GROUP BY gender
ORDER BY readmit_pct DESC;

-- Q6 — Race vs Readmission
SELECT
  race,
  COUNT(*) AS encounters,
  ROUND(100.0 * SUM(CASE WHEN readmit_30d='Yes' THEN 1 ELSE 0 END)/COUNT(*), 2) AS readmit_pct
FROM readmitguard_data
GROUP BY race
ORDER BY encounters DESC;

-- Q7 — Average Medications Used vs Readmission
SELECT
  readmit_30d,
  ROUND(AVG(num_medications), 2) AS avg_medications,
  COUNT(*) AS encounters
FROM readmitguard_data
GROUP BY readmit_30d;
