===========================================
PROCESSED DATA — Healthcare Readmission Analytics
===========================================

📁 Folder: data/processed/
🩺 Project: Healthcare Readmission Analytics
🎯 Purpose: Store cleaned, feature-engineered, and Tableau-ready datasets.

-------------------------------------------
DESCRIPTION
-------------------------------------------
This folder contains the **processed version** of the healthcare readmission dataset used
for exploratory analysis, feature engineering, and visualization.

The main processed file in this project:
- `healthcare_processed.csv` → Tableau-ready export generated after Python preprocessing.

-------------------------------------------
CREATION WORKFLOW
-------------------------------------------
1. The raw dataset (`healthcare_raw.csv`) was cleaned and loaded into SQL for basic filtering.
2. Cleaned records were exported from MySQL into Python via Pandas.
3. Feature engineering and transformations were applied in:
   - `python/healthcare_eda_feature_engineering.ipynb`
4. The final processed file was exported as `healthcare_processed.csv`.

-------------------------------------------
DATA CHARACTERISTICS
-------------------------------------------
- Contains no missing or null values.
- All categorical fields encoded and standardized.
- Numerical variables normalized/scaled where applicable.
- Target variable `readmit_30d` retained as binary label.
- Columns renamed for clarity and compatibility with Tableau.

-------------------------------------------
USAGE
-------------------------------------------
- Used by Tableau workbook: `tableau/healthcare_dashboard.twbx`
- Supports KPIs, trend analysis, and story dashboards.
- Recommended to keep this file lightweight (<25 MB) for GitHub upload.

-------------------------------------------
VERSIONING NOTES
-------------------------------------------
v1.0 — Initial processed dataset (October 2025)
v1.1 — Minor renaming and column formatting for Tableau compatibility

-------------------------------------------
AUTHOR & CONTACT
-------------------------------------------
Prepared by: Ashish Chamel  
Date: October 2025  
Notes: For reproducibility, regenerate this file using the Python notebook mentioned above.
