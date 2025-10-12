use SalesDB

-- SET operators : combining rows from diff. tables

/* UNION, UNION ALL, INTERSECT, EXCEPT	*/

/* query : select * from customers 'set op.' select * from orders	*/

/* Rules :
1. SET operators can be used almost with all clauses WHERE | JOIN | GROUP BY | HAVING
   ORDER BY can be used only once atlast

   Eg: Select * from table..	UNION Select * from table..	Order by FirstName

2. No. of columns in each query must be the same. Eg: Select FirstName from.. UNION Select FirstName, LastName from.. -> X

3. Data types of columns in each query must be compatible. Eg: Select CustomerID.. UNION Select FirstName... -> X

4. Order of columns also should be same. Eg: Select LastName.. UNION Select EmployeeID.. -> X

5. Column name in result is determined from first query(select statement)
*/

/* Quick Recap of Rules :
1. Order by can be used only once
2. Same No. of columns, Data types, Order of columns
3. First qury controls alias	*/

-- UNION : returns all distinct rows from both queries, No duplicates

/* TASK : Combine data from employees and customers into one table	*/
select FirstName, LastName from Sales.Customers 
union 
Select FirstName, LastName from Sales.Employees

-- UNION ALL : returns all rows from both queries, Incudes Duplicates, Faster than Union
select FirstName, LastName from Sales.Customers 
union all
Select FirstName, LastName from Sales.Employees

-- EXCEPT : returns all distinct rows from first query that are not in second query. Order matters
select FirstName, LastName from Sales.Employees 
except
Select FirstName, LastName from Sales.Customers

-- INTERSECT : returns only rows common in both queries
select FirstName, LastName from Sales.Employees 
intersect
Select FirstName, LastName from Sales.Customers

/* Use Cases :
1. Combine similar info before analyzing

2. For DE -> DELTA DETECTION : Use 'Except' to get latest data from Data Resource and load into Data warehouse, 
                               by which we get newly added data instead of all

3. Data completeness check : 'Except' can be used to compare tables to detect discrepancies btw db's.
                              Result should be Empty. Table A 'EXCEPT' Table B
*/

/* TASK : Orders are stored in separate tables(Orders and OrdersArchive)
		  Combine all orders into one report without duplicates	*/

select * from Sales.Orders
union
select * from Sales.OrdersArchive

/* don't use '*' for select all bcz it will sometimes give issue but we can't see like interchange of cols.
   so use col. name instead by select Table -> Right Click -> Select 1000 rows and copy paste the col_name	
   and include source table(new column) for better understanding    */

select 'Orders' as SourceTable
      ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime] from Sales.Orders

union

select 'OrdersArchive' as SourceTable
      ,[OrderID]
      ,[ProductID]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[OrderDate]
      ,[ShipDate]
      ,[OrderStatus]
      ,[ShipAddress]
      ,[BillAddress]
      ,[Quantity]
      ,[Sales]
      ,[CreationTime] from Sales.OrdersArchive

order by OrderID