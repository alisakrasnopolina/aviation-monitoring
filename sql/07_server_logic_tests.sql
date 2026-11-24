-- ПР № 11. Выполнить под локальным postgres (SET SESSION AUTHORIZATION).
-- Сценарии изменяют строки только внутри транзакции. ROLLBACK в конце.
BEGIN;
SET LOCAL search_path = public, pg_temp;

DO $$
BEGIN
    BEGIN
        INSERT INTO airport(airport_code, airport_name, city)
        SELECT airport_code, airport_name, city FROM airport ORDER BY airport_id LIMIT 1;
        RAISE EXCEPTION 'TC-01: дубликат принят';
    EXCEPTION WHEN unique_violation THEN
        IF SQLERRM NOT LIKE '%uq_airport_code%' THEN RAISE; END IF;
    END;
    BEGIN
        INSERT INTO airport(airport_code, airport_name, city) VALUES ('12', 'Тест', 'Тест');
        RAISE EXCEPTION 'TC-02: неверный код принят';
    EXCEPTION WHEN check_violation THEN
        IF SQLERRM NOT LIKE '%chk_airport_code%' THEN RAISE; END IF;
    END;
    BEGIN
        INSERT INTO flight(flight_number, airline_id, departure_airport_id, arrival_airport_id)
        VALUES ('TC03', -1, (SELECT min(airport_id) FROM airport),
                (SELECT max(airport_id) FROM airport));
        RAISE EXCEPTION 'TC-03: неверная ссылка принята';
    EXCEPTION WHEN foreign_key_violation THEN
        IF SQLERRM NOT LIKE '%fk_flight_airline%' THEN RAISE; END IF;
    END;
    BEGIN
        INSERT INTO flight(flight_number, airline_id, departure_airport_id, arrival_airport_id)
        VALUES ('TC04', (SELECT min(airline_id) FROM airline), (SELECT min(airport_id) FROM airport),
                (SELECT min(airport_id) FROM airport));
        RAISE EXCEPTION 'TC-04: одинаковые аэропорты приняты';
    EXCEPTION WHEN check_violation THEN
        IF SQLERRM NOT LIKE '%chk_flight_different_airports%' THEN RAISE; END IF;
    END;
    IF fn_calculate_delay_minutes(16) IS DISTINCT FROM 198
       OR fn_calculate_delay_minutes(81) IS NOT NULL THEN
        RAISE EXCEPTION 'TC-05/06: неверный результат расчёта задержки';
    END IF;
    BEGIN
        PERFORM * FROM fn_airline_delay_stats(TIMESTAMP '2025-02-01', TIMESTAMP '2025-01-01');
        RAISE EXCEPTION 'TC-07: неверный период принят';
    EXCEPTION WHEN raise_exception THEN
        IF SQLERRM NOT LIKE 'Начало периода (%) должно быть раньше%' THEN RAISE; END IF;
    END;
    BEGIN
        CALL sp_change_flight_status(81, 'Вылетел', TIMESTAMP '2026-10-15 10:25');
        RAISE EXCEPTION 'TC-12: операция без активной привязки принята';
    EXCEPTION WHEN raise_exception THEN
        IF SQLERRM NOT LIKE 'Для логина PostgreSQL "%" не найден активный пользователь%' THEN RAISE; END IF;
    END;
END;
$$;

DO $$
DECLARE
    instance BIGINT;
    delta INTERVAL;
BEGIN
    SELECT flight_instance_id INTO STRICT instance FROM flight_instance
    WHERE actual_arrival IS NOT NULL ORDER BY flight_instance_id LIMIT 1;

    FOREACH delta IN ARRAY ARRAY[INTERVAL '0 minutes', INTERVAL '-1 minute'] LOOP
        BEGIN
            UPDATE flight_instance SET scheduled_arrival = scheduled_departure + delta
            WHERE flight_instance_id = instance;
            RAISE EXCEPTION 'TC-13: недопустимое плановое время принято';
        EXCEPTION WHEN check_violation THEN
            IF SQLERRM NOT LIKE '%chk_scheduled_arrival_after_departure%' THEN RAISE; END IF;
        END;

        BEGIN
            UPDATE flight_instance SET actual_arrival = actual_departure + delta
            WHERE flight_instance_id = instance;
            RAISE EXCEPTION 'TC-14: недопустимое фактическое время принято';
        EXCEPTION WHEN check_violation THEN
            IF SQLERRM NOT LIKE '%chk_actual_arrival_after_departure%' THEN RAISE; END IF;
        END;
    END LOOP;

    BEGIN
        INSERT INTO flight_instance(flight_id, status_id, scheduled_departure,
                                    scheduled_arrival, actual_departure)
        VALUES ((SELECT MIN(flight_id) FROM flight),
                (SELECT status_id FROM flight_status WHERE status_name = 'Запланирован'),
                TIMESTAMP '2090-10-15 10:00', TIMESTAMP '2090-10-15 12:00',
                TIMESTAMP '2090-10-15 10:30');
        RAISE EXCEPTION 'TC-17: принято фактическое время при регистрации';
    EXCEPTION WHEN raise_exception THEN
        IF SQLERRM NOT LIKE 'При регистрации фактическое время%' THEN RAISE; END IF;
    END;
