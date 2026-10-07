# 🚇 Pune Metro Database & Transit Analytics (MySQL)

A comprehensive relational database model and analytical SQL query suite simulating the Pune Metro transit network (Purple & Aqua Lines). This project models transit operations—including line routes, station sequencing, commuter cards, and tap-in/tap-out trip tracking—and demonstrates advanced SQL querying techniques to extract ridership, route, and revenue insights.

---

## 📌 Project Architecture

The database schema (`punemetrodb`) enforces relational integrity using foreign keys, check constraints, and unique indexes across six tables:

- **`metrolines`**: Stores metro corridor lines, color codes, terminal points, and operational statuses.
- **`stations`**: Catalogs stations, elevation types (Elevated vs. Underground), and interchange indicators.
- **`routestations`**: Maps the sequence of stops and cumulative track distance (`distancefromoriginkm`) along each line.
- **`commuters`**: Maintains commuter demographic and registration records.
- **`metrocards`**: Tracks smart card credentials (Maha Metro Card, Pune One Card, Student Pass), live balances, and card statuses.
- **`trips`**: Logs commuter journey logs, entry/exit timestamps, station IDs, and calculated fares.

---

## 📊 Key Analytical Queries Implemented

The project contains analytical SQL scripts designed to answer critical transit operations questions:

1. **Revenue and Ridership by Line**: Joins route topologies with trip logs to evaluate line-level performance, passenger volume, and average fare yield.
2. **Commuter Spend Analysis**: Aggregates lifetime transit expenditure per commuter across registered cards.
3. **Trip-Level vs. Global Network Metrics**: Leverages inline window functions (`SUM() OVER`, `AVG() OVER`, and overall revenue share `%`) to benchmark individual trips against broader system performance without row collapse.
4. **Above-Average Revenue Corridors**: Uses nested subqueries and `HAVING` filters to isolate metro corridors outperforming system-wide revenue averages.
5. **Tiered Card Spend Ranking**: Employs Common Table Expressions (CTEs) along with `RANK()` and `DENSE_RANK()` partitioned across smart card types.
6. **Cumulative Spend & Moving Averages**: Computes running spend totals and 2-trip moving averages per card using frame specifications (`ROWS BETWEEN ...`).
7. **Card Category Financial Metrics**: Aggregates vault balances, active adoption rates, and card issuance distributions across pass types.
8. **Station-to-Station Hop Distances**: Uses the `LEAD()` analytical function over sequential route data to calculate inter-station track distances dynamically.
9. **Commuter Transit Profiles**: Uses correlated subqueries and `GROUP_CONCAT()` to generate unified passenger dossiers showing trip volume, total spend, and corridors traversed.

---

## 🛠️ Tech Stack & Concepts

- **RDBMS**: MySQL 8.0+
- **Database Concepts**: Primary/Foreign Keys, Cascade Deletes, CHECK Constraints, Composite Unique Keys
- **SQL Techniques**:
  - Complex multi-table inner and outer joins (`JOIN`, `LEFT JOIN`)
  - Common Table Expressions (CTEs)
  - Window Functions (`LEAD`, `RANK`, `DENSE_RANK`, `SUM() OVER`, `AVG() OVER`, Sliding Frames)
  - String aggregation (`GROUP_CONCAT`)
  - Correlated and scalar subqueries

---

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-username/pune-metro-sql-analytics.git](https://github.com/your-username/pune-metro-sql-analytics.git)
   cd pune-metro-sql-analytics
