-- Пояснительная записка, раздел 4.5.
-- Выполнить под владельцем БД или аналитиком.
-- Период относится к плановому времени вылета, правая граница исключается.
WITH sample AS (
    SELECT EXTRACT(EPOCH FROM (fi.actual_departure - fi.scheduled_departure)) / 60 AS minutes
    FROM public.flight_instance AS fi
    JOIN public.flight_status AS fs USING (status_id)
    WHERE fi.scheduled_departure >= TIMESTAMP '2025-01-01'
      AND fi.scheduled_departure < TIMESTAMP '2025-02-01'
      AND fs.status_name = 'Выполнен'
      AND fi.actual_departure IS NOT NULL
)
SELECT
    threshold.label AS delay_definition,
    COUNT(sample.minutes) AS completed,
    COUNT(*) FILTER (
        WHERE sample.minutes > 0 AND sample.minutes >= threshold.min_minutes
    ) AS delayed,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE sample.minutes > 0 AND sample.minutes >= threshold.min_minutes
        ) / NULLIF(COUNT(sample.minutes), 0),
        2
    ) AS share_percent
FROM (VALUES (0, '> 0 минут'), (15, '≥ 15 минут'),
             (30, '≥ 30 минут'), (60, '≥ 60 минут')) AS threshold(min_minutes, label)
LEFT JOIN sample ON TRUE
GROUP BY threshold.min_minutes, threshold.label
ORDER BY threshold.min_minutes;
