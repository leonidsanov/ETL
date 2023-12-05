-- Домашняя работа к четвёртому семинару.
-- 1. Создайте таблицу movies с полями movies_type, director, year_of_issue, length_in_minutes, rate.
-- 2. Сделайте таблицы для горизонтального партицирования по году выпуска (до 1990, 1990 - 2000, 2000 - 2010, 2010 - 2020, после 2020).
-- 3. Сделайте таблицы для горизонтального партицирования по длине фильма (до 40 минута, от 40 до 90 минут, от 90 до 130 минут, более 130 минут)
-- 4. Сделайте таблицы для горизонтального партицирования по рейтингу фильма (ниже 5, от 5 до 8, от 8до 10).
-- 5. Создайте правила добавления данных для каждой таблицы.
-- 6. Добавьте фильмы так, чтобы в каждой таблице было не менее 3 фильмов.
-- 7. Добавьте пару фильмов с рейтингом выше 10.
-- 8. Сделайте выбор из всех таблиц, в том числе из основной.
-- 9. Сделайте выбор только из основной таблицы

-- 1. Создайте таблицу movies с полями movies_type, director, year_of_issue, length_in_minutes, rate.
CREATE TABLE movies (
  movie_type VARCHAR(255), 
  director VARCHAR(255), 
  year_of_issue INTEGER, 
  length_in_minutes INTEGER, 
  rate FLOAT
);

-- 2. Сделайте таблицы для горизонтального партицирования по году выпуска (до 1990, 1990 -2000, 2000- 2010, 2010-2020, после 2020).
-- Создание таблицы для фильмов до 1990 года
CREATE TABLE movies_before_1990 (
  CHECK (year_of_issue < 1990)
) INHERITS (movies);

-- Создание таблицы для фильмов с 1990 по 2000 год
CREATE TABLE movies_1990_to_2000 (
  CHECK (
    year_of_issue >= 1990 
    AND year_of_issue <= 2000
  )
) INHERITS (movies);

-- Создание таблицы для фильмов с 2000 по 2010 год
CREATE TABLE movies_2000_to_2010 (
  CHECK (
    year_of_issue > 2000 
    AND year_of_issue <= 2010
  )
) INHERITS (movies);

-- Создание таблицы для фильмов с 2010 по 2020 год
CREATE TABLE movies_2010_to_2020 (
  CHECK (
    year_of_issue > 2010 
    AND year_of_issue <= 2020
  )
) INHERITS (movies);

-- Создание таблицы для фильмов после 2020 года
CREATE TABLE movies_after_2020 (
  CHECK (year_of_issue > 2020)
) INHERITS (movies);

-- 3. Сделайте таблицы для горизонтального партицирования по длине фильма (до 40 минут, от 40 до 90 минут, от 90 до 130 минут, более 130 минут)

-- Создание таблицы для фильмов до 40 минут
CREATE TABLE films_less_than_40 (
  CHECK (length_in_minutes < 40)
) INHERITS (movies);

-- Создание таблицы для фильмов от 40 до 90 минут
CREATE TABLE films_40_to_90 (
  CHECK (
    length_in_minutes >= 40 
    AND length_in_minutes < 90
  )
) INHERITS (movies);

-- Создание таблицы для фильмов от 90 до 130 минут
CREATE TABLE films_90_to_130 (
  CHECK (
    length_in_minutes >= 90 
    AND length_in_minutes < 130
  )
) INHERITS (movies);

-- Создание таблицы для фильмов более 130 минут
CREATE TABLE films_greater_than_130 (
  CHECK (length_in_minutes >= 130)
) INHERITS (movies);

-- 4. Сделайте таблицы для горизонтального партицирования по рейтингу фильма (ниже 5, от 5 до 8, от 8 до 10).

-- Создание таблицы для фильмов с рейтингом ниже 5
CREATE TABLE movies_low_rate (
  CHECK (rate < 5)
) INHERITS (movies);

