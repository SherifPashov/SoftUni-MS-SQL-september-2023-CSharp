--1
CREATE DATABASE [Minions]

USE[Minions]

--2 
CREATE TABLE [Minions](
	[Id] INT PRIMARY KEY 
	,[Name] NVARCHAR(50) NOT NULL
	,[Age] INT NOT NULL
)

CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY 
	,[Name] NVARCHAR(50) NOT NULL
)

--3

ALTER TABLE [Minions]
ADD [TownId] INT  FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL

--4

ALTER TABLE [Minions]
ALTER COLUMN [Age] INT
--Allow NULL Age

INSERT INTO [Towns]([Id],[Name])
	VALUES 
	(1 ,'Sofia'),
	(2 ,'Plovdiv'),
	(3 ,'Varna')

INSERT INTO [Minions]
	VALUES
	(1 ,'Kevin', 22, 1)
	,(2 ,'Bob', 15, 3)
	,(3 ,'Steward',NULL,2)

--5
TRUNCATE TABLE [Minions]
--delate table

--7

CREATE TABLE [People](
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX),
	CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(3, 2),
	-- (DECIMAL -,-- all 3 number 2 sled ,),
	[Weight] DECIMAL(5, 2),
	[Gender] CHAR(1) NOT NULL,
	CHECK ([Gender]='m' OR [Gender]='f'),
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR(MAX) 

)

INSERT INTO [People]([Name], [Height], [Weight], [Gender], [Birthdate])
	VALUES
	('Az', 1.70, 70.2, 'm', '2000-09-09'),
	('Pesho', 1.80, 80.6, 'm', '1988-03-08'),
	('Ivan',  1.83, 93.3,'m', '2005-02-25'),
	('Anna', 1.62, 50.6, 'f', '2003-07-18'),
	('Mariq', 1.65, 53.8, 'f', '2006-03-07')

	SELECT * FROM [People]


--8 

CREATE TABLE [Users](
 [Id] INT PRIMARY KEY IDENTITY,
 [Username] VARCHAR(30),
 [Password] VARCHAR(26),
 [ProfilePicture] VARBINARY(MAX),
 CHECK (DATALENGTH([ProfilePicture])<7200),
 [LastLoginTime] DATE NOT NULL,
 [IsDeleted] VARCHAR(5),
 CHECK ([IsDeleted]='true' OR [IsDeleted]= 'false')

)

INSERT INTO [Users] ([Username], [Password], [LastLoginTime], [IsDeleted])
	VALUES
		('Az','Password','2022-03-26','true'),
		('Pesho','Password','2022-09-23','true'),
		('Ivan','Password','2022-09-24','false'),
		('Anna','Password','2022-08-26','true'),
		('Mariq','Password','2022-09-26','false')


--13


CREATE TABLE Directors (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	DirectorName VARCHAR(255),
	Notes VARCHAR(MAX)
)

CREATE TABLE Genres(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	GenreName VARCHAR(255),
	Notes VARCHAR(MAX)
)

CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	CategoryName VARCHAR(255),
	Notes VARCHAR(MAX)
)

CREATE TABLE Movies(
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Title] VARCHAR(50),
	[DirectorId] INT FOREIGN KEY REFERENCES [Directors](Id),
	[CopyrightYear] SMALLINT,
	[Length] FLOAT,
	[GenreId] INT FOREIGN KEY REFERENCES [Genres](Id),
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories](Id),
	[Rating] DECIMAL(3,2),
	Notes VARCHAR(MAX)
)

INSERT INTO [Directors](DirectorName,Notes)
	VALUES
		('Pesho', 'Good'),
		('Ivan', 'Bad'),
		('Mariq', 'FLy'),
		('Rafie', 'Bye'),
		('Sherif', 'Hello')

INSERT INTO [Genres](GenreName,Notes)
	VALUES
		('Horror', 'OWH'),
		('Commedy', NULL),
		('Action', 'fight'),
		('Drama', NULL),
		('History', 'bad')


INSERT INTO [Categories](CategoryName,Notes)
	VALUES
		('c1', 'c1'),
		('c2', 'c2'),
		('c3', 'c3'),
		('c4', 'c4'),
		('c5', 'c5')


