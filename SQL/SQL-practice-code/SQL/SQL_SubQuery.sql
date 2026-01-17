-- Advance SQL Techniques :
/* Subquery, CTE(Common Table Expression), Views, Temp Tables, CTAS(Create Table as Select), Stored Procedures, Triggers	*/

-- Subquery : A query inside another query

/* Why SubQuery ?
Eg. : Join Tables -> Filtering -> Transformation(remove nulls..) -> Aggregations
instead of having one single complex query divide into subqueries : Join Tables(SQ) -> Filter(SQ) -> Transform(SQ) -> Aggr.(Main Query)		*/


/* Subquery Categories :
1. Dependency -> Correlated subquery, Non-Correlated subquery, 
2. Result Types -> Scalar subquery(single value), Row Subquery, Table subquery
3. Locations | Clauses -> SELECT, FROM, JOINS, WHERE(Comparision Op.(= <>..) / Logical Op.(IN, ANY, ALL, EXISTS))	*/


-- Result Types :
/* Scalar Subquery : Return single value	*/
select avg(sales) AvgOrders from Sales.Orders

/* Row Subquery : Multiple rows	*/
select CustomerID from Sales.Orders

/* Table Subquery : Multiiple rows and cols	*/
select * from Sales.Orders

-- Location Types :
/* FROM Clause : Used as temp. table for the main query	
Syntx - Select * from(Select column from table where condition)t	*/	

/* TASK : Find the products that have a price higher than the average price of all products	*/
select * from(
select ProductID, Price,
Avg(Price) over() AvgPrice
from Sales.Products)t
where Price>AvgPrice

/* TASK : Rank customers based on their total amount of sales	*/
select 
Rank() over(order by TotalSales desc) CustRank, * 
from(
select CustomerID, Sum(Sales) TotalSales 
from Sales.Orders
group by CustomerID)t


/* SELECT Clause : Used to aggr. data side by side with main query's data, allowing for direct comparision
Syntx - Select column1, (Select col from table where condition) from Table	
Only Scaler value is allowed for the subquery	*/

/* TASK : Show the products IDs, names, prices and total number of orders	*/
select 
ProductID, Product, Price,
(select Count(*) from Sales.Orders) TotalOrders
from Sales.Products


/* JOIN Clause : Used to prepare data(filtering or aggr.) before joining it with other tables	*/

/* TASK : Show all customers details & find the total orders for each customers	*/
select *
from Sales.Customers c 
left join (
	select 
	customerId,count(*) TotalOrders 
	from sales.Orders
	group by CustomerID)t
on c.CustomerID = t.CustomerID


/* WHERE Clause : 
Syntx - Select * from table1 where column = (Select * from table2 where cond.)	
Subquery must be scaler	*/

-- Comparission Ops : 
/* TASK : Find the products that have a price higher than the average price of all products	*/
select * from Sales.Products
where Price > (select avg(Price) from Sales.Products)

-- Logical Ops :

-- IN :
/* TASK : Show the details of orders made by customers in Germany	*/
select * from Sales.Orders
where CustomerID in 
				 (Select CustomerID 
				 from Sales.Customers 
				 where Country = 'Germany')

-- ANY | ALL :
/* Syntx : Select * from where col < ANY | ALL (Select col from table where cond.)	*/

/* TASK : Find female employees whose salaries are greater than the salary of any male employee	*/
select *
from Sales.Employees 
where Gender = 'F' 
and Salary > any(select Salary from Sales.Employees where Gender = 'M')

/* TASK : Find female employees whose salaries are greater than the salary of all male employee	*/
select * 
from Sales.Employees 
where Gender = 'F' 
and Salary > all(select Salary from Sales.Employees where Gender = 'M')


-- Dependency Types : 
/* Non-Correlated Subquery : A Subquery that can run independtly from main query. 'IN','ANY|ALL'
   Correlated Subquery : A Subquery that relays values from the main query. 'EXISTS'	*/

/* TASK : Show all customer details and find the total orders for each customer	*/
-- With Non-Correlated : Independent
select * from sales.Customers c
left join ( select CustomerID, count(*) TotalOrders
			from Sales.Orders
			group by CustomerID)o
on c.CustomerID = o.CustomerID

-- With Correlated : Dependent
select *, 
(select count(*) from sales.Orders o where o.CustomerID = c.CustomerID) TotalOrders
from Sales.Customers c

/* Note: In Non-correlated we can subquery with SELECT Clause bcz it' non-scaler, the rows doesn't match. So instead we cna go with Correlated	*/


-- EXISTS :
/* Check if a subquery returns rows. Used to test do we have result or not.
   Syntx : Select col1,col2.. from Table2 where EXISTS(select 1 from Table1.ID = Table2.ID))

   How it Works?
   -> For each row in main query -> Run Subquery -> If return value : row of main query included else not
*/

/* TASK : Show details of orders made in Germany	*/
select * from Sales.Orders o
where EXISTS ( select 1 
			   from Sales.Customers c
			   where Country = 'Germany'
			   And c.CustomerID = o.CustomerID)

/* not in Germany	*/
select * from Sales.Orders o
where NOT EXISTS ( select 1 
			   from Sales.Customers c
			   where Country = 'Germany'
			   And c.CustomerID = o.CustomerID)

/* Same Using Non Correlated : 'IN | NOT IN'	*/
select * from Sales.Orders
where CustomerID NOT IN (select CustomerID 
						 from Sales.Customers
						 where Country = 'Germany')				

/* SUMMARY
-- Query inside another Query. Breaks complex query into smaller

* UseCases : 
Create Temp. result sets, Prepare data before joining,
Dynamic & complex filtering, Check existence of rows from another table(EXISTS),
Row by row comparision(Correlated Subquery)

*/
