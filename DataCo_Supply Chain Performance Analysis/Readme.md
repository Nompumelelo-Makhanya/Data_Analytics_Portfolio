# End-to-End Supply Chain & Commercial Performance Analytics (SQL & Power BI)

## 1. Executive Summary & Business Problem
Modern retail, FMCG, and automotive supply chains face a constant balancing act between *fulfilment speed (OTIF), **promotional discounting, and **net profit margins. Using a 3-year operational dataset of **180,519 order line items* across *65,752 unique orders* (January 2015 – January 2018), this project diagnoses systemic delivery bottlenecks, quantifies revenue erosion from discounting and order failures, and provides actionable commercial recommendations.

### Headline KPIs Audited via T-SQL & Power BI
* *Gross Sales:* $36.78M ($36,784,735.01)
* *Total Discounts Granted:* $3.73M (10.14% effective discount rate)
* *Net Sales:* $33.05M ($33,054,402.38)
* *Net Profit & Margin:* $3.97M ($3,966,902.97 | *12.00%* net profit margin)
* *Overall OTIF (On-Time In-Full) Rate:* *40.88%* (73,788 advance and on-time deliveries)
* *At-Risk Net Sales (Cancellations & Suspected Fraud):* *$1.41M* ($1,412,188.62 across 7,754 failed order lines)

---

## 2. Technical Architecture & Workflow
1. *Data Cleaning & Validation:* Audited column completeness, standardised date granularity (Order_Date), and removed duplicate/high-cardinality fields to optimise query execution and BI memory footprint.
2. *Exploratory & Diagnostic Analysis (Microsoft SQL Server / T-SQL):*
   * Authored 6 business-driven T-SQL queries covering executive financial reconciliation, OTIF and lead-time variance by shipping tier, regional market profitability, category discount erosion, loss-making SKU detection (HAVING), and segment-level fraud/cancellation exposure.
3. *Star Schema Modelling & BI Reporting (Power BI & DAX):*
   * Engineered a Dim_Date calendar table (2015-01-01 to 2018-01-31) linked via a one-to-many (1:*) relationship to the fact table.
   * Built *14 custom DAX measures* using CALCULATE, DIVIDE, and DISTINCTCOUNT to guarantee 100% numerical reconciliation between SQL Server and Power BI.
   * Designed an interactive *3-page executive dashboard* (Executive Overview, Logistics & OTIF, and Category & Risk) with cross-page slicers for *Year, **Market, and **Customer Segment*.

---

## 3. Key Analytical Findings & Commercial Recommendations

### A. Logistics & Fulfilment Bottlenecks (OTIF & Lead-Time Variance)
* *Finding:* Overall OTIF sits at *40.88%, driven by an average delay variance of *+0.57 days** (3.50 actual days vs. 2.93 scheduled days).
* *Critical SLA Failure:* *First Class* shipping records a *0.00% OTIF rate—every non-cancelled First Class order misses its **1.0-day* promised SLA because actual fulfilment averages *2.0 days. Meanwhile, **Second Class* averages *3.99 actual days* against a *2.0-day* schedule (*19.36% OTIF), whereas **Standard Class* achieves the highest reliability (*57.66% OTIF*).
* *Systemic Regional Delays:* Late delivery rates sit consistently between *54% and 55%* across all five global markets (Europe, LATAM, Pacific Asia, USCA, and Africa), confirming a network-wide scheduling bottleneck rather than an isolated regional issue.
* *Recommendation:* Re-baseline First Class and Second Class customer-facing SLA commitments to match realistic warehouse dispatch times, and audit carrier handoffs on express tiers to protect customer trust.

### B. Category Profitability & SKU Margin Leaks
* *Finding:* Core categories *Fishing* ($0.76M net profit), *Cleats* ($0.49M), and *Camping & Hiking* ($0.43M) drive the bulk of company profit while maintaining healthy ~12% margins despite ~10% average discounting.
* *Unprofitable SKUs:* SKU-level margin auditing (HAVING SUM(order_profit_per_order) < 0) isolated *3 loss-making products* generating *-$1,390.63* in combined net losses—led by *SOLE E35 Elliptical* (-$965.12 net loss despite $26,409.85 in net sales and an 11.97% average discount).
* *Recommendation:* Cap promotional discounts at *≤ 8%* on high-ticket fitness equipment (SOLE E35/E25 Elliptical and Bushnell Pro X7) or renegotiate supplier cost prices to eliminate negative unit economics.

### C. Order Cancellation & Suspected Fraud Risk
* *Finding:* Cancellations and suspected fraud put *$1.41M* in net sales at risk. *Consumer* and *Home Office* segments tie for the highest order failure rate (*4.37%, ahead of **Corporate* at *4.13%), with **Consumer* representing the largest financial exposure (*$0.75M* at risk).
* *Recommendation:* Implement automated pre-dispatch payment verification and velocity checks on high-value Consumer and Home Office orders to reduce fraud holds without slowing down legitimate fulfilment.

---

## 4. Repository Structure
* supply_chain_analysis.sql — Complete, commented T-SQL script answering all 6 core business questions.
* Supply_Chain_Performance_Dashboard.pbix — Interactive 3-page Power BI report with Dim_Date star schema and 14 DAX measures.
* /screenshots — High-resolution exports of 1. Executive Overview, 2. Logistics & OTIF, and 3. Category & Risk.
<img width="459" height="257" alt="Executive Overview" src="https://github.com/user-attachments/assets/06f631d1-9202-425f-a663-8d56853665d8" />
<img width="463" height="262" alt="Logistics   OTIF" src="https://github.com/user-attachments/assets/fc858eee-7a82-4509-95bb-3a1e431f21da" />
<img width="459" height="257" alt="Category   Risk" src="https://github.com/user-attachments/assets/eb08daf4-6575-44c4-84d3-5e63177c34fd" />



