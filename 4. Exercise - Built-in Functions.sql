--1

SELECT 
FirstName,
LastName
FROM Employees
WHERE FirstName LIKE 'Sa%' 

--2
SELECT 
FirstName,
LastName 
FROM Employees
WHERE LastName LIKE '%ei%'

--3

SELECT
FirstName
FROM Employees
WHERE (DepartmentID=3 OR DepartmentID=10)
AND HireDate BETWEEN '01-01-1995' AND '12-31-2005'

--4

SELECT 
FirstName,
LastName
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'


--5

SELECT 
[Name]
FROM Towns
WHERE  LEN([Name]) BETWEEN  5 AND 6
ORDER BY [Name]

--6

SELECT
TownID,
[Name]
FROM Towns
WHERE LEFT([Name],1) IN('M', 'K', 'B', 'E')
ORDER BY [Name]

--7

SELECT 
TownID,
[Name]
FROM Towns
WHERE LEFT([Name],1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]

--8

CREATE VIEW V_EmployeesHiredAfter2000
AS
SELECT 
FirstName,
LastName
FROM Employees
WHERE HireDate >'2000-12-31'

--9

SELECT 
FirstName,
LastName
FROM Employees
WHERE LEN(LastName)=5

--10

SELECT
EmployeeID,
FirstName,
LastName,
Salary,
DENSE_RANK()OVER(PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

--11

SELECT * FROM
	(SELECT
	EmployeeID,
	FirstName,
	LastName,
	Salary,
	DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID) AS [Rank] 
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000) AS [Subquery]
WHERE Subquery.Rank=2
ORDER BY Salary DESC


--12
SELECT
CountryName,
IsoCode as[ISO Code]
FROM Countries
WHERE LOWER(CountryName) LIKE ('%a%a%a%')
ORDER BY IsoCode

--13

SELECT
p.PeakName,
r.RiverName,
LOWER(LEFT(p.PeakName,LEN(p.PeakName)-1) + r.RiverName) AS MIX
FROM Peaks AS p , Rivers AS r
WHERE RIGHT(p.PeakName,1)=LEFT(r.RiverName,1)
ORDER BY MIX

--14

SELECT TOP(50)
[Name],
FORMAT([Start], 'yyyy-MM-dd')[Start]
FROM Games
WHERE YEAR([Start])BETWEEN 2011 AND 2012
ORDER BY [Start],[Name]

--15

SELECT
Username,
SUBSTRING(Email,CHARINDEX('@',Email)+1,LEN(Email)) AS [Email Provider]
FROM Users
ORDER BY [Email Provider],Username

--16

SELECT 
Username,
IpAddress
FROM Users
WHERE IpAddress LIKE('___.1%.%.___')
ORDER BY Username

--17
SELECT 
[Name] AS Game,
CASE
	WHEN DATEPART(hour,[Start]) BETWEEN 0 AND 11 THEN 'Morning'
	WHEN DATEPART(hour,[Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
	WHEN DATEPART(hour,[Start]) BETWEEN 18 AND 23 THEN 'Evening'
END AS [Part of the Day],
Duration=
CASE
	WHEN Duration <=3 THEN ' Extra Short'
	WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
	WHEN Duration > 6 THEN 'Long'
	ELSE 'Extra Long'
END 
FROM Games
ORDER BY [Name],[Duration],[Part of the Day]

--18
SELECT 
ProductName,
OrderDate,
DATEADD(day,3,OrderDate)[Pay Due],
DATEADD(month,1,OrderDate)[Deliver Due]
FROM Orders