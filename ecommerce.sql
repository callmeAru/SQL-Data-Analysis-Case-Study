use ecommerce;
select * from flipkart_sales_enriched;

SELECT COUNT(*) AS Total_Rows FROM flipkart_sales_enriched;
DESCRIBE flipkart_sales_enriched;
SELECT MIN(`Order Date`) AS First_Order_Date,MAX(`Order Date`) AS Last_Order_Date
FROM flipkart_sales_enriched;

SELECT `Order ID`,`Product Name`,`Order Date`,`Total Sales (INR)`,COUNT(*) AS Duplicate_Count
FROM flipkart_sales_enriched
GROUP BY `Order ID`,`Product Name`,`Order Date`,`Total Sales (INR)` HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;

SELECT `Order ID`,COUNT(*) AS Number_of_Rows
FROM flipkart_sales_enriched
GROUP BY `Order ID`
HAVING COUNT(*) > 1
ORDER BY Number_of_Rows DESC;

SELECT DISTINCT Category
FROM flipkart_sales_enriched;

SELECT DISTINCT Region
FROM flipkart_sales_enriched;

SELECT DISTINCT `Payment Method`
FROM flipkart_sales_enriched;

SELECT DISTINCT `Product Name`
FROM flipkart_sales_enriched
ORDER BY `Product Name`;

SELECT ROUND(SUM(`Total Sales (INR)`), 2) AS Total_Sales
FROM flipkart_sales_enriched;

SELECT ROUND(SUM(`Profit (INR)`), 2) AS Total_Profit
FROM flipkart_sales_enriched;

SELECT ROUND(AVG(`Total Sales (INR)`), 2) AS Average_Sales
FROM flipkart_sales_enriched;

SELECT SUM(`Quantity Sold`) AS Total_Quantity_Sold
FROM flipkart_sales_enriched;

SELECT `Product Name`, ROUND(SUM(`Total Sales (INR)`), 2) AS Total_Sales
FROM flipkart_sales_enriched
GROUP BY `Product Name`
ORDER BY Total_Sales DESC;

SELECT Category, ROUND(SUM(`Total Sales (INR)`), 2) AS Total_Sales
FROM flipkart_sales_enriched
GROUP BY Category
ORDER BY Total_Sales DESC;

SELECT Category,ROUND(SUM(`Profit (INR)`), 2) AS Total_Profit
FROM flipkart_sales_enriched
GROUP BY Category
ORDER BY Total_Profit DESC;

SELECT `Product Name`,SUM(`Total Sales (INR)`) AS Total_Sales
FROM flipkart_sales_enriched
GROUP BY `Product Name`
HAVING SUM(`Total Sales (INR)`) >
(
    SELECT AVG(Product_Sales)
    FROM
    (
        SELECT `Product Name`,SUM(`Total Sales (INR)`) AS Product_Sales
        FROM flipkart_sales_enriched
        GROUP BY `Product Name`
    ) AS ProductSummary
);

WITH ProductSales AS
(
    SELECT `Product Name`, SUM(`Total Sales (INR)`) AS Total_Sales
    FROM flipkart_sales_enriched
    GROUP BY `Product Name`
)

SELECT `Product Name`,ROUND(Total_Sales, 2) AS Total_Sales,
    RANK() OVER
    (ORDER BY Total_Sales DESC) AS Sales_Rank
FROM ProductSales;

WITH MonthlySales AS
(
    SELECT
        YEAR(`Order Date`) AS Year,
        MONTH(`Order Date`) AS Month,
        SUM(`Total Sales (INR)`) AS Total_Sales
    FROM flipkart_sales_enriched
    GROUP BY
        YEAR(`Order Date`),
        MONTH(`Order Date`)
)
SELECT Year,Month,ROUND(Total_Sales, 2) AS Total_Sales,
ROUND(
        LAG(Total_Sales) OVER
        ( ORDER BY Year, Month), 2
    ) AS Previous_Month_Sales
FROM MonthlySales
ORDER BY Year, Month;

WITH ProductSales AS
(
    SELECT
        `Product Name`,SUM(`Total Sales (INR)`) AS Total_Sales
    FROM flipkart_sales_enriched
    GROUP BY `Product Name`
)

SELECT `Product Name`,ROUND(Total_Sales, 2) AS Total_Sales,
    NTILE(3) OVER
    (ORDER BY Total_Sales) AS Sales_Group
FROM ProductSales;