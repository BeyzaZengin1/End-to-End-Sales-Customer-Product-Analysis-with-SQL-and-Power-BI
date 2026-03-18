# End-to-End-Sales-Customer-Product-Analysis-with-SQL-and-Power-BI

# 📊 Online Retail Analytics | SQL & Power BI Project

## 📌 Project Overview

This project performs an end-to-end analysis of an online retail dataset using SQL, followed by visualization in Power BI.

It covers the full data workflow:
**Data Exploration → Data Quality Assessment → Cleaning → Feature Engineering → Business Analysis → Visualization**

---

## 🎯 Business Objectives

* Understand **sales performance and trends**
* Identify **top-performing products and markets**
* Analyze **customer purchasing behavior**
* Evaluate **return (cancellation) impact**
* Prepare a **clean analytical dataset** for BI reporting

---

## 🛠 Tools & Technologies

* SQL (Advanced Data Analysis & Data Cleaning)
* Power BI (Dashboarding & Visualization)
* Dataset: Online Retail II
* Content:
* Invoice,StockCode,Description,Quantity,InvoiceDate,Price,CustomerID,Country

---

## 📂 Project Structure

* `ECommersAnalysis.sql` → Full SQL workflow (EDA, cleaning, analysis)
* `SalesAnalysisDashboard.pbix` → Interactive dashboard
* `OnlineRetail2.csv` → Dataset
* `README.md` → Documentation

* Views created:
* View_Returns → Cleaned returns dataset
* Clean_Online_Retail → Cleaned sales dataset
* Clean_Online_Retail_Final → Deduplicated, analysis-ready dataset

* SQL techniques used:
* ROW_NUMBER() for deduplication
* IQR method for outlier detection
* CTEs (WITH) for segmentation and calculations
* Window functions (SUM() OVER, PERCENTILE_CONT) for cumulative analysis
---

## 🔍 Data Processing Workflow

### 1. Exploratory Data Analysis (EDA)

* Dataset profiling:

  * Total records, invoices, customers, products
  * Time range analysis,statistical summary
  * Missing value ratios and potential anomalies
  * Outlier detection (Price and Quantity)
  * Initial structure validation

---

### 2. Data Quality Assessment

* Missing value analysis:

* Customer_ID and Description gaps identified
* Null ratio calculation
* Investigation of incomplete records

---

### 3. Data Cleaning Strategy

The dataset contains operational noise and inconsistencies:

#### Removed:

* Cancelled invoices (`Invoice LIKE 'C%'`)
* Zero-price and non-commercial transactions
* Operational records:

  * POSTAGE, AMAZON FEE, Manual adjustments

#### Filtered:

* Extreme outliers using **IQR method**
* Invalid quantity and price ranges
* Price: 0.01 – 8.45
* Quantity: 1 – 23

---

### 4. Outlier Detection

* Statistical profiling (MIN, MAX, AVG, STDEV)
* IQR-based filtering for:

  * Price
  * Quantity

---

### 5. Data Modeling (SQL Views)

Created structured analytical layers:

* `Clean_Online_Retail` → filtered dataset
* `Clean_Online_Retail_Final` → deduplicated dataset
* `View_Returns` → cleaned return transactions
* `View_Sales_Vs_Refund_Trend` → sales vs refund comparison

---

### 6. Data Deduplication

* Applied `ROW_NUMBER()` logic
* Removed duplicate transaction records
* Ensured analytical consistency

---

## 📊 Key Analysis & KPIs

### Core Metrics

* Total Revenue
* Total Invoices
* Total Returned Product
* Returned Rate
* Average Order Value (AOV)
* Unique Customers
* Unique Products
* Country-level performance analysis
* Monthly sales trends and revenue share

---

### Analytical Modules

* 📈 Monthly Sales Trend
* 🌍 Country Performance Analysis
* 🏆 Top Products by Revenue
* 🧮 ABC Product Segmentation
* 🛒 Market Basket Analysis
* 🔁 Repeat Customer Analysis
* 💰 Customer Pareto Analysis
* 🔄 Return / Cancellation Analysis

---

## 📈 Key Business Insights & Recommendations

### 💰 Revenue & Sales

