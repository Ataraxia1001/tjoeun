SELECT * FROM market_db.member;


SELECT * FROM buy
     INNER JOIN member
     ON buy.mem_id = member.mem_id
     WHERE buy.mem_id = 'GRL';
     
SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, concat(M.phone1, M.phone2) '연락처' FROM buy B
	 INNER JOIN member M
     ON B.mem_id = M.mem_id;
     
-- 중복제거 distinct. 한번이상 구매한 회원목록
SELECT DISTINCT M.mem_id, M.mem_name, M.addr FROM buy B
     INNER JOIN member M ON B.mem_id = M.mem_id
     ORDER BY M.mem_id;
     
     
-- 회원가입후 한번도 구매한적이 없는 회원 목록, outer join
SELECT M.mem_id, M.mem_name, B.prod_name, M.addr 
     FROM member M
         LEFT OUTER JOIN buy B ON M.mem_id = B.mem_id
         ORDER BY M.mem_id;
         
SELECT distinct M.mem_id, M.mem_name, B.prod_name, M.addr FROM member M
      LEFT OUTER JOIN buy B ON M.mem_id = B.mem_id
      WHERE B.prod_name IS NULL   -- choose people who never bought
      ORDER BY M.mem_id;

SELECT * FROM buy 
      CROSS JOIN member;
      
      
SELECT COUNT(*) FROM world.city;
SELECT COUNT(*) FROM sakila.inventory
    CROSS JOIN world.city;
      
      
CREATE table emp_table (emp char(4), manager char(4), phone varchar(8));
insert into emp_table value ('대표', null, '0000');
insert into emp_table value ('영업이사', '대표', '1111');
insert into emp_table value ('관리이사', '대표', '2222');
insert into emp_table value ('정보이사', '대표', '3333');
insert into emp_table value ('영업과장', '영업이사', '1111-1');
insert into emp_table value ('경리부장', '관리이사', '2222-1');
insert into emp_table value ('인사과장', '관리이사', '2222-1');
insert into emp_table value ('개발팀장', '정보이사', '3333-1');
insert into emp_table value ('개발주임', '정보이사', '3333-1-1');

SELECT A.emp '직원', B.emp '직속상관', B.phone '직속상관연락' FROM emp_table A
      INNER JOIN emp_table B ON A.manager = B.emp ;
      WHERE A.emp = '경리부장'; 
	  
      
-- exercise
use bookstore;
-- 구매고객이 가격 8000이상 도서를 2권이상 주문한 고객 이름, 수량, 판매금액을 조회
SELECT C.username, O.custid, count(*) AS '수량', SUM(O.saleprice) AS '판매액' FROM orders O  -- SUM(O.saleprice)
       INNER JOIN customer C ON O.custid = C.custid
	   WHERE saleprice > 8000 
       GROUP BY custid
       HAVING count(*) >= 2;
       









