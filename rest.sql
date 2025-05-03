-- 1. Зоны
CREATE TABLE Зоны
(
    Id SERIAL PRIMARY KEY,
    Название VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO Зоны (Название)
VALUES ('Общая'),
       ('Детская'),
       ('Частная');

-- 2. Столы
CREATE TABLE Столы
(
    Id SERIAL PRIMARY KEY,
    Название VARCHAR(50) NOT NULL UNIQUE,
    Количество_мест INTEGER NOT NULL CHECK (Количество_мест > 0),
    Зона_id INTEGER NOT NULL REFERENCES Зоны (Id) ON DELETE RESTRICT
);
INSERT INTO Столы (Название, Количество_мест, Зона_id)
VALUES ('ОБ1', 4, 1),
       ('ОБ2', 4, 1),
       ('ОБ3', 2, 1),
       ('ОБ4', 2, 1),
       ('Д1', 5, 2),
       ('Д2', 5, 2),
       ('Д3', 5, 2),
       ('Ч1', 4, 3),
       ('Ч2', 2, 3);

-- 3. Официанты
CREATE TABLE Официанты
(
    Id SERIAL PRIMARY KEY,
    Фамилия VARCHAR(50) NOT NULL,
    Имя VARCHAR(50) NOT NULL,
    Отчество VARCHAR(50),
    Логин VARCHAR(50) NOT NULL UNIQUE,
    Пароль VARCHAR(50) NOT NULL
);
INSERT INTO Официанты (Фамилия, Имя, Отчество, Логин, Пароль)
VALUES ('Семёнов', 'Кирилл', 'Николаевич', 'of_SemenovKN', 'Pa$$w0rd'),
       ('Андреев', 'Андрей', 'Алексеевич', 'of_AndreevAA', 'Pa$$w0rd'),
       ('Дмитриев', 'Олег', 'Иванович', 'of_DmitrievOI', 'Pa$$w0rd');

-- 4. Посетители (клиенты)
CREATE TABLE Посетители
(
    Id SERIAL PRIMARY KEY,
    Фамилия VARCHAR(50) NOT NULL,
    Имя VARCHAR(50) NOT NULL,
    Отчество VARCHAR(50),
    Телефон VARCHAR(50) NOT NULL,
    Карта VARCHAR(50),
    Логин VARCHAR(50) NOT NULL UNIQUE,
    Пароль VARCHAR(50) NOT NULL
);
INSERT INTO Посетители (Фамилия, Имя, Отчество, Телефон, Карта, Логин, Пароль)
VALUES ('Иванов', 'Иван', 'Иванович', '45 10 665764', '4825 7731 7788 1752', 'IvanovII', 'Pa$$w0rd'),
       ('Петров', 'Алексей', 'Алексеевич', '46 78 239712', '5652 1147 9921', 'PetrovAA', 'Pa$$w0rd'),
       ('Павлов', 'Евгений', 'Геннадьевич', '45 15 009426', '3134 7742 5677', 'PavlovEG', 'Pa$$w0rd');

-- 5. Поставки и Ингредиенты
CREATE TABLE Поставки
(
    Id SERIAL PRIMARY KEY,
    Номер VARCHAR(50) NOT NULL,
    Дата_Формирования DATE NOT NULL,
    Поставщик VARCHAR(100) NOT NULL,
    Город VARCHAR(100) NOT NULL,
    Улица VARCHAR(100) NOT NULL,
    Дом VARCHAR(50) NOT NULL,
    Строение VARCHAR(50),
    ОКПО VARCHAR(50) NOT NULL
);
INSERT INTO Поставки (Номер, Дата_Формирования, Поставщик, Город, Улица, Дом, Строение, ОКПО)
VALUES ('СП-0000001-23', '2023-09-15', 'ООО «Овощ тут»', 'Москва', 'ул. Тимерязевская', '15', 'стр. 8', '5981561046'),
       ('СП-0000002-23', '2023-09-16', 'ООО «Мясной завод»', 'Москва', 'Нахимоский проспект', '45', 'к. 1',
        '8311967835');

CREATE TABLE Ингредиенты
(
    Id SERIAL PRIMARY KEY,
    Название VARCHAR(100) NOT NULL UNIQUE
);
INSERT INTO Ингредиенты (Название)
VALUES ('Помидоры'),
       ('Капуста'),
       ('Яблоки'),
       ('Говядина'),
       ('Куриные крылья');

CREATE TABLE Ингредиенты_Поставки
(
    Id SERIAL PRIMARY KEY,
    Ингредиент_id INTEGER NOT NULL REFERENCES Ингредиенты (Id) ON DELETE CASCADE,
    Поставка_id INTEGER NOT NULL REFERENCES Поставки (Id) ON DELETE CASCADE,
    Количество DECIMAL(10, 2) NOT NULL CHECK (Количество > 0)
);
INSERT INTO Ингредиенты_Поставки (Ингредиент_id, Поставка_id, Количество)
VALUES (1, 1, 50.00),
       (2, 1, 45.00),
       (3, 1, 30.00),
       (4, 2, 150.00),
       (5, 2, 150.00);

-- 6. Меню и состав блюд
CREATE TABLE Меню
(
    Id SERIAL PRIMARY KEY,
    Название VARCHAR(100) NOT NULL UNIQUE,
    Вес DECIMAL(6, 2) NOT NULL CHECK (Вес > 0),
    Цена DECIMAL(8, 2) NOT NULL CHECK (Цена >= 0)
);
INSERT INTO Меню (Название, Вес, Цена)
VALUES ('Филе порося', 350.00, 950.00),
       ('Суп мечты', 200.00, 750.00),
       ('Гарнир овощной', 250.00, 650.00),
       ('Мясная тарелка', 1200.00, 1670.00),
       ('Как бы здоровое питание', 1100.00, 1500.00),
       ('Картофель по-своему', 120.00, 120.00);

CREATE TABLE Меню_Ингредиенты
(
    Id SERIAL PRIMARY KEY,
    Меню_id INTEGER NOT NULL REFERENCES Меню (Id) ON DELETE CASCADE,
    Ингредиент_id INTEGER NOT NULL REFERENCES Ингредиенты (Id) ON DELETE CASCADE,
    Количество INTEGER NOT NULL CHECK (Количество > 0)
);
INSERT INTO Меню_Ингредиенты (Меню_id, Ингредиент_id, Количество)
VALUES (1, 4, 1),
       (2, 3, 2),
       (3, 1, 1),
       (4, 4, 1),
       (5, 1, 1),
       (6, 1, 2);

-- 7. Заказы и позиции
CREATE TABLE Заказы
(
    Id SERIAL PRIMARY KEY,
    Номер VARCHAR(50) NOT NULL,
    Сотрудник_id INTEGER NOT NULL REFERENCES Официанты (Id) ON DELETE RESTRICT,
    Дата_Время_Открытия TIMESTAMP NOT NULL,
    Стол_id INTEGER NOT NULL REFERENCES Столы (Id) ON DELETE RESTRICT,
    Общая_Стоимость DECIMAL(10, 2) NOT NULL CHECK (Общая_Стоимость >= 0)
);
INSERT INTO Заказы (Номер, Сотрудник_id, Дата_Время_Открытия, Стол_id, Общая_Стоимость)
VALUES ('ЗКЗ-000000001-23', 1, '2023-09-01 14:00:24', 1, 2890.00),
       ('ЗКЗ-000000002-23', 2, '2023-09-01 16:17:37', 2, 1070.00),
       ('ЗКЗ-000000003-23', 3, '2023-09-03 12:10:41', 8, 4570.00),
       ('ЗКЗ-000000004-23', 1, '2023-09-04 16:35:01', 2, 2250.00);

CREATE TABLE Позиции_Заказа
(
    Id SERIAL PRIMARY KEY,
    Заказ_Id INTEGER NOT NULL REFERENCES Заказы (Id) ON DELETE CASCADE,
    Посетитель_Id INTEGER NOT NULL REFERENCES Посетители (Id) ON DELETE RESTRICT,
    Меню_id INTEGER NOT NULL REFERENCES Меню (Id) ON DELETE RESTRICT,
    Количество INTEGER NOT NULL CHECK (Количество > 0),
    Цена DECIMAL(8, 2) NOT NULL CHECK (Цена >= 0),
    Дата_Время_Добавления TIMESTAMP NOT NULL,
    Статус VARCHAR(50) NOT NULL
);
INSERT INTO Позиции_Заказа (Заказ_Id, Посетитель_Id, Меню_id, Количество, Цена, Дата_Время_Добавления, Статус)
VALUES (1, 2, 1, 2, 1900.00, '2023-09-01 14:05:01', 'Выдан'),
       (1, 2, 2, 1, 750.00, '2023-09-01 14:30:34', 'Выдан'),
       (1, 2, 6, 2, 120.00, '2023-09-01 14:30:35', 'Выдан'),
       (2, 3, 6, 1, 120.00, '2023-09-01 16:26:01', 'Выдан'),
       (2, 3, 1, 1, 950.00, '2023-09-01 17:30:16', 'Ожидается'),
       (3, 1, 3, 2, 650.00, '2023-09-03 12:18:27', 'Выдан'),
       (3, 1, 1, 1, 950.00, '2023-09-03 12:20:35', 'Выдан'),
       (3, 1, 3, 1, 650.00, '2023-09-03 12:18:50', 'Выдан'),
       (3, 1, 4, 1, 1670.00, '2023-09-03 14:29:53', 'Выдан'),
       (4, 1, 2, 3, 750.00, '2023-09-04 16:40:36', 'Выдан'),
       (4, 1, 2, 1, 750.00, '2023-09-04 17:20:13', 'Выдан'),
       (4, 1, 2, 1, 750.00, '2023-09-04 19:40:41', 'Выдан');

-- 8. Типы оплаты и чеки
CREATE TABLE Типы_Оплаты
(
    Id SERIAL PRIMARY KEY,
    Название VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO Типы_Оплаты (Название)
VALUES ('Наличный'),
       ('Безналичный');

CREATE TABLE Чеки
(
    Id SERIAL PRIMARY KEY,
    Номер VARCHAR(50) NOT NULL,
    Дата_Время TIMESTAMP NOT NULL,
    Общая_Стоимость DECIMAL(10, 2) NOT NULL CHECK (Общая_Стоимость >= 0),
    Внесено DECIMAL(10, 2) NOT NULL CHECK (Внесено >= 0),
    Сдача DECIMAL(10, 2) NOT NULL CHECK (Сдача >= 0),
    Заказ_Id INTEGER NOT NULL REFERENCES Заказы (Id) ON DELETE RESTRICT,
    Тип_Оплаты_id INTEGER NOT NULL REFERENCES Типы_Оплаты (Id) ON DELETE RESTRICT
);
INSERT INTO Чеки (Номер, Дата_Время, Общая_Стоимость, Внесено, Сдача, Заказ_Id, Тип_Оплаты_id)
VALUES ('КЧ-0000001/23', '2023-09-01 18:56:54', 3468.00, 3500.00, 32.00, 1, 1),
       ('КЧ-0000002/23', '2023-09-03 15:21:47', 5484.00, 5484.00, 0.00, 3, 2),
       ('КЧ-0000003/23', '2023-09-04 20:02:52', 2700.00, 3000.00, 300.00, 4, 1);

-- 9. Система бронирования

-- Основная таблица брони
CREATE TABLE reservations
(
    Id SERIAL PRIMARY KEY,
    reservation_code TEXT NOT NULL UNIQUE CHECK (reservation_code ~ '^БР/\\d{2}/\\d{10}$'),
visitor_id INTEGER NOT NULL REFERENCES Посетители (Id) ON DELETE RESTRICT,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
visit_date DATE NOT NULL,
visit_time TIME NOT NULL,
guest_count INTEGER NOT NULL CHECK (guest_count > 0),
CHECK ( (visit_date + visit_time) >= created_at )
);

CREATE OR REPLACE FUNCTION trg_check_serve_time()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
v_visit_time TIME;
BEGIN
-- Получаем время визита из таблицы reservations
SELECT visit_time
INTO v_visit_time
FROM reservations
WHERE Id = NEW.reservation_id;

-- Проверяем условие
IF NEW.serve_time > v_visit_time THEN
RAISE EXCEPTION
'Время подачи блюда (%) позже времени визита (%)',
NEW.serve_time, v_visit_time;
END IF;

RETURN NEW;
END;
$$;


-- Связь брони и столов
-- 1) Таблица связи брони и столов
DROP TABLE IF EXISTS reservation_tables;
CREATE TABLE reservation_tables (
                                    Id SERIAL PRIMARY KEY,
                                    reservation_id INTEGER NOT NULL
                                        REFERENCES reservations(Id) ON DELETE CASCADE,
                                    table_id INTEGER NOT NULL
                                        REFERENCES "Столы"(Id) ON DELETE RESTRICT,
-- для сохранения уникальности сочетания брони+стола
                                    UNIQUE (reservation_id, table_id)
);

-- 2) Таблица предварительного меню брони
DROP TABLE IF EXISTS reservation_dishes;
CREATE TABLE reservation_dishes (
                                    Id SERIAL PRIMARY KEY,
                                    reservation_id INTEGER NOT NULL
                                        REFERENCES reservations(Id) ON DELETE CASCADE,
                                    dish_id INTEGER NOT NULL
                                        REFERENCES "Меню"(Id) ON DELETE RESTRICT,
                                    quantity INTEGER NOT NULL CHECK (quantity > 0),
                                    serve_time TIME NOT NULL,
-- чтобы не повторять одно и то же блюдо в одно и то же время
                                    UNIQUE (reservation_id, dish_id, serve_time)
);




