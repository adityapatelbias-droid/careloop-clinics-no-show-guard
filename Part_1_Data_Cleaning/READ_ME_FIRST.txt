CARELOOP CLINICS — PART 2 FINAL PACKAGE

Files:
1. Task_2_1_Create_Database_and_Tables.sql
   Creates the database and both tables using the assignment schema. Run before data loading.

2. Part_2_SQL_Analysis_Report.docx
   Draft report using your supplied MySQL screenshots and the cleaned appointment data.

3. Task_2_2_Python_Groupby_Verification.py
   Run this in the same folder as appointments_clean.csv (Google Colab or local Python).
   Capture a screenshot of its output for the Masai submission.

4. Task_2_1_and_2_2_Extra_Checks.sql
   In MySQL Workbench:
   - First run the duplicate-key INSERT statement ALONE. It should fail with duplicate key.
   - Then run the all-clinics SELECT query separately.
   - Save screenshots of both outputs/errors.

IMPORTANT:
- Do not run the duplicate-key INSERT as part of a bulk script.
- Do not rerun load_data.sql just to test the duplicate key.
- The duplicate-key test has not been executed on your MySQL instance by this package.
- The Python script should be run by you and its output screenshot retained as execution evidence.
