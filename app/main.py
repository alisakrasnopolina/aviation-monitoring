from datetime import date, datetime, time
import tkinter as tk
from tkinter import messagebox, ttk

from psycopg2 import Error
from psycopg2.sql import SQL, Identifier

from db import CATALOGS, Database


STATUSES = ("Запланирован", "Вылетел", "Выполнен", "Отменён")
TIME_FORMAT = "%Y-%m-%d %H:%M"
FIELDS = {
    "airport_code": "Код аэропорта", "airport_name": "Аэропорт", "city": "Город",
    "airline_code": "Код авиакомпании", "airline_name": "Авиакомпания",
    "flight_number": "Номер рейса", "airline_id": "ID авиакомпании",
    "departure_airport_id": "ID аэропорта вылета", "arrival_airport_id": "ID аэропорта прилёта",
    "reason_name": "Причина", "description": "Описание", "login": "Логин приложения",
    "last_name": "Фамилия", "first_name": "Имя", "middle_name": "Отчество",
    "is_active": "Активен", "role_id": "Роль",
}


def stamp(value):
    return datetime.strptime(value, TIME_FORMAT)


def as_text(value):
    if isinstance(value, datetime):
        return value.strftime(TIME_FORMAT)
    return "" if value is None else str(value)


class Grid:
    def __init__(self, parent, headers):
        frame = ttk.Frame(parent)
        frame.pack(fill="both", expand=True)
        self.tree = ttk.Treeview(frame, columns=list(range(len(headers))), show="headings",
                                 selectmode="browse")
        for i, caption in enumerate(headers):
            self.tree.heading(i, text=caption)
            self.tree.column(i, width=max(88, len(caption) * 8), stretch=True)
        y = ttk.Scrollbar(frame, orient="vertical", command=self.tree.yview)
        x = ttk.Scrollbar(frame, orient="horizontal", command=self.tree.xview)
        self.tree.configure(yscrollcommand=y.set, xscrollcommand=x.set)
        self.tree.grid(row=0, column=0, sticky="nsew")
        y.grid(row=0, column=1, sticky="ns")
        x.grid(row=1, column=0, sticky="ew")
        frame.rowconfigure(0, weight=1)
        frame.columnconfigure(0, weight=1)
        self.rows = []

    def fill(self, rows):
        self.rows = rows
        self.tree.delete(*self.tree.get_children())
        for i, row in enumerate(rows):
            self.tree.insert("", "end", iid=str(i), values=[as_text(value) for value in row])

    def selected(self):
        items = self.tree.selection()
        if not items:
            raise ValueError("Выбери строку в таблице.")
        return self.rows[int(items[0])]


