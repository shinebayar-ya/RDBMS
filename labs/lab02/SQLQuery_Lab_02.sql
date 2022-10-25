/*
	@author: x41
	Task #1 solution                                                                                        
*/

-- Good luck!!!
-- Execute following queries.

USE [master]
GO

-- T1.1 Create a CustomerDB database with specifying files
IF DB_ID ('CustomerDB') IS NOT NULL
DROP DATABASE CustomerDB
GO

CREATE DATABASE	CustomerDB
ON (
	NAME = CustomerDB_data,
	FILENAME = 'D:\customerdb_data.mdf',
	SIZE = 10,
	MAXSIZE = 50,
	FILEGROWTH = 5
) LOG ON (
	NAME = CustomerDB_log,
	FILENAME = 'D:\customerdb_log.ldf',
	SIZE = 5,
	MAXSIZE = 25,
	FILEGROWTH = 5
)
GO

SELECT *
FROM sys.databases
GO

-- T1.2 Create a SalesDB database with specifying files
IF DB_ID ('SalesDB') IS NOT NULL
DROP DATABASE SalesDB
GO

CREATE DATABASE	SalesDB
ON (
	NAME = SalesDB_data,
	FILENAME = 'D:\salesdb_data.mdf',
	SIZE = 10MB,
	MAXSIZE = 100MB,
	FILEGROWTH = 1MB
) LOG ON (
	NAME = SalesDB_log,
	FILENAME = 'D:\salesdb_log.ldf',
	SIZE = 5MB,
	MAXSIZE = 25MB,
	FILEGROWTH = 1MB
)
GO

SELECT *
FROM sys.databases
GO

-- T1.3.1 Create a snapshot of CustomerDB database
IF DB_ID ('Customer_dbss_1') IS NOT NULL
DROP DATABASE Customer_dbss_1
GO

CREATE DATABASE Customer_dbss_1
ON (
	NAME = CustomerDB_data,
	FILENAME = 'D:\customer_dbss_1.ss'
) AS SNAPSHOT OF CustomerDB
GO

SELECT *
FROM sys.databases
GO

-- T1.3.2 Create a snapshot of SalesDB database
IF DB_ID ('Sales_dbss_1') IS NOT NULL
DROP DATABASE Sales_dbss_1
GO

CREATE DATABASE Sales_dbss_1
ON (
	NAME = SalesDB_data,
	FILENAME = 'D:\sales_dbss_1.ss'
) AS SNAPSHOT OF SalesDB
GO

SELECT *
FROM sys.databases
GO

-- T2.1 Create NMIT database without specifying file
IF DB_ID ('NMIT') IS NOT NULL
DROP DATABASE [NMIT]
GO

CREATE DATABASE NMIT
GO

SELECT *
FROM sys.databases
GO

USE NMIT
GO

-- T2.2 Create Student table
IF OBJECT_ID ('Student') IS NOT NULL
DROP TABLE Student
GO

CREATE TABLE Student (
	ID int IDENTITY(100, 2),
	StudentCode varchar(10),
	StudentName nvarchar(20),
	StudentAge int CONSTRAINT CK_Student_StudentAge CHECK (StudentAge BETWEEN 19 AND 39),
	RegisterNum nvarchar(4),
	CONSTRAINT PK_Student_ID PRIMARY KEY (ID),
	CONSTRAINT UQ_Student_StudentCode UNIQUE (StudentCode)
)
GO

-- T2.3 View Student table details
EXEC sp_help Student
GO

-- T2.4 Create a new CHECK constraint on the 'StudentCode'
IF OBJECT_ID ('CK_Student_StudentCode_Prefix') IS NOT NULL
ALTER TABLE Student
DROP CONSTRAINT CK_Student_StudentCode_Prefix
GO

ALTER TABLE Student
ADD CONSTRAINT CK_Student_StudentCode_Prefix
CHECK(SUBSTRING(StudentCode, 1, 2) IN ('CS', 'SW', 'HW', 'SA'))
GO

