--====================================================
--LOADING DATASET
--====================================================
GO
USE OnlineRetail2; 
GO

--====================================================
-- EDA (EXPLORATORY DATA ANALYSIS)
--====================================================

-- Preview top 10 records to understand the dataset structure

SELECT TOP 10 * 
FROM online_retail_II;

-- Basic dataset overview
-- Counting rows, unique invoices, customers, products, and date range

SELECT 
    COUNT(*) AS Total_Rows1,
    COUNT(DISTINCT Invoice) AS Total_Unique_Invoices1,
    COUNT(DISTINCT Customer_ID) AS Total_Unique_Customers1,
    COUNT(DISTINCT StockCode) AS Total_Unique_Products1,
    MIN(InvoiceDate) AS Start_Date1,
    MAX(InvoiceDate) AS End_Date1
FROM online_retail_II;


--====================================================
-- DATA QUALITY CHECK / MISSING VALUES / CANCEL VALUES
--====================================================

-- Count missing values in each column

SELECT 
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN Invoice IS NULL THEN 1 ELSE 0 END) AS Missing_Invoice,
    SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) AS Missing_StockCode,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Missing_Description,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceDate,
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS Missing_Price,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Missing_CustomerID,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Missing_Country
FROM online_retail_II;


-- MISSING VALUE RATIO CALCULATION
-- Calculate missing value percentages for key columns
SELECT 
    COUNT(*) AS Total_Rows,

    -- Customer_ID missing rate
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Missing_CustomerID_Count,
    ROUND(
        CAST(SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 2
    ) AS CustomerID_Null_Percentage,
    
    -- Description missing rate
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Missing_Description_Count,
    ROUND(
        CAST(SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 2
    ) AS Description_Null_Percentage

FROM online_retail_II;


--RECORDS WITH MISSING PRODUCT DESCRIPTIONS
-- Show top 20 records with missing product descriptions

SELECT TOP 20 
    StockCode, 
    Description, 
    Price, 
    Quantity,
    InvoiceDate 
FROM online_retail_II 
WHERE Description IS NULL;


-- RECORDS WITH MISSING CUSTOMER_ID

SELECT TOP 20
    StockCode,
    Description,
    Price,
    Quantity,
    InvoiceDate
FROM online_retail_II
WHERE Customer_ID IS NULL;

--ALL RECORDS WITH MISSING DESCRIPTIONS HAVE A PRICE OF 0 ?

SELECT 
    COUNT(*) AS Total_Null_Rows,
    SUM(CASE WHEN Price = 0 THEN 1 ELSE 0 END) AS Zero_Price,
    SUM(CASE WHEN Price > 0 THEN 1 ELSE 0 END) AS Priced,
    SUM(Quantity) AS Total_Quantity
FROM online_retail_II 
WHERE Description IS NULL;


--RETURN/CANCEL 

--Excluded InvoiceNos starting with 'C' as they represent operational adjustments, not actual returns.
SELECT * FROM online_retail_II
WHERE Invoice LIKE 'C%' 
  AND (Description IN ('AMAZON FEE', 'Adjust bad debt', 'POSTAGE', 'DOTCOM POSTAGE', 'Manual') 
       OR Price = 0);

-- Dropped 'C' records with empty descriptions and zero prices; identified as non-commercial operational logs.

SELECT * FROM online_retail_II
WHERE Invoice LIKE 'C%' 
  AND (Description IS NULL OR Description = '');

--All cancels are negative? / Yes

SELECT * FROM online_retail_II
WHERE Invoice LIKE 'C%' 
  AND Quantity >= 0;

--Identified irrelevant return records and extreme quantity anomalies to clean the noise in the data

SELECT TOP 10 
    Invoice, 
    StockCode, 
    Description, 
    Quantity, 
    InvoiceDate, 
    Customer_ID
FROM online_retail_II
WHERE Invoice LIKE 'C%'
AND Description NOT IN (
      'AMAZON FEE', 
      'Adjust bad debt', 
      'POSTAGE', 
      'DOTCOM POSTAGE', 
      'Manual',
      'Bank Charges',
      'CRUK Commission'
  )
ORDER BY Quantity ASC; 



--====================================================
-- SANITY CHECK & OUTLIER ANALYSIS
--====================================================

-- MAX 10 QUANTITY

SELECT TOP 10 *
FROM online_retail_II
ORDER BY Quantity DESC;

-- MAX 10 PRICE

SELECT TOP 10 *
FROM online_retail_II
ORDER BY Price DESC;

--STATISTICAL SUMMARY

SELECT 
    MIN(Price) AS Min_Price,
    MAX(Price) AS Max_Price,
    AVG(Price) AS Average_Price,
    STDEV(Price) AS Standard_Deviation_Price
FROM online_retail_II;

--====================================================
-- IQR (OUTLIER DETECTION)
--====================================================


-- IQR CALCULATION FOR PRICE

WITH Quartiles AS (
    SELECT 
        PERCENTILE_CONT(0.25) 
        WITHIN GROUP (ORDER BY Price) OVER () AS Q1,

        PERCENTILE_CONT(0.75) 
        WITHIN GROUP (ORDER BY Price) OVER () AS Q3

    FROM online_retail_II
    WHERE Price > 0    -- exclude operational/extreme prices
),

IQR_Calculation AS (
    SELECT DISTINCT
        Q1,
        Q3,
        (Q3 - Q1) AS IQR,
        (Q1 - 1.5 * (Q3 - Q1)) AS Lower_Bound,
        (Q3 + 1.5 * (Q3 - Q1)) AS Upper_Bound
    FROM Quartiles
)

SELECT * FROM IQR_Calculation;


--IQR CALCULATION FOR QUANTITY

WITH Quartiles AS (
    SELECT 
        PERCENTILE_CONT(0.25) 
        WITHIN GROUP (ORDER BY Quantity) OVER () AS Q1,

        PERCENTILE_CONT(0.75) 
        WITHIN GROUP (ORDER BY Quantity) OVER () AS Q3
    FROM online_retail_II
    WHERE Quantity > 0   -- exclude negative/return/cancel quantities
),

IQR_Calc AS (
    SELECT DISTINCT
        Q1,
        Q3,
        (Q3 - Q1) AS IQR,
        (Q1 - 1.5 * (Q3 - Q1)) AS Lower_Bound,
        (Q3 + 1.5 * (Q3 - Q1)) AS Upper_Bound
    FROM Quartiles
)

SELECT *
FROM IQR_Calc;


--====================================================
-- DATA CLEANING & CLEAN VIEW
--====================================================

--Clean view for cancel analysis

GO
CREATE OR ALTER VIEW View_Returns AS
WITH Deduplicated_Returns AS (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY Invoice, StockCode, Quantity, Price, InvoiceDate, Customer_ID ORDER BY Invoice) AS rn
    FROM online_retail_II
    WHERE Invoice LIKE 'C%' 
      AND Quantity BETWEEN -23 AND -1  -- Kept only plausible retail returns by filtering extreme outliers based on the IQR method.
      AND Price > 0
      AND Customer_ID IS NOT NULL
      AND Description NOT IN ('AMAZON FEE', 'Adjust bad debt', 'POSTAGE', 'DOTCOM POSTAGE', 'Manual')
)
SELECT * FROM Deduplicated_Returns WHERE rn = 1;
GO

--Clean Online Retail View
GO
CREATE OR ALTER VIEW Clean_Online_Retail AS
SELECT *
FROM online_retail_II
WHERE Price BETWEEN 0.01 AND 8.45  -- exclude operational/extreme prices
  AND Quantity BETWEEN 1 AND 23   -- exclude negative or wholesale quantities
  AND Description IS NOT NULL
  AND Customer_ID IS NOT NULL
  AND Description NOT IN (     -- These records represent operational entries and do not reflect real sales,
                               -- therefore they were excluded from the Clean_Online_Retail view.
      'AMAZON FEE',
      'Adjust bad debt',
      'POSTAGE',
      'DOTCOM POSTAGE',
      'Manual'
);

GO


--CONTROLLING DUPLICATES

SELECT 
Invoice,
StockCode,
Quantity,
Price,
InvoiceDate,
Customer_ID,
COUNT(*) AS Duplicate_Count
FROM Clean_Online_Retail
GROUP BY 
Invoice,
StockCode,
Quantity,
Price,
InvoiceDate,
Customer_ID
HAVING COUNT(*) > 1



-- FINAL VIEW


GO
ALTER VIEW Clean_Online_Retail_Final AS

WITH Deduplicated AS (

SELECT 
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    Customer_ID,
    Country,
    ROW_NUMBER() OVER(
        PARTITION BY 
            Invoice,
            StockCode,
            Quantity,
            Price,
            InvoiceDate,
            Customer_ID
        ORDER BY Invoice
    ) AS rn

FROM Clean_Online_Retail
)

SELECT
    Invoice,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    Price,
    Customer_ID,
    Country
FROM Deduplicated
WHERE rn = 1;
GO


-- HOW MUCH DATA WE HAVE AFTER VIEW?
-- ALL RECORDS IN VIEW

SELECT COUNT(*) AS Total_View
FROM Clean_Online_Retail_Final;


-- NUMBER AND PERCENTAGE OF RECORDS EXCLUDED FROM THE VIEW

SELECT 
    (SELECT COUNT(*) FROM online_retail_II) 
    - (SELECT COUNT(*) FROM Clean_Online_Retail_Final) AS Rows_Outside_View,
    
    ROUND(
        ((SELECT COUNT(*) FROM online_retail_II) 
        - (SELECT COUNT(*) FROM Clean_Online_Retail_Final)) * 100.0 
        / (SELECT COUNT(*) FROM online_retail_II), 2
    ) AS Rows_Outside_View_Percentage;


--CHECKING STATISTICAL SUMMARY ON CLEAN DATA

SELECT 
    MIN(Price) AS Min_Price,
    MAX(Price) AS Max_Price,
    AVG(Price) AS Average_Price,
    STDEV(Price) AS Standard_Deviation_Price
FROM Clean_Online_Retail_Final;



--====================================================
---ANALYSIS PART
--====================================================


--====================================================
--KPI'S
--====================================================
SELECT 
    COUNT(DISTINCT Invoice) AS Total_Unique_Invoices, 
	COUNT(DISTINCT Customer_ID) AS Total_Unique_Customers,
	COUNT(DISTINCT StockCode) AS Total_Unique_Products,
    SUM(Quantity * Price) AS Total_Revenue, 
    SUM(Quantity * Price) / COUNT(DISTINCT Invoice) AS AOV 
FROM Clean_Online_Retail_Final;


--====================================================
-- MONTHLY SALES TREND
--====================================================
SELECT 
    YEAR(InvoiceDate) AS Year_,
    MONTH(InvoiceDate) AS Month_,
    COUNT(DISTINCT Invoice) AS Total_Invoices,
    SUM(Quantity) AS Total_Product,
    ROUND(SUM(Quantity * Price), 2) AS Monthly_Revenue,
    ROUND(SUM(Quantity * Price) * 100.0 / SUM(SUM(Quantity * Price)) OVER(), 2) AS Revenue_Share_Percentage
FROM Clean_Online_Retail_Final
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Year_, Month_;


--====================================================
-- COUNTRY PERFORMANCE
--====================================================

SELECT 
    Country,
    COUNT(DISTINCT Invoice) AS Total_Transactions,
    SUM(Quantity) AS Total_Product_Quantity,
    ROUND(SUM(Quantity * Price), 2) AS Total_Revenue,
    ROUND(
        SUM(Quantity * Price) / COUNT(DISTINCT Invoice), 
        2
    ) AS Average_Basket_Value
FROM Clean_Online_Retail_Final
GROUP BY Country
ORDER BY Total_Revenue DESC;


--MOST PROFITABLE PRODUCTS

SELECT TOP 10
    Description,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT Invoice) AS Order_Count,
    ROUND(SUM(Quantity * Price), 2) AS Total_Revenue
