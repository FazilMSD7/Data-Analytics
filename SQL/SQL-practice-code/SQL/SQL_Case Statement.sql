use SalesDB

/* CASE STATEMENTS */

/* allows to write condition statements and returns value when met	
	Syntax : Case	when 'condition' then 'result' .. else 'result'		End

	If we don't write else it will return 'Null'
	Execution stops when 1st condition is met
*/

/*	Use case :	Data Transformation */

-- Categorizing Data : 

/* Generate a report showing total sales for each category :
	- High: If Sales > 50
	- Medium: If Sales btw 20 and 50
	- Low: If Sales >= 20
	Sort categories from lowest to highest	*/

select category,
sum(sales) as TotalSales
from (
select orderId, Sales,
CASE
	When Sales > 50 then 'High'
	When Sales > 20 then 'Medium'
	Else 'Low'
END
as Category
from Sales.Orders
)t
group by category
order by TotalSales


/* Rules : Data type of result must be matching	
Eg  : when Sales>50 then 'High' else 0 --> X	*/

-- Map values : transform from one value to another

/* TASK : Retrive employee details with gender displayed as full text	*/
select *,
CASE
	WHEN Gender = 'M' then 'Male'
	WHEN Gender = 'F' then 'Female'
END as gender
from sales.employees

/* TASK : Retrive customer details with abbreviated country code	*/
select *,
CASE
	WHEN Country = 'Germany' then 'GER'
	WHEN Country = 'USA' then 'US'
	ELSE 'Not Available'
END as abbrCountryCode
from Sales.Customers

-- Quick form : Instead of repeating col. name every time use col. after CASE, Only for = 'operator'
select *,
CASE Country
	WHEN 'Germany' then 'GER'
	WHEN 'USA' then 'US'
	ELSE 'Not Available'
END as abbrCountryCode
from Sales.Customers

-- Handling Nulls : replace null with specific value
/* TASK : Find average scores of customers and treat null as O
		  and provide details sucha s CustomerID & LastName	*/

select Customerid,
Lastname, 
Score,
Case
	When Score IS NULL then 0
	Else Score
End as TScore,
avg(Score) over() as Avg_Score,
avg(
Case
	When Score IS NULL then 0
	Else Score
End
) over() as Avg_Cleaned_Score
from Sales.Customers

-- Conditional Aggregation : apply only on subsets of data that fulfill certain conditions

/* TASK : Count how many times each customer has made an order with sales greater than 30	*/
select
CustomerID,
sum(
CASE
	When Sales>30 then 1
	Else 0
END) as TotalHighSales,
Count(*) as TotalOrders
from Sales.Orders
group by CustomerID