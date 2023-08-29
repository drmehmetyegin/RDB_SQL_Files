--SQL SESSION-8, 23.01.2023, (Window Functions-1)

--Window Functions (WF) vs. GROUP BY
--Let's review the following two queries for differences between GROUP BY and WF.
---------------------------------------------------------------------

--QUESTION: Write a query that returns the total stock amount of each product in the stock table.

-----with Group By

SELECT product_id, SUM(quantity) total_stock
FROM product.stock
GROUP BY product_id
ORDER BY product_id


SELECT DISTINCT product_id, SUM(quantity)  OVER(PARTITION BY product_id) total_stock1
FROM product.stock


SELECT *,  SUM(quantity)  OVER(PARTITION BY product_id) total_stock1
FROM product.stock

--///////////////////////////////
--QUESTION: Write a query that returns average product prices of brands. 
SELECT *
FROM sale.order_item a 
INNER JOIN product.product b ON a.product_id= b.product_id
INNER JOIN product.brand c ON b.brand_id=c.brand_id

SELECT c.brand_name, AVG(a.list_price* a.quantity*(1-a.discount)) aver_product
FROM sale.order_item a 
INNER JOIN product.product b ON a.product_id= b.product_id
INNER JOIN product.brand c ON b.brand_id=c.brand_id
GROUP BY c.brand_name
ORDER BY c.brand_name

SELECT DISTINCT c.brand_name, AVG(a.list_price* a.quantity*(1-a.discount)) OVER (PARTITION BY c.brand_name ORDER BY c.brand_name) aver_product1
FROM sale.order_item a 
INNER JOIN product.product b ON a.product_id= b.product_id
INNER JOIN product.brand c ON b.brand_id=c.brand_id

-------------------------------------------------------------------------
--1. ANALYTIC AGGREGATE FUNCTIONS
--MIN() - MAX() - AVG() - SUM() - COUNT()
-------------------------------------------------------------------------

--QUESTION: What is the cheapest product price for each category?

SELECT DISTINCT  e.product_name, MIN (d.list_price* d.quantity*(1-d.discount)) OVER (PARTITION BY category_name )
FROM sale.order_item d  
INNER JOIN product.product e ON d.product_id= e.product_id
INNER JOIN product.category f ON f.category_id=e.category_id 

--///////////////////////////////
--QUESTION:	How many different product in the product table?
SELECT DISTINCT COUNT(product_id) OVER() num_product_types
FROM product.product
--///////////////////////////////
--QUESTION: How many different product in the order_item table?

----The following queries bring wrong numbers since they count all the line 

select count(product_id) over()
from sale.order_item

select count(product_id) over(partition by product_id) num_of_products
from sale.order_item

select distinct count(product_id) over(partition by product_id) num_of_products
from sale.order_item
------product id kac defa gecmis onu getirdi
----------That should be like. COUNT and DISTINCT kullanimina dikkat etmek lazim

SELECT COUNT (DISTINCT (product_id)) 
FROM sale.order_item

select distinct count(product_id) over() num_of_products
from(
	select distinct product_id
	from sale.order_item
) t1

--///////////////////////////////
--QUESTION: Write a query that returns how many products are in each order?

SELECT *
FROM sale.order_item

SELECT DISTINCT order_id, SUM(quantity) OVER(PARTITION BY order_id) num_product
FROM sale.order_item

--///////////////////////////////
--QUESTION: Write a query that returns the number of products in each category of brands.
--(her bir markan�n farkl� kategorilerdeki �r�n say�lar�)

SELECT DISTINCT pp.brand_id pp.category_id, COUNT(pp.brand_id) OVER(PARTITION BY pp.brand_id, pp.category_id)
FROM sale.order_item oi 
INNER JOIN product.product pp ON pp.product_id=oi.product_id

-------------------------------------------------------------------------
--WINDOW FRAMES
-------------------------------------------------------------------------
-------partition by sifirlama yapar order by toplayarak devam eder. 3. satirda 13 21 33 41 olarak gidiyor
select brand_id, model_year,
	count(product_id) over(),
	count(product_id) over(partition by brand_id),
	count(product_id) over(partition by brand_id order by model_year)
