BEGIN;
SET LOCAL search_path = public, pg_temp;
-- ============================================================
-- Практическая работа № 8
-- Файл: 04_functions.sql
-- Пользовательские функции
-- СУБД: PostgreSQL
-- ============================================================

CREATE OR REPLACE FUNCTION fn_calculate_delay_minutes(
    p_flight_instance_id BIGINT
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_scheduled_departure TIMESTAMP;
    v_actual_departure    TIMESTAMP;
    v_delay_minutes       INTEGER;
BEGIN
    SELECT scheduled_departure, actual_departure
    INTO v_scheduled_departure, v_actual_departure
    FROM flight_instance
    WHERE flight_instance_id = p_flight_instance_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION
            'Выполнение рейса с id=% не найдено',
            p_flight_instance_id;
    END IF;

    IF v_actual_departure IS NULL THEN
        RETURN NULL;
    END IF;

    v_delay_minutes :=
        FLOOR(
            EXTRACT(
                EPOCH FROM (
                    v_actual_departure - v_scheduled_departure
                )
            ) / 60
        )::INTEGER;

    RETURN GREATEST(v_delay_minutes, 0);
END;
$$;


CREATE OR REPLACE FUNCTION fn_airline_delay_stats(
    p_date_from TIMESTAMP,
    p_date_to   TIMESTAMP
)
RETURNS TABLE (
    airline_code          VARCHAR(3),
    airline_name          VARCHAR(150),
    total_flights         BIGINT,
    delayed_flights       BIGINT,
    delayed_share_percent NUMERIC(7,2),
    average_delay_minutes NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_date_from IS NULL OR p_date_to IS NULL THEN
        RAISE EXCEPTION
            'Начало и конец периода должны быть заданы';
    END IF;

    IF p_date_from >= p_date_to THEN
        RAISE EXCEPTION
            'Начало периода (%) должно быть раньше конца периода (%)',
            p_date_from,
            p_date_to;
    END IF;

    RETURN QUERY
    SELECT
        a.airline_code,
        a.airline_name,
        COUNT(*)::BIGINT,
        COUNT(*) FILTER (
            WHERE
                fi.actual_departure IS NOT NULL
                AND fi.actual_departure > fi.scheduled_departure
        )::BIGINT,
        ROUND(
            (
                COUNT(*) FILTER (
                    WHERE
                        fi.actual_departure IS NOT NULL
                        AND fi.actual_departure > fi.scheduled_departure
                )
            )::NUMERIC
            / NULLIF(COUNT(*), 0)
            * 100,
            2
        )::NUMERIC(7,2),
        ROUND(
            AVG(
                CASE
                    WHEN
                        fi.actual_departure IS NOT NULL
                        AND fi.actual_departure > fi.scheduled_departure
                    THEN
                        EXTRACT(
                            EPOCH FROM (
                                fi.actual_departure - fi.scheduled_departure
                            )
                        ) / 60
                END
            )::NUMERIC,
            2
        )::NUMERIC(10,2)
    FROM flight_instance fi
    JOIN flight f
        ON f.flight_id = fi.flight_id
    JOIN airline a
        ON a.airline_id = f.airline_id
    JOIN flight_status fs
        ON fs.status_id = fi.status_id
    WHERE
        fi.scheduled_departure >= p_date_from
        AND fi.scheduled_departure < p_date_to
        AND fs.status_name = 'Выполнен'
        AND fi.actual_departure IS NOT NULL
    GROUP BY
        a.airline_id,
        a.airline_code,
        a.airline_name
    ORDER BY
        5 DESC,
        6 DESC NULLS LAST,
        1;
END;
$$;

COMMIT;