-- 2) Функция добавления брони
-- ==========================
CREATE OR REPLACE FUNCTION add_reservation(
p_code TEXT, -- код брони, формат БР/00/0000000000
p_visitor_id INTEGER, -- ссылка на Посетители(Id)
p_visit_date DATE,
p_visit_time TIME,
p_guest_count INTEGER,
p_table_ids INTEGER[], -- массив Столы(Id)
p_dishes JSONB -- [{"dish_id":<Id>, "quantity":<N>, "serve_time":"HH24:MI"}…]
) RETURNS VOID AS
$$
DECLARE
v_res_id INTEGER;
v_total_seats INTEGER := 0;
v_qty INTEGER;
t_id INTEGER;
dish JSONB;
serve_at TIME;
d_id INTEGER;
d_qty INTEGER;
BEGIN
-- 1) Проверка корректности времени визита
IF (p_visit_date + p_visit_time) < CURRENT_TIMESTAMP THEN
RAISE EXCEPTION
'Время визита (%) не может быть раньше текущего (%)',
p_visit_date + p_visit_time, CURRENT_TIMESTAMP;
END IF;

-- 2) Создаём саму бронь и получаем её PK
INSERT INTO reservations (reservation_code,
                          visitor_id,
                          created_at,
                          visit_date,
                          visit_time,
                          guest_count)
