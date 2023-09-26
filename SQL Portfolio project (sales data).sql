-- inspecting data
select *
from portfolio_project.dbo.sales_data_sample$
order by ORDERLINENUMBER asc
-- checking unique values
select distinct status from portfolio_project.dbo.sales_data_sample$ -- nice one to plot
select distinct YEAR_ID from portfolio_project.dbo.sales_data_sample$
SELECT DISTINCT PRODUCTLINE from portfolio_project.dbo.sales_data_sample$
SELECT DISTINCT COUNTRY from portfolio_project.dbo.sales_data_sample$ -- NICE ONE TO PLOT
SELECT DISTINCT DEALSIZE from portfolio_project.dbo.sales_data_sample$ -- NICE ONE TO PLOT
SELECT DISTINCT TERRITORY from portfolio_project.dbo.sales_data_sample$ -- NICE ONE TO PLOT

select distinct MONTH_ID from portfolio_project.dbo.sales_data_sample$
WHERE YEAR_ID = 2003
order by 1 desc

-- ANALYSIS
-- LETS START BY GROUPING 
SELECT PRODUCTLINE, SUM(SALES) AS REVENUE
from portfolio_project.dbo.sales_data_sample$
GROUP BY PRODUCTLINE
ORDER BY 2 DESC

SELECT YEAR_ID, SUM(SALES) AS REVENUE
from portfolio_project.dbo.sales_data_sample$
GROUP BY YEAR_ID
ORDER BY 2 DESC

SELECT DEALSIZE, SUM(SALES) AS REVENUE
from portfolio_project.dbo.sales_data_sample$
GROUP BY DEALSIZE
ORDER BY 2 DESC

-- WHICH MONTH HAD THE MOST SALES?
SELECT MONTH_ID, SUM(SALES) AS REVENUE, COUNT(ORDERNUMBER) AS FREQUENCY
FROM portfolio_project.DBO.sales_data_sample$
WHERE YEAR_ID = 2005 -- (YOU CAN CHANGE THE YEAR HERE)
GROUP BY MONTH_ID
ORDER BY 2 DESC

-- WHICH PRODUCT SELLS THE MOST, IN THE HIGHEST REVENUE GENERATOR MONTH( WHICH IS NOVEMBER)
SELECT PRODUCTLINE, SUM(Sales) as revenue, count(ordernumber) as frequency
FROM portfolio_project.DBO.sales_data_sample$
WHERE YEAR_ID = 2004 and month_id= 11 --(YOU CAN CHANGE THE YEAR HERE) 
group by PRODUCTLINE
order by 2 desc		


-- who is our best customer? ( using RFM model)
drop table if exists #rfm
;with rfm (CUSTOMERNAME, monetary_value, avg_monetary_value, frequency, lastorderdate, max_order_date, RECENCY)    as 
(
	 select  CUSTOMERNAME, 
	sum(sales) as monetary_value, avg(sales) as avg_monetary_value, count(ordernumber) as frequency, 
	max(orderdate) as lastorderdate, (select max(orderdate) 
	from portfolio_project.DBO.sales_data_sample$
	where year_id = 2005) as max_order_date, DATEDIFF(DD, MAX(ORDERDATE),(select max(orderdate) 
	from portfolio_project.DBO.sales_data_sample$
	where year_id = 2005 )) AS RECENCY
	FROM portfolio_project.DBO.sales_data_sample$	
	group by CUSTOMERNAME
),
rfm_calc (CUSTOMERNAME, monetary_value, avg_monetary_value, frequency, lastorderdate, max_order_date, RECENCY, 
rfm_recency, rfm_frequency, rfm_avg_monetary_value) as
(
select *,
	ntile (4) over (order by recency desc) as rfm_recency,
	ntile (4) over (order by frequency) as rfm_frequency,
	ntile (4) over (order by monetary_value) as rfm_avg_monetary_value
from rfm
)
select *, rfm_recency + rfm_frequency + rfm_avg_monetary_value  as rfm_cell_numeric,
cast( rfm_recency as varchar) + cast(rfm_frequency as varchar) + cast(rfm_avg_monetary_value as varchar) as rfm_cell_string
into #rfm
from rfm_calc
order by CUSTOMERNAME asc


select CUSTOMERNAME, rfm_avg_monetary_value, rfm_recency, rfm_frequency,
	case 
	when rfm_cell_string in (111, 112 , 121, 122, 123, 132, 211, 212, 114, 141) then 'lost_customers'  --lost customers
			when rfm_cell_string in (133, 134, 143, 244, 334, 343, 344, 144) then 'slipping away, cannot lose' -- (Big spenders who haven’t purchased lately) slipping away
			when rfm_cell_string in (311, 411, 331) then 'new customers'
			when rfm_cell_string in (222, 223, 233, 322) then 'potential churners'
			when rfm_cell_string in (323, 333,321, 422, 332, 432) then 'active' --(Customers who buy often & recently, but at low price points)
			when rfm_cell_string in (433, 434, 443, 444) then 'loyal'
		end rfm_segment

from #rfm

-- what products are most often sold together?
select distinct ordernumber, stuff(
	(select ',' + PRODUCTCODE
	from portfolio_project.dbo.sales_data_sample$ as p 
	where ORDERNUMBER in 
	( 
	select ORDERNUMBER
	from 
	(
	 select ORDERNUMBER, count(*) as rn
	 from portfolio_project.dbo.sales_data_sample$
	 where status = 'shipped'
	 group by ORDERNUMBER) m
	 where rn =2
	 and p.ORDERNUMBER = s.ORDERNUMBER
	 )
	 for xml path ('')), 
	 1,1, '') as productcodes

from portfolio_project.dbo.sales_data_sample$ as s
order by 2 desc


 --What city has the highest number of sales in a specific country
select city, sum (sales) Revenue
from  portfolio_project.dbo.sales_data_sample$
where country = 'UK'
group by city
order by 2 desc



---What is the best product in United States?
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from  portfolio_project.dbo.sales_data_sample$
where country = 'USA'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc