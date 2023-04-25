use marekt_db;
DELIMITER $$
CREATE PROCEDURE ifProc1()
BEGIN 
	if 100 = 100 then 
        SELECT '100은 100과 같다'; 
    end if; 
END $$
DELIMITER ;

call ifProc1();

DROP PROCEDURE if exists ifProc2;


DELIMITER $$
CREATE PROCEDURE ifProc2()
BEGIN
    DECLARE myNum INT;  -- @ 함수밖에서
    SET myNum = 200;
    if myNum= 100 then
	    SELECT '100입니다.';
	else  
        SELECT '100이 아닙니다.';
	end if;
end $$
DELIMITER ;
call ifProc2();

DELIMITER $$
CREATE PROCEDURE ifProc3()
BEGIN
    DECLARE debutDate DATE; -- 데뷰일 변수 준비
    DECLARE curDate date; -- 오늘 날짜 변수
    DECLARE days INT;  -- 활동한 일수
    SELECT debut_date INTO debutDate  -- debu_date column -> variable
         FROM market_db.member 
         WHERE mem_id = 'APN';
    SET curDate = current_date(); -- 현재날짜 
    SET days = datediff(curDate, debutDate);  -- 일단위
    
    if (days/365) >= 5 then
	     SELECT concat('데뷰한지', days, '일이 지났습니다. 축하합니다.');
	else 
         SELECT concat('데뷰한지', days, '일밖에 안됬네요. 화이팅.');
	end if;
END $$
DELIMITER ;
call ifProc3();

SELECT if(100 > 300, '크다', '작다');

-- 다중분기 case
case 
    when 10 then '십'
    when 50 then '오십'
    when 100 then '일백'
    else '기타' 
end case;
-- AS '결과';

drop procedure if exists caseProc;
DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN
    declare point int;
    declare credit char(1);
    set point = 88;
    
    case 
        when point >= 90 then
             set credit = 'A';
	    when point >= 80 then
             set credit = 'B';
	    when point >= 70 then
             set credit = 'C';
		when point >= 60 then
             set credit = 'D';
		else
             set credit = 'F';
    end case;
	SELECT  concat('취득점수 -->', point), concat('학점 -->', credit);
end $$
DELIMITER ;
call caseProc();

-- case 활용 구매액 기준 회원 등급을 만들어 보자
SELECT mem_id, sum(price * amount) '총구매액'
     FROM buy 
     GROUP BY mem_id;
     
     
SELECT mem_id, sum(price*amount) '총구매액'
	 FROM buy 
     GROUP BY mem_id
     ORDER BY sum(price*amount) DESC;
     
     
-- 구매테이블과 회원테이블
SELECT B.mem_id, M.mem_name, sum(price*amount) '총구매액'
     FROM buy B
        inner join member M 
        ON B.mem_id = M.mem_id
	 GROUP BY B.mem_id
     ORDER BY sum(price * amount) DESC;
     
-- 한번도 안산사람도 나와야 하기때문에 아우터 조인을 해야함
SELECT B.mem_id, M.mem_name, sum(price*amount) '총구매액'
     FROM buy B
        right outer join member M 
        ON B.mem_id = M.mem_id
	 GROUP BY B.mem_id
     ORDER BY sum(price * amount) DESC;
     
-- SELECT 
SELECT B.mem_id, M.mem_name, sum(price*amount) '총구매액',
     case
         when sum(price*amount) >= 1500 then '최우수고객'
         when sum(price*amount) >= 1000 then '우수고객'
         when sum(price*amount) >= 1 then '일반고객'
         else '유령고객'
	 end '회원등급'
     FROM buy B
        right outer join member M 
        ON B.mem_id = M.mem_id
	 GROUP BY B.mem_id
     ORDER BY sum(price * amount) DESC;



-- while, add 1-100
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
    declare i int; -- 1-100까지 증가할 변수
	declare hap int; -- 합계를 넣어주는 변수
    set i = 1;
    set hap = 0;
    while (i <= 100) do 
         set hap = hap + i;
         set i = i + 1;
	end while;
    SELECT '1부터 100까지 합은 =>', hap;
end $$
DELIMITER ;
call whileProc();



DROP PROCEDURE if exists whileProc2;
-- while 응용
DELIMITER $$
CREATE PROCEDURE whileProc2()
BEGIN
    declare i int; -- 1-100까지 증가할 변수
	declare hap int; -- 합계를 넣어주는 변수
    set i = 1;
    set hap = 0;
    myWhile: 
    while (i <= 100) do
         if (i % 4 = 0) then 
		     set i = i + 1;
		     iterate myWhile; --  label로 가서 계속진행
	     end if;
         set hap = hap + i; 
         if (hap > 1000) then
             leave myWhile; -- label을 떠남. 종료
         end if;
         set i = i + 1;
    end while;
    SELECT '1부터 100까지 합(4배수제외)은 1000이상은 종료 =>', hap;
end $$
DELIMITER ;
call whileProc2();

-- 동적 SQL
prepare myQuery from 'select * from member where mem_id = "BLK"';
execute myQuery;
deallocate prepare myQuery; -- 동적 sql 해제
execute myQuery;

-- 출입문 내역
CREATE table gate_table (
     id INT auto_increment primary key, 
     entry_time datetime);

set @curDate = current_timestamp();
prepare myQuery FROM  'insert into gate_table values(null, ?)';
execute myQuery using @curDate;

-- 테이블에 조회
SELECT * FROM gate_table;




	














