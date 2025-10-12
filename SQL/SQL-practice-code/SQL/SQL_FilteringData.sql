USE MyDatabase

/* Filtering Data - where operators : 
1. Comparision Operators ( = != <> < > >= <= )
2. Logical Operators ( and, or, not )
3. Range Operator ( Between)
4. Membership Operator ( In, Not In)
5. Search Operator ( Like )	*/

-- Comparision Operatoes : Expression Operator Expression
/* Column1 = Column2	eg: first_name = last_name
   Column1 = Value		eg: first_name = 'John'
   Function = Value		eg: UPPER(first_name) = 'JOHN'
   Expression = Value	eg: price*quantity = 1000
   Subquery = Value		eg: (select avg(sales) from orders) = 1000		** Advanced **	*/
   
select * from customers where country = 'USA'
select * from customers where country != 'USA'
select * from customers where country <> 'USA'	/* both != and <> is same */
select * from customers where score>=500


-- Logical Operators :
/* AND : all conditions must be true
   OR : anyone should be true
   NOT : excludes matching values	*/

select * from customers where country = 'USA' AND score >= 500

select * from customers where country = 'USA' OR score >= 500

select * from customers where NOT country = 'USA'


-- Range Operators : check if value is within the range (inclusive)

select * from customers where score between 300 AND 700

-- Membership Operators : Check value exist in list

/* TASK : retrive all customers from either Germany or USA */
/* using comp. and logical ops */
select * from customers where country = 'Germany' OR country = 'USA'

/* using membership op */
select * from customers where country IN ('Germany','USA')

select * from customers where country NOT IN ('Germany','USA')


-- Search Operator : search for a patter in text
/* % -> anything(0,1,many)
   _ -> exact match	*/

/* Example : M% -> Maria, Ma, M
			 %in -> Martin, vin, in
			 %r% -> Maria, Peter, Rayan, R

			 __b% -> Albert, Rob
*/

/* TASK : Find all customers whose first name starts with 'M'	*/
select first_name from customers where first_name LIKE 'M%'

/* TASK : Find all customers whose name contains 'r'	*/
select first_name from customers where first_name LIKE '%r%'

/* TASK : Find all customers whose name has 'r' in 3rd position	*/
select first_name from customers where first_name LIKE '__r%'