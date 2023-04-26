use market_db;


DELIMITER $$
create procedure user_proc()
begin
   select * from member; 
end $$ 
DELIMITER ;
call user_proc();

drop procedure if exists user_proc();


use market_db;
DELIMITER $$
create procedure user_proc1(in userName varchar(10))
begin
   select * from member where mem_name = userName; 
end $$ 
DELIMITER ;
call user_proc1();



DELIMITER $$
create procedure user_proc2(in userNumber int, in userHeight int)
begin
   select * from member where mem_number > userNumber and height > userHeight; 
end $$ 
DELIMITER ;
call user_proc2(6, 165);



drop procedure if exists user_proc3;
DELIMITER $$
create procedure user_proc3(in textValue char(10), out outValue int)
begin
	insert into noTable values(null, textValue);
    select max(id) into outvalue from noTable;    -- there is no noTable
end $$ 
DELIMITER ;
desc noTable;  -- there is no noTable

create table if not exists noTable(
id int auto_increment primary key, txt char(10));
call user_proc3('테스트1', @myValue);
select concat('입력된 ID값 ->', @myValue);


-- SQL 프로그래밍 활용
DELIMITER $$
create procedure ifelse_proc(in memName varchar(10))
begin
	declare debutYear int; -- 변수선언
    select year(debut_date) into debutYear from member
       where mem_name = mem_name;
	if (debutYear >= 2015) then 
	   select '신인가수네요 화이팅하세요' as '메시지';
	else 
       select '고참가수네요 그동안 수고했어요' as '메시지';
	end if;
end $$ 
DELIMITER ;
call ifelse_proc('오마이걸');


-- exercise
DELIMITER $$
create procedure hap100()
begin
   declare hap int;
   declare i int;
   set hap = 0;
   set i = 1;
   while(i <= 100) do
      set i = i + 1;
      set hap = hap + i;
   end while;
   SELECT hap;
end $$ 
DELIMITER ;
call hap100();



-- 동적 SQL
DELIMITER $$    
create procedure dynamic_proc(in tableName varchar(10))
begin
   set @sqlQuery = concat('select * from ', tableName);
   prepare myQuery from @sqlQuery;
   execute myQuery;
   deallocate prepare myQuery;
end $$ 
DELIMITER ;
call dynamic_proc('member');


-- 07-2: stored function

set global log_bin_trust_function_creators = 1;  -- allow to make stored function
DELIMITER $$
create function sumFunc(number1 int, number2 int)
   returns int
begin
   return number1 + number2;
end $$
DELIMITER ;
select sumFunc(100, 200) as '합계';


DELIMITER $$
create function calcYearFunc(dYear int)
   returns int  -- set type of return value
begin
   declare runYear int;
   set runYear = Year(curdate()) - dYear;
   return runYear;
end $$
DELIMITER ;
select calcYearFunc(2007) as '활동 햇수';
select calcYearFunc(2007) into @debut2007;
select calcYearFunc(2013) into @debut2013;
select @debut2007 - @debut2013 as '차이';

select mem_id, mem_name, calcYearFunc(year(debut_date)) as '활동햇수' from member;

-- 함수의 내용확인
show create function calcYearFunc;


-- 함수 삭제
drop function calcYearFunc;


-- 커서
declare memNumber int; -- 회원의 인원수
declare cnt int Default 0; -- 읽은 행의 변수 갯수
declare totNumber int Default 0;  -- 인원의 합계
declare endofRow Boolean default false; -- 행의 끝이면 True

-- 커서 선언
declare memberCursor Cursor for 
     select mem_number from member;
     
-- 행의 끝이면 endRow에 변수 True대입하라는 명령어
declare continue handler
    for not found set endofRow = TRUE;

cursor_loop : LOOP
 fetch memberCursor into memNumber;
 if endofRow then 
    leave cursor_loop;
 end if;
 set cnt = cnt + 1 ;
 set totNumber = totNumber + memNumber;
end loop cursor_loop;
select (totNumber/cnt) as '회원의 평균인원수';
close memberCursor;


drop procedure if exists cursor_proc;
-- 커서의 통합코드
delimiter $$
create procedure cursor_proc()
begin
    declare memNumber int; 
    declare cnt int Default 0;
    declare totNumber int Default 0;
    declare endofRow Boolean default false;
    declare memberCursor Cursor for 
        select mem_number from member;
	declare continue handler 
        for not found set endofRow = TRUE;
        
	open memberCursor; -- 커서제거
    cursor_loop : LOOP
		fetch memberCursor into memNumber;
        
        if endofRow then
            leave cursor_loop;
		end if;
        
        set cnt = cnt + 1;
        set totNumber = totNumber + memNumber;
	end loop cursor_loop;
    select (totNumber/cnt) as '회원의 평균 인원 수';
    close memberCursor;
end $$
delimiter ;

call cursor_proc();


-- 07-3: trigger(useful for backup)
create table if not exists trigger_table (id int, txt varchar(10));
insert into trigger_table values (1, '레드벨벳');
insert into trigger_table values (2, '잇지');
insert into trigger_table values (3, '블랙핑크');

-- create trigger
delimiter $$
create trigger myTrigger
	after delete -- 삭제후에 작동하도록 지정
    on trigger_table   -- 부착할 테이블
    for each row  -- 각 행마다 적용
begin
    set @msg = '가수 그룹이 삭제됨';  -- 트리거가 실행되면 작동되는 코드
end $$
delimiter ;

set @msg = '';
insert into trigger_table values(4, '마마무');
select @msg;

update trigger_table set txt = '블핑' where id=3;
select @msg;
delete from trigger_table where id=4;
select @msg;

create table singer(select mem_id, mem_name, mem_number, addr from member);
create table backup_singer(
mem_id char(8) not null, 
mem_name varchar(10) not null, 
mem_number int not null, 
addr char(2) not null,
modType char(2), -- 변경된 타입 '수정' or '삭제'
modDate Date, -- 변경된 날짜
modUser varchar(30) -- 변경한 사용자
);


drop trigger if exists singer_deleteTrg;
delimiter $$
create trigger singer_deleteTrg -- 트리거이름
       after delete 
       on singer
       for each row
begin
    insert into backup_singer values(OLD.mem_id, OLD.mem_name, OLD.mem_number, OLD.addr, '삭제',
    curdate(), current_user());
end $$
delimiter ;

drop trigger if exists singer_updateTrg;
delimiter $$
create trigger singer_updateTrg -- 트리거이름
       after update 
       on singer
       for each row
begin
    insert into backup_singer values(OLD.mem_id, OLD.mem_name, OLD.mem_number, OLD.addr, '수정',
    curdate(), current_user());
end $$
delimiter ;

update singer set addr = '영국' where mem_id = 'BLK';
delete from singer where mem_number >= 7;






