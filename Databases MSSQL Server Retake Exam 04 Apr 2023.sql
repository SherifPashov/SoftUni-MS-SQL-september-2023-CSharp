CREATE DATABASE Accounting 

CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(10) NOT NULL
)

CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	StreetName NVARCHAR(20) NOT NULL,
	StreetNumber INT ,
	PostCode INT NOT NULL,
	City NVARCHAR(25) NOT NULL,
	CountryId INT FOREIGN KEY REFERENCES Countries(Id) NOT NULL
)

CREATE TABLE Vendors
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	NumberVAT NVARCHAR(15) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

CREATE TABLE Clients
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(25) NOT NULL,
	NumberVAT NVARCHAR(15) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Products
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(35) NOT NULL,
	Price DECIMAL(18,2),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	VendorId INT FOREIGN KEY REFERENCES Vendors(Id)
)


CREATE TABLE Invoices
(
	Id INT PRIMARY KEY IDENTITY,
	Number INT NOT NULL Unique,
	IssueDate DATETIME2 NOT NULL,
	DueDate DATETIME2 NOT NULL,
	Amount DECIMAL(18,2) NOT NULL,
	Currency NVARCHAR(5) NOT NULL,
	ClientId INT FOREIGN KEY REFERENCES Clients(Id)
)


CREATE TABLE ProductsClients
(
	ProductId INT FOREIGN KEY REFERENCES Products(Id),
	ClientId INT FOREIGN KEY REFERENCES Clients(Id)
	PRIMARY KEY (ProductId,ClientId)
)






--2

INSERT INTO Products([Name], Price, CategoryId, VendorId)
VALUES

('SCANIA Oil Filter XD01',78.69, 1, 1),
('MAN Air Filter XD01', 97.38, 1, 5),
('DAF Light Bulb 05FG87', 55.00, 2, 13),
('ADR Shoes 47-47.5', 49.85, 3, 5),
('Anti-slip pads S', 5.87, 5, 7)

INSERT INTO Invoices(Number, IssueDate, DueDate, Amount, Currency, ClientId)
VALUES
(1219992181, '2023-03-01', '2023-04-30',	180.96,	'BGN',	3),
(1729252340, '2022-11-06', '2023-01-04', 158.18, 'EUR', 13),
(1950101013, '2023-02-17', '2023-04-18', 615.15,'USD',19)


--3
UPDATE Invoices
SET DueDate = '2023-04-01'
WHERE YEAR(IssueDate) =2022 AND MONTH(IssueDate)=11

UPDATE Clients
SET AddressId=3
WHERE [Name] like '%CO%'

SELECT * FROM Invoices

--4

DELETE ProductsClients
WHERE ClientId IN(SELECT ClientId FROM Clients WHERE NumberVAT LIKE 'IT%')

DELETE Invoices --66 25
WHERE ClientId IN(SELECT ClientId FROM Clients WHERE NumberVAT LIKE 'IT%')

DELETE Clients
WHERE NumberVAT LIKE 'IT%'   --6

--5
SELECT 
Number
,Currency
FROM Invoices
ORDER BY Amount DESC,DueDate ASC

--6  5 OR 3
SELECT 
p.Id,
p.[Name],
p.Price,
c.[Name]
FROM Products p 
JOIN Categories c ON c.id=p.CategoryId
WHERE c.[Name] = 'ADR' OR c.[Name]='Others'
ORDER BY Price DESC

--7
SELECT 
cl.Id,
cl.[Name] as Client,
CONCAT(a.StreetName ,' ' ,a.StreetNumber, ', ', a.City, ', ', a.PostCode, ', ', co.[Name]) AS [Address]
FROM Clients cl
JOIN Addresses a ON a.Id = cl.AddressId
JOIN Countries co ON co.Id= a.CountryId
LEFT JOIN ProductsClients p ON p.ClientId=cl.Id
WHERE p.ProductId IS NULL
ORDER BY cl.[Name] ASC

--8

SELECT TOP(7)
i.Number,
i.Amount,
c.[Name] AS Client

FROM Invoices i
LEFT JOIN Clients c ON c.Id = i.ClientId
WHERE (i.IssueDate<'2023-01-01' AND i.Currency='EUR') OR (c.NumberVAT LIKE'DE%'and i.Amount>500 )
ORDER BY i.Number,i.Amount


--9
SELECT 
c.[Name],
MAX(p.Price) AS Price,
c.NumberVAT AS [VAT Number]
FROM Clients c
JOIN ProductsClients pc ON pc.ClientId=c.Id
JOIN Products p ON p.Id=pc.ProductId
WHERE c.[Name] NOT LIKE '%KG'
GROUP BY c.[Name],c.NumberVAT
ORDER BY MAX(p.Price) DESC

--10
SELECT 
c.[Name],
FLOOR(AVG(p.Price)) AS Price
FROM Clients c
LEFT JOIN ProductsClients pc ON pc.ClientId=c.Id
JOIN Products p ON p.Id=pc.ProductId
JOIN Vendors v ON v.Id=p.VendorId
WHERE v.NumberVAT LIKE '%FR%' AND pc.ClientId IS NOT NULL
GROUP BY c.Name
ORDER BY FLOOR(AVG(p.Price)),c.[Name] DESC

SELECT * FROM Products


--11

CREATE FUNCTION udf_ProductWithClients(@name NVARCHAR(30)) 
RETURNS INT 
AS
BEGIN 
	DECLARE @Result INT=
			(
				SELECT 
				COUNT(pc.ClientId)
				FROM Products p
				JOIN ProductsClients pc ON p.Id = pc.ProductId
				WHERE p.[Name] = @name

			)
	RETURN @Result

END


SELECT dbo.udf_ProductWithClients('DAF FILTER HU12103X')

--12 
CREATE PROCEDURE usp_SearchByCountry(@country NVARCHAR(50))
AS
	SELECT 
	v.[Name] Vendor,
	v.NumberVAT VAT,
	CONCAT(a.StreetName, ' ', a.StreetNumber) [Street Info],
	CONCAT( a.City,' ',a.PostCode) [City Info]
	FROM Vendors v
	JOIN Addresses a ON a.Id=v.AddressId
	JOIN Countries c ON c.Id=a.CountryId
	WHERE c.Name = @country





DROP TABLE ProductsClients
DROP TABLE Invoices
DROP TABLE Products
DROP TABLE Categories
DROP TABLE Clients
DROP TABLE Vendors
DROP TABLE Addresses
DROP TABLE Countries