END;
$$;

SET SESSION AUTHORIZATION test_operator;

DO $$
DECLARE
    v_flight BIGINT;
    planned BIGINT;
    completed BIGINT;
    instance BIGINT;
    departure TIMESTAMP := TIMESTAMP '2090-10-15 10:00';
    actual TIMESTAMP := departure + INTERVAL '30 minutes';
    delta INTERVAL;
BEGIN
    SELECT MIN(flight_id) INTO v_flight FROM public.flight;
    SELECT status_id INTO STRICT planned FROM flight_status WHERE status_name = 'Запланирован';
    SELECT status_id INTO STRICT completed FROM flight_status WHERE status_name = 'Выполнен';

    BEGIN
        INSERT INTO flight_instance(flight_id, status_id, scheduled_departure, scheduled_arrival)
        VALUES (v_flight, completed, departure, departure + INTERVAL '2 hours');
        RAISE EXCEPTION 'TC-17: принято неверное начальное состояние';
    EXCEPTION WHEN raise_exception THEN
        IF SQLERRM NOT LIKE 'Новое выполнение должно иметь статус%' THEN RAISE; END IF;
    END;

    INSERT INTO flight_instance(flight_id, status_id, scheduled_departure, scheduled_arrival)
    VALUES (v_flight, planned, departure, departure + INTERVAL '2 hours')
    RETURNING flight_instance_id INTO instance;
    PERFORM set_config('coursework.test_instance', instance::TEXT, TRUE);

    BEGIN
        CALL sp_change_flight_status(instance, 'Выполнен', departure + INTERVAL '2 hours');
        RAISE EXCEPTION 'TC-11: выполнение завершено до вылета';
    EXCEPTION WHEN raise_exception THEN
        IF SQLERRM NOT LIKE '%фактическое время вылета не зафиксировано%' THEN RAISE; END IF;
    END;

    CALL sp_change_flight_status(instance, 'Вылетел', actual);
    IF fn_calculate_delay_minutes(instance) IS DISTINCT FROM 30
       OR NOT EXISTS (SELECT 1 FROM delay WHERE flight_instance_id = instance) THEN
        RAISE EXCEPTION 'TC-08/09: неверный результат регистрации вылета';
    END IF;

    FOREACH delta IN ARRAY ARRAY[INTERVAL '0 minutes', INTERVAL '-1 minute'] LOOP
        BEGIN
            CALL sp_change_flight_status(instance, 'Выполнен', actual + delta);
            RAISE EXCEPTION 'TC-15: недопустимое время принято';
        EXCEPTION WHEN raise_exception THEN
            IF SQLERRM NOT LIKE 'Фактическое время прилёта (%) должно быть позже%' THEN RAISE; END IF;
        END;
    END LOOP;

    CALL sp_change_flight_status(instance, 'Выполнен', actual + INTERVAL '2 hours');
END;
$$;

RESET SESSION AUTHORIZATION;

DO $$
DECLARE
    instance BIGINT := current_setting('coursework.test_instance')::BIGINT;
    author BIGINT;
BEGIN
    SELECT user_id INTO STRICT author FROM app_user WHERE db_login = 'test_operator';
    IF (SELECT count(*) FROM status_history WHERE flight_instance_id = instance) <> 3
       OR (SELECT count(*) FROM status_history WHERE flight_instance_id = instance
                                            AND changed_by_user_id = author) <> 3
       OR NOT EXISTS (
           SELECT 1 FROM status_history h JOIN flight_status s ON s.status_id = h.new_status_id
           WHERE h.flight_instance_id = instance AND h.previous_status_id IS NULL
             AND s.status_name = 'Запланирован'
       )
       OR NOT EXISTS (
           SELECT 1 FROM flight_instance fi JOIN flight_status s USING (status_id)
           WHERE fi.flight_instance_id = instance AND s.status_name = 'Выполнен'
             AND fi.actual_arrival > fi.actual_departure
       ) THEN
        RAISE EXCEPTION 'TC-10/16/18: данные выполнения или история неверны';
    END IF;
END;
$$;

SELECT 'PASS: TC-01–TC-18' AS result;
ROLLBACK;
