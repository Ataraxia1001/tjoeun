SELECT * FROM member;
SELECT member_name, member_addr FROM member;
SELECT * FROM member WHERE member_name = '아이유'; -- SELECT chooses column, WHERE chooses row.
CREATE INDEX idx_member_name ON member(member_name);
SELECT * FROM member WHERE member_name = '아이유';
CREATE VIEW member_view
AS 
    SELECT * FROM member;
SELECT * FROM member_view;  -- view is not real table. It is only for reading.

DELIMITER //   -- sored procedure. it is like a function in ordinary programming language.
CREATE PROCEDURE myProc()
BEGIN
	SELECT * FROM member WHERE member_name = '나훈아';
    SELECT * FROM product WHERE product_name = '삼각김밥';
END//
DELIMITER ; 

CALL myProc();


 