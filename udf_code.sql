create database fuction;

use fuction;

delimiter $$
create function addit(a int,b int)
returns int
deterministic
begin
	declare c int;
    set c=a+b;
    return c;
end $$
delimiter ;

select addit(10,20)


delimiter $$
create function subst(a int,b int)
returns int
deterministic
	begin 
    declare c int;
    set c=a+b;
    return c;
end $$

delimiter ;
select subst(9,5);

delimiter $$
create function cancate(fname varchar(20),lname varchar(20))
returns varchar(100)
deterministic
begin
	return CONCAT(fname ,' ', lname);
end $$
select cancate("raka","pal");

DELIMITER ;
delimiter $$
create function revStr(str varchar(100))
returns varchar(100)
deterministic
begin
	return reverse(str);
end $$
delimiter ;

select revStr('Rakesh')

delimiter $$
create function hashPwd(password varchar(255))
returns varchar(255)
deterministic
begin
	return sha2(password,256);
end $$
delimiter ;
select hashPwd('Rakesh143')

DELIMITER $$
CREATE FUNCTION CalculateBonus(salary DECIMAL(10,2), experience INT)  
RETURNS DECIMAL(10,2)  
DETERMINISTIC  
BEGIN  
    DECLARE bonus DECIMAL(10,2);

    IF experience >= 10 THEN  
        SET bonus = salary * 0.20;  -- 20% bonus
    ELSEIF experience >= 5 THEN  
        SET bonus = salary * 0.10;  -- 10% bonus
    ELSE  
        SET bonus = salary * 0.05;  -- 5% bonus
    END IF;

    RETURN bonus;
END $$

DELIMITER ;
SELECT CalculateBonus(60000, 7)