-- Stored Procedure
/* Stored inside db server side, not client. 
Instead of writing same query again we can call stored procedure, it's like function.
It can do loops, control flow, parameters, error handling

Best way to control projects is python, better than Stored procedures
*/

/*
 Syntx : Create Procedure Procedure_name as
		 Begin
			-- SQL Statements
		 End

To call -> Exec Procedure_name
*/

/* TASK : For US customers Find the total number of customers and average score	*/

Create Procedure CustomerDetails as
Begin
	select  
	count(CustomerId) TotalCustomers,
	Avg(Score) AverageScore
	from sales.Customers
	where Country = 'USA'
End;
Go

Exec CustomerDetails

/* ------------------------------------------------------------------------------------------------------ */

-- Stored procedure Parameters : Placeholder used to pass values as input from caller to procedure

/* TASK : For German customers Find the total number of customers and average score	*/
Alter Procedure CustomerDetails @country NVARCHAR(50) as
Begin
	select  
	count(CustomerId) TotalCustomers,
	Avg(Score) AverageScore
	from sales.Customers
	where Country = @country
End;
Go

Exec CustomerDetails @country = 'Germany'

Exec CustomerDetails @country = 'USA'

/* ------------------------------------------------------------------------------------------------------ */

-- default parameter : if used didn't define any value it will take default value Eg.'USA'
Alter Procedure CustomerDetails @country NVARCHAR(50) ='USA' as
Begin
	select  
	count(CustomerId) TotalCustomers,
	Avg(Score) AverageScore
	from sales.Customers
	where Country = @country
End;
Go

Exec CustomerDetails

/* ------------------------------------------------------------------------------------------------------ */

-- multiple queries :
/* TASK : Find total number of orders and total sales where country = 'USA'	*/
Alter Procedure CustomerDetails @country NVARCHAR(50) ='USA' as
Begin
	select  
	count(CustomerId) TotalCustomers,
	Avg(Score) AverageScore
	from sales.Customers
	where Country = @country;

	select 
	Count(OrderID) TotalOrders,
	Sum(Sales) TotalSales
	from Sales.Orders o
	join Sales.Customers c on
	o.CustomerID = c.CustomerID
	where country = @country

end;
Go

Exec CustomerDetails
Exec CustomerDetails @country = 'Germany'

/* ------------------------------------------------------------------------------------------------------ */

-- Stored procedure Variables : Placeholders used to store values to be used later in the procedure
/* TASK : Get below output :
		  Total Customers from Germany : 2
		  Average Score from Germany : 425
*/

-- Stored procedure Control flow : 'IF.. BEGIN.. END	ELSE BEGIN.. END'
/* TASK : Remove if any null and get Avg score	*/

Alter Procedure CustomerDetails @country NVARCHAR(50) ='USA' as
Begin

		-- step 1 : declare variables
declare @totalcustomers int, @avgscore float;

-- Prepare & Cleanup : Control flow Task
IF Exists (Select 1 from Sales.Customers where score is null and country = @country)
	BEGIN
		print('Updating Null score to 0')
		Update Sales.Customers
		Set Score = 0
		where score is null and country = @country
	END

ELSE
	BEGIN
		print('No Null score found')
	END

-- Generating Reports : Variable Task
		-- step 2 : assign values before like @total.. = , and remove alias
	select  
	@totalcustomers = count(CustomerId),
	@avgscore = Avg(Score)
	from sales.Customers
	where Country = @country;

		-- step 3 : use variables & while using it should be same dtype.
		--			so cast it accordingly
	print 'Total Customers from ' + @country + ': ' + cast(@totalcustomers as NVARCHAR);
	print 'Average Score from Germany ' + @country + ': ' + cast(@avgscore as NVARCHAR);

end;
go

/* go to mesaages instaed of result to check log */
Exec CustomerDetails
Exec CustomerDetails @country = 'Germany'

/* ------------------------------------------------------------------------------------------------------ */

-- Store procedure Error Handling :
/*
Syntx : BEGIN TRY
			-- SQL Statements that might cause error
		END TRY

		BEGIN CATCH
			-- SQL Statements to handle error
		END CATCH
*/

Alter Procedure CustomerDetails @country NVARCHAR(50) ='USA' as
Begin
	BEGIN TRY
		select 
		Count(OrderID) TotalOrders,
		Sum(Sales) TotalSales,
		1/0	-- divsion error 
		from Sales.Orders o
		join Sales.Customers c on
		o.CustomerID = c.CustomerID
		where country = @country
	END TRY

	BEGIN CATCH
		print('Error occured')
		print('Error Message : ' + error_message());
		print('Error Message : ' + cast(error_number() as NVARCHAR));
		print('Error Message : ' + cast(error_line() as NVARCHAR));
		print('Error Message : ' + error_procedure());
	END CATCH

end;
Go

exec CustomerDetails

drop procedure CustomerDetails


/* Stored Procedures Summary :
-- It's a precompiled set of SQL statements stored in database

EXEC proc_name to execute, 
Syntx : CREATE Procedure name as 
		Begin
			..SQL Logic
		End

Parameters - Alter Procedure Proc_name @country NVARCHAR(50)
			 use @country while Exec and Inside SQL logic

Variables - declare @totalcustomers int, @avgscore float;
			In SELECT Logic assign Variable : select  
											  @totalcustomers = count(CustomerId)..

Control Flow : IF..condition
			     BEGIN..	END
			   ELSE 
				 BEGIN..	END

Error Handling : BEGIN TRY
					-- SQL Statements that might cause error
				 END TRY

				BEGIN CATCH
					Print ERROR_MESSAGE(SQL Statements to handle error)
				END CATCH