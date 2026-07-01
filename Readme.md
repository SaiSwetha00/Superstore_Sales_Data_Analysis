# 🛒 Superstore Sales Analytics Dashboard

> End-to-end data analytics project covering data cleaning, SQL EDA, Python analysis, interactive dashboard, and Excel reporting — built on the Sample Superstore dataset.

---

## 📌 Project Overview

This project analyzes **9,994 retail sales transactions** from a US-based superstore covering **2021–2024**. The goal is to uncover revenue drivers, identify loss-making areas, and present findings through a professional interactive dashboard — exactly the kind of end-to-end workflow expected in a real business analyst role.

---

## 🎯 Business Questions Answered

- Which regions and categories generate the most profit?
- How do discounts impact profit margins?
- Which sub-categories are loss-making?
- What is the year-over-year sales growth trend?
- Which customer segments drive the most revenue?
- What is the monthly sales and profit trend over 4 years?

---

## 📁 Project Structure

```
superstore-sales-analytics/
│
├── data/
│   ├── 01_Superstore_Raw_Dataset.csv          # Original raw dataset
│   └── 02_Superstore_Cleaned_Dataset.csv      # Cleaned + feature-engineered dataset
│
├── sql/
│   └── 03_Superstore_SQL_EDA.sql              # Full SQL EDA with 8 sections
│
├── python/
│   └── Superstore_Data_Cleaning_Script.py     # Python cleaning script (pandas)
│
├── dashboard/
│   └── superstore_dashboard_light.html        # Interactive HTML dashboard
│
├── excel/
│   └── Superstore_Excel_Dashboard.xlsx        # 7-sheet Excel dashboard with charts
│
└── README.md
```

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Python** | Data cleaning, feature engineering, analysis |
| **pandas** | DataFrame operations, groupby, filtering |
| **matplotlib** | Charts and visualizations |
| **SQL** | Exploratory data analysis, window functions |
| **Excel** | Dashboard with pivot-style tables and charts |
| **HTML / CSS / JavaScript** | Interactive dashboard UI |
| **Chart.js** | Line, bar, donut, scatter charts in browser |
| **GitHub** | Version control and project hosting |

---

## 🔍 Data Cleaning Steps

Performed in `Superstore_Data_Cleaning_Script.py`:

1. Loaded raw CSV with correct encoding (`latin1`)
2. Removed duplicate rows
3. Converted `Order Date` and `Ship Date` to datetime format
4. Dropped rows with missing `Sales` or `Profit` values
5. Filled missing categorical values with `'Unknown'`
6. Standardized text columns (`.str.strip().str.title()`)
7. Removed rows with zero or negative `Sales` and `Quantity`
8. Engineered 10 new columns (Year, Quarter, Profit Margin %, Margin Band, etc.)
9. Reset index and exported cleaned CSV

---

## 📊 SQL EDA — Sections Covered

File: `03_Superstore_SQL_EDA.sql`

| Section | Queries |
|---|---|
| 1. Data Overview | Record count, date range, unique values, null check |
| 2. Sales Analysis | KPIs, yearly sales, monthly trend, quarterly breakdown, YoY growth |
| 3. Regional Analysis | Sales by region, top 10 states, bottom 5 states by profit |
| 4. Category Analysis | Category sales, sub-category performance, loss-making sub-categories |
| 5. Customer Segments | Segment revenue, top 10 customers by lifetime value |
| 6. Discount Impact | Profit by discount band, high-discount order analysis |
| 7. Shipping Analysis | Revenue and delivery time by ship mode |
| 8. Advanced Queries | Window functions: RANK(), running totals, MoM growth, customer segmentation |

---

## 📈 Key Business Insights

**1. Discount Impact — Most Critical Finding**
> Orders with discounts of **40% or above** result in **negative average profit** per order. High discounting in the Furniture category is the primary driver of losses.

**2. Technology is the Most Profitable Category**
> Technology generates the highest profit margin despite not being the highest in sales volume. Copiers is the single best-performing sub-category.

**3. West Region Leads in Profit**
> The West region consistently outperforms other regions in both sales and profit across all four years.

**4. Office Supplies Has the Best Margin**
> Office Supplies achieves the highest profit margin percentage of all three categories despite lower average order values.

**5. Consumer Segment Drives the Most Revenue**
> The Consumer segment accounts for the largest share of total sales, followed by Corporate and Home Office.

---

## 🖥️ Interactive Dashboard

The HTML dashboard (`superstore_Sales_dashboard.html`) replicates a Power BI-style enterprise dashboard built entirely in HTML, CSS, and JavaScript with Chart.js. It includes:

- **KPI cards** with YoY growth indicators and sparklines
- **5 report pages** — Executive Overview, Sales Analysis, Profit Analysis, Customer Analysis, Product Analysis
- **Live slicers** — Year, Region, Category, Segment (all synced across pages)
- **Rich tooltips** — hover any visual to see Sales, Profit, Orders, Margin, Avg Discount
- **Conditional formatting** — green = profit, red = loss, orange = low margin
- **Dynamic report title** — updates based on selected filters
- **Discount scatter chart** — individual order-level discount vs profit visualization

> 💡 **No installation required.** Open the `.html` file in any browser to use it.

---

## 📋 Excel Dashboard — Sheets

File: `Superstore_Excel_Dashboard.xlsx`

| Sheet | Contents |
|---|---|
| 1. Dashboard | 8 KPI cards with calculated metrics |
| 2. Regional Analysis | Sales/profit/margin by region + bar chart |
| 3. Category Analysis | Category and sub-category breakdown + donut chart |
| 4. Discount Impact | Discount band analysis + key insight callout + chart |
| 5. Customer Segments | Segment performance + chart |
| 6. Monthly Trend | Month-by-month sales and profit + line chart |
| 7. Raw Data | Filterable data table with conditional formatting |

---

## 🚀 How to Run

### Python Cleaning Script
```bash
# Install dependency
pip install pandas

# Place raw CSV in the same folder, then run:
python Superstore_Data_Cleaning_Script.py
```

### SQL EDA
```sql
-- Works in MySQL, PostgreSQL, or SQLite
-- Step 1: Create the sales table using the CREATE TABLE at top of the file
-- Step 2: Import Superstore_Raw_Dataset.csv into the table
-- Step 3: Run any section of queries
```

### Interactive Dashboard
```
Open superstore_Sales_dashboard.html in any modern browser.
No server, no installation, no login required.
```

---

## 💡 Skills Demonstrated

`Python` `pandas` `Data Cleaning` `Feature Engineering` `SQL` `Window Functions`
`Exploratory Data Analysis` `Excel` `Pivot Tables` `Chart.js` `HTML` `CSS` `JavaScript`
`Data Visualization` `KPI Design` `Dashboard Development` `Business Intelligence`
`Data Storytelling` `Conditional Formatting` `GitHub`

---

## 📬 Contact

**[Sai Swetha Etikala]**
📧 [saiswethaetikala08@gmail.com]
🔗 [https://www.linkedin.com/in/saiswethaetikala]

---

## ⭐ If you found this project helpful, please give it a star!

---

*Built as a portfolio project to demonstrate end-to-end data analytics skills — from raw data to interactive business dashboard.*
