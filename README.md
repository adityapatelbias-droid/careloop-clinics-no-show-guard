**GitHub Repository:** https://github.com/adityapatelbias-droid/careloop-clinics-no-show-guard

# CareLoop Clinics — No-Show Guard

**An End-to-End Healthcare Data Analytics, Machine Learning and Generative AI Project**

## 1. Project Overview

CareLoop Clinics — No-Show Guard is a data-driven healthcare analytics project focused on understanding, analysing and predicting patient appointment no-shows.

The project combines Python data cleaning, SQL analysis, machine learning and Generative AI to identify patterns associated with missed appointments, estimate no-show risk and analyse patient follow-up notes.

The main objective is to transform raw healthcare appointment data into meaningful insights and actionable recommendations that can help clinics improve appointment attendance and patient follow-up processes.

## 2. Key Findings — Four Project Parts

1. **Part 1 — Data Cleaning:** Processed 1,020 source appointment records. Removed 20 exact duplicate records and 6 records with unparseable appointment dates, producing a cleaned dataset of 990 appointments.
2. **Part 2 — SQL Analysis:** Identified 218 no-shows among 990 cleaned appointments, resulting in an overall no-show rate of 22.0%. Analysed clinic performance, appointment lead times, monthly trends and city-wise clinic rankings across 8 clinics.
3. **Part 3 — Machine Learning:** Selected Logistic Regression for no-show risk prediction. The model achieved a test ROC-AUC of 78.84%, using a classification threshold of 0.35.
4. **Part 4 — Generative AI:** Analysed 10 patient follow-up notes using Google Gemini. The CRAFT prompt generated 10 structured records that passed Pydantic validation directly.

## 3. Business Recommendation

The clinics should introduce a targeted appointment follow-up system to reduce missed appointments. The cleaned dataset contains 990 appointments, including 218 no-shows, representing a 22.0% no-show rate. The selected Logistic Regression model can identify appointments with a predicted no-show probability of 0.35 or higher for additional staff attention. Its test ROC-AUC was 78.84%, with precision and recall of 57.14% each. Clinics should combine these risk predictions with findings from the 10 analysed follow-up notes. Recommended actions include improving SMS and call reminders, verifying patient contact details, offering flexible evening or weekend appointment slots, and exploring transport assistance or telehealth options for patients facing travel difficulties. Clinic staff should review flagged appointments and use these insights to plan appropriate follow-up actions. The model should support human decision-making rather than replace it.

## 4. Project Objectives

- Clean, validate and prepare healthcare appointment datasets.
- Analyse clinic performance and no-show patterns using SQL.
- Develop a machine learning model to predict appointment no-show risk.
- Use Generative AI to extract meaningful information from patient follow-up notes.
- Generate data-driven recommendations for improving clinic operations.

## 5. Project Components

### Part 1 — Data Cleaning and Preparation

- Data ingestion and validation using Python.
- CSV processing using the Python CSV module.
- Duplicate record identification and removal.
- Invalid appointment date handling.
- Missing-value treatment and imputation.
- Outlier detection and IQR-based capping.
- Appointment feature engineering.
- Clinic data enrichment using the Open-Meteo API.
- Data quality audit reporting.
- Exporting cleaned datasets and SQL loading scripts.

**Main outputs:**
- `01_ingest_clean.ipynb`
- `appointments_clean.csv`
- `clinics_enriched.csv`
- `load_data.sql`
- `part1_audit.json`
- `rejected_rows.json`

### Part 2 — SQL Analysis

- MySQL database and table creation.
- Data loading and verification.
- Duplicate primary-key testing.
- Clinic-level no-show rate analysis.
- Appointment lead-time analysis.
- Monthly appointment and no-show trends.
- City-level clinic rankings.
- SQL result verification using Python.

**Main outputs:**
- `02_queries.sql`
- SQL supporting scripts.
- SQL analysis report.
- Python verification script.

### Part 3 — Machine Learning

- Feature preparation and preprocessing.
- Training and testing dataset preparation.
- Logistic Regression model development.
- Decision Tree and Random Forest comparison.
- Hyperparameter tuning using GridSearchCV.
- Five-fold cross-validation.
- Classification threshold selection using training-set out-of-fold predictions.
- Appointment no-show risk scoring.
- Final model evaluation on the held-out test set.

