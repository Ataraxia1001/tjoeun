-- 1. 가격이 10000원보다 크고 20000이하인 도서를 검색하시오
SELECT bookname FROM book WHERE price BETWEEN 10000 AND 20000;

-- 2. 주문일자가 2021/02/01 에서 2021/02/07내 주문내역검색
SELECT * FROM orders WHERE orderdate BETWEEN '2021-02-01' AND '2021-02-07';

-- 3. 도서번호가 3, 4, 5, 6 인 주문목록 출력
SELECT * FROM orders WHERE bookid IN (3, 4, 5, 6);

-- 4. 박씨성을 가진 고객 출력 
SELECT username FROM customer WHERE username LIKE '박%'; 

-- 5. 2번째 글짜가 '지'인 고객 출력
SELECT username FROM customer WHERE username LIKE '%지%'; 
SELECT username FROM customer WHERE username LIKE '_지%'; 

-- 6. '철학의 역사'를 출간한 출판사 검색
SELECT bookname, publisher FROM book WHERE bookname = '철학의 역사';

-- 7. 도서이름에 썬으로 일치하고 5000원 이상인 도서
SELECT * FROM book WHERE bookname LIKE '%썬%' AND price >= 5000;

-- 8. 출판사 이름이 '정론사' 혹은 '새미디어'
SELECT * FROM book WHERE publisher = '정론사' OR publisher = '새미디어';
