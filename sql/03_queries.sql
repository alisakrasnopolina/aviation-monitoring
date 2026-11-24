-- ============================================================
-- Практическая работа № 7
-- Файл: 03_queries.sql
-- Тема: Информационная система учета, мониторинга и анализа
--       авиарейсов и задержек аэропорта
-- СУБД: PostgreSQL
--
-- База должна быть предварительно создана и наполнена:
-- 01_create_tables.sql -> 02_insert_data.sql -> 03_queries.sql
-- ============================================================


-- ============================================================
-- Диагностическая проверка (не входит в 12 прикладных запросов)
-- ============================================================

SELECT current_database() AS current_database;

SELECT
    'app_role' AS table_name, COUNT(*) AS row_count FROM app_role
UNION ALL SELECT 'app_user', COUNT(*) FROM app_user
UNION ALL SELECT 'airport', COUNT(*) FROM airport
UNION ALL SELECT 'airline', COUNT(*) FROM airline
UNION ALL SELECT 'flight', COUNT(*) FROM flight
UNION ALL SELECT 'flight_status', COUNT(*) FROM flight_status
UNION ALL SELECT 'flight_instance', COUNT(*) FROM flight_instance
UNION ALL SELECT 'delay_reason', COUNT(*) FROM delay_reason
UNION ALL SELECT 'delay', COUNT(*) FROM delay
UNION ALL SELECT 'status_history', COUNT(*) FROM status_history
ORDER BY table_name;


-- ============================================================
-- ЗАПРОС 1
-- Получить список выполнений рейсов из JFK за январь 2025 года
-- в хронологическом порядке.
-- Используются: JOIN, WHERE, ORDER BY.
-- ============================================================

SELECT
    fi.flight_instance_id,
    a.airline_code,
    a.airline_name,
    f.flight_number,
    dep.airport_code AS origin,
    arr.airport_code AS destination,
    fi.scheduled_departure,
    fi.actual_departure,
    fs.status_name
FROM flight_instance fi
JOIN flight f
    ON f.flight_id = fi.flight_id
JOIN airline a
    ON a.airline_id = f.airline_id
JOIN airport dep
    ON dep.airport_id = f.departure_airport_id
JOIN airport arr
    ON arr.airport_id = f.arrival_airport_id
JOIN flight_status fs
    ON fs.status_id = fi.status_id
WHERE
    dep.airport_code = 'JFK'
    AND fi.scheduled_departure >= TIMESTAMP '2025-01-01 00:00:00'
    AND fi.scheduled_departure <  TIMESTAMP '2025-02-01 00:00:00'
ORDER BY fi.scheduled_departure;


-- ============================================================
-- ЗАПРОС 2
-- Получить все рейсы с задержкой вылета и вычислить
-- продолжительность задержки в минутах.
-- Используются: JOIN, WHERE, вычисляемое выражение, ORDER BY.
-- ============================================================

SELECT
    fi.flight_instance_id,
    a.airline_code,
    f.flight_number,
    arr.airport_code AS destination,
    fi.scheduled_departure,
    fi.actual_departure,
    ROUND(
        EXTRACT(
            EPOCH FROM (
                fi.actual_departure - fi.scheduled_departure
            )
        ) / 60
    ) AS delay_minutes
FROM flight_instance fi
JOIN flight f
    ON f.flight_id = fi.flight_id
JOIN airline a
    ON a.airline_id = f.airline_id
JOIN airport arr
    ON arr.airport_id = f.arrival_airport_id
WHERE
    fi.actual_departure IS NOT NULL
    AND fi.actual_departure > fi.scheduled_departure
ORDER BY delay_minutes DESC, fi.scheduled_departure;


-- ============================================================
-- ЗАПРОС 3
-- Получить отмененные рейсы с указанием авиакомпании,
-- направления и планового времени вылета.
-- Используются: несколько JOIN, WHERE, ORDER BY.
-- ============================================================

SELECT
    fi.flight_instance_id,
    a.airline_code,
    a.airline_name,
    f.flight_number,
    dep.airport_code AS origin,
    arr.airport_code AS destination,
    fi.scheduled_departure,
    fs.status_name
FROM flight_instance fi
JOIN flight f
    ON f.flight_id = fi.flight_id
JOIN airline a
    ON a.airline_id = f.airline_id
JOIN airport dep
    ON dep.airport_id = f.departure_airport_id
JOIN airport arr
    ON arr.airport_id = f.arrival_airport_id
JOIN flight_status fs
    ON fs.status_id = fi.status_id
WHERE fs.status_name = 'Отменён'
ORDER BY fi.scheduled_departure;


-- ============================================================
-- ЗАПРОС 4
-- Получить задержанные рейсы и указанную для них основную причину.
-- LEFT JOIN позволяет сохранить рейсы, у которых причина пока NULL.
-- Используются: JOIN не менее трех таблиц, LEFT JOIN, ORDER BY.
-- ============================================================

