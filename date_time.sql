create database sales;
use sales;

drop table  sales;
CREATE TABLE sales (
	order_id VARCHAR(15) NOT NULL, 
	order_date VARCHAR(15) NOT NULL, 
	ship_date VARCHAR(15) NOT NULL, 
	ship_mode VARCHAR(14) NOT NULL, 
	customer_name VARCHAR(22) NOT NULL, 
	segment VARCHAR(11) NOT NULL, 
	state VARCHAR(36) NOT NULL, 
	country VARCHAR(32) NOT NULL, 
	market VARCHAR(6) NOT NULL, 
	region VARCHAR(14) NOT NULL, 
	product_id VARCHAR(16) NOT NULL, 
	category VARCHAR(15) NOT NULL, 
	sub_category VARCHAR(11) NOT NULL, 
	product_name VARCHAR(127) NOT NULL, 
	sales DECIMAL(38, 0) NOT NULL, 
	quantity DECIMAL(38, 0) NOT NULL, 
	discount DECIMAL(38, 3) NOT NULL, 
	profit DECIMAL(38, 8) NOT NULL, 
	shipping_cost DECIMAL(38, 2) NOT NULL, 
	order_priority VARCHAR(8) NOT NULL, 
	`year` DECIMAL(38, 0) NOT NULL
);
select  * from sales;

set session sql_mode=''

load data infile 
'D:/sales_data_final.csv'
into table sales 
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows 

select  * from sales;

select str_to_date(order_date,'%m/%d/%Y') from sales;

select count(*) from sales;

alter table sales
add column order_date_new date after order_date;
update sales
set order_date_new=str_to_date(order_date,'%m/%d/%Y');

alter table sales
add column ship_date_new date after ship_date;
update sales
set ship_date_new=str_to_date(ship_date,'%m/%d/%Y');

SET SQL_SAFE_UPDATES=0;
select * from sales;

select * from sales where ship_date_new='2011-01-05';
select * from sales where ship_date_new>'2011-01-05';
select * from sales where ship_date_new<'2011-01-05';

select * from sales where ship_date_new between '2011-01-05' and '2011-08-30';

select now();
select curdate();
select curtime();
select * from sales where ship_date_new<date_sub(now(),interval 1 week);
select date_sub(now(),interval 1 week);
select date_sub(now() , interval 3 day);
select date_sub(now() , interval 30 day);
select date_sub(now() , interval 30 year);
select year(now());
select dayname(now());

alter table sales
add column flag date after order_id;
select * from sales;
update sales
set flag=now();

select * from sales limit 2;
alter table sales
modify column year datetime;

alter table sales
add column Year_New date;
alter table sales
add column Month_New date;
alter table sales
add column Day_New date;

alter table sales
modify column Year_new int;

alter table sales
modify column Month_new int;

alter table sales
modify column Day_new int;
select * from sales;

update sales set Year_new=year(order_date_new);
update sales set Month_new=month(order_date_new);
update sales set Day_new=day(order_date_new);

select month(order_date_new) from sales;
select year_new,avg(sales) from sales group by year_new;
select year_new,sum(sales) from sales group by year_new;
select year_new,min(sales) from sales group by year_new;
select year_new,max(sales) from sales group by year_new;

select year_new,sum(quantity) from sales group by year_new;


select year_new,(sales*discount+shipping_cost)  as CTC from sales;
select order_id ,discount , if(discount > 0 ,'yes' , 'no') as discount_flag from sales;
alter table sales drop Year_new;
alter table sales rename column Day_new to Day;
alter table sales
add column discount_flag date after discount
alter table sales
modify column discount_flag varchar(20) after discount

select * from sales ;

select discount_flag , count(*) from sales group by discount_flag 

select count(*) from  sales where discount > 0 

update sales
set discount_flag = if(discount > 0, 'yes', 'no');
select * from sales;