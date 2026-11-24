-- ============================================================
-- Практическая работа № 7
-- Наполнение базы данных тестовыми данными
--
-- Источник операционных данных:
-- BTS TranStats
-- Reporting Carrier On-Time Performance
-- JFK, январь 2025
-- ============================================================

BEGIN;

-- Первоначальный импорт исторического набора в пустую схему до установки триггеров.
SET LOCAL search_path = public, pg_temp;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM app_role)
       OR EXISTS (SELECT 1 FROM pg_trigger
                  WHERE tgrelid = 'public.flight_instance'::regclass
                    AND NOT tgisinternal) THEN
        RAISE EXCEPTION 'Импорт требует пустой схемы до установки триггеров';
    END IF;
END;
$$;


INSERT INTO app_role (
    role_id,
    role_name
)
VALUES
    (1, 'Оператор'),
    (2, 'Аналитик'),
    (3, 'Администратор');


INSERT INTO app_user (
    user_id,
    login,
    last_name,
    first_name,
    middle_name,
    is_active,
    role_id
)
VALUES
    (
        1,
        'operator1',
        'Иванов',
        'Иван',
        'Иванович',
        TRUE,
        1
    ),
    (
        2,
        'analyst1',
        'Петрова',
        'Анна',
        'Сергеевна',
        TRUE,
        2
    ),
    (
        3,
        'admin1',
        'Сидоров',
        'Павел',
        'Андреевич',
        TRUE,
        3
    ),
    (
        4,
        'operator2',
        'Смирнова',
        'Елена',
        'Олеговна',
        TRUE,
        1
    );


UPDATE app_user SET db_login = CASE login
    WHEN 'operator1' THEN 'test_operator'
    WHEN 'analyst1' THEN 'test_analyst'
    WHEN 'admin1' THEN 'test_admin'
END
WHERE login IN ('operator1', 'analyst1', 'admin1');

INSERT INTO flight_status (
    status_id,
    status_name
)
VALUES
    (1, 'Запланирован'),
    (2, 'Вылетел'),
    (3, 'Выполнен'),
    (4, 'Отменён');


INSERT INTO delay_reason (
    reason_id,
    reason_name,
    description
)
VALUES
    (
        1,
        'Причина авиакомпании',
        'Задержка по причинам, связанным с авиакомпанией'
    ),
    (
        2,
        'Погодные условия',
        'Задержка, связанная с погодными условиями'
    ),
    (
        3,
        'Национальная авиационная система',
        'Задержка, связанная с работой национальной авиационной системы'
    ),
    (
        4,
        'Безопасность',
        'Задержка по причинам безопасности'
    ),
    (
        5,
        'Позднее прибытие воздушного судна',
        'Задержка вследствие позднего прибытия воздушного судна'
    ),
    (
        6,
        'Прочее',
        'Иные причины задержки'
    );


INSERT INTO airline (
    airline_id,
    airline_code,
    airline_name
)
VALUES (
    1,
    'AA',
    'American Airlines'
);


INSERT INTO airline (
    airline_id,
    airline_code,
    airline_name
)
VALUES (
    2,
    'AS',
    'Alaska Airlines'
);


INSERT INTO airline (
    airline_id,
    airline_code,
    airline_name
)
VALUES (
    3,
    'B6',
    'JetBlue Airways'
);


INSERT INTO airline (
    airline_id,
    airline_code,
    airline_name
)
VALUES (
    4,
    'DL',
    'Delta Air Lines'
);


INSERT INTO airline (
    airline_id,
    airline_code,
    airline_name
)
VALUES (
    5,
    'F9',
    'Frontier Airlines'
);


INSERT INTO airline (
    airline_id,
    airline_code,
    airline_name
)
VALUES (
    6,
    'OO',
    'SkyWest Airlines'
);


INSERT INTO airline (
    airline_id,
    airline_code,
    airline_name
)
VALUES (
    7,
    'YX',
    'Republic Airways'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    1,
    'JFK',
    'JFK Airport',
    'New York, NY'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    2,
    'MIA',
    'MIA Airport',
    'Miami, FL'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    3,
    'MCI',
    'MCI Airport',
    'Kansas City, MO'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    4,
    'MCO',
    'MCO Airport',
    'Orlando, FL'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    5,
    'DFW',
    'DFW Airport',
    'Dallas/Fort Worth, TX'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    6,
    'SJU',
    'SJU Airport',
    'San Juan, PR'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    7,
    'JAX',
    'JAX Airport',
    'Jacksonville, FL'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    8,
    'TPA',
    'TPA Airport',
    'Tampa, FL'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    9,
    'BOS',
    'BOS Airport',
    'Boston, MA'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    10,
    'ROC',
    'ROC Airport',
    'Rochester, NY'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    11,
    'CLT',
    'CLT Airport',
    'Charlotte, NC'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    12,
    'LAX',
    'LAX Airport',
    'Los Angeles, CA'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    13,
    'PBI',
    'PBI Airport',
    'West Palm Beach/Palm Beach, FL'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    14,
    'MKE',
    'MKE Airport',
    'Milwaukee, WI'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    15,
    'ATL',
    'ATL Airport',
    'Atlanta, GA'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    16,
    'PHX',
    'PHX Airport',
    'Phoenix, AZ'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    17,
    'MSP',
    'MSP Airport',
    'Minneapolis, MN'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    18,
    'PDX',
    'PDX Airport',
    'Portland, OR'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    19,
    'ORF',
    'ORF Airport',
    'Norfolk, VA'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    20,
    'DCA',
    'DCA Airport',
    'Washington, DC'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    21,
    'BQN',
    'BQN Airport',
    'Aguadilla, PR'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    22,
    'FLL',
    'FLL Airport',
    'Fort Lauderdale, FL'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    23,
    'RDU',
    'RDU Airport',
    'Raleigh/Durham, NC'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    24,
    'SFO',
    'SFO Airport',
    'San Francisco, CA'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    25,
    'LAS',
    'LAS Airport',
    'Las Vegas, NV'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    26,
    'RSW',
    'RSW Airport',
    'Fort Myers, FL'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    27,
    'SYR',
    'SYR Airport',
    'Syracuse, NY'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    28,
    'DEN',
    'DEN Airport',
    'Denver, CO'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    29,
    'SEA',
    'SEA Airport',
    'Seattle, WA'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    30,
    'STT',
    'STT Airport',
    'Charlotte Amalie, VI'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    31,
    'ORD',
    'ORD Airport',
    'Chicago, IL'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    32,
    'SAV',
    'SAV Airport',
    'Savannah, GA'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    33,
    'AUS',
    'AUS Airport',
    'Austin, TX'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    34,
    'ORH',
    'ORH Airport',
    'Worcester, MA'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    35,
    'SAN',
    'SAN Airport',
    'San Diego, CA'
);