SELECT
    fi.flight_instance_id,
    a.airline_code,
    f.flight_number,
    arr.airport_code AS destination,
    dr.reason_name,
    ROUND(
        EXTRACT(
            EPOCH FROM (
                fi.actual_departure - fi.scheduled_departure
            )
        ) / 60
    ) AS delay_minutes
FROM delay d
JOIN flight_instance fi
    ON fi.flight_instance_id = d.flight_instance_id
JOIN flight f
    ON f.flight_id = fi.flight_id
JOIN airline a
    ON a.airline_id = f.airline_id
JOIN airport arr
    ON arr.airport_id = f.arrival_airport_id
LEFT JOIN delay_reason dr
    ON dr.reason_id = d.reason_id
ORDER BY delay_minutes DESC, a.airline_code, f.flight_number;


-- ============================================================
-- ЗАПРОС 5
-- Определить количество выполнений рейсов в каждом состоянии.
-- Используются: COUNT, GROUP BY, ORDER BY.
-- ============================================================

SELECT
    fs.status_name,
    COUNT(*) AS flight_count
FROM flight_instance fi
JOIN flight_status fs
    ON fs.status_id = fi.status_id
GROUP BY fs.status_id, fs.status_name
ORDER BY flight_count DESC, fs.status_name;


-- ============================================================
-- ЗАПРОС 6
-- Определить количество исторических рейсов каждой авиакомпании
-- в январе 2025 года.
-- Используются: JOIN, WHERE, COUNT, GROUP BY, ORDER BY.
-- ============================================================

SELECT
    a.airline_code,
    a.airline_name,
    COUNT(*) AS flight_count
FROM flight_instance fi
JOIN flight f
    ON f.flight_id = fi.flight_id
JOIN airline a
    ON a.airline_id = f.airline_id
WHERE
    fi.scheduled_departure >= TIMESTAMP '2025-01-01 00:00:00'
    AND fi.scheduled_departure <  TIMESTAMP '2025-02-01 00:00:00'
GROUP BY
    a.airline_id,
    a.airline_code,
    a.airline_name
ORDER BY flight_count DESC, a.airline_code;


-- ============================================================
-- ЗАПРОС 7
-- Рассчитать среднюю, минимальную и максимальную продолжительность
-- положительной задержки вылета в минутах.
-- Используются: подзапрос, AVG, MIN, MAX.
-- ============================================================

SELECT
    ROUND(AVG(delay_minutes), 2) AS average_delay_minutes,
    ROUND(MIN(delay_minutes), 2) AS minimum_delay_minutes,
    ROUND(MAX(delay_minutes), 2) AS maximum_delay_minutes
FROM (
    SELECT
        EXTRACT(
            EPOCH FROM (
                actual_departure - scheduled_departure
            )
        ) / 60 AS delay_minutes
    FROM flight_instance
    WHERE
        actual_departure IS NOT NULL
        AND actual_departure > scheduled_departure
) delayed_flights;


-- ============================================================
-- ЗАПРОС 8
-- Определить наиболее часто встречающиеся причины задержек.
-- Записи с неуказанной причиной показываются как
-- «Причина не указана».
-- Используются: LEFT JOIN, COALESCE, COUNT, GROUP BY, ORDER BY.
-- ============================================================

SELECT
    COALESCE(
        dr.reason_name,
        'Причина не указана'
    ) AS reason_name,
    COUNT(*) AS delay_count
FROM delay d
LEFT JOIN delay_reason dr
    ON dr.reason_id = d.reason_id
GROUP BY
    COALESCE(
        dr.reason_name,
        'Причина не указана'
    )
ORDER BY delay_count DESC, reason_name;


-- ============================================================
-- ЗАПРОС 9
-- Найти авиакомпании, средняя положительная задержка вылета
-- которых превышает 15 минут.
-- WHERE отбирает отдельные задержанные рейсы до группировки,
-- HAVING отбирает группы после вычисления среднего значения.
-- Используются: WHERE, AVG, GROUP BY, HAVING, ORDER BY.
-- ============================================================

SELECT
    a.airline_code,
    a.airline_name,
    COUNT(*) AS delayed_flights,
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    fi.actual_departure - fi.scheduled_departure
                )
            ) / 60
        ),
        2
    ) AS average_delay_minutes
FROM flight_instance fi
JOIN flight f
    ON f.flight_id = fi.flight_id
JOIN airline a
    ON a.airline_id = f.airline_id
WHERE
    fi.actual_departure IS NOT NULL
    AND fi.actual_departure > fi.scheduled_departure
GROUP BY
    a.airline_id,
    a.airline_code,
    a.airline_name
HAVING
    AVG(
        EXTRACT(
            EPOCH FROM (
                fi.actual_departure - fi.scheduled_departure
            )
        ) / 60
    ) > 15
ORDER BY average_delay_minutes DESC;


-- ============================================================
-- ЗАПРОС 10
-- Найти рейсы, задержка которых превышает среднюю положительную
-- задержку всех рейсов.
-- Используются: JOIN, вложенный запрос, WHERE, ORDER BY.
-- ============================================================

