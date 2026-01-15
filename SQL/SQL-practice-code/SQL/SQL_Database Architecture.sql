-- Database Architecure

-- Data Warehouse :
/* A special db that collects and integrates data from different sources to enable analytical & suport decision-making	*/

/* Challenges & Solutions :

Challenge -> Redundancy, Performance issue, Complexity, Hard to maintain, Db Stress, Security

Solutions -> Subquery, CTE(Common Table Expression), Views, Temp Tables, CTAS(Create Table as Select)	*/

-- Database Architecture :
/*
Client -> User(Us) - Query

Server -> Database Engine -> Two types of storage : Disk & Cache

Database Engine : It's brain of the db, executing multiple operations such as storing, retriving and managing data with the dabatabase

Disk storage : Long term memory, where data is stored permanently.
			   Can hold a large amt. of data but slow to read & write

Cache storage : Fast short term memory, where data is stored temporarily.
				Extremely fast to read & write, but can hold samller amt. of data

** 3 Components of Disk Storage :

User Data Storage - Main content of the database, where Actual data that users care abt is stored. Eg. Sales.Customers

System Catalog - Db's internal storage for it's own information. A blueprint that keeps track of everything abt the data itself, not user data.
				 It holds the Metadata(Data about Data) information of the database.
				 Eg. TableName, ColumnName, DataType..
				 We can finf it in Information Schema(System defined schema with built in view thatprovide abt database like Tables and Columns)

Temporary Data Storage - Temp space used by the database for short term tasks like processing queries or sorting data.
						 Once these tasks are done, the storage is cleared
						 Database -> Sysytem Databases -> Tempdb -> Temporary Tables
*/

Select * from INFORMATION_SCHEMA.TABLES