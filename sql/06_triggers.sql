BEGIN;
SET LOCAL search_path = public, pg_temp;
DROP TRIGGER IF EXISTS trg_validate_flight_status_transition
ON flight_instance;

DROP FUNCTION IF EXISTS trg_validate_flight_status_transition_fn();

CREATE FUNCTION trg_validate_flight_status_transition_fn()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_status_name VARCHAR(50);
    v_new_status_name VARCHAR(50);
BEGIN
    IF NEW.status_id IS NOT DISTINCT FROM OLD.status_id THEN
        RETURN NEW;
    END IF;

    SELECT status_name
    INTO v_old_status_name
    FROM flight_status
    WHERE status_id = OLD.status_id;

    SELECT status_name
    INTO v_new_status_name
    FROM flight_status
    WHERE status_id = NEW.status_id;

    IF v_old_status_name IS NULL OR v_new_status_name IS NULL THEN
        RAISE EXCEPTION
            'Не удалось определить старый или новый статус';
    END IF;

    IF NOT (
        (v_old_status_name = 'Запланирован'
         AND v_new_status_name IN ('Вылетел', 'Отменён'))
        OR
        (v_old_status_name = 'Вылетел'
         AND v_new_status_name = 'Выполнен')
    ) THEN
        RAISE EXCEPTION
            'Недопустимый переход состояния: "%" -> "%"',
            v_old_status_name,
            v_new_status_name;
    END IF;

    IF
        v_new_status_name = 'Вылетел'
        AND NEW.actual_departure IS NULL
    THEN
        RAISE EXCEPTION
            'Для перехода в статус "Вылетел" необходимо фактическое время вылета';
    END IF;

    IF
        v_new_status_name = 'Выполнен'
        AND NEW.actual_arrival IS NULL
    THEN
        RAISE EXCEPTION
            'Для перехода в статус "Выполнен" необходимо фактическое время прилёта';
    END IF;

    IF
        v_new_status_name = 'Отменён'
        AND (
            NEW.actual_departure IS NOT NULL
            OR NEW.actual_arrival IS NOT NULL
        )
    THEN
        RAISE EXCEPTION
            'Отменённый до вылета рейс не должен иметь фактического времени вылета или прилёта';
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.trg_validate_flight_instance_insert_fn()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM public.flight_status
        WHERE status_id = NEW.status_id
          AND status_name = 'Запланирован'
    ) THEN
        RAISE EXCEPTION
            'Новое выполнение должно иметь статус «Запланирован»';
    END IF;

    IF NEW.actual_departure IS NOT NULL
       OR NEW.actual_arrival IS NOT NULL THEN
        RAISE EXCEPTION
            'При регистрации фактическое время вылета и прилёта должно отсутствовать';
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_validate_flight_instance_insert ON public.flight_instance;
CREATE TRIGGER trg_validate_flight_instance_insert
BEFORE INSERT ON public.flight_instance
FOR EACH ROW
EXECUTE FUNCTION public.trg_validate_flight_instance_insert_fn();

CREATE TRIGGER trg_validate_flight_status_transition
BEFORE UPDATE OF status_id
ON flight_instance
FOR EACH ROW
WHEN (OLD.status_id IS DISTINCT FROM NEW.status_id)
EXECUTE FUNCTION trg_validate_flight_status_transition_fn();


CREATE OR REPLACE FUNCTION public.trg_write_status_history_fn()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
DECLARE
    v_user_id BIGINT;
    v_previous_status_id BIGINT;
BEGIN
    SELECT user_id
    INTO v_user_id
    FROM public.app_user u
    JOIN public.app_role ar USING (role_id)
    WHERE u.db_login = SESSION_USER
      AND u.is_active AND ar.role_name = 'Оператор'
      AND pg_has_role(SESSION_USER, 'app_operator', 'USAGE');

    IF NOT FOUND THEN
        RAISE EXCEPTION
            'Для логина PostgreSQL "%" не найден активный пользователь приложения',
            SESSION_USER;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        v_previous_status_id := OLD.status_id;
    END IF;

    INSERT INTO public.status_history (
        flight_instance_id,
        previous_status_id,
        new_status_id,
        changed_by_user_id,
        changed_at
    )
    VALUES (
        NEW.flight_instance_id,
        v_previous_status_id,
        NEW.status_id,
        v_user_id,
        CURRENT_TIMESTAMP
    );

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_write_status_history
ON public.flight_instance;

DROP TRIGGER IF EXISTS trg_write_initial_status_history ON public.flight_instance;
CREATE TRIGGER trg_write_initial_status_history
AFTER INSERT ON public.flight_instance
FOR EACH ROW
EXECUTE FUNCTION public.trg_write_status_history_fn();

CREATE TRIGGER trg_write_status_history
AFTER UPDATE OF status_id ON public.flight_instance
FOR EACH ROW
WHEN (OLD.status_id IS DISTINCT FROM NEW.status_id)
EXECUTE FUNCTION public.trg_write_status_history_fn();


DROP TRIGGER IF EXISTS trg_sync_delay
ON flight_instance;

DROP FUNCTION IF EXISTS trg_sync_delay_fn();

CREATE FUNCTION trg_sync_delay_fn()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
BEGIN
    IF
        NEW.actual_departure IS NOT NULL
        AND NEW.actual_departure > NEW.scheduled_departure
    THEN
        INSERT INTO delay (
            flight_instance_id,
            reason_id
        )
        VALUES (
            NEW.flight_instance_id,
            NULL
        )
        ON CONFLICT (flight_instance_id)
        DO NOTHING;
    ELSE
        DELETE FROM delay
        WHERE flight_instance_id = NEW.flight_instance_id;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_sync_delay
AFTER INSERT OR UPDATE OF actual_departure, scheduled_departure
ON flight_instance
FOR EACH ROW
EXECUTE FUNCTION trg_sync_delay_fn();



COMMIT;
