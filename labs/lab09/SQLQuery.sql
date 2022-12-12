/*
    @author: x41
    Task # 7
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


-- 8. Product, Sales, Category 3 хүснэгтийг холбосон vAll нэртэй view үүсгэх.
CREATE View vAll AS
SELECT  p.ProID, 
        p.ProName, 
        p.CategoryID, 
        p.Price, 
        c.CategoryName, 
        s.[Number],
        s.Product,
        s.[Count],
        s.[Date]
FROM Product p
FULL OUTER JOIN Sales s ON p.ProID = s.Product
FULL OUTER JOIN Category c ON p.CategoryID = c.CategoryID
GO

-- 9. 3 ширхэгээс дээш зарагдсан бараануудыг харуулсан vThree гэсэн view-г зөвхөн 3 дээш зарагдсан бараанууд ордог байхаар үүсгэх.
CREATE VIEW vThree AS
SELECT [Number], Product, [Count], [Date]
FROM Sales
WHERE [Count] > 3
WITH CHECK OPTION
GO

-- 10. Хамгийн их гүйлгээтэй 5 бараа харуулсан vTop5 view үүсгэх.
CREATE VIEW vTop5 AS
SELECT TOP 5 p.ProName
FROM Product p 
INNER JOIN Sales s ON p.ProID = s.Product
GROUP BY p.ProName
ORDER BY SUM(s.[Count]) DESC
GO

-- 11. Төрөл тус бүр нийт хэдэн ширхэг бараа зарсаныг харуулсан vCategoryTotal view үүсгэх.
CREATE VIEW vCategoryTotal AS
SELECT c.CategoryName, [Төрөл тус бүрийн зарагдсан тоо ширхэг] = SUM(s.[Count])
FROM Product p 
INNER JOIN Category c ON p.CategoryID = c.CategoryID
INNER JOIN Sales s ON p.ProID = s.Product
GROUP BY c.CategoryName
GO

-- 12. insert into vThree values(2, 2, getdate()) гэсэн өгөгдлийг нэмж болох уу? Болохгүй бол яагаад?
INSERT INTO vThree VALUES(2, 2, GETDATE())
GO
-- WITHOUT CHECK OPTION
-- Энэ тохиодолд query амжилттай ажиллах хэдий ч View рүү орохгүй юм. Учир нь View нь
-- 3 -аас дээш барааг харуулдаг View юм. Sales table -д харин үлдсэн баганад ямар нэг
-- PRIMARY KEY, NOT NULL constraint байхгүй бол амжилттай орно.
-- Мөн олон хүснэгтээс бүрдсэн View өгөгдөл оруулах үед амжилтгүй ажиллана.

-- WITH CHECK OPTION
-- WITH CHECK OPTION constraint хангахгүй байгаа учир өгөгдөл орохгүй. 
-- Мөн WITH CHECK OPTION тэй View ээс үүссэн View өгөгдөл оруулах үед тухайн
-- constraint ажиллана.