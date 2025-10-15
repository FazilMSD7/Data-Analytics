use SalesDB

/* NULL functions */

/* 1. Replace Values :
			ISNULL/ Coalesce :	Null -> Value	: Eg : NULL -> 40
			NULL IF :			Value -> Null	:  Eg : 40 -> NULL

	2. To check for Nulls :
			IS NULL/ IS NOT NULL : True/False	*/

-- ISNULL : ISNULL(value,replacement_value) 
/*	 eg: ISNULL(Shipping_Addr,'unknown')
	'unknown' by default, change acc. ISNULL(Shipping_Addr, Billing_Addr)	*/

-- COALESCE : returns first non-null value from list : COALESCE(val1, val2, val3..)
/* eg: COALESCE(Shipping_Addr, Billing_Addr, 'unknown')	*/

/* Go with COALESCE bcz it's standard in every db	*/

/* UseCase : */

-- 1. Data Aggregation - Handle null before aggr.(SUM, COUNT..)	

/* TASK : Find average scores of the customers	*/
select * from Sales.Customers

select avg(IsNull(Score,'')) as AvgScore from sales.Customers

select score,
COALESCE(score,0) as Score2,
AVG(score) OVER () as AvgScore1,
AVG(COALESCE(score,0)) OVER() as AvgScore2
from Sales.Customers

-- 2. Mathematical Op. - Handle null before any math operations

/* TASK : Display full name of customers in single field and add 10 bonus points to each customer's score */
select FirstName, LastName, 
coalesce(LastName, '') as LastName2,
firstName + ' ' + coalesce(LastName, '') as FullName,
score,
coalesce(Score, 0) as ScoreBefore,
coalesce(Score, 0)+10 as AfterBonus
from Sales.Customers

-- Handling Nulls before Joins (If keys has check and handle it)

-- Create employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    dept_id INT -- This may have NULLs
);

-- Create departments table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100)
);

-- Insert employees
INSERT INTO employees (emp_id, name, dept_id) VALUES
(1, 'Alice', 10),
(2, 'Bob', NULL),        -- No department assigned
(3, 'Charlie', 20),
(4, 'David', 999);       -- Dept ID not in departments

-- Insert departments
INSERT INTO departments (dept_id, dept_name) VALUES
(10, 'HR'),
(20, 'Engineering'),
(30, 'Marketing');


/* TASK : display each employee's ID, name, and their department name. 
If the employee does not belong to any department (i.e., dept_id is NULL or doesn't match any in departments), 
show "No Department" as the department name	*/

select * from employees
select * from departments

select emp_id, name, coalesce(dept_name,'No Department')
from employees as e
left join departments as d
on e.dept_id = d.dept_id

/* TASK : Show Only Employees Without a Department	*/
select emp_id,name,dept_name
from employees as e
left join departments as d
on e.dept_id = d.dept_id
where dept_name is null

/* Just to delete table to execute everytime	*/
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;


-- Handling Nulls to sort data's (If values has check and handle it)

/* TASK : Sort customers from lowest to highest scores with NULL appearing last	*/
select customerId, score
from Sales.Customers 
order by
case when score is null then 1 else 0 end, score

-- NULLIF : compare two value, return NULL if equal and First Value if not equal
/* Syntax : NULLIF(value1, value2), Eg: nullIf(Price,-1) - returns NULL for -1	*/

/* NullIF : Use Case	*/

-- Division By Zero

/* TASK : Find sales price for each order by dividing the sales quantity	*/
select OrderID, Sales, Quantity, 
Sales/ NullIF(Quantity,0) as PerQtyPrice 
from Sales.Orders

-- IS NULL / IS NOT NULL : returns True/False

/* Use case for IS NULL	*/
-- Filter data

/* TASK : Identify customers who have no scores	 and have scores*/
select *
from Sales.Customers
where Score is null

select * 
from Sales.Customers
where Score is not null

-- IS NULL : Anti Joins - Finding unmatched rows btw two tables - Left/Right anti join

/* TASK : List all details for customers who have not placed any orders	*/
select c.*,OrderID 
from Sales.Customers as c
left join Sales.Orders as o
on c.CustomerID = o.CustomerID
where o.OrderID is null


-- NULL(unknown) vs Empty('') vs Space(' ')

/* note :with is a CTE fn: so it'll be available for only that query, 
if u need to use later create again or create TEMP table (#exy)*/

;with exy as(
select 1 Id, 'A' as Category union
select 2, NULL union
select 3, '' union
select 4, ' '
)

select *,
DATAlength(Category) as Category_Length
from exy

-- Handling Nulls : Data Policies

/*  Data Policy : Set of rules that defines how data should be defined

1. Only use nulls and empty strings avoid using balnk spaces : TRIM(Leading and Trailing spaces removed)	
2. Only use null avoid empty and blank spaces : NULLIF()
3. Use only default value avoid using nulls, empty and blank strings : COALESCE(replace those with anything)

Try using : NULLIF or COALESCE
*/

;with exy as(
select 1 Id, 'A' as Category union
select 2, NULL union
select 3, '' union
select 4, ' '
)
select Id, Category,
trim(Category) as policy1,
nullif(Category, '') as policy2,
coalesce(nullif(Category, ''), 'unknown') as policy3
from exy


/* QUICK SUMMARY */
/*
1. Null special markers means missing values
2. Using NULL can optimize storage
3. Functions :	COALESCE | ISNULL -> replace null to values
				NULLIF -> replace values to null
				IS NULL | IS NOT NULL -> just to check
4. Usecases - Handle Nulls before : Data Aggregation,
									Mathematical Op's, 
									Joining Tables, 
									Sorting Data,
									Finding unmatched data : Left/Right Anti Join
									Data Policies

*/
						