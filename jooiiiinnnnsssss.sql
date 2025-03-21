USE BANK;


CREATE TABLE TRANSACTIONS1(
trans_id INT,	
account_id	INT,
`Date`	varchar(30),
`Type`	VARCHAR(30),
operation	VARCHAR(40),
amount	INT,
balance	FLOAT,
Purpose	VARCHAR(40),
bank	VARCHAR(45),
account_partern_id INT);

alter table TRANSACTIONS1 modify column `date` date;

FOREIGN KEY (account_id) references ACCOUNT(account_id)
);
drop table TRANSACTIONS1;
alter table TRANSACTIONS1 add FOREIGN KEY (account_id) references ACCOUNT(account_id);

select * from TRANSACTIONS1;
ALTER TABLE TRANSACTIONS1 ADD COLUMN new_date DATE;
UPDATE TRANSACTIONS1 
SET new_date = STR_TO_DATE(`date`, '%d-%m-%Y');
ALTER TABLE TRANSACTIONS1 DROP COLUMN `date`;
ALTER TABLE TRANSACTIONS1 CHANGE COLUMN new_date `date` DATE;


LOAD DATA INFILE  
'D:/transaction.csv'
into table TRANSACTIONS1
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;

SELECT * FROM  TRANSACTIONS1;
alter table TRANSACTIONS1 add index idx_purpose(Purpose);
create index idx_account_id on TRANSACTIONS(account_id);
drop index idx_purpose on TRANSACTIONS;

select * from TRANSACTIONS1;

alter table TRANSACTIONS1
partition by key(account_id)
partitions 5;

alter table TRANSACTIONS1
partition by hash(account_id)
partitions 5;

select * from TRANSACTIONS1;
alter table TRANSACTIONS1
partition by list columns (type)(
partition p0 values in ('Withdrawal'),
partition p1 values in ('Credit')
);

alter table TRANSACTIONS1
partition by range columns(Purpose)(
partition p0 values  in('Household '),
partition p1 values  in ('Old-age Pension'),
partition p2 values  in ('Home loan'),
partition p3 values  in ('Insurance Payment'),
partition p4 values  in ('Loan Payment')
);

select date from TRANSACTIONS
select count(*) from TRANSACTIONS;
select Purpose,count(*) as total from TRANSACTIONS group by Purpose;
select bank,count(*) from TRANSACTIONS1 group by bank;
select Type,count(*) from TRANSACTIONS group by Type;
select distinct year(`date`) as year from TRANSACTIONS1;


LOAD DATA INFILE  
'D:/transaction.csv'
into table TRANSACTIONS
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines terminated by '\n'
IGNORE 1 ROWS;	
select * from ORDER_LIST;
SELECT * FROM DISTRICT;
SELECT * FROM `ACCOUNT`;
select Card_Assigned,count(*) from `ACCOUNT` group by Card_Assigned;
select Account_type,count(*) from `ACCOUNT` group by Account_type;
select frequency,count(*) from `ACCOUNT` group by frequency;

SELECT * FROM  ORDER_LIST;	###
SELECT * FROM  LOAN;
select status,count(*) from loan group by status;


SELECT * FROM  TRANSACTIONS;
alter table TRANSACTIONS add index idx_purpose(Purpose);
create index idx_account_id on TRANSACTIONS(account_id);
drop index idx_purpose on TRANSACTIONS;

alter table TRANSACTIONS
partition by list columns(Purpose)(
partition p0 values  in('Household '),
partition p1 values  in ('Old-age Pension'),
partition p2 values  in ('Home loan'),
partition p3 values  in ('Insurance Payment'),
partition p4 values  in ('Loan Payment')
);

select count(*) from TRANSACTIONS;
select Purpose,count(*) as total from TRANSACTIONS group by Purpose;
select bank,count(*) from TRANSACTIONS group by bank;
select Type,count(*) from TRANSACTIONS group by Type;



SELECT * FROM  `CLIENT`;
SELECT * FROM DISPOSITION;
select count(*) from DISPOSITION;
select type , count(*) from DISPOSITION group by type;

SELECT * FROM CARD;
select count(*) from CARD;
select type , count(*) from CARD group by type;
ALTER TABLE `ACCOUNT` ADD COLUMN Card_Assigned VARCHAR(40) AFTER Account_type ;

