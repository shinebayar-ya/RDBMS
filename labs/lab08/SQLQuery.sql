/*
    @author: x41
    Task # 6.2
*/

USE [master]
GO

-- 1. SuperMarket гэсэн нэртэй өгөгдлийн бааз үүсгэх.
IF DB_ID('Supermarket') IS NOT NULL
DROP DATABASE [Supermarket]
GO

CREATE DATABASE [Supermarket]
GO

USE Supermarket
GO

-- 2. Product хүснэгтийг үүсгэх.
CREATE TABLE Product (
    ProID INT IDENTITY(100, 1) PRIMARY KEY,
    ProName NVARCHAR(30) NOT NULL,
    CategoryID INT NOT NULL,
    Price INT NOT NULL
)
GO

-- 3. Дараах өгөгдүүдийг Product хүснэгтэд оруулах.
INSERT INTO Product 
VALUES 
(N'Зууван цех талх', 1, 750),
(N'Буриад төмс', 2, 600),
(N'Саван', 3, 350),
(N'Гэрлийн ламп', 3, 500),
(N'Лууван', 2, 800),
(N'Улаан төмс', 2, 1000),
(N'Цагаан лууван', 2, 1200),
(N'Болор архи', 8, 15000)
GO

-- 4. Category хүснэгтийг үүсгэх.
CREATE TABLE Category (
    CategoryID INT IDENTITY(1, 1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL
)
GO

-- 5. Дараах өгөгдүүдийг Category хүснэгтэд оруулах.
INSERT INTO Category 
VALUES 
(N'Боов талх'),
(N'Хүнсний ногоо'),
(N'Гэр ахуйн бараа'),
(N'Ус, ундаа')
GO

-- 6. Sales хүснэгтийг үүсгэх.
CREATE TABLE Sales (
[Number] INT IDENTITY PRIMARY KEY,
Product INT,
[Count] INT,
[Date] SMALLDATETIME DEFAULT GETDATE()
)
GO

-- 7. Дараах өгөгдлүүдийг Sales хүснэгтрүү оруулах.
INSERT INTO Sales 
VALUES
(100, 2, '2008-02-17'),
(101, 3, '2008-02-17'),
(106, 1, '2008-02-17'),
(104, 3, '2008-02-18'),
(100, 5, '2008-02-18'),
(103, 10, '2008-02-18'),
(104, 1, '2008-02-19'),
(106, 2, '2008-02-20'),
(105, 3, '2008-02-20'),
(105, 1, '2008-02-21'),
(100, 1, '2008-02-21'),
(101, 2, '2008-02-21'),
(102, 4, '2008-02-22'),
(105, 2, '2008-02-22'),
(104, 5, '2008-02-22'),
(100, 2, '2008-02-22'),
(100, 1, '2008-02-22'),
(100, 15, '2008-02-23'),
(101, 2, '2008-02-24'),
(102, 1, '2008-02-25')
GO

-- 8. 2008.02.20 зарагдсан бараануудыг харуулах.
SELECT p.ProName
FROM Product p
INNER JOIN Sales s
ON p.ProId = s.Product
WHERE s.[Date] = '2008-02-20'
GO

-- 9. Нэгч удаа борлуулалт хийгдээгүй барааг харуулах.
SELECT ProName as Name
FROM Product
WHERE ProID NOT IN (
    SELECT DISTINCT Product
    FROM Sales
)
GO

-- 10. Product, Sales хүснэгтүүдийг нэгтгэж харуулах.
SELECT p.*, s.*
FROM Product p 
INNER JOIN Sales s ON p.ProID = s.Product
ORDER BY p.ProName
GO

-- 11. Cаван нийт хэдэн төгрөгөөр зарагдсаныг харуулах.
SELECT p.ProName, SUM(p.Price * s.[Count])  AS 'Савангийн нийт үнэ'
FROM Product p 
INNER JOIN Sales s ON p.ProID = s.Product
WHERE p.ProName LIKE N'Саван'
GROUP BY p.ProName
GO

-- 12. Хамгийн их зарагдсан 3 барааг харуулах.
SELECT TOP 3 p.ProName
FROM Product p 
INNER JOIN Sales s ON p.ProID = s.Product
GROUP BY p.ProName
ORDER BY SUM(s.[Count]) DESC
GO

-- 13. Бараа болгон хэдэн ширхэг зарагдсаныг харуулах.. Жнь: Төмс - 5
SELECT p.ProName + ' - ' + CAST(SUM(s.[Count]) AS NVARCHAR) AS [Хэдэн ш зарагдсан тоо]
FROM Product p 
INNER JOIN Sales s ON p.ProID = s.Product
GROUP BY p.ProName
GO

-- 14. Product хүснэгтэнд Саван гэсэн нэртэй бараа байвал Sales хүснэгтээс савангийн бүх борлуулалтыг харуулах.
SELECT s.*
FROM Product p 
INNER JOIN Sales s ON p.ProID = s.Product
WHERE p.ProName LIKE N'Саван' 
GO

-- 15. Хамгийн их зарагдсан барааны төрлийг харуулах.
SELECT TOP 1 c.CategoryName
FROM Product p 
INNER JOIN Sales s ON p.ProID = s.Product
INNER JOIN Category c ON p.CategoryID = c.CategoryID
GROUP BY p.ProName, c.CategoryName
ORDER BY SUM(s.[Count]) DESC
GO

-- 16. Луувангаас их үнэтэй бараануудыг харуулах.
SELECT ProName
FROM Product
WHERE Price > (
    SELECT Price
    FROM Product
    WHERE ProName LIKE N'Лууван'
)
GO

-- 17. Захиалгын дугаар, барааны нэр, төрөл, тоо, нэгж үнэ, захиалгын нийт үнийг харуулах.
SELECT s.[Number], p.ProName, c.CategoryName, s.[Count], p.Price, [Нийт үнэ] = s.[Count] * p.Price
FROM Product p
INNER JOIN Sales s ON p.ProID = s.Product
INNER JOIN Category c ON p.CategoryID = c.CategoryID
GO

-- 18. Бараа тус бүрийн нэр, төрөл, нийт зарагдсан тоо, нэгж үнэ, нийт үнүүдийг харуулах.
SELECT p.ProName, c.CategoryName, [Нийт зарагдсан тоо] = SUM(s.[Count]), p.Price, [Нийт үнэ] = SUM(s.[Count] * p.Price)
FROM Product p
INNER JOIN Sales s ON p.ProID = s.Product
INNER JOIN Category c ON p.CategoryID = c.CategoryID
GROUP BY p.ProName, c.CategoryName, p.Price
GO

-- 19. 2008.02.25 зарагдсан бүх борлуултын Зарагдсан огноог 2008.02.27, Зарсан тоо ширхэгийг 5 болгож засах.
UPDATE Sales
SET [Date] = '2008-02-27', [Count] = 5
WHERE [Date] = '2008-02-25'
GO

SELECT *
FROM Sales
GO

-- 20. Улаан төмстэй ижил ангиллын бараануудыг устгах.
SELECT *
FROM Product
GO

SELECT *
FROM Sales
GO

DELETE FROM Product
WHERE ProName LIKE N'Улаан төмс'
GO

DELETE FROM Sales
WHERE Product IN (
    SELECT DISTINCT ProID
    FROM Product
    WHERE ProName LIKE N'Улаан төмс'
)
GO