create database naver_db;
drop table if exists buy, member;
create table member(
mem_id char(8) not null primary key,
mem_name varchar(10) not null,
height tinyint unsigned 
);

describe member; -- 표를 요약해서 볼수 있음

drop table if exists buy, member;
create table member(
mem_id char(8) not null,
mem_name varchar(10) not null,
height tinyint unsigned,
primary key(mem_id) 
);
describe member;


drop table if exists buy, member;
create table member(
mem_id char(8) not null,
mem_name varchar(10) not null,
height tinyint unsigned
);

-- alter 쿼리를 활용해서 프라이머리키 지정
alter table member 
     add constraint
     primary key(mem_id);
 describe member;
 
 drop table if exists buy, member;
 create table member(
mem_id char(8) not null,
mem_name varchar(10) not null,
height tinyint unsigned,
constraint primary key PK_member_mem_id(mem_id)
);
describe member;


create table buy(
num int auto_increment not null primary key,
mem_id char(8) not null,
prod_name char(6) not null,
foreign key(mem_id) references member(mem_id)
);  -- 기준테이블과 참조테이블의 외래키의 컬럼명이 반드시 같을 필요는 없음



drop table if exists buy, member;
create table member(
mem_id char(8) not null,
mem_name varchar(10) not null,
height tinyint unsigned
);
create table buy(
num int auto_increment not null primary key,
mem_id char(8) not null,
prod_name char(6) not null
);  
alter table buy
   add constraint foreign key(mem_id) references member(mem_id);

insert into member values('BLK', '블랙핑크', 163);
insert into buy values(null, 'BLK', '지갑');
insert into buy values(null, 'BLK', '맥북');
SELECT * FROM naver_db.buy;
SELECT * FROM member;
update member set mem_id = 'PINK' WHERE mem_id = 'BLK'; -- mem_id is used to connect two tables, it cannot be updated.
delete from member where mem_id = 'BLK'; -- it cannot be deleted either.







drop table if exists buy, member;
create table member(
mem_id char(8) not null primary key,
mem_name varchar(10) not null,
height tinyint unsigned
);
create table buy(
num int auto_increment not null primary key,
mem_id char(8) not null,
prod_name char(6) not null
);  
alter table buy
   add constraint foreign key(mem_id) references member(mem_id)
   on update cascade
   on delete cascade;

INSERT INTO member values('BLK', '블랙핑크', 163);
insert into buy values(NULL, 'BLK', '지갑');  -- give null for mem_id, but buy gets mem_id from member.
insert into buy values(NULL, 'BLK', '맥북');
update member set mem_id = 'PINK' WHERE mem_id = 'BLK';
delete from member where mem_id = 'PINK'; 



-- unique 
drop table if exists buy, member;
create table member(
mem_id char(8) not null primary key,
mem_name varchar(10) not null,
height tinyint unsigned null,
email char(30) null unique -- 이메일 중복안됨 지정
);
insert into member values ('BLK', '블랙핑크', 163, 'pink@gmail.com');
insert into member values('APN', '에이핑크', 164, 'pink@gmail.com'); -- email must be unique, cannot be inserted.



-- check
drop table if exists buy, member;
create table member(
mem_id char(8) not null primary key,
mem_name varchar(10) not null,
height tinyint unsigned null check (height >= 100),
phone1 char(3) null
);
INSERT INTO member values('BLK', '블랙핑크', 163, null);
INSERT INTO member values('TWC', '트와이스', 99, null);  -- height < 100, it cannot be inserted.

alter table member
    add constraint
	check (phone1 IN ('02', '031', '032', '054', '055', '061'));

insert into member values('TWC', '트와이스', 167, '02');
insert into member values('OMY', '오마이걸', 167, '010'); -- '010' doesn't exist in check



drop table if exists buy, member;
create table member(
mem_id char(8) not null primary key,
mem_name varchar(10) not null,
height tinyint unsigned default 160,
phone1 char(3) null
);
alter table member
       alter column phone1 set default '02';
insert into member values('TWC', '트와이스', 167, '054');
insert into member values('OMY', '오마이걸', default, default);
SELECT * FROM member;
       










