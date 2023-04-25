-- 5장 3절 뷰
USE market_db;
SELECT mem_id, mem_name, addr FROM member;
-- 뷰를 만드는 형식
use market_db;

create view v_member 
as SELECT mem_id, mem_name, addr FROM member;

SELECT * FROM v_member;
SELECT mem_name, addr FROM v_member
WHERE addr in ('서울', '경기');



SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, concat(M.phone1, M.phone2) '연락처' 
FROM buy B inner join member M ON B.mem_id = M.mem_id;

CREATE VIEW v_memberbuy AS 
SELECT B.mem_id, M.mem_name, B.prod_name, M.addr, concat(M.phone1, M.phone2) '연락처' 
FROM buy B inner join member M ON B.mem_id = M.mem_id;


SELECT * FROM v_memberbuy WHERE mem_name = '블랙핑크';
 

CREATE view v_viewtest1
AS SELECT B.mem_id 'member ID', M.mem_name AS 'member Name', B.prod_name 'Product Name', M.addr, concat(M.phone1, M.phone2) as 'Office Phone'
FROM buy B inner join member M ON B.mem_id = M.mem_id;

SELECT 'member ID', 'member Name' FROM v_viewtest1;  -- ' is wrong syntax
-- 컬럼이름에 공백이 있으면 빽틱(`)으로 가져와야함
SELECT `member ID`, `member Name` FROM v_viewtest1;  -- ` is right syntax


alter view v_viewtest1
as select B.mem_id '회원아이디', M.mem_name as '회원이름', B.prod_name '제품이름',
concat(M.phone1, M.phone2) AS '연락처' FROM buy B inner join member M on B.mem_id = M.mem_id;

select `회원아이디`, `회원이름` from v_viewtest1;
drop view v_viewtest1;

create or replace view v_viewtest2 
as select mem_id, mem_name, addr from member;

describe v_viewtest2;
describe member;

show create view v_viewtest2;
-- 뷰테이블 수정
select * from v_member;
update v_member set addr='부산' WHERE mem_id = 'BLK';
select * from v_member;
insert into v_member(mem_id, mem_name, addr) values('BTS', '방탄소년단', '경기');


-- 키가 167이상인 뷰를 만들어보자
create view v_height167 
as select * from member where height >= 167;

select * from v_height167;

delete from v_height167 where height < 167;

select @@sql_safe_updates;  -- unsafe 옵션: 지우기방지 옵션
set sql_safe_updates = 0;  -- 0으로 셋팅해서 지우기 가능하게

-- 데이터를 입력
insert into v_height167 values('TRA', '티아라', 6, '서울', null, null, 159, '2005-11-17');
alter view v_height167
as select * from member where height >= 167 values('TOB', '텔레토비', 4, '영국', null, null, 140, '1995-04-01') 
with check option;   -- 이 옵션은 뷰에서 167이하는 입력 안되도록 함

-- 테이블 삭제시 뷰는?
create view v_complex
as select B.mem_id, M.mem_name, B.prod_name, M.addr
from buy B inner join member M on B.mem_id = M.mem_id;

drop table if exists buy, member; -- 원본테이블삭제
select * from market_db.v_complex;


  



