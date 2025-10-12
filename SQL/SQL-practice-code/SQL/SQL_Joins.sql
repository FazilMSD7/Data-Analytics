Use MyDatabase

/* JOINS : combining columns from diff. tables
   SETS : combining rows from diff. tables	*/

/* JOINS : Inner, Full, Letft, Right -> Key Column
   SETS : Union, Union All, Intersect, Except -> Same Columns	*/

/* JOINS :
1. Recombine data -> eg : combine Customers, Address, Orders.. together
2. Data enrichment -> Get exact data. eg : Add needed data from other table, 
										   like if customer table need zipcode details join them
3. Check existence(filtering) -> just to check with conditions from other table, will not combine


Types : Matching Joins -> Full, Inner, Right, Left
		Unmatching Joins -> Left anti, Right anti, Full anti, Cross join
*/


-- No join : returns data from two tables without combining them
select * from customers
select * from orders

-- Inner join : returns only matching data from both tables
/* for any join it will be select * from A [type] join B on <condition>... 
   If we donot specify any type default will be inner join

   order of table doesn't matter in inner join, select * from B inner join A on B.key = A.key
*/

/* TASK : get all customers along with their orders, but only who have placed order	*/
select * from customers inner join orders on id = customer_id

select customer_id, first_name, order_id, sales from customers inner join orders on id = customer_id

/* NOTE : column ambiguity -> add table name before column to avoid confusion on joins with same col. name	
		  to avoid rewriting table names again and again use alias
*/

select orders.customer_id, customers.first_name, orders.order_id, orders.sales 
from customers inner join orders on customers.id = orders.customer_id

select o.customer_id, c.first_name, o.order_id, o.sales 
from customers as c inner join orders as o
on c.id = o.customer_id


-- Left join : All rows from left table and only matching from right

/* order of table matter in left and right join, select * from A left join B on A.key = B.key
   all data's from table A will be there, and only matching from table B	*/

/* TASK : Get all customers along with their orders, including those without orders	*/

select c.id, c.first_name, o.order_id, o.sales
from customers as c left join orders as o
on c.id = o.customer_id

-- Right join : Allrows from right table and only matching from left

/* TASK : Get all customers along with their orders, including orders withoutmatching customers	*/

select c.id, c.first_name, o.order_id, o.sales 
from customers as c right join orders as o
on c.id = o.customer_id

/* TASK : same task using Left Join	
   (just switch the order of from and join type-> it will become left join or vice versa) */

select c.id, c.first_name, o.order_id, o.sales 
from orders as o left join customers as c
on c.id = o.customer_id

-- Full join : All rows from both tables

/* TASK : Get all customers and orders even if ther's no match	*/

select * 
from customers as c full join orders as o
on c.id = o.customer_id


/* ADVANCED Join Types : Left Anti, Right Anti, Full Anti, Cross join : for unmatcj=hing values	*/

-- Left anti join : returns rows from left table that has no match in right
/* we need to use filter (where) : select * from A left join B on A.key = B.key where B.key is null	*/

/* TASK : Get all customers who haven't placed any orders	*/

select c.id, c.first_name 
from customers as c left join orders as o
on c.id = o.customer_id
where o.customer_id is null

-- Right anti join : returns rows from right table that has no match from left

/* TASK : Get all orders without matching customers	*/

select *
from customers as c right join orders as o
on c.id = o.customer_id
where c.id is null

/* TASK : Same task using Left join	*/
select *
from orders as o left join customers as c
on c.id = o.customer_id
where c.id is null


/* the below will never work, bcz if c.id is null pk should never be null so it nvere returns anything

   select * x
   from customers as c left join orders as o
   on c.id = o.customer_id
   where c.id is null	
*/


-- Full anti join : returns only which donot match in both tables. It's opposite of Inner join

/* TASK : Find customers without orders and orders without customers	*/

select * 
from customers as c full join orders as o
on c.id = o.customer_id
where c.id is null or o.customer_id is null


/* TASK : Get all customers along with their orders,
		  but only for customers who have placed an order (without using inner join)	*/

select * 
from customers as c left join orders as o
on c.id = o.customer_id
where o.customer_id is not null

/* using inner join	*/
select * 
from customers inner join orders
on id = customer_id


-- Cross join : combines every row from left and right (all possible combinations - cartesian join)

/* TASK : Generate all possible combinations of customers and orders table */
select * from customers cross join orders


/* How to choose between Join Types	*/

/*  Only matching : INNER JOIN

	All Rows : 1. One side(master table) -> LEFT JOIN
			   2. Both side(master both) -> FULL JOIN

	Only Unmatching : 1. One side(master table) -> LEFT ANTI JOIN(Left + Where)
					  2. Both side(master both) -> FULL ANTI JOIN(Full + Where)		
					  
	** Try using Left Join, Avoid using Right join for any ** 
*/


-- MULTIPLE TABLE JOINS (Joins more than 2 tables) -> Left Join + Where

/* If u need to match tables -> Use Left join + Where
   If every tables matters -> User Inner join	*/


/* TASK : Using SalesDB, Retrive a list of all orders, along with the related customer, product and employee details	

	For each order, dispaly :
	OrderId, Customers's name, Product's name, Sales amount, Product price, Salesperson's name
*/

Use SalesDB

/* Check ER Diagram for relationship btw tables	*/
select * from Sales.Customers
select * from Sales.Orders
select * from Sales.Employees
select * from Sales.Products


select 
	o.OrderId,
	c.FirstName as customerFirstName, c.LastName as customerLastName,
	p.Product as ProductName,
	o.Sales, 
	p.Price, 
	e.FirstName as EmployeeFirstName, e.LastName as EmployeeLastName
from Sales.Orders as o left join Sales.Customers as c
on o.CustomerID = c.CustomerID
left join Sales.Products as p
on o.ProductID = p.ProductID
left join Sales.Employees as e
on o.SalesPersonID = e.EmployeeID