VALUES (p_code,
        p_visitor_id,
        CURRENT_TIMESTAMP,
        p_visit_date,
        p_visit_time,
        p_guest_count)
    RETURNING Id INTO v_res_id;

-- 3) Подсчёт мест и заполнение reservation_tables
FOREACH t_id IN ARRAY p_table_ids
LOOP
SELECT "Количество_мест"
INTO v_qty
FROM "Столы"
WHERE Id = t_id;

v_total_seats := v_total_seats + v_qty;

INSERT INTO reservation_tables (reservation_id, table_id)
VALUES (v_res_id, t_id);
END LOOP;

IF p_guest_count > v_total_seats THEN
RAISE EXCEPTION
'Гостей (%) больше мест (%)',
p_guest_count, v_total_seats;
END IF;

-- 4) Заполнение reservation_dishes из JSONB
FOR dish IN SELECT * FROM jsonb_array_elements(p_dishes)
                              LOOP
    serve_at := (dish ->> 'serve_time')::TIME;
d_id := (dish ->> 'dish_id')::INTEGER;
d_qty := (dish ->> 'quantity')::INTEGER;

IF serve_at > p_visit_time THEN
RAISE EXCEPTION
'Время подачи (%) позже визита (%)',
serve_at, p_visit_time;
END IF;

