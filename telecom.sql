create database telecom;
use telecom;

create table if not exists call_drop(
 `Date` date,
 city varchar(30),
 total_calls int,
 Dropped_calls int,
 Network_Tower_id varchar(10),
 Signal_strength_DB int);
 
select * from call_drop where city = 'Prayagraj';

select * from call_drop group by city;
select Network_Tower_id,count( Network_Tower_id) as Total from call_drop group by Network_Tower_id;
select city,count( city) as Total from call_drop group by city having Total > 1200;

insert into call_drop(Date,city,total_calls,Dropped_calls,Network_Tower_id,Signal_strength_DB) values('2024-03-23','Prayagraj',15997,null, null,-64);

load data infile
'D:/big_call_drop_data.csv'
into table call_drop
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT 
    COUNT(*) AS total_rows, 
    COUNT(total_calls) AS non_null_values, 
    COUNT(*) - COUNT(Network_Tower_id) AS missing_values
FROM call_drop;

update call_drop
set Network_Tower_id = null
where city = 'Prayagraj';
Delimiter $$
create procedure city(IN v1 varchar(30))
begin
	select * from call_drop where city = v1;
end;

call city("Bangalore");
call city("Delhi")
-- case
select city,total_calls,Network_Tower_id ,
	case
		when city = "Bangalore" then "BLR"
        when city = "Delhi" then "NCR"
        else "others"
	end as city_code
from call_drop;
select *,coalesce(Network_Tower_id,'Raka') as cleaned_col from call_drop where city='Prayagraj';
delete from call_drop where Network_Tower_id is null;

create index idx_city on call_drop(city);
show indexes from call_drop;
select distinct year(Date) from call_drop;
select total_calls,count( total_calls) from call_drop group by total_calls;

alter table call_drop 
partition by hash(total_calls) 
partitions 5;

select * from call_drop limit 1;
select date,city,total_calls ,
row_number() over(partition by city order by date) as 'Row_number' 
from call_drop;

select date,city,total_calls ,
row_number() over( order by city) as 'Row_number' 
from call_drop;

select distinct city from call_drop;

select date,city,total_calls ,
rank() over(partition by city order by date) as 'Rank' 
from call_drop;

select date,city,total_calls ,
rank() over( order by city) as 'Rank' 
from call_drop;

select date,city,total_calls ,
dense_rank() over(partition by city order by date) as 'Dense Rank' 
from call_drop;

select date,city,total_calls ,
dense_rank() over( order by city) as 'Dense Rank' 
from call_drop;

select date,city,total_calls ,
row_number() over(partition by city order by date) as 'Row_number',
rank() over(partition by city order by date) as 'Rank',
dense_rank() over(partition by city order by date) as 'Dense Rank'
from call_drop;

select date,city,total_calls ,
row_number() over( order by city) as 'Row_number' ,
rank() over( order by city) as 'Rank',
dense_rank() over( order by city) as 'Dense Rank'
from call_drop;

-- experiments for rollback data which is deleted by DELETE

describe call_drop;
show columns from call_drop;
select COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH from information_schema.columns where table_name = 'call_drop';

SHOW CREATE TABLE call_drop;
select * from call_drop
delete from call_drop where city="Delhi" and Network_Tower_id="T006";
SELECT * FROM call_drop WHERE city = 'Delhi' AND Network_Tower_id = 'T006';

START TRANSACTION;
DELETE FROM call_drop WHERE city = 'Delhi' AND Network_Tower_id = 'T006';
ROLLBACK;

SHOW TABLE STATUS LIKE 'call_drop';
ALTER TABLE call_drop ENGINE = InnoDB;

SET AUTOCOMMIT = 0;

START TRANSACTION;
DELETE FROM call_drop WHERE city = 'Delhi' AND Network_Tower_id = 'T006';
ROLLBACK;
SELECT * FROM call_drop WHERE city = 'Delhi' AND Network_Tower_id = 'T005';
SELECT COUNT(*) FROM call_drop WHERE city = 'Delhi' AND Network_Tower_id = 'T006';



SET AUTOCOMMIT = 0;
START TRANSACTION;
DELETE FROM call_drop WHERE city = 'Delhi' AND Network_Tower_id = 'T005';
ROLLBACK;
SELECT * FROM call_drop WHERE city = 'Delhi' AND Network_Tower_id = 'T005';  -- चेक करें कि डेटा वापस आया या नहीं
SHOW TABLE STATUS LIKE 'call_drop';
SELECT @@AUTOCOMMIT;


CREATE TABLE call_drop_test AS SELECT * FROM call_drop WHERE 1=0; -- खाली टेबल बनाएं
ALTER TABLE call_drop_test ENGINE = InnoDB; -- इसे 100% InnoDB में बदलें
INSERT INTO call_drop_test SELECT * FROM call_drop WHERE city = 'Delhi' AND Network_Tower_id = 'T007';
select * from call_drop_test;
SET AUTOCOMMIT = 0;
START TRANSACTION;
DELETE FROM call_drop_test WHERE city = 'Delhi' AND Network_Tower_id = 'T007';
ROLLBACK;
SELECT * FROM call_drop_test WHERE city = 'Delhi' AND Network_Tower_id = 'T007';
SHOW TABLE STATUS LIKE 'call_drop_test';
SELECT @@AUTOCOMMIT;

SELECT TABLE_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME 
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE REFERENCED_TABLE_NAME = 'call_drop';

