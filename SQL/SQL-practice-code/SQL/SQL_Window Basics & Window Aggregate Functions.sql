/* Window Functions - Analyticals Functions */

-- Window Functions : 
/*	Perform calculations(eg : Aggr.) on specific subset of data(col.)
	Without losing level of details of row - Row level calculation	
	
	“Window functions allow comparing row-level values against global or partition-level aggregates without collapsing rows.”
*/
					
-- Group By(Aggr.) vs Window Function(Aggr. + Details) :

/* Group By : Has only Aggr. functions - Count, Sum, Avg, Min, Max

   Window : Aggr. functions - Count, Sum, Avg, Min, Max
			Rank functions - Row_Number, Rank, Dense_Rank, Cume_Dist, Percent_Rank, Ntile(n)
			Value functions - Lead(expr,offset,default)
							  Lag(expr,offset,default)
							  First_Value(expr)
							  Last_Value(expr)
*/

/* TASK : Find total sales across all orders	*/
select sum(sales) as TotalSales from Sales.Orders

-- TASK : Find total sales across all orders

/* Use Group by */
select ProductID, sum(Sales) as TotalSales
from Sales.Orders group by ProductID

-- TASK : Find total sales across all orders and provide order_date, orderId

/* Use Window Function : If needed extra details	*/
select OrderId, OrderDate, ProductID, 
sum(Sales) Over(Partition by ProductId) as TotalSales
from Sales.Orders

/* Syntax of window function */

/*	 Window fn Over(Partition Clause   Order Clause   Frame Clause)

Eg : Avg(Sales) Over(Partition By Category  Order By OrderDate  ROWS UNBOUND PRECEDING) 
*/

/* f(x) Window Expression

1. Empty -- Rank() Over(Order By OrderDate)

2. Column -- Avg(Sales) Over(Order By OrderDate)

3. Number -- Nteil(2) Over(Order By OrderDate)

4. Mul. Args -- Lead(Sale,2,10) Over (Order By OrderDate)

5. Cond. Logic -- Sum(Case When Sales>10 then 1 else 0 End) Over(Order By OrderDate)

*/

-- Partition By : Divides the rows into groups, based on the cols
/*	OVER() -> Entire Dataset -> Whole Window
	OVER(Partition By Month) -> Dataset Divide by Month
*/

/* TASK : Find total sales across all orders additionally provide details such as OrderId & OrderDate	*/
select OrderId, OrderDate, 
sum(sales) over() as TotalSales
from Sales.Orders

/* TASK : Find total sales for each product, additionally provide details such as OrderId & OrderDate	*/
select OrderID, OrderDate,ProductID, 
sum(Sales) over(Partition by ProductId) as TotalSalesPerPrd
from Sales.Orders

/* TASK : Find total sales per month additionally provide details such as OrderId & OrderDate	*/
select OrderId, OrderDate, 
sum(sales) over(Partition By month(OrderDate)) as TotalSalesPerMonth
from Sales.Orders

/* TASK : Find total sales across all orders and
		  Find total sales for each product, additionally provide details such as OrderId & OrderDate	*/ 
select OrderID, OrderDate, ProductID, Sales,
sum(sales) over () as Total_Sales,
sum(sales) over(Partition by ProductId) as TotalSalesPerPrd
from Sales.Orders

/* TASK : Find total sales for each combination of product and order status	*/
select ProductID, OrderStatus, Sales,
sum(Sales) over(Partition by ProductId,OrderStatus) as SalesBy_PrdAndStatus
from Sales.Orders

/* TASK : Just Together :
-- Find total sales across all orders
-- Find total sales for each product
-- Find total sales for each combination of product and order status
-- Find total sales per month combination of product and Orderdate
-- Additionally provide details such as OrderId & OrderDate
*/

select OrderID, OrderDate, ProductID, Sales,
sum(Sales) over() as TotalSales,
sum(Sales) over(partition by ProductId) as SaleByPrd,
sum(Sales) over(partition by ProductId, OrderStatus) as SaleBy_PrdAndStatus,
sum(Sales) over(partition by month(OrderDate),ProductId) as SalesBy_PrdAndMonth
from Sales.Orders
order by OrderDate

-- Order By : To sort data within window
/* Note : Must for Rank and Value functions	*/

/* TASK : Rank each order based on their sales from highest to lowest
		  Additionally provide details such as orderId and OrderDate	*/
select * from Sales.Orders

select OrderID, OrderDate, Sales,
RANK() over(order by Sales desc) as Rank_ofSales
from Sales.Orders

