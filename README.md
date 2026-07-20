# Sales Data Analysis with SQL Server & Power BI

## Overview

This project demonstrates an end-to-end sales analysis workflow using **SQL Server** and **Power BI**. SQL Server was used for data exploration, data quality validation, KPI calculation, customer segmentation, and advanced analytical queries, while Power BI was used to build an interactive dashboard for business reporting.

The analysis is based on a Star Schema data warehouse consisting of one fact table and multiple dimension tables.

## Technologies

- SQL Server
- T-SQL
- Power BI
- Excel

## Data Model

- **Fact Table**
  - `gold.fact_sales`

- **Dimension Tables**
  - `gold.dim_customers`
  - `gold.dim_products`

## Analysis Performed

- Data quality validation
- KPI calculation
- Exploratory Data Analysis (EDA)
- Sales trend analysis
- Customer segmentation
- Age group analysis
- Gender distribution by country
- Product performance analysis
- Time-series analysis using monthly and yearly sales

## Dashboard

The Power BI dashboard includes:

- Sales KPIs
- Monthly & yearly sales trends
- Customer segmentation
- Product performance
- Customer demographics
- Interactive filters and visualizations

## Repository Structure

```text
Sales-Data-Analysis/
│
├── SQL Scripts/
├── Power BI Dashboard/
├── Dataset/
├── Images/
└── README.md
```

## Skills Demonstrated

- SQL Querying
- Data Analysis
- Data Quality
- KPI Development
- Window Functions
- Customer Segmentation
- Time-Series Analysis
- Data Visualization
- Power BI Dashboard Development