**Main outputs:**
- `03_model.ipynb`
- `test_risk_scores.csv`
- Supporting model comparison results.

### Part 4 — Generative AI Analysis

- Google Gemini API integration.
- CRAFT prompt engineering.
- Pydantic structured-output validation.
- Basic Prompt versus CRAFT Prompt comparison.
- Patient follow-up note analysis.
- Appointment and clinic data integration.
- Reason analysis by clinic and city.
- Clinic-specific recommendations.

**Main outputs:**
- `04_genai.ipynb`
- `notes_analysed.csv`
- `gemini_raw_response.json`
- `basic_prompt_response.json`
- `basic_prompt_normalized.json`
- `prompt_comparison_report.json`
- `clinic_specific_recommendations.csv`

## 6. Technologies and Tools

| Category | Technologies |
|---|---|
| Programming Language | Python |
| Data Analysis | Pandas, NumPy |
| Database | MySQL |
| Machine Learning | Scikit-learn |
| Generative AI | Google Gemini API |
| Data Validation | Pydantic |
| Weather Data | Open-Meteo API |
| Development Environment | Google Colab, Jupyter Notebook |
| Version Control | Git and GitHub |

## 7. Machine Learning Results

**Selected Model:** Logistic Regression

**Selected Classification Threshold:** 0.35

The model was selected using training data and out-of-fold predictions. The test dataset was kept separate for final evaluation.

### Test-set performance

| Metric | Result |
|---|---:|
| Accuracy | 78.79% |
| Precision | 57.14% |
| Recall | 57.14% |
| F1-score | 57.14% |
| ROC-AUC | 78.84% |
| Test appointments | 198 |
| No-shows in test set | 49 |

The model generates a probability score for each test appointment. Appointments with a predicted no-show probability of 0.35 or higher are flagged for additional review.

## 8. Generative AI Results

The Generative AI component used Google Gemini to analyse 10 patient follow-up notes.

Two prompting approaches were compared:

**CRAFT Prompt**
- Generated 10 structured records.
- Passed Pydantic validation directly.
- Produced consistent categories and confidence labels.

**Basic Prompt**
- Initially generated inconsistent category labels and confidence formats.
- Required output normalization.
- All 10 records passed validation after normalization.

The comparison demonstrates the importance of structured prompt engineering and output validation when developing Generative AI applications.

The analysed reasons included:
- No reminder.
- Transport or distance.
- Work or scheduling.
- Financial difficulties.
- Illness.
- Contact issues.
- Unknown reasons.

The findings from these notes were used to generate clinic-specific recommendations.

## 9. Project Limitations

1. **Limited Dataset Scope:** The appointment dataset contains 990 cleaned records from only 8 clinics. The results may not generalise to other healthcare facilities, regions or time periods.

2. **Machine Learning Performance:** The selected model achieved 57.14% precision and 57.14% recall at the 0.35 threshold. Some flagged appointments may still attend, while some no-shows may not be identified. Therefore, predictions should support rather than replace human decisions.

3. **Limited Generative AI Sample:** Only 10 follow-up notes were analysed. The identified reasons may not represent the wider patient population. A larger and more representative dataset with human validation would be required for stronger conclusions.

## 10. Repository Structure

The GitHub repository is organised into four main project components:

- `data/` — Original source CSV datasets.
- `Part_1_Data_Cleaning/` — Data ingestion, cleaning, validation and audit outputs.
- `Part_2_SQL_Analysis/` — Consolidated SQL queries, supporting SQL scripts and analysis report.
- `Part_3_Machine_Learning/` — Machine learning notebook, Python implementation and risk scores.
- `Part_4_Generative_AI/` — Gemini notebook, analysed notes, prompt comparison, validation results and recommendations.

## 11. Security and Data Handling

- Gemini API credentials were accessed through Google Colab Secrets.
- API keys and private credentials are not included in the submitted notebook or repository.
- Original datasets and processed outputs are maintained as separate files.
- Data cleaning and processing steps are documented for reproducibility.

## 12. Project Status

**All four project components have been completed and organised for final capstone submission.**

The repository contains the data preparation workflow, SQL analysis, machine learning implementation, Generative AI analysis and supporting outputs.

---

*CareLoop Clinics — No-Show Guard | Healthcare Data Analytics, Machine Learning and Generative AI Capstone Project*