INSERT INTO airport (
    airport_id,
    airport_code,
    airport_name,
    city
)
VALUES (
    36,
    'IND',
    'IND Airport',
    'Indianapolis, IN'
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    1,
    '1428',
    4,
    1,
    2
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    2,
    '4047',
    6,
    1,
    3
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    3,
    '1993',
    3,
    1,
    2
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    4,
    '1740',
    4,
    1,
    4
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    5,
    '1274',
    1,
    1,
    5
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    6,
    '403',
    3,
    1,
    6
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    7,
    '1677',
    3,
    1,
    7
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    8,
    '2093',
    4,
    1,
    8
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    9,
    '5765',
    7,
    1,
    9
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    10,
    '486',
    3,
    1,
    10
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    11,
    '4871',
    5,
    1,
    4
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    12,
    '1012',
    1,
    1,
    11
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    13,
    '2623',
    3,
    1,
    12
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    14,
    '1053',
    3,
    1,
    13
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    15,
    '3723',
    6,
    1,
    14
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    16,
    '2342',
    4,
    1,
    15
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    17,
    '2603',
    1,
    1,
    2
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    18,
    '283',
    3,
    1,
    4
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    19,
    '419',
    3,
    1,
    15
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    20,
    '1487',
    1,
    1,
    16
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    21,
    '3890',
    6,
    1,
    17
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    22,
    '1386',
    3,
    1,
    10
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    23,
    '19',
    2,
    1,
    18
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    24,
    '4359',
    7,
    1,
    19
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    25,
    '4659',
    7,
    1,
    9
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    26,
    '4671',
    7,
    1,
    20
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    27,
    '2190',
    4,
    1,
    15
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    28,
    '1582',
    1,
    1,
    5
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    29,
    '838',
    3,
    1,
    21
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    30,
    '1501',
    3,
    1,
    22
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    31,
    '4573',
    7,
    1,
    23
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    32,
    '1903',
    3,
    1,
    6
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    33,
    '536',
    2,
    1,
    24
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    34,
    '244',
    1,
    1,
    24
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    35,
    '583',
    3,
    1,
    4
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    36,
    '795',
    4,
    1,
    25
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    37,
    '1319',
    3,
    1,
    15
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    38,
    '1529',
    3,
    1,
    26
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    39,
    '2516',
    3,
    1,
    27
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    40,
    '1514',
    4,
    1,
    2
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    41,
    '707',
    4,
    1,
    12
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    42,
    '2320',
    4,
    1,
    26
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    43,
    '383',
    3,
    1,
    4
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    44,
    '457',
    4,
    1,
    28
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    45,
    '2757',
    1,
    1,
    16
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    46,
    '771',
    4,
    1,
    12
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    47,
    '4367',
    7,
    1,
    19
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    48,
    '791',
    4,
    1,
    16
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    49,
    '31',
    2,
    1,
    29
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    50,
    '171',
    1,
    1,
    12
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    51,
    '773',
    4,
    1,
    12
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    52,
    '3043',
    1,
    1,
    30
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    53,
    '2819',
    1,
    1,
    31
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    54,
    '2234',
    1,
    1,
    5
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    55,
    '679',
    4,
    1,
    24
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    56,
    '841',
    3,
    1,
    32
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    57,
    '735',
    3,
    1,
    16
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    58,
    '5611',
    7,
    1,
    7
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    59,
    '1083',
    3,
    1,
    4
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    60,
    '1233',
    4,
    1,
    33
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    61,
    '496',
    4,
    1,
    5
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    62,
    '523',
    3,
    1,
    12
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    63,
    '5726',
    7,
    1,
    32
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    64,
    '3709',
    6,
    1,
    31
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    65,
    '4687',
    7,
    1,
    34
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    66,
    '709',
    4,
    1,
    35
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    67,
    '732',
    4,
    1,
    2
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    68,
    '1189',
    3,
    1,
    35
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    69,
    '5705',
    7,
    1,
    31
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    70,
    '738',
    4,
    1,
    12
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    71,
    '5670',
    7,
    1,
    36
);


