Select *
FROM sale.customer
 =================
 Select Distinct first_name
 FROM sale.customer

 ================
 Select Count(first_name)
 From sale.customer

 ==============
 SELECT TOP 5 list_price
 FROM sale.order_item

 ------

 SELECT *
 FROM sale.order_item

Select order_id, AVG(list_price)
FROM sale.order_item
Group BY order_id