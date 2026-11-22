CareLoop Clinics — Part 3 files

1. Upload appointments_clean.csv to Google Colab.
2. Upload/open CareLoop_Part3_Machine_Learning.ipynb (or run the .py script in a notebook cell).
3. Run all cells from top to bottom.
4. Confirm the printed checks:
   - 990 rows and 11 feature columns
   - 792 training rows and 198 test rows
   - 49 no-shows in the test set
   - baseline accuracy 0.7525
5. Download test_risk_scores.csv and the four part3_*.csv supporting outputs.
6. Take screenshots of the printed metric tables and final test metrics for your submission.

Important:
- The notebook uses only the allowed features listed in the Masai instructions.
- patient_id, appointment_id, dates, clinic_id, gender and status are not model features.
- The test set is not used for model selection or threshold selection.
- The supplied acceptance criteria are reference values, not a reason to alter results.
