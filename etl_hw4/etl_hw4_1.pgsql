-- Создайте таблицу movies с полями movies_type, director, year_of_issue, length_in_minutes, rate.

CREATE TABLE movies (
    movie_type VARCHAR(255),
    director VARCHAR(255),
    year_of_issue INTEGER,
    length_in_minutes INTEGER,
    rate FLOAT
);

-- Сделайте таблицы для горизонтального партицирования по году выпуска (до 1990, 1990 -2000, 2000- 2010, 2010-2020, после 2020).

-- Создание таблицы для фильмов до 1990 года
CREATE TABLE movies_before_1990 (
    CHECK (year_of_issue < 1990)
) INHERITS (movies);

-- Создание таблицы для фильмов с 1990 по 2000 год
CREATE TABLE movies_1990_to_2000 (
    CHECK (year_of_issue >= 1990 AND year_of_issue <= 2000)
) INHERITS (movies);

-- Создание таблицы для фильмов с 2000 по 2010 год
CREATE TABLE movies_2000_to_2010 (
    CHECK (year_of_issue > 2000 AND year_of_issue <= 2010)
) INHERITS (movies);

-- Создание таблицы для фильмов с 2010 по 2020 год
CREATE TABLE movies_2010_to_2020 (
    CHECK (year_of_issue > 2010 AND year_of_issue <= 2020)
) INHERITS (movies);

-- Создание таблицы для фильмов после 2020 года
CREATE TABLE movies_after_2020 (
    CHECK (year_of_issue > 2020)
) INHERITS (movies);

-- Сделайте таблицы для горизонтального партицирования по длине фильма (до 40 минут, от 40 до 90 минут, от 90 до 130 минут, более 130 минут)

-- Создание таблицы для фильмов до 40 минут
CREATE TABLE films_less_than_40
    (CHECK (length < 40))
    INHERITS (movies);

-- Создание таблицы для фильмов от 40 до 90 минут
CREATE TABLE films_40_to_90
    (CHECK (length >= 40 AND length < 90))
    INHERITS (movies);

-- Создание таблицы для фильмов от 90 до 130 минут
CREATE TABLE films_90_to_130
    (CHECK (length >= 90 AND length < 130))
    INHERITS (movies);

-- Создание таблицы для фильмов более 130 минут
CREATE TABLE films_greater_than_130
    (CHECK (length >= 130))
    INHERITS (movies);
```

-- После создания таблиц можно добавить данные в соответствующие таблицы с помощью команды INSERT. Например:

-- Добавление фильма короче 40 минут
INSERT INTO films_less_than_40 (title, length) VALUES ('Фильм 1', 30);

-- Добавление фильма от 40 до 90 минут
INSERT INTO films_40_to_90 (title, length) VALUES ('Фильм 2', 60);

-- Добавление фильма от 90 до 130 минут
INSERT INTO films_90_to_130 (title, length) VALUES ('Фильм 3', 100);

-- Добавление фильма более 130 минут
INSERT INTO films_greater_than_130 (title, length) VALUES ('Фильм 4', 150);

-- Сделайте таблицы для горизонтального партицирования по рейтингу фильма (ниже 5, от 5 до 8, от 8до 10).

-- Создание основной таблицы
CREATE TABLE movies (
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    rating DECIMAL(2, 1) NOT NULL
);

-- Создание партиций для разных диапазонов рейтинга
CREATE TABLE movies_below_5 PARTITION OF movies FOR VALUES FROM (MINVALUE) TO (5);
CREATE TABLE movies_5_to_8 PARTITION OF movies FOR VALUES FROM (5) TO (8);
CREATE TABLE movies_8_to_10 PARTITION OF movies FOR VALUES FROM (8) TO (10);


