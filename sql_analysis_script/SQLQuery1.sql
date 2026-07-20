/*
Project: Sales Data Analysis
Tools: SQL Server, Power BI
Focus:
- Data Quality Checks
- KPI Calculation
- Customer & Product Analysis
- Time Series Analysis
*/




USE DataWarehouseAnalytics;
GO

--  1. SCHEMA & DATA UNDERSTANDING

-- table structure (dim_customers)
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'
  AND TABLE_NAME = 'dim_customers';

-- table structure (fact_sales)
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'
  AND TABLE_NAME = 'fact_sales';

-- table structure (dim_products)
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'gold'
  AND TABLE_NAME = 'dim_products';


--  2. DATA QUALITY AND KPI

-- for dim_customers
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN country IS NULL OR country = 'n/a' THEN 1 ELSE 0 END) AS missing_country,
    SUM(CASE WHEN gender IS NULL OR gender = 'n/a' THEN 1 ELSE 0 END) AS missing_gender,
    SUM(CASE WHEN birthdate IS NULL THEN 1 ELSE 0 END) AS missing_birthdate,
    SUM(CASE WHEN country IS NULL OR country = 'n/a' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS missing_country_pct
FROM gold.dim_customers;

-- for fact_sales
SELECT 
    SUM(CASE WHEN order_number IS NULL THEN 1 ELSE 0 END) AS missing_order_number,
    SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END) AS missing_customer_key,
    SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END) AS missing_product_key,
    COUNT(order_number) AS total_transactions,
    SUM(ISNULL(sales_amount,0)) AS total_sales_amount,
    SUM(ISNULL(quantity,0)) AS total_quantity,
    AVG(price) AS average_price
FROM gold.fact_sales;

-- for dim_products
SELECT 
    SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END) AS missing_product_key,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN product_number IS NULL OR product_number = '' THEN 1 ELSE 0 END) AS missing_product_number,
    SUM(CASE WHEN product_name IS NULL OR product_name = '' THEN 1 ELSE 0 END) AS missing_product_name,
    COUNT(product_key) AS total_products,
    AVG(cost) AS average_cost
FROM gold.dim_products;


--  3. EXPLORATORY ANALYSIS

-- total orders per year
SELECT YEAR(order_date) AS orders_per_year,
       COUNT(YEAR(order_date))
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- total sales amount per year
SELECT YEAR(order_date) AS sales_per_year,
       SUM(sales_amount) AS total_sales_amount 
FROM gold.fact_sales
WHERE YEAR(order_date) IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- customer purchase frequency (joining with : dim_customers and fact_sales table)
WITH customer_purchases AS (
    SELECT 
        c.customer_key,
        COUNT(fs.order_number) AS purchase_count
    FROM gold.fact_sales AS fs
    INNER JOIN gold.dim_customers AS c
        ON c.customer_key = fs.customer_key
    GROUP BY c.customer_key
)
SELECT 
    cp.customer_key,
    RANK() OVER (ORDER BY cp.purchase_count DESC) AS purchase_rank    
FROM customer_purchases AS cp
ORDER BY purchase_rank;

-- highest 10 selling products analysis (joining with : dim_products and fact_sales table)
SELECT TOP 10
    p.product_name,
    SUM(fs.quantity * fs.sales_amount) AS total_sales_amount
FROM gold.dim_products AS p
INNER JOIN gold.fact_sales AS fs
    ON p.product_key = fs.product_key
GROUP BY 
    p.product_key,
    p.product_name
ORDER BY total_sales_amount DESC;

-- distinct product categories
SELECT DISTINCT 
    CASE WHEN category IS NULL THEN 'Unknown' ELSE category END AS category
FROM gold.dim_products;


--  4. SALES TREND PER MONTH (aggregation for visualization: line chart)
SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales_amount,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);


--  5. CUSTOMER SEGMENTATION BY PURCHASE FREQUENCY (pie chart or bar chart)
WITH customer_order_count AS (
    SELECT 
        customer_key,
        COUNT(DISTINCT order_number) AS total_orders
    FROM gold.fact_sales
    GROUP BY customer_key
)
SELECT 
    CASE 
        WHEN total_orders = 1 THEN 'One-time Buyers'
        WHEN total_orders BETWEEN 2 AND 5 THEN 'Repeat Buyers'
        ELSE 'High-frequency Buyers'
    END AS customer_segment,
    COUNT(*) AS customer_count
FROM customer_order_count
GROUP BY 
    CASE 
        WHEN total_orders = 1 THEN 'One-time Buyers'
        WHEN total_orders BETWEEN 2 AND 5 THEN 'Repeat Buyers'
        ELSE 'High-frequency Buyers'
    END
ORDER BY customer_segment;


--  6. AGE CALCULATION & DISTRIBUTION (dim_customers)
WITH cte_age AS (
    SELECT 
        DATEDIFF(YEAR, birthdate, GETDATE())
        - CASE 
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, birthdate, GETDATE()), birthdate) > GETDATE()
            THEN 1 ELSE 0
          END AS customer_age
    FROM gold.dim_customers
    WHERE birthdate IS NOT NULL
)
SELECT 
    customer_age,
    COUNT(*) AS customer_count
FROM cte_age
WHERE customer_age BETWEEN 0 AND 100
GROUP BY customer_age
ORDER BY customer_age;


--  7. AGE GROUP SEGMENTATION (FOR VISUALIZATION)
SELECT 
    CASE 
        WHEN age IS NULL THEN 'Unknown'
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS customer_count
FROM (
    SELECT 
        DATEDIFF(YEAR, birthdate, GETDATE())
        - CASE 
            WHEN DATEADD(YEAR, DATEDIFF(YEAR, birthdate, GETDATE()), birthdate) > GETDATE()
            THEN 1 ELSE 0
          END AS age
    FROM gold.dim_customers
) AS derived_age
GROUP BY 
    CASE 
        WHEN age IS NULL THEN 'Unknown'
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END
ORDER BY customer_count DESC;


--  8. GENDER DISTRIBUTION RANKED BY COUNTRY
WITH gender_country_counts AS (
    SELECT 
        CASE 
            WHEN country IS NULL OR country = 'n/a' THEN 'Unknown'
            ELSE country
        END AS country,
        CASE
            WHEN gender IS NULL OR gender = 'n/a' THEN 'Unknown'
            ELSE gender
        END AS gender,
        COUNT(*) AS customer_count
    FROM gold.dim_customers
    GROUP BY 
        CASE 
            WHEN country IS NULL OR country = 'n/a' THEN 'Unknown'
            ELSE country
        END,
        CASE
            WHEN gender IS NULL OR gender = 'n/a' THEN 'Unknown'
            ELSE gender
        END
)
SELECT 
    country,
    gender,
    customer_count,
    RANK() OVER (PARTITION BY country ORDER BY customer_count DESC) AS rank_per_country
FROM gender_country_counts
ORDER BY country, rank_per_country;