INSERT INTO reservation_dishes (reservation_id,
                                dish_id,
                                quantity,
                                serve_time)
VALUES (v_res_id,
        d_id,
        d_qty,
        serve_at);
END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_serve_time_trigger
    BEFORE INSERT OR UPDATE ON reservation_dishes
                         FOR EACH ROW
                         EXECUTE FUNCTION trg_check_serve_time();



CREATE OR REPLACE FUNCTION add_table_if_not_exists(p_name VARCHAR)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
v_found BOOLEAN;
BEGIN
SELECT EXISTS(
    SELECT 1 FROM "Столы" WHERE "Название" = p_name
) INTO v_found;

IF v_found THEN
RAISE EXCEPTION 'Указанный стол уже есть в таблице!';
END IF;

-- примерная вставка, можно подставить реальные параметры
INSERT INTO "Столы"(Название, Количество_мест, Зона_id)
VALUES (p_name, 4, 1);
END;
$$;

SELECT add_table_if_not_exists('Д2');
-- ERROR: Указанный стол уже есть в таблице!




CREATE OR REPLACE FUNCTION generate_reservation_code(p_dt TIMESTAMP)
RETURNS TEXT LANGUAGE plpgsql AS $$
DECLARE
yy TEXT := to_char(p_dt, 'YY');
seq INTEGER;
BEGIN
SELECT COALESCE(
               MAX((substring(reservation_code FROM 5 FOR 10))::INTEGER),
               0
       ) + 1
INTO seq
FROM reservations
WHERE to_char(created_at, 'YY') = yy;

RETURN format('БР/%s/%010s', yy, seq);
END;
$$;

-- Получаем Id стола и посетителя по их логинам/названиям
WITH params AS (
    SELECT
        '2024-03-01 10:10:10'::TIMESTAMP AS dt,
            ARRAY[(SELECT Id FROM "Столы" WHERE "Название"='ОБ2')] AS tables,
        (SELECT Id FROM "Посетители" WHERE "Логин"='IvanovII') AS visitor,
        '2024-03-02 11:11:00'::TIMESTAMP AS visit_dt
)
SELECT
    add_reservation_auto_code(
            params.dt,
            params.tables,
            params.visitor,
            params.visit_dt,
            1
    ) AS new_code
FROM params;
-- new_code = 'БР/24/0000000004'



CREATE OR REPLACE FUNCTION delete_ingredient_safe(p_name VARCHAR)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
v_id INTEGER;
v_used BOOLEAN;
BEGIN
SELECT Id INTO v_id
FROM "Ингредиенты"
WHERE "Название" = p_name;
IF NOT FOUND THEN
RAISE EXCEPTION 'Ингредиент «%» не найден', p_name;
END IF;

SELECT EXISTS(
    SELECT 1
    FROM "Меню_Ингредиенты"
    WHERE "Ингредиент_id" = v_id
) INTO v_used;

IF v_used THEN
RAISE EXCEPTION
'Выбранный ингредиент невозможно удалить, так как к нему привязано блюдо.';
END IF;

DELETE FROM "Ингредиенты" WHERE Id = v_id;
END;
$$;


SELECT delete_ingredient_safe('Перец');
-- ERROR: Выбранный ингредиент невозможно удалить, так как к нему привязано блюдо.



CREATE OR REPLACE FUNCTION add_menu_ingredient_safe(
p_menu_name VARCHAR,
p_ingredient_name VARCHAR,
p_qty INTEGER
) RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
v_menu_id INTEGER;
v_ingr_id INTEGER;
v_exists BOOLEAN;
BEGIN
SELECT Id INTO v_menu_id FROM "Меню" WHERE "Название" = p_menu_name;
SELECT Id INTO v_ingr_id FROM "Ингредиенты" WHERE "Название" = p_ingredient_name;