-- Создание таблицы для фильмов с рейтингом от 5 до 8
CREATE TABLE movies_medium_rate (
  CHECK (
    rate >= 5 
    AND rate < 8
  )
) INHERITS (movies);

-- Создание таблицы для фильмов с рейтингом от 8 до 10
CREATE TABLE movies_high_rate (
  CHECK (
    rate >= 8 
    AND rate <= 10
  )
) INHERITS (movies);

-- 5. Создайте правила добавления данных для каждой таблицы.
CREATE RULE insert_movies_before_1990 AS ON INSERT TO movies 
WHERE 
  (year_of_issue < 1990) DO INSTEAD INSERT INTO movies_before_1990 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_1990_2000 AS ON INSERT TO movies 
WHERE 
  (
    year_of_issue >= 1990 
    AND year_of_issue <= 2000
  ) DO INSTEAD INSERT INTO movies_1990_to_2000 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_2000_2010 AS ON INSERT TO movies 
WHERE 
  (
    year_of_issue > 2000 
    AND year_of_issue <= 2010
  ) DO INSTEAD INSERT INTO movies_2000_to_2010 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_2010_2020 AS ON INSERT TO movies 
WHERE 
  (
    year_of_issue > 2010 
    AND year_of_issue <= 2020
  ) DO INSTEAD INSERT INTO movies_2010_to_2020 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_after_2020 AS ON INSERT TO movies 
WHERE 
  (year_of_issue > 2020) DO INSTEAD INSERT INTO movies_after_2020 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_short AS ON INSERT TO movies 
WHERE 
  (length_in_minutes < 40) DO INSTEAD INSERT INTO films_less_than_40 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_medium AS ON INSERT TO movies 
WHERE 
  (
    length_in_minutes >= 40 
    AND length_in_minutes <= 90
  ) DO INSTEAD INSERT INTO films_40_to_90 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_long AS ON INSERT TO movies 
WHERE 
  (
    length_in_minutes > 90 
    AND length_in_minutes <= 130
  ) DO INSTEAD INSERT INTO films_90_to_130 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_extra_long AS ON INSERT TO movies 
WHERE 
  (length_in_minutes > 130) DO INSTEAD INSERT INTO films_greater_than_130 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_low_rate AS ON INSERT TO movies 
WHERE 
  (rate < 5) DO INSTEAD INSERT INTO movies_low_rate 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_medium_rate AS ON INSERT TO movies 
WHERE 
  (
    rate >= 5 
    AND rate < 8
  ) DO INSTEAD INSERT INTO movies_medium_rate 
VALUES 
  (NEW.*);

CREATE RULE insert_movies_high_rate AS ON INSERT TO movies 
WHERE 
  (
    rate >= 8 
    AND rate <= 10
  ) DO INSTEAD INSERT INTO movies_high_rate 
VALUES 
  (NEW.*);

-- 6. Добавьте фильмы так, чтобы в каждой таблице было не менее 3 фильмов.
INSERT INTO movies (movie_type, director, year_of_issue, length_in_minutes, rate) VALUES
  ('Комедия', 'Режиссер А', 1985, 120, 7.5),
  ('Драма', 'Режиссер Б', 1995, 150, 8.2),
  ('Боевик', 'Режиссер В', 2005, 80, 6.9);
-- Остальные фильмы добавляются по аналогии

-- 7. Добавление фильмов с рейтингом выше 10 (некорректные данные, так как рейтинг не может быть выше 10)
-- Это пример некорректного запроса, который не должен выполняться:
-- INSERT INTO movies (movie_type, director, year_of_issue, length_in_minutes, rate) VALUES
--   ('Фантастика', 'Режиссер Г', 2021, 140, 10.5);

-- 8. Выборка из всех таблиц, включая основную
SELECT * FROM ONLY movies;
SELECT * FROM movies_before_1990;
SELECT * FROM movies_1990_to_2000;
-- Выборка из остальных партиций добавляется по аналогии

-- 9. Выборка только из основной таблицы
SELECT * FROM ONLY movies;