from product.product
---------------Unbounded preceding ve unbounded following partition by ile gruplanan itemlarin basi ve sonu. Bir sonraki brand_id de bastan baslar
select brand_id, model_year,
	count(product_id) over(partition by brand_id order by model_year),
	count(product_id) over(partition by brand_id order by model_year range between unbounded preceding and current row) [range], --default
	count(product_id) over(partition by brand_id order by model_year rows between unbounded preceding and current row) [row],
	count(product_id) over(partition by brand_id order by model_year rows between 1 preceding and current row) [row_1_preceding],
	count(product_id) over(partition by brand_id order by model_year rows between unbounded preceding and unbounded following) [row_un],
	count(product_id) over(partition by brand_id order by model_year range between unbounded preceding and unbounded following) [range_un]
from product.product

select brand_id, model_year,
	count(product_id) over(partition by brand_id order by model_year),
    count(product_id) over(partition by brand_id order by model_year rows between unbounded preceding and 1 following) [Row23],
    count(product_id) over(partition by brand_id order by model_year range between current row and unbounded following) [Row44],
    count(product_id) over(partition by brand_id order by model_year range between current row and unbounded following) [range_11]
from product.product


-------------------------------------------------------------------------
--2. ANALYTIC NAVIGATION FUNCTIONS
-------------------------------------------------------------------------

--It's mandatory to use ORDER BY.

--******FIRST_VALUE()*****--
--/////////////////////////////////


select *, first_value(first_name) over(order by first_name) 
from sale.staff

select *, first_value(first_name) over(order by last_name) 
from sale.staff

--QUESTION: Write a query that returns first order date by month.
SELECT*
FROM sale.orders

SELECT DISTINCT YEAR(Order_date) OrderYear, Month(Order_date) OrderMonth, FIRST_VALUE(order_date) Over(ORDER BY YEAR(Order_date), Month(Order_date)) first_order_date
FROM sale.orders

--QUESTION: Write a query that returns customers and their most valuable order with total amount of it.


---SELECT k.customer_id, l.order_id, FIRST_VALUE(net_price) OVER (ORDER BY k.customer_id)
---FROM (SELECT k.customer_id, l.order_id, SUM(m.list_price*m.quantity*(1-m.discount)) net_total_price
----FROM sale.customer k  
---INNER JOIN sale.orders l ON k.customer_id= l.customer_id
---INNER JOIN sale.order_item m ON l.order_id=m.order_id
---GROUP BY k.customer_id, l.order_id)t
--ORDER BY k.customer_id, l.order_id) t

WITH CTE AS (SELECT k.customer_id, l.order_id, SUM(m.list_price*m.quantity*(1-m.discount)) net_total_price
FROM sale.customer k  
INNER JOIN sale.orders l ON k.customer_id= l.customer_id
INNER JOIN sale.order_item m ON l.order_id=m.order_id
GROUP BY k.customer_id, l.order_id)
SELECT distinct customer_id,
	first_value(order_id) over(partition by customer_id order by net_price desc),
	first_value(net_price) over(partition by customer_id order by net_price desc)
from CTE

---True only
with cte as
(
		select a.customer_id, b.order_id,
			SUM(quantity * list_price * (1-discount)) net_price
		from sale.orders a
			inner join sale.order_item b
			on a.order_id=b.order_id
		group by a.customer_id, b.order_id
		
)
select distinct customer_id,
	first_value(order_id) over(partition by customer_id order by net_price desc),
	first_value(net_price) over(partition by customer_id order by net_price desc)
from cte

--/////////////////////////////////
--******LAST_VALUE()*****--


--QUESTION: Write a query that returns last order date by month.
SELECT DISTINCT YEAR(Order_date) OrderYear, Month(Order_date) OrderMonth, LAST_VALUE(order_date) Over(ORDER BY YEAR(Order_date), Month(Order_date)) last_order_date
FROM sale.orders