SELECT EXISTS(
    SELECT 1
    FROM "Меню_Ингредиенты"
    WHERE "Меню_id" = v_menu_id
      AND "Ингредиент_id" = v_ingr_id
) INTO v_exists;

IF v_exists THEN
RAISE EXCEPTION 'Указанный ингредиент уже есть у указанного блюда.';
END IF;

INSERT INTO "Меню_Ингредиенты"(Меню_id, Ингредиент_id, Количество)
VALUES (v_menu_id, v_ingr_id, p_qty);
END;
$$;


SELECT add_menu_ingredient_safe('Суп мечты', 'Огурцы', 1);
-- ERROR: Указанный ингредиент уже есть у указанного блюда.


CREATE OR REPLACE FUNCTION add_order_item_and_recalc(
p_order_number VARCHAR,
p_dish_name VARCHAR,
p_qty INTEGER
) RETURNS NUMERIC LANGUAGE plpgsql AS $$
DECLARE
v_order_id INTEGER;
v_old_total NUMERIC;
v_menu_id INTEGER;
v_price NUMERIC;
v_new_total NUMERIC;
v_visitor_id INTEGER;
BEGIN
-- 1) Найти заказ и старую сумму
SELECT Id, Общая_Стоимость
INTO v_order_id, v_old_total
FROM "Заказы"
WHERE Номер = p_order_number;

-- 2) Найти блюдо и его цену
SELECT Id, Цена
INTO v_menu_id, v_price
FROM "Меню"
WHERE "Название" = p_dish_name;

-- 3) Выбрать любого посетителя из уже существующих позиций (или null)
SELECT Посетитель_Id INTO v_visitor_id
FROM "Позиции_Заказа"
WHERE Заказ_Id = v_order_id
    LIMIT 1;

-- 4) Добавить новую позицию
INSERT INTO "Позиции_Заказа"(
    Заказ_Id, Посетитель_Id, Меню_id,
    Количество, Цена, Дата_Время_Добавления, Статус
) VALUES (
             v_order_id, v_visitor_id, v_menu_id,
             p_qty, v_price * p_qty, CURRENT_TIMESTAMP, 'Ожидается'
         );

-- 5) Пересчитать и обновить общую стоимость
v_new_total := v_old_total + v_price * p_qty;
UPDATE "Заказы"
SET Общая_Стоимость = v_new_total
WHERE Id = v_order_id;

RETURN v_new_total;
END;
$$;



SELECT add_order_item_and_recalc(
               'ЗКЗ-000000001-23',
               'Как бы здоровое питание',
               1
       ) AS updated_total;
-- updated_total = 4390.00


-- Запросы


SELECT
    m.Название,
    m.Цена,
    m.Вес,
    COUNT(mi.Ингредиент_id) AS Количество_ингредиентов
FROM Меню m
         JOIN Меню_Ингредиенты mi ON m.Id = mi.Меню_id
GROUP BY m.Id, m.Название, m.Цена, m.Вес;

SELECT
    p.Фамилия || ' ' || p.Имя || ' ' || COALESCE(p.Отчество, '') AS ФИО,
    ROUND(AVG(z.Общая_Стоимость), 2) AS Средняя_стоимость
FROM Посетители p
         JOIN Позиции_Заказа pz ON p.Id = pz.Посетитель_Id
         JOIN Заказы z ON pz.Заказ_Id = z.Id
GROUP BY p.Id, p.Фамилия, p.Имя, p.Отчество;

SELECT
    o.Фамилия || ' ' || o.Имя || ' ' || COALESCE(o.Отчество, '') AS Сотрудник,
    p.Фамилия || ' ' || p.Имя || ' ' || COALESCE(p.Отчество, '') AS Клиент,
    z.Номер AS Номер_заказа
FROM Заказы z
         JOIN Официанты o ON z.Сотрудник_id = o.Id
         JOIN Позиции_Заказа pz ON z.Id = pz.Заказ_Id
         JOIN Посетители p ON pz.Посетитель_Id = p.Id;

SELECT
    Название,
    Вес,
    Цена,
    LENGTH(Название) AS Длина_названия
FROM Меню;

SELECT UPPER(Название) AS Название_в_верхнем_регистре
FROM Меню;

SELECT
    reservation_code AS Номер_брони,
    TO_CHAR(created_at, 'ГГ: YY, Месяц: MM, День: DD') AS Дата_формирования
FROM reservations;

SELECT
    reservation_code AS Номер_брони,
    visit_date AS Дата_посещения,
    visit_date + INTERVAL '21 days' AS Дата_отмены
FROM reservations;

SELECT
    p.Фамилия || ' ' || p.Имя AS ФИО,
    ch.Номер AS Номер_чека,
    ch.Дата_Время AS Дата_чека,
    r.reservation_code AS Номер_брони,
    r.created_at AS Дата_брони,
    EXTRACT(EPOCH FROM (r.created_at - ch.Дата_Время)) / 3600 AS Разница_в_часах
