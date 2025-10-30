===========================================
SOURCE CODE — Healthcare Readmission Analytics
===========================================

📁 Folder: src/
🩺 Project: Healthcare Readmission Analytics
🎯 Purpose: Store all core scripts, notebooks, and utility functions used in the analytical workflow.

-------------------------------------------
DESCRIPTION
-------------------------------------------
This folder holds all **source code and automation scripts** related to:
- Data ingestion (CSV to SQL)
- Data transformation and feature engineering
- Model preparation and export
- Utility functions for reproducibility

For this project, most of the source work is implemented in a single Jupyter Notebook:
> `python/healthcare_eda_feature_engineering.ipynb`

That notebook performs:
- Loading and cleaning of the raw dataset (`healthcare_raw.csv`)
- Data validation and null-handling
- Feature encoding for A1C, glucose, and medication variables
- Export of the Tableau-ready dataset (`healthcare_processed.csv`)

-------------------------------------------
RECOMMENDED STRUCTURE
-------------------------------------------
Suggested modular Python files for future expansion:
src/
├── data_ingest.py # SQL connection, loading, and extraction
├── clean_transform.py # Cleaning and transformation functions
├── feature_engineering.py # Custom feature creation and encoding
├── model_training.py # Placeholder for predictive modeling (future)
├── utils.py # Helper functions (logging, configs, etc.)
└── README_placeholder.txt # (this file)


-------------------------------------------
NOTES
-------------------------------------------
- This folder currently serves as a placeholder for reproducibility.
- Scripts may be migrated here from the notebook once modularized.
- Version control should track `.py` scripts only — exclude large data files.

-------------------------------------------
AUTHOR & CONTACT
-------------------------------------------
Author: Ashish Chamel  
Date: October 2025  
Version: v1.0  
Contact: [GitHub Profile or LinkedIn Link Here]
