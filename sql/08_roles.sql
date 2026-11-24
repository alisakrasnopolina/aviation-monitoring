BEGIN;
SET LOCAL search_path = public, pg_temp;
-- ============================================================
-- Практическая работа № 9
-- Файл: 08_roles.sql
-- Пользователи, роли и разграничение доступа
-- СУБД: PostgreSQL
-- База данных: aviation_monitoring
-- Выполнять от имени postgres / владельца БД.
-- ============================================================

-- 1. Прикладные роли
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_operator') THEN
        CREATE ROLE app_operator NOLOGIN;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_analyst') THEN
        CREATE ROLE app_analyst NOLOGIN;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_admin') THEN
        CREATE ROLE app_admin NOLOGIN;
    END IF;
END;
$$;

-- 2. Учебные пользователи. Пароли назначаются отдельно.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'test_operator') THEN
        CREATE ROLE test_operator LOGIN;
    ELSE
        ALTER ROLE test_operator LOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'test_analyst') THEN
        CREATE ROLE test_analyst LOGIN;
    ELSE
        ALTER ROLE test_analyst LOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'test_admin') THEN
        CREATE ROLE test_admin LOGIN;
    ELSE
        ALTER ROLE test_admin LOGIN;
    END IF;
END;
$$;

-- 3. Членство
REVOKE app_analyst, app_admin FROM test_operator;
REVOKE app_operator, app_admin FROM test_analyst;
REVOKE app_operator, app_analyst FROM test_admin;

GRANT app_operator TO test_operator WITH INHERIT TRUE;
GRANT app_analyst TO test_analyst WITH INHERIT TRUE;
GRANT app_admin TO test_admin WITH INHERIT TRUE;

-- 4. Подключение и схема
DO $$
BEGIN
    EXECUTE format('GRANT CONNECT ON DATABASE %I TO app_operator, app_analyst, app_admin', current_database());
END;
$$;

GRANT USAGE ON SCHEMA public
TO app_operator, app_analyst, app_admin;

REVOKE CREATE ON SCHEMA public FROM PUBLIC;

-- 5. Убираем избыточные права PUBLIC
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;

REVOKE ALL ON FUNCTION fn_calculate_delay_minutes(BIGINT) FROM PUBLIC;
REVOKE ALL ON FUNCTION fn_airline_delay_stats(TIMESTAMP, TIMESTAMP) FROM PUBLIC;
REVOKE ALL ON PROCEDURE sp_change_flight_status(BIGINT, VARCHAR, TIMESTAMP) FROM PUBLIC;

-- ============================================================
-- 6. ОПЕРАТОР
-- ============================================================

GRANT SELECT ON
    airport,
    airline,
    flight,
    flight_status,
    flight_instance,
    delay_reason,
    delay
TO app_operator;

-- Регистрация нового выполнения рейса.
GRANT INSERT (
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival
)
ON flight_instance
TO app_operator;

-- Корректировка только плановых сведений.
GRANT UPDATE (
    scheduled_departure,
    scheduled_arrival
)
ON flight_instance
TO app_operator;

-- Указание/исправление причины задержки.
GRANT UPDATE (reason_id)
ON delay
TO app_operator;

-- Последовательность identity для flight_instance.
DO $$
DECLARE
    v_sequence_name TEXT;
BEGIN
    v_sequence_name := pg_get_serial_sequence('flight_instance', 'flight_instance_id');
    IF v_sequence_name IS NOT NULL THEN
        EXECUTE format(
            'GRANT USAGE, SELECT ON SEQUENCE %s TO app_operator',
            v_sequence_name
        );
    END IF;
END;
$$;

GRANT EXECUTE ON FUNCTION fn_calculate_delay_minutes(BIGINT)
TO app_operator;

GRANT EXECUTE ON PROCEDURE sp_change_flight_status(BIGINT, VARCHAR, TIMESTAMP)
TO app_operator;

-- ============================================================
-- 7. АНАЛИТИК
-- ============================================================

GRANT SELECT ON
    airport,
    airline,
    flight,
    flight_status,
    flight_instance,
    delay_reason,
    delay
