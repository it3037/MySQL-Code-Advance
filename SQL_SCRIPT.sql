CREATE DATABASE BANK;
USE BANK;
drop table bank_wal_data;
show tables;
show table status;

CREATE TABLE DISTRICT(
District_Code INT PRIMARY KEY	,
District_Name VARCHAR(100)	,
Region VARCHAR(100)	,
No_of_inhabitants	INT,
No_of_municipalities_with_inhabitants_less_499 INT,
No_of_municipalities_with_inhabitants_500_btw_1999	INT,
No_of_municipalities_with_inhabitants_2000_btw_9999	INT,
No_of_municipalities_with_inhabitants_less_10000 INT,	
No_of_cities	INT,
Ratio_of_urban_inhabitants	FLOAT,
Average_salary	INT,
No_of_entrepreneurs_per_1000_inhabitants INT,
No_committed_crime_2017	INT,
No_committed_crime_2018 INT
) ;

select * from DISTRICT;

CREATE TABLE ACCOUNT(
account_id INT PRIMARY KEY,
district_id	INT,
frequency	VARCHAR(40),
`Date` DATE ,
Account_type VARCHAR(40),
Card_Assigned VARCHAR(40),
FOREIGN KEY (district_id) references DISTRICT(District_Code) 
);

CREATE TABLE ORDER_LIST(
order_id	INT PRIMARY KEY,
account_id	INT,
bank_to	VARCHAR(45),
account_to	INT,
amount DECIMAL(10,2),
FOREIGN KEY (account_id) references ACCOUNT(account_id)
);

CREATE TABLE LOAN(
loan_id	INT ,
account_id	INT,
`Date`	DATE,
amount	INT,
duration	INT,
payments	INT,
`status` VARCHAR(35),
FOREIGN KEY (account_id) references ACCOUNT(account_id)
);

CREATE TABLE TRANSACTIONS(
trans_id INT,	
account_id	INT,
`Date`	varchar(30),
`Type`	VARCHAR(30),
operation	VARCHAR(40),
amount	INT,
balance	FLOAT,
Purpose	VARCHAR(40),
bank	VARCHAR(45),
account_partern_id INT,
FOREIGN KEY (account_id) references ACCOUNT(account_id));

CREATE TABLE CLIENT(
client_id	INT PRIMARY KEY,
Sex	CHAR(10),
Birth_date	DATE,
district_id INT,
FOREIGN KEY (district_id) references DISTRICT(District_Code) 
);

CREATE TABLE DISPOSITION(
disp_id	INT PRIMARY KEY,
client_id INT,
account_id	INT,
`type` CHAR(15),
FOREIGN KEY (account_id) references ACCOUNT(account_id),
FOREIGN KEY (client_id) references CLIENT(client_id)
);

CREATE TABLE CARD(
card_id	INT PRIMARY KEY,
disp_id	INT,
`type` CHAR(10)	,
issued DATE,
FOREIGN KEY (disp_id) references DISPOSITION(disp_id)
);

SELECT * FROM DISTRICT;
SELECT * FROM `ACCOUNT`;
SELECT * FROM ORDER_LIST;
SELECT * FROM LOAN;
SELECT * FROM TRANSACTIONS;
SELECT * FROM `CLIENT`;
SELECT * FROM DISPOSITION;
SELECT * FROM CARD;

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


##https://chatgpt.com/share/67cfe8a6-ceb8-800e-a302-a6473a8f11fa
## Find all districts jisme at least ek account hai
SELECT distinct District_Name 
FROM DISTRICT d
WHERE EXISTS (
    SELECT 1 
    FROM ACCOUNT a 
    WHERE a.district_id = d.District_Code
);


SELECT account_id, balance
FROM TRANSACTIONS
WHERE balance < ANY (
    SELECT amount 
    FROM LOAN
);


SELECT distinct trans_id, amount 
FROM TRANSACTIONS
WHERE amount = ANY (
    SELECT amount 
    FROM ORDER_LIST
);

SELECT account_id, balance
FROM TRANSACTIONS
WHERE balance < ALL (
    SELECT amount 
    FROM loan
);

SELECT c.client_id, c.Sex, c.Birth_date
FROM CLIENT c
WHERE EXISTS (
    SELECT 1
    FROM TRANSACTIONS t
    WHERE t.account_id IN (
        SELECT a.account_id FROM ACCOUNT a WHERE a.district_id = c.district_id
    )group by sex
);