INSERT INTO flight (
    flight_id,
    flight_number,
    airline_id,
    departure_airport_id,
    arrival_airport_id
)
VALUES (
    72,
    '5750',
    7,
    1,
    20
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    1,
    1,
    3,
    '2025-01-11 19:55:00',
    '2025-01-11 23:27:00',
    '2025-01-11 20:37:00',
    '2025-01-11 23:51:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    2,
    2,
    3,
    '2025-01-23 11:20:00',
    '2025-01-23 13:53:00',
    '2025-01-23 11:52:00',
    '2025-01-23 14:19:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    3,
    3,
    3,
    '2025-01-22 15:00:00',
    '2025-01-22 18:15:00',
    '2025-01-22 15:25:00',
    '2025-01-22 19:21:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    4,
    4,
    3,
    '2025-01-13 19:29:00',
    '2025-01-13 22:36:00',
    '2025-01-13 20:06:00',
    '2025-01-13 23:17:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    5,
    5,
    3,
    '2025-01-19 15:59:00',
    '2025-01-19 19:15:00',
    '2025-01-19 17:15:00',
    '2025-01-19 20:46:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    6,
    6,
    3,
    '2025-01-20 20:45:00',
    '2025-01-21 01:42:00',
    '2025-01-20 22:43:00',
    '2025-01-21 03:25:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    7,
    7,
    3,
    '2025-01-04 14:59:00',
    '2025-01-04 17:40:00',
    '2025-01-04 15:25:00',
    '2025-01-04 18:07:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    8,
    8,
    3,
    '2025-01-31 15:40:00',
    '2025-01-31 18:50:00',
    '2025-01-31 15:56:00',
    '2025-01-31 18:53:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    9,
    9,
    3,
    '2025-01-19 06:00:00',
    '2025-01-19 07:30:00',
    '2025-01-19 07:01:00',
    '2025-01-19 08:01:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    10,
    10,
    3,
    '2025-01-07 21:55:00',
    '2025-01-07 23:26:00',
    '2025-01-07 22:27:00',
    '2025-01-07 23:47:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    11,
    11,
    3,
    '2025-01-22 15:00:00',
    '2025-01-22 18:06:00',
    '2025-01-22 15:17:00',
    '2025-01-22 18:22:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    12,
    12,
    3,
    '2025-01-30 19:30:00',
    '2025-01-30 21:43:00',
    '2025-01-30 19:46:00',
    '2025-01-30 21:35:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    13,
    13,
    3,
    '2025-01-09 21:30:00',
    '2025-01-10 00:55:00',
    '2025-01-10 00:08:00',
    '2025-01-10 03:08:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    14,
    14,
    3,
    '2025-01-05 19:45:00',
    '2025-01-05 22:51:00',
    '2025-01-05 20:34:00',
    '2025-01-05 23:33:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    15,
    15,
    3,
    '2025-01-24 17:50:00',
    '2025-01-24 19:36:00',
    '2025-01-24 18:19:00',
    '2025-01-24 20:02:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    16,
    10,
    3,
    '2025-01-21 21:55:00',
    '2025-01-21 23:26:00',
    '2025-01-22 01:13:00',
    '2025-01-22 02:35:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    17,
    16,
    3,
    '2025-01-20 12:24:00',
    '2025-01-20 15:00:00',
    '2025-01-20 12:45:00',
    '2025-01-20 15:14:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    18,
    17,
    3,
    '2025-01-10 17:34:00',
    '2025-01-10 20:56:00',
    '2025-01-10 17:51:00',
    '2025-01-10 21:01:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    19,
    18,
    3,
    '2025-01-05 17:05:00',
    '2025-01-05 20:10:00',
    '2025-01-05 17:31:00',
    '2025-01-05 20:36:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    20,
    19,
    3,
    '2025-01-02 17:53:00',
    '2025-01-02 20:35:00',
    '2025-01-02 18:18:00',
    '2025-01-02 20:52:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    21,
    20,
    3,
    '2025-01-10 09:30:00',
    '2025-01-10 13:25:00',
    '2025-01-10 09:48:00',
    '2025-01-10 12:59:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    22,
    21,
    3,
    '2025-01-11 11:29:00',
    '2025-01-11 13:50:00',
    '2025-01-11 12:26:00',
    '2025-01-11 14:39:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    23,
    14,
    3,
    '2025-01-03 19:45:00',
    '2025-01-03 22:51:00',
    '2025-01-03 20:00:00',
    '2025-01-03 22:52:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    24,
    22,
    3,
    '2025-01-04 09:20:00',
    '2025-01-04 10:49:00',
    '2025-01-04 10:05:00',
    '2025-01-04 11:32:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    25,
    23,
    3,
    '2025-01-18 17:29:00',
    '2025-01-18 21:07:00',
    '2025-01-18 17:47:00',
    '2025-01-18 20:57:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    26,
    24,
    4,
    '2025-01-10 21:55:00',
    '2025-01-10 23:25:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    27,
    25,
    4,
    '2025-01-19 21:59:00',
    '2025-01-19 23:09:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    28,
    5,
    4,
    '2025-01-08 15:59:00',
    '2025-01-08 19:15:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    29,
    26,
    4,
    '2025-01-06 14:59:00',
    '2025-01-06 16:24:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    30,
    16,
    4,
    '2025-01-10 12:24:00',
    '2025-01-10 15:00:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    31,
    27,
    4,
    '2025-01-21 20:10:00',
    '2025-01-21 22:59:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    32,
    28,
    4,
    '2025-01-09 14:30:00',
    '2025-01-09 17:46:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    33,
    29,
    4,
    '2025-01-19 15:59:00',
    '2025-01-19 20:49:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    34,
    30,
    4,
    '2025-01-19 15:55:00',
    '2025-01-19 19:07:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    35,
    31,
    4,
    '2025-01-06 21:00:00',
    '2025-01-06 23:08:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    36,
    32,
    3,
    '2025-01-27 14:59:00',
    '2025-01-27 19:49:00',
    '2025-01-27 15:04:00',
    '2025-01-27 19:53:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    37,
    33,
    3,
    '2025-01-03 09:30:00',
    '2025-01-03 13:14:00',
    '2025-01-03 09:40:00',
    '2025-01-03 13:18:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    38,
    34,
    3,
    '2025-01-12 15:34:00',
    '2025-01-12 19:26:00',
    '2025-01-12 15:43:00',
    '2025-01-12 19:16:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    39,
    35,
    3,
    '2025-01-22 06:45:00',
    '2025-01-22 09:45:00',
    '2025-01-22 06:52:00',
    '2025-01-22 10:21:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    40,
    36,
    3,
    '2025-01-30 07:35:00',
    '2025-01-30 10:42:00',
    '2025-01-30 07:49:00',
    '2025-01-30 10:45:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    41,
    37,
    3,
    '2025-01-20 21:30:00',
    '2025-01-21 00:11:00',
    '2025-01-20 21:37:00',
    '2025-01-21 00:23:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    42,
    38,
    3,
    '2025-01-13 06:00:00',
    '2025-01-13 09:20:00',
    '2025-01-13 06:02:00',
    '2025-01-13 09:07:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    43,
    39,
    3,
    '2025-01-27 18:15:00',
    '2025-01-27 19:36:00',
    '2025-01-27 18:21:00',
    '2025-01-27 20:00:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    44,
    40,
    3,
    '2025-01-03 11:00:00',
    '2025-01-03 14:23:00',
    '2025-01-03 11:04:00',
    '2025-01-03 14:25:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    45,
    41,
    3,
    '2025-01-30 19:45:00',
    '2025-01-30 23:28:00',
    '2025-01-30 19:47:00',
    '2025-01-30 23:30:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    46,
    42,
    3,
    '2025-01-19 07:35:00',
    '2025-01-19 10:56:00',
    '2025-01-19 07:28:00',
    '2025-01-19 10:50:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    47,
    43,
    3,
    '2025-01-06 19:30:00',
    '2025-01-06 22:33:00',
    '2025-01-06 19:28:00',
    '2025-01-06 22:36:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    48,
    44,
    3,
    '2025-01-22 16:55:00',
    '2025-01-22 19:46:00',
    '2025-01-22 16:49:00',
    '2025-01-22 19:16:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    49,
    38,
    3,
    '2025-01-25 06:00:00',
    '2025-01-25 09:20:00',
    '2025-01-25 05:59:00',
    '2025-01-25 09:02:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    50,
    45,
    3,
    '2025-01-15 17:00:00',
    '2025-01-15 20:50:00',
    '2025-01-15 16:58:00',
    '2025-01-15 20:04:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    51,
    46,
    3,
    '2025-01-08 17:05:00',
    '2025-01-08 20:37:00',
    '2025-01-08 17:03:00',
    '2025-01-08 20:33:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    52,
    47,
    3,
    '2025-01-25 19:00:00',
    '2025-01-25 20:37:00',
    '2025-01-25 18:55:00',
    '2025-01-25 20:21:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    53,
    48,
    3,
    '2025-01-27 07:35:00',
    '2025-01-27 11:35:00',
    '2025-01-27 07:30:00',
    '2025-01-27 11:52:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    54,
    49,
    3,
    '2025-01-31 11:30:00',
    '2025-01-31 14:58:00',
    '2025-01-31 11:27:00',
    '2025-01-31 15:00:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    55,
    50,
    3,
    '2025-01-23 06:00:00',
    '2025-01-23 09:29:00',
    '2025-01-23 05:55:00',
    '2025-01-23 08:56:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    56,
    1,
    3,
    '2025-01-09 19:55:00',
    '2025-01-09 23:27:00',
    '2025-01-09 19:55:00',
    '2025-01-09 22:58:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    57,
    51,
    3,
    '2025-01-04 10:29:00',
    '2025-01-04 13:45:00',
    '2025-01-04 10:23:00',
    '2025-01-04 13:38:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    58,
    52,
    3,
    '2025-01-20 08:59:00',
    '2025-01-20 13:59:00',
    '2025-01-20 08:52:00',
    '2025-01-20 13:58:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    59,
    53,
    3,
    '2025-01-10 09:00:00',
    '2025-01-10 10:47:00',
    '2025-01-10 08:58:00',
    '2025-01-10 10:47:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    60,
    54,
    3,
    '2025-01-16 08:00:00',
    '2025-01-16 11:20:00',
    '2025-01-16 07:58:00',
    '2025-01-16 10:46:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    61,
    55,
    3,
    '2025-01-09 14:55:00',
    '2025-01-09 18:41:00',
    '2025-01-09 14:52:00',
    '2025-01-09 18:04:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    62,
    56,
    3,
    '2025-01-13 08:30:00',
    '2025-01-13 11:00:00',
    '2025-01-13 08:21:00',
    '2025-01-13 10:46:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    63,
    57,
    3,
    '2025-01-08 18:30:00',
    '2025-01-08 22:13:00',
    '2025-01-08 18:23:00',
    '2025-01-08 21:56:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    64,
    58,
    3,
    '2025-01-31 19:29:00',
    '2025-01-31 22:20:00',
    '2025-01-31 19:28:00',
    '2025-01-31 22:36:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    65,
    59,
    3,
    '2025-01-06 09:59:00',
    '2025-01-06 13:01:00',
    '2025-01-06 09:58:00',
    '2025-01-06 12:51:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    66,
    60,
    3,
    '2025-01-01 17:40:00',
    '2025-01-01 21:15:00',
    '2025-01-01 17:38:00',
    '2025-01-01 21:30:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    67,
    61,
    3,
    '2025-01-18 18:00:00',
    '2025-01-18 21:19:00',
    '2025-01-18 17:56:00',
    '2025-01-18 21:08:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    68,
    62,
    3,
    '2025-01-14 07:00:00',
    '2025-01-14 10:21:00',
    '2025-01-14 06:49:00',
    '2025-01-14 10:04:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    69,
    52,
    3,
    '2025-01-31 09:00:00',
    '2025-01-31 14:00:00',
    '2025-01-31 08:53:00',
    '2025-01-31 13:22:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    70,
    63,
    3,
    '2025-01-01 17:40:00',
    '2025-01-01 20:20:00',
    '2025-01-01 17:36:00',
    '2025-01-01 20:23:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    71,
    64,
    3,
    '2025-01-18 19:29:00',
    '2025-01-18 21:28:00',
    '2025-01-18 19:25:00',
    '2025-01-18 21:38:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    72,
    65,
    3,
    '2025-01-28 12:59:00',
    '2025-01-28 14:02:00',
    '2025-01-28 12:51:00',
    '2025-01-28 13:52:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    73,
    66,
    3,
    '2025-01-14 16:55:00',
    '2025-01-14 20:25:00',
    '2025-01-14 16:52:00',
    '2025-01-14 19:54:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    74,
    67,
    3,
    '2025-01-13 13:10:00',
    '2025-01-13 16:33:00',
    '2025-01-13 13:08:00',
    '2025-01-13 16:41:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    75,
    68,
    3,
    '2025-01-08 16:30:00',
    '2025-01-08 19:45:00',
    '2025-01-08 16:27:00',
    '2025-01-08 18:52:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    76,
    69,
    3,
    '2025-01-12 08:00:00',
    '2025-01-12 09:55:00',
    '2025-01-12 07:56:00',
    '2025-01-12 10:01:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    77,
    49,
    3,
    '2025-01-17 11:30:00',
    '2025-01-17 14:58:00',
    '2025-01-17 11:28:00',
    '2025-01-17 14:54:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    78,
    70,
    3,
    '2025-01-02 15:29:00',
    '2025-01-02 18:50:00',
    '2025-01-02 15:28:00',
    '2025-01-02 18:44:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    79,
    71,
    3,
    '2025-01-08 14:16:00',
    '2025-01-08 16:39:00',
    '2025-01-08 14:09:00',
    '2025-01-08 16:22:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    80,
    72,
    3,
    '2025-01-31 08:55:00',
    '2025-01-31 10:20:00',
    '2025-01-31 08:49:00',
    '2025-01-31 10:08:00'
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    81,
    1,
    1,
    '2026-10-15 10:00:00',
    '2026-10-15 13:00:00',
    NULL,
    NULL
);


