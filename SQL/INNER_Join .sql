use ConstructionCo
go



---Project + Manager(INNER JOIN)



SELECT p.ProjectID,p.ProjName,e.EmpFirstName AS ManagerFirst,e.EmpLastName AS ManagerLast
FROM Project p
INNER JOIN Employee e

       ON p.ManagerID = e.EmployeeID;


---Employee + Jobs (INNER JOIN x2)

SELECT e.EmployeeID,
       e.EmpFirstName,
       e.EmpLastName,
       j.JobID,
       j.JobDescription
FROM Employee e
INNER JOIN JobsBilled jb
       ON e.EmployeeID = jb.EmployeeID
INNER JOIN Job j

       ON jb.JobID = j.JobID;



---Project + Customer (INNER JOIN)


SELECT p.ProjectID,p.ProjName,c.PhoneNumber
FROM Project p
INNER JOIN Customer c
       ON p.CustomerID = c.CustomerID;




---Employee + Manager (self INNER JOIN)


SELECT e.EmpFirstName AS EmployeeFirst,e.EmpLastName AS EmployeeLast,m.EmpFirstName AS ManagerFirst, m.EmpLastName AS ManagerLast
FROM Employee e
INNER JOIN Employee m
       ON e.ManagerID = m.EmployeeID;


---Project + Assigned Employees (INNER JOIN x2)

SELECT p.ProjectID,p.ProjName,e.EmployeeID,e.EmpFirstName,e.EmpLastName
FROM Project p

INNER JOIN ProjEmployee pe
       ON p.ProjectID = p.ProjID
INNER JOIN Employee e
       ON pe.EmployeeID = e.EmployeeID;


----Billing details (INNER JOIN x3)

SELECT p.ProjectID,
       p.ProjectName,
       CONCAT(e.EmpFirstName, ' ', e.EmpLastName) AS EmployeeName,
       j.JobDescription
       jb.HoursBilled
       jb.DateBilled
FROM JobsBilled jb
INNER JOIN Project p
       ON jb.ProjectID = p.ProjectID
INNER JOIN Employee e
       ON jb.EmployeeID = e.EmployeeID
INNER JOIN Job j
       ON jb.JobID = j.JobID;



----Count employees per project (INNER JOIN + GROUP BY)

SELECT p.ProjectID,
       p.ProjName,
       COUNT(pe.EmployeeID) AS NumEmployees
FROM Project p
INNER JOIN ProjectEmployee pe
       ON p.ProjectID = pe.ProjectID

GROUP BY p.ProjectID, p.ProjtName




----Manager + Projects they manage (INNER JOIN)


SELECT e.EmpFirstName AS ManagerFirst
       e.EmpLastName AS ManagerLast
       p.ProjectID,
       p.ProjectName
FROM Project p
INNER JOIN Employee e
       ON p.ManagerID = e.EmployeeID


----Jobs + Total Hours (INNER JOIN + GROUP BY)

SELECT j.JobID,
       j.JobDescription,
       SUM(jb.HoursBilled) AS TotalHours
FROM Job j
INNER JOIN JobsBilled jb
       ON j.JobID = jb.JobID

GROUP BY j.JobID, j.JobDescription



----Employees who billed on each project INNER JOIN x2

SELECT p.ProjName,
       e.EmployeeID,
       e.EmpFirstName,
       e.EmpLastName
FROM JobsBilled jb
INNER JOIN Project p
       ON jb.ProjectID = p.ProjectID
INNER JOIN Employee e
       ON jb.EmployeeID = e.EmployeeID

GROUP BY p.ProjName, e.EmployeeID, e.EmpFirstName, e.EmpLastName