FROM Чеки ch
         JOIN Заказы z ON ch.Заказ_Id = z.Id
         JOIN Позиции_Заказа pz ON z.Id = pz.Заказ_Id
         JOIN Посетители p ON pz.Посетитель_Id = p.Id
         JOIN reservations r ON p.Id = r.visitor_id;

SELECT Название, Цена
FROM Меню
WHERE Цена = (SELECT MAX(Цена) FROM Меню);

SELECT
    z.Номер AS Номер_заказа,
    o.Фамилия || ' ' || o.Имя AS Сотрудник,
    ROW_NUMBER() OVER (PARTITION BY z.Id ORDER BY pz.Id) AS Номер_позиции,
        m.Название AS Название_блюда
FROM Заказы z
         JOIN Официанты o ON z.Сотрудник_id = o.Id
         JOIN Позиции_Заказа pz ON z.Id = pz.Заказ_Id
         JOIN Меню m ON pz.Меню_id = m.Id;

SELECT
    m.Название,
    COUNT(pz.Меню_id) AS Количество_заказов
FROM Позиции_Заказа pz
         JOIN Меню m ON pz.Меню_id = m.Id
GROUP BY m.Id, m.Название
ORDER BY Количество_заказов ASC
    LIMIT 3;

SELECT
    o.Фамилия || ' ' || o.Имя AS Сотрудник,
    SUM(z.Общая_Стоимость) AS Общая_сумма
FROM Заказы z
         JOIN Официанты o ON z.Сотрудник_id = o.Id
GROUP BY o.Id, o.Фамилия, o.Имя;

SELECT
    Название,
    ROUND(Цена * 1.2, 2) AS Цена_с_НДС
FROM Меню;

SELECT
    z.Номер AS Номер_заказа,
    z.Дата_Время_Открытия,
    STRING_AGG(m.Название || ' (' || pz.Количество || ' шт.)', ', ') AS Позиции
FROM Заказы z
         JOIN Позиции_Заказа pz ON z.Id = pz.Заказ_Id
         JOIN Меню m ON pz.Меню_id = m.Id
GROUP BY z.Номер, z.Дата_Время_Открытия;

SELECT
    SUBSTR(Номер, 4) AS Номер_чека_без_КЧ
FROM Чеки;

SELECT LOWER(Название) AS Ингредиенты_в_нижнем_регистре
FROM Ингредиенты;

SELECT
    Номер AS Номер_заказа,
    EXTRACT(DAY FROM Дата_Время_Открытия) AS День,
    EXTRACT(MONTH FROM Дата_Время_Открытия) AS Месяц,
    EXTRACT(HOUR FROM Дата_Время_Открытия) AS Час
FROM Заказы;

SELECT
    z.Номер AS Номер_заказа,
    m.Название AS Название_блюда,
    EXTRACT(EPOCH FROM (pz.Дата_Время_Добавления - z.Дата_Время_Открытия)) / 60 AS Разница_в_минутах
FROM Позиции_Заказа pz
         JOIN Заказы z ON pz.Заказ_Id = z.Id
         JOIN Меню m ON pz.Меню_id = m.Id;

SELECT
    m.Название,
    m.Вес,
    m.Цена,
    i.Название AS Ингредиент,
    CASE
        WHEN EXISTS (SELECT 1 FROM файлы WHERE файлы.Меню_id = m.Id) THEN 'Файл_присутствует'
        ELSE 'Файл_отсутствует'
        END AS Статус_файла
FROM Меню m
         JOIN Меню_Ингредиенты mi ON m.Id = mi.Меню_id
         JOIN Ингредиенты i ON mi.Ингредиент_id = i.Id;

SELECT
    z.Номер AS Номер_заказа,
    p.Фамилия || ' ' || p.Имя AS ФИО
FROM Заказы z
         JOIN Позиции_Заказа pz ON z.Id = pz.Заказ_Id
         JOIN Посетители p ON pz.Посетитель_Id = p.Id
WHERE z.Общая_Стоимость = (SELECT MIN(Общая_Стоимость) FROM Заказы);

SELECT DISTINCT Название
FROM Ингредиенты;

SELECT
    o.Фамилия || ' ' || o.Имя AS Сотрудник,
    COUNT(z.Id) AS Количество_заказов,
    ROUND(SUM(z.Общая_Стоимость * 0.15 * 0.87), 2) AS Зарплата
FROM Заказы z
         JOIN Официанты o ON z.Сотрудник_id = o.Id
GROUP BY o.Id, o.Фамилия, o.Имя;

-- Еще запросы

SELECT
    z.Номер AS Номер_заказа,
    z.Дата_Время_Открытия AS Дата_создания,
    s.Название AS Номер_стола,
    o.Фамилия || ' ' || o.Имя AS ФИО_сотрудника
FROM Заказы z
         JOIN Официанты o ON z.Сотрудник_id = o.Id
         JOIN Столы s ON z.Стол_id = s.Id
WHERE o.Логин = 'of_SemenovKN';

