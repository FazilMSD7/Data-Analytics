/* Aggregation & Analytical Functions	*/

/* Aggregate Functions : Count, Sum, Min, Max, Avg */

/* TASK : Find Count, Sum, Avg, Min and Max of sales data from orders table	*/

select customerid,
count(*) as Total_nr_Sales,
sum(Sales) as Total_Sales,
avg(Sales) as Avg_Sale,
min(Sales) as Min_Sale,
max(Sales) as Max_Sale
from Sales.orders
group by customerid			/* aggregtes per customer */

/* TASK : Analyze the scores in customers table	*/
select
count(*) as TotalCus,
sum(Score) as TotalScore,
min(Score) as MinScore,
max(Score) as MaxScore,
avg(
case
	when score is null then 0
	else score
end
) as AvgScore
from Sales.Customers