# 📊 Sales Data Analysis Project (SQL Server & Power BI)

##  Project Overview
This project focuses on analyzing sales data using **SQL Server** for data exploration, data quality checks, KPI calculations, and advanced analysis, followed by building an **interactive Power BI dashboard** for visualization and business insights.

The analysis is performed on a star-schema data warehouse containing fact and dimension tables.

---

## 🛠 Tools & Technologies
- **SQL Server** (Data Analysis & Querying)
- **Power BI** (Dashboard & Visualization)
- **Excel** (Source data files)

---

## 🗂 Data Model
The project is based on the following tables:

- `gold.fact_sales`  
  Contains transactional sales data (orders, sales amount, quantity, dates).

- `gold.dim_customers`  
  Contains customer information (demographics, country, gender, birthdate).

- `gold.dim_products`  
  Contains product details (product name, category, cost).

---

## 🔍 Analysis Performed

### 1️⃣ Schema & Data Understanding
- Explored table structures using `INFORMATION_SCHEMA`
- Identified key columns and relationships between fact and dimension tables

---

### 2️⃣ Data Quality Checks & KPIs
- Missing values analysis for:
  - Customer country, gender, and birthdate
  - Order number, customer key, and product key
- Core KPIs calculated:
  - Total transactions
  - Total sales amount
  - Total quantity sold
  - Average price and average product cost

---

### 3️⃣ Exploratory Data Analysis (EDA)
- Total orders per year
- Total sales amount per year
- Customer purchase frequency ranking
- Top 10 best-selling products
- Distinct product categories

---

### 4️⃣ Time Series Analysis
- Monthly sales trend analysis:
  - Total sales amount per month
  - Total orders per month  
- Prepared aggregated data for **line chart visualization** in Power BI

---

### 5️⃣ Customer Segmentation (Behavioral)
Customers were segmented based on purchase frequency:
- **One-time Buyers** (1 order)
- **Repeat Buyers** (2–5 orders)
- **High-frequency Buyers** (6+ orders)

This segmentation helps identify loyal customers and customer retention opportunities.

---

### 6️⃣ Customer Age Analysis
- Accurate age calculation based on birthdate
- Age distribution analysis
- Filtering out invalid ages

---

### 7️⃣ Age Group Segmentation
Customers were grouped into age ranges for visualization:
- Under 18
- 18–25
- 26–35
- 36–45
- 46–60
- 60+
- Unknown

---

### 8️⃣ Gender Distribution by Country
- Gender distribution analysis per country
- Ranking genders within each country using window functions
- Useful for demographic and market analysis

---

## 📈 Power BI Dashboard
After completing the SQL analysis, the cleaned and aggregated data was imported into **Power BI** to build an interactive dashboard including:

- Sales KPIs
- Yearly & monthly sales trends
- Customer segmentation charts
- Product performance analysis
- Demographic insights (age & gender)

📸 *Dashboard screenshots can be found in the `/images` folder.*

---

## 📂 Project Structure
