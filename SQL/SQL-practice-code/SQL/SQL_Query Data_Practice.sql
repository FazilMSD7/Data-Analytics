use MyDatabase

select * from orders

/* TASK : Get two most recent orders	*/
select top 2 * from orders order by order_date desc
