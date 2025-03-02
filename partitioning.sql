# https://chatgpt.com/share/67b9ea0e-a938-800e-8d04-f0f52581e337

create database partitioning;
use partitioning;

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date VARCHAR(100),
    customer_name VARCHAR(100),
    amount DECIMAL(10,2),
    PRIMARY KEY (order_id)
    );
    
ALTER TABLE orders 
MODIFY COLUMN order_date DATE;
ALTER TABLE orders ADD COLUMN order_date_temp DATE;
UPDATE orders 
SET order_date_temp = STR_TO_DATE(order_date, '%d-%m-%Y');

ALTER TABLE orders DROP COLUMN order_date;
ALTER TABLE orders CHANGE COLUMN order_date_temp order_date DATE;

    
drop table orders;
select * from orders;
LOAD DATA INFILE  
'D:/orders.csv'
into table orders
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;	

select * from orders;
SELECT distinct YEAR(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_year FROM orders;
SELECT YEAR(order_date) AS order_year FROM orders;
ALTER TABLE orders ADD COLUMN order_year INT;
UPDATE orders 
SET order_year = YEAR(STR_TO_DATE(order_date, '%d-%m-%Y'));

select * from orders;

ALTER TABLE orders
partition by hash(order_id)
partitions 5;
select partition_name , table_name , table_rows from information_schema.partitions where table_name = 'orders';

ALTER TABLE orders 
PARTITION BY KEY(order_id) PARTITIONS 3;

select partition_name , table_name , table_rows from information_schema.partitions where table_name = 'orders';
