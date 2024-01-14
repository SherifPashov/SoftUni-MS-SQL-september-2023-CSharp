CREATE DATABASE TouristAgency 

CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Destinations
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	CountryId INT FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Rooms
(
	Id INT PRIMARY KEY IDENTITY,
	[Type] NVARCHAR(40) NOT NULL,
	Price Decimal(18,2) NOT NULL,
	BedCount INT NOT NULL --0-10
)

CREATE TABLE Hotels
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	DestinationId INT FOREIGN KEY REFERENCES Destinations(Id)
)

CREATE TABLE Tourists
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(80) NOT NULL,
	PhoneNumber NVARCHAR(20) NOT NULL,
	Email NVARCHAR(80) NOT NULL,
	CountryId INT FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Bookings
(
	Id INT PRIMARY KEY IDENTITY,
	ArrivalDate DateTime2 NOT NULL,
	DepartureDate DATETIME2 NOT NULL,
	AdultsCount INT NOT NULL,
	ChildrenCount INT NOT NULL,
	TouristId INT FOREIGN KEY REFERENCES Tourists(Id),
	HotelId INT FOREIGN KEY REFERENCES Hotels(Id),
	RoomId INT FOREIGN KEY REFERENCES Rooms(Id)
)

CREATE TABLE HotelsRooms
(
	HotelId INT FOREIGN KEY REFERENCES Hotels(Id),
	RoomId INT FOREIGN KEY REFERENCES Rooms(Id)
	PRIMARY KEY (HotelId,RoomId)
)

--2 
INSERT INTO Tourists([Name],PhoneNumber,Email,CountryId)
VALUES 
('John Rivers', '653-551-1555', 'john.rivers@example.com', 6),
('Adeline Aglaé', '122-654-8726', 'adeline.aglae@example.com', 2),
('Sergio Ramirez', '233-465-2876', 's.ramirez@example.com', 3),
('Johan Müller', '322-876-9826', 'j.muller@example.com', 7),
('Eden Smith', '551-874-2234', 'eden.smith@example.com', 6)


INSERT INTO Bookings(ArrivalDate, DepartureDate, AdultsCount, ChildrenCount, TouristId, HotelId, RoomId)
VALUES

('2024-03-01', '2024-03-11', 1,	0,	21,	3,	5),
('2023-12-28', '2024-01-06', 2,	1,	22,	13,	3),
('2023-11-15', '2023-11-20', 1,	2,	23,	19,	7),
('2023-12-05', '2023-12-09', 4,	0,	24,	6,	4),
('2024-05-01', '2024-05-07', 6,	0,	25,	14,	6)


--3
UPDATE Bookings
SET DepartureDate = DATEADD(DAY, 1, DepartureDate)
WHERE YEAR(DepartureDate) =2023 AND MONTH(DepartureDate)=12

UPDATE Tourists
SET Email = NULL
WHERE [Name] LIKE '%MA%'

--4

DELETE Tourists




DELETE Bookings
WHERE TouristId = 6 OR  TouristId=16 or  TouristId=25 --4,1



DELETE Tourists
WHERE [Name] LIKE '%Smith%'  --6,16

SELECT *FROM Hotels h
JOIN HotelsRooms hr ON hr.HotelId=h.Id




--5
SELECT 
FORMAT(b.ArrivalDate,'yyyy-MM-dd' ),
AdultsCount,
ChildrenCount
FROM Bookings b
JOIN Rooms r ON b.RoomId = r.Id
ORDER BY r.Price DESC,ArrivalDate

--6
SELECT h.Id,Name FROM Hotels h
JOIN HotelsRooms hr ON h.Id = hr.HotelId
JOIN Rooms r ON r.Id = hr.RoomId
JOIN Bookings b ON b.HotelId=h.Id 
WHERE r.Type='VIP apartment' 
GROUP BY h.Id,[Name]
ORDER BY COUNT(b.Id) DESC;



--7
SELECT 
t.Id,
t.[Name],
t.PhoneNumber
FROM Tourists t
LEFT JOIN Bookings b ON b.TouristId=t.Id
WHERE b.TouristId IS NUll
ORDER BY t.[Name] 

--8

SELECT TOP (10)
h.[Name] as HotelName,
d.[Name],
c.[Name]
FROM Bookings b
JOIN Hotels h ON h.Id=b.HotelId
JOIN Destinations d ON d.Id=h.DestinationId
Join Countries c ON c.id=d.CountryId
WHERE ArrivalDate<'2023-12-31' AND (h.Id % 2) <> 0
ORDER BY c.[Name],ArrivalDate 

--9



SELECT  h.[Name] [HotelName],
		r.Price [RoomPrice]
  FROM Tourists t
 JOIN Bookings b ON b.TouristId=t.Id
 JOIN  Hotels h ON b.HotelId=h.Id
 JOIN Rooms r ON r.Id=b.RoomId
 WHERE t.[Name] NOT LIKE '%EZ'
 ORDER BY r.Price DESC



--10


SELECT
h.[Name],
SUM(DATEDIFF(DAY, b.ArrivalDate, b.DepartureDate)*r.Price) AS HotelRevenue
FROM Hotels h
JOIN Bookings b ON b.HotelId = h.Id 
JOIN Rooms r ON r.Id = b.RoomId
GROUP BY h.[Name]
ORDER BY HotelRevenue DESC


--11
CREATE FUNCTION udf_RoomsWithTourists(@name NVARCHAR(50)) 
RETURNS INT 
BEGIN 
	RETURN 
	(
		SELECT 
		SUM(b.AdultsCount)+
		SUM(b.ChildrenCount)
		FROM Rooms r
		JOIN Bookings b ON b.RoomId=r.Id
		JOIN Tourists t ON t.Id = b.RoomId
		WHERE r.Type=@name
	)
	
	
END

SELECT dbo.udf_RoomsWithTourists ('Double Room')
--12 reaal

CREATE PROCEDURE usp_SearchByCountry
@country NVARCHAR(50)
AS
	SELECT 
	t.[Name],
	t.PhoneNumber,
	t.Email,
	COUNT(b.TouristId) AS CountOfBookings
	FROM Tourists t
	JOIN Countries c ON c.Id=t.Id
	JOIN Bookings b ON b.TouristId=t.Id
	WHERE c.Name = @country
	GROUP BY t.[Name],t.PhoneNumber,t.Email,b.TouristId
	ORDER BY t.[Name],COUNT(b.TouristId) DESC

	


DELETE HotelsRooms
DELETE Bookings
DELETE Tourists
DELETE Hotels
DELETE Rooms
DELETE Destinations
DELETE Countries

--10,11,12