INSERT INTO flight_instance (
    flight_instance_id,
    flight_id,
    status_id,
    scheduled_departure,
    scheduled_arrival,
    actual_departure,
    actual_arrival
)
VALUES (
    82,
    2,
    2,
    '2026-10-16 09:00:00',
    '2026-10-16 12:00:00',
    '2026-10-16 09:20:00',
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    1,
    1,
    1
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    2,
    2,
    2
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    3,
    3,
    3
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    4,
    4,
    4
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    5,
    5,
    5
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    6,
    6,
    1
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    7,
    7,
    1
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    8,
    8,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    9,
    9,
    1
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    10,
    10,
    1
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    11,
    11,
    5
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    12,
    12,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    13,
    13,
    5
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    14,
    14,
    5
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    15,
    15,
    2
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    16,
    16,
    5
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    17,
    17,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    18,
    18,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    19,
    19,
    1
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    20,
    20,
    1
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    21,
    21,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    22,
    22,
    1
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    23,
    23,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    24,
    24,
    5
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    25,
    25,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    26,
    36,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    27,
    37,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    28,
    38,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    29,
    39,
    3
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    30,
    40,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    31,
    41,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    32,
    42,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    33,
    43,
    3
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    34,
    44,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    35,
    45,
    NULL
);


INSERT INTO delay (
    delay_id,
    flight_instance_id,
    reason_id
)
VALUES (
    36,
    82,
    6
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    1,
    1,
    NULL,
    1,
    1,
    '2025-01-10 19:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    2,
    1,
    1,
    2,
    1,
    '2025-01-11 20:37:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    3,
    1,
    2,
    3,
    1,
    '2025-01-11 23:51:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    4,
    2,
    NULL,
    1,
    1,
    '2025-01-22 11:20:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    5,
    2,
    1,
    2,
    1,
    '2025-01-23 11:52:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    6,
    2,
    2,
    3,
    1,
    '2025-01-23 14:19:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    7,
    3,
    NULL,
    1,
    1,
    '2025-01-21 15:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    8,
    3,
    1,
    2,
    1,
    '2025-01-22 15:25:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    9,
    3,
    2,
    3,
    1,
    '2025-01-22 19:21:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    10,
    4,
    NULL,
    1,
    1,
    '2025-01-12 19:29:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    11,
    4,
    1,
    2,
    1,
    '2025-01-13 20:06:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    12,
    4,
    2,
    3,
    1,
    '2025-01-13 23:17:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    13,
    5,
    NULL,
    1,
    1,
    '2025-01-18 15:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    14,
    5,
    1,
    2,
    1,
    '2025-01-19 17:15:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    15,
    5,
    2,
    3,
    1,
    '2025-01-19 20:46:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    16,
    6,
    NULL,
    1,
    1,
    '2025-01-19 20:45:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    17,
    6,
    1,
    2,
    1,
    '2025-01-20 22:43:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    18,
    6,
    2,
    3,
    1,
    '2025-01-21 03:25:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    19,
    7,
    NULL,
    1,
    1,
    '2025-01-03 14:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    20,
    7,
    1,
    2,
    1,
    '2025-01-04 15:25:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    21,
    7,
    2,
    3,
    1,
    '2025-01-04 18:07:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    22,
    8,
    NULL,
    1,
    1,
    '2025-01-30 15:40:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    23,
    8,
    1,
    2,
    1,
    '2025-01-31 15:56:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    24,
    8,
    2,
    3,
    1,
    '2025-01-31 18:53:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    25,
    9,
    NULL,
    1,
    1,
    '2025-01-18 06:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    26,
    9,
    1,
    2,
    1,
    '2025-01-19 07:01:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    27,
    9,
    2,
    3,
    1,
    '2025-01-19 08:01:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    28,
    10,
    NULL,
    1,
    1,
    '2025-01-06 21:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    29,
    10,
    1,
    2,
    1,
    '2025-01-07 22:27:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    30,
    10,
    2,
    3,
    1,
    '2025-01-07 23:47:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    31,
    11,
    NULL,
    1,
    1,
    '2025-01-21 15:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    32,
    11,
    1,
    2,
    1,
    '2025-01-22 15:17:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    33,
    11,
    2,
    3,
    1,
    '2025-01-22 18:22:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    34,
    12,
    NULL,
    1,
    1,
    '2025-01-29 19:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    35,
    12,
    1,
    2,
    1,
    '2025-01-30 19:46:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    36,
    12,
    2,
    3,
    1,
    '2025-01-30 21:35:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    37,
    13,
    NULL,
    1,
    1,
    '2025-01-08 21:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    38,
    13,
    1,
    2,
    1,
    '2025-01-10 00:08:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    39,
    13,
    2,
    3,
    1,
    '2025-01-10 03:08:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    40,
    14,
    NULL,
    1,
    1,
    '2025-01-04 19:45:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    41,
    14,
    1,
    2,
    1,
    '2025-01-05 20:34:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    42,
    14,
    2,
    3,
    1,
    '2025-01-05 23:33:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    43,
    15,
    NULL,
    1,
    1,
    '2025-01-23 17:50:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    44,
    15,
    1,
    2,
    1,
    '2025-01-24 18:19:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    45,
    15,
    2,
    3,
    1,
    '2025-01-24 20:02:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    46,
    16,
    NULL,
    1,
    1,
    '2025-01-20 21:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    47,
    16,
    1,
    2,
    1,
    '2025-01-22 01:13:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    48,
    16,
    2,
    3,
    1,
    '2025-01-22 02:35:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    49,
    17,
    NULL,
    1,
    1,
    '2025-01-19 12:24:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    50,
    17,
    1,
    2,
    1,
    '2025-01-20 12:45:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    51,
    17,
    2,
    3,
    1,
    '2025-01-20 15:14:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    52,
    18,
    NULL,
    1,
    1,
    '2025-01-09 17:34:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    53,
    18,
    1,
    2,
    1,
    '2025-01-10 17:51:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    54,
    18,
    2,
    3,
    1,
    '2025-01-10 21:01:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    55,
    19,
    NULL,
    1,
    1,
    '2025-01-04 17:05:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    56,
    19,
    1,
    2,
    1,
    '2025-01-05 17:31:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    57,
    19,
    2,
    3,
    1,
    '2025-01-05 20:36:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    58,
    20,
    NULL,
    1,
    1,
    '2025-01-01 17:53:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    59,
    20,
    1,
    2,
    1,
    '2025-01-02 18:18:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    60,
    20,
    2,
    3,
    1,
    '2025-01-02 20:52:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    61,
    21,
    NULL,
    1,
    1,
    '2025-01-09 09:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    62,
    21,
    1,
    2,
    1,
    '2025-01-10 09:48:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    63,
    21,
    2,
    3,
    1,
    '2025-01-10 12:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    64,
    22,
    NULL,
    1,
    1,
    '2025-01-10 11:29:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    65,
    22,
    1,
    2,
    1,
    '2025-01-11 12:26:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    66,
    22,
    2,
    3,
    1,
    '2025-01-11 14:39:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    67,
    23,
    NULL,
    1,
    1,
    '2025-01-02 19:45:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    68,
    23,
    1,
    2,
    1,
    '2025-01-03 20:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    69,
    23,
    2,
    3,
    1,
    '2025-01-03 22:52:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    70,
    24,
    NULL,
    1,
    1,
    '2025-01-03 09:20:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    71,
    24,
    1,
    2,
    1,
    '2025-01-04 10:05:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    72,
    24,
    2,
    3,
    1,
    '2025-01-04 11:32:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    73,
    25,
    NULL,
    1,
    1,
    '2025-01-17 17:29:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    74,
    25,
    1,
    2,
    1,
    '2025-01-18 17:47:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    75,
    25,
    2,
    3,
    1,
    '2025-01-18 20:57:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    76,
    26,
    NULL,
    1,
    1,
    '2025-01-09 21:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    77,
    26,
    1,
    4,
    1,
    '2025-01-10 19:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    78,
    27,
    NULL,
    1,
    1,
    '2025-01-18 21:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    79,
    27,
    1,
    4,
    1,
    '2025-01-19 19:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    80,
    28,
    NULL,
    1,
    1,
    '2025-01-07 15:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    81,
    28,
    1,
    4,
    1,
    '2025-01-08 13:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    82,
    29,
    NULL,
    1,
    1,
    '2025-01-05 14:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    83,
    29,
    1,
    4,
    1,
    '2025-01-06 12:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    84,
    30,
    NULL,
    1,
    1,
    '2025-01-09 12:24:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    85,
    30,
    1,
    4,
    1,
    '2025-01-10 10:24:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    86,
    31,
    NULL,
    1,
    1,
    '2025-01-20 20:10:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    87,
    31,
    1,
    4,
    1,
    '2025-01-21 18:10:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    88,
    32,
    NULL,
    1,
    1,
    '2025-01-08 14:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    89,
    32,
    1,
    4,
    1,
    '2025-01-09 12:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    90,
    33,
    NULL,
    1,
    1,
    '2025-01-18 15:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    91,
    33,
    1,
    4,
    1,
    '2025-01-19 13:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    92,
    34,
    NULL,
    1,
    1,
    '2025-01-18 15:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    93,
    34,
    1,
    4,
    1,
    '2025-01-19 13:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    94,
    35,
    NULL,
    1,
    1,
    '2025-01-05 21:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    95,
    35,
    1,
    4,
    1,
    '2025-01-06 19:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    96,
    36,
    NULL,
    1,
    1,
    '2025-01-26 14:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    97,
    36,
    1,
    2,
    1,
    '2025-01-27 15:04:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    98,
    36,
    2,
    3,
    1,
    '2025-01-27 19:53:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    99,
    37,
    NULL,
    1,
    1,
    '2025-01-02 09:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    100,
    37,
    1,
    2,
    1,
    '2025-01-03 09:40:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    101,
    37,
    2,
    3,
    1,
    '2025-01-03 13:18:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    102,
    38,
    NULL,
    1,
    1,
    '2025-01-11 15:34:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    103,
    38,
    1,
    2,
    1,
    '2025-01-12 15:43:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    104,
    38,
    2,
    3,
    1,
    '2025-01-12 19:16:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    105,
    39,
    NULL,
    1,
    1,
    '2025-01-21 06:45:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    106,
    39,
    1,
    2,
    1,
    '2025-01-22 06:52:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    107,
    39,
    2,
    3,
    1,
    '2025-01-22 10:21:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    108,
    40,
    NULL,
    1,
    1,
    '2025-01-29 07:35:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    109,
    40,
    1,
    2,
    1,
    '2025-01-30 07:49:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    110,
    40,
    2,
    3,
    1,
    '2025-01-30 10:45:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    111,
    41,
    NULL,
    1,
    1,
    '2025-01-19 21:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    112,
    41,
    1,
    2,
    1,
    '2025-01-20 21:37:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    113,
    41,
    2,
    3,
    1,
    '2025-01-21 00:23:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    114,
    42,
    NULL,
    1,
    1,
    '2025-01-12 06:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    115,
    42,
    1,
    2,
    1,
    '2025-01-13 06:02:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    116,
    42,
    2,
    3,
    1,
    '2025-01-13 09:07:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    117,
    43,
    NULL,
    1,
    1,
    '2025-01-26 18:15:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    118,
    43,
    1,
    2,
    1,
    '2025-01-27 18:21:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    119,
    43,
    2,
    3,
    1,
    '2025-01-27 20:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    120,
    44,
    NULL,
    1,
    1,
    '2025-01-02 11:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    121,
    44,
    1,
    2,
    1,
    '2025-01-03 11:04:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    122,
    44,
    2,
    3,
    1,
    '2025-01-03 14:25:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    123,
    45,
    NULL,
    1,
    1,
    '2025-01-29 19:45:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    124,
    45,
    1,
    2,
    1,
    '2025-01-30 19:47:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    125,
    45,
    2,
    3,
    1,
    '2025-01-30 23:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    126,
    46,
    NULL,
    1,
    1,
    '2025-01-18 07:35:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    127,
    46,
    1,
    2,
    1,
    '2025-01-19 07:28:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    128,
    46,
    2,
    3,
    1,
    '2025-01-19 10:50:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    129,
    47,
    NULL,
    1,
    1,
    '2025-01-05 19:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    130,
    47,
    1,
    2,
    1,
    '2025-01-06 19:28:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    131,
    47,
    2,
    3,
    1,
    '2025-01-06 22:36:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    132,
    48,
    NULL,
    1,
    1,
    '2025-01-21 16:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    133,
    48,
    1,
    2,
    1,
    '2025-01-22 16:49:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    134,
    48,
    2,
    3,
    1,
    '2025-01-22 19:16:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    135,
    49,
    NULL,
    1,
    1,
    '2025-01-24 06:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    136,
    49,
    1,
    2,
    1,
    '2025-01-25 05:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    137,
    49,
    2,
    3,
    1,
    '2025-01-25 09:02:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    138,
    50,
    NULL,
    1,
    1,
    '2025-01-14 17:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    139,
    50,
    1,
    2,
    1,
    '2025-01-15 16:58:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    140,
    50,
    2,
    3,
    1,
    '2025-01-15 20:04:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    141,
    51,
    NULL,
    1,
    1,
    '2025-01-07 17:05:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    142,
    51,
    1,
    2,
    1,
    '2025-01-08 17:03:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    143,
    51,
    2,
    3,
    1,
    '2025-01-08 20:33:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    144,
    52,
    NULL,
    1,
    1,
    '2025-01-24 19:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    145,
    52,
    1,
    2,
    1,
    '2025-01-25 18:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    146,
    52,
    2,
    3,
    1,
    '2025-01-25 20:21:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    147,
    53,
    NULL,
    1,
    1,
    '2025-01-26 07:35:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    148,
    53,
    1,
    2,
    1,
    '2025-01-27 07:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    149,
    53,
    2,
    3,
    1,
    '2025-01-27 11:52:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    150,
    54,
    NULL,
    1,
    1,
    '2025-01-30 11:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    151,
    54,
    1,
    2,
    1,
    '2025-01-31 11:27:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    152,
    54,
    2,
    3,
    1,
    '2025-01-31 15:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    153,
    55,
    NULL,
    1,
    1,
    '2025-01-22 06:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    154,
    55,
    1,
    2,
    1,
    '2025-01-23 05:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    155,
    55,
    2,
    3,
    1,
    '2025-01-23 08:56:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    156,
    56,
    NULL,
    1,
    1,
    '2025-01-08 19:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    157,
    56,
    1,
    2,
    1,
    '2025-01-09 19:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    158,
    56,
    2,
    3,
    1,
    '2025-01-09 22:58:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    159,
    57,
    NULL,
    1,
    1,
    '2025-01-03 10:29:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    160,
    57,
    1,
    2,
    1,
    '2025-01-04 10:23:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    161,
    57,
    2,
    3,
    1,
    '2025-01-04 13:38:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    162,
    58,
    NULL,
    1,
    1,
    '2025-01-19 08:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    163,
    58,
    1,
    2,
    1,
    '2025-01-20 08:52:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    164,
    58,
    2,
    3,
    1,
    '2025-01-20 13:58:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    165,
    59,
    NULL,
    1,
    1,
    '2025-01-09 09:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    166,
    59,
    1,
    2,
    1,
    '2025-01-10 08:58:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    167,
    59,
    2,
    3,
    1,
    '2025-01-10 10:47:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    168,
    60,
    NULL,
    1,
    1,
    '2025-01-15 08:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    169,
    60,
    1,
    2,
    1,
    '2025-01-16 07:58:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    170,
    60,
    2,
    3,
    1,
    '2025-01-16 10:46:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    171,
    61,
    NULL,
    1,
    1,
    '2025-01-08 14:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    172,
    61,
    1,
    2,
    1,
    '2025-01-09 14:52:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    173,
    61,
    2,
    3,
    1,
    '2025-01-09 18:04:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    174,
    62,
    NULL,
    1,
    1,
    '2025-01-12 08:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    175,
    62,
    1,
    2,
    1,
    '2025-01-13 08:21:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    176,
    62,
    2,
    3,
    1,
    '2025-01-13 10:46:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    177,
    63,
    NULL,
    1,
    1,
    '2025-01-07 18:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    178,
    63,
    1,
    2,
    1,
    '2025-01-08 18:23:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    179,
    63,
    2,
    3,
    1,
    '2025-01-08 21:56:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    180,
    64,
    NULL,
    1,
    1,
    '2025-01-30 19:29:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    181,
    64,
    1,
    2,
    1,
    '2025-01-31 19:28:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    182,
    64,
    2,
    3,
    1,
    '2025-01-31 22:36:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    183,
    65,
    NULL,
    1,
    1,
    '2025-01-05 09:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    184,
    65,
    1,
    2,
    1,
    '2025-01-06 09:58:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    185,
    65,
    2,
    3,
    1,
    '2025-01-06 12:51:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    186,
    66,
    NULL,
    1,
    1,
    '2024-12-31 17:40:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    187,
    66,
    1,
    2,
    1,
    '2025-01-01 17:38:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    188,
    66,
    2,
    3,
    1,
    '2025-01-01 21:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    189,
    67,
    NULL,
    1,
    1,
    '2025-01-17 18:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    190,
    67,
    1,
    2,
    1,
    '2025-01-18 17:56:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    191,
    67,
    2,
    3,
    1,
    '2025-01-18 21:08:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    192,
    68,
    NULL,
    1,
    1,
    '2025-01-13 07:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    193,
    68,
    1,
    2,
    1,
    '2025-01-14 06:49:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    194,
    68,
    2,
    3,
    1,
    '2025-01-14 10:04:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    195,
    69,
    NULL,
    1,
    1,
    '2025-01-30 09:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    196,
    69,
    1,
    2,
    1,
    '2025-01-31 08:53:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    197,
    69,
    2,
    3,
    1,
    '2025-01-31 13:22:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    198,
    70,
    NULL,
    1,
    1,
    '2024-12-31 17:40:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    199,
    70,
    1,
    2,
    1,
    '2025-01-01 17:36:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    200,
    70,
    2,
    3,
    1,
    '2025-01-01 20:23:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    201,
    71,
    NULL,
    1,
    1,
    '2025-01-17 19:29:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    202,
    71,
    1,
    2,
    1,
    '2025-01-18 19:25:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    203,
    71,
    2,
    3,
    1,
    '2025-01-18 21:38:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    204,
    72,
    NULL,
    1,
    1,
    '2025-01-27 12:59:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    205,
    72,
    1,
    2,
    1,
    '2025-01-28 12:51:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    206,
    72,
    2,
    3,
    1,
    '2025-01-28 13:52:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    207,
    73,
    NULL,
    1,
    1,
    '2025-01-13 16:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    208,
    73,
    1,
    2,
    1,
    '2025-01-14 16:52:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    209,
    73,
    2,
    3,
    1,
    '2025-01-14 19:54:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    210,
    74,
    NULL,
    1,
    1,
    '2025-01-12 13:10:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    211,
    74,
    1,
    2,
    1,
    '2025-01-13 13:08:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    212,
    74,
    2,
    3,
    1,
    '2025-01-13 16:41:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    213,
    75,
    NULL,
    1,
    1,
    '2025-01-07 16:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    214,
    75,
    1,
    2,
    1,
    '2025-01-08 16:27:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    215,
    75,
    2,
    3,
    1,
    '2025-01-08 18:52:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    216,
    76,
    NULL,
    1,
    1,
    '2025-01-11 08:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    217,
    76,
    1,
    2,
    1,
    '2025-01-12 07:56:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    218,
    76,
    2,
    3,
    1,
    '2025-01-12 10:01:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    219,
    77,
    NULL,
    1,
    1,
    '2025-01-16 11:30:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    220,
    77,
    1,
    2,
    1,
    '2025-01-17 11:28:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    221,
    77,
    2,
    3,
    1,
    '2025-01-17 14:54:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    222,
    78,
    NULL,
    1,
    1,
    '2025-01-01 15:29:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    223,
    78,
    1,
    2,
    1,
    '2025-01-02 15:28:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    224,
    78,
    2,
    3,
    1,
    '2025-01-02 18:44:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    225,
    79,
    NULL,
    1,
    1,
    '2025-01-07 14:16:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    226,
    79,
    1,
    2,
    1,
    '2025-01-08 14:09:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    227,
    79,
    2,
    3,
    1,
    '2025-01-08 16:22:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    228,
    80,
    NULL,
    1,
    1,
    '2025-01-30 08:55:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    229,
    80,
    1,
    2,
    1,
    '2025-01-31 08:49:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    230,
    80,
    2,
    3,
    1,
    '2025-01-31 10:08:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    231,
    81,
    NULL,
    1,
    1,
    '2026-10-14 10:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    232,
    82,
    NULL,
    1,
    1,
    '2026-10-15 09:00:00'
);