TO app_analyst;

GRANT EXECUTE ON FUNCTION fn_calculate_delay_minutes(BIGINT)
TO app_analyst;

GRANT EXECUTE ON FUNCTION fn_airline_delay_stats(TIMESTAMP, TIMESTAMP)
TO app_analyst;

-- ============================================================
-- 8. АДМИНИСТРАТОР
-- ============================================================

GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_admin;

GRANT INSERT, UPDATE, DELETE ON
    airport,
    airline,
    flight,
    delay_reason
TO app_admin;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_admin;

GRANT EXECUTE ON FUNCTION fn_calculate_delay_minutes(BIGINT)
TO app_admin;
GRANT EXECUTE ON FUNCTION fn_airline_delay_stats(TIMESTAMP, TIMESTAMP)
TO app_admin;

-- ============================================================
-- 9. Контролируемое изменение статуса через SECURITY DEFINER
-- ============================================================

ALTER PROCEDURE sp_change_flight_status(BIGINT, VARCHAR, TIMESTAMP)
SECURITY DEFINER;
ALTER PROCEDURE sp_change_flight_status(BIGINT, VARCHAR, TIMESTAMP)
SET search_path = pg_catalog, public, pg_temp;

-- Внутренние триггерные функции должны уметь изменять связанные таблицы
-- даже если вызывающий оператор не имеет прямых прав на эти таблицы.
ALTER FUNCTION trg_write_status_history_fn() SECURITY DEFINER;
ALTER FUNCTION trg_write_status_history_fn() SET search_path = pg_catalog, public, pg_temp;
ALTER FUNCTION trg_sync_delay_fn() SECURITY DEFINER;
ALTER FUNCTION trg_sync_delay_fn() SET search_path = pg_catalog, public, pg_temp;

-- ============================================================
-- 10. Демонстрация REVOKE
-- ============================================================

GRANT SELECT ON app_user TO app_analyst;
REVOKE SELECT ON app_user FROM app_analyst;

-- Явный отзыв прав, которых в итоговой модели быть не должно.
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM app_analyst;
REVOKE DELETE ON flight_instance, delay, status_history FROM app_operator;
REVOKE EXECUTE ON PROCEDURE sp_change_flight_status(BIGINT, VARCHAR, TIMESTAMP)
FROM app_analyst, app_admin;

-- Пользователи приложения и назначение прикладных ролей.
REVOKE INSERT, UPDATE ON app_user FROM app_admin;
REVOKE INSERT, UPDATE, DELETE ON flight_status, app_role FROM app_admin;
GRANT INSERT (login, last_name, first_name, middle_name, is_active, role_id),
      UPDATE (login, last_name, first_name, middle_name, is_active, role_id)
ON app_user TO app_admin;
GRANT DELETE ON app_user TO app_admin;
REVOKE UPDATE (flight_id) ON flight_instance FROM app_operator;

CREATE OR REPLACE FUNCTION public.fn_session_role()
RETURNS TEXT
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = pg_catalog, public, pg_temp
AS $$
    SELECT ar.role_name::TEXT
    FROM public.app_user u
    JOIN public.app_role ar USING (role_id)
    WHERE u.db_login = SESSION_USER AND u.is_active
      AND pg_has_role(SESSION_USER, (CASE ar.role_name
          WHEN 'Оператор' THEN 'app_operator'
          WHEN 'Аналитик' THEN 'app_analyst'
          WHEN 'Администратор' THEN 'app_admin'
      END)::NAME, 'USAGE')
$$;
REVOKE ALL ON FUNCTION public.fn_session_role() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.fn_session_role()
TO app_operator, app_analyst, app_admin;

-- 11. Контроль членства
SELECT
    r.rolname AS role_name,
    m.rolname AS member_name
FROM pg_auth_members am
JOIN pg_roles r ON r.oid = am.roleid
JOIN pg_roles m ON m.oid = am.member
WHERE r.rolname IN ('app_operator', 'app_analyst', 'app_admin')
ORDER BY r.rolname, m.rolname;

COMMIT;
