# End-to-End-Sales-Customer-Product-Analysis-with-SQL-and-Power-BI

# 📊 Online Retail Analytics | SQL & Power BI Project

## 💡 Key Highlights

* Built an end-to-end SQL data pipeline for retail analytics
* Cleaned and transformed raw transactional data using advanced SQL techniques
* Identified key business drivers using Pareto and segmentation analysis
* Designed an interactive Power BI dashboard for decision-making

  
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
  **Dataset Columns:**
* Invoice, StockCode, Description, Quantity, InvoiceDate, Price, CustomerID, Country

---

## 📂 Project Structure

* `ECommersAnalysis.sql` → Full SQL workflow (EDA, cleaning, analysis)
* `SalesAnalysisDashboard.pbix` → Dashboard
* `OnlineRetail2.csv` → Dataset
* `README.md` → Documentation

* Views created:
* View_Returns → Cleaned returns dataset
* Clean_Online_Retail → Cleaned sales dataset
* Clean_Online_Retail_Final → Deduplicated, analysis-ready dataset
* View_Sales_Vs_Refund_Trend → Compared monthly sales trends with return trends

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

* Cancelled invoices (`Invoice LIKE 'C%'`)   ! View_Returns has been created for return analysis.
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
* `Clean_Online_Retail_Final` → filtered deduplicated dataset
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

* Total Revenue: 3,84 M 
* Total Orders: 17 K
* Total Sold Quantity: 2 M
* Total Returned Quantity: 28 K
* Repeat Customer Quantity: 3 K
* Repeat Rate: 0,64%
* Returned Refund Amount: 104.96 K
* Total Customers: 4 K
* Country-level performance analysis
* Monthly sales trends and revenue share
* Compare monthly sales and return trends

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

### 💰 Monthly Trend & Revenue & Sales Insights

* Monthly revenue and invoice volume peak in November, with ~14.8% of total annual revenue.
* September–November period is the strongest sales season, likely due to promotions or seasonal demand.
* Early months (Jan–Mar) and December show lower sales volumes, indicating seasonality.
* The increase in total products sold mirrors invoice growth, confirming higher transaction activity drives revenue peaks.
* Revenue is highly concentrated in a small subset of products (**Pareto effect observed**)
* A-segment products generate ~80% of total revenue
* Customer behavior suggests strong repeat purchasing patterns (~4 orders per customer)
* Product catalog is large, indicating potential long-tail distribution in revenue contribution
  
---

### 🛍 Customer Behavior

* A total of 2,679 customers are repeat buyers, representing a repeat rate of 64%.
* Significant portion of customers are **one-time buyers**
* Repeat customers contribute disproportionately to total revenue
* High-value customers dominate revenue distribution
* Customers place ~4 orders on average


---

### 🌍 Country & Market Insights

* Premium / high-value niche markets:
* Singapore, Switzerland, Lebanon, Channel Islands → low transaction volume but high Average Order Value (AOV), indicating strong premium customer segments.
* International markets show lower transaction volume but higher average order values
* The business is heavily concentrated in the UK market, generating over 85% of total revenue
* High-value niche markets (e.g., Singapore, Switzerland) indicate strong premium customer segments
* Certain countries (UK,Germany,France,EIRE) generate the majority of revenue
* Basket value varies significantly by region


---

## 📊 Product & Revenue Insights 

* A small subset of products (A segment) generates ~80% of total revenue, confirming the Pareto principle.
* Approximately 800 products drive the majority of business value, while over 1,800 products contribute only ~5% of total revenue.
* Top-performing products (e.g., PARTY BUNTING, WHITE HANGING HEART T-LIGHT HOLDER, JUMBO BAG RED RETROSPOT) exhibit both high order frequency and high sales volume.
* This indicates strong product-market fit and consistent customer demand.
* The overall product portfolio follows a long-tail distribution, where a few key products dominate revenue while many contribute marginally.

### 📈 Business Implications

* Inventory should prioritize A-segment products to avoid stock-outs of high-revenue items.
* Marketing efforts should focus on high-performing products to maximize ROI.
* A-segment products are ideal candidates for cross-selling and bundling strategies.



---
# 🛒 Market Basket Analysis

* Identified frequently co-purchased products based on transaction-level data.
* Analysis focused on A-segment (top revenue) products to uncover high-impact associations.
* Only statistically significant product relationships were retained to eliminate noise.
* Results highlight strong cross-selling opportunities between high-performing products. 

 
### 🔄 Returns Analysis Insights

* Returns are concentrated in specific products and countries, indicating potential quality or logistics issues.
* Refund trends follow overall sales patterns but remain at a significantly lower magnitude.
* The overall return rate is relatively controlled, suggesting stable operational performance.
* However, returns still have a measurable impact on total revenue and profit margins.
* Certain products show consistently high return volumes, making them key targets for quality improvement.
* Return behavior varies by country, highlighting differences in customer expectations or delivery conditions.

---

### ⚠️ Data Quality Insights

* Missing Customer_ID values limit the accuracy of customer-level analysis, including segmentation and repeat behavior.
* Operational records (e.g., postage, fees, manual adjustments) can artificially inflate revenue if not properly excluded.
* Outliers in price and quantity significantly distort statistical metrics such as averages and standard deviation.
* Data cleaning and filtering (including IQR-based outlier detection) are essential to ensure reliable and meaningful analysis.


---

## 📷 Dashboard

## 📷 Dashboard Overview

* The dashboard provides a comprehensive and interactive view of the business performance across multiple dimensions:

* Monthly revenue, invoice volume, and sales trends over time
* Revenue share distribution and seasonality patterns
* Country-level performance including total revenue, transaction volume, and average order value (AOV)
* Identification of high-value and niche markets (e.g., high AOV countries)
* Top-performing products based on revenue, quantity sold, and order frequency
* ABC product segmentation highlighting A, B, and C category contributions
* Product-level revenue concentration and long-tail distribution insights
* Customer behavior analysis including repeat customers, one-time buyers, and repeat rate
* Customer value distribution and identification of high-value customers (Pareto analysis)
* Market basket analysis showing frequently co-purchased products and cross-selling opportunities
* Return and cancellation analysis including:
  * Total returned quantity and refund amount
  * Top returned products
  * Country-level return patterns
  * Monthly sales vs. return trend comparison
  * Overall return rate impact on revenue
    
![Monthly Sales Dashboard](https://github.com/BeyzaZengin1/End-to-End-Sales-Customer-Product-Analysis-with-SQL-and-Power-BI/blob/main/DashboardFinal1.png)
![Monthly Sales Dashboard](https://github.com/BeyzaZengin1/End-to-End-Sales-Customer-Product-Analysis-with-SQL-and-Power-BI/blob/main/DashboardFinal2.png)

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
* GitHub: https://github.com/BeyzaZengin1
* Linkedin: www.linkedin.com/in/beyza-zengin-615a2a223
