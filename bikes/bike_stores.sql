select ord.order_id, CONCAT(cus.first_name, ' ', cus.last_name) as 'customers', 
	cus.city, cus.state, ord.order_date,
	SUM(ite.quantity) as 'total units',
	SUM(ite.quantity * ite.list_price) as 'revenue',
	pro.product_name,
	cat.category_name,
	store.store_name,
	CONCAT(stf.first_name, ' ', stf.last_name) as 'sales_rep'
from sales.orders as ord
join
sales.customers as cus
on 
ord.customer_id = cus.customer_id 
join 
sales.order_items as ite
on
ord.order_id = ite.order_id
join 
production.products as pro
on
ite.product_id = pro.product_id
join production.categories as cat
on
pro.category_id = cat.category_id
join sales.stores as store
on ord.store_id = store.store_id
join
sales.staffs as stf
on
ord.staff_id = stf.staff_id
group by ord.order_id, CONCAT(cus.first_name, ' ', cus.last_name), 
	cus.city, cus.state, ord.order_date, pro.product_name, cat.category_name,
	store.store_name,
	CONCAT(stf.first_name, ' ', stf.last_name) 

