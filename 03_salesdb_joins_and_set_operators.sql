/*
===============================================================================
SalesDB - Joins & Set Operators Practice
===============================================================================
Covers: LEFT JOIN, FULL JOIN, and UNION/EXCEPT set operators.
===============================================================================
*/

-- Find customers who have made NO orders (LEFT JOIN + IS NULL pattern)
SELECT 
    * 
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
    ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;


-- 3-table join: order details + customer name + product name/price
SELECT 
    o.OrderID,
    c.FirstName,
    c.LastName,
    p.Product,
    p.Price
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
    ON c.CustomerID = o.CustomerID
LEFT JOIN Sales.Products p
    ON o.ProductID = p.ProductID;


-- FULL JOIN: show only unmatched rows from either side
SELECT *
FROM Sales.Customers c
FULL JOIN Sales.Orders o
    ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL OR o.CustomerID IS NULL;


-- UNION: combine customer and employee names, no duplicates
SELECT 
    FirstName,
    LastName
FROM Sales.Customers

UNION

SELECT
    FirstName,
    LastName
FROM Sales.Employees;


-- EXCEPT: employee names that do NOT appear in the Customers table
SELECT 
    FirstName,
    LastName
FROM Sales.Employees

EXCEPT

SELECT
    FirstName,
    LastName
FROM Sales.Customers;


-- UNION with a source label: combine Orders and OrdersArchive
SELECT 
    *,
    'Orders' AS SourceTable
FROM Sales.Orders

UNION

SELECT
    *,
    'OrdersArchive' AS SourceTable
FROM Sales.OrdersArchive

ORDER BY OrderDate;
