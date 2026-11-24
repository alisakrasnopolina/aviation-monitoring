BEGIN;
-- ============================================================
-- Практическая работа № 8
-- Файл: 05_procedures.sql
-- Хранимые процедуры
-- СУБД: PostgreSQL
-- ============================================================

CREATE OR REPLACE PROCEDURE public.sp_change_flight_status(
    p_flight_instance_id BIGINT,
    p_new_status_name     VARCHAR,
    p_event_time          TIMESTAMP DEFAULT NULL
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
    v_new_status_id       BIGINT;
    v_current_status_name VARCHAR(50);
    v_actual_departure    TIMESTAMP;
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM public.app_user AS u
        JOIN public.app_role AS r ON r.role_id = u.role_id
        WHERE u.db_login = SESSION_USER
          AND u.is_active
          AND r.role_name = 'Оператор'
          AND pg_has_role(SESSION_USER, 'app_operator', 'USAGE')
    ) THEN
        RAISE EXCEPTION
            'Для логина PostgreSQL "%" не найден активный пользователь приложения',
            SESSION_USER;
    END IF;

    SELECT
        fs.status_name,
        fi.actual_departure
    INTO
        v_current_status_name,
        v_actual_departure
    FROM flight_instance fi
    JOIN flight_status fs
        ON fs.status_id = fi.status_id
    WHERE fi.flight_instance_id = p_flight_instance_id
    FOR UPDATE OF fi;

    IF NOT FOUND THEN
        RAISE EXCEPTION
            'Выполнение рейса с id=% не найдено',
            p_flight_instance_id;
    END IF;

    SELECT status_id
    INTO v_new_status_id
    FROM flight_status
    WHERE status_name = p_new_status_name;

    IF NOT FOUND THEN
        RAISE EXCEPTION
            'Статус "%" не найден',
            p_new_status_name;
    END IF;

    IF v_current_status_name = p_new_status_name THEN
        RAISE EXCEPTION
            'Выполнение рейса id=% уже имеет статус "%"',
            p_flight_instance_id,
            p_new_status_name;
    END IF;

    IF p_new_status_name = 'Вылетел' THEN
        IF p_event_time IS NULL THEN
            RAISE EXCEPTION
                'Для статуса "Вылетел" необходимо указать фактическое время вылета';
        END IF;

        UPDATE flight_instance
        SET
            actual_departure = p_event_time,
            status_id = v_new_status_id
        WHERE flight_instance_id = p_flight_instance_id;

    ELSIF p_new_status_name = 'Выполнен' THEN
        IF p_event_time IS NULL THEN
            RAISE EXCEPTION
                'Для статуса "Выполнен" необходимо указать фактическое время прилёта';
        END IF;

        IF v_actual_departure IS NULL THEN
            RAISE EXCEPTION
                'Нельзя завершить рейс id=%: фактическое время вылета не зафиксировано',
                p_flight_instance_id;
        END IF;

        IF p_event_time <= v_actual_departure THEN
            RAISE EXCEPTION
                'Фактическое время прилёта (%) должно быть позже фактического времени вылета (%)',
                p_event_time,
                v_actual_departure;
        END IF;

        UPDATE flight_instance
        SET
            actual_arrival = p_event_time,
            status_id = v_new_status_id
        WHERE flight_instance_id = p_flight_instance_id;

    ELSIF p_new_status_name = 'Отменён' THEN
        UPDATE flight_instance
        SET status_id = v_new_status_id
        WHERE flight_instance_id = p_flight_instance_id;

    ELSE
        RAISE EXCEPTION
            'Переход в статус "%" не поддерживается данной бизнес-операцией',
            p_new_status_name;
    END IF;
END;
$$;

REVOKE EXECUTE ON PROCEDURE public.sp_change_flight_status(BIGINT, VARCHAR, TIMESTAMP) FROM PUBLIC;
DROP PROCEDURE IF EXISTS public.sp_change_flight_status(BIGINT, VARCHAR, BIGINT, TIMESTAMP);
COMMIT;
