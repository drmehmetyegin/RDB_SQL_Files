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