/*
	@author: x41
	Task #3 solutions
*/

USE [master]
GO

-- Task 1.1 Create a new database
IF DB_ID ('EmpDB') IS NOT NULL
DROP DATABASE EmpDB
GO

CREATE DATABASE EmpDB
GO

USE EmpDB
GO

-- Task 1.2 Create a new table
IF OBJECT_ID ('Employee') IS NOT NULL
DROP TABLE Employee
GO

CREATE TABLE Employee (
	EmpCode int NOT NULL,
	EmpName nvarchar(20) NOT NULL,
	EmpDOB date, -- Date of Birth
	EmpDOJ date NOT NULL, -- Date of Joining
	Salary int NOT NULL,
	JobTitle nvarchar(30) NOT NULL
)
GO

-- Task 1.3 
-- Remove all rows from a table
/*
TRUNCATE TABLE Employee
*/
-- Adds one or more rows to a table
INSERT INTO Employee (EmpCode, EmpName, EmpDOB, EmpDOJ, Salary, JobTitle)
VALUES 
(1, N'Болд', '1982/03/08', '2005/12/01', 1000000, N'Захирал'),
(2, N'Болдбаатар', '1985/09/26', '2006/02/01', 500000, N'Програмист'),
(3, N'Баатар', '1987/10/26', '2006/02/01', 500000, N'Програмист'),
(4, N'Хүрэлсүх', '1987/08/06', '2006/02/01', 500000, N'Програмист'),
(5, N'Хулан', '1982/08/06', '2006/01/01', 700000, N'Ахлах Програмист'),
(6, N'Мягмар', '1985/04/16', '2005/10/07', 300000, N'Шалгагч'),
(7, N'Болд', '1981/05/06', '2005/10/07', 300000, N'Шалгагч'),
(8, N'Пүрэвсүрэн', '1980/03/23', '2007/11/23', 400000, N'Нягтлан бодогч'),
(9, N'Давааням', '1979/02/20', '2008/01/03', 700000, N'Ахлах Програмист'),
(10, N'Наранчимэг', '1979/02/20', '2008/05/24', 500000, N'Програмист')
GO

SELECT *
FROM Employee
GO

-- Task 1.4
SELECT MAX(Salary) AS [Хамгийн их цалин], MIN(Salary) AS [Хамгийн бага цалин], AVG(Salary) AS [Дундаж цалин]
FROM Employee
GO

-- Task 1.5
SELECT COUNT(DISTINCT EmpCode) AS [Ажилчдын тоо]
FROM Employee
GO

-- Task 1.6
SELECT COUNT(*) AS [Програмистын тоо]
FROM Employee
WHERE JobTitle LIKE(N'Програмист')
GO

-- Task 1.7
SELECT EmpName, EmpDOB, EmpDOJ
FROM Employee
GO

-- Task 1.8
SELECT EmpName, DATEDIFF(year, EmpDOB, GETDATE()) AS [Ажилтны нас], DATEDIFF(yy, EmpDOJ, GETDATE()) AS [Ажилтны ажилласан жил]
FROM Employee
GO

-- Task 1.9
SELECT TOP(1) *, DATEDIFF(yy, EmpDOB, GETDATE()) AS [Ажилтны нас] 
FROM Employee
ORDER BY DATEPART(year, EmpDOB), Salary -- default ASC
GO

-- Alternative solution
SELECT TOP(1) *, DATEDIFF(yy, EmpDOB, GETDATE()) AS [Ажилтны нас]
FROM Employee
ORDER BY DATEDIFF(yy, EmpDOB, GETDATE()) DESC, Salary
GO

-- Task 1.10
SELECT *
FROM Employee
ORDER BY Salary DESC
GO

-- Task 1.12
SELECT TOP(3) *
FROM Employee
ORDER BY Salary DESC
GO

-- Task 1.13
SELECT TOP(3) *
FROM Employee
ORDER BY Salary ASC
GO

-- Task 1.14
ALTER TABLE Employee
ADD Department nvarchar(100)
GO

-- Task 1.15
UPDATE Employee
SET Department = N'Програм хангамж'
GO

SELECT *
FROM Employee
GO

-- Task 1.16
DELETE
FROM Employee
WHERE EmpCode IN (
	SELECT TOP 1 EmpCode
	FROM Employee
	WHERE EmpDOB < '1980-01-01'
	ORDER BY EmpDOJ DESC
)