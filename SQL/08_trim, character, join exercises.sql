-- TRIM()  문자열공백제거 ----> strip() of python
SELECT trim('  안녕하세요   ');

SELECT trim(both '안' FROM '안녕하세요안');  -- '안' 제거

--  좌측공백제거
SELECT trim(leading from '    안녕하세요  ');

-- 우측공백제거
SELECT trim(trailing from '             안녕하세요   '); 

-- 좌측문자제거
SELECT trim(leading '안' FROM '안녕하세요안');

-- 우측문자제거
SELECT trim(trailing '안' FROM '안녕하세요안');

SELECT ltrim('           안녕하세요          ');  -- same as leading
SELECT rtrim('           안녕하세요          ');  -- same as trailing

SELECT length('안녕'); 
SELECT char_length('안녕');
SELECT character_length('안녕');

-- 대소문자
SELECT upper('sql로 시작하는 하루');
SELECT lower('A에서 Z까지 !');


-- 추출
SELECT substring('안녕하세요', 2, 3); -- start index 2 and 3 characters
SELECT substring_index('안.녕.하.세.요', '.', 2);  -- show up to second '.'

SELECT substring_index('안.녕.하.세.요', '.', -3); -- goes to -3 '.' and show up to that

SELECT concat('홍길동', '모험');
SELECT concat_ws(',', '홍길동', '모험');
SELECT '홍길동', '모험';


use bookstore;
SELECT concat_ws(":", bookname, publisher) from book;

SELECT bookname, ":", publisher FROM book;

-- customer의 name과 phone을 ':'로 묶기
SELECT group_concat(username, ':', phone) AS '전화' FROM customer;
SELECT concat_ws(':', username, phone) AS '전화' FROM customer;

SELECT Now(), sysdate(), current_timestamp;
SELECT curtime(), current_time;

SELECT adddate('2021-8-31', interval 5 day);    -- add 5 days
SELECT adddate('2021-8-31', interval 1 month);  
SELECT addtime('2021-01-01 23:59:59', '1:1:1') -- add 1 hour, 1 minute, 1 second

-- SELECT datediff('2022-01-01', now());
SELECT timediff('23:23:59', '2:1:1');

-- 날짜/시간 생성
SELECT makedate(2021, 55);
SELECT date_format(makedate(2021, 55), '%Y.%m.%d');
SELECT maketime(11, 11, 10);
SELECT quarter('2021-04-04')

-- change type of data
-- SELECT avg(saleprice) AS '평균 구매 가격' FROM orders;
SELECT cast(avg(saleprice) AS signed integer) AS '평균구매가격' FROM orders; 


-- combine table without join
SELECT username, saleprice FROM customer C, orders O
      WHERE C.custid = O.custid;

-- same thing using join
SELECT username, saleprice FROM customer C 
    join orders O ON C.custid = O.custid;

-- 도서가격이 20000원 이상인 도서를 주문한 고객이름,도서이름 출력
SELECT C.username, B.bookname FROM customer C, orders O, book B
      INNER JOIN orders O ON C.custid = O.custid
      -- INNER JOIN book B ON C.custid = B.custid
    --  WHERE .saleprice > 20000;




SELECT C.username AS '이름', B.bookname AS '도서명' FROM customer C, orders O, book B
     WHERE C.custid = O.custid and O.bookid = B.bookid and B.price > 20000;


SELECT username, sum(saleprice) FROM customer C, orders O
     where C.custid = O.custid
     GROUP BY C.username ORDER BY O.orderdate;
     
     
SELECT C.username, O.saleprice FROM customer C
      LEFT OUTER JOIN orders O ON C.custid = O.custid;


     
     
