/* DDL (Data Definition Language) --> create, alter, drop */

use MyDatabase

-- create table : column_name, data type, constraint(pk_name primary key(col_name))

create table persons(
id int not null, person_name varchar(50) not null, phone varchar(15) not null, dob date,
constraint pk_persons primary key(id)
)

select * from persons

-- alter table : used to modify DDL of table(add/edit_col..) 
/*	col will be added at last only, not in middle or anywhere 
	alter add, drop column	*/

alter table persons
add email varchar(50) not null

select * from persons

/* TASK : Remove column phone from persons table */
alter table persons
drop column phone

select * from persons

-- drop table : delete table from db
drop table persons


/* DML (Data Manipulation Language) --> insert, update, delete */

-- insert : add data to table(new table/existing table)

/* insert values : insert into(col_name..) values(..)	
	NOTE : if column_name not specified it'll insert values for all columns	
		   no. of col. and values should match	
		   multiple values can be inserted	
		   can't insert null value for pk	
		   order of col and values should match	
		   columns not includeed will become null */

select * from customers

insert into customers(id, first_name, country, score)
values(6, 'Fazil', 'India', 550), (7, 'Anzil', 'India', NULL)

select * from customers

insert into customers values(8, 'Gughan', 'India', NULL)

/* columns not included will become null */
insert into customers(id, first_name, score) values(9, 'Saro', 770)

select * from customers


-- insert using select : insert values from source table to target table
/* TASK : copy data from 'customers' table to 'persons' table	*/

select * from persons

insert into persons(id, person_name, phone, dob)
select id, first_name, 'unknown', null from customers 

select * from persons

-- update : change content of already existing row -> update table_name set col = value, where <condition>
/* NOTE : if we are not using 'where' it'll update all rows
		 insert(used to add new data) vs update(used to modify existing data)	*/

/* TASK : change score of customer 6 to '0'	*/
update customers set score = 0 where id = 6

select * from customers

/* TASK : change score of customer 10 to '0' and update the country to 'UK'	*/
update customers set score = 0, country = 'UK' where id = 9

/* TASK : update all customers with NULL score by setting their score to 0 
   Note : we can't use = for NULL values, instead use IS NULL	*/
update customers set score = 0 where score IS NULL

-- delete : to remove rows from table
/* NOTE : if we are not giving where condition, it'll delete all rows	*/

/* TASK : delete all customers with id greater than 5	*/
delete from customers where id>5

/* TASK : delete all data from table persons */
delete from persons

-- truncate : same as delete but deletes whole rows without any condition and is faster
truncate table persons