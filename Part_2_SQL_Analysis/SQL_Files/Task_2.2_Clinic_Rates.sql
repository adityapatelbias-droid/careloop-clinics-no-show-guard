
USE noshowguard;

-- Task 2.2: No-show rate by clinic

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

HAVING COUNT(*) >= 95

ORDER BY no_show_pct DESC;