-- Window Frame : Define a subset of row in a window
/* Note : Frame clause can be used together with order by clause
		  Lower value must be before the higher value	*/

/* Syntax : AVG(Sales) OVER (PARTITION BY Category ORDER BY OrderDate 
			ROWS BETWEEN CURRENT ROW AND UNBOUND FOLLOWING)


Note : ROWS -> Frame types : ROWS, RANGE
	   CURRENT ROW -> Frame Boundary(lower value) : CURRENT ROW, N PRECEDING, UNBOUNDED PRECEDING
	   UNBOUND FOLLOWING -> Frame Boundary(higer value) : CURRENT ROW, N FOLLOWING, UNBOUND FOLLOWING	*/

/* Note :
UNBOUND FOLLOWING - Last possible row within a window
N PRECEDING - The n-th before the current row
UNBOUNDED PRECEDING - First possible row within a window	*/

select OrderID, OrderDate, OrderStatus, Sales, 
SUM(Sales) OVER(Partition By OrderStatus Order By OrderDate
ROWS Between Current Row AND Unbounded Following) CurToLast,

SUM(Sales) OVER(Partition By OrderStatus Order By OrderDate
ROWS Between Current Row AND 2 Following) CurTo2Following
from Sales.Orders

/* Note : For only PRECEDING, the current row can be skipped
Normal Form -> ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
Short Form -> ROWS 2 FOLLOWING	*/

select OrderID, OrderDate, OrderStatus, Sales,
SUM(Sales) OVER(Partition By OrderStatus Order By OrderDate
ROWS 2 Preceding) TotalSales
from Sales.Orders

/* Note : Default Frame -> ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW	*/
select OrderID, OrderDate, OrderStatus, Sales,
SUM(Sales) OVER(Partition By OrderStatus Order By OrderDate) TotalSales
from Sales.Orders

/* Rules of Window Function	
1. Window fn can only be used in SELECT and ORDER BY clause, Can't be used to filter data	*/
select OrderID, OrderDate, OrderStatus, Sales,
SUM(Sales) OVER(Partition By OrderStatus Order By OrderDate) TotalSales
from Sales.Orders
Order By SUM(Sales) OVER(Partition By OrderStatus Order By OrderDate)

/* 2. Nesting window fn is not allowed	
   3. SQL exceute window fn after WHERE clause	*/

/* TASK : Find the total sales for each order status only for two products 101 and 102	*/
select productid, orderstatus, sales,
SUM(Sales) Over(Partition by OrderStatus)
from Sales.Orders where ProductID in(101,102)

select productid, orderstatus, sales,
SUM(Sales) Over(Partition by OrderStatus,productid)
from Sales.Orders where ProductID in(101,102)

/* using group by - to collapse	*/
select productid, orderstatus, sum(sales) sales
from sales.Orders
where productid in (101,102)
group by productid,orderstatus
order by ProductID

/* 4. Window fn can be used with GROUP BY clause in same query, only if the same columns are used	*/

/* TASK : Rank customers based on their total sales	*/
select customerid, 
sum(sales) sales,
rank() over(order by sum(sales) desc) rank
from Sales.Orders
group by CustomerID


-- Window Aggregate Functions

-- COUNT() : how many row within a window, null won't be counted
/* Used for : Overall & Category Analysis, Quality check - Identify NULLS & Duplicates	*/

/* TASK : Find the total number of orders	*/
select count(OrderID) TotalOrders from Sales.Orders

/* TASK : 
1. Find the total number of orders additionally provide details such as orderId & orderDate	
2. Find total number of orders for each customer additionally provide details such as orderId & orderDate*/

select CustomerID, OrderDate, OrderId, 
count(*) over() TotalOrders,
count(*) over(partition by CustomerID) TotalCustomerOrder 
from Sales.Orders

/* TASK : 
1. Find the total number of customers additionally provide all customers details	
2. Find total number of score for the customers */
select *, count(*) over() TotalCustomers, count(score) over() TotalCustomers from Sales.Customers

/* TASK : Check whether the table 'Orders' contains any duplicate rows	*/
select orderID, count(*) over(Partition By OrderID) CheckPK
from Sales.Orders

select orderId, count(*) over(Partition By OrderID) CheckPK
from Sales.OrdersArchive

/* TASK : Identify the duplicates	*/
select * from(
select OrderID, count(*) over(Partition by OrderID) CheckPK 
from Sales.OrdersArchive)t
where CheckPK > 1


-- SUM()

