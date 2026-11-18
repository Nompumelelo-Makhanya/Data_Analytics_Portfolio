create database DataCo_Supply_Chain

/*Data integrity & executive financial summary*/
/*Audit total order line items, unique orders, date range,gross sales,net sales, net profit and net profit margin (%).*/
select count(order_item_id) as total_order_line_items, count(distinct(order_id)) as unique_orders, 
min(order_date_dateorders) as start_date,max(order_date_dateorders) as end_date, 
round(sum(sales),2) as gross_sales, round(sum(sales_per_customer),2) as net_sales,
round(sum(order_profit_per_order),2) as net_profit, 
round((sum(order_profit_per_order) / sum(sales_per_customer))*100,2) as net_profit_margin_percent 
	from raw_supply_chain;	 

/*Shipping Lead-Time Variance by Shipping Mode*/
/*Compare average scheduled shipping days, average actual shipping days, and average delay variance (days) by Shipping Mode*/
select shipping_mode, round(avg(days_for_shipment_scheduled),2) as average_scheduled_shipping_days, round(avg(days_for_shipping_real),2) as average_actual_shipping_days, 
round(avg(days_for_shipping_real - days_for_shipment_scheduled),2) as average_delay_variance_days
	from raw_supply_chain
	group by Shipping_Mode
	order by average_delay_variance_days desc;

/* On-Time Delivery (OTIF) Rate by Shipping Mode */
/* Calculate total order lines, on-time order lines, and On-Time delivery rate (%) across each Shipping Mode. */
select shipping_mode, count(order_id) as total_order_lines, 
count(case when delivery_status 
				in ('Advance Shipping','Shipping on time')
				then 1 end) as on_time_order_lines,
cast(100.0 * count(case when delivery_status in
				('Advance Shipping', 'Shipping on time')
				then 1 end)/ count(order_item_id) as decimal(10,2)) as on_time_delivery_rate_percent
		from raw_supply_chain
		group by Shipping_Mode
		order by on_time_delivery_rate_percent desc;

/*Regional Market Fulfilment & Profit Performance*/
/*Objective: Compare total unique orders, net sales, net profit, profit margin (%), and late delivery rate (%) across each Market.*/
select market,count(distinct order_id) as total_unique_orders, 
cast(sum(sales_per_customer) as decimal(10,2)) as net_sales,
cast(sum(order_profit_per_order) as decimal(10,2)) as net_profit,
cast(100*(sum(order_profit_per_order)/sum(sales_per_customer)) as decimal(10,2)) as profit_margin_percent,
100* sum(late_delivery_risk)/count(distinct order_item_id) as late_delivery_rate_percent
	from raw_supply_chain
	group by market
	order by net_sales desc;

/*Category Profitability & Discount Erosion Analysis*/
/*Compare total units sold, gross sales, total discounts, average discount rate (%), net sales, net profit, and net margin (%) across each Department and Product Category*/
select department_name, category_name, 
sum(Order_Item_Quantity) as total_units_sold, 
cast(sum(sales) as decimal(10,2)) as gross_sales, 
cast(sum(order_item_discount) as decimal(10,2)) as total_discounts, 
cast((avg(order_item_discount_rate)*100) as decimal(10,2)) as avg_discount_rate_percent, 
round(sum(sales_per_customer),2) as net_sales,
round(sum(order_profit_per_order),2) as net_profit, 
cast((sum(order_profit_per_order) / sum(sales_per_customer) *100) as decimal(10,2)) as net_profit_margin_percent 
	from raw_supply_chain
	group by department_name, category_name
	order by net_profit desc;	  
	
/*Top 10 Loss-Making Products (Negative Net Profit Outliers) */
/*Identify the 10 products generating the largest total net losses, showing order lines, units sold, average discount rate (%),net sales, 
and total net loss.*/
select top 10 product_name, 
count(order_id) as order_lines,
sum(order_item_quantity) as units_sold,
cast((avg(order_item_discount_rate)*100) as decimal(10,2)) as avg_discount_rate_percent,
cast(sum(sales_per_customer) as decimal(10,2)) as net_sales,
cast(sum(order_profit_per_order) as decimal(10,2)) as total_net_loss
	from raw_supply_chain
	group by product_name
	having sum(order_profit_per_order) < 0
	order by total_net_loss asc;

/*Order Cancellation & Suspected Fraud Risk by Customer Segment*/
/*Identify total line items, canceled line items, suspected fraud line items, at-risk net sales, and overall failure rate (%)
across each Customer Segment.*/
select customer_segment,
count(order_item_id) as total_line_items,
count(case when delivery_status = 'Shipping canceled' then 1 end) as canceled_line_items,
count(case when order_status = 'Suspected_Fraud' then 1 end) as suspected_fraud_line_items,
cast(sum(case when order_status in ('canceled','suspected_fraud') 
			then sales_per_customer else 0 end) as decimal (10,2)) as at_risk_net_sales,
cast(100.0* count(case when order_status in ('canceled','suspected_fraud') then 1 end)/count(order_item_id) as decimal (10,2)) as overall_failure_rate_percent
	from raw_supply_chain
	group by customer_segment
	order by overall_failure_rate_percent desc;


select * from raw_supply_chain
