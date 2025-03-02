use ineuron_fsda;

DELIMITER &&
create procedure sudh()
BEGIN
	select * from bank_deatils;
END &&

call sudh()

DELIMITER &&
create procedure bal_max()
BEGIN
	select * from bank_deatils where balance in (select max(balance) from bank_deatils);
END &&

call bal_max();

DELIMITER &&
create procedure avg_bal_jobrole(IN sudh varchar(30))
BEGIN
	select avg(balance) from bank_deatils where job=sudh;
END &&

call avg_bal_jobrole("admin.");
call avg_bal_jobrole("retired");

DELIMITER &&
create procedure sel_edu_job()
BEGIN 
	select * from bank_deatils where job="unknown" and education="primary";
END &&

call sel_edu_job()

DELIMITER &&
create procedure sel_edu_job1(IN v1 varchar(30), IN v2 varchar(30))
BEGIN
	select * from bank_deatils where job=v1 and education=v2;
END &&

call sel_edu_job1("management","secondary")

create view bank_view as select age,job,marital,balance,education from bank_deatils;
select * from bank_view;
select avg(balance) from bank_view where job="admin.";

