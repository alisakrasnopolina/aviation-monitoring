"""Operations shared by the desktop application and integration tests."""

from psycopg2 import connect
from psycopg2.sql import SQL, Identifier


CATALOGS = {
    "Аэропорты": ("airport", "airport_id", ("airport_code", "airport_name", "city")),
    "Авиакомпании": ("airline", "airline_id", ("airline_code", "airline_name")),
    "Рейсы": ("flight", "flight_id", ("flight_number", "airline_id",
                                      "departure_airport_id", "arrival_airport_id")),
    "Причины задержек": ("delay_reason", "reason_id", ("reason_name", "description")),
    "Пользователи": ("app_user", "user_id",
                     ("login", "last_name", "first_name", "middle_name", "is_active", "role_id")),
}

FLIGHTS = """
SELECT fi.flight_instance_id, a.airline_code || f.flight_number AS flight,
       dep.airport_code || ' → ' || arr.airport_code AS route, fs.status_name,
       fi.scheduled_departure, fi.scheduled_arrival, fi.actual_departure,
       fi.actual_arrival, d.delay_id, dr.reason_name
FROM flight_instance fi
JOIN flight f USING (flight_id)
JOIN airline a USING (airline_id)
JOIN airport dep ON dep.airport_id = f.departure_airport_id
JOIN airport arr ON arr.airport_id = f.arrival_airport_id
JOIN flight_status fs USING (status_id)
LEFT JOIN delay d USING (flight_instance_id)
LEFT JOIN delay_reason dr USING (reason_id)
WHERE (%s = '' OR a.airline_code || f.flight_number ILIKE %s
              OR f.flight_number ILIKE %s OR a.airline_code ILIKE %s OR a.airline_name ILIKE %s
              OR dep.airport_code ILIKE %s OR arr.airport_code ILIKE %s)
  AND (%s = '' OR fs.status_name = %s)
  AND (%s::date IS NULL OR fi.scheduled_departure >= %s::date)
  AND (%s::date IS NULL OR fi.scheduled_departure < %s::date + 1)
  AND (%s::boolean IS NULL OR (d.delay_id IS NOT NULL) = %s::boolean)
ORDER BY fi.scheduled_departure DESC, fi.flight_instance_id
"""

SUMMARY = """
WITH sample AS (
    SELECT status_name,
           EXTRACT(EPOCH FROM (actual_departure - scheduled_departure)) / 60 AS minutes
    FROM flight_instance JOIN flight_status USING (status_id)
    WHERE scheduled_departure >= %s AND scheduled_departure < %s
)
SELECT COUNT(*), COUNT(*) FILTER (WHERE status_name = 'Выполнен' AND minutes IS NOT NULL),
       COUNT(*) FILTER (WHERE status_name = 'Выполнен' AND minutes > 0),
       ROUND(100.0 * COUNT(*) FILTER (WHERE status_name = 'Выполнен' AND minutes > 0)
             / NULLIF(COUNT(*) FILTER (WHERE status_name = 'Выполнен' AND minutes IS NOT NULL), 0), 2),
       ROUND(AVG(minutes) FILTER (WHERE status_name = 'Выполнен' AND minutes > 0), 2),
       ROUND(MIN(minutes) FILTER (WHERE status_name = 'Выполнен' AND minutes > 0), 2),
       ROUND(MAX(minutes) FILTER (WHERE status_name = 'Выполнен' AND minutes > 0), 2)
FROM sample
"""


class Database:
    def __init__(self, config):
        self.connection = connect(**config, connect_timeout=5,
                                  options="-c search_path=public,pg_temp")

    def execute(self, query, parameters=()):
        with self.connection, self.connection.cursor() as cursor:
            cursor.execute(query, parameters)
            return cursor.fetchall() if cursor.description else cursor.rowcount

    def close(self):
        self.connection.close()

    def role(self):
        return self.execute("SELECT public.fn_session_role()")[0][0]

    def flights(self, search="", status="", start=None, end=None, delayed=None):
        pattern = f"%{search}%"
        return self.execute(FLIGHTS, (search, *([pattern] * 6), status, status,
                                      start, start, end, end, delayed, delayed))

    def register(self, flight_id, departure, arrival):
        rows = self.execute("""
            INSERT INTO flight_instance(flight_id, status_id, scheduled_departure, scheduled_arrival)
            VALUES (%s, (SELECT status_id FROM flight_status WHERE status_name = 'Запланирован'), %s, %s)
            RETURNING flight_instance_id
        """, (flight_id, departure, arrival))
        return rows[0][0]

    def schedule(self, instance, departure, arrival):
        return self.execute("""
            UPDATE flight_instance SET scheduled_departure = %s, scheduled_arrival = %s
            WHERE flight_instance_id = %s
        """, (departure, arrival, instance))

    def change(self, instance, status, event):
        self.execute("CALL public.sp_change_flight_status(%s::bigint, %s::varchar, %s::timestamp)",
                     (instance, status, event))

    def reason(self, delay, reason):
        return self.execute("UPDATE delay SET reason_id = %s WHERE delay_id = %s", (reason, delay))

    def history(self, instance):
        return self.execute("""
            SELECT h.changed_at, old.status_name, new.status_name, u.login
            FROM status_history h
            LEFT JOIN flight_status old ON old.status_id = h.previous_status_id
            JOIN flight_status new ON new.status_id = h.new_status_id
            JOIN app_user u ON u.user_id = h.changed_by_user_id
            WHERE h.flight_instance_id = %s ORDER BY h.history_id
        """, (instance,))

    def stats(self, start, end):
        bounds = (start, end)
        return (
            self.execute(SUMMARY, bounds),
            self.execute("SELECT * FROM fn_airline_delay_stats(%s::timestamp, %s::timestamp)", bounds),
            self.execute("""
                SELECT COALESCE(r.reason_name, 'Не указана'), COUNT(*)
                FROM delay d JOIN flight_instance fi USING (flight_instance_id)
                LEFT JOIN delay_reason r USING (reason_id)
                WHERE fi.scheduled_departure >= %s AND fi.scheduled_departure < %s
                GROUP BY 1 ORDER BY 2 DESC, 1
            """, bounds),
            self.execute("""
                SELECT s.status_name, COUNT(fi.flight_instance_id)
                FROM flight_status s LEFT JOIN flight_instance fi
                    ON fi.status_id = s.status_id
                   AND fi.scheduled_departure >= %s AND fi.scheduled_departure < %s
                GROUP BY s.status_name ORDER BY s.status_name
            """, bounds),
        )

    def catalog(self, title):
        table, pk, fields = CATALOGS[title]
        columns = SQL(", ").join(map(Identifier, (pk, *fields)))
        return self.execute(SQL("SELECT {} FROM {} ORDER BY {}").format(
            columns, Identifier(table), Identifier(pk)))

    def save_catalog(self, title, values, key=None):
        table, pk, fields = CATALOGS[title]
        if key is None:
            return self.execute(SQL("INSERT INTO {} ({}) VALUES ({})").format(
                Identifier(table), SQL(", ").join(map(Identifier, fields)),
                SQL(", ").join([SQL("%s")] * len(fields))), values)
        assignments = SQL(", ").join(SQL("{} = %s").format(Identifier(f)) for f in fields)
        return self.execute(SQL("UPDATE {} SET {} WHERE {} = %s").format(
            Identifier(table), assignments, Identifier(pk)), (*values, key))

    def delete_catalog(self, title, key):
        table, pk, _ = CATALOGS[title]
        return self.execute(SQL("DELETE FROM {} WHERE {} = %s").format(
            Identifier(table), Identifier(pk)), (key,))
