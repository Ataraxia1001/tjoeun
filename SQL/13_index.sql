-- chapter 6: index
use market_db;

create table table1
   (col1 int primary key, -- primary key 생성하면 자동으로 클러스터형 인덱스 생산됨
   col2 int,
   col3 int);
   
show index from table1;

create table table2
    (col1 int primary key,
    col2 int unique,
    col3 int unique);
show index from table2;

drop table if exists buy, member;
create table member (
mem_id char(8),
mem_name varchar(10),
mem_number int,
addr char(2)
);

insert into member values ('TMC', '트와이스', 9, '서울');
insert into member values ('BLK', '블랙핑크', 4, '경남');
insert into member values ('WMN', '여자친구', 6, '경기');
insert into member values ('OMY', '오마이걸', 7, '서울');

select * from member;
alter table member
add constraint
primary key (mem_id);
select * from member;
alter table member drop primary key; -- 기본키 제거
select * from member;
 

alter table member drop primary key(mem_name);
select * from member;

alter table member 
add constraint
unique(mem_name);   -- unique는 찾아보기가 여러개 만들어지는것이지 내용의 순서가 바뀌지않음
select * from member;
insert into member values ('GRL', '소녀시대', 8, '서울'); 



create table cluster(mem_id char(8), mem_name varchar(10));
insert into cluster values ('TWC', '트와이스');

insert into cluster values ('GRL', '소녀시대');
insert into cluster values ('ITZ', '잇지');
insert into cluster values ('RED', '레드벨벳');
insert into cluster values ('APN', '에이핑크');
insert into cluster values ('SPC', '트와이');
insert into cluster values ('MMU', '마마무');
select * from market_db.cluster;

alter table cluster add constraint primary key(mem_id);
select * from cluster;



create table second(mem_id char(8), mem_name varchar(10));
insert into second values ('TWC', '트와이스');
insert into second values ('GRL', '소녀시대');
insert into second values ('ITZ', '잇지');
insert into second values ('RED', '레드벨벳');
insert into second values ('APN', '에이핑크');
insert into second values ('SPC', '트와이');
insert into second values ('MMU', '마마무');
select * from second;

alter table second add constraint unique (mem_id);

-- chapter 6-3
select * from member;
show index from member;
show table status like 'member';

create index idx_member_addr
    on member(addr);
                                                                                          
analyze table member;
show table status like 'member';
create unique index idx_member_mem_number 
    on member(mem_number);
create unique index idx_member_name
    on member(mem_name);
show index from member;
insert into member values ('MOO', '마마무', 2, '태국', '001', '2020.10.11');
analyze table member;
show index from member;

select * from member;
select mem_id, mem_name, addr from member
where mem_name = '에이핑크';

create index idx_member_mem_number
on member(mem_number); 
analyze table member;

select mem_name, mem_number
     from member
     where mem_number >= 7;

select mem_name, mem_number
     from member
     where mem_number >= 1;

select mem_name, mem_number
     from member
     where mem_number*2 >= 14;

select mem_name, mem_number
     from member
     where mem_number >= 14 / 2;

    
    
    