FROM Clean_Online_Retail_Final
GROUP BY Description
ORDER BY Total_Revenue DESC;


--====================================================
-- PRODUCT REVENUE ANALYSIS (ABC)
--====================================================

WITH Product_Revenue AS (
    SELECT 
        Description,
        ROUND(SUM(Quantity * Price), 2) AS Total_Revenue
    FROM Clean_Online_Retail_Final
    WHERE Quantity > 0 AND Price > 0 -- Just Positive Sales
    GROUP BY Description
),
Cumulative_Calculation AS (
    SELECT 
        Description,
        Total_Revenue,
        SUM(Total_Revenue) OVER (ORDER BY Total_Revenue DESC) AS Cumulative_Total,
        SUM(Total_Revenue) OVER () AS Overall_Total
    FROM Product_Revenue
),
Segmented AS (
    SELECT 
        Description,
        Total_Revenue,
        CASE 
            WHEN (Cumulative_Total / NULLIF(Overall_Total, 0)) <= 0.80 THEN 'A (STAR)'
            WHEN (Cumulative_Total / NULLIF(Overall_Total, 0)) <= 0.95 THEN 'B (MEDIUM)'
            ELSE 'C (LOW)'
        END AS Segment
    FROM Cumulative_Calculation
)
SELECT 
    Segment,
    COUNT(Description) AS Product_Count, 
    SUM(Total_Revenue) AS Segment_Total_Revenue,
    ROUND(SUM(Total_Revenue) * 100.0 / SUM(SUM(Total_Revenue)) OVER (), 2) AS Segment_Revenue_Percentage
