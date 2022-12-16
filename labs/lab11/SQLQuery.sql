USE [master]
GO

-- 1. Dictionary өгөгдлийн санг үүсгэх.
IF DB_ID('Dictionary') IS NOT NULL
DROP DATABASE [Dictionary]
GO

CREATE DATABASE Dictionary
GO

USE Dictionary
GO


-- 2. Diction хүснэгтийг үүсгэх.
CREATE TABLE [Diction] (
    [Number] int IDENTITY PRIMARY KEY ,
    English nvarchar(100) UNIQUE NOT NULL ,
    Mongolian nvarchar(100) UNIQUE NOT NULL ,
    [Count] int ,
    CreatedDate smalldatetime,
    UpdatedDate smalldatetime ,
)
GO

-- 3. AddWord гэсэн нэртэй Stored Procedure үүсгэ. Энэ нь дараах нөхцлийн хангасан байх
--      • CreateDate, UpdateDate багануудад тухайн оруулж байгаа цагийг оруулах
--      • Count багана нь үг хайсныг тоолох учираас анхны утга нь 0 байна
--      • Амжилттай нэмсэн болон алдаа гарсан тохиолдолд мэдээлэл өгдөг байх
CREATE OR ALTER PROCEDURE AddWord (
    @EnglishWord nvarchar(100),
    @MongolianWord nvarchar(100),
    @Count int = 0
) AS
SET NOCOUNT ON;
BEGIN TRY
    BEGIN TRANSACTION

        INSERT INTO [Diction]
        VALUES
            (@EnglishWord, @MongolianWord, @Count, GETDATE(), GETDATE())

    IF @@TRANCOUNT > 0
        COMMIT TRANSACTION

    PRINT N'Амжилттай нэмэгдлээ.'
END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    PRINT N'Алдаа гарлаа.'

--     DECLARE @ErrorMessage nvarchar(1000), @ErrorSeverity int;
--     SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY();
--     RAISERROR(@ErrorMessage, @ErrorSeverity, 1)
END CATCH;
GO

-- 4. AddWord SP-г ашиглан 20 үг оруулах.
AddWord N'analyse', N'шинжлэх';
GO
AddWord N'anomaly', N'гажиг';
GO
AddWord N'anticipate', N'зөгнөх';
GO
AddWord N'ancestral', N'удмын';
GO
AddWord N'antipathy', N'дургүйцэх';
GO
AddWord N'apex', N'орой';
GO
AddWord N'apprehend', N'баривчлах';
GO
AddWord N'arbitrary', N'дураараа';
GO
AddWord N'arrogantly', N'дээрэнгүй';
GO
AddWord N'ascertain', N'нотлох';
GO
AddWord N'assail', N'довтлох';
GO
AddWord N'assess', N'үнэлэх';
GO
AddWord N'assimilate', N'нэгдэх';
GO
AddWord N'associate', N'холбогдох';
GO
AddWord N'augment', N'ихэсгэх';
GO
AddWord N'authority', N'захирах';
GO
AddWord N'battle', N'тулалдах';
GO
AddWord N'biased', N'алдаатай';
GO
AddWord N'candidate', N'горилогч';
GO
AddWord N'coerce', N'албадах';
GO

-- Error handling
AddWord N'coerce', N'албадах';
GO

SELECT *
FROM Diction
GO


-- 5. FindWord гэсэн үгийг монгол, ангилаар хайдаг SP үүсгэ. Дараах нөхцөлийг хангасан байна
--      • 2 parameter-тэй байна. Эхнийх нь хайх үг, 2 дахь нь ангилаас хайх уу? Монголоос хайх уу? Гэсэн төлөв байна
--      • Хайх бүрт Count багана нь 1-р өсдөг байна. Яагаад гэвэл хүн тухайн үгийг хэдэн удаа хайсныг хадгалдаг байх юм
--      • Хайлтын үр дүнд зөвхөн Бичлэгийн дугаар, Монгол, Англи гэсэн 2 багана харагдахаар хийнэ
--      • Хайлтыг Like ашиглан хайх үгээр эхэлсэн хойшоогоо дурын байхаар хийнэ үү
CREATE OR ALTER PROCEDURE FindWord (
    @Word nvarchar(100) = N'%',
    @Lang nvarchar(2) = N'EN'
) AS
SET NOCOUNT ON;
IF @Lang = N'MN'
    BEGIN
        UPDATE Diction
        SET [Count] += 1
        WHERE Mongolian LIKE (@Word + N'%');

        SELECT [Number], Mongolian, English
        FROM Diction
        WHERE Mongolian LIKE (@Word + N'%');

    END
