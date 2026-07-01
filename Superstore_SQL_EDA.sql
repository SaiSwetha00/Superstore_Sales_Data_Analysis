-- ============================================================
--  SUPERSTORE SALES — SQL EDA ANALYSIS
--  Database: superstore_db  |  Table: sales
--  Tool: PostgreSQL / MySQL / SQLite compatible
-- ============================================================

-- ── TABLE SETUP ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS sales (
    row_id          INTEGER,
    order_id        VARCHAR(20),
    order_date      DATE,
    ship_date       DATE,
    ship_mode       VARCHAR(30),
    customer_id     VARCHAR(20),
    customer_name   VARCHAR(50),
    segment         VARCHAR(20),
    city            VARCHAR(50),
    state           VARCHAR(50),
    region          VARCHAR(20),
    product_id      VARCHAR(30),
    category        VARCHAR(30),
    sub_category    VARCHAR(30),
    product_name    VARCHAR(100),
    sales           DECIMAL(10,2),
    quantity        INTEGER,
    discount        DECIMAL(4,2),
    profit          DECIMAL(10,2)
);

-- ============================================================
-- SECTION 1: DATA OVERVIEW
-- ============================================================

-- 1.1 Total record count
SELECT COUNT(*) AS total_records FROM sales;

-- 1.2 Date range of data
SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS date_span_days
FROM sales;

-- 1.3 Count of unique values per column
SELECT
    COUNT(DISTINCT order_id)       AS unique_orders,
    COUNT(DISTINCT customer_id)    AS unique_customers,
    COUNT(DISTINCT product_id)     AS unique_products,
    COUNT(DISTINCT region)         AS unique_regions,
    COUNT(DISTINCT category)       AS unique_categories,
    COUNT(DISTINCT sub_category)   AS unique_sub_categories,
    COUNT(DISTINCT state)          AS unique_states
FROM sales;

-- 1.4 Check for null values in key columns
SELECT
    SUM(CASE WHEN order_date   IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN sales        IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN profit       IS NULL THEN 1 ELSE 0 END) AS null_profit,
    SUM(CASE WHEN customer_id  IS NULL THEN 1 ELSE 0 END) AS null_customer_id
FROM sales;

-- ============================================================
-- SECTION 2: SALES ANALYSIS
-- ============================================================

-- 2.1 Overall KPIs
SELECT
    ROUND(SUM(sales), 2)                          AS total_sales,
    ROUND(SUM(profit), 2)                         AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)      AS profit_margin_pct,
    COUNT(DISTINCT order_id)                       AS total_orders,
    ROUND(AVG(sales), 2)                           AS avg_order_value,
    ROUND(SUM(quantity), 0)                        AS total_units_sold
FROM sales;

-- 2.2 Sales by year
SELECT
    YEAR(order_date)           AS year,
    ROUND(SUM(sales), 2)       AS total_sales,
    ROUND(SUM(profit), 2)      AS total_profit,
    COUNT(DISTINCT order_id)   AS total_orders,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS margin_pct
FROM sales
GROUP BY YEAR(order_date)
ORDER BY year;

-- 2.3 Monthly sales trend
SELECT
    YEAR(order_date)   AS year,
    MONTH(order_date)  AS month,
    ROUND(SUM(sales),2) AS monthly_sales,
    ROUND(SUM(profit),2) AS monthly_profit
FROM sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

-- 2.4 Sales by quarter
SELECT
    YEAR(order_date) AS year,
    CONCAT('Q', QUARTER(order_date)) AS quarter,
    ROUND(SUM(sales),2) AS sales,
    ROUND(SUM(profit),2) AS profit
FROM sales
GROUP BY year, quarter
ORDER BY year, quarter;

-- 2.5 Year-over-year growth (using subquery)
SELECT
    curr.year,
    curr.total_sales,
    prev.total_sales AS prev_year_sales,
    ROUND((curr.total_sales - prev.total_sales) / prev.total_sales * 100, 2) AS yoy_growth_pct
FROM (
    SELECT YEAR(order_date) AS year, ROUND(SUM(sales),2) AS total_sales
    FROM sales GROUP BY YEAR(order_date)
) curr
LEFT JOIN (
    SELECT YEAR(order_date) AS year, ROUND(SUM(sales),2) AS total_sales
    FROM sales GROUP BY YEAR(order_date)
) prev ON curr.year = prev.year + 1
ORDER BY curr.year;

-- ============================================================
-- SECTION 3: REGIONAL ANALYSIS
-- ============================================================

-- 3.1 Sales and profit by region
SELECT
    region,
    ROUND(SUM(sales),2)       AS total_sales,
    ROUND(SUM(profit),2)      AS total_profit,
    COUNT(DISTINCT order_id)  AS orders,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_pct,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM sales
GROUP BY region
ORDER BY total_profit DESC;

-- 3.2 Top 10 states by sales
SELECT
    state, region,
    ROUND(SUM(sales),2)  AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM sales
GROUP BY state, region
ORDER BY total_sales DESC
LIMIT 10;

-- 3.3 Bottom 5 states by profit (loss-making)
SELECT
    state,
    ROUND(SUM(profit),2) AS total_profit,
    COUNT(*) AS orders
FROM sales
GROUP BY state
ORDER BY total_profit ASC
LIMIT 5;

-- ============================================================
-- SECTION 4: CATEGORY ANALYSIS
-- ============================================================

-- 4.1 Sales by category
SELECT
    category,
    ROUND(SUM(sales),2)       AS total_sales,
    ROUND(SUM(profit),2)      AS total_profit,
    COUNT(*) AS transactions,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_pct
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