select * from  loan;
select distinct year(`Date`) from loan ;

alter table loan
partition by range(year(`Date`))(
partition p0 values less than(2016),
partition p1 values less than(2017),
partition p2 values less than(2018),
partition p3 values less than(2019),
partition p4 values less than(2020),
partition p5 values less than(2021)
);

USE BANK;

select d.District_Name,d.Region,d.No_of_inhabitants,d.No_of_cities,d.Average_salary,d.No_of_entrepreneurs_per_1000_inhabitants,d.No_committed_crime_2017,d.No_committed_crime_2018,a.frequency,a.Account_type,a.Card_Assigned,a.`Date`,ol.bank_to,ol.account_to,ol.amount,l.amount,l.duration,l.payments,l.`status`,t.`Type`,t.operation,t.amount,t.balance,t.Purpose,t.bank,t.account_partern_id,c.Sex,c.Birth_date,dis.`type`,card.type,card.issued
from district d 
left join account a on d.District_Code=a.district_id
left join order_list ol on a.account_id=ol.account_id
left join loan l on l.account_id=a.account_id
left join transactions t on t.account_id=a.account_id
left join client c on c.district_id=d.District_Code
left join DISPOSITION dis on dis.account_id=a.account_id AND dis.client_id=c.client_id
left join card  on card.disp_id=dis.disp_id;



select * from(
SELECT 
    d.District_Name, d.Region, d.No_of_inhabitants, d.No_of_cities, 
    d.Average_salary, d.No_of_entrepreneurs_per_1000_inhabitants, 
    d.No_committed_crime_2017, d.No_committed_crime_2018,
    a.frequency, a.Account_type, a.Card_Assigned, a.`Date`,
    ol.bank_to, ol.account_to, ol.amount AS order_amount,
    l.amount AS loan_amount, l.duration, l.payments, l.`status` AS loan_status,
    t.`Type` AS transaction_type, t.operation, t.amount AS transaction_amount, 
    t.balance, t.Purpose, t.bank, t.account_partern_id,
    c.Sex, c.Birth_date,
    dis.`type` AS disposition_type,
    card.type AS card_type, card.issued AS card_issued_date
FROM DISTRICT d
LEFT JOIN ACCOUNT a ON d.District_Code = a.district_id
LEFT JOIN DISPOSITION dis ON a.account_id = dis.account_id
LEFT JOIN CLIENT c ON dis.client_id = c.client_id
LEFT JOIN CARD card ON dis.disp_id = card.disp_id
LEFT JOIN ORDER_LIST ol ON a.account_id = ol.account_id
LEFT JOIN LOAN l ON a.account_id = l.account_id
LEFT JOIN TRANSACTIONS t ON a.account_id = t.account_id )
AS bank_wal_data;

select bank,count(*) from bank_wal_data group by bank;
select count(*) from bank_wal_data;
select * from bank_wal_data where bank='Bank Creditas';


CREATE VIEW bank_wal_data AS
SELECT 
    d.District_Name, d.Region, d.No_of_inhabitants, d.No_of_cities, 
    d.Average_salary, d.No_of_entrepreneurs_per_1000_inhabitants, 
    d.No_committed_crime_2017, d.No_committed_crime_2018,
    a.frequency, a.Account_type, a.Card_Assigned, a.`Date`,
    ol.bank_to, ol.account_to, ol.amount AS order_amount,
    l.amount AS loan_amount, l.duration, l.payments, l.`status` AS loan_status,
    t.`Type` AS transaction_type, t.operation, t.amount AS transaction_amount, 
    t.balance, t.Purpose, t.bank, t.account_partern_id,
    c.Sex, c.Birth_date,
    dis.`type` AS disposition_type,
    card.type AS card_type, card.issued AS card_issued_date
FROM DISTRICT d
LEFT JOIN ACCOUNT a ON d.District_Code = a.district_id
LEFT JOIN DISPOSITION dis ON a.account_id = dis.account_id
LEFT JOIN CLIENT c ON dis.client_id = c.client_id
LEFT JOIN CARD card ON dis.disp_id = card.disp_id
LEFT JOIN ORDER_LIST ol ON a.account_id = ol.account_id
LEFT JOIN LOAN l ON a.account_id = l.account_id
LEFT JOIN TRANSACTIONS t ON a.account_id = t.account_id;

