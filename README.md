# SQL Server Data Warehouse

This repository contains a SQL Server–based Data Warehouse built using the Medallion Architecture.
Data is sourced from CRM and ERP CSV files and transformed into analytics-ready datasets for reporting and business analysis.

Primary Consumers (Gold Layer):

- Data Analysts
- Business Users

**BRONZE LAYER**

Definition:

Stores raw, unprocessed data directly from CRM and ERP CSV files.

Objective:

- Data traceability
- Debugging and auditing

Details:

- Object Type: Tables
- Load Method: Full Load (Truncate & Insert)
- Transformations: None
- Data Modeling: None (as-is)

****SILVER LAYER****

Definition: Contains cleaned and standardized data prepared for analysis.

Objective:

- Prepare data for analytics
- Act as an intermediate transformation layer

Details:

- Object Type: Tables
- Load Method: Full Load (Truncate & Insert)
- Transformations: Data cleaning, Standardization, Normalization, Derived columns & Data enrichment
- Data Modeling: None

****GOLD LAYER****

Definition: Business-ready data optimized for reporting and analytics.

Objective: Enable dashboards, reports, and KPI analysis

Details:

- Object Type: Views
- Load Method: Not applicable
- Transformations: CRM & ERP data integration, Aggregations & Business rules and logic
- Data Modeling: Star schema, Aggregated objects, Flat reporting tables
