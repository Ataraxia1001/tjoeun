use sakila;

select count(*) from actor;
select count(*) from film;
select count(*) from customer;
select count(*) from staff;
select count(*) from rental;
select count(*) from inventory;

-- 배우 이름을 합쳐서 '배우' 컬럼으로 조회
select upper(concat(first_name, ' ', last_name)) '배우' from actor;

-- son으로 끝나는 성을 가진 배우 조회
select * from actor where last_name like '%son';
      
-- 배우들이 출연한 영화조회: 배우 이름을 합쳐서 '배우', title, release_year, 
select upper(concat(A.first_name, ' ', A.last_name)) '배우' , F.title, F.release_year from actor A, film F, film_actor B
     where A.actor_id = B.actor_id and B.film_id = F.film_id;
     
-- last_name 별 배우숫자
select last_name, count(*) from actor
     group by last_name
     order by count(*) desc, last_name;  -- same count--> order by last_name
     
     
-- country 테이블 id와 국가를 조회, australia, germany
desc country;
select country_id, country from country
    where country = 'Australia' or country ='Germany';

-- 스테프테이블 성과 이름을 합치고 staff와, address를 합치고
-- address, district, postal code, city_id 조회
select upper(concat(S.first_name, ' ', S.last_name)) 'staff name', A.address, A.district, A.postal_code, A.city_id from address A, staff S
     where A.address_id = S.address_id;   -- same as left join
       

 -- staff 성, 이름을 합치고 payment(pay컬럼)테이블과 합치고
 -- staff 이름 기준으로 그룹화하여 2005년 7월 데이터 조회
select upper(concat(S.first_name, ' ', S.last_name)) 'staff name', SUM(P.amount) 'patment amount' from staff S
       left join payment P on P.staff_id = S.staff_id
       where month(P.payment_date) = 7 and year(P.payment_date) = 2005
       group by S.first_name, S.last_name; 
       
 -- 영화별 출연 배우의 수 film, film_actor 합치고
 -- title 배우수 컬럼명:'배우'     
select F.title, count(FA.actor_id) actor_number from film F
      left join film_actor FA on FA.film_id = F.film_id
      group by F.title
      order by actor_number desc;  
	
select F.title, count(*) actor_number from film F
      left join film_actor FA on FA.film_id = F.film_id
      group by F.title
      order by actor_number desc;  


-- 영화 제목이 halloween nuts 배우이름이 성과 이름이 합쳐서 나오도록 조회
-- 서브쿼리 - 조건절에 쿼리를 새로 만들어야 함. film_actor,  actor film
select concat(first_name, ' ', last_name) actor_name from actor 
         where actor_id in (select actor_id from film_actor where film_id in (select film_id from film where lower(title) = lower('halloween nuts')));


-- 국가가 canada인 고객 이름을 서브쿼리로 찾기
-- 고객 성과 이름을 합치고 고객, email
-- customer, address, city, country 테이블 활용 서브쿼리 3번
select concat(first_name, ' ', last_name) customer_name, email from customer
        where address_id in (select address_id from address where city_id in 
                            (select city_id from city where country_id in
                            (select country_id from country where country = 'Canada')));
					
                    
-- join을 활용해서 국가가 canada인 고객 이름
select concat(C.first_name, ' ', C.last_name) customer_name, C.email, CO.country from customer C
      left join address A on A.address_id = C.address_id
      left join city CI on CI.city_id = A.city_id
      left join country CO on CO.country_id = CI.country_id
      where CO.country = 'Canada';



-- 1. 영화에서 PG등급 G등급 조회
-- rating, count(*) 수량 film
select rating, count(*) film_number from film
     where rating = 'PG' or rating = 'G'
     group by rating;

-- 2. pg or g 영화이름, rating, title, release year
select title, rating, release_year from film
       where rating ='PG' or rating = 'G';
       
-- 3. 등급별 rating, count
select rating, count(*) film_number from film
      group by rating;
      

-- rental_rate가 1~6 이하인 등급별 rating 영화의 수를 출력
select rating, count(*) from film 
      where rental_rate < 6 and rental_rate > 1
      group by rating;







