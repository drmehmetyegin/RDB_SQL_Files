SELECT *
FROM product.product
WHERE list_price > (SELECT list_price
                    FROM product.product
                    WHERE product_name= 'Pro-Series 49-CLASS FULL HD Outdoor Led TV (Silver)' )

===================================
SELECT b.first_name, b.last_name,a.order_date
FROM sale.orders a
INNER JOIN sale.customer b ON a.customer_id=b.customer_id
WHERE a.order_date IN
(
SELECT o.order_date
FROM sale.customer c 
INNER JOIN sale.orders o  ON c.customer_id= o.customer_id
WHERE first_name= 'Laurel' and last_name='Goldammer')

=================================
SELECT i.product_id,p.product_name
FROM sale.orders o 
INNER JOIN sale.customer c ON o.customer_id=c.customer_id
INNER JOIN sale.order_item i ON i.order_id=o.order_id
INNER JOIN product.product p ON p.product_id=i.product_id
WHERE i.order_id IN (
SELECT TOP 10 order_id
FROM sale.orders o 
INNER JOIN sale.customer c ON o.customer_id=c.customer_id
WHERE city='Buffalo'
ORDER BY order_id DESC)


==================
WITH cte as 
(Select TOP 1 o.order_date as last_order_date
FROM sale.orders o , sale.customer c  
WHERE o.customer_id= c.customer_id
AND c.first_name='Jerald' AND c.last_name='Berray'
ORDER BY o.order_date DESC)
SELECT a.first_name, a.last_name
FROM sale.customer a, sale.orders b , cte
WHERE b.order_date < cte.last_order_date
AND city='Austin'

===================
WITH CTE1 AS
(
SELECT o.order_date as lg_dates
FROM sale.customer c 
INNER JOIN sale.orders o  ON c.customer_id= o.customer_id
WHERE first_name= 'Laurel' and last_name='Goldammer')
SELECT a.customer_id,b.first_name, b.last_name, CTE1.lg_dates
FROM sale.orders a , sale.customer b, CTE1
WHERE a.customer_id= b.customer_id
AND a.order_date=CTE1.lg_dates