SELECT
    pz.Заказ_Id AS Номер_заказа,
    m.Название AS Название_блюда,
    pz.Количество
FROM Позиции_Заказа pz
         JOIN Меню m ON pz.Меню_id = m.Id
WHERE pz.Количество < 3;

SELECT
    p.Фамилия || ' ' || p.Имя AS ФИО,
    p.Логин,
    p.Пароль
FROM Посетители p
WHERE p.Телефон LIKE '45%';

SELECT
    m.Название AS Название_блюда,
    m.Цена,
    i.Название AS Ингредиент
FROM Меню m
         JOIN Меню_Ингредиенты mi ON m.Id = mi.Меню_id
         JOIN Ингредиенты i ON mi.Ингредиент_id = i.Id
WHERE i.Название IN ('Лук', 'Перец', 'Морковь');

SELECT
    Название,
    Вес,
    Цена
FROM Меню
WHERE Вес BETWEEN 100 AND 500;

SELECT
    z.Номер AS Номер_заказа,
    o.Фамилия || ' ' || o.Имя AS ФИО_сотрудника,
    m.Название AS Название_позиции,
    pz.Количество
FROM Заказы z
         JOIN Официанты o ON z.Сотрудник_id = o.Id
         JOIN Позиции_Заказа pz ON z.Id = pz.Заказ_Id
         JOIN Меню m ON pz.Меню_id = m.Id
         JOIN Чеки ch ON z.Id = ch.Заказ_Id
WHERE ch.Сдача != 0
  AND pz.Количество > 1
  AND o.Логин = 'of_SemenovKN';

SELECT
    m.Название,
    m.Вес,
    m.Цена
FROM Меню m
WHERE NOT EXISTS (
    SELECT 1
    FROM Меню_Ингредиенты mi
             JOIN Ингредиенты i ON mi.Ингредиент_id = i.Id
    WHERE mi.Меню_id = m.Id AND i.Название = 'Морковь'
);

SELECT
    p.Номер AS Номер_сметы,
    p.Поставщик,
    i.Название AS Ингредиент
FROM Поставки p
         JOIN Ингредиенты_Поставки ip ON p.Id = ip.Поставка_id
         JOIN Ингредиенты i ON ip.Ингредиент_id = i.Id
WHERE ip.Количество >= 50.00;

SELECT
    p.Фамилия || ' ' || p.Имя AS ФИО,
    p.Карта
FROM Посетители p
WHERE p.Карта NOT LIKE '%77%';

SELECT
    z.Номер AS Номер_заказа,
    p.Фамилия || ' ' || p.Имя AS ФИО_клиента,
    o.Фамилия || ' ' || o.Имя AS ФИО_сотрудника,
    s.Название AS Номер_стола
FROM Заказы z
         JOIN Посетители p ON z.Стол_id = p.Id
         JOIN Официанты o ON z.Сотрудник_id = o.Id
         JOIN Столы s ON z.Стол_id = s.Id
WHERE s.Название NOT IN ('ОБ3', 'ОБ4', 'ОБ5', 'Ч1');

SELECT
    r.reservation_code AS Номер_брони,
    p.Фамилия || ' ' || p.Имя AS ФИО_клиента,
    r.visit_date AS Дата_посещения
FROM reservations r
         JOIN Посетители p ON r.visitor_id = p.Id
WHERE r.guest_count < 2 OR r.guest_count > 5;

SELECT
    m.Название,
    i.Название AS Ингредиент,
    m.Вес,
    CASE
        WHEN m.Вес BETWEEN 0 AND 250 THEN 'Лёгкое блюдо'
        WHEN m.Вес BETWEEN 251 AND 750 THEN 'Средней тяжести'
        ELSE 'Тяжёлое'
        END AS Категория
FROM Меню m
         JOIN Меню_Ингредиенты mi ON m.Id = mi.Меню_id
         JOIN Ингредиенты i ON mi.Ингредиент_id = i.Id;


CREATE VIEW first_task_first_table AS
SELECT
    z.Название AS Зона,
    COUNT(s.Id) AS Количество_столов,
    SUM(s.Количество_мест) AS Общее_количество_мест
FROM Зоны z
         JOIN Столы s ON z.Id = s.Зона_id
GROUP BY z.Название;

SELECT * FROM first_task_first_table;

CREATE VIEW first_task_second_table AS
SELECT
    o.Фамилия || ' ' || o.Имя || ' ' || COALESCE(o.Отчество, '') AS ФИО_сотрудника,
    o.Логин AS Логин_сотрудника,
    p.Фамилия || ' ' || p.Имя || ' ' || COALESCE(p.Отчество, '') AS ФИО_клиента,
    p.Логин AS Логин_клиента,
    p.Пароль AS Пароль_клиента
FROM Официанты o
         CROSS JOIN Посетители p;

SELECT * FROM first_task_second_table;

-- дальше просто рандом названия, сортировать сложно