SELECT t.trans_id, t.account_id, t.amount AS Transaction_amount
FROM TRANSACTIONS t
WHERE t.amount > ANY (
    SELECT l.amount FROM LOAN l
);

SELECT a.account_id, a.frequency, a.Date, t.balance
FROM ACCOUNT a
JOIN TRANSACTIONS t ON a.account_id = t.account_id
WHERE t.balance > ALL (
    SELECT l.amount FROM LOAN l
);

-- INSERT INTO SELECT – Data Copy Karna
-- 👉 Purpose:

-- Ek table se doosre table me data copy karna.
-- Jo records SELECT se aayenge, unko INSERT INTO dusre table me save karega.
-- Naye records create honge bina manually enter kare.

INSERT INTO CUSTOMER_BACKUP (client_id, Name, Birth_date, District_id)
SELECT client_id, Name, Birth_date, District_id
FROM CUSTOMER
WHERE Birth_date >= '2000-01-01';

CREATE TABLE IF NOT EXISTS TRANSACTION_ARCHIVE (
    trans_id INT,
    account_id INT,
    Date VARCHAR(30),
    Type VARCHAR(30),
    amount INT,
    balance FLOAT
);


INSERT INTO TRANSACTION_ARCHIVE (trans_id, account_id, Date, Type, amount, balance)
SELECT trans_id, account_id, Date, Type, amount, balance
FROM TRANSACTIONS
WHERE Date < '2015-01-01';
select * from TRANSACTION_ARCHIVE;

-- IFNULL() function NULL values ko replace karta hai kisi default value se.
-- Agar column me NULL value hai, toh yeh doosri specified value return karega.
-- Data consistency aur reporting ke liye useful hai.
-- IFNULL(expression, default_value)


SELECT loan_id, account_id, 
    IFNULL(repayment_date, 'Not Paid') AS Repayment_Status
FROM LOAN;
select distinct status from loan;
select * from loan;
-- CASE statement conditional logic apply karne ke liye use hota hai.
-- IF-ELSE ki tarah kaam karta hai, lekin SQL queries ke andar.
-- Reports aur data transformation me bohot useful hai.

SELECT loan_id, account_id, amount, status,
    CASE 
        WHEN status = 'Contract Finished' THEN 'Approved'
        WHEN status = 'Running Contract' THEN 'Pending'
        WHEN status = 'Loan not payed' THEN 'Declined'
        ELSE 'Unknown Status'
    END AS Loan_Status
FROM LOAN;

SELECT trans_id, account_id, amount, 
    CASE 
        WHEN amount < 1000 THEN 'Small Transaction'
        WHEN amount BETWEEN 1000 AND 10000 THEN 'Medium Transaction'
        ELSE 'Large Transaction'
    END AS Transaction_Type
FROM TRANSACTIONS;

SELECT order_id, account_id, amount,
    CASE 
        WHEN amount >= 10000 THEN amount * 0.20  -- 20% discount
        WHEN amount >= 5000 THEN amount * 0.10   -- 10% discount
        ELSE amount * 0.05                       -- 5% discount
    END AS Discount_Amount
FROM ORDER_list;

select * from ORDER_list;
SELECT trans_id, account_id, amount,
    CASE 
        WHEN amount > 50000 THEN 'High Risk'
        WHEN amount BETWEEN 30000 AND 50000 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Fraud_Risk_Level
FROM TRANSACTIONS;

#What is the demographic profile of the bank's clients and how does it vary across districts? 
SELECT * FROM DISTRICT;
SELECT * FROM `ACCOUNT`;
SELECT * FROM ORDER_LIST;
SELECT * FROM LOAN;
SELECT * FROM TRANSACTIONS;
SELECT * FROM `CLIENT`;
SELECT * FROM DISPOSITION;
SELECT * FROM CARD;

SELECT 
    d.District_Name, c.Sex, 
    COUNT(c.client_id) AS Total_Clients,
    CAST(AVG(YEAR(CURDATE()) - YEAR(c.Birth_date)) AS unsigned) AS Avg_Age
FROM CLIENT c
JOIN DISTRICT d ON c.district_id = d.District_Code
GROUP BY d.District_Name, c.Sex
ORDER BY d.District_Name;

##How the banks have performed over the years. Give their detailed analysis year & month-wise. 
SELECT 
    YEAR(t.Date) AS Year, 
    MONTH(t.Date) AS Month,
    COUNT(t.trans_id) AS Total_Transactions,
    SUM(t.amount) AS Total_Transaction_Amount
