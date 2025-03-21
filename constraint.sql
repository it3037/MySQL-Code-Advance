create database dress_data;
use dress_data;

create table if not exists dress(
`Dress_ID` varchar(30),	
`Style`	varchar(30),	
`Price`	varchar(30),	
`Rating`	varchar(30),	
`Size`	varchar(30),	
`Season`	varchar(30),	
`NeckLine`	varchar(30),	
`SleeveLength` varchar(30),		
`waiseline`	varchar(30),	
`Material`	varchar(30),	
`FabricType`	varchar(30),	
`Decoration`	varchar(30),	
`Pattern Type` varchar(30),		
`Recommendation` varchar(30));

LOAD DATA INFILE  
'D:/AttributeDataSet.csv'
into table dress
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;	

select * from dress;

create table if not exists test(
test_id int auto_increment,
test_name varchar(30),
test_mailid varchar(30),
test_address varchar(30),
primary key(test_id));

select * from test;
insert into test values(1,'sudhanshu','sudhanshu@ineuron.ai','benglaore'),
(2,'krish','krish@gmail.com', 'bengalore'),
(3,'hitesh' ,'hitesh@ineuron.ai','bengalore'),
(4,'shubahm' , 'shudham@gmail.com', 'jaipur');

create table if not exists test2(
test_id int not null auto_increment,
test_name varchar(30),
test_mailid varchar(30),
test_address varchar(30),
primary key(test_id));

insert into test2(test_name,test_mailid,test_address) values('sudhanshu','sudhanshu@ineuron.ai','benglaore'),
('krish','krish@gmail.com', 'bengalore'),
('hitesh' ,'hitesh@ineuron.ai','bengalore'),
('shubahm' , 'shudham@gmail.com', 'jaipur');

insert into test2 values(1,'sudhanshu','sudhanshu@ineuron.ai','benglaore'),
(2,'krish','krish@gmail.com', 'bengalore'),
(3,'hitesh' ,'hitesh@ineuron.ai','bengalore'),
(4,'shubahm' , 'shudham@gmail.com', 'jaipur');

select * from test2;
create table if not exists test3(
test_id int,
test_name varchar(30),
test_mailid varchar(30),
test_address varchar(30),
test_salery int check(test_salery > 10000));

alter table test3 add constraint

insert into test3 values (1,'sudhanshu','sudhanshu@ineuron.ai','benglaore' , 50000),
(2,'krish','krish@gmail.com', 'bengalore' , 30000),
(3,'hitesh' ,'hitesh@ineuron.ai','bengalore' , 111000),
(4,'shubahm' , 'shudham@gmail.com', 'jaipur',20000);

select * from test3;

create table if not exists test4(
test_id int,
test_name varchar(30),
test_mailid varchar(30),
test_address varchar(30) check(test_address="bangalore"),
test_salery int check(test_salery > 10000));

insert into test4 values (1,'sudhanshu','sudhanshu@ineuron.ai','bangalore' , 50000),
(2,'krish','krish@gmail.com', 'bangalore' , 30000),
(3,'hitesh' ,'hitesh@ineuron.ai','bangalore' , 111000),
(4,'shubahm' , 'shudham@gmail.com', 'jaipur',20000);

insert into test4 values (1,'sudhanshu','sudhanshu@ineuron.ai','bangalore' , 50000),
(2,'krish','krish@gmail.com', 'bangalore' , 30000),
(3,'hitesh' ,'hitesh@ineuron.ai','bangalore' , 111000),
(4,'shubahm' , 'shudham@gmail.com', 'bangalore',20000);

select * from test4;

create table if not exists test5(
test_id int not null,
test_name varchar(30),
test_mailid varchar(30),
test_address varchar(30) check(test_address="bangalore"),
test_salery int check(test_salery > 10000));

select * from test5;
insert into test5(test_id,test_name,test_mailid,test_address,test_salery) value(12,'krish','krish@gmail.com', 'bangalore' , 30000);

create table if not exists test6(
test_id int not null default 0,
test_name varchar(30),
test_mailid varchar(30),
test_address varchar(30) check(test_address="bangalore"),
test_salery int check(test_salery > 10000));

insert into test6(test_name,test_mailid,test_address,test_salery) value('krish','krish@gmail.com', 'bangalore' , 30000);
insert into test6(test_id,test_name,test_mailid,test_address,test_salery) value(101,'krish','krish@gmail.com', 'bangalore' , 30000);
select * from test6;

create table if not exists test7(
test_id int not null default 0,
test_name varchar(30),
test_mailid varchar(30) unique,
test_address varchar(30) check(test_address="bangalore"),
test_salery int check(test_salery > 10000));

insert into test7(test_name,test_mailid,test_address,test_salery) value('krish','krish@gmail.com', 'bangalore' , 30000);
insert into test7(test_id,test_name,test_mailid,test_address,test_salery) value(101,'krish','krishnaik@gmail.com', 'bangalore' , 30000);
select * from test7;

create table if not exists test8(
test_id int not null auto_increment,
test_name varchar(30) not null default "unknown",
test_mailid varchar(30) unique not null,
test_address varchar(30) check(test_address="bangalore")  not null,
test_salery int check(test_salery > 10000) not null,
primary key(test_id));

insert into test8(test_id,test_name,test_mailid,test_address,test_salery) value(101,'krish','krishnaik@gmail.com', 'bangalore' , 30000);
select * from test8;
select count(distinct test_name) from test8;
select distinct test_name,test_address,test_salery from test8 where test_address='Bangalore';
select  test_name,avg(test_salery) as salary,test_address from test8 group by test_address having salary>10000;
create index idx_test_id on test8(test_id);
