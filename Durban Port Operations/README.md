# 🚢 Durban Port Operations & Demurrage Analytics

An end-to-end maritime logistics analytics project evaluating vessel turnaround efficiency, anchorage congestion, berth utilisation, and demurrage financial exposure across the **Port of Durban** (*DCT Pier 1, DCT Pier 2, Island View,* and *Maydon Wharf*).

---

## 🎯 Business Problem & Objectives
Port congestion and marine service delays drive extended anchorage waiting times, breached Service Level Agreements (SLAs), and costly daily demurrage penalties. Using a simulated log of **1,000 vessel port calls** (`January – October 2026`), this project answers five core operational questions:
1. **Terminal Performance & Financial Exposure:** How do total vessel calls, average anchorage wait times, turnaround durations, and demurrage costs (USD) compare across terminals?
2. **SLA Compliance & Risk:** What proportion of vessel calls are `On Schedule`, `At Risk`, or `Breached SLA` at each terminal?
3. **Berth Utilisation Efficiency:** How much of a vessel's berth stay is spent on active cargo operations versus non-productive idle time?
4. **Root-Cause Delay Impact:** Which operational bottlenecks (*High Swell/Wind, Tug/Pilot Availability, Crane/Equipment Fault, Documentation/Customs*) drive the highest average penalty and total demurrage cost?
5. **High-Cost & Turnaround Outliers:** Which individual container vessels incurred >\$15,000 in demurrage, and what are the top 3 longest turnaround outliers per terminal?

---

## 🛠️ End-to-End Technical Workflow

### 1. Data Engineering & Simulation (Microsoft Excel)
* Engineered a 1,000-row operational dataset (`Durban_Ports_Operations_Dataset.xlsx`) modelling Durban terminal operations across **Container** (TEU), **Liquid Bulk/Tanker** (MT), and **Bulk Grain & Fertiliser** (MT) cargo.
* Configured terminal-specific SLA turnaround thresholds and daily demurrage rates calibrated to vessel class:
    * **DCT Pier 1 (Container):** 36-hour SLA | \$25,000/day demurrage
    * **DCT Pier 2 (Container):** 42-hour SLA | \$28,000/day demurrage
    * **Island View (Liquid Bulk):** 48-hour SLA | \$22,000/day demurrage
    * **Maydon Wharf (Dry Bulk):** 60-hour SLA | \$16,000/day demurrage

### 2. Data Auditing & Exploratory Analysis (SQL)
Wrote 8 structured SQL queries against the `DBN_PO` table (`sql/durban_port_analysis.sql`) covering:
1. **Data Integrity Verification:** Audited total row count (`1,000`), unique `call_id` count, and earliest `anchorage_arrival` timestamp.
2. **Terminal Performance Benchmarking:** Aggregated vessel calls, average anchorage wait, average turnaround time, and total demurrage (USD) by terminal and cargo type.
3. **High-Penalty Container Filtering:** Isolated container vessels exceeding `\$15,000` in estimated demurrage.
4. **SLA Status Breakdown:** Used conditional `SUM(CASE WHEN ...)` logic to count `Breached SLA` and `At Risk` calls per terminal.
5. **Terminal SLA Breach Rates:** Calculated percentage breach rates across terminals to rank SLA compliance.
6. **Delay Root-Cause Financial Impact:** Evaluated affected call counts, average anchorage wait, average penalty per vessel, and total demurrage across delay drivers (excluding `'None'`).
7. **Berth Utilisation Efficiency:** Calculated average berth stay hours, idle berth hours, and productive berth percentage (`active cargo hours / total berth stay`) per terminal.
8. **Turnaround Outlier Ranking:** Used a Common Table Expression (`CTE`) and `RANK() OVER (PARTITION BY terminal ...)` window function to isolate the top 3 longest turnaround calls at each terminal.

### 3. ETL, Star Schema Modelling & Dashboarding (Power BI)
* **Power Query ETL:** Standardised regional decimal/currency parsing, extracted pure date keys (`Arrival_Date`, `Departure_Date`) from timestamps, and derived `Berth_Idle_Hrs`.
* **Star Schema Data Model:** Linked a custom **`Dim_Date`** calendar table (`1:*` relationship) to the **`Port Call Logs`** fact table and created 11 custom DAX measures.
* **3-Page Interactive Report:** Built synced `Month` and `Terminal` slicers across **Executive Port Overview**, **Terminal & Berth Efficiency**, and **Bottleneck & Delay Analysis**.

---

## 📊 Key Findings & Operational Insights
* **\$12.25M Demurrage Exposure:** Across **1,000 vessel calls**, **69.0% (690 calls)** breached terminal SLA limits, generating **\$12.25M** in estimated demurrage with a port-wide average turnaround of **55.33 hours**.
* **Non-Cargo Delays Consume Nearly Half of Port Time:** Vessels spent an average of **18.83 hours (~34%)** waiting at anchorage and **~11%** idle at berth, leaving only **~55%** of total turnaround time for active cargo operations.
* **Terminal Productivity Benchmarks:** Container terminals averaged **85 TEU/hr** at **DCT Pier 1** vs. **83 TEU/hr** at **DCT Pier 2**. Bulk terminals averaged **950 MT/hr** at **Island View** vs. **924 MT/hr** at **Maydon Wharf**.
* **Primary Delay Drivers:** **High Swell/Wind** (**\$2.56M**, 206 calls) and **Tug/Pilot Availability** (**\$2.42M**, 203 calls) drove the highest demurrage losses, followed closely by **Documentation/Customs** (**\$2.33M**) and **Crane/Equipment Faults** (**\$2.32M**).

---

## 🖼️ Dashboard Previews
* **Page 1 — Executive Port Overview:** `screenshots/01_executive_port_overview.png`
* **Page 2 — Terminal & Berth Efficiency:** `screenshots/02_terminal_berth_efficiency.png`
* **Page 3 — Bottleneck & Delay Analysis:** `screenshots/03_bottleneck_delay_analysis.png`
