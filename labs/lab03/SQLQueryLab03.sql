/*
		@author: x41
		Task #2 solutions
*/

USE [master]
GO
-- 1.	EmpDB өгөгдлийн санг үүсгэх.
IF DB_ID ('EmpDB') IS NOT NULL
DROP DATABASE EmpDB
GO

CREATE DATABASE EmpDB
GO

USE EmpDB
GO

-- 2.	EmpRegister хүснэгтийг үүсгэх.
IF OBJECT_ID ('EmpRegister') IS NOT NULL
DROP TABLE EmpRegister
GO

CREATE TABLE EmpRegister (
	ID INT IDENTITY PRIMARY KEY,
	[Last Name] NVARCHAR(20) CONSTRAINT DF_EmpRegister_Last_Name DEFAULT N'.Н',
	[First Name] NVARCHAR(20),
	Age TINYINT CONSTRAINT CK_EmpRegister_Age CHECK(18 < Age AND Age < 40),
	[Hired Date] DATETIME CONSTRAINT DF_EmpRegister_Hired_Date DEFAULT GETDATE()
)
GO

-- 3.	EmpCode - char(8) баганыг EmpRegister хүснэгтэд нэмж оруулах.
ALTER TABLE EmpRegister
ADD [Emp Code] char(8)
GO

-- 4.	EmpCode баганын өгөгдөл ‘EMP’ гэсэн үсгээр эхэлсэн байх нөхцөлийг нэмж өгөх.
ALTER TABLE EmpRegister
ADD CONSTRAINT CK_EmpRegister_Emp_Code
CHECK([Emp Code] LIKE N'EMP%')
GO

-- 5.	EmpCode баганын өгөгдөл давхардахгүй нөхцөлийг нэмж өгөх.
ALTER TABLE EmpRegister
ADD CONSTRAINT UQ_EmpRegister_Emp_Code
UNIQUE ([Emp Code])
GO

-- 6.	Age баганыг устгах.
/*
ALTER TABLE EmpRegister
DROP CONSTRAINT CK_EmpRegister_Age
GO
*/

ALTER TABLE EmpRegister
DROP COLUMN Age
GO

-- 7.	TimeSheet хүснэгтийг үүсгэх.
CREATE TABLE TimeSheet (
	Number INT IDENTITY PRIMARY KEY,
	[Emp ID] INT CONSTRAINT FK_TimeSheet_Emp_ID FOREIGN KEY REFERENCES EmpRegister(ID),
	[Time In] DATETIME CONSTRAINT DF_TimeSheet_Time_In DEFAULT GETDATE(),
	[Time Out] DATETIME CONSTRAINT DF_TimeSheet_Time_Out DEFAULT GETDATE()
)
GO

-- 8.	Flag nchar(1) null өгөгдөл орохгүй багана TimeSheet хүснэгтэд нэмж оруулах.
ALTER TABLE TimeSheet
ADD Flag nchar(1)
GO

-- 9.	Flag баганад зөвхөн 'И','Ч','Ө','Т','О','Х' гэсэн өгөгдөл орох нөхцөлийг нэмж өгөх.
ALTER TABLE TimeSheet
ADD CONSTRAINT CK_TimeSheet_Flag
CHECK(Flag IN (N'И', N'Ч', N'Ө', N'Т', N'О', N'Х'))
GO

-- 10.	Дараах өгөгдлүүдийг EmpRegister хүснэгтэд оруулах.
SELECT *
FROM EmpRegister
GO

INSERT INTO EmpRegister ([Last Name], [First Name], [Emp Code], [Hired Date])
VALUES
(N'Бат',        N'Цэцэг',	    'EMP00012',	'2005/10/23'),
(N'Дорж',       N'Алимаа',	    'EMP00014',	'2006/01/14'),
(N'Алтанхуяг',  N'Хишигээ',	    'EMP00100',	'2006/02/01'),
(N'Ганбаяр',    N'Нарансолонго','EMP00230',	'2007/11/11'),
(N'Төмөр',      N'Батхишиг',	'EMP00001',	'2008/11/12'),
(N'Дондог',     N'Баярсолонго',	'EMP00043',	'2009/07/18')
GO

-- 11.	Дараах өгөгдлүүдийг TimeSheet хүснэгтэд оруулах.
SELECT *
FROM TimeSheet
GO

