use market_db;
SELECT * FROM member;
SELECT * FROM market_db.member;
SELECT addr, debut_date "데뷰 일자", mem_name FROM member;
SELECT * FROM member WHERE mem_name = '블랙핑크';
SELECT * FROM member WHERE mem_number = '4';

SELECT mem_id, mem_name FROM member WHERE height > 162;
SELECT  mem_id, mem_name FROM member WHERE height > 165 AND mem_number > 6;
SELECT mem_id, mem_name FROM member WHERE height > 165 or mem_number > 6;
SELECT mem_id, mem_name FROM member WHERE height >= 163 and height <= 165;
SELECT mem_id, mem_name FROM member WHERE height BETWEEN 163 AND 165;

SELECT mem_name, addr FROM member WHERE addr = '경기' OR addr = '전남' OR addr = '경남';
SELECT mem_name, addr FROM member WHERE addr IN('경기', '경남', '전남');

SELECT * FROM member WHERE mem_name like '우%';
SELECT * FROM member WHERE mem_name like '__핑크';
SELECT height FROM member WHERE mem_name = '에이핑크'; -- height = 164 here

-- 에이핑크의 키보다 큰 그룹을 찾는 쿼리
SELECT mem_name, height FROM member WHERE height > (SELECT height FROM member WHERE mem_name = '에이핑크'); -- height > 164 here




