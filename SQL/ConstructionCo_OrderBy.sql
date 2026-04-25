use ConstructionCo

- S1: Find employees hired between 2006-01-01 and 2012-12-31 + tenure in years
SELECT E.EmployeeID, E.FName, E.LName, E.HireDate,
       TenureYears = DATEDIFF(YEAR, E.HireDate, GETDATE())
FROM dbo.Employee AS E
WHERE E.HireDate >= '2006-01-01' AND E.HireDate <= '2012-12-31'
ORDER BY E.HireDate;

-- S2: Last name contains 'son' (case-insensitive) + length of last name
SELECT E.EmployeeID, E.FName, E.LName, LastNameLength = LEN(E.LName)
FROM dbo.Employee AS E
WHERE LOWER(E.LName) LIKE 'son'
ORDER BY E.LName;

-- S3: Customers with NYC/Queens phone numbers (212/718), format as (AAA) BBB-CCCC
-- Clean phone number using REPLACE
SELECT  C.CustomerID, C.CustomerName, C.Phone,
        Digits = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.Phone,'(',''),')',''),'-',''),' ',''),'.',''),'+',''),
        FormattedPhone = '(' + SUBSTRING(D.D,1,3) + ') ' + SUBSTRING(D.D,4,3) + '-' + SUBSTRING(D.D,7,4)
FROM dbo.Customer AS C
CROSS APPLY (VALUES(
  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(C.Phone,'(',''),')',''),'-',''),' ',''),'.',''),'+','')
)) AS D(D)
WHERE D.D LIKE '212' OR D.D LIKE '718';

-- S4: Projects started between 2013–2014 + start date plus 14 days
SELECT P.ProjectID, P.CustomerID, P.DateStarted,
       TwoWeeksLater = DATEADD(DAY, 14, P.DateStarted)
FROM dbo.Project AS P
WHERE P.DateStarted >= '2013-01-01' AND P.DateStarted < '2015-01-01'
ORDER BY P.DateStarted;

-- S5: CASE + WHERE #1: Only ChargePerHour >= 40, label tiers
SELECT P.ProjectID, P.ChargePerHour,
       ChargeTier = CASE
                      WHEN P.ChargePerHour BETWEEN 40 AND 59.99 THEN 'Mid'
                      WHEN P.ChargePerHour >= 60 THEN 'Upper'
                      ELSE 'Below 40'
                    END
FROM dbo.Project AS P
WHERE P.ChargePerHour >= 40
ORDER BY P.ChargePerHour;

-- S6: CASE + WHERE #2: Status label for projects, only for CustomerID 1 and 2
SELECT P.ProjectID, P.CustomerID,
       StatusLabel = CASE
                       WHEN P.DateStarted > GETDATE() THEN 'Not Started'
                       WHEN P.DateEnded IS NULL       THEN 'Active'
                       ELSE 'Completed'
                     END
FROM dbo.Project AS P
WHERE P.CustomerID IN (1,2)
ORDER BY P.ProjectID;

-- S7: CASE + WHERE #3: Female employees only, show age and age group
SELECT E.EmployeeID, E.FName, E.LName, E.Gender,
       AgeYears = DATEDIFF(YEAR, E.BirthDate, GETDATE())
                  - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.BirthDate, GETDATE()), E.BirthDate) > GETDATE() THEN 1 ELSE 0 END,
       AgeBand = CASE
                   WHEN (DATEDIFF(YEAR, E.BirthDate, GETDATE())
                         - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.BirthDate, GETDATE()), E.BirthDate) > GETDATE() THEN 1 ELSE 0 END) < 30 THEN 'Under 30'
                   WHEN (DATEDIFF(YEAR, E.BirthDate, GETDATE())
                         - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.BirthDate, GETDATE()), E.BirthDate) > GETDATE() THEN 1 ELSE 0 END) BETWEEN 30 AND 44 THEN '30–44'
                   ELSE '45+'
                 END
FROM dbo.Employee AS E
WHERE E.Gender = 'F'
ORDER BY E.LName, E.FName;

-- S8: Last name contains 'a' + position of first 'a' using CHARINDEX
SELECT E.EmployeeID, E.FName, E.LName,
       FirstPosOf_a = CHARINDEX('a', LOWER(E.LName))
FROM dbo.Employee AS E
WHERE LOWER(E.LName) LIKE 'a'
ORDER BY E.LName;

-- S9: Tenure in years using DATEDIFF
SELECT E.EmployeeID, E.FName, E.LName,
       TenureYears = DATEDIFF(YEAR, E.HireDate, GETDATE())
FROM dbo.Employee AS E
ORDER BY TenureYears DESC;

-- S10: Age in years + birth month name
SELECT E.EmployeeID, E.FName, E.LName,
       AgeYears = DATEDIFF(YEAR, E.BirthDate, GETDATE())
                  - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, E.BirthDate, GETDATE()), E.BirthDate) > GETDATE() THEN 1 ELSE 0 END,
       BirthMonth = DATENAME(MONTH, E.BirthDate)
