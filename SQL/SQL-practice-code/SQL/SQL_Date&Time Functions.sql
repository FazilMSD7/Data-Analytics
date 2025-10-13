use SalesDB
-- Date and Time Functions :
/* Date -> 2025/10/13,	Time -> 18 : 58 : 52,	Timestamp(DateTime) -> Date + Time	*/


select OrderID, OrderDate, ShipDate, CreationTime from Sales.Orders

/*	1. Date column from a table
	2. Hard coded constant string value	: select '2025-08-20'
	3. GetDate() -> get current date and time	*/

select 
OrderID,
CreationTime,
'2025-10-13' as 'Hardcoded_date',
GETDATE() as today 
from Sales.Orders
	
/* Date and Time functions : 
1. Part Extraction -> day, month, year, datepart, datename, datetrunc, eomonth
2. Format of date : 13 October 2025 -> format, convert, caste
3. Calculations -> dateAdd, dateDiff
4. Validations : True/False -> IsDate
*/


/* Part Extraction :	*/

-- Day / Month / Year
select CreationTime, 
day(CreationTime) as 'DAY', month(CreationTime) as 'MONTH', year(CreationTime) as 'YEAR'
from Sales.Orders

-- DatePart : returns specific part of date as number -> datepart(part, date)
select CreationTime,
DATEPART(week, CreationTime) week,
DATEPART(quarter, CreationTime) quarter,
DATEPART(month, CreationTime) month,
DATEPART(day, CreationTime) day,
DATEPART(hour, CreationTime) hour
from Sales.Orders

-- DateName : returns specific part of date as name -> datename(part, date)
select CreationTime,
DATENAME(month, CreationTime) month,
DATENAME(weekday, CreationTime) weekday
from Sales.Orders

-- DateTrunc : the remaining part after part will be resetted -> datetrunc(part, date) : Resetting part 
select CreationTime,
DATETRUNC(hour,CreationTime) as hours_resetted,
DATETRUNC(day, CreationTime) as day_resetted
from Sales.Orders

/* TASK : Retrive orders placed every month	*/
select datetrunc(month, CreationTime) as date ,count(*)
from Sales.Orders
group by datetrunc(month, CreationTime)

-- EOMonth : returns last day of month
select eomonth(CreationTime) as EOM 
from Sales.Orders

/* TASK : Get the first day of month again including EOM	*/
select datetrunc(month, eomonth(CreationTime)) as EOM 
from Sales.Orders

/* Why we need to do Date Part Extraction	*/

-- 1. Data aggregation : 
/* TASK : How many orders were placed each year?	*/
select * from Sales.Orders

select year(OrderDate) as date, count(*) as No_of_Orders
from Sales.Orders
group by year(OrderDate)

/* TASK : How many orders were placed each month?	*/
select datename(month, OrderDate) as Order_month, count(*) as Orders
from Sales.Orders
group by datename(month, OrderDate)
order by Order_month desc

-- 2. Data Filtering :
/* TASK : show all orders placed during february month	*/
select OrderDate
from Sales.Orders
where Lower(Datename(month, OrderDate)) = 'february'

select Orderdate
from Sales.Orders
where MONTH(Orderdate) = 2


/* Date Format : 'YYYY - MM - dd' , 'HH - mm - ss' */

/*	Formatting : Changing the format of value from one to another, how data looks.
		DATE:	1. FORMAT -> Eg : 'mm/dd/yy' - 13/10/25, 'mmm yyyy' - Oct 2025
				2. CONVERT -> give style number Eg : 6 -> 20 Aug 25, 112 -> 20250820

		NUMBER:	1. FORMAT -> N - 1,234,567.89, C - dollar 1,234,567.89
				
	Casting : Change datatype from one to another, Eg: Date to String
		CAST(), CONVERT()
*/

-- FORMAT : format(value, format)
select format(CreationTime, 'MMM dd yyyy') as dd_mm_yyy
from Sales.Orders

/* TASK : Show Creation Time in format : Day - Wed Jan Q1 2025 12:34:56 PM	*/
select creationTime 
from Sales.Orders

select 'Day - ' + format(creationTime,' ddd MMM') +
' Q' + DATENAME(QUARTER, CreationTime) +
format(creationTime,' yyyy HH:mm:ss tt') as date
from Sales.Orders

/* Why we need to do Date Formatting */

-- Data Aggregation : 
/* TASK : get Order date 'Feb 25' and find total orders*/

select format(OrderDate, 'MMM yy') as orderDate, count(*) orders
from Sales.Orders
group by format(OrderDate, 'MMM yy')

-- Data Standardization : Clean data into one standard format from diff. resources


-- CONVERT : Convert value to diff. data type.  convert(data_type, value)
select CONVERT(int, '32323') as INT

select CreationTime,
convert(date, CreationTime) as conv_creationTime
from Sales.Orders

-- CAST : Convert a value to diff. data type. cast(value as data_type)
select cast('331' as int) as int

/* Format vs Convert vs Cast	*/
/*
				CASTING						FORMATING
CAST		AnyType to AnyType					X
CONVERT		AnyType to AnyType			Only to Date & Time
FORMAT		AnyType to Only String	  To both Date&Time & Numbers
*/


-- Date Calculations : DateAdd(), DateDiff()

-- DateAdd : Add/Subtract specific time interval to/from a date. DATEADD(part, interval, date) : DATEADD(year,2,OrderDate)
select OrderDate,
DATEADD(year,2,OrderDate) as '2yearsLater',
DATEADD(month,-4,OrderDate) as '4yearsEarlier'
from Sales.Orders

-- DateDiff : Diff btw two dates. DATAEDIFF(part, start_date, end_date) : DATEDIFF(year, OrderDate, ShippedDate)
select OrderDate, ShipDate,
DATEDIFF(day,OrderDate,ShipDate) as 'No_Days_TakenToShip'
from Sales.Orders

/* TASK : Calculate age of employee from Employees table	*/
select FirstName, 
datediff(year, BirthDate, GETDATE()) as age 
from Sales.Employees

/* TASK : Find average shipping duration in each month	*/
select datename(month, OrderDate) as month, 
avg(DATEDIFF(day, OrderDate, ShipDate))
as Avg_shipping_Duration 
from sales.orders 
group by datename(month, OrderDate)


-- LAG : To access previous value from row : lag(col_name) over (order by order_column)
/* LAG is a window fn	*/

/* Time Gap Analysis	*/

/* TASK : Find no. of days btw each order and previous order	*/
select OrderID, 
OrderDate cur_OrderDate,
lag(OrderDate) over (order by OrderDate) as prev_order_date,
datediff(day, lag(OrderDate) over (order by OrderDate), OrderDate) as NoOfDays
from Sales.Orders


-- Date Validation : ISDATE() - chk whether a value is a date, return 1 or 0

select ISDATE('10/08/2023')
select ISDATE('123')

/*ADVANCED*/
/* TASK : CAST and Check whether Date is in correct type/format */
select 
	--cast(orderDate as Date) as orderDate,
	orderDate,
	isdate(orderDate),
	case when isdate(orderDate) = 1 then cast(orderDate as Date)
		 else '2001-12-12'
	end newOrderDate
from (
	select '2025/10/13' as orderDate union
	select '2025/08/19' union
	select '2025/08/23' union
	select '2025/08'
)t
--where ISDATE(orderDate) = 0