/* TASK : Find total sales across all orders and total sales for each product
		  additionally provide details such as order ID and order date	*/

select OrderID, OrderDate,
ProductId,
sum(Sales) over(Partition by ProductID) TotalProductSales,
sum(Sales) over() TotalSales
from Sales.Orders
order by orderID


-- AVG()

/* TASK : Find average sales across all orders and average sales for each product
		  Additionally provide details such as orderID, orderDate	*/

select OrderID, OrderDate, ProductId, Sales, 
avg(sales) over() AverageSales,
avg(sales) over(Partition by ProductID) AvgSalesPrd
from Sales.Orders

/* TASK : Find the average scores of customers
		  Additionally provide details such as CustomerID and LastName	*/

-- note : replace NULL using COALESCE
select CustomerId, LastName,
avg(Score) over() AvgScore,
avg(coalesce(score,0)) over() AvgScoreWithoutNull
from Sales.Customers

/* TASK : Find all orders where sales are higher than the average sales across all orders	*/
select * from(
select OrderID, ProductId, Sales,
Avg(Sales) over() AvgSales
from Sales.Orders)t
where Sales>AvgSales

-- MIN() and MAX()

/* TASK : Find the highest and lowest sales of all orders
		  Find the highest and lowest for each product
		  Additionally provide details such as OrderID, OrderDate	*/

select OrderId, ProductID, Sales,
min(Sales) over() LowestSale,
max(Sales) over() HighestSale,
min(Sales) over(Partition by ProductID) LowestSalePrd,
max(Sales) over(Partition by ProductID) HighestSalePrd
from Sales.Orders

/* TASK : Show employees with the highest salary */
select * from(
select *,
max(salary) over() HighestSalary
from Sales.Employees)t
where salary = HighestSalary

/* TASK : Calculate the deviation of each sale from both min & max sale amounts	*/
select OrderId, ProductID, Sales,
Sales - min(Sales) over() diffFromMinSale,
max(Sales) over() - Sales diffFromMaxSale
from Sales.Orders

-- Comparision Use Case : compare the current value and aggregated value of window function

/* 1. Part to Whole Analysis : compare current sales to total sales
   2. Compare to Extreme Analysis : compare sales to highest or lowest sales
   3. Compare to Average Analysis : helps to evaluate whether a value is above or below the avg.	*/

/* TASK : Find the percentage contribution of each product's sales to the total sales	*/
select ProductId, Sales,
sum(sales) over() TotalSales,
ROUND(CAST(Sales as float) / sum(sales) over() * 100,2) PercentageOfTotal
from Sales.Orders

/* TASK : compare sales to highest or lowest sales	*/
select productId , sales, 
max(sales) over() as HighestSale,
min(sales) over() as LowestSale,
max(sales) over() - sales as DiffFromProductHighest,
sales - min(sales) over() as DiffFromProductLowest
from Sales.Orders

/* TASK : helps to evaluate whether a value is above or below the avg.	*/
select productId, Sales,
CASE
	when Sales > AVG(Sales) over() then 'Highest'
	when Sales < AVG(Sales) over() then 'Lowest'
	else 'Average'
END as SalesCategory
from Sales.Orders


-- Analytical UseCase : Running & Rolling Totals

/* Running Total : Aggr. all values from beginning up to the current point without dropping older data
			Syn - SUM(Sales) Over(Order by Month)	[by default frame - ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW]

   Rolling Total : Aggr. all values within a fixed time window(eg. 30 days), As new data added older will be dropped
			Syn - SUM(Sales) Over(Order by Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)	  
*/

/* TASK : Calculate the moving avg. of sales for each product over time	*/
select OrderID, ProductID, OrderDate, Sales,
avg(Sales) over(Partition by ProductID) AvgSalesByPrd,
avg(Sales) over(Partition by ProductID order by OrderDate) MovingAvg
from Sales.Orders

-- note : in above moving avg is calculated as window prdID, so 10/1, 10+20/2, 10+20+90/3, 10+20+90+20/4

/* TASK : Calculate the moving average of sales for each product over time, including only the next order	*/
select OrderID, ProductID, OrderDate, Sales,
avg(Sales) over(partition by productId order by orderDate 
rows between current row and 1 following) MovingAvgSalesIncNxtOrder
from Sales.Orders


/* Note :
Overall Total - SUM(Sales) Over()
Total per grp - SUM(Sales) Over(Partition By Product)
Running Total - SUM(Sales) Over(Order By Month)
Rolling Total - SUM(Sales) Over(Order By Month ROWS 2 PRECEDING)	*/