ELSE IF @Lang = N'EN'
    BEGIN
        UPDATE Diction
        SET [Count] += 1
        WHERE English LIKE (@Word + N'%');

        SELECT [Number], English, Mongolian
        FROM Diction
        WHERE English LIKE (@Word + N'%');
    END
ELSE
    PRINT N'Та Монгол (MN) эсвэл Англи (EN) хэлний үгийг л завсарлах боломжтой.';
GO

FindWord N'г', N'MN'

SELECT *
FROM Diction
GO

-- 6. EditWord гэсэн үг засдаг SP үүсгэх. Дараах нөхцөлийг хангасан байна.
--      • 3 parameter-тэй байна. Эхнийх нь засах Number-н дугаар, 2 дахь нь засах үг, 3 дахь нь Монгол уу? Англи уу? Гэсэн төлөв
--      • Засах болгонд UpdatedDate багана тухайн агшины системийн цагийг авдаг байна.
--      • Амжилттай засагдсан болон алдаа гарсан үед мэдээлэл өгдөг байх
CREATE OR ALTER PROCEDURE EditWord (
    @Number int,
    @EditedWord nvarchar(100),
    @Lang nvarchar(2) = N'EN'
) AS
SET NOCOUNT ON;
IF @Lang = N'MN'
    BEGIN TRY
        UPDATE Diction
        SET Mongolian = @EditedWord, UpdatedDate = GETDATE()
        WHERE [Number] = @Number

        IF @@ROWCOUNT = 0
            BEGIN
                ROLLBACK TRANSACTION
                PRINT N'Таны оруулсан өгөгдөл байхгүй байна.'
            END
        ELSE IF @@TRANCOUNT > 0
            BEGIN
                COMMIT TRANSACTION
                PRINT N'Амжилттай засагдлаа.'
            END
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        PRINT N'Алдаа гарлаа.'
    END CATCH
ELSE IF @Lang = N'EN'
    BEGIN TRY
        UPDATE Diction
        SET English = @EditedWord, UpdatedDate = GETDATE()
        WHERE [Number] = @Number

        IF @@ROWCOUNT = 0
            BEGIN
                ROLLBACK TRANSACTION
                PRINT N'Таны оруулсан өгөгдөл байхгүй байна.'
            END
        ELSE IF @@TRANCOUNT > 0
            BEGIN
                COMMIT TRANSACTION
                PRINT N'Амжилттай засагдлаа.'
            END
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        PRINT N'Алдаа гарлаа.'
    END CATCH
ELSE
    PRINT N'Та Монгол (MN) эсвэл Англи (EN) хэлний үгийг л завсарлах боломжтой.';
GO

EditWord 20, N'enforce'
GO

EditWord 22, N'complex'
GO

SELECT *
FROM Diction
GO

-- 7. DeleteWord гэсэн үг устгадаг SP үүсгэх. Дараах нөхцөлийг хангасан байна.
--      • 1 parameter-тэй байна. Тэр нь тухай бичлэгийн дугаар байна
--      • Өгөгдлийг байгаа тохиолдолд устгана
--      • Амжилттай болон алдаа хийгдсэн мэдээлэл буцааж өгдөг байх
CREATE OR ALTER PROCEDURE DeleteWord (
    @Number int
) AS
SET NOCOUNT ON;
BEGIN TRY
    DELETE Diction
    WHERE [Number] = @Number

    IF @@ROWCOUNT = 0
        BEGIN
            ROLLBACK TRANSACTION
            PRINT N'Таны оруулсан өгөгдөл байхгүй байна.'
        END
    ELSE IF @@TRANCOUNT > 0
        COMMIT TRANSACTION
    ELSE
        PRINT N'Амжилттай засагдлаа.'
END TRY

BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    PRINT N'Алдаа гарлаа.'
END CATCH
GO

AddWord N'compress', N'шахах'
GO

DeleteWord 21
GO

SELECT *
FROM Diction
GO