SELECT
    fi.flight_instance_id,
    a.airline_code,
    f.flight_number,
    arr.airport_code AS destination,
    ROUND(
        EXTRACT(
            EPOCH FROM (
                fi.actual_departure - fi.scheduled_departure
            )
        ) / 60
    ) AS delay_minutes
FROM flight_instance fi
JOIN flight f
    ON f.flight_id = fi.flight_id
JOIN airline a
    ON a.airline_id = f.airline_id
JOIN airport arr
    ON arr.airport_id = f.arrival_airport_id
WHERE
    fi.actual_departure IS NOT NULL
    AND fi.actual_departure > fi.scheduled_departure
    AND (
        EXTRACT(
            EPOCH FROM (
                fi.actual_departure - fi.scheduled_departure
            )
        ) / 60
    ) > (
        SELECT
            AVG(
                EXTRACT(
                    EPOCH FROM (
                        fi2.actual_departure - fi2.scheduled_departure
                    )
                ) / 60
            )
        FROM flight_instance fi2
        WHERE
            fi2.actual_departure IS NOT NULL
            AND fi2.actual_departure > fi2.scheduled_departure
    )
ORDER BY delay_minutes DESC;


-- ============================================================
-- ЗАПРОС 11
-- Комплексно сравнить авиакомпании за январь 2025 года:
-- количество рейсов, число задержанных, долю задержанных,
-- число отмененных и среднюю положительную задержку.
-- Это основной аналитический запрос проекта.
-- Используются: CTE, несколько JOIN, FILTER, CASE, AVG,
-- GROUP BY, вычисления, NULLIF, ORDER BY.
-- ============================================================

WITH airline_stats AS (
    SELECT
        a.airline_id,
        a.airline_code,
        a.airline_name,

        COUNT(*) AS total_flights,

        COUNT(*) FILTER (
            WHERE
                fi.actual_departure IS NOT NULL
                AND fi.actual_departure > fi.scheduled_departure
        ) AS delayed_flights,

        COUNT(*) FILTER (
            WHERE fs.status_name = 'Отменён'
        ) AS cancelled_flights,

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
        ) AS avg_positive_delay

    FROM flight_instance fi
    JOIN flight f
        ON f.flight_id = fi.flight_id
    JOIN airline a
        ON a.airline_id = f.airline_id
    JOIN flight_status fs
        ON fs.status_id = fi.status_id

    WHERE
        fi.scheduled_departure >= TIMESTAMP '2025-01-01 00:00:00'
        AND fi.scheduled_departure <  TIMESTAMP '2025-02-01 00:00:00'

    GROUP BY
        a.airline_id,
        a.airline_code,
        a.airline_name
)

SELECT
    airline_code,
    airline_name,
    total_flights,
    delayed_flights,

    ROUND(
        delayed_flights::numeric
        / NULLIF(total_flights, 0)
        * 100,
        2
    ) AS delayed_share_percent,

    cancelled_flights,

    ROUND(
        avg_positive_delay,
        2
    ) AS average_delay_minutes

FROM airline_stats
ORDER BY
    delayed_share_percent DESC,
    average_delay_minutes DESC NULLS LAST,
    airline_code;


-- ============================================================
-- ЗАПРОС 12
-- Получить текущие рейсы, требующие операционного внимания:
-- запланированные и уже вылетевшие.
-- Используются: несколько JOIN, IN, ORDER BY.
-- ============================================================

SELECT
    fi.flight_instance_id,
    a.airline_code,
    f.flight_number,
    dep.airport_code AS origin,
    arr.airport_code AS destination,
    fs.status_name,
    fi.scheduled_departure,
    fi.actual_departure
FROM flight_instance fi
JOIN flight f
    ON f.flight_id = fi.flight_id
JOIN airline a
    ON a.airline_id = f.airline_id
JOIN airport dep
    ON dep.airport_id = f.departure_airport_id
JOIN airport arr
    ON arr.airport_id = f.arrival_airport_id
JOIN flight_status fs
    ON fs.status_id = fi.status_id
WHERE fs.status_name IN (
    'Запланирован',
    'Вылетел'
)
ORDER BY fi.scheduled_departure;


-- ============================================================
-- ДОПОЛНИТЕЛЬНЫЙ ЗАПРОС 13
-- Получить историю изменения статусов для всех выполнений,
-- отображая предыдущий и новый статус, пользователя и время.
-- Полезен для проверки требования о хранении истории состояний.
-- ============================================================

SELECT
    sh.history_id,
    sh.flight_instance_id,
    COALESCE(
        prev.status_name,
        'Начальное состояние'
    ) AS previous_status,
    new_status.status_name AS new_status,
    u.login AS changed_by,
    CONCAT_WS(
        ' ',
        u.last_name,
        u.first_name,
        u.middle_name
    ) AS user_full_name,
    sh.changed_at
FROM status_history sh
LEFT JOIN flight_status prev
    ON prev.status_id = sh.previous_status_id
JOIN flight_status new_status
    ON new_status.status_id = sh.new_status_id
JOIN app_user u
    ON u.user_id = sh.changed_by_user_id
ORDER BY
    sh.flight_instance_id,
    sh.changed_at,
    sh.history_id;
