
-- ============================================================
-- CareLoop Clinics — No-Show Guard
-- Part 2: SQL Analysis
-- File: 02_queries.sql
-- ============================================================

-- STEP 1: Create database and tables

CREATE DATABASE IF NOT EXISTS noshowguard;
USE noshowguard;

CREATE TABLE IF NOT EXISTS clinics (
    clinic_id VARCHAR(5) PRIMARY KEY,
    clinic_name VARCHAR(40) NOT NULL,
    city VARCHAR(20) NOT NULL,
    tier VARCHAR(10),
    latitude DECIMAL(8,4),
    longitude DECIMAL(8,4),
    temp_c DECIMAL(5,1)
);

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id VARCHAR(8) PRIMARY KEY,
    patient_id VARCHAR(8) NOT NULL,
    clinic_id VARCHAR(5) NOT NULL,
    booked_on DATE,
    appt_date DATE,
    age INT,
    gender VARCHAR(1),
    distance_km DECIMAL(5,1),
    fee_inr INT,
    booking_channel VARCHAR(10),
    visit_type VARCHAR(12),
    reminder_sent VARCHAR(3),
    prior_no_shows INT,
    status VARCHAR(10),
    lead_days INT,
    no_show INT,
    FOREIGN KEY (clinic_id) REFERENCES clinics(clinic_id)
);

-- STEP 2: Data loading
-- Run the existing Part 1 load_data.sql separately
-- after creating the tables.
-- It inserts clinic and appointment records.

-- STEP 3: Duplicate-key test
-- Run this statement ALONE after the 990 appointment rows
-- have been loaded.
--
-- Expected error:
-- ERROR 1062 (23000): Duplicate entry 'A0001'
-- for key 'appointments.PRIMARY'

-- INSERT INTO appointments (appointment_id, patient_id, clinic_id)
-- VALUES ('A0001', 'P999', 'C01');


-- STEP 4: No-show rate by clinic (Task 2.2)

SELECT
    c.clinic_name,
    c.city,
    COUNT(*) AS appointments,
    SUM(a.no_show) AS no_shows,
    ROUND(100.0 * SUM(a.no_show) / COUNT(*), 1) AS no_show_pct
FROM appointments AS a
JOIN clinics AS c
    ON c.clinic_id = a.clinic_id
GROUP BY
    c.clinic_id,
    c.clinic_name,
    c.city
HAVING COUNT(*) >= 95
ORDER BY no_show_pct DESC;


-- STEP 5: Appointment lead-time analysis (Task 2.3)

SELECT
    CASE
        WHEN lead_days BETWEEN 1 AND 7 THEN '1-7'
        WHEN lead_days BETWEEN 8 AND 14 THEN '8-14'
        WHEN lead_days BETWEEN 15 AND 30 THEN '15-30'
        ELSE '31+'
    END AS lead_band,
    COUNT(*) AS appointments,
    SUM(no_show) AS no_shows,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 1) AS no_show_pct
FROM appointments
GROUP BY lead_band
ORDER BY MIN(lead_days);


-- STEP 6: Monthly no-show trend (Task 2.4)

WITH monthly AS (
    SELECT
        DATE_FORMAT(appt_date, '%Y-%m') AS month,
        COUNT(*) AS appointments,
        SUM(no_show) AS no_shows,
        ROUND(
            100.0 * SUM(no_show) / COUNT(*), 1
        ) AS no_show_pct
    FROM appointments
    GROUP BY DATE_FORMAT(appt_date, '%Y-%m')
),

with_previous AS (
    SELECT
        month,
        appointments,
        no_shows,
        no_show_pct,
        LAG(no_show_pct) OVER (
            ORDER BY month
        ) AS previous_rate
    FROM monthly
)

SELECT
    month,
    appointments,
    no_shows,
    no_show_pct,
    ROUND(
        no_show_pct - previous_rate, 1
    ) AS change_percentage_points
FROM with_previous
ORDER BY month;


-- STEP 7: Rank clinics within their cities (Task 2.5)

WITH clinic_rates AS (
    SELECT
        c.clinic_id,
        c.clinic_name,
        c.city,
        ROUND(
            100.0 * SUM(a.no_show) / COUNT(*), 1
        ) AS no_show_pct
    FROM appointments AS a
    JOIN clinics AS c
        ON c.clinic_id = a.clinic_id
    GROUP BY
        c.clinic_id,
        c.clinic_name,
        c.city
),

ranked AS (
    SELECT
        clinic_id,
        clinic_name,
        city,
        no_show_pct,
        RANK() OVER (
            PARTITION BY city
            ORDER BY no_show_pct DESC
        ) AS rank_in_city
    FROM clinic_rates
),

overall_rate AS (
    SELECT
        100.0 * AVG(no_show) AS overall_no_show_pct
    FROM appointments
)

SELECT
    r.clinic_name,
    r.city,
    r.no_show_pct,
    r.rank_in_city,
    CASE
        WHEN r.no_show_pct > o.overall_no_show_pct
            THEN 'above'
        WHEN r.no_show_pct < o.overall_no_show_pct
            THEN 'below'
        ELSE 'equal'
    END AS vs_overall
FROM ranked AS r
CROSS JOIN overall_rate AS o
ORDER BY
    r.city,
    r.rank_in_city;


-- STEP 8: Inspect all eight clinics (additional check)

SELECT
    c.clinic_name,
    c.city,
    COUNT(*) AS appointments,
    SUM(a.no_show) AS no_shows,
    ROUND(
        100.0 * SUM(a.no_show) / COUNT(*), 1
    ) AS no_show_pct
FROM appointments AS a
JOIN clinics AS c
    ON c.clinic_id = a.clinic_id
GROUP BY
    c.clinic_id,
    c.clinic_name,
    c.city
ORDER BY no_show_pct DESC;

-- END OF PART 2 SQL ANALYSIS
