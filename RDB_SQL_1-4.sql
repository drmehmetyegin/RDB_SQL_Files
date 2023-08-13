
----------------------------
Select Top 10 customer_id, first_name, last_name
From Sale.customer
Order by first_name DESC;
-----------------
-- WHERE NOT
SELECT first_name, last_name, street, city, state
FROM sale.customer
WHERE NOT city = 'Atlanta';
----------------
select TOP 5 first_name, COUNT(first_name) num_of_names
from sale.customer
Group BY first_name
order BY num_of_names DESC
---------------
---Find people with Irish descent
Select customer_id, first_name,last_name
FROM sale.customer
WHERE last_name like 'Mc%'

-------------
----Brand names starts with A or D
SELECT*
FROM product.brand
WHERE brand_name LIKE '[AD]%'
----------------
----Brand names starts bt A-L
SELECT*
FROM product.brand
WHERE brand_name LIKE '[A-L]%'

----------------
---People that does not live in TX, OH, PA
Select  first_name+ ' '+last_name as customer_name_list
FROM sale.customer
Where state NOT IN ('TX', 'OH', 'PA')

-----------------
-- date should be written among quotes
SELECT *
FROM sale.orders
WHERE order_date 
    BETWEEN '2018-08-13' 
        AND '2018-09-23';
SELECT *
FROM sale.orders
WHERE order_date BETWEEN '20180203' AND '20180209';

-----------------
select Top 1 state, Count(*) num_hotmail_state
from sale.customer
Group By State
order by num_hotmail_state DESC

=====================

select order_id, SUM(quantity*list_price*discount) total_discount
from sale.order_item
Group by order_id

Select *
from sale.order_item

===========================
=orders that are more than 2 days
Select  order_id,
        DATEDIFF(DAY,order_date,shipped_date) as inday_shipped
from sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2

=====================================

Select  [order_id],[customer_id],[order_status],[order_date],[required_date],[shipped_date],[store_id],[staff_id],
        DATEDIFF(DAY,order_date,shipped_date) as inday_shipped
from sale.orders
WHERE DATEDIFF(DAY,order_date,shipped_date) >2
Order BY inday_shipped

================

Select Len('welcome')
Select CHARINDEX('ct', 'character')
Select PATINDEX('%R', 'Character')

====================

---JOIN
Select *
from sale.staff

select *
from sale.store

=================
--How many employees are in each store?

Select b.store_name, COUNT(a.staff_id) num_employee
From sale.staff a
INNER JOIN sale.store b ON a.store_id=b.store_id
GROUP By b.store_name

====================
---Report total number of products sold by each employee?
Select a.staff_id,ISNULL(SUM (c.quantity),0) total_sale
FROM sale.staff a 
Left JOIN sale.orders b ON a.staff_id= b.staff_id
Left Join sale.order_item c On b.order_id=c.order_id
Group by a.staff_id,c.quantity
Order By total_sale DESC;

=================================
---Report total sale by each employee?
Select a.staff_id,Convert(DEC(18,2), ISNULL(SUM (c.quantity*c.list_price*(1-c.discount)),0),1) total_sale
FROM sale.staff a 
Left JOIN sale.orders b ON a.staff_id= b.staff_id
Left Join sale.order_item c On b.order_id=c.order_id
Group by a.staff_id,c.quantity
Order By total_sale DESC;

=====================




