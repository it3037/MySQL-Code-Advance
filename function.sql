# https://chatgpt.com/share/67bea4f8-ec8c-800e-b544-08d1cab94867

set global max_allowed_packet = 209715200;

use sales;
select * from sales;

DELIMITER $$
create function add_to_col(a int)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE b int;
    set b=a+10;
    return b;
end $$

select customer_name, max(sales) from sales;

DELIMITER $$

CREATE PROCEDURE get_all_sales()
BEGIN
    SELECT * FROM sales;
END $$

DELIMITER ;
call get_all_sales();

DELIMITER $$

CREATE PROCEDURE find_5th_highest_profit()
BEGIN
    SELECT profit 
    FROM sales 
    WHERE profit < (SELECT MAX(profit) FROM sales WHERE profit < 
                   (SELECT MAX(profit) FROM sales WHERE profit < 
                   (SELECT MAX(profit) FROM sales WHERE profit < 
                   (SELECT MAX(profit) FROM sales))))
    ORDER BY profit DESC
    LIMIT 1;
END $$

DELIMITER ;

CALL find_5th_highest_profit();

select add_to_col(23);
select * from sales;
select quantity from sales;
select customer_name,quantity, add_to_col(quantity) from sales;

DELIMITER $$
create function final_profit(profit int,discount int)
returns int
deterministic
begin
declare final_profit int;
set final_profit=profit-discount;
return final_profit;
end $$
DELIMITER ;

select customer_name,profit,discount,final_profit(profit,discount) as final_profit from sales;

DELIMITER $$
create function final_profit_real(profit int,discount int,sales int)
returns int
deterministic
begin
declare final_profit int;
set final_profit=profit-sales*discount;
return final_profit;
end $$
DELIMITER ;
select profit,discount,sales,final_profit_real(profit,discount,sales) as final_profit_real from sales;

DELIMITER $$
create function final_profits_real(profit decimal(20,6),discount decimal(20,6),
sales decimal(20,6))
returns int
deterministic
begin
declare final_profit int;
set final_profit=profit-sales*discount;
return final_profit;
end $$
DELIMITER ;

select profit,discount,sales,final_profits_real(profit,discount,sales) as final_profit_real from sales;

DELIMITER $$
create function int_to_str(a INT)
returns varchar(30)
deterministic
BEGIN 
	DECLARE b varchar(30) ;
	set b = a ;
    return b ;
end $$
DELIMITER ;

DELIMITER &&
create function int_to_str (a int)
returns varchar(30)
DETERMINISTIC
begin
	declare b varchar(30);
	set b = a;
	return b;
end&&

select int_to_str(45);

select * from sales;
select quantity,int_to_str(quantity) from sales;
select max(sales),min(sales) from sales;

1  - 100 - super affordable product 
100-300 - affordable 
300 - 600 - moderate price 
600 + - expensive 

delimiter &&
create function mark_sales(sales int)
returns varchar(30)
deterministic
begin
declare flag_sales varchar(30); 
if sales  <= 100  then 
	set flag_sales = "super affordable product" ;
elseif sales > 100 and sales < 300 then 
	set flag_sales = "affordable" ;
elseif sales >300 and sales < 600 then 
	set flag_sales = "moderate price" ;
else 
	set flag_sales = "expensive" ;
end if ;
return flag_sales;
end &&

select mark_sales(10);
select sales,mark_sales(sales) from sales;

set @var=10;
generate_data:loop
set @var=@var+1;
if @var = 100 then
	leave generate_data;
end if;
end loop generate_data;

Delimiter $$
create procedure insert_data()
Begin
set @var  = 10 ;
generate_data : loop
insert into loop_table values (@var);
set @var = @var + 1  ;
if @var  = 100 then 
	leave generate_data;
end if ;
end loop generate_data;
End $$

call insert_data()


#Task 
#	1 . Create a loop for a table to insert a record into a tale for two columns in first coumn you have to inset a data ranging from 1 to 100 and in second column you hvae to inset a square of the first column 
#	2 . create a user defined function to find out a date differences in number of days 
#    3 . create a UDF to find out a log base 10 of any given number 
#    4 . create a UDF which will be able to check a total number of records avaible in your table 
#    5 . create a procedure to find out  5th highest profit in your sales table you dont have to use rank and windowing function 


#A UDF to Calculate Square of a Number
DELIMITER $$
CREATE FUNCTION square(n INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN n * n;
END $$

DELIMITER ;

select square(5)

#UDF for Factorial Calculation
DELIMITER $$
CREATE FUNCTION factorial(n INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE fact INT DEFAULT 1;
    DECLARE i INT DEFAULT 1;
    WHILE i <= n DO
        SET fact = fact * i;
        SET i = i + 1;
    END WHILE;
    RETURN fact;
END $$

select factorial(5)

# Format a Phone Number (Standardize Input)
DELIMITER $$
CREATE FUNCTION format_phone(phone VARCHAR(20)) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    -- Remove non-numeric characters
    DECLARE cleaned_phone VARCHAR(20);
    SET cleaned_phone = REPLACE(REPLACE(REPLACE(phone, ' ', ''), '-', ''), '(', '');
    SET cleaned_phone = REPLACE(cleaned_phone, ')', '');
    
    -- Format as +91 XXXXX XXXXX (assuming Indian numbers)
    IF LENGTH(cleaned_phone) = 10 THEN
        RETURN CONCAT('+91 ', LEFT(cleaned_phone, 5), ' ', RIGHT(cleaned_phone, 5));
    ELSE
        RETURN cleaned_phone; -- Return as is if not a 10-digit number
    END IF;
END $$

DELIMITER ;
 select format_phone(6394182793)
 
#UDF: Calculate GST (Tax) on a Product Price
DELIMITER $$

CREATE FUNCTION calculate_gst(price DECIMAL(10,2), gst_rate DECIMAL(5,2)) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN price + (price * gst_rate / 100);
END $$

DELIMITER ;
select calculate_gst(100000,18)

#UDF: Generate Unique Business Code for Clients

DELIMITER $$

CREATE FUNCTION generate_client_code(client_name VARCHAR(50), client_id INT) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CONCAT(UPPER(LEFT(client_name, 3)), client_id);
END $$

DELIMITER ;

select generate_client_code("Raka",101)

DELIMITER $$

CREATE FUNCTION date_diff_days(start_date DATE, end_date DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end_date, start_date);
END $$

DELIMITER ;
select date_diff_days('01-02-2025','17-02-2025')
SELECT date_diff_days('2024-01-01', '2025-02-01');  -- Output: 31