-- 4.2 Sub-category performance — top profitable
SELECT
    category, sub_category,
    ROUND(SUM(sales),2)  AS sales,
    ROUND(SUM(profit),2) AS profit,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_pct
FROM sales
GROUP BY category, sub_category
ORDER BY profit DESC;

-- 4.3 Sub-categories with negative profit (loss-making)
SELECT
    sub_category,
    ROUND(SUM(profit),2) AS total_profit,
    COUNT(*) AS orders
FROM sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- ============================================================
-- SECTION 5: CUSTOMER SEGMENT ANALYSIS
-- ============================================================

-- 5.1 Sales by customer segment
SELECT
    segment,
    ROUND(SUM(sales),2)                          AS total_sales,
    ROUND(SUM(profit),2)                         AS total_profit,
    COUNT(DISTINCT customer_id)                   AS unique_customers,
    COUNT(DISTINCT order_id)                      AS total_orders,
    ROUND(AVG(sales),2)                           AS avg_order_value,
    ROUND(SUM(profit)/SUM(sales)*100,2)           AS margin_pct,
    ROUND(AVG(discount)*100,1)                    AS avg_discount_pct
FROM sales
GROUP BY segment
ORDER BY total_sales DESC;

-- 5.2 Top 10 customers by revenue
SELECT
    customer_id, customer_name, segment,
    ROUND(SUM(sales),2)  AS lifetime_sales,
    ROUND(SUM(profit),2) AS lifetime_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales
GROUP BY customer_id, customer_name, segment
ORDER BY lifetime_sales DESC
LIMIT 10;

-- ============================================================
-- SECTION 6: DISCOUNT IMPACT ANALYSIS
-- ============================================================

-- 6.1 Average profit by discount band
SELECT
    CASE
        WHEN discount = 0    THEN '0% - No discount'
        WHEN discount = 0.1  THEN '10%'
        WHEN discount = 0.2  THEN '20%'
        WHEN discount = 0.3  THEN '30%'
        WHEN discount = 0.4  THEN '40%'
        WHEN discount >= 0.5 THEN '50%+'
    END AS discount_band,
    COUNT(*)                       AS orders,
    ROUND(AVG(profit),2)           AS avg_profit,
    ROUND(AVG(sales),2)            AS avg_sales,
    ROUND(SUM(profit)/SUM(sales)*100,2) AS margin_pct
FROM sales
GROUP BY discount_band
ORDER BY discount;

-- 6.2 Profitability at high discounts
SELECT
    COUNT(*) AS orders_with_40pct_plus_discount,
    ROUND(SUM(sales),2)  AS sales_lost_value,
    ROUND(SUM(profit),2) AS total_loss,
    ROUND(AVG(profit),2) AS avg_profit_per_order
FROM sales
WHERE discount >= 0.4;

-- ============================================================
-- SECTION 7: SHIPPING ANALYSIS
-- ============================================================

-- 7.1 Orders and revenue by ship mode
SELECT
    ship_mode,
    COUNT(*)               AS orders,
    ROUND(SUM(sales),2)    AS total_sales,
    ROUND(AVG(DATEDIFF(ship_date, order_date)),1) AS avg_days_to_ship
FROM sales
GROUP BY ship_mode
ORDER BY total_sales DESC;

-- ============================================================
-- SECTION 8: ADVANCED QUERIES
-- ============================================================

-- 8.1 Running total of sales by month (window function)
SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    ROUND(SUM(sales),2) AS monthly_sales,
    ROUND(SUM(SUM(sales)) OVER (
        PARTITION BY YEAR(order_date)
        ORDER BY MONTH(order_date)
    ),2) AS running_total_sales
FROM sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

-- 8.2 Rank sub-categories by profit within each category
SELECT
    category, sub_category,
    ROUND(SUM(profit),2) AS total_profit,
    RANK() OVER (PARTITION BY category ORDER BY SUM(profit) DESC) AS rank_in_category
FROM sales
GROUP BY category, sub_category
ORDER BY category, rank_in_category;

-- 8.3 Customer order frequency and value segmentation
SELECT
    customer_id, customer_name,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(SUM(sales),2) AS total_sales,
    CASE
        WHEN COUNT(DISTINCT order_id) >= 10 THEN 'High Frequency'
        WHEN COUNT(DISTINCT order_id) >= 5  THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_segment,
    CASE
        WHEN SUM(sales) >= 10000 THEN 'High Value'
        WHEN SUM(sales) >= 3000  THEN 'Medium Value'
        ELSE 'Low Value'
    END AS value_segment
FROM sales
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC;

-- 8.4 Month-over-month growth rate
SELECT
    curr.year, curr.month,
    curr.monthly_sales,
    ROUND((curr.monthly_sales - prev.monthly_sales)/prev.monthly_sales*100, 2) AS mom_growth_pct
FROM (
    SELECT YEAR(order_date) AS year, MONTH(order_date) AS month,
           ROUND(SUM(sales),2) AS monthly_sales
    FROM sales GROUP BY YEAR(order_date), MONTH(order_date)
) curr
LEFT JOIN (
    SELECT YEAR(order_date) AS year, MONTH(order_date) AS month,
           ROUND(SUM(sales),2) AS monthly_sales
    FROM sales GROUP BY YEAR(order_date), MONTH(order_date)
) prev ON (curr.year = prev.year AND curr.month = prev.month + 1)
       OR (curr.year = prev.year + 1 AND curr.month = 1 AND prev.month = 12)
ORDER BY curr.year, curr.month;

-- ============================================================
-- END OF EDA SQL FILE
-- ============================================================
