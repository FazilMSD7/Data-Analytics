-- CTAS & TEMP :

/* Table Types : 
Permanent Table -> Create/Insert, CTAS
Create : Define the structure of table, Insert : Insert data into the table. CREATE-Table-INSERT
CTAS(Create Table as Select) : Create new table based on result of sql query. Physical Table. Query-Result-Table
VIEWS : Stores only query not data, Always shows latest data. Virtual Table.

Temporary Table -> #table_name, Automatic clean up when session ends
*/

/* Syntx :
-- Create/Insert :
Create Table Table_name(id int, name varchar...)
Insert into Table_name(1,'Frank')

-- CTAS :
Create Table Table_name as(Select.. from.. where..)  --> In MySQL|Postgres|Oracle
Select.. Into Table_name From.. where..  --> SqlServer
*/

/* Usecases :
1. Optimize performance :
In View, One can use View query once complted only. Eg: If BA completes Views usage the Risk Analyst can use. Time consumed lot
In CTAS, At single time multiple people can use bcz stored as Table
*/

/* TASK : Show total number of orders for each month	*/
select 
DATENAME(month,OrderDate) OrderMonth,
count(OrderID) TotalOrders
into Sales.MonthlyOrders
from Sales.Orders
group by DATENAME(month,OrderDate)

select * from Sales.MonthlyOrders

drop table Sales.MonthlyOrders

/* How to refresh CTAS? --> Need to use TSQL : If present drop go create	*/
if OBJECT_ID('Sales.MonthlyOrders2','U') is not null
	drop table Sales.MonthlyOrders2
go
	select 
DATENAME(month,OrderDate) OrderMonth,
count(OrderID) TotalOrders
into Sales.MonthlyOrders2
from Sales.Orders
group by DATENAME(month,OrderDate)

select * from Sales.MonthlyOrders2

/* Usecase :
1. Creating Snapshot : Actual data will not be changed, so we can change data and analyze, it won't affect
2. Physical Data Marts
*/


-- Temporary Tables : (#)
/* Stores intermediate results in temp storage within the database during the session. Temp tables will be dropped once session ends	

Syntx :
Select.. Into #Table_name From.. where..  --> SqlServer
*/

/* TASK : Create a Temp table for Orders table	*/
select *
into #OrdersTemp
from Sales.Orders

select * from #OrdersTemp


/* Step-1 : Load Data to TEMP table
   Step-2 : Transform Data in TEMP table
   Step-3 : Load TEMP table into Permanent table	*/

Select * 
into Sales.OrdersTest
From #OrdersTemp

drop table #OrdersTemp
drop table Sales.OrdersTest

/* Subquery vs CTE vs TMP vs CTAS vs View
Storage : Memory(Subquery, CTE), Disk(TMP, CTAS), No Storage(View)

Lifetime : Temporary(Subquery, CTE, TMP), Permanent(CTAS, View)

When Deleted : End of query(Subquery, CTE), End of session(TMP), DROP(CTAS, View)

Scope : Single query(Subquery, CTE), Multi queries(TMP, CTAS, View)

Reusability : Limited -> 1 place - 1 query(Subquery)
			  Limited -> 1 multi places -1 query(CTE)
			  Medium -> multi places - during session(TMP)
			  High -> multi places - queries(CTAS, View)
			  Up2Date -> Subquery, CTAS, View