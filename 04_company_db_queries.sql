/*
===============================================================================
Company DB - Joins, Aggregations, Subqueries & EXISTS
===============================================================================
Schema: Departments(Dnum PK, Dname, MGRSSN FK), Employee(SSN PK, Fname, Lname,
Salary, Dno FK, Superssn FK), Project(Pnumber PK, Pname, Dnum FK),
Works_for(ESSN FK, Pno FK, Hours), Dependent(ESSN FK, Dependent_name, Sex)
===============================================================================
*/

-- UNION: female dependents of female employees + male dependents of male employees
SELECT
    d.Dependent_name,
    d.Sex
FROM dbo.Dependent d 
JOIN dbo.Employee e
    ON d.ESSN = e.SSN
WHERE d.Sex = 'F' AND e.Sex = 'F'

UNION

SELECT
    d.Dependent_name,
    d.Sex
FROM dbo.Dependent d 
JOIN dbo.Employee e
    ON d.ESSN = e.SSN
WHERE d.Sex = 'M' AND e.Sex = 'M';


-- Total hours per week spent on each project
SELECT 
    p.Pname,
    SUM(w.Hours) AS TotalHours
FROM dbo.Project p 
JOIN dbo.Works_for w
    ON p.Pnumber = w.Pno
GROUP BY p.Pname;


-- All data of the managers (self-join style: matched via MGRSSN)
SELECT *
FROM (
    SELECT
        d.Dname,
        e.*
    FROM dbo.Departments d
    JOIN dbo.Employee e
        ON e.SSN = d.MGRSSN
) t;


-- Per department: max, min, and average salary of ALL employees
SELECT
    d.Dname,
    MAX(e.Salary) AS MaxSalary,
    MIN(e.Salary) AS MinSalary,
    AVG(e.Salary) AS AvgSalary
FROM dbo.Departments d
JOIN dbo.Employee e
    ON e.Dno = d.Dnum
GROUP BY d.Dname;


-- Managers who have NO dependents
SELECT
    e.Fname,
    e.Lname
FROM dbo.Departments d
JOIN dbo.Employee e
    ON e.SSN = d.MGRSSN
LEFT JOIN dbo.Dependent de
    ON de.ESSN = e.SSN
WHERE de.ESSN IS NULL;


-- Departments with average salary below the company-wide average
SELECT
    d.Dnum,
    d.Dname,
    COUNT(e.SSN) AS NumEmployees,
    AVG(e.Salary) AS DeptAvgSalary
FROM dbo.Departments d
JOIN dbo.Employee e
    ON e.Dno = d.Dnum
GROUP BY d.Dnum, d.Dname
HAVING AVG(e.Salary) < (SELECT AVG(Salary) FROM dbo.Employee);


-- Employees + the projects run by their own department
SELECT 
    e.Fname,
    e.Lname,
    e.Dno
FROM dbo.Employee e
JOIN dbo.Project p
    ON e.Dno = p.Dnum
JOIN dbo.Departments d
    ON e.Dno = d.Dnum
GROUP BY e.Fname, e.Lname, e.Dno;


-- Top 2 highest salaries
SELECT TOP 2
    Salary
FROM dbo.Employee
ORDER BY Salary DESC;


-- Employees whose name matches any dependent's name
SELECT
    e.Fname
FROM dbo.Employee e
JOIN dbo.Dependent d
    ON e.Fname = d.Dependent_name;


-- Employees who have at least one dependent (using EXISTS)
SELECT 
    e.SSN,
    e.Fname,
    e.Lname
FROM dbo.Employee e
WHERE EXISTS (
    SELECT 1
    FROM dbo.Dependent d
    WHERE d.ESSN = e.SSN
);
