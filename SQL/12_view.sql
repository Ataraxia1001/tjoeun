use bookstore;
insert into book values(12, 'OpenCV 파이썬', '포웨이', 23500);
insert into book values(13, '자연어 처리 시작하기', '투시즌', 20000);
insert into book values(14, 'SQL 이해', '새미디어', 22000);
insert into customer values(6, '박보영', '서울 서초구', '010-9999-5555');
insert into customer values(7, '오정세', '서울 중구', '010-8888-4444');
insert into customer values(8, '이병헌', '서울 성북구', '010-7777-3333');


insert into orders values(11, 6, 12, 23500, str_to_date('2020-02-01', '%Y-%m-%d'));
insert into orders values(12, 6, 14, 44000, str_to_date('2020-02-03', '%Y-%m-%d'));
insert into orders values(13, 8, 13, 20000, str_to_date('2020-02-03', '%Y-%m-%d'));
insert into orders values(14, 3, 13, 20000, str_to_date('2020-02-04', '%Y-%m-%d'));
insert into orders values(15, 4, 12, 23500, str_to_date('2020-02-03', '%Y-%m-%d'));
insert into orders values(16, 5, 8, 35000, str_to_date('2020-02-03', '%Y-%m-%d'));

select * from book where bookid in (12, 13, 14);


-- exercise

-- 1. v_order 테이블 만들기: orderid, custid(0),
-- username, bookid(0), saleprice, orderdate, 
-- custid(c) = custid(o) and bookid(b) = bookid(o)
create view v_order
as select C.username, O.saleprice, O.orderdate from customer C
inner join orders O on O.custid = C.custid;

select * from v_order;

-- 2. v_order 도서가격이 20000 이상이 레코드로 변경
create or replace view v_orders(custid, username, adress)
as select C.custid, username, address from customer C, orders O, book B
where B.price >= 20000;
select * from v_orders;

-- 3. v_cust_purchase 테이블 생성
--    username(c) '고객', sum(O.saleprice) '구매액'
create view v_cust_purchase
as select C.username as '고객', sum(O.saleprice) '구매액'
from customer C, orders O
where C.custid = O.custid
group by 고객
order by 구매액 DESC;

select * from v_cust_purchase;