FROM Segmented
GROUP BY Segment
ORDER BY Segment_Total_Revenue DESC;


--====================================================
-- MARKET BASKET ANALYSIS
--====================================================

WITH Product_Revenue AS (
    SELECT Description, SUM(Quantity * Price) AS Total_Revenue
    FROM Clean_Online_Retail_Final
    GROUP BY Description
),
A_Segment AS (
    SELECT Description
    FROM (
        SELECT Description,
               SUM(Total_Revenue) OVER (ORDER BY Total_Revenue DESC) AS Cumulative_Revenue,
               SUM(Total_Revenue) OVER () AS Overall_Revenue
        FROM Product_Revenue
    ) AS T
    WHERE Cumulative_Revenue <= 0.81 * Overall_Revenue -- Adjusted the threshold to 81% to include 'borderline' Star products and ensure no significant items are missed.
),
MultiItemInvoices AS (
    SELECT Invoice
    FROM Clean_Online_Retail_Final
    GROUP BY Invoice
    HAVING COUNT(DISTINCT Description) > 1 
)
SELECT 
    a.Description AS Main_Product,
    b.Description AS CoPurchased_Product,
    COUNT(*) AS CoPurchase_Count
FROM Clean_Online_Retail_Final a
JOIN Clean_Online_Retail_Final b ON a.Invoice = b.Invoice
JOIN MultiItemInvoices m ON a.Invoice = m.Invoice
WHERE a.Description IN (SELECT Description FROM A_Segment)
  AND a.Description < b.Description  -- It prevents double counting and improves query performance
