# Laboratory notes

## Laboratory #1 note

SQL Server -тэй хэрхэн connection үүсгэх буюу холболт хийх талаар үзсэн тэгэхдээ login буюу нэвтрэхдээ 2 төрлийн authentication байдаг гэж үзсэн.

- Windows authentication
- SQL Server Login authentication

<b>Windows auth</b> гэдэг нь бид нарын computer username, password -г ашиглан холболтыг үүсгэж байгаа гэсэн үг юм.

Харин, <b>SQL Server Login auth</b> гэдэг нь login name, login password -г ашиглан холболтыг үүсгэдэг. Бидний жишээнд системийн бүх database -д хандах эрхтэй sa (Super admin) login -оор нэвтрэхийг үзсэн бөгөөд хэрвээ basic -аар суулгасан тохиодолд энэ нь идэвхгүй байдаг тул хэрхэн SQL Server auth and Windows auth mixed mode -г идэвхжүүлэх, sa login -ийг хэрхэн идэвхжүүлэх, мөн password -г хэрхэн тодорхойлохыг үзсэн. Зарим ангиудад new login үүсгэж түүгээрээ нэвтрэн ямар нэгэн эрх өгөөгүй гэдгийн харуулсан.

Үүний дараа бид AdventureWorks гэх сургалтанд ашиглагддаг бодит database -д дараах үйлдлүүдийг сурсан:

    RESTORE
    ATTACH
    DETACH

үйлдлүүдийг UI ашиглан буюу mouse -аа ашиглан menu, panel, window зэргүүдээс сонголтуудыг сонгон эдгээр үйлдлүүдийг хийж сурсан.

Дараа нь, Design Query in Editor гэх tool -ын тусламжтайгаар анхны query -г generate буюу үүсгэсэн түүнийгээ execute буюу ажлуулж үр дүнг харсан. Мөн зарим нэг AGGREGATE function -г яаж ашиглахыг сурсан.

Үүний дараа оюутнууд өгөгдсөн лаборатори дасгалыг хийж, query -г үүсгэж ажлуулж үзсэн.

## Laboratory #2 note

Өмнөх лабораторийг ажлыг хэрхэн хийх байсан талаар жишээ болгон үзүүлсэн болон өмнөх лаб -д үзсэн ойлголтыг сэргээсэн.
Database -д дараах шинээр үйлдлийг хийж сурсан.

    CREATE
    DROP
    BACK UP

Өмнөх лаборатори дээр хийгдсэн restore, attach, detach үйлдлүүдийг query ашиглан хийж сурсан.

### Database үүсгэхдээ:

- default байдлаар буюу SIZE = 8MB, MAXSIZE = 8MB, FILEGROWTH = 64MB
- data болон transaciton log файлуудыг өөрөө тодорхойлсон.
- олон data болон transaction log файлуудыг тодорхойлсон primary file эхэнд байрлах файл бөгөөд өргөтгөл нь (.mdf), secondary data файлууд нь (.ndf), log файл (.ldf) гэсэн 3 өргөтгөлийг database -т ашиглагддаг гэж үзсэн.
- filegroup ашигласан /нэг файл зөвхөн filegroup -д хамаарна. Холбоо хамааралтай файлууд нэг filegroup -д харьяалагдана/

Snapshot буюу db хуулбар (read-only database) үүсгэж сурсан.
database -г хэрхэн backup хийдгийг үзсэн.

Үүний дараа оюутнууд лабораторийн ажлын эхний хэсгийг гүйцэтгэсэн.

Дараа нь, table хэрхэн үүсгэх талаар үзсэн бөгөөд attribute буюу баганууд нь ямар өгөгдлийн төрөлтэй зарлагддаг мөн зарим нэг 'CONSTRAINT' буюу table -д өгөгдлөл орохдоо зарим шаардлагыг хангасан байх хязгаарлалтуудын талаар үзсэн. Table -ийн дэлгэрэнгүй мэдээллийг харах болон үүссэн table -д хэрхэн багана нэмэх, баганануудад constraint үүсгэх, устах талаар үзсэн.

Даалгаварт лабораторийн ажлын 2-р хэсгийг өгсөн.

## Laboratory #3 note

Өмнөх лабораторийн ажлыг хэрхэн хийх байсан талаар үзсэн. Даалгавр бүрийг нэг бүрчлэн хийж харуулсан. Лекцээр үзсэн CONSTRAINT ойлголтыг хийж үзүүлсэн.

Дараах constraint -уудыг үзсэн:

    NOT NULL
    UNIQUE
    PRIMARY KEY
    CHECK (expression)
    FOREIGN KEY
    AUTO_INCREMENT OR IDENTITY (seed, increment)

Дараах function -уудыг үзсэн:

    LEFT(string, number_of_chars)
    LEN(string)

Дараах operator -уудыг үзсэн:

    OR
    AND
    IN (value1, value2, ...)
    BETWEEN value1 AND value2

Даалгаварт Лаб №3 -г өгсөн.

## Laboratory #4 note

## Laboratory #5 note

## Laboratory #6 note

## Laboratory #7 note

## Laboratory #8 note

## Laboratory #9 note

## Laboratory #10 note

## Laboratory #11 note

## Laboratory #12 note