INSERT INTO status_history (
    history_id,
    flight_instance_id,
    previous_status_id,
    new_status_id,
    changed_by_user_id,
    changed_at
)
VALUES (
    233,
    82,
    1,
    2,
    1,
    '2026-10-16 09:20:00'
);


SELECT setval(
    pg_get_serial_sequence(
        'app_role',
        'role_id'
    ),
    (
        SELECT MAX(role_id)
        FROM app_role
    ),
    TRUE
);


SELECT setval(
    pg_get_serial_sequence(
        'app_user',
        'user_id'
    ),
    (
        SELECT MAX(user_id)
        FROM app_user
    ),
    TRUE
);


SELECT setval(
    pg_get_serial_sequence(
        'airport',
        'airport_id'
    ),
    (
        SELECT MAX(airport_id)
        FROM airport
    ),
    TRUE
);


SELECT setval(
    pg_get_serial_sequence(
        'airline',
        'airline_id'
    ),
    (
        SELECT MAX(airline_id)
        FROM airline
    ),
    TRUE
);


SELECT setval(
    pg_get_serial_sequence(
        'flight',
        'flight_id'
    ),
    (
        SELECT MAX(flight_id)
        FROM flight
    ),
    TRUE
);


SELECT setval(
    pg_get_serial_sequence(
        'flight_status',
        'status_id'
    ),
    (
        SELECT MAX(status_id)
        FROM flight_status
    ),
    TRUE
);


SELECT setval(
    pg_get_serial_sequence(
        'flight_instance',
        'flight_instance_id'
    ),
    (
        SELECT MAX(flight_instance_id)
        FROM flight_instance
    ),
    TRUE
);


SELECT setval(
    pg_get_serial_sequence(
        'delay_reason',
        'reason_id'
    ),
    (
        SELECT MAX(reason_id)
        FROM delay_reason
    ),
    TRUE
);


SELECT setval(
    pg_get_serial_sequence(
        'delay',
        'delay_id'
    ),
    (
        SELECT MAX(delay_id)
        FROM delay
    ),
    TRUE
);


SELECT setval(
    pg_get_serial_sequence(
        'status_history',
        'history_id'
    ),
    (
        SELECT MAX(history_id)
        FROM status_history
    ),
    TRUE
);


COMMIT;
