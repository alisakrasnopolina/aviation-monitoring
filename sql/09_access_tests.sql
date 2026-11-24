-- ПР № 11. Проверка эффективных разрешений, выполнить под владельцем базы.
-- Реальные подключения трёх ролей дополнительно проверяет tests/check_access.py.
DO $$
DECLARE
    proc TEXT := 'public.sp_change_flight_status(bigint, character varying, timestamp without time zone)';
BEGIN
    IF to_regprocedure('public.sp_change_flight_status(bigint, character varying, bigint, timestamp without time zone)') IS NOT NULL
       OR NOT has_function_privilege('test_operator', proc, 'EXECUTE')
       OR has_function_privilege('test_analyst', proc, 'EXECUTE')
       OR has_function_privilege('test_admin', proc, 'EXECUTE')
       OR NOT has_column_privilege('test_operator', 'public.flight_instance', 'flight_id', 'INSERT')
       OR has_column_privilege('test_operator', 'public.flight_instance', 'flight_id', 'UPDATE')
       OR has_column_privilege('test_operator', 'public.flight_instance', 'status_id', 'UPDATE')
       OR NOT has_column_privilege('test_operator', 'public.flight_instance', 'scheduled_departure', 'UPDATE')
       OR has_column_privilege('test_operator', 'public.app_user', 'db_login', 'UPDATE')
       OR has_column_privilege('test_admin', 'public.app_user', 'db_login', 'UPDATE')
       OR has_table_privilege('test_admin', 'public.status_history', 'INSERT, UPDATE, DELETE')
       OR has_table_privilege('test_analyst', 'public.flight_instance', 'INSERT, UPDATE, DELETE')
       OR NOT has_table_privilege('test_admin', 'public.delay_reason', 'INSERT')
       OR NOT has_table_privilege('test_admin', 'public.app_user', 'SELECT')
       OR NOT has_table_privilege('test_analyst', 'public.flight_instance', 'SELECT')
       OR NOT has_table_privilege('test_operator', 'public.flight_instance', 'SELECT') THEN
        RAISE EXCEPTION 'Эффективные разрешения отличаются от матрицы прав';
    END IF;
END;
$$;

SELECT 'PASS: матрица прав и сигнатура процедуры' AS result;
