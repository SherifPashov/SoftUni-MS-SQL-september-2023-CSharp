--1
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
SELECT 
FirstName,
LastName
FROM Employees
WHERE Salary>35000


EXEC usp_GetEmployeesSalaryAbove35000

--2

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber
@SalaryLevel DECIMAL(18,4)
AS
	SELECT FirstName, LastName
	FROM Employees
	WHERE Salary >= @SalaryLevel

--3

CREATE PROCEDURE usp_GetTownsStartingWith 
@towns VARCHAR(30)
AS
	SELECT 
	[Name]
	FROM Towns
	WHERE [Name] LIKE @towns+'%' 


--4

CREATE PROCEDURE usp_GetEmployeesFromTown
@townName NVARCHAR(30)
AS
	SELECT 
	e.FirstName [First Name],
	e.LastName [Last Name]
	FROM Employees e
	JOIN Addresses a ON e.AddressID=a.AddressID
	JOIN Towns t ON t.TownID = a.TownID AND t.Name = @townName 

--5

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) 
RETURNS VARCHAR(50)
AS
BEGIN
	IF @salary <30000
		RETURN 'Low'
	ELSE IF @salary <= 50000
		RETURN 'Average'
	
	RETURN 'High'
END

SELECT dbo.ufn_GetSalaryLevel(25000)

--6

CREATE PROCEDURE usp_EmployeesBySalaryLevel 
@SalaryLevel NVARCHAR(50)
AS
BEGIN
	SELECT 
	FirstName,
	LastName
	FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel
END

EXEC usp_EmployeesBySalaryLevel 'Low'

--7

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(50), @word NVARCHAR(50))
RETURNS BIT
AS
BEGIN 
	DECLARE @i INT = 1
	WHiLE @i <= LEN(@word)
	BEGIN 
		DECLARE @ch NVARCHAR(1) = SUBSTRING(@word,@i,1)

		IF(CHARINDEX(@ch,@setOfLetters) = 0)
			RETURN 0
		ELSE
			SET @i +=1
	END

	RETURN 1
END


--8

CREATE PROCEDURE usp_DeleteEmployeesFromDepartment  
@departmentId INT 
AS
BEGIN 
	DECLARE @employeesToBeDelated TABLE(ID INT)

	INSERT INTO @employeesToBeDelated(ID)
		SELECT EmployeeID
		FROM Employees
		WHERE DepartmentID = @departmentId

	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT
	
	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT * FROM @employeesToBeDelated)

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT* FROM @employeesToBeDelated)

	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (SELECT * FROM @employeesToBeDelated)

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId

	DELETE FROM Employees
	WHERE DepartmentID = @departmentId

	SELECT COUNT(*) FROM Employees
	WHERE DepartmentID = @departmentId
END


--9
CREATE PROCEDURE usp_GetHoldersFullName
AS
	SELECT CONCAT_WS(' ',FirstName,LastName) FROM AccountHolders


--10
CREATE OR ALTER PROCEDURE usp_GetHoldersWithBalanceHigherThan 
@a MONEY
AS

	SELECT ah.FirstName,ah.LastName FROM Accounts a
	JOIN AccountHolders ah ON a.AccountHolderId=ah.Id
	GROUP BY ah.Id,ah.FirstName,ah.LastName
	HAVING SUM (a.Balance)>@a
	ORDER BY ah.FirstName,ah.LastName


EXEC usp_GetHoldersWithBalanceHigherThan 0.2

--11

CREATE OR ALTER FUNCTION ufn_CalculateFutureValue
(@Sum DECIMAL(18,2), @Rate FLOAT, @NumberOfYears INT)
RETURNS DECIMAL(20,4)
AS
BEGIN
	RETURN @Sum * POWER((1 + @Rate), @NumberOfYears)
END

EXEC dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

--12

CREATE PROCEDURE usp_CalculateFutureValueForAccount
(@AccountId INT,@Rate FLOAT)
AS
	DECLARE @Years INT = 5 
	
	SELECT 
	a.Id [Account Id],
	ah.FirstName [First Name],
	ah.LastName [Last Name],
	a.Balance [Current Balance],
	dbo.ufn_CalculateFutureValue(a.Balance,@Rate,@Years)
	FROM Accounts a
	JOIN AccountHolders ah ON ah.Id=a.AccountHolderId
	WHERE a.Id=@AccountId


