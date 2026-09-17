/*
===============================================================================
SalesDB - Subqueries Practice
===============================================================================
Covers: non-correlated subqueries, scalar subqueries, and combining
LEAD/DATEDIFF with a subquery to analyze customer loyalty.
===============================================================================
*/

-- Non-correlated subquery: orders from customers NOT in Germany
SELECT 
    *
FROM Sales.Orders
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Sales.Customers
    WHERE Country != 'Germany'
);


-- Scalar subquery: products priced above the average product price
SELECT 
    ProductID,
    Price,
    (SELECT AVG(Price) FROM Sales.Products) AS AvgPrice
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products);


-- Customer loyalty analysis: rank customers by average days between orders
-- (uses LEAD + DATEDIFF in a subquery, then aggregates and ranks in the outer query)
SELECT
    CustomerID,
    AVG(DaysUntilNextOrder) AS AvgDays,
    RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder), 999999)) AS RankAvg
FROM (
    SELECT
        OrderID,
        CustomerID,
        OrderDate AS CurrentOrder,
        LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrder,
        DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) AS DaysUntilNextOrder
    FROM Sales.Orders
) t
GROUP BY CustomerID;
