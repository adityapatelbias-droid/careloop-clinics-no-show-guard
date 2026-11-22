
USE noshowguard;

-- Task 2.4: Monthly no-show trend

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
