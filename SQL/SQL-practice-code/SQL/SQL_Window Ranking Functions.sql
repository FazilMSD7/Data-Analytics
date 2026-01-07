-- Window Ranking Functions

/* Types :
1. Integer based ranking : 1, 2, 3, 4..	--> Top/Bottom Analysis : Find top 3 products
						   ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE(num)

2. percentage based ranking : 0, 0.25, 0.5, 0.75, 1 --> For distribution analysis like contribution : Find top 20% prds
							  CUME_DIST(), PERCENT_RANK()	
*/

/* note : 
Expression is empty for all except NTILE(num)
Partition clause is optional for all
Order clause is req. for all
Frame clause is not allowed for all	*/

-- ROW_NUMBER() : Assign unique no. to each in a window, Doesn't handle ties
/* Syn - ROW_NUMBER() OVER(Partition By PrdID Order By Sales)	: Order By is Mand.	*/

/* TASK : Rank orders based on their sales from highest to lowest	*/
select orderId,Sales,
row_number() over(order by sales desc) SalesRank_Row
from Sales.Orders

-- RANK() : Assign a rank to each row, Handles ties. Leaves gap in ranking
/* Syn - RANK() OVER(Partition By PrdID Order By Sales)	: Order By is Mand.	*/
select orderId,Sales,
rank() over(order by sales desc) SalesRank
from Sales.Orders

-- DENSE_RANK() : Assign a rank to each row, Handles ties. Doesn't leave gap in ranking
/* Syn - DENSE_RANK() OVER(Partition By PrdID Order By Sales)	: Order By is Mand.	*/
select orderId,Sales,
dense_rank() over(order by sales desc) SalesDenseRank
from Sales.Orders

select orderId,Sales,
row_number() over(order by sales desc) SalesRank_Row,
rank() over(order by sales desc) SalesRank,
dense_rank() over(order by sales desc) SalesDenseRank
from Sales.Orders


-- ROW_NUMBER() : Use Cases

/* Top-N Analysis -> TASK : Find the top highest sales for each product */
select * from(
select orderID, productId, sales,
ROW_NUMBER() over(Partition by ProductId Order by sales desc) RankByPrd
from sales.Orders)t
where RankByPrd = 1

/* Bottom-N Analysis -> TASK : Find the lowest 2 customers based on their total sales	*/
select * from(
select CustomerId,
Sum(Sales) TotalSales,
ROW_NUMBER() over(Order By Sum(Sales)) RankCustomers
from sales.Orders
group by CustomerID)t
where RankCustomers<=2

/* TASK : Assign unique ID's to the rows of the 'Orders Archive' table */
select ROW_NUMBER() over(order by orderId) UniqueID, *
from Sales.OrdersArchive

/* Identify Duplicates
TASK : Identify duplicate rows in table 'Orders Archive' and return a clean result without any duplicates */
select * from(
select ROW_NUMBER() over(partition by Orderid order by CreationTime desc) rn, *
from Sales.OrdersArchive)t
where rn=1

-- NTILE(num) : Divides the rows into a specified number of approx. equal groups(buckets)
/* Syn - NTILE(num) OVER(Partition By PrdID Order By Sales)	: Order By is Mand.	*/

/* note : 
Bucket size = No. of rows/ No. of buckets(which is given in NTILE(2)
Rule : Larger groups come first. [Eg. : If total 5-> splits into 3 and 2]
*/

select OrderId, Sales,
NTILE(1) over(order by sales desc) OneBucket,
NTILE(2) over(order by sales desc) TwoBucket,
NTILE(3) over(order by sales desc) ThreeBucket,
NTILE(4) over(order by sales desc) FourBucket
from sales.Orders

-- NTILE(num) : Use Case

/* Data Segmentation : Divides a dataset into distinct subset based on a certain criteria	*/

/* TASK : Segment all orders into 3 categories high, medium and low sales	*/
select *,
Case
	when SalesBucket = 1 then 'high'
	when SalesBucket = 2 then 'medium'
	else 'low'
end SalesCategory
from(
select orderid, sales,
ntile(3) over(order by sales) SalesBucket
from Sales.Orders)t

/* Equalizing Load : Useful for DE's -> Transform a large table into small buckets later load into Destination db and then UNION ALL together	*/

/* TASK : In order to export the data divide the orders into 2 groups	*/
select ntile(2) over(Order by orderId) Buckets, *
from Sales.Orders


-- CUME_DIST() : Position nr / No. of rows
/* Cumulative Distribution calc. the distribution points within a window 
Rule : Tie Rule -> The position of the last occurance of the same value 

UseCase : To find distribution of data
*/

-- PERCENT_RANK() : Position nr - 1 / No. of rows - 1
/* Calculates the relative position of each row	
Rule : Tie Rule -> The position of the first occurance of the same value 

UseCase : To find relative position of each row
*/

/* TASK : Find the products that fall within the highest 40% of prices	*/
select * ,
concat(DistRank * 100,'%') DistRankPercentage
from(
select Product, Price,
CUME_DIST() over(Order by Price desc) DistRank
from Sales.Products)t
where DistRank <= 0.4

select * ,
concat(DistRank * 100,'%') DistRankPercentage
from(
select Product, Price,
PERCENT_RANK() over(Order by Price desc) DistRank
from Sales.Products)t
where DistRank <= 0.4