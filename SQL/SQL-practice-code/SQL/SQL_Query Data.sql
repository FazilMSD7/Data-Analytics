-- This is a comment

/* multiple
comment */

/*	QUERY DATA	*/

-- specify database to use
use MyDatabase

-- from clause : retrive data
select * from customers

select first_name,country from customers

-- where clause : filter data - where(condition)
select first_name,score from customers where score!=0

select * from customers where country = 'Germany'

-- order by clause : sort data -> order by column_name asc/desc (by default asc)
select * from customers order by score desc
select * from customers order by score

-- nested order by : order by multiple columns - it will sort for cols given
select * from customers order by country asc,score desc

-- group by : aggregate data -> combine rows with same values
-- aggregate fn : sum, min, max, count, avg

/* eg : to find total score of each country - here germany has 2 values, so it combines 
	use as : Alias(to_rename column name */

select country, sum(score) as total_score from customers group by country order by total_score desc

/* note : all columns in select must be either aggregated or included in groupby
	here -> if we select first_name it will throw error bcz it's not aggrgated or group by..	*/

-- select country, first_name, sum(score) from customers group by country

select country, first_name, sum(score) as total_score from customers group by country, first_name

/* TASK : Find total_score and total_no_customers for each country	*/
select country, sum(score) as total_score, count(id) as total_customers from customers group by country

-- having clause : filter data after aggregation, can be used with group by - having(condition)
/* note : diff. btw where are group by is where(for normal) before group by, but having(for aggregation) after group by	*/

select country, sum(score) as total_score from customers group by country having sum(score)>800

/* using where and having together	:
flow will be : FROM-> WHERE-> GROUP BY-> HAVING-> SELECT */
select country, sum(score) from customers where score>400 group by country having sum(score)>800

/* TASK : Find average score for each country 
		  considering only customers with a score not equal to 0
		  and return only those countries with an average score greater than 400	*/

select country, avg(score) as avg_score from customers where score!=0 group by country having avg(score)>430

-- distinct clause : remove duplicates, after select
select distinct country from customers

/* note : don't use distinct unless it's necessary, it can slow down our query -> don't use if it's unique	*/

-- top clause : limit your data
select top 3 * from customers order by score desc

select distinct top 2 country from customers


-- ORDER OF EXECUTION : from -> where -> group by -> having -> select -> distinct -> order by -> top

/* trick to remember : 'from where groups have selected distinct ordered top'

First SQL finds the data (FROM)
Then filters the data (WHERE)
Then filters the remaining (GROUP BY)
Then filters those groups (HAVING)
Then selects what to show (SELECT)
Then cleans duplicated (DISTINCT)
Then sorts the result (ORDER BY)
Finally show only top rows (TOP)	*/

-- ORDER WE WRITE : select -> distinct -> top -> from -> where -> group by -> having -> order by

/* Techniques to Remember : 
1. Use ; atlast of query bcz in other db it's must like MySQL not needed for SQL server 
	select * from table;

2. Static fixed values : means we can add our own values into database.
	Eg : add Customer_type into customer table	*/
select first_name,'new customer' as customer_type from customers

/*
3. Highlight and execute : to execute only a part of query
just select only those to be executed by ur mouse	*/
select * from customers where country = 'USA'	/* here we need to select till from customer, so it will be displayed	*/