* Revenue is highly concentrated in a small subset of products (**Pareto effect observed**)
* A-segment products generate ~80% of total revenue
* The business is heavily concentrated in the UK market, generating over 85% of total revenue
* International markets show lower transaction volume but higher average order values
* High-value niche markets (e.g., Singapore, Switzerland) indicate strong premium customer segments
* Customer behavior suggests strong repeat purchasing patterns (~4 orders per customer)
* Product catalog is large, indicating potential long-tail distribution in revenue contribution
  
---

### 🛍 Customer Behavior

* Significant portion of customers are **one-time buyers**
* Repeat customers contribute disproportionately to total revenue
* High-value customers dominate revenue distribution
* Repeat customer analysis and purchase frequency
* Top customers by total spending
* Pareto analysis to identify high-value customers

---

### 🌍 Market Insights

* Certain countries generate the majority of revenue
* Basket value varies significantly by region
* Co-purchased products for “Star” items
* Only significant associations considered

---

## 📊 Product & Revenue Insights 

- A small subset of products (A segment) generates ~80% of total revenue, confirming the Pareto principle
- 807 products drive the majority of business value, while 1800+ products contribute only ~5% of revenue
- Top-performing products show both high order frequency and high sales volume, indicating strong product-market fit
- The business follows a long-tail distribution, where a few key products dominate overall performance
 
📊 📈 PRODUCT & ABC ANALYSIS 

🏆 Top Product Performance
📌 Insight

En çok gelir getiren ürünler:

PARTY BUNTING

WHITE HANGING HEART T-LIGHT HOLDER

JUMBO BAG RED RETROSPOT

👉 Bu ürünler:

Hem yüksek sipariş sayısı

Hem yüksek adet satışı

Hem de yüksek revenue üretiyor

💥 Gerçek yorum:

Bu ürünler “core revenue drivers” — yani işin bel kemiği

📌 Behavioral Insight

Bazı ürünlerde:

Quantity yüksek (10K+)

Order count da yüksek

👉 Bu şu demek:

💥

Bu ürünler sadece popüler değil, aynı zamanda frekanslı tekrar satın alınan ürünler

📊 ABC ANALYSIS 
🔥 Ana sonuç:

A segment → %80 revenue (79.99%)

B segment → %15

C segment → %5

👉 Bu tam olarak:

💥 Pareto Principle (80/20 rule)

💎 Revenue Concentration Insight

807 ürün → %80 revenue

1883 ürün → sadece %5 revenue

💥

Ürünlerin büyük çoğunluğu neredeyse hiç değer üretmiyor

⚖️ Product Strategy Insight
📌 Çok kritik çıkarım:

👉 İş modeli:

Few products = high impact

Many products = low impact

💥

Bu klasik long-tail e-commerce structure

🚀 Business Implications (mülakatlık kısım)
1. Inventory Optimization

A segment ürünler:

stokta HER ZAMAN olmalı

C segment:

kaldırılabilir / azaltılabilir

2. Marketing Strategy

Reklam bütçesi:
👉 A segment ürünlere odaklanmalı

3. Cross-Selling Opportunity

A segment ürünler:
👉 bundle / öneri sistemi için ideal
---

### 🔄 Returns Analysis

* Returns are mostly associated with:

* Specific products
* Certain countries
* Refund trends follow sales trends but at a lower magnitude
* Return rate remains relatively controlled but impacts profit margins
* Top returned products by quantity and revenue
* Country-wise return trends
* Monthly sales vs. return trends
* Overall return rate:
* By quantity
* By revenue

---

### ⚠️ Data Quality Insights

* Missing Customer_ID impacts customer-level analysis
* Operational records (postage, fees) can distort revenue if not cleaned
* Outliers significantly affect statistical metrics if not handled

---

## 📷 Dashboard

![Monthly Sales Dashboard](C:\Users\Hp\OneDrive\Masaüstü\DashboardPNG\DashboardFinal1.png)
![Monthly Sales Dashboard](C:\Users\Hp\OneDrive\Masaüstü\DashboardPNG\DashboardFinal2.png)

---

## 🚀 Conclusion

This project demonstrates a **complete real-world data analysis pipeline**, transforming raw transactional data into meaningful business insights.

It highlights:

* Importance of **data cleaning**
* Impact of **outliers and noise**
* Value of **structured analytical layers (views)**
* Practical use of SQL for **business intelligence**

---

## 👨‍💻 Author

* Beyza Zengin
* GitHub: https://github.com/yourusername
