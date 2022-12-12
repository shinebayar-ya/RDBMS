/*
    @author: x41
    Task # 8
*/

USE [master]
GO

-- 1. Library өгөгдлийн санг үүсгэх.
IF DB_ID('Library') IS NOT NULL
DROP DATABASE [Library]
GO

CREATE DATABASE [Library]
GO

USE Library
GO

-- 2. Books хүснэгтийг үүсгэх.
IF OBJECT_ID('Books') IS NOT NULL
DROP TABLE Books
GO

CREATE TABLE Books (
    BookID INT IDENTITY(100, 1) PRIMARY KEY,
    BookTitle NVARCHAR(100) NOT NULL,
    Author NVARCHAR(30) NOT NULL,
)
GO

-- 3. @title, @author гэсэн 2 parameter-тэй Books хүснэгт рүү өгөгдөл оруулдаг InsBook нэртэй SP бичих
CREATE OR ALTER PROC InsBook (
    @title NVARCHAR(100),
    @author NVARCHAR(30)
) AS
INSERT INTO Books 
VALUES
(@title, @author)
GO

-- 4. Дараах өгөгдүүдийг Books хүснэгтэнд InsBook SP-г ашиглан оруулах
InsBook N'Borland C++', N'Бат'
GO
InsBook N'Java', N'Хулан'
GO
InsBook N'ASP.NET with AJAX', N'Баатар'
GO
InsBook N'Java Beginner', N'Сүрэнжав'
GO
InsBook N'C#.NET', N'Онтгонбаяр'
GO
InsBook N'JSP advanced', N'Хүрэлсүх'
GO
InsBook N'Database programming', N'Хулан'
GO
InsBook N'Borland Delphi', N'Баатар'
GO

SELECT *
FROM Books
GO

-- 5. BookID-г өгөхөд тухайн номны нэр, зохиолчийг харуулдаг GetInfo гэсэн нэртэй SP бичих.
CREATE OR ALTER PROC GetInfo (
    @id INT
) AS
SELECT BookTitle, Author
FROM Books
WHERE BookID = @id
GO

-- 6. Номын зохиогчийн нэрийг өгөхөд тэр зохиолчийн бичсэн бүх номыг харуулдаг WriteBooks гэсэн нэртэй SP бичих.
CREATE OR ALTER PROC WriteBooks (
    @author NVARCHAR(30)
) AS
SELECT BookTitle
FROM Books
WHERE Author = @author
GO

-- 7. Зохиогчын нэр өгөхөд хэдэн ном бичсэнийг харуулах AuthorInfo нэртэй SP бичих.
CREATE OR ALTER PROC AuthorInfo (
    @author NVARCHAR(30)
) AS
SELECT [Бичсэн номын тоо] = COUNT(DISTINCT BookTitle)
FROM Books
WHERE Author = @author
GO

-- 8. Номын нэрийг өгөхөд тэр номыг устгадаг DelTitle нэртэй SP бичих.
CREATE OR ALTER PROC DelTitle (
    @title NVARCHAR(100)
) AS
DELETE FROM Books
WHERE BookTitle = @title
GO

-- 9. Номын BookID-г өгөхөд өгсөн дугаартай номыг устгадаг DelBook нэртэй SP бичих.
CREATE OR ALTER PROC DelTitle (
    @id INT
) AS
DELETE FROM Books
WHERE BookID = @id
GO

-- 10. Номын дугаар, нэр, зохиогчийг өгөөд номын дугаараар нь шүүлт хийж засдаг байх UpdBook нэртэй SP бичих.
CREATE OR ALTER PROC DelTitle (
    @id INT,
    @title NVARCHAR(100),
    @author NVARCHAR(30)
) AS
UPDATE Books
SET BookTitle = @title, Author = @author
WHERE BookID = @id
GO
