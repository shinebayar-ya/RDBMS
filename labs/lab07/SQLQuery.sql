/*
    @author: x41
    Task #6.1
*/

USE [master]
GO

-- 1. EmpDB өгөгдлийн санг үүсгэх.
CREATE DATABASE EmpDB
GO

USE EmpDB
GO

-- 2. Employee хүснэгтийг үүсгэх.
CREATE TABLE Employee (
    EmpCode int PRIMARY KEY identity,
    EmpName nvarchar (20) not null,
    HiredDate date not null,
    DepartID int not null,
    JobTitle nvarchar (30) not null
)
GO

-- 3. Department хүснэгтийг үүсгэх.
CREATE TABLE Department (
    DepartID int PRIMARY KEY identity(100,1),
    DepartName nvarchar (30) not null
)
GO

-- 4. Salary хүснэгтийг үүсгэх.
CREATE TABLE Salary (
    [Number] int PRIMARY KEY identity,
    EmpCode int not null,
    Salary int not null,
    [Date] date not null
)
GO

-- 5. Employee хүснэгтэд дараах өгөгдлийг оруулах.
INSERT INTO Employee
VALUES
(N'Болд', '2005/12/01', 101, N'Захирал'),
(N'Болдбаатар', '2006/02/01', 100, N'Програмист'),
(N'Баатар', '2006/02/01', 100, N'Програмист'),
(N'Хүрэлсүх', '2006/02/01', 100, N'Програмист'),
(N'Хулан', '2006/01/01', 103, N'Албаны дарга'),
(N'Мягмар', '2005/10/07', 103, N'Хамгаалагч'),
(N'Болд', '2005/10/07', 103, N'Хамгаалагч')
GO

SELECT *
FROM Employee
GO


-- 6. Department хүснэгтэд дараах өгөгдлийг оруулах.
INSERT INTO Department
VALUES
(N'Мэдээлэл технологи'),
(N'Санхүүгийн хэлтэс'),
(N'Хяналт шалгалт'),
(N'Хамгаалалтын алба')
GO

SELECT *
FROM Department
GO

-- 7. Salary хүснэгтэд дараах өгөгдлийг оруулах.
INSERT INTO Salary
VALUES
(1, 1000000, '2009/03/01'),
(2, 500000, '2009/03/01'),
(3, 750000, '2009/03/01'),
(4, 500000, '2009/03/01'),
(2, 500000, '2009/03/15'),
(3, 500000, '2009/03/15'),
(4, 650000, '2009/03/15'),
(5, 450000, '2009/03/15'),
(6, 500000, '2009/03/15')
GO

SELECT *
FROM Salary
GO

-- 8. Баатартай нэг хэлтсийн ажилчдыг харуулах.
SELECT *
FROM Employee
WHERE DepartID = (
    SELECT DepartID
    FROM Employee
    WHERE EmpName LIKE N'Баатар'
)
GO

SELECT *
FROM Employee
GO


-- 9. Хамгийн өндөр цалин авдаг ажилтны нэр, кодыг харуулах.
SELECT EmpName, EmpCode
FROM Employee
WHERE EmpCode = (
    SELECT TOP 1 EmpCode
    FROM Salary
    ORDER BY Salary DESC
)
GO

-- 10. Програмист албан тушаалтай ажилчдын цалинг харуулах.
SELECT EmpCode, SUM(Salary)
FROM Salary
WHERE EmpCode IN (
    SELECT EmpCode
    FROM Employee
    WHERE JobTitle LIKE N'Програмист'
)
GROUP BY EmpCode
GO

-- 11. Болд гэсэн нэртэй ажилчид ямар хэлтэст харьяалагдахыг харуулах.
SELECT DepartName
FROM Department
WHERE DepartID IN (
    SELECT DepartID
    FROM Employee
    WHERE EmpName LIKE N'Болд'
)
GO

-- 12. Ажилтан Хулан Хамгаалалтын албаны ажилтан бол бүх Хамгаалалтын ажилчдыг харуулах.
SELECT *
FROM Employee
WHERE EXISTS (
    SELECT DepartID
    FROM Employee
    WHERE DepartID IN (
        SELECT DepartID
        FROM Department
        WHERE DepartName LIKE N'Хамгаалалтын алба'
    ) AND EmpName LIKE N'Хулан'
) AND DepartID IN (
        SELECT DepartID
        FROM Department
        WHERE DepartName LIKE N'Хамгаалалтын алба'
)
GO

-- 13. Ажилтны код, нэр, албан тушаал, хэлтсийн нэрийг хүснэгтүүдийг холбож харуулах.
SELECT e.EmpCode, e.EmpName, e.JobTitle, d.DepartName
FROM Employee e, Department d
WHERE e.DepartID = d.DepartID
GO

-- 14. Employee, Salary, Department хүснэгтүүдийг холбож харуулах.
SELECT e.*, s.Salary, d.DepartName
FROM Employee e, Salary s, Department d
WHERE e.DepartID = d.DepartID AND e.EmpCode = s.EmpCode
GO

