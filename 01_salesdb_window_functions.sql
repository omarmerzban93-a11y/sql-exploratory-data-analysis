/*
===============================================================================
SalesDB - Window Functions Practice
===============================================================================
Covers: LAG, FIRST_VALUE, LAST_VALUE, RANK, and combining window functions
with subqueries for month-over-month and product-level analysis.
===============================================================================
*/

-- Basic LAG: compare each order's sales to the previous order's sales
SELECT 
    OrderDate,
    Sales,
    LAG(Sales) OVER (ORDER BY OrderDate) AS PreviousSales
FROM Sales.Orders;


-- Month-over-Month sales change using LAG
SELECT
    *,
    CurrentMonthSales - PreviousMonthSales AS Mom_change,
    ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT) / PreviousMonthSales * 100, 1) AS mom_perc
FROM (
    SELECT
        MONTH(OrderDate) AS OrderMonth,
        SUM(Sales) AS CurrentMonthSales,
        LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) AS PreviousMonthSales
    FROM Sales.Orders
    GROUP BY MONTH(OrderDate)
) t;


-- Find the lowest and highest sales for each product,
-- and the difference between current sales and the lowest sales
SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS LowestSales,
    LAST_VALUE(Sales) OVER (
        PARTITION BY ProductID
        ORDER BY Sales
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS HighestSales,
    Sales - FIRST_VALUE(Sales) OVER (
        PARTITION BY ProductID
        ORDER BY Sales
    ) AS SalesDifference
FROM Sales.Orders;


-- Rank customers based on their total amount of sales
SELECT
    *,
    RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
FROM (
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) t;
