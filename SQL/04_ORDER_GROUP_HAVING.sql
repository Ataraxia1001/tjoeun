use market_db;
SELECT * FROM member;
SELECT mem_id, mem_name, debut_date FROM member ORDER BY debut_date DESC;
SELECT mem_id, mem_name, debut_date, height FROM member 
	WHERE height > 164   -- WHERE must be ahead of ORDER BY
    ORDER BY height DESC;

-- 키 164 이상이면서 데뷰일이 먼저 (ASC) 순서로 정렬 
SELECT mem_id, mem_name, debut_date, height FROM member 
	WHERE height > 164   -- WHERE must be ahead of ORDER BY
    ORDER BY height DESC, debut_date ASC;

-- LIMIT: limit the number of rows to show
SELECT * FROM member LIMIT 3;
SELECT * FROM member 
    ORDER BY debut_date ASC
	LIMIT 3;
    
    
SELECT mem_id, debut_date, height FROM member
     ORDER BY height DESC
     LIMIT 3, 2;  -- start from forth row(0 is first row) and show two rows.

SELECT mem_id, debut_date, height FROM member
     ORDER BY height DESC
     LIMIT 0, 3;  -- start from first row and show three rows.
	
SELECT distinct addr FROM member
     ORDER BY addr;  -- distinct: show unique values
     

SELECT mem_id, amount FROM buy
       ORDER BY mem_id;
       
SELECT mem_id, SUM(amount) FROM buy
       GROUP BY mem_id;
     
SELECT mem_id "회원 아이디", SUM(amount) "총 구매 개수" FROM buy
       GROUP BY mem_id; -- change column name with ""
       
SELECT mem_id "회원 ID", SUM(price*amount) "총 구매금액" FROM buy
      GROUP BY mem_id;

SELECT mem_id, AVG(amount) "평균구매개수" FROM buy
	  GROUP BY mem_id;
      
SELECT count(*) FROM member;  -- total 10 rows
SELECT count(phone1) '연락처가 있는회원' FROM member; -- two rows have no phone1 -> 8 rows with phone1

SELECT mem_id, SUM(price*amount) FROM buy
      WHERE SUM(price*amount) > 1000
      GROUP BY mem_id;   -- error: WHERE cannot be used with GROUP BY. --> Use HAVING!!
      
SELECT mem_id "회원 ID", SUM(price*amount) FROM buy
      GROUP BY mem_id
      HAVING SUM(price*amount) > 1000
      ORDER BY sum(price*amount) DESC; -- HAVING is after GROUP BY!!

-- SELECT -> GROUP BY -> HAVING -> ORDER BY -> LIMIT
	
    
    
-- Exercise
use bookstore;
SELECT * FROM book
     ORDER BY bookname;
     
SELECT * FROM book
     ORDER BY price, bookname;

SELECT * FROM book
     ORDER BY price DESC, publisher ASC; 
      
SELECT orderdate FROM orders
     ORDER BY orderdate DESC;
     
SELECT * FROM book
     WHERE bookname like '%썬%' AND price < 20000
     ORDER BY publisher DESC;

SELECT * FROM orders 
     WHERE saleprice >= 1000
     ORDER BY bookid ASC;
	

     