INSERT INTO TimeSheet 
VALUES
(1,	'2009/02/20 08:10',	'2009/02/20 19:23',	N'И'),
(3,	'2009/02/20 08:40',	'2009/02/20 19:24',	N'И'),
(2,	'2009/02/20 08:56',	'2009/02/20 18:00',	N'И'),
(4,	'2009/02/20 09:04',	'2009/02/20 20:15',	N'Х'),
(6,	'2009/02/20 09:10',	'2009/02/20 18:29',	N'Х'),
(5,	'2009/02/21 08:57',	'2009/02/21 18:10',	N'И'),
(1,	'2009/02/21 08:59',	'2009/02/21 19:14',	N'И'),
(3,	'2009/02/21 08:59',	'2009/02/21 22:30',	N'И'),
(4,	'2009/02/21 09:00',	'2009/02/21 18:04',	N'И'),
(2,	'2009/02/21 09:00',	'2009/02/21 09:00',	N'Ө'),
(6,	'2009/02/21 10:27',	'2009/02/21 18:10',	N'Х'),
(1,	'2009/03/01 09:00',	'2009/03/01 09:00',	N'Ч'),
(2,	'2009/03/01 09:00',	'2009/03/01 09:00',	N'О'),
(3,	'2009/03/01 09:00',	'2009/03/01 09:00',	N'О'),
(4,	'2009/03/01 08:00',	'2009/03/01 18:20',	N'И'),
(5,	'2009/03/01 09:10',	'2009/03/01 17:23',	N'Х'),
(6,	'2009/03/01 09:34',	'2009/03/01 17:56',	N'Х')
GO

-- 12.	2008 оноос өмнө орсон ажилчдын нэрсийг харуулах.
SELECT [First Name]
FROM EmpRegister
WHERE YEAR([Hired Date]) < 2008 
GO

-- 13.	Ажилчдын ажилласан жилийг харуулах.
SELECT *, DATEDIFF(year, [Hired Date], GETDATE()) AS [Ажилласан жил]
FROM EmpRegister
GO

-- 14.	Б үсгээр эхэлсэн ажилчдыг тоолох.
SELECT COUNT(*) AS [Б үсгээр эхэлсэн ажилчдын тоо]
FROM EmpRegister
WHERE [First Name] LIKE N'Б%'
GO

-- 15.	Ажилчдын нэрсийг эцгийн нэрийн эхний үсэг (.) нэр гэсэн хэлбэртэйгээр харуулах. Ж нь: Б.Цэцэг гэх мэт.
SELECT [Ажилчдын нэрс] = LEFT([Last Name], 1) + '.' + [First Name]
FROM EmpRegister
GO

-- 16.	Ажилчдын ажилд орсон зөвхөн жилүүдийг нь харуулах. Ж нь: 2007 гэх мэт.
SELECT *, YEAR([Hired Date]) AS [Ажилд орсон жил]
FROM EmpRegister
GO

-- 17.	Ажилчдын кодоор нь буурахаар эрэмбэлж харуулах.
SELECT *
FROM EmpRegister
ORDER BY [Emp Code] DESC
GO

-- 18.	2009.02.21 -нд бүртгэсэн цагийн бүртгэлийг харуулах.
SELECT *
FROM TimeSheet
WHERE CAST([Time In] AS DATE) = '2009/02/21'
GO

-- 19.	Бүх цагийн бүртгэлээс ажилд ирсэн (И) ажилчдын цагийн бүртгэлийг харуулах.
SELECT * 
FROM TimeSheet
WHERE Flag LIKE N'И'
GO

-- 20.	Ажилтан тус бүрийн ажилдаа хоцорсон тоонуудыг харуулах.
SELECT [Emp ID], COUNT(Flag) AS [Хоцорсон тоо]
FROM TimeSheet
WHERE Flag LIKE N'Х'
GROUP BY [Emp ID]
GO

-- 21.	Нэг ч удаа хоцорч байгаагүй ажилтнуудыг харуулах.
SELECT DISTINCT [Emp ID]
FROM TimeSheet
WHERE [Emp ID] NOT IN (
	SELECT [Emp ID]
	FROM TimeSheet
	WHERE Flag LIKE N'Х'
	GROUP BY [Emp ID]
)
GO


-- 22.	Ажилчид 9:00 ажилдаа ирэх ёстой бол хоцорсон ажилчдын хэзээ хэдэн минут хоцорсныг харуулах.
SELECT *, DATEDIFF(minute, '09:00', FORMAT([Time In], N'HH:mm')) AS [Хоцорсон минут]
FROM TimeSheet
WHERE Flag LIKE N'Х'
GO

-- 23.	Ажилчид 18:00 цагт ажлаас буух ёстой бол ажлаас эрт буусан ажилчдын минутыг харуулах.
SELECT *, DATEDIFF(minute, FORMAT([Time Out], N'HH:mm'), '18:00') AS [Эрт буусан минут]
FROM TimeSheet
WHERE FORMAT([Time Out], N'HH:mm') < '18:00' AND FORMAT([Time Out], N'HH:mm') <> '09:00'
GO

-- 24.	Ажилчид бүр нийт хэдэн минут хоцорсныг харуулах.
SELECT [Emp ID], SUM(DATEDIFF(minute, '09:00', FORMAT([Time In], N'HH:mm'))) AS [Нийт хоцорсон минут]
FROM TimeSheet
WHERE Flag LIKE N'Х'
GROUP BY [Emp ID]
GO

-- 25.	Хамгийн их хоцорсон нэг ажилтанг харуулах.
SELECT TOP 1 [Emp ID]
FROM TimeSheet
WHERE Flag LIKE N'Х'
GROUP BY [Emp ID]
ORDER BY COUNT(Flag) DESC
GO