INSERT INTO [Movies](Title,DirectorId,CopyrightYear,Length,GenreId,CategoryId,Rating,Notes)
	VALUES
		('Die', 2, 1908, 1.86, 1, 1, 2.6,'da'),
		('Rocky', 3, 1960, 2.86, 2, 1, 7.8,'ne'),
		('Han', 4, 1964, 3.86, 1, 4, 1.4,'ops'),
		('Toplo', 1, 1990, 0.66, 3, 1, 3.2,'yep'),
		('Best', 5, 1983, 4.96, 1, 5, 2.4,'nop')


--14

CREATE TABLE [Categories](
	Id INT PRIMARY KEY IDENTITY,
	CategoryName VARCHAR(50) NOT NULL,
	DailyRate DECIMAL(3,2), 
	WeeklyRate DECIMAL(3,2), 
	MonthlyRate DECIMAL(3,2),
	WeekendRate DECIMAL(3,2)
)
CREATE TABLE [Cars](
	Id INT PRIMARY KEY IDENTITY , 
	PlateNumber INT, 
	Manufacturer INT, 
	Model VARCHAR(50), 
	CarYear SMALLINT, 
	CategoryId INT, 
	Doors INT, 
	Picture IMAGE, 
	Condition VARCHAR(50), 
	Available VARCHAR(50)
)
CREATE TABLE [Employees](
	Id INT PRIMARY KEY IDENTITY, 
	FirstName VARCHAR (50) NOT NULL, 
	LastName VARCHAR(50) NOT NULL, 
	Title VARCHAR(50),
	Notes VARCHAR(50)
)
CREATE TABLE [Customers](
	Id INT PRIMARY KEY IDENTITY,
	DriverLicenceNumber INT,
	FullName VARCHAR(50) NOT NULL,
	Address VARCHAR(MAX), 
	City VARCHAR(MAX), 
	ZIPCode INT NOT NULL,
	Notes VARCHAR(MAX)
) 
CREATE TABLE [RentalOrders](
	Id INT PRIMARY KEY IDENTITY, 
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	CustomerId INT FOREIGN KEY REFERENCES Customers(ID), 
	CarId INT FOREIGN KEY REFERENCES Cars(Id), 
	TankLevel INT,
	KilometrageStart INT ,
	KilometrageEnd INT , 
	TotalKilometrage INT ,
	StartDate DATE , 
	EndDate DATE ,
	TotalDays INT , 
	RateApplied DECIMAL(3,2), 
	TaxRate DECIMAL(3,2), 
	OrderStatus VARCHAR(MAX),
	Notes VARCHAR(MAX)
)

INSERT INTO Categories(CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate)
	VALUES
		('Da', 2.2, 3.3, 8.3, 2.5),
		('Ne', 3.2, 1.3, 5.3, 6.5),
		('Yep', 4.2, 6.3, 6.3, 4.5)

INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Condition, Available)
	VALUES
		(3,1,'Fs',1,2,1,'d3a','ne'),
		(2,2,'Ns',2,1,3,'d1a','Ne'),
		(1,3,'Ms',3,3,2,'d2a','nM')

INSERT INTO Employees(FirstName, LastName, Title , Notes)
	VALUES 
		('AZ','DQDA','We','AW'),
		('Ti','HaA','He','GR'),
		('Tq','WAwad','Ne','SE')

INSERT INTO Customers(DriverLicenceNumber, FullName, [Address], City, ZIPCode, Notes)
	VALUES 
	(1,'DA','Unas','SofH', 1030 ,'neQE'),
	(2,'zs','UAAas','SofG', 1020 ,'neQ'),
	(3,'AAAA','UFas','SofD', 1500 ,'neFQW')

INSERT INTO RentalOrders (EmployeeId, CustomerId)
	VALUES
	(2,3),
	(1,2),
	(3,1)


-- 15


CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY, 
	FirstName VARCHAR(50), 
	LastName VARCHAR(50),
	Title VARCHAR(50),
	Notes VARCHAR(MAX)
)

CREATE TABLE Customers (
	AccountNumber INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	PhoneNumber INT, 
	EmergencyName VARCHAR(50),
	EmergencyNumber INT, 
	Notes VARCHAR(MAX)
)

CREATE TABLE RoomStatus (
	RoomStatus VARCHAR(MAX), 
	Notes VARCHAR(MAX)
)

CREATE TABLE RoomTypes  (
	RoomType VARCHAR(MAX), 
	Notes VARCHAR(MAX)
)

CREATE TABLE BedTypes   (
	BedType VARCHAR(MAX), 
	Notes VARCHAR(MAX)
)

CREATE TABLE Rooms(
	RoomNumber INT PRIMARY KEY IDENTITY,
	RoomType VARCHAR(50),
	BedType VARCHAR(50),
	Rate DECIMAL(3,2),
	RoomStatus VARCHAR(50),
	Notes VARCHAR(50)
) 

CREATE TABLE Payments (
	Id INT PRIMARY KEY IDENTITY, 
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	PaymentDate DATE,
	AccountNumber INT, 
	FirstDateOccupied DATE,
	LastDateOccupied DATE , 
	TotalDays INT, 
	AmountCharged INT, 
	TaxRate DECIMAL (3,2), 
	TaxAmount DECIMAL (3,2),
	PaymentTotal DECIMAL (3,2), 
	Notes VARCHAR(50)
)

CREATE TABLE Occupancies (
	Id INT PRIMARY KEY IDENTITY, 
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id),
	DateOccupied DATE,
	AccountNumber INT,
	RoomNumber INT,
	RateApplied DECIMAL (3,2) ,
	PhoneCharge DECIMAL (3,2),
	Notes VARCHAR(50)
)


INSERT INTO Employees(FirstName,LastName)
	VALUES 
		('da','ne'),
		('d234a','n234e'),
		('ddsfa','n234e')

INSERT INTO Customers (FirstName, LastName)
	VALUES 
		('da','ne'),
		('d234a','n234e'),
		('ddsfa','n234e')

INSERT INTO RoomStatus(RoomStatus)
	VALUES
	('me'),
	('mawve'),
	('medwqv')

INSERT INTO RoomTypes(RoomType)
	VALUES
		('me'),
		('mawve'),
		('medwqv')

INSERT INTO BedTypes(BedType)
	VALUES
		('me'),
		('mawve'),
		('medwqv')

INSERT INTO Rooms(RoomType)
	VALUES
		('me'),
		('mawve'),
		('medwqv')

INSERT INTO Payments(TotalDays)
	VALUES
		(1),
		(13),
		(14)

INSERT INTO Occupancies(RoomNumber)
	VALUES
		(1),
		(13),
		(14)

--16

CREATE DATABASE SoftUni

CREATE TABLE Towns(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50)
)

CREATE TABLE Addresses(
	Id INT PRIMARY KEY IDENTITY,
	AddressText VARCHAR(MAX),
	TownId INT FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE Departments (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50)

)

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY, 
	FirstName VARCHAR(50),
	MiddleName VARCHAR(50),
	LastName VARCHAR(50),
	JobTitle VARCHAR(50),
	DepartmentId INT FOREIGN KEY REFERENCES Departments  (Id),
	HireDate VARCHAR(12),
	Salary DECIMAL(20,2),
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

INSERT INTO Towns
	VALUES
		('Sofia'),
		('Plovdiv'),
		('Varna'),
		('Burgas')

INSERT INTO Departments
	VALUES
		('Engineering'),
		('Sales'),
		('Software Development'),
		('Quality Assurance')

INSERT INTO Employees (FirstName, JobTitle,DepartmentId ,HireDate,Salary)
	VALUES 
		('Ivan Ivanov Ivanov', '.NET Developer', 4, '01-02-2013', 3500.00),
		('Petar Petrov Petrov', 'Senior Engineer', 1, '02-03-2004', 4000.00),
		('Maria Petrova Ivanova', 'Intern', 5, '28-08-2016', 525.25),
		('Georgi Teziev Ivanov', 'CEO', 2, '09-12-2007', 3000.00),
		('Peter Pan Pan', 'Intern', 3, '28-08-2016', 599.88)

--19
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

--20
SELECT 
* 
FROM Towns
ORDER BY [Name]

SELECT 
* 
FROM Departments
ORDER BY [Name]

SELECT 
* 
FROM Employees
ORDER BY [Salary] DESC

--21

SELECT 
[Name]
FROM Towns
ORDER BY [Name]

SELECT 
[Name] 
FROM Departments
ORDER BY [Name]

SELECT 
[FirstName],
[LastName],
[JobTitle],
[Salary]
FROM Employees
ORDER BY [Salary] DESC	

--22
UPDATE Employees
SET Salary*= 1.1

SELECT 
[Salary]
FROM Employees

--23

UPDATE Payments  
SET TaxRate*=0.97

SELECT 
TaxRate 
FROM Payments 

--24

DELETE FROM Occupancies 