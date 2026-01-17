-- CTE : Common Table Expression
/* Temp., named result set(virtual set), that can be used multiple times within ur query	
   Can't use Order by Clause in CTE*/

/* Diff. btw Subquery and CTE :
Subquery - result can be used only once. Execution : Bottom(Subquery) to Top(Main query)
CTE - result can be used many times. Execution : Top(CTE query) to Bottom(Main query)	*/

/* Why CTE?
We can reuse CTE query instead of writing query separately again.
Eg: Subquery : [Join -> Aggr(SUM) -> Join] Subquery -> [Aggr(Avg)] Main query
	CTE : CTE[Join] -> [Aggr(SUM) -> Aggr(Avg)] Main query
*/

/* Advantages :
Query : CTE query [CTE_TopCustomers(select..) CTE_TopPrds(select..) CTE_DailyRevenue(select..)] [Select...] Main query

Redadability, Modularity, Reusability	*/

/* Syntax :
	With CTE_name as (
	Select.. From.. Where..)
	Select.. from CTE_name where..
*/

/* CTE Types :
1. Non-Recursive CTE (Executed only once without repetition): Standalone CTE, Nested CTE
2. Recursive CTE (Self referencing query that rep. process data until cond. is met)	*/


-- Standalone CTE : Define & used independently
/* TASK : Step-1 : Find the total sales of customer	*/
With CTE_TotalSales as
(
select CustomerID,
sum(Sales) TotalSales
from Sales.Orders
group by CustomerID
)
-- Main query
select 
c.CustomerID, c.FirstName,
cts.TotalSales
from Sales.Customers c 
left join CTE_TotalSales cts 
on c.CustomerID = cts.CustomerID;

-- Multiple Standalone CTE :
/* TASK : Step-2 : Find last order date for each customer	*/
With CTE_TotalSales as
(
select CustomerID,
sum(Sales) TotalSales
from Sales.Orders
group by CustomerID
),
CTE_LastOrder as
(
select CustomerID,
Max(OrderDate) LastOrderDate
from Sales.Orders
group by CustomerID
)
-- Main query
select 
c.CustomerID, c.FirstName,
cts.TotalSales, clo.LastOrderDate
from Sales.Customers c 
left join CTE_TotalSales cts 
on c.CustomerID = cts.CustomerID
left join CTE_LastOrder clo
on clo.CustomerID = c.CustomerID;


-- Nested CTE : CTE inside another CTE, can't run independently
/* Syntax :
	With CTE_name1 as (
	Select.. From.. Where..),	   -> Standalone CTE

	CTE_name2 as (
	Select.. From CTEname1 Where..) -> Nested CTE

	Select.. from CTE_name2 where..	-> Main query
*/

/* TASK : Step-3 : Rank Customers based on Total Sales per customer	*/
With CTE_TotalSales as
(
select CustomerID,
sum(Sales) TotalSales
from Sales.Orders
group by CustomerID
),
CTE_CustomerRank as		-- Nested CTE
(
select CustomerID,TotalSales,
Rank() over(Order by TotalSales desc) CustomerRank
from CTE_TotalSales
),
/* Step-4 : Segment customers on their total sales	*/
CTE_CustomerSegment as
(
select CustomerID, 
case 
	when TotalSales > 100 then 'High'
	when TotalSales > 80 then 'Medium'
	else 'Low'
end CustomerSegments
from CTE_TotalSales
)
-- Main query
select 
c.CustomerID, c.FirstName,
cts.TotalSales,
ccr.CustomerRank,
ccs.CustomerSegments
from Sales.Customers c 
left join CTE_TotalSales cts
on c.CustomerID = cts.CustomerID
left join CTE_CustomerRank ccr
on c.CustomerID = ccr.CustomerID
left join CTE_CustomerSegment ccs
on c.CustomerID = ccs.CustomerID;



/* TOGETHER : */
-- Step-1 : Find the total sales of customer (Standalone CTE)
With CTE_TotalSales as
(
select CustomerID,
sum(Sales) TotalSales
from Sales.Orders
group by CustomerID
),
-- Step-2 : Find last order date for each customer(Multiple CTE[Standalone])
CTE_LastOrder as
(
select CustomerID,
Max(OrderDate) LastOrderDate
from Sales.Orders
group by CustomerID
),
-- Step-3 : Rank Customers based on Total Sales per customer(Nested CTE)
CTE_CustomerRank as
(
select CustomerID,
Rank() over(Order by TotalSales) CustomerRank
from CTE_TotalSales
),
-- Step-4 : Segment customers on their total sales(Nested CTE)
CTE_CustomerSegment as
(
select CustomerID,
case
	when TotalSales > 100 then 'High'
	when TotalSales > 80 then 'Medium'
	else 'Low'
end CustomerSegment
from CTE_TotalSales
)
-- Main query
select 
c.CustomerID, c.FirstName,
cts.TotalSales, clo.LastOrderDate,
ccr.CustomerRank, ccs.CustomerSegment
from Sales.Customers c 
left join CTE_TotalSales cts 
on cts.CustomerID = c.CustomerID
left join CTE_LastOrder clo
on clo.CustomerID = c.CustomerID
left join CTE_CustomerRank ccr
on ccr.CustomerID = c.CustomerID
left join CTE_CustomerSegment ccs
on ccs.CustomerID = c.CustomerID;


-- Recursive CTE : Keep looping process data until cond. is met. Used mostly for Hierarichal
/* Anchor query -> executes only once
   Recursive query -> loops

Syntx : 
	With CTE_name as (
	Select.. From.. Where..		-- Anchor query
	UNION ALL
	Select.. From CTE_name Where[break cond.]	-- Recursive query
	)
	Select.. From CTE_name Where..
*/

/* TASK : Generate a sequence of number from 1 to 20	*/
With Series as
(
--Anchor query
Select 1 as MyNumber
UNION ALL
--Recursive query
Select MyNumber + 1
from Series 
where MyNumber < 20
)
--Main query
select * from Series
option(maxrecursion 30);	-- MAXRECURSION-> to control how many recusrsion can be done max


/* TASK : Show the employees hierachy by displaying each employee's level within the organization	*/
-- Anchor query
with cte_emp_hierarchy as
(
select EmployeeID,
FirstName, ManagerID,
1 as level
from Sales.Employees
where ManagerID is null
UNION ALL
-- recursive query
select e.EmployeeID,
e.FirstName, e.ManagerID,
level + 1
from Sales.Employees e
inner join cte_emp_hierarchy ceh
on e.ManagerID = ceh.EmployeeID
)
-- main query
select * from cte_emp_hierarchy;