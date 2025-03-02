# https://chatgpt.com/share/67be78e5-ed6c-800e-abb5-b0e27e82bbae

use partitioning;
create table emp_data(
	emp_id int ,
    dept varchar(20),
    salary int);
select * from emp_data;
insert into emp_data (emp_id,dept,salary) values(1,'IT',50000),
(2,'IT',60000),
(3,'HR',45000),
(4,'HR',47000),
(5,'IT',55000);
drop table emp_data;
SELECT * FROM emp_data;
SELECT * ,AVG(salary) AS avg_salary FROM emp_data GROUP BY dept;
SELECT *,AVG(salary) OVER (PARTITION BY dept ) AS avg_salary FROM emp_data;



select * ,avg(salary) as avg_salary from emp_data group by dept;

select * ,avg(salary) over(partition by dept) as avg_salary from emp_data;