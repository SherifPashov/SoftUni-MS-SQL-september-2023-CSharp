-- Sction 1. DDL
CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE Creators(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(30) NOT NULL,
)

CREATE TABLE PlayersRanges(
	Id INT PRIMARY KEY IDENTITY,
	PlayersMin INT NOT NULL,
	PlayersMax INT NOT NULL
)

CREATE TABLE Addresses(
	Id INT PRIMARY KEY IDENTITY,
	StreetName NVARCHAR(100) NOT NULL,
	StreetNumber INT NOT NULL,
	Town NVARCHAR(30) NOT NULL,
	Country NVARCHAR(50) NOT NULL,
	ZIP INT NOT NULL
)

CREATE TABLE Publishers(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) UNIQUE NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id),
	Website NVARCHAR(40) NOT NULL,
	Phone NVARCHAR(20) NOT NULL
)

CREATE TABLE Boardgames(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(30) NOT NULL,
	YearPublished INT NOT NULL,
	Rating DECIMAL(4,2) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	PublisherId INT FOREIGN KEY REFERENCES Publishers(Id),
	PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges(Id)
)

CREATE TABLE CreatorsBoardgames(
	CreatorId INT FOREIGN KEY REFERENCES Creators(Id),
	BoardgameId INT FOREIGN KEY REFERENCES Boardgames(Id),
	PRIMARY KEY(CreatorId, BoardgameId)
)



