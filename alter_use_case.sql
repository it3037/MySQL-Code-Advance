#https://chatgpt.com/share/67b9e9ea-9374-800e-8872-917d3d19afa0

use partitioning;

CREATE TABLE order_data (
    order_id INT NOT NULL,
    order_date VARCHAR(100),
    customer_name VARCHAR(100),
    amount DECIMAL(10,2)
    );
  
drop table staff;

select * from order_data;

alter table order_data add column salary int after customer_name  ;  #add
alter table order_data drop amount ; #delete
alter table order_data modify column order_date date; #modify data type
alter table order_data change column customer_name emp_name varchar(100); #change col name
alter table order_data add primary key(order_id); #add primery key
alter table order_data rename column emp_name to customer_name;  #rename column
alter table order_data rename to staff;  #Rename table name

select * from staff;
INSERT INTO staff (order_id, order_date, customer_name, salary) VALUES
(1001, '2025-03-02', 'Emily Davis', 503.58),
(1002, '2025-03-02', 'David White', 85.49),
(1003, '2025-02-21', 'Mike Johnson', 974.08),
(1004, '2025-01-17', 'Jessica Lee', 757.96),
(1005, '2025-02-03', 'Jessica Lee', 666.22),
(1006, '2025-01-06', 'Laura Martin', 819.84),
(1007, '2025-02-16', 'Jane Smith', 689.46),
(1008, '2025-02-17', 'David White', 789.14),
(1009, '2025-02-13', 'Mike Johnson', 831.29);
select * from staff;

update staff
set salary=11000
where order_id=1009;

update staff
set salary =100000 , customer_name="Rakesh"
where order_id =1001;

update staff
set salary = salary+1001;

update staff
set salary = salary + 1
where salary >= (select avg(salary) from staff);

create index idx_salary on staff(salary);
create index idx_cust_name on staff(customer_name);
select * from staff where customer_name in ('Rakesh','David White','Jane Smith')
SHOW INDEXES FROM staff;
WITH sample_data AS (
    SELECT * FROM staff WHERE customer_name IN ('Rakesh', 'David White', 'Jane Smith')
)
SELECT * FROM sample_data;

CREATE TABLE employees1 (
    emp_id INT NOT NULL,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    PRIMARY KEY (emp_id, department));
    
INSERT INTO employees1 (emp_id, emp_name, department) VALUES
(2001, 'David Lee', 'HR'),
(2001, 'Bob Smith', 'IT'),
(2001, 'Jack White', 'Finance'),
(2013, 'Jack White', 'Marketing');
	
select * from employees1 group by(department);
select department ,count(emp_id) as total_emp from employees1 group by(department);
select department,count( emp_id) as total_emp from employees1 group by(department) having total_emp<5;








