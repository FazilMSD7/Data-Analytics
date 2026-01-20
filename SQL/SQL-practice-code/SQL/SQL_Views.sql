-- Views :

/* Structure of database :
` SQL Server -> Database Server : stores, manages and provide access to db for users or applications
` Databases -> Collection of information stored in structured way. Eg: Sales, HR
` Schema -> Logical way that groups related objects together. Eg: Orders, Customers

` Table -> Place where data is stored & organized into rows and columns. Eg: Order_Items

` View -> Is a virtual table that shows data without storing it physically

~  DDL -> Data definition language : A set of cmnds that allows us to define & manage the structure of db. CREATE, ALTER, DROP	
*/


/* 3 Level Architecture of Database :
-- Physical Storage / Internal Level : How data is actually stored on disk. Eg: Data files, Partitions, Logs, Catalog, Blocks, Caches.. DBA

--  Logical Structure / Conceptual Level : The logically design of database. Eg: Table,Columns, Relationships, Constraints.. Data Engineer

-- View Level / External Level : What users actually see. Diff. users can see diff views of same database.
								 Eg: HR can see Employee_name, Salary. Manager can see Employee_name, Salary, Performance.. End users
*/


-- VIEWS :
/* Virtual table based on the result set of a query, without storing the data in database.

-- Tables vs Views :
Tables : Data is stored, Hard to maintain, Fast response, Read/Write db

Views : Data is not stored, Easy to maintain, Slow response, Read db
*/

/* Why Views :
Eg: Instead of writing same query for CTE(Sum Join) from BA, Risk Analyst, Finance Analyst we can use View for (Sum Join). 
	So it will be central logic and they can use it for analysis.

VIEWS vs CTE :
Views : Reduce redundancy in multiple query, Persisted logic(data doesn't disappear), Need to maintain(CREATE/DROP)

CTE : Reduce redundancy in 1 query, Temporary logic(data disappears), No maintenance(Auto cleanup)
*/


-- View Syntx :
/* CREATE View View_name as(Select.. From.. Where..)	*/

/* TASK : Find the runing total for each month	*/
With CTE_Monthly_Summary as (
	select 
	DATETRUNC(Month,OrderDate) OrderMonth,
	Sum(Sales) TotalSales,
	Count(OrderID) TotalOrders,
	Sum(Quantity) TotalQuantities
	from Sales.Orders
	group by DATETRUNC(Month,OrderDate)
)
select 
orderMonth, TotalSales,
Sum(TotalSales) over(Order by OrderMonth) RunningTotal
from CTE_Monthly_Summary


/* Using View : To use the query multiple times	*/
-- note : Create Schema name for readability. Eg: Sales.V_...
Create View Sales.V_Monthly_Summary as (
	select 
	DATETRUNC(Month,OrderDate) OrderMonth,
	Sum(Sales) TotalSales,
	Count(OrderID) TotalOrders,
	Sum(Quantity) TotalQuantities
	from Sales.Orders
	group by DATETRUNC(Month,OrderDate)
)

/* Delete View */
DROP VIEW Sales.V_Monthly_Summary

/* note : instead of doing create - drop logics in separate query, we can use TSQL(Transact SQL)	*/
if OBJECT_ID('Sales.V_Monthly_Summary','V') is not null
	drop view Sales.V_Monthly_Summary
go
	Create View Sales.V_Monthly_Summary as (
	select 
	DATETRUNC(Month,OrderDate) OrderMonth,
	Sum(Sales) TotalSales,
	Count(OrderID) TotalOrders,
	Sum(Quantity) TotalQuantities
	from Sales.Orders
	group by DATETRUNC(Month,OrderDate)
)


select * from Sales.V_Monthly_Summary

select 
orderMonth, TotalSales,
Sum(TotalSales) over(Order by OrderMonth) RunningTotal
from Sales.V_Monthly_Summary

/* TASK(Data Abstraction): Provide view that combines details from orders, products, customers and employees	*/
Create View Sales.V_OrderDetails as(
	select 
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.Category,
	Coalesce(c.FirstName,'') + ' ' + Coalesce(c.LastName,'') CustomerName,
	c.Country,
	Coalesce(e.FirstName,'') + ' ' + Coalesce(e.LastName,'') SalesName,
	e.Department,
	o.Sales,
	o.Quantity
	from Sales.Orders o
	left join Sales.Products p
	on p.ProductID = o.ProductID
	left join Sales.Customers c
	on c.CustomerID = o.CustomerID
	left join Sales.Employees e
	on e.EmployeeID = o.SalesPersonID
)

select * from Sales.V_OrderDetails

/* TASK(Security): Provide a view for the EU sales team that combines details from all tables & exclude data related to USA */
Create View Sales.V_EU_Sales as(
	select 
	o.OrderID,
	o.OrderDate,
	p.Product,
	p.Category,
	Coalesce(c.FirstName,'') + ' ' + Coalesce(c.LastName,'') CustomerName,
	c.Country,
	Coalesce(e.FirstName,'') + ' ' + Coalesce(e.LastName,'') SalesName,
	e.Department,
	o.Sales,
	o.Quantity
	from Sales.Orders o
	left join Sales.Products p
	on p.ProductID = o.ProductID
	left join Sales.Customers c
	on c.CustomerID = o.CustomerID
	left join Sales.Employees e
	on e.EmployeeID = o.SalesPersonID
	where Country != 'USA'
)

select * from Sales.V_EU_Sales

/* Usecases :
1. Data Abstraction -> Hide Complexity

2. Security(who can seee what data) -> [All data, Column level Security, Row level Security]

3. Flexibilty and Dynamic -> Change and retrive without affecting org. Db

4. Virtual Data Marts in Data Warehouse : 
	A virtaul data mart is a logical layer created using SQL views,
	instead of creating physically storing separate mart tables.
	So, in DWH diff teams need diff slices of data which can be stored in View Data mart forms
	like Sales_mart, Finance_mart..

5. Store central complex business logics to be reused.
*/