--******LAG() & LEAD()*****--


--LAG() SYNTAX

/*LAG(return_value ,offset [,default]) 
OVER (
    [PARTITION BY partition_expression, ... ]
    ORDER BY sort_expression [ASC | DESC], ...
)*/


--QUESTION: Write a query that returns the order date of the one previous sale of each staff (use the LAG function)
SELECT *
FROM sale.staff a
INNER JOIN sale.orders b ON a.staff_id=b.staff_id

SELECT a.staff_id, (a.first_name + ' '+a.last_name) as fullname, b.order_date, LAG(b.order_date) OVER (Partition BY a.staff_id Order BY order_date) previous_sale
FROM sale.staff a
INNER JOIN sale.orders b ON a.staff_id=b.staff_id

--LEAD() SYNTAX

/*LEAD(return_value ,offset [,default]) 
OVER (
    [PARTITION BY partition_expression, ... ]
    ORDER BY sort_expression [ASC | DESC], ...
)*/

--QUESTION: Write a query that returns the order date of the one next sale of each staff (use the LEAD function)
SELECT a.staff_id, (a.first_name + ' '+a.last_name) as fullname, b.order_date, LEAD (b.order_date) OVER (Partition BY a.staff_id Order BY order_date) next_sale
FROM sale.staff a
INNER JOIN sale.orders b ON a.staff_id=b.staff_id


----------------------------------------------------------------------

--QUESTION: Write a query that returns the difference order count between the current month and the previous month for each year. 

WITH cte as (SELECT YEAR(a.order_date) order_year, MONTH(a.order_date) order_month, COUNT(a.order_id) order_count
FROM sale.orders a 
GROUP BY YEAR(a.order_date), MONTH(a.order_date))
SELECT order_year, order_month, order_count, LAG(order_count) OVER (Order by order_month) as next_month, (order_count-LEAD(order_count) OVER (Order by order_month))as difference_order
FROM cte


with t1 as(
	select distinct year(order_date) years, month(order_date) months,
		count(order_id) over(partition by year(order_date), month(order_date)) total_orders
	from sale.orders
)
select years, months, total_orders,
	lag(total_orders) over(partition by years order by years, months) previous_month,
	total_orders - lag(total_orders) over(partition by years order by years, months) 'difference'
from t1



SELECT YEAR(order_date) order_year, MONTH(order_date) order_month, COUNT(order_id) order_count
FROM sale.orders 
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)

--SQL SESSION-9, 25.01.2023, (Window Functions-2)

--*** Windowed functions can only appear in the SELECT or ORDER BY clauses.

--3. ANALYTIC NUMBERING FUNCTIONS--

--ROW_NUMBER() - RANK() - DENSE_RANK() - CUME_DIST() - PERCENT_RANK() - NTILE()

--The ORDER BY clause is mandatory because these functions are order sensitive.
--They are not used with window frames.

--////////////////////////

--QUESTION: Assign an ordinal number to the product prices for each category in ascending order.

SELECT
	category_id, list_price,
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_num	
FROM
	product.product


--Lets try previous query again using RANK() and DENSE_RANK() functions.
SELECT
	category_id, list_price,
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_num,
	RANK() OVER(PARTITION BY category_id ORDER BY list_price) rank_num,
	DENSE_RANK()OVER(PARTITION BY category_id ORDER BY list_price) drank_num,
	PERCENT_RANK() OVER(PARTITION BY category_id ORDER BY list_price) perrank_num
FROM
	product.product



SELECT
	category_id, list_price,
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) row_num,
	RANK() OVER(PARTITION BY category_id ORDER BY list_price) rnk,
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) dense_rnk
FROM
	product.product

	-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


--QUESTION: Write a query that returns both of the followings:
-- * Average product price.
-- * The average product price of orders.


SELECT DISTINCT order_id, 
		AVG((list_price*quantity*(1-discount))) OVER () as avg_pr_price,
		AVG((list_price*quantity*(1-discount))) OVER (PARTITION BY order_id) as avg_ord_price
FROM sale.order_item