-- Section 2 - Insert
INSERT INTO Boardgames
			([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
	VALUES	('Deep Blue', 2019, 5.67, 1, 15, 7),
			('Paris', 2016, 9.78, 7, 1, 5),
			('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
			('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
			('One Small Step', 2019, 5.75, 5, 9, 2)

INSERT INTO Publishers 
			([Name], AddressId, Website, Phone)
	 VALUES ('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
			 ('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
			 ('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')


-- Update
UPDATE PlayersRanges
SET PlayersMax += 1
WHERE PlayersMin = 2 and PlayersMax = 2

UPDATE Boardgames
SET [Name] = [Name] + 'V2'
WHERE YearPublished >= 2020


-- Delete
DELETE FROM CreatorsBoardgames WHERE BoardgameId in (1,16,31,47)
DELETE FROM Boardgames WHERE PublisherId in (1, 16)
DELETE FROM Publishers WHERE AddressId = 5
DELETE FROM Addresses WHERE LEFT(Town, 1) = 'l'

-- Quering
SELECT
	[Name], Rating 
FROM Boardgames
ORDER BY
	YearPublished,[Name] DESC

-- Boardgames by category
SELECT 
	b.Id, b.[Name], YearPublished, 
	c.[Name][CategoryName] 
FROM Boardgames b
JOIN
	Categories c ON c.Id = b.CategoryId
WHERE
	c.[Name] in ('Strategy Games', 'Wargames')
ORDER BY
	YearPublished DESC

-- Creators with boardgames - subquery
SELECT
	Id, 
	CONCAT_WS(' ', FirstName, LastName)[CreatorName], 
	Email
FROM
	Creators
WHERE id NOT IN(
				SELECT CreatorId FROM CreatorsBoardgames
				)
-- Creators with boardgames - left join
SELECT
	Id, 
	CONCAT_WS(' ', FirstName, LastName)[CreatorName], 
	Email
FROM Creators c
LEFT JOIN
	CreatorsBoardgames cb ON cb.CreatorId = c.Id
WHERE
	cb.BoardgameId IS NULL

-- 8. First 5 boardgames
SELECT TOP(5) 
	bg.[Name], 
	Rating, 
	cat.[Name] AS CategoryName
FROM 
	Boardgames AS bg
JOIN 
	Categories AS cat ON bg.CategoryId = cat.Id
JOIN 
	PlayersRanges as pr ON bg.PlayersRangeId = pr.Id
WHERE Rating > 7
	AND (bg.[Name] LIKE '%a%' OR Rating > 7.50)
	AND PlayersMin >= 2
	AND PlayersMax <= 5
ORDER BY bg.[Name], Rating DESC

-- 9. Creators with emails
SELECT 
	FullName, Email, Rating FROM
	(SELECT 
		CONCAT_WS(' ', FirstName, LastName)[FullName],  
		Email, bg.Name, bg.Rating,
		RANK() OVER (PARTITION BY Email ORDER BY rating DESC) AS GameRating
	FROM Creators c
	JOIN
		CreatorsBoardgames cbg ON cbg.CreatorId = c.Id
	JOIN
		Boardgames bg ON bg.Id = cbg.BoardgameId
	WHERE RIGHT(Email, 4) = '.com' ) AS subq
where GameRating = 1

-- 9. Creators with emails(WITH CTE)
WITH RankedCreators AS (
    SELECT
        CONCAT_WS(' ', FirstName, LastName) AS FullName,
        Email,
        bg.Name,
        bg.Rating,
        RANK() OVER (PARTITION BY Email ORDER BY bg.Rating DESC) AS GameRank
    FROM
        Creators c
    JOIN
        CreatorsBoardgames cbg ON cbg.CreatorId = c.Id
    JOIN
        Boardgames bg ON bg.Id = cbg.BoardgameId
    WHERE
        Email LIKE '%.com'
)
SELECT
    FullName,
    Email,
    Rating
FROM
    RankedCreators
WHERE
    GameRank = 1;


--10. Creators by rating
SELECT
	c.LastName, 
	CEILING(AVG(b.Rating)) AS AverageRating, 
	p.[Name]
FROM  
	Creators AS c
JOIN 
	CreatorsBoardgames AS cb ON c.Id=cb.CreatorId
JOIN
	Boardgames AS b ON cb.BoardgameId=b.Id
JOIN 
	Publishers AS p ON b.PublisherId=p.Id
WHERE 
	p.[Name]='Stonemaier Games'
GROUP BY 
	c.LastName, p.[Name]
ORDER BY 
	AVG(b.Rating) DESC

-- 11. Creators with boardgames
CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(50)) 
RETURNS INT
AS
BEGIN
	DECLARE @total INT =
	(SELECT COUNT(BoardgameId) 
	FROM
		CreatorsBoardgames cbg
	JOIN
		Creators c ON c.Id = cbg.CreatorId
	where 
		c.FirstName = @name)

	RETURN @total
END

-- 12. Search for a baordgae in category
CREATE PROCEDURE usp_SearchByCategory
@category NVARCHAR(30)
AS

DECLARE @categoryId INT = 
	(SELECT Id 
	FROM Categories
	WHERE [Name] = @category)

SELECT 
	bg.[Name], bg.YearPublished, bg.Rating, 
	@category[CategoryName], p.[Name][PublisherName], 
	CONCAT_WS(' ', pr.PlayersMin, 'people')[MinPlayers],
	CONCAT_WS(' ', pr.PlayersMax, 'people')[MaxPlayers]
FROM
	Boardgames bg
JOIN 
	Publishers p ON bg.PublisherId = p.Id
join
	PlayersRanges pr ON pr.Id = bg.PlayersRangeId
WHERE
	bg.CategoryId = @categoryId
ORDER BY
	PublisherName,YearPublished DESC


-- Additional info
-- Show employees hire by year
SELECT
	DATEPART(year, HireDate) HireYear, 
	COUNT(*) EmployeesHired
FROM
	Employees
GROUP BY
	DATEPART(year, HireDate) 

-- ... AND BY MONTH
SELECT
	DATEPART(year, HireDate) HireYear, 
	DATEPART(MONTH, HireDate) HireMonth,
	COUNT(*) EmployeesHired
FROM
	Employees
GROUP BY
	DATEPART(year, HireDate), DATEPART(MONTH, HireDate) 
ORDER BY 
	HireYear, HireMonth

-- Total slary payment per employee
SELECT 
	FirstName, LastName,
	DATEDIFF(year, HireDate, getdate()) * Salary
FROM Employees

-- Good luck! :)