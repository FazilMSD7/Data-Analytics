use MyDatabase

/* Functions : a built in sql code that 
   accepts an input value - process it  - returns an output value	*/

/* 1. Single row function : single value i/o. Eg: Maria.UPPER() -> maria
   2. Multi row function : multiple values, multiple inp. and single output. Eg: SUM(100,200..) -> 300

* Nested Functions : Function used inside another function. Eg: LOWER(LEFT('Maria',2)) -> ma	*/

/* TYPES OF FUNCTIONS :
1. Single row function : String, Numeric, Data&Time, Null functions
2. Multi row functions : Aggregate, Window functions	*/


-- String Functions : 
/*	Manipulate - CONCAT, UPPER, LOWER, TRIM, REPLACE
	Calculations - LEN
	String Extraction -> LEFT, RIGHT, SUBSRING	*/

-- CONCAT : combine multiple strings into one
select * from customers
select concat(first_name,' ', country) as Name from customers

-- UPPER/LOWER
select upper(country) as country from customers

select lower(country) as country from customers

-- TRIM : removes leaing and trailing spaces
select trim(first_name) as name from customers

-- REPLACE : replace specific character
select '91-948988722' as phone,
 replace('91-948988722' ,'-', '') as ph

select 'report.txt' as re,
replace('report.txt', 'txt', 'csv') as new_re

-- LEN
select len(first_name) as len_of_fname from customers

-- LEFT/ RIGHT : extract specific no. of chars from start/end
select left(first_name,2) as 'left', right(first_name, 3) as 'right' from customers

-- SUBSTRING : extract part of string from specific position -> SUBSTRING(Value, Start, Length)

/* TASK : Retrieve a list of customers fname removing first character	*/
select substring(trim(first_name),2,len(first_name)) as fname from customers


-- Number Functions :

-- round
select
round(3.521,2) as round_2,
round(3.516,1) as round_1,
round(3.498,0) as round_0

-- ABS : (Absolute) -> converts negative into positive
select abs(-10) as absolute
