--1

SELECT TOP(5)
EmployeeID,
JobTitle,
e.AddressID,
a.AddressText
FROM Employees AS e 
JOIN Addresses AS a ON a.AddressID=e.AddressID
ORDER BY e.AddressID

--2
SELECT TOP(50)
FirstName,
LastName,
t.Name AS [Town],
a.AddressText
 FROM Employees AS e 
 JOIN Addresses AS a ON a.AddressID= e.AddressID
 JOIN Towns t ON a.TownID= t.TownID
 ORDER BY FirstName,LastName

 --3
 SELECT
 EmployeeID,
 FirstName,
 LastName,
 d.Name AS [DepartmentName]
 FROM Employees e
 JOIN Departments d ON d.DepartmentID=e.DepartmentID
 WHERE d.Name='Sales'
 ORDER BY e.EmployeeID

 --4

 SELECT TOP (5)
 EmployeeID,
 FirstName,
 Salary,
 d.Name AS [DepartmentName]
 FROM Employees e
 JOIN Departments d ON d.DepartmentID=e.DepartmentID
 WHERE Salary>15000
 ORDER BY e.DepartmentID

 --5

 SELECT TOP (3)
e.EmployeeID,
 e.FirstName
 FROM Employees e
 WHERE e.EmployeeID NOT IN (SELECT EmployeeID FROM EmployeesProjects)
 ORDER BY e.EmployeeID

 --6
 SELECT 
 FirstName,
 LastName,
 HireDate,
 d.Name
 FROM Employees e 
 JOIN Departments d ON d.DepartmentID= e.DepartmentID
 WHERE (d.Name = 'Sales' OR d.Name = 'Finance')
 AND e.HireDate>'01-01-1999' 
 ORDER BY e.HireDate
 
 --7

 SELECT  TOP(5)
 e.EmployeeID,
 e.FirstName,
 p.Name [ProjectName]
 FROM Employees e
 JOIN EmployeesProjects ep ON ep.EmployeeID = e.EmployeeID
 JOIN Projects p ON ep.ProjectID = p.ProjectID
 WHERE p.StartDate>'2002-08-13' AND p.EndDate IS NULL
 ORDER BY e.EmployeeID

 --8
 SELECT 
 e.EmployeeID,
 e.FirstName,
	CASE
		WHEN p.StartDate>'2004-12-31' THEN NULL
		ELSE p.Name
	END 
 FROM Employees e
 JOIN EmployeesProjects ep ON ep.EmployeeID=e.EmployeeID
 JOIN Projects p ON p.ProjectID = ep.ProjectID
 WHERE e.EmployeeID=24

 --9

 SELECT 
 e.EmployeeID,
 e.FirstName,
 e.ManagerID,
 m.FirstName
 FROM Employees e
 JOIN Employees m ON e.ManagerID=m.EmployeeID
 WHERE e.ManagerID IN (3,7)
 ORDER BY e.EmployeeID

 --10

 SELECT TOP(50)
 e.EmployeeID,
 CONCAT_WS(' ',e.FirstName,e.LastName) AS [EmployeeName],
 CONCAT_WS(' ',m.FirstName,m.LastName) AS [ManagerName],
 d.Name AS [DepartmenName]
 FROM Employees e
 JOIN Employees m ON e.ManagerID = m.EmployeeID
 JOIN Departments d ON d.DepartmentID=e.DepartmentID
 ORDER BY e.EmployeeID

 --11
 SELECT TOP(1)
 AVG(Salary) AS [MinAverageSalary]
 FROM Employees e
 JOIN Departments d ON e.DepartmentID= d.DepartmentID
 GROUP BY (d.Name)
 ORDER BY [MinAverageSalary]

 --12

 SELECT 
 c.CountryCode,
 m.MountainRange,
 p.PeakName,
 p.Elevation
 FROM Peaks p
 JOIN MountainsCountries mc ON p.MountainId=mc.MountainId
 JOIN Mountains m ON m.Id=mc.MountainId
 Join Countries c ON mc.CountryCode=c.CountryCode
 WHERE C.CountryName ='Bulgaria' AND p.Elevation>2835
 ORDER BY p.Elevation DESC

 --13
 SELECT 
 c.CountryCode,
 Count(m.MountainRange)
 FROM Countries c
 JOIN MountainsCountries mc ON mc.CountryCode=c.CountryCode
 JOIN Mountains m ON m.Id=mc.MountainId
 WHERE c.CountryName='United States' OR c.CountryName='Russia ' OR c.CountryName='Bulgaria'
 GROUP BY c.CountryCode

 --14

 SELECT TOP (5)
 c.CountryName,
 r.RiverName
 FROM Countries c
 LEFT JOIN CountriesRivers cr ON cr.CountryCode=c.CountryCode
 LEFT JOIN Rivers r ON r.Id = cr.RiverId
 WHERE c.ContinentCode='AF'
 ORDER BY c.CountryName


 --16
 SELECT
 COUNT(*)
 FROM Countries c
 LEFT JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
 LEFT JOIN Mountains m ON m.Id = mc.MountainId 
 WHERE m.id IS NULL

 --17

 SELECT TOP(5)
 c.CountryName,
 MAX(p.Elevation) AS [HighestPeakElevation],
 MAX(r.Length) AS [LongestRiverLength]
 FROM Countries c
 LEFT JOIN MountainsCountries mc ON mc.CountryCode = c.CountryCode
 LEFT JOIN Mountains m ON m.Id = mc.MountainId
 LEFT JOIN Peaks p ON p.MountainId = m.id
 LEFT JOIN CountriesRivers cr ON cr.CountryCode= c.CountryCode
 LEFT JOIN Rivers r ON r.Id = cr.RiverId
 GROUP BY c.CountryName
 ORDER BY HighestPeakElevation DESC,LongestRiverLength DESC
 

 