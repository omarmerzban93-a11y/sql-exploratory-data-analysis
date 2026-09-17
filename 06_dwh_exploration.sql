/*
===============================================================================
DataWarehouseAnalytics - Database & Dimension Exploration
===============================================================================
*/

-- Explore all tables in the database
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- Explore all columns for a specific table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

-- Explore all countries our customers are from
SELECT DISTINCT country
FROM gold.dim_customers;

-- Explore all product categories/subcategories
SELECT DISTINCT category, subcategory
FROM gold.dim_products;

-- Customer gender split
SELECT 
    gender,
    COUNT(*) AS gendersplit
FROM gold.dim_customers
GROUP BY gender;

-- Date exploration: first and last order date + order range in years
SELECT
    MIN(order_date) AS firstorderdate, 
    MAX(order_date) AS lastorderdate,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;

-- Oldest and youngest customers by birthdate
SELECT
    MIN(birthdate) AS oldestbirthdate,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngestage,
    MAX(birthdate) AS youngestbirthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldestage
FROM gold.dim_customers;
