# CareLoop Clinics — Part 4: Generative AI Analysis

## Objective
Analyse patient follow-up notes using Gemini and structured prompting.

## Dataset
- appointments_clean.csv
- followup_notes.csv
- clinics.csv

## Tasks Completed
1. Loaded and inspected the datasets.
2. Defined a Pydantic schema for structured note analysis.
3. Tested invalid responses and schema validation.
4. Created a CRAFT prompt for Gemini.
5. Analysed 10 follow-up notes using Gemini.
6. Validated the generated structured output.
7. Merged analysed notes with appointment and clinic data.
8. Created reason-by-clinic and reason-by-city summaries.
9. Generated clinic-specific recommendations.
10. Compared CRAFT and Basic Prompt outputs.

## Prompt Comparison
The CRAFT prompt produced 10 valid records and passed schema validation directly.

The Basic Prompt initially used inconsistent category labels and numeric
confidence scores. It required normalization into the predefined categories
and confidence levels. After normalization, all 10 records passed validation.

This demonstrates that CRAFT reduced the need for post-processing.

## Important Outputs
- notes_analysed.csv
- gemini_raw_response.json
- basic_prompt_response.json
- basic_prompt_normalized.json
- basic_prompt_validation_report.json
- merged_notes_appointments_clinics.csv
- reason_by_clinic.csv
- reason_by_city.csv
- clinic_specific_recommendations.csv
- prompt_comparison_report.json

## API Security
The Gemini API key was stored using Colab Secrets and is not included
in the submission.
