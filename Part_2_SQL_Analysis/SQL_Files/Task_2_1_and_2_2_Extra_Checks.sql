USE noshowguard;

-- Task 2.1: duplicate-key test.
-- Run this statement ALONE after the 990 appointment rows are loaded.
-- Expected: ERROR 1062 (23000): Duplicate entry 'A0001' for key 'appointments.PRIMARY'
INSERT INTO appointments (appointment_id, patient_id, clinic_id)
VALUES ('A0001', 'P999', 'C01');

-- Task 2.2: inspect ALL eight clinics.
-- This is the same clinic aggregation without the HAVING filter.
SELECT
    c.clinic_name,
    c.city,
    COUNT(*) AS appointments,
    SUM(a.no_show) AS no_shows,
    ROUND(100.0 * SUM(a.no_show) / COUNT(*), 1) AS no_show_pct
FROM appointments AS a
JOIN clinics AS c
    ON c.clinic_id = a.clinic_id
GROUP BY c.clinic_id, c.clinic_name, c.city
ORDER BY no_show_pct DESC;