class Application:
    def __init__(self, root):
        self.root = root
        self.db = None
        self.role = None
        root.title("Мониторинг авиарейсов")
        root.geometry("1140x720")
        root.minsize(820, 540)
        style = ttk.Style(root)
        style.theme_use("clam")
        style.configure("Treeview", rowheight=27, background="#ffffff", fieldbackground="#ffffff")
        style.configure("Treeview.Heading", padding=6, background="#dce8f3")
        style.configure("Title.TLabel", font=("Segoe UI", 19, "bold"), foreground="#173950")
        style.configure("TButton", padding=(9, 6))
        self.base = ttk.Frame(root, padding=18)
        self.base.pack(fill="both", expand=True)
        self.login()

    def reset_view(self):
        for widget in self.base.winfo_children():
            widget.destroy()

    def guarded(self, action):
        def run():
            try:
                action()
            except (Error, ValueError) as exc:
                details = exc.diag.message_primary if isinstance(exc, Error) else str(exc)
                messagebox.showerror("Операция не выполнена", details or str(exc), parent=self.root)
        return run

    def button(self, parent, title, action):
        ttk.Button(parent, text=title, command=self.guarded(action)).pack(side="left", padx=(0, 7))

    def login(self):
        self.reset_view()
        ttk.Label(self.base, text="Мониторинг авиарейсов", style="Title.TLabel").pack(pady=(25, 16))
        form = ttk.Frame(self.base)
        form.pack()
        inputs = {}
        for i, (name, label, default) in enumerate((
            ("host", "Сервер", "127.0.0.1"), ("port", "Порт", "5432"),
            ("dbname", "База данных", "aviation_monitoring_pr10"),
            ("user", "Пользователь PostgreSQL", "test_operator"), ("password", "Пароль", ""),
        )):
            ttk.Label(form, text=label).grid(row=i, column=0, sticky="w", padx=8, pady=5)
            entry = ttk.Entry(form, width=34, show="*" if name == "password" else "")
            entry.insert(0, default)
            entry.grid(row=i, column=1, pady=5)
            inputs[name] = entry

        def sign_in():
            db = Database({key: entry.get() for key, entry in inputs.items()})
            try:
                role = db.role()
                if role not in ("Оператор", "Аналитик", "Администратор"):
                    raise ValueError("Для подключения требуется активная связанная учётная запись приложения.")
            except (Error, ValueError):
                db.close()
                raise
            self.db, self.role = db, role
            self.dashboard(inputs["user"].get())

        actions = ttk.Frame(self.base)
        actions.pack(pady=14)
        self.button(actions, "Войти", sign_in)
        inputs["password"].focus_set()
        inputs["password"].bind("<Return>", lambda _: self.guarded(sign_in)())

    def dashboard(self, user):
        self.reset_view()
        head = ttk.Frame(self.base)
        head.pack(fill="x", pady=(0, 10))
        ttk.Label(head, text="Мониторинг авиарейсов", style="Title.TLabel").pack(side="left")
        ttk.Button(head, text="Выйти", command=self.logout).pack(side="right")
        ttk.Label(head, text=f"{self.role} · {user}").pack(side="right", padx=14)
        tabs = ttk.Notebook(self.base)
        tabs.pack(fill="both", expand=True)
        flights = ttk.Frame(tabs, padding=10)
        tabs.add(flights, text="Выполнения рейсов")
        self.flight_tab(flights)
        if self.role in ("Аналитик", "Администратор"):
            stats = ttk.Frame(tabs, padding=10)
            tabs.add(stats, text="Статистика")
            self.stats_tab(stats)
        if self.role == "Администратор":
            catalog = ttk.Frame(tabs, padding=10)
            tabs.add(catalog, text="Справочники и пользователи")
            self.catalog_tab(catalog)

    def logout(self):
        self.db.close()
        self.db = None
        self.login()

    def dialog(self, title, fields, submit):
        popup = tk.Toplevel(self.root)
        popup.title(title)
        popup.transient(self.root)
        body = ttk.Frame(popup, padding=14)
        body.pack(fill="both", expand=True)
        values = []
        for i, (label, initial, choices) in enumerate(fields):
            ttk.Label(body, text=label).grid(row=i, column=0, sticky="w", padx=(0, 10), pady=5)
            value = tk.StringVar(value=as_text(initial))
            values.append(value)
            if choices is None:
                widget = ttk.Entry(body, textvariable=value, width=37)
            else:
                widget = ttk.Combobox(body, textvariable=value, values=choices,
                                      state="readonly", width=35)
            widget.grid(row=i, column=1, sticky="ew", pady=5)

        def finish():
            try:
                submit([v.get().strip() for v in values])
            except (ValueError, Error) as exc:
                detail = exc.diag.message_primary if isinstance(exc, Error) else str(exc)
                messagebox.showerror("Операция не выполнена", detail or str(exc), parent=popup)
                return
            popup.destroy()

        ttk.Button(body, text="Сохранить", command=finish).grid(row=len(fields), column=1, sticky="e", pady=8)
        popup.grab_set()

    def flight_tab(self, frame):
        filter_row = ttk.Frame(frame)
        filter_row.pack(fill="x", pady=(0, 8))
        widgets = []
        for label, width in (("Рейс, перевозчик, аэропорт", 19), ("Статус", 16),
                             ("Дата с, ГГГГ-ММ-ДД", 12), ("Дата по, включительно", 12), ("Задержка", 12)):
            group = ttk.Frame(filter_row)
            group.pack(side="left", padx=(0, 9))
            ttk.Label(group, text=label).pack(anchor="w")
            choices = {"Статус": ("", *STATUSES), "Задержка": ("", "Есть", "Нет")}
            widget = (ttk.Combobox(group, state="readonly", values=choices[label], width=width)
                      if label in choices else ttk.Entry(group, width=width))
            widget.pack()
            widgets.append(widget)
        actions = ttk.Frame(frame)
        actions.pack(fill="x", pady=(0, 7))
        total = tk.StringVar()
        ttk.Label(actions, textvariable=total).pack(side="right")
        grid = Grid(frame, ("ID", "Рейс", "Маршрут", "Статус", "Вылет по плану", "Прилёт по плану",
                            "Факт. вылет", "Факт. прилёт", "ID задержки", "Причина"))

        def load():
            search, status, first, last, delay_filter = (w.get().strip() for w in widgets)
            start = date.fromisoformat(first) if first else None
            end = date.fromisoformat(last) if last else None
            if start and end and start > end:
                raise ValueError("Дата «с» должна быть не позже даты «по».")
            rows = self.db.flights(search, status, start, end, {"Есть": True, "Нет": False}.get(delay_filter))
            grid.fill(rows)
            total.set(f"Выполнений: {len(rows)}")

        self.button(filter_row, "Найти", load)
        plan = ("Плановый вылет (ГГГГ-ММ-ДД ЧЧ:ММ)", "Плановый прилёт (ГГГГ-ММ-ДД ЧЧ:ММ)")

        def register():
            rows = self.db.execute("""
                SELECT flight_id, a.airline_code || f.flight_number
                FROM flight f JOIN airline a USING (airline_id) ORDER BY 1
            """)
            choices = {f"{key} · {number}": key for key, number in rows}

            def submit(values):
                key, departure, arrival = values
                if key not in choices:
                    raise ValueError("Выбери рейс.")
                self.db.register(choices[key], stamp(departure), stamp(arrival))
                load()
            self.dialog("Регистрация выполнения",
                        [("Рейс", "", tuple(choices)), (plan[0], "", None), (plan[1], "", None)], submit)

        def edit():
            row = grid.selected()

            def submit(values):
                self.db.schedule(row[0], *map(stamp, values))
                load()
            self.dialog("Корректировка планового времени",
                        [(plan[0], row[4], None), (plan[1], row[5], None)], submit)

        def transition():
            row = grid.selected()
            options = {"Запланирован": ("Вылетел", "Отменён"), "Вылетел": ("Выполнен",)}.get(row[3])
            if not options:
                raise ValueError("Для выбранного состояния переходов больше нет.")

            def submit(values):
                status, event = values
                if status == "Отменён" and event:
                    raise ValueError("Для отмены оставь время события пустым.")
                self.db.change(row[0], status, None if status == "Отменён" else stamp(event))
                load()
            self.dialog("Смена состояния",
                        [("Новое состояние", options[0], options),
                         ("Фактическое время (ГГГГ-ММ-ДД ЧЧ:ММ)", "", None)], submit)

        def set_reason():
            row = grid.selected()
            if row[8] is None:
                raise ValueError("Для этого выполнения задержка не зарегистрирована.")
            reasons = {"Не указана": None}
            reasons.update({f"{name} · {key}": key for key, name in
                            self.db.execute("SELECT reason_id, reason_name FROM delay_reason ORDER BY 2")})
            current = next((name for name in reasons if name.rpartition(" · ")[0] == row[9]),
                           "Не указана")

            def submit(values):
                self.db.reason(row[8], reasons[values[0]])
                load()
            self.dialog("Причина задержки", [("Причина", current, tuple(reasons))], submit)

        def history():
            row = grid.selected()
            popup = tk.Toplevel(self.root)
            popup.title(f"История выполнения {row[0]}")
            popup.geometry("690x400")
            Grid(popup, ("Время записи", "Предыдущий статус", "Новый статус", "Автор")).fill(
                self.db.history(row[0]))

        if self.role == "Оператор":
            for label, action in (("Зарегистрировать", register), ("Изменить план", edit),
                                  ("Сменить статус", transition), ("Причина задержки", set_reason)):
                self.button(actions, label, action)
        elif self.role == "Администратор":
            self.button(actions, "История состояний", history)
        self.guarded(load)()

    def stats_tab(self, frame):
        filters = ttk.Frame(frame)
        filters.pack(fill="x")
        dates = []
        for label, value in (("С (включительно)", "2025-01-01"), ("До (исключая дату)", "2025-02-01")):
            ttk.Label(filters, text=label).pack(side="left", padx=5)
            entry = ttk.Entry(filters, width=12)
            entry.insert(0, value)
            entry.pack(side="left", padx=5)
            dates.append(entry)
        tabs = ttk.Notebook(frame)
        tabs.pack(fill="both", expand=True, pady=10)
        grids = []
        for title, headers in (
            ("Итоги", ("Всего", "Выполнено", "Задержано", "Доля, %", "Среднее, мин", "Мин.", "Макс.")),
            ("Авиакомпании", ("Код", "Авиакомпания", "Выполнено", "Задержано", "Доля, %", "Среднее, мин")),
            ("Причины задержек", ("Причина", "Количество")),
            ("Состояния", ("Статус", "Количество")),
        ):
            tab = ttk.Frame(tabs, padding=5)
            tabs.add(tab, text=title)
            grids.append(Grid(tab, headers))

        def load():
            start, end = (datetime.combine(date.fromisoformat(e.get()), time.min) for e in dates)
            if start >= end:
                raise ValueError("Начало периода должно быть раньше окончания.")
            for grid, rows in zip(grids, self.db.stats(start, end)):
                grid.fill(rows)
        self.button(filters, "Рассчитать", load)
        self.guarded(load)()

    def catalog_tab(self, frame):
        tabs = ttk.Notebook(frame)
        tabs.pack(fill="both", expand=True)
        for title, (_, _, fields) in CATALOGS.items():
            tab = ttk.Frame(tabs, padding=6)
            tabs.add(tab, text=title)
            self.catalog_editor(tab, title, fields)

    def catalog_editor(self, tab, title, fields):
        actions = ttk.Frame(tab)
        actions.pack(fill="x", pady=(0, 7))
        grid = Grid(tab, ("ID", *(FIELDS[f] for f in fields)))

        def load():
            grid.fill(self.db.catalog(title))

        def edit(key=None, current=None):
            options = {}
            references = {
                "airline_id": ("airline", "airline_id", "airline_name"),
                "departure_airport_id": ("airport", "airport_id", "airport_name"),
                "arrival_airport_id": ("airport", "airport_id", "airport_name"),
                "role_id": ("app_role", "role_id", "role_name"),
            }
            for field in fields:
                if field in references:
                    table, ident, caption = references[field]
                    rows = self.db.execute(SQL("SELECT {}, {} FROM {} ORDER BY 2").format(
                        Identifier(ident), Identifier(caption), Identifier(table)))
                    options[field] = {f"{value} · {name}": value for value, name in rows}
            options["is_active"] = {"Да": True, "Нет": False}
            form = []
            for f, value in zip(fields, current or [None] * len(fields)):
                choices = options.get(f)
                initial = (next((label for label, item in choices.items() if item == value), "")
                           if choices else value)
                if f == "is_active" and value is None:
                    initial = "Да"
                form.append((FIELDS[f], initial, tuple(choices) if choices else None))

            def submit(values):
                converted = []
                for f, value in zip(fields, values):
                    if f in options:
                        if value not in options[f]:
                            raise ValueError(f"Заполни поле «{FIELDS[f]}».")
                        converted.append(options[f][value])
                    else:
                        converted.append(value or None)
                self.db.save_catalog(title, tuple(converted), key)
                load()
            self.dialog(title, form, submit)

        def modify():
            key, *current = grid.selected()
            edit(key, current)

        def delete():
            key = grid.selected()[0]
            if messagebox.askyesno("Удалить запись", f"Удалить запись {key}?", parent=self.root):
                self.db.delete_catalog(title, key)
                load()

        for label, action in (("Добавить", edit), ("Изменить", modify),
                              ("Удалить", delete), ("Обновить", load)):
            self.button(actions, label, action)
        self.guarded(load)()


if __name__ == "__main__":
    root = tk.Tk()
    Application(root)
    root.mainloop()
