-- arithmetic
SELECT 1;
SELECT 1+1;
SELECT 0.1;
SELECT 1-1;
SELECT 100/20;
SELECT 5.0/2;

USE bookstore;
/* book 테이블에서 price 값에 0.05 */
SELECT price*0.05 FROM book;
SELECT price/2 FROM book;
SELECT (price/2)*100 FROM book;

SELECT 1 > 100;
SELECT 1 < 100;
SELECT 10 = 10;
SELECT 101 <> 10;  -- not equal
SELECT 101 != 10; -- not equal

-- logical operation
SELECT (10>=10) and (5<10);
SELECT (10>10) and (5<10);
SELECT (10>10) or (5<10);
SELECT not (10>10);

SELECT count(*) FROM orders;

-- 고객이 주문한 도서의 총 판매액을 구하시오
SELECT sum(saleprice) FROM orders;
-- 고객이 주문한 도서의 총 판매액인데 '총매출'로 표시'
SELECT sum(saleprice) AS 총매출 FROM orders;
SELECT avg(saleprice) AS 매출평균 FROM orders;

-- 판매액을 합계 평균, 최저, 최고가 구하기
SELECT sum(saleprice) AS 총매출액, 
avg(saleprice) AS 매출평균, 
min(saleprice) AS 최저가, 
max(saleprice) AS 최고가 
FROM orders;








