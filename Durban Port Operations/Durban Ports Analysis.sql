create database Durban_Port_Operations

/*Data integrity check: Verifying the imported dataset. Return total number of rows, count of distinct call_id values and the earliest anchorage_arrival timestamp*/
select count(*) as total_rows,count(distinct call_id) as unique_call_id, min(anchorage_arrival) as earliest_arrival
	from DBN_PO;

/*Evaluating terminal performance*/
/*Displaying each terminal, cargo type and total number of vessel call, average anchorage waiting time, average turnaround time and total estimated demurrage cost in USD.
Order the results from highest total demurrage cost to lowest*/
select terminal, cargo_type, count(call_id) as total_number_of_vessel_call,round(avg(anchorage_wait_hrs),1) as AVG_anchorage_waiting_time,
round(avg(total_turnaround_hrs),1) as AVG_turnaround_time, round(sum(est_demurrage_USD),2) as total_estimated_demurrage_USD
	from DBN_PO
	group by terminal, cargo_type
	order by total_estimated_demurrage_USD desc;

/*Show only container vessels that incurred more than $15,000 in estimated demurrage. Return the call_id, vessel_name, terminal, delay_reason, total_turnaround_hrs and est_demurrage_usd,
sorted from the highest penalty down*/
select call_id, vessel_name, terminal, delay_reason, total_turnaround_hrs,est_demurrage_usd
	from DBN_PO
	where cargo_type = 'Container' and est_demurrage_usd > 15000
	order by est_demurrage_usd desc;

/*SLA breach rate by terminal*/
/*For each terminal, write a query that calculates: total vessel calls, number of vessels with demurrage_status = 'Breached SLA', number of vessels with demurrage status = 'At Risk'*/
select terminal, count(call_id) as total_vessel_call, sum(case when demurrage_status ='Breached SLA' then 1 else 0 end) as breached_sla_calls, 
sum(case when demurrage_status ='At Risk' then 1 else 0 end) as at_risk_calls 
	from DBN_PO
	group by terminal;

/*Display the SLA breach percentage (breached calls divided by total calls, multiplied by 100 and rounded to 1 decimal place) for each terminal*/
select terminal, round(100 * sum(case when demurrage_status = 'Breached SLA' then 1 else 0 end)/count(call_id),1) as sla_breach_percentage
	from DBN_PO
	group by terminal
	order by sla_breach_percentage desc;

/*Delay root-cause financial impact*/
/*Analyze delayed vessel calls (excluding 'None') by delay reason to identify affected vessel counts, average anchorage wait times,average penalty per vessel, 
and total demurrage cost in USD*/
select delay_reason,count(call_id) as affected_vessels, avg(anchorage_wait_hrs) as AVG_anchorage_wait_hrs,round(avg(est_demurrage_USD),2) as average_penalty, sum(est_demurrage_USD) as
total_demurrage_cost_USD
	from DBN_PO
	where delay_reason <> 'None'
	group by delay_reason
	order by total_demurrage_cost_USD desc;

/*Berth Utilisation Efficiency*/
/*Evaluate total berth stay hours, idle berth hours, and productive berth percentage (active cargo hours vs. total port turnaround time) per terminal, ordered from lowest to highest efficiency*/
select terminal,round(avg(total_turnaround_hrs - anchorage_wait_hrs),1) as total_berth_stay_hrs, round(avg(total_turnaround_hrs - anchorage_wait_hrs - net_cargo_hours),1) as idle_berth_hrs,
round(100.0 * avg(net_cargo_hours)/avg(total_turnaround_hrs),1) as productive_berth_percentage
	from DBN_PO
	group by terminal
	order by productive_berth_percentage asc;

/*Top 3 worst turnaround outliers per terminal*/
/*Identify the top 3 longest total_turnaround_hrs vessel calls for each individual terminal. Display the terminal, the vessel's rank within that terminal, call_id, vessel_name, delay_reason,
total_turnaround_hrs, est_demurrage_usd*/
with RankedVessels as (
select terminal, rank()over (partition by terminal order by total_turnaround_hrs desc) as delay_rank, call_id, vessel_name, delay_reason, total_turnaround_hrs, est_demurrage_usd
	from DBN_PO )

select terminal, delay_rank,call_id,vessel_name, delay_reason, total_turnaround_hrs, est_demurrage_usd
	from RankedVessels
	where delay_rank <= 3
	order by terminal asc, delay_rank asc;
 
/*Viewing DBN_PO table*/
select * from DBN_PO