GROUP BY a.Description, b.Description
HAVING COUNT(*) > 5 -- To filter out random associations and focus on significant patterns
ORDER BY CoPurchase_Count DESC;



--====================================================
--REPEAT CUSTOMER ANALYSIS
--====================================================

WITH Customer_Orders AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Invoice) AS Order_Count
    FROM Clean_Online_Retail_Final
    GROUP BY Customer_ID
)

SELECT
    COUNT(*) AS Total_Customer,
    SUM(CASE WHEN Order_Count = 1 THEN 1 ELSE 0 END) AS Single_Order_Customer,
    SUM(CASE WHEN Order_Count > 1 THEN 1 ELSE 0 END) AS Repeat_Customer
FROM Customer_Orders;

--REPEAT RATE

WITH Customer_Orders AS (
    SELECT
        Customer_ID,
        COUNT(DISTINCT Invoice) AS Order_Count
    FROM Clean_Online_Retail_Final
    GROUP BY Customer_ID
)

SELECT
    COUNT(*) AS Total_Customer,
    
    SUM(CASE WHEN Order_Count > 1 THEN 1 ELSE 0 END) AS Repeat_Customer,

    ROUND(
        SUM(CASE WHEN Order_Count > 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS Repeat_Rate_Percentage
FROM Customer_Orders;

-- TOP CUSTOMERS BY REVENUE

WITH Customer_Revenue AS (

SELECT
    Customer_ID,
    SUM(Quantity * Price) AS Total_Spending
FROM Clean_Online_Retail_Final
GROUP BY Customer_ID

)

SELECT TOP 10
    Customer_ID,
    ROUND(Total_Spending,2) AS Total_Spending
FROM Customer_Revenue
ORDER BY Total_Spending DESC;

--====================================================
-- CUSTOMER PARETO ANALYSIS
--====================================================

--Customer Pareto Analysis

WITH Customer_Revenue AS (

SELECT
    Customer_ID,
    SUM(Quantity * Price) AS Total_Spending
FROM Clean_Online_Retail_Final
WHERE Customer_ID IS NOT NULL
GROUP BY Customer_ID

),

Customer_Pareto AS (

SELECT
    Customer_ID,
    Total_Spending,
    SUM(Total_Spending) OVER (ORDER BY Total_Spending DESC) AS Cumulative_Revenue,
    SUM(Total_Spending) OVER () AS Overall_Revenue
FROM Customer_Revenue

)

SELECT
    Customer_ID,
    ROUND(Total_Spending,2) AS Total_Spending,
    ROUND((Cumulative_Revenue / Overall_Revenue) * 100,2) AS Pareto_Rate
FROM Customer_Pareto
ORDER BY Total_Spending DESC;



--====================================================
-- CANCEL ANALYSIS
--====================================================

-- Top 10 cancels

SELECT TOP 10
    Description,
    SUM(ABS(Quantity)) AS Total_Returned_Qty,
    COUNT(DISTINCT Invoice) AS Return_Transaction_Count,
    ROUND(SUM(ABS(Quantity) * Price), 2) AS Total_Loss_Amount
FROM View_Returns
GROUP BY Description
ORDER BY Total_Returned_Qty DESC;



-- Cancel analysis based on country

SELECT 
    Country,
    COUNT(DISTINCT Invoice) AS Total_Return_Transactions, -- Number of return invoices
    SUM(ABS(Quantity)) AS Total_Returned_Items,          -- Total returnd quantity
    ROUND(SUM(ABS(Quantity) * Price), 2) AS Total_Refund_Amount -- Total refund amount
FROM View_Returns
GROUP BY Country
ORDER BY Total_Refund_Amount DESC; 


-- Monthly return trend analysis

SELECT 
    YEAR(InvoiceDate) AS Year_,
    MONTH(InvoiceDate) AS Month_,
    COUNT(DISTINCT Invoice) AS Return_Invoice_Count, -- How many return invoices were issued during that month?
    SUM(ABS(Quantity)) AS Returned_Quantity,         -- How many units were returned during that month?
    ROUND(SUM(ABS(Quantity) * Price), 2) AS Monthly_Refund_Total -- What was the total refund value for that month?
FROM View_Returns
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY Year_, Month_;

--Return trend

GO
CREATE VIEW View_Sales_Vs_Refund_Trend AS
SELECT 
    ISNULL(S.Year_, R.Year_) AS Year_,
    ISNULL(S.Month_, R.Month_) AS Month_,
    ROUND(S.Monthly_Revenue, 2) AS Sales_Revenue,
    ROUND(ISNULL(R.Monthly_Refund_Total, 0), 2) AS Refund_Amount
FROM (
    
    SELECT YEAR(InvoiceDate) AS Year_, MONTH(InvoiceDate) AS Month_, SUM(Quantity * Price) AS Monthly_Revenue
    FROM Clean_Online_Retail_Final
    GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
) S
LEFT JOIN (
    
    SELECT YEAR(InvoiceDate) AS Year_, MONTH(InvoiceDate) AS Month_, SUM(ABS(Quantity) * Price) AS Monthly_Refund_Total
    FROM View_Returns
    GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
) R ON S.Year_ = R.Year_ AND S.Month_ = R.Month_;
GO

-- General return rate by revenue

WITH Total_Sales AS (
    SELECT 
        SUM(Quantity) AS Total_Sold_Qty,
        SUM(Quantity * Price) AS Total_Sales_Revenue
    FROM Clean_Online_Retail_Final
),
Total_Returns AS (
    SELECT 
        SUM(ABS(Quantity)) AS Total_Returned_Qty,
        SUM(ABS(Quantity) * Price) AS Total_Refund_Amount
    FROM View_Returns
)
SELECT 
    Total_Sold_Qty,
    Total_Returned_Qty,
    -- Return Rate by Volume
    ROUND(CAST(Total_Returned_Qty AS FLOAT) / Total_Sold_Qty * 100, 2) AS Return_Rate_Quantity_Pct,
    
    Total_Sales_Revenue,
    Total_Refund_Amount,
    -- Return Rate by Revenue
    ROUND(CAST(Total_Refund_Amount AS FLOAT) / Total_Sales_Revenue * 100, 2) AS Return_Rate_Revenue_Pct
FROM Total_Sales, Total_Returns;