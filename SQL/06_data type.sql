use market_db;

create table hongong4 (
  tinyint_col tinyint,
  smallint_col smallint,
  int_col int,
  bigint_col bigint
);

insert into hongong4 value(127, 32767, 2147483647, 9000000000000000000)
SELECT * FROM hongong4;
insert into hongong4 value(127, 32767, 2147483647, 90000000000000000000);

drop table if exists buy, member;

create table member(
  mem_id char(8) NOT NULL PRIMARY KEY, 
  mem_name varchar(10) NOT NULL,  -- 이름 가변으로 들어갈예정
  mem_number TINYINT NOT NULL,
  addr char(2) NOT NULL,
  phone1 char(3),
  phone2 char(8),
  height tinyint unsigned,  -- unsigned --> starts with 0. 0 < TINYINT(unsigned) < 255 
  debut_date date
);

CREATE database neflix_db;
use neflix_db;

create table movie(
movie_id int,
movie_title varchar(30),
movie_director varchar(30),
movie_star varchar(30),
movie_script longtext,-- 42억자
movie_film longblob -- 4G
)

-- using variable
use market_db;
set @myVar1 = 5;
set @myVar2 = 4.52;
SELECT @myVar1;
SELECT @myVar1 + @myVar2;
SET @txt = '가수 이름 ==>';
SET @height = 166;
SELECT @txt, mem_name FROM member WHERE height > @height;

SET @count = 3;
SELECT mem_name, height FROM member
     ORDER BY height
     limit @count;  -- variable cannot be used in limit


prepare mysql FROM 'select mem_name, height 
from member
order by height
limit ?';
EXECUTE mysql USING @count; -- @count is inserted in ? of prepared mysql.
SELECT AVG(price) '평균가격' FROM buy;
SELECT cast(avg(price) AS signed) '평균가격' FROM buy; -- signed -> make integer
SELECT convert(avg(price), signed) '평균가격' FROM buy;  -- same as cast
SELECT cast('2022$12$12' AS Date);
SELECT cast('2022/12/12' AS Date);
SELECT cast('2022%12%12' AS Date);
SELECT cast('2022@12@12' AS Date);

SELECT num, CONCAT(cast(price AS char), 'X', cast(amount AS char), '=')
        '가격X수량', price * amount '구매액'
        FROM buy;

SELECT '100' + '200';
SELECT concat('100', '200');
SELECT concat(100, '200');
SELECT 1 > '2mega';  -- second one is converted 2(integer)
SELECT 3 > '2MEGA';  --  정수인 2로 변환되서 비교
SELECT 0 = 'mega2';  -- 문자는 0 으로 변환


