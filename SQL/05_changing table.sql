use market_db;

create table hongong1 (toy_id INT, toy_name CHAR(4), age INT);

insert into hongong1 value(1, '우디', 25);
SELECT * FROM hongong1;
insert into hongong1(toy_id, toy_name) value(2, '버즈');
insert into hongong1(toy_name, age, toy_id) value('제시', 25, 3);

create table hongong2(toy_id INT auto_increment primary key, toy_name char(4), age INT);
insert into hongong2 value(null, '보핍', 25);
insert into hongong2 value(null, '슬랭키', 22);
insert into hongong2 value(null, '렉스',21);
SELECT * FROM hongong2;
SELECT last_insert_id();

ALTER table hongong2 auto_increment = 100;
insert into hongong2 value(null, '재남', 35);

create table hongong3(toy_id INT auto_increment primary key, toy_name char(4), age INT);
ALTER table hongong3 auto_increment = 1000;
set @@auto_increment_increment = 3; -- 증가값이 3씩 증가(toy_id)
-- 시스템변수
show global variables;
insert into hongong3 value(null, '토마스', 20);
insert into hongong3 value(null, '제임스', 23);
insert into hongong3 value(null, '고든',25);
SELECT * FROM hongong3;


SELECT count(*) FROM world.city;
SELECT * FROM world.city;
DESC world.city;  -- DESC: describe the table.

SELECT * FROM world.city limit 5;
CREATE table city_popul(city_name CHAR(35), population INT);
insert into city_popul    -- insert data into a different table(city_popul)
     SELECT NAME, population FROM world.city;

SELECT * FROM city_popul limit 5;



-- update: modify data in table.
UPDATE city_popul     
     set city_name = '서울'
     where city_name = 'Seoul';  
     
     
	
SELECT * FROM city_popul WHERE city_name = 'Seoul';
SELECT * FROM city_popul WHERE city_name = '서울';
    
SELECT * FROM  city_popul WHERE city_name = 'New York';
UPDATE city_popul
    SET city_name = '뉴욕' 
    WHERE city_name = 'New York';
SELECT * FROM city_popul WHERE city_name = '뉴욕';

UPDATE city_popul
    SET population = population / 10000;
    
-- delete: delete data in table
DELETE FROM city_popul WHERE city_name like 'New%';
SELECT * FROM city_popul;

CREATE TABLE big_table1(SELECT * FROM world.city, sakila.country);
CREATE TABLE big_table2(SELECT * FROM world.city, sakila.country);
CREATE TABLE big_table3(SELECT * FROM world.city, sakila.country);
SELECT COUNT(*) FROM big_table1;

DELETE FROM big_table1;   -- remove content of table
SELECT * FROM big_table1;  
DROP TABLE big_table2;    -- remove table compeletely
SELECT * FROM big_table2;
truncate big_table3;      -- deletes the data inside a table, but not the table itself.
SELECT * FROM big_table3;


