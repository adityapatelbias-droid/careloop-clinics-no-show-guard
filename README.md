**GitHub Repository:** https://github.com/adityapatelbias-droid/careloop-clinics-no-show-guard

# CareLoop Clinics — No-Show Guard

**An End-to-End Healthcare Data Analytics, Machine Learning and Generative AI Project**

## 1. Project Overview

CareLoop Clinics — No-Show Guard is a data-driven project focused on understanding and predicting patient appointment no-shows in healthcare clinics.

The project combines data cleaning, SQL analysis, machine learning and Generative AI to identify patterns associated with missed appointments, estimate no-show risk and analyse patient follow-up notes.

The objective is to turn raw clinic appointment data into meaningful insights that can help clinics improve appointment attendance and patient follow-up processes.

## 2. Project Objectives

- Clean, validate and prepare healthcare appointment datasets.
- Analyse clinic performance and no-show patterns using SQL.
- Develop a machine learning model to predict appointment no-show risk.
- Use Generative AI to extract meaningful information from patient follow-up notes.
- Generate data-driven recommendations for improving clinic operations.

## 3. Project Components

### Part 1 — Data Cleaning and Preparation

- Data ingestion and validation.
- Duplicate record identification and removal.
- Invalid appointment date handling.
- Missing-value treatment and imputation.
- Distance data validation and capping.
- Clinic data enrichment.
- Data quality audit reporting.

### Part 2 — SQL Analysis

- Database and table creation.
- Data loading and verification.
- Clinic-level no-show rate analysis.
- Appointment lead-time analysis.
- Monthly appointment trends.
- City-level clinic rankings.
- SQL result verification using Python.

### Part 3 — Machine Learning

- Feature preparation and preprocessing.
- Training and testing dataset preparation.
- Logistic Regression model development.
- Appointment no-show risk scoring.
- Classification threshold selection.
- Model evaluation using accuracy, precision, recall, F1-score and ROC-AUC.
- Test-set risk score generation.

### Part 4 — Generative AI Analysis

- Google Gemini API integration.
- CRAFT prompt engineering.
- Pydantic structured-output validation.
- Basic Prompt versus CRAFT Prompt comparison.
- Patient follow-up note analysis.
- Appointment and clinic data integration.
- Reason analysis by clinic and city.
- Clinic-specific recommendations.

## 4. Technologies and Tools

| Category | Technologies |
|---|---|
| Programming | Python |
| Data Analysis | Pandas, NumPy |
| Database | MySQL |
| Machine Learning | Scikit-learn |
| Generative AI | Google Gemini API |
| Data Validation | Pydantic |
| Development | Google Colab, Jupyter Notebook |
| Version Control | Git and GitHub |

## 5. Repository Structure

The repository is organised into four main project components:

- `Part_1_Data_Cleaning/` — Data ingestion, cleaning, validation and audit outputs.
- `Part_2_SQL_Analysis/` — SQL scripts, screenshots and analysis report.
- `Part_3_Machine_Learning/` — Machine learning notebook, Python implementation and risk scores.
- `Part_4_Generative_AI/` — Gemini analysis, prompt comparison, validation results and recommendations.

## 6. Machine Learning Results

The Logistic Regression model was selected for appointment no-show risk prediction.

**Test-set evaluation:**

| Metric | Result |
|---|---:|
| Accuracy | 78.79% |
| Precision | 57.14% |
| Recall | 57.14% |
| F1-score | 57.14% |
| ROC-AUC | 78.84% |

The model was evaluated on a separate test dataset containing 198 appointments.

## 7. Generative AI Results

The Generative AI component analysed 10 patient follow-up notes using Google Gemini.

The CRAFT prompt generated structured results that passed Pydantic validation directly.

The Basic Prompt initially required output normalization because its category labels and confidence format differed from the predefined schema. After normalization, all 10 records passed validation.

This comparison demonstrates the importance of structured prompting and output validation in Generative AI applications.

## 8. Project Outputs

The repository includes:

- Cleaned and enriched datasets.
- Data quality audit reports.
- SQL scripts and analysis results.
- Machine learning notebook and Python implementation.
- Appointment no-show risk scores.
- Gemini-generated follow-up note analysis.
- Prompt comparison and validation reports.
- Clinic-specific recommendations.

## 9. Security and Data Handling

- Gemini API credentials were accessed through Google Colab Secrets.
- API keys and private credentials are not intended to be included in this repository.
- Original datasets and processed outputs are maintained separately.

## 10. Project Status

**All four project components have been completed and organised for final review and submission.**

---

*CareLoop Clinics — No-Show Guard | Healthcare Data Analytics and Machine Learning Capstone Project*