-- T2.5 Create a new CHECK constraint on the 'StudentCode'
IF OBJECT_ID ('CK_Student_StudentCode_Length') IS NOT NULL
ALTER TABLE Student
DROP CONSTRAINT CK_Student_StudentCode_Length
GO

ALTER TABLE Student
ADD CONSTRAINT CK_Student_StudentCode_Length
CHECK(LEN(StudentCode) = 10)
GO

-- T2.6 Modify the data type of the 'RegisterNum' column
ALTER TABLE Student
ALTER COLUMN RegisterNum nvarchar(10)
GO

-- T2.7 Add a new 'Class' column
IF OBJECT_ID ('Class') IS NOT NULL
ALTER TABLE Student
DROP COLUMN Class
GO

ALTER TABLE Student
ADD Class varchar(20)
GO

-- T2.8 Create a new UNIQUE constraint on the 'RegisterNum' column
IF OBJECT_ID ('UQ_Student_RegisterNum') IS NOT NULL
ALTER TABLE Student
DROP CONSTRAINT UQ_Student_RegisterNum
GO

ALTER TABLE Student
ADD CONSTRAINT UQ_Student_RegisterNum
UNIQUE (RegisterNum)
GO

-- T2.9 Remove the 'RegisterNum' column from the table 'Student'
/*
ALTER TABLE Student
DROP CONSTRAINT UQ_Student_RegisterNum
GO
*/

ALTER TABLE Student
DROP COLUMN RegisterNum
GO

-- T2.10 Create a new table 'Test'
IF OBJECT_ID ('Test') IS NOT NULL
DROP TABLE Test
GO

CREATE TABLE Test (
	ID int,
	StudentID int,
	LessonName nvarchar(20),
	Mark int,
	CONSTRAINT PK_Test_ID PRIMARY KEY (ID),
	CONSTRAINT CK_Test_Mark_Between_1 CHECK (Mark BETWEEN 0 AND 100)
)
GO

EXEC sp_help Test
GO
-- T2.11 Create a new AUTO_INCREMENT constraint on the 'ID' column
/*
ALTER TABLE Test
DROP CONSTRAINT PK_Test_ID
*/

ALTER TABLE Test
DROP COLUMN ID
GO

ALTER TABLE Test
ADD ID int IDENTITY CONSTRAINT PK_Test_ID PRIMARY KEY (ID)
GO

EXEC sp_help Test

-- T2.12 Create a new FOREIGN KEY CONSTRAINT on the 'StudentID' column 
-- REFERENCES the ID column f
IF OBJECT_ID ('FK_Test_StudentID') IS NOT NULL
ALTER TABLE Test
DROP CONSTRAINT FK_Test_StudentID
GO

ALTER TABLE Test
ADD CONSTRAINT FK_Test_StudentID
FOREIGN KEY (StudentID) REFERENCES Student(ID)
GO

-- T2.13 Change the data type of the column named 'LessonName' in the 'Test' table
ALTER TABLE Test
ALTER COLUMN LessonName nvarchar(50)

-- T2.14 Create a CHECK constraint on the 'Mark' column
IF OBJECT_ID ('CK_Test_Mark_Between_2') IS NOT NULL
ALTER TABLE Test
DROP CONSTRAINT CK_Test_Mark_Between_2
GO

ALTER TABLE Test
ADD CONSTRAINT CK_Test_Mark_Between_2
CHECK (Mark BETWEEN 0 AND 800)
GO

ALTER TABLE Test
DROP CONSTRAINT CK_Test_Mark_Between_1
GO

-- T2.15 Create a snapshot of NMIT database
CREATE DATABASE NMIT_dbss_1
ON (
	NAME = NMIT,
	FILENAME = 'D:\nmit_dbss_1.ss'
) AS SNAPSHOT OF NMIT;

-- T2.16 Remove the 'Student' and 'Test' tables
/*
ALTER TABLE Test
DROP CONSTRAINT FK_Test_StudentID
GO
*/
DROP TABLE Student
GO

DROP TABLE Test
GO

-- T2.17 Restore a database using the database snapshot
USE [master]
GO

RESTORE DATABASE NMIT
FROM DATABASE_SNAPSHOT = 'NMIT_dbss_1'
GO