FROM TRANSACTIONS t
GROUP BY YEAR(t.Date), MONTH(t.Date)
ORDER BY YEAR(t.Date), MONTH(t.Date);


SELECT 
    a.Account_type, 
    COUNT(a.account_id) AS Total_Accounts, 
    SUM(t.amount) AS Total_Revenue
FROM ACCOUNT a
left join TRANSACTIONS t ON a.account_id = t.account_id
GROUP BY a.Account_type
ORDER BY Total_Revenue DESC;

SELECT 
    c.type AS Card_Type, 
    COUNT(c.card_id) AS Total_Cards,
    SUM(t.amount) AS Total_Spent
FROM CARD c
JOIN TRANSACTIONS t ON c.disp_id = t.account_id
GROUP BY c.type
ORDER BY Total_Spent DESC;

SELECT 
    t.Purpose, 
    SUM(t.amount) AS Total_Expense
FROM TRANSACTIONS t
WHERE t.Type = 'Withdrawal'
GROUP BY t.Purpose
ORDER BY Total_Expense DESC;

select * from TRANSACTIONS;

select  Purpose,count(Purpose) from TRANSACTIONS group by Purpose;

SELECT 
    l.status AS Loan_Status, 
    COUNT(l.loan_id) AS Total_Loans, 
    SUM(l.amount) AS Total_Loan_Amount,
    d.District_Name
FROM LOAN l
JOIN ACCOUNT a ON l.account_id = a.account_id
JOIN DISTRICT d ON a.district_id = d.District_Code
GROUP BY l.status, d.District_Name
ORDER BY Total_Loan_Amount DESC;

SELECT 
    d.District_Name,
    COUNT(DISTINCT c.client_id) AS Total_Customers,
    COUNT(t.trans_id) AS Transactions,
    SUM(t.amount) AS Total_Transaction_Amount
FROM TRANSACTIONS t
JOIN ACCOUNT a ON t.account_id = a.account_id
JOIN CLIENT c ON a.account_id = c.client_id
JOIN DISTRICT d ON c.district_id = d.District_Code
GROUP BY d.District_Name
ORDER BY Total_Transaction_Amount DESC;

SELECT 
    d.District_Name,
    COUNT(a.account_id) AS Total_Accounts,
    COUNT(l.loan_id) AS Total_Loans,
    SUM(l.amount) AS Total_Loan_Amount
FROM DISTRICT d
JOIN ACCOUNT a ON d.District_Code = a.district_id
LEFT JOIN LOAN l ON a.account_id = l.account_id
GROUP BY d.District_Name
ORDER BY Total_Loan_Amount DESC;

select distinct Region from DISTRICT;

delimiter $$
create procedure Region_Code()
	begin
		select District_Name,Region,No_of_inhabitants,
			case
				when Region = "central Bohemia" then "CB"
				when Region = "south Bohemia" then "SB"
				when Region = "west Bohemia" then "WB"
				else "Others"
			end as Region_Code
		from DISTRICT;
	end $$

call Region_Code();

create view region as 
select District_Name,Region,No_of_inhabitants from DISTRICT where District_Name ="Kladno";

select * from region;
delimiter $$
create function region(District_Name varchar(30))
returns varchar(30)
deterministic
begin
	return District_Name ;
end $$

select region("Kladno") as district;

select * from DISTRICT;
delete from DISTRICT where Region="Prague";
create table DISTRICT_copy as select * from DISTRICT where 1=0; # created duplicate table
select * from DISTRICT_copy;
insert into DISTRICT_copy() select * from DISTRICT # inserted data from old table to duplicate table
select distinct Region from DISTRICT_copy;
select Region,count(Region) as Total from DISTRICT_copy group by Region;
select District_Name,count(District_Name) from DISTRICT_copy group by District_Name;
select Region,District_Name
from DISTRICT_copy group by Region
order by Region;

SELECT Region, GROUP_CONCAT(District_Name ORDER BY District_Name SEPARATOR CHAR(10)) AS Districts
FROM DISTRICT_copy
GROUP BY Region
ORDER BY Region;

SELECT Region, GROUP_CONCAT(District_Name ORDER BY District_Name SEPARATOR '\n') AS Districts
FROM DISTRICT_copy
GROUP BY Region
ORDER BY Region;

