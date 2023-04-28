use sakila;

select * from film;


select rating, rental_rate, count(*) movie_number, sum(rental_rate), avg(rental_rate), min(rental_rate), max(rental_rate) from film
    group by rating, rental_rate
    order by avg(rental_rate) desc;
    
    
select rating, rental_rate, count(*) movie_number, avg(rental_rate) from film
    group by rating
    order by avg(rental_rate) desc;
    

select film_id, title from film
        where film_id in (select film_id from film_category where category_id in
						 (select category_id from category where genre = 'Family'));
     

select F.film_id, F.title, C.genre from film F
        inner join film_category FC on F.film_id = FC.film_id
        inner join category C on C.category_id = FC.category_id
        where C.genre = 'Action';
        
select C.genre, count(F.film_id) 영화수, sum(F.rental_rate), avg(F.rental_rate) 평균,
      max(F.rental_rate) 최대, min(F.rental_rate) 최소 from film F, film_category FC
      join category 
      group by
      having C.genre = 'Action'
      order by 평균 desc;
        
        
        

select genre, count(*) movie_number, ifnull(sum(P.amount), 0) revenue from category C
        inner join film_category FC on FC.category_id = C.category_id
        inner join inventory I on I.film_id = FC.film_id
        inner join rental R on R.inventory_id = I.inventory_id
        inner join payment P on P.rental_id = R.rental_id
        group by C.genre
        order by revenue desc;
        
        
create or replace view v_cat_revenue as
select genre, count(*) movie_number, ifnull(sum(P.amount), 0) revenue from category C
        inner join film_category FC on FC.category_id = C.category_id
        inner join inventory I on I.film_id = FC.film_id
        inner join rental R on R.inventory_id = I.inventory_id
        inner join payment P on P.rental_id = R.rental_id
        group by C.genre
        order by revenue desc;

select * from v_cat_revenue limit 10;
        
        



