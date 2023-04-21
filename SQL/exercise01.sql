CREATE DATABASE bookstore;

USE bookstore;


CREATE TABLE Book
( bookid  		INT PRIMARY KEY, -- 사용자 아이디(PK)
  bookname   	VARCHAR(40) NOT NULL, 
  publisher     VARCHAR(40),  -- 인원수
  price	  		INTEGER 
);

CREATE TABLE Customer -- 구매 테이블
(  custid 		INT PRIMARY KEY, 
   username 	VARCHAR(20), 
   address 	    VARCHAR(20), 
   phone     	VARCHAR(20)
);

CREATE TABLE Orders (
    orderid INT PRIMARY KEY,
    custid INTEGER,
    bookid INTEGER,
    saleprice INTEGER,
    orderdate DATE,
    FOREIGN KEY (custid)
        REFERENCES Customer (custid),
    FOREIGN KEY (bookid)
        REFERENCES Book (bookid)
);

insert into Book values(1, '철학의 역사', '정론사', 7500);
insert into Book values(2, '3D 모델링 시작하기', '한비사', 15000);
insert into Book values(3, 'SQL의 이해', '새미디어', 2200);
insert into Book values(4, '텐서플로우 시작', '새미디어', 3500);
insert into Book values(5, '인공지능 개론', '정론사', 8000);
insert into Book values(6, '파이썬 고급', '정론사', 8000);
insert into Book values(7, 'Secure 코딩', '정보사', 7500);
insert into Book values(8, 'C++ 중급', '튜링사', 18000);
insert into Book values(9, 'Secure 코딩', '정보사', 7500);
insert into Book values(10, 'Machine learning 이해', '새미디어', 32000);

SELECT * FROM Book;

insert into Customer values(1, '박지성', '영국 맨체스타', '010-1234-1010');
insert into Customer values(2, '김연아', '대한민국 서울', '010-1223-3456');
insert into Customer values(3, '장미란', '대한민국 강원도', '010-4878-1901');
insert into Customer values(4, '추신수', '대한민국 부산', '010-8000-8765');
insert into Customer values(5, '박세리', '대한민국 대전', NULL);

SELECT * FROM Customer;

insert into Orders values(1, 1, 1, 7500, str_to_date('2021-02-01', '%Y-%m-%d'));
insert into Orders values(2, 1, 3, 44000, str_to_date('2021-02-03', '%Y-%m-%d'));
insert into Orders values(3, 2, 5, 8000, str_to_date('2021-02-03', '%Y-%m-%d'));
insert into Orders values(4, 3, 6, 7500, str_to_date('2021-02-04', '%Y-%m-%d'));
insert into Orders values(5, 4, 7, 20000, str_to_date('2021-02-05', '%Y-%m-%d'));
insert into Orders values(6, 1, 2, 15000, str_to_date('2021-02-07', '%Y-%m-%d'));
insert into Orders values(7, 4, 8, 18000, str_to_date('2021-02-07', '%Y-%m-%d'));
insert into Orders values(8, 3, 10, 32000, str_to_date('2021-02-08', '%Y-%m-%d'));
insert into Orders values(9, 2, 10, 32000, str_to_date('2021-02-08', '%Y-%m-%d'));
insert into Orders values(10, 3, 8, 18000, str_to_date('2021-02-10', '%Y-%m-%d'));


