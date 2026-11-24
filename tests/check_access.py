"""Integration checks with independent PostgreSQL logins. Writes are rolled back."""

from datetime import datetime
from getpass import getpass
import os
from pathlib import Path
import sys

from psycopg2 import Error

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "app"))
from db import Database


def expect_denial(cursor, query):
    cursor.execute("SAVEPOINT denial")
    try:
        cursor.execute(query)
    except Error as exc:
        cursor.execute("ROLLBACK TO SAVEPOINT denial")
        if exc.pgcode != "42501":
            raise
    else:
        raise AssertionError(f"Access should have been denied: {query}")
    finally:
        if not cursor.connection.closed:
            cursor.execute("RELEASE SAVEPOINT denial")


def analyst(db, cursor):
    assert db.flights()
    summary, airlines, _, _ = db.stats(datetime(2025, 1, 1), datetime(2025, 2, 1))
    assert summary[0][1] == sum(row[2] for row in airlines)
    expect_denial(cursor, "DELETE FROM flight_instance WHERE FALSE")
    expect_denial(cursor, "CALL sp_change_flight_status(0, 'Отменён', NULL)")
    expect_denial(cursor, "SELECT user_id FROM app_user")


def operator(db, cursor):
    assert db.flights()
    expect_denial(cursor, "UPDATE flight_instance SET flight_id = flight_id WHERE FALSE")
    expect_denial(cursor, "UPDATE flight_instance SET status_id = status_id WHERE FALSE")
    expect_denial(cursor, "UPDATE app_user SET is_active = TRUE WHERE FALSE")
    cursor.execute("""
        INSERT INTO flight_instance(flight_id, status_id, scheduled_departure, scheduled_arrival)
        VALUES ((SELECT min(flight_id) FROM flight),
                (SELECT status_id FROM flight_status WHERE status_name = 'Запланирован'),
                '2091-02-01 10:00', '2091-02-01 13:00')
        RETURNING flight_instance_id
    """)
    instance = cursor.fetchone()[0]
    cursor.execute("CALL sp_change_flight_status(%s::bigint, 'Вылетел', '2091-02-01 10:15')", (instance,))
    cursor.execute("SELECT fn_calculate_delay_minutes(%s::bigint)", (instance,))
    assert cursor.fetchone() == (15,)


def admin(db, cursor):
    assert db.catalog("Пользователи") and db.history(1)
    cursor.execute("INSERT INTO delay_reason(reason_name) VALUES ('ПР11 контроль')")
    expect_denial(cursor, "UPDATE status_history SET changed_at = changed_at WHERE FALSE")
    expect_denial(cursor, "UPDATE app_user SET db_login = NULL WHERE FALSE")
    expect_denial(cursor, "CALL sp_change_flight_status(0, 'Отменён', NULL)")


def main():
    config = {
        "host": os.getenv("PGHOST", "127.0.0.1"),
        "port": os.getenv("PGPORT", "5432"),
        "dbname": os.getenv("PGDATABASE", "aviation_monitoring_pr10"),
    }
    for login, role, check in (
        ("test_operator", "Оператор", operator),
        ("test_analyst", "Аналитик", analyst),
        ("test_admin", "Администратор", admin),
    ):
        db = Database(dict(config, user=login, password=getpass(f"{login} — пароль PostgreSQL: ")))
        try:
            assert db.role() == role
            assert db.execute("SELECT SESSION_USER") == [(login,)]
            with db.connection.cursor() as cursor:
                check(db, cursor)
            print(f"PASS: {login} | {role}")
        finally:
            db.connection.rollback()
            db.close()


if __name__ == "__main__":
    main()
