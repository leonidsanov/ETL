/* create schema DE;
 * CREATE TABLE  if not exists de.Transactions (
  id serial,
  Client_id int NOT NULL,
  Report_date date,
  Txn_amount int NOT NULL);*/


/*
Создайте в Postgress таблицу news с полями id, category_id, rate, title, author
Сделайте таблицы для партицирования по category_id (возможные значения 1, 2, 3) которые будут наследоваться от основной таблицы
Создайте правила для добавления в эти таблицы
Добавьте несколько записей в каждую таблицу
Добавьте запись с category_id = 4
Сделайте выборку из всех таблиц.
 */
 
create table de.posts (
	id int not null
	,category_id int not null
	,rate int
	,title varchar(50) not null
	,author varchar(50) not null
	);
	
select * from de.posts;
create table de.posts_(
	check (category_id = 1))
	inherits (de.posts);

create table de.posts_2(
	check (category_id = 2))
	inherits (de.posts);

create table de.posts_3(
	check (category_id = 3))
	inherits (de.posts);

insert into de.posts(
	id
	,category_id
	,rate
	,title
	,author)
values (
	1
	,1
	,155
	,'T1'
	,'JhonD'
);
 
create rule posts_insert_to_1 as on insert to de.posts
	where (category_id = 1)
	do instead insert into de.posts_1 values (new.*);

create rule posts_insert_to_2 as on insert to de.posts
	where (category_id = 2)
	do instead insert into de.posts_2 values (new.*);

create rule posts_insert_to_3 as on insert to de.posts
	where (category_id = 3)
	do instead insert into de.posts_3 values (new.*);

insert into de.posts(id, category_id, rate, title, author)
values 
	(2, 1, 254, 'T1', 'Ann'),
	(3, 2, 3, 'T21', 'Kate'),
	(4, 3, 54, 'T32', 'Mary'),
	(5, 3, 51, 'T34', 'Mike');
	
select * from de.posts_11;
select * from de.posts_21;
select * from de.posts_31;



insert into de.posts(id, category_id, rate, title, author)
values (6, 4, 12, 'T1', 'Alice');

select * from /*only*/ de.posts ;

/*
Сделайте таблицы для партицирования новостей по rate (возможные значения до 100, от 100 до 200, больше 200),
 которые будут наследоваться от основной таблицы
Создайте правила для добавления в эти таблицы
Добавьте несколько записей в каждую таблицу
Сделайте выборку из всех таблиц.
 * */

create table de.posts_11(
	check (rate <= 100))
	inherits (de.posts);

create table de.posts_21(
	check (rate > 100 and rate <= 200 ))
	inherits (de.posts);

create table de.posts_31(
	check (rate > 200))
	inherits (de.posts);

create rule posts_insert_to_1_rate_100 as on insert to de.posts
	where (rate <= 100)
	do instead insert into de.posts_11 values (new.*);

drop rule posts_insert_to_1_rate_100 on de.posts;

create rule posts_insert_to_2_rate_200 as on insert to de.posts
	where (rate > 100 and rate <= 200 )
	do instead insert into de.posts_21 values (new.*);

create rule posts_insert_to_3_rate_300 as on insert to de.posts
	where (rate > 200)
	do instead insert into de.posts_31 values (new.*);

insert into de.posts(id, category_id, rate, title, author)
values 
	(2, 1, 10, 'T1', 'Jinny'),
	(3, 2, 101, 'T251', 'Freddy'),
	(4, 3, 210, 'T342', 'Sam'),
	(5, 4, 250, 'T34', 'Alex');

/*
Откройте консоль Postgress
Создайте таблицу vehicles c полями vehicle_type, plate_number, year_of_issue, weight, owner
Сделайте таблицы для горизонтального партицирования по весу машины(от 1 тонны до 2.5 тонн, от 2.5 до 4 тонн, больше 4 тонн)
Сделайте таблицы для горизонтального партицирования по году выпуска машины (до 2000, с 2000 до 2019, после 2019)
Создайте правила добавления данных для каждой таблицы
Добавьте транспортные средства чтобы в каждой созданной таблице было не менее трех транспортных средств
Добавьте несколько мотоциклов весом меньше одной тонны
Сделайте выбор из всех таблиц в том числе и из основной
Сделайте выбор только из основной таблицы.
 */

create table de.vehicles (
	id serial primary key
	,vehicle_type varchar(15) not null -- -- тип motorcycle, passenger_car, truck
	,plate_number varchar(6) not null -- ГРН
	,year_of_issue int not null  -- год выпуска
	,weight int not null -- вес в кг 
	,owner varchar(50) not null  -- владелец
);

alter table de.vehicles add check ( vehicle_type in ('motorcycle', 'passenger_car', 'truck'));
-- Сделайте таблицы для горизонтального партицирования по весу машины(от 1 тонны до 2.5 тонн, от 2.5 до 4 тонн, больше 4 тонн)
create table de.vehicles_by_weight_1(
	check (weight >= 1000 and weight <2500))
	inherits (de.vehicles);

create table de.vehicles_by_weigth_2(
	check (weight >= 2500 and weight <4000))
	inherits (de.vehicles);

create table de.vehicles_by_weight_3(
	check (weight >= 4000))
	inherits (de.vehicles);


create rule vehicles_by_weight_1 as on insert to de.vehicles
	where (weight >= 1000 and weight <2500)
	do instead insert into de.vehicles_by_weight_1 values (new.*);

create rule vehicles_by_weight_2 as on insert to de.vehicles
	where (weight >= 2500 and weight <4000)
	do instead insert into de.vehicles_by_weigth_2 values (new.*);

create rule vehicles_by_weight_3 as on insert to de.vehicles
	where (weight >= 4000)
	do instead insert into de.vehicles_by_weight_3 values (new.*);

--Сделайте таблицы для горизонтального партицирования по году выпуска машины (до 2000, с 2000 до 2019, после 2019)
create table de.vehicles_by_year_1(
	check (year_of_issue <=2000))
	inherits (de.vehicles);

create table de.vehicles_by_year_2(
	check (year_of_issue > 2000 and year_of_issue < 2019))
	inherits (de.vehicles);

create table de.vehicles_by_year_3(
	check (year_of_issue >=2019))
	inherits (de.vehicles);
-- Создайте правила добавления данных для каждой таблицы
create rule vehicles_by_year_1 as on insert to de.vehicles
	where (year_of_issue <=2000)
	do instead insert into de.vehicles_by_year_1 values (new.*);

create rule vehicles_by_year_2 as on insert to de.vehicles
	where (year_of_issue > 2000 and year_of_issue < 2019)
	do instead insert into de.vehicles_by_year_2 values (new.*);

create rule vehicles_by_year_3 as on insert to de.vehicles
	where (year_of_issue >=2019)
	do instead insert into de.vehicles_by_year_1 values (new.*);

-- Добавьте несколько мотоциклов весом меньше одной тонны

insert into de.vehicles (vehicle_type, plate_number, year_of_issue, weight, owner)
	values
	('motorcycle', 12488, 1985, 900, 'VannDamm'),
	('motorcycle', 99999, 1973, 700, 'BruceLee');

-- Сделайте выбор из всех таблиц в том числе и из основной
select * from only de.vehicles v ;
select * from de.vehicles_by_weight_1 vbw ;
select * from de.vehicles_by_weigth_2 vbw2;
select * from de.vehicles_by_weight_3 vbw ;
select * from de.vehicles_by_year_1 vby ;
select * from de.vehicles_by_year_2 vby ;
select * from de.vehicles_by_year_3 vby ;

delete from de.vehicles;