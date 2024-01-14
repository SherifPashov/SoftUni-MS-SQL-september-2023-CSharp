--1
CREATE DATABASE Lab2

CREATE TABLE Passports
(
	PassportID INT PRIMARY KEY IDENTITY(101,1),
	PassportNumber NVARCHAR(25)
)


CREATE TABLE Persons
(
	PersonID INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(50),
	Salary DECIMAL(15,2),
	PassportID INT FOREIGN KEY REFERENCES Passports(PassportID)
)
INSERT INTO Passports(PassportNumber)
VALUES 
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO Persons (FirstName,Salary,PassportID)
VALUES
('Roberto',43300.00,102),
('Tom',56100.00,103),
('Yana',60200.00,101)

SELECT * FROM Persons


--2

CREATE TABLE Manufacturers
(
	ManufacturerID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50),
	EstablishedOn NVARCHAR(50),

)

CREATE TABLE Models
(
	ModelID INT PRIMARY KEY IDENTITY(101,1),
	[Name] NVARCHAR(50),
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO Manufacturers([Name],EstablishedOn)
VALUES
	('BMW','07/03/1916'),
	('Tesla','01/01/2003'),
	('Lada','01/05/1966')

INSERT INTO Models ([Name],ManufacturerID)
VALUES
	('X1',1),
	('i6',1),
	('Model S',2),
	('Model X',2),
	('Model 3',2),
	('Nova',3)


--3

CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50)
)

CREATE TABLE Exams
(
	ExamID INT PRIMARY KEY IDENTITY(101,1),
	[Name] NVARCHAR(50)
)

CREATE TABLE StudentsExams
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID)
	PRIMARY KEY (StudentID,ExamID)
)

INSERT INTO Students ([Name])
VALUES 
	('Mila'),
	('Toni'),
	('Ron')


INSERT INTO Exams([Name])
VALUES
	('SpringMVC'),
	('Neo4j'),
	('Oracle 11g')


INSERT INTO StudentsExams(StudentID,ExamID)
VALUES
	(1,101),
	(1,102),
	(2,101),
	(3,103),
	(2,102),
	(2,103)


--4

CREATE TABLE Teachers
(
	TeacherID INT PRIMARY KEY IDENTITY(101,1),
	[Name] NVARCHAR(50) NOT NULL,
	ManagerID INT REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers([Name],ManagerID)
VALUES
	('John', NULL),
	('Maya', 106),
	('Silvia', 106),
	('Ted', 105),
	('Mark', 101),
	('Greta' ,101)


--5
CREATE DATABASE ZAD5


CREATE TABLE Cities
(
	CityID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE ItemTypes
(
	ItemTypeID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50)NOT NULL
)

CREATE TABLE Items
(
	ItemID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE Customers
(
	CustomerID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	Birthday DATE NOT NULL,
	CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Orders
(
	OrderID INT PRIMARY KEY IDENTITY,
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)

CREATE TABLE OrderItems
(
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID)
	PRIMARY KEY (OrderID,ItemID)
)


--6

CREATE TABLE Subjects
(
	SubjectID INT PRIMARY KEY IDENTITY,
	SubjectName NVARCHAR(50)
)

CREATE TABLE Majors
(
	MajorID INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50)
)
CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY,
	StudentNumber INT,
	StudentName NVARCHAR(50),
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Payments
(
	PaymentID INT PRIMARY KEY IDENTITY,
	PaymentDate DATE,
	PaymentAmount FLOAT,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Agenda
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID)
	PRIMARY KEY (StudentID,SubjectID)
)


	



