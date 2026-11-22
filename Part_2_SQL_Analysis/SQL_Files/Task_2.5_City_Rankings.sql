
USE noshowguard;

-- Task 2.5: Rank clinics within their cities

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