CREATE VIEW bxodhble_aanhble_3 AS
SELECT
    z.Номер AS Номер_заказа,
    o.Фамилия || ' ' || o.Имя AS Сотрудник,
    p.Фамилия || ' ' || p.Имя AS Клиент,
    m.Название AS Блюдо,
    pz.Количество,
    m.Цена,
    pz.Количество * m.Цена AS Сумма_позиции,
    z.Общая_Стоимость
FROM Заказы z
         JOIN Официанты o ON z.Сотрудник_id = o.Id
         JOIN Позиции_Заказа pz ON z.Id = pz.Заказ_Id
         JOIN Посетители p ON pz.Посетитель_Id = p.Id
         JOIN Меню m ON pz.Меню_id = m.Id;

SELECT * FROM bxodhble_aanhble_3;

CREATE VIEW bxodhble_aanhble_4 AS
SELECT
    r.reservation_code AS Номер_брони,
    p.Фамилия || ' ' || p.Имя AS Клиент,
    s.Название AS Стол,
    m.Название AS Блюдо,
    rd.quantity AS Количество,
    rd.serve_time AS Время_подачи
FROM reservations r
         JOIN Посетители p ON r.visitor_id = p.Id
         JOIN reservation_tables rt ON r.Id = rt.reservation_id
         JOIN Столы s ON rt.table_id = s.Id
         JOIN reservation_dishes rd ON r.Id = rd.reservation_id
         JOIN Меню m ON rd.dish_id = m.Id;

SELECT * FROM bxodhble_aanhble_4;

CREATE VIEW bxodhble_aanhble_5 AS
SELECT
    z.Номер AS Номер_заказа,
    o.Фамилия || ' ' || o.Имя AS Сотрудник,
    p.Фамилия || ' ' || p.Имя AS Клиент,
    m.Название AS Блюдо,
    pz.Количество,
    s.Название AS Стол,
    ch.Номер AS Номер_чека,
    ch.Дата_Время AS Дата_чека,
    ch.Общая_Стоимость AS Сумма_чека,
    ch.Сдача AS Сдача,
    t.Название AS Тип_оплаты
FROM Заказы z
         JOIN Официанты o ON z.Сотрудник_id = o.Id
         JOIN Позиции_Заказа pz ON z.Id = pz.Заказ_Id
         JOIN Посетители p ON pz.Посетитель_Id = p.Id
         JOIN Меню m ON pz.Меню_id = m.Id
         JOIN Столы s ON z.Стол_id = s.Id
         JOIN Чеки ch ON z.Id = ch.Заказ_Id
         JOIN Типы_Оплаты t ON ch.Тип_Оплаты_id = t.Id;

SELECT * FROM bxodhble_aanhble_5;

CREATE VIEW bxodhble_aanhble_6 AS
SELECT
    p.Номер AS Номер_поставки,
    p.Дата_Формирования,
    p.Поставщик,
    i.Название AS Ингредиент,
    ip.Количество,
    p.ОКПО
FROM Поставки p
         JOIN Ингредиенты_Поставки ip ON p.Id = ip.Поставка_id
         JOIN Ингредиенты i ON ip.Ингредиент_id = i.Id;

SELECT * FROM bxodhble_aanhble_6;

CREATE VIEW bxodhble_aanhble_7 AS
SELECT
    m.Название AS Блюдо,
    i.Название AS Ингредиент,
    mi.Количество
FROM Меню m
         JOIN Меню_Ингредиенты mi ON m.Id = mi.Меню_id
         JOIN Ингредиенты i ON mi.Ингредиент_id = i.Id;

SELECT * FROM bxodhble_aanhble_7;

CREATE VIEW bxodhble_aanhble_8 AS
SELECT
    r.reservation_code AS Номер_брони,
    p.Фамилия || ' ' || p.Имя AS Клиент,
    s.Название AS Стол,
    m.Название AS Блюдо,
    rd.quantity AS Количество,
    rd.serve_time AS Время_подачи
FROM reservations r
         JOIN Посетители p ON r.visitor_id = p.Id
         JOIN reservation_tables rt ON r.Id = rt.reservation_id
         JOIN Столы s ON rt.table_id = s.Id
         JOIN reservation_dishes rd ON r.Id = rd.reservation_id
         JOIN Меню m ON rd.dish_id = m.Id;

SELECT * FROM bxodhble_aanhble_8;


CREATE VIEW bxodhble_aanhble_9 AS
SELECT
    ch.Номер AS Номер_чека,
    ch.Дата_Время AS Дата_чека,
    ch.Общая_Стоимость,
    ch.Внесено,
    ch.Сдача,
    t.Название AS Тип_оплаты
FROM Чеки ch
         JOIN Типы_Оплаты t ON ch.Тип_Оплаты_id = t.Id;

SELECT * FROM bxodhble_aanhble_9;

CREATE VIEW bxodhble_aanhble_10 AS
SELECT
    COUNT(*) AS Количество_блюд,
    ROUND(AVG(Вес), 2) AS Средний_вес,
    ROUND(AVG(Цена), 2) AS Средняя_цена
FROM Меню;

SELECT * FROM bxodhble_aanhble_10;