FROM dbo.Employee AS E
ORDER BY E.LName;

-- S11: Project status - NULL DateEnded = 'Active', otherwise 'Completed'
SELECT P.ProjectID,
       StatusText = CASE WHEN P.DateEnded IS NULL THEN 'Active' ELSE 'Completed' END
FROM dbo.Project AS P
ORDER BY P.ProjectID;



/* ===== AGGREGATE QUERIES =====
   A-E1 to A-E5, then A-M1 to A-M4
*/

-- A-E1 (EASY): Count of employees by gender
SELECT E.Gender, EmployeeCount = COUNT(*)
FROM dbo.Employee AS E
GROUP BY E.Gender
ORDER BY E.Gender;

-- A-E2 (EASY): Projects per manager
SELECT P.ManagerID, ProjectsCount = COUNT(*)
FROM dbo.Project AS P
GROUP BY P.ManagerID
ORDER BY ProjectsCount DESC;

-- A-E3 (EASY): Count jobs grouped by the first letter of description
SELECT FirstLetter = UPPER(LEFT(J.Description,1)), JobsCount = COUNT(*)
FROM dbo.Job AS J
GROUP BY UPPER(LEFT(J.Description,1))
ORDER BY FirstLetter;

-- A-E4 (EASY): Total hours billed per employee in 2014
SELECT JB.EmployeeID, TotalHours2014 = SUM(JB.Hours)
FROM dbo.JobsBilled AS JB
WHERE JB.EntryDate >= '2014-01-01' AND JB.EntryDate <'2015-01-01'
GROUP BY JB.EmployeeID
ORDER BY TotalHours2014 DESC;

-- A-E5 (EASY): Direct reports per manager (ReportsTo), exclude NULL
SELECT ManagerID = E.ReportsTo, DirectReports = COUNT(*)
FROM dbo.Employee AS E
WHERE E.ReportsTo IS NOT NULL
GROUP BY E.ReportsTo
ORDER BY DirectReports DESC, ManagerID;



/* A-M1: JobsBilled - Employee-Year-Month summary
   Keep only months with COUNT >= 2 and AVG Hours >= 3.0
*/
SELECT JB.EmployeeID,
       WorkYear  = YEAR(JB.EntryDate),
       WorkMonth = MONTH(JB.EntryDate),
       EntryCount = COUNT(*),
       TotalHours = SUM(JB.Hours),
       AvgHoursPerEntry = AVG(CAST(JB.Hours AS DECIMAL(10,2)))
FROM dbo.JobsBilled AS JB
GROUP BY JB.EmployeeID, YEAR(JB.EntryDate), MONTH(JB.EntryDate)
HAVING COUNT(*) >= 2
   AND AVG(CAST(JB.Hours AS DECIMAL(10,2))) >= 3.0
ORDER BY JB.EmployeeID, WorkYear, WorkMonth;


/* A-M2: Project - Manager-Year, average project duration (days)
   Only completed projects, keep AvgDuration >= 30
   Sort by AvgDuration DESC
*/
SELECT P.ManagerID,
       StartYear   = YEAR(P.DateStarted),
       Projects    = COUNT(*),
       AvgDuration = AVG(CAST(DATEDIFF(DAY, P.DateStarted, P.DateEnded) AS DECIMAL(10,2)))
FROM dbo.Project AS P
WHERE P.DateEnded IS NOT NULL
GROUP BY P.ManagerID, YEAR(P.DateStarted)
HAVING COUNT(*) >= 1
   AND AVG(CAST(DATEDIFF(DAY, P.DateStarted, P.DateEnded) AS DECIMAL(10,2))) >= 30
ORDER BY AvgDuration DESC, P.ManagerID, StartYear;



-- A-M3: Total hours billed per year, keep only years with at least 3 entries
SELECT WorkYear = YEAR(JB.EntryDate),
       Entries = COUNT(*),
       TotalHours = SUM(JB.Hours)
FROM dbo.JobsBilled AS JB
GROUP BY YEAR(JB.EntryDate)
HAVING COUNT(*) >= 3
ORDER BY WorkYear;



-- A-M4: Employee-Year KPIs (COUNT, SUM, AVG)
-- Keep only if COUNT >= 2 and AVG Hours >= 20.0
SELECT JB.EmployeeID,
       WorkYear = YEAR(JB.EntryDate),
       Entries = COUNT(*),
       TotalHours = SUM(JB.Hours),
       AvgHoursPerEntry = AVG(CAST(JB.Hours AS DECIMAL(10,2)))
FROM dbo.JobsBilled AS JB
GROUP BY JB.EmployeeID, YEAR(JB.EntryDate)
HAVING COUNT(*) >= 2
   AND AVG(CAST(JB.Hours AS DECIMAL(10,2))) >= 20.0
ORDER BY JB.EmployeeID, WorkYear;
