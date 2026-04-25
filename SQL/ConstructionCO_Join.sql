use ConstructionCo


SELECT
P.ProjectID as ProjectID, P.ProJName as ProjName,
E.EmpFirstName as ManagerFirstName,
E.EmpLastName as ManagerLastName
FROM Project AS P
JOIN Manager AS M on p.ManagerID = m.ManagerID
JOIN Employee AS E on m.ManagerID = E.EmployeeID


#list each employee and every job they are assigned to
# and show the job description

SELECT E.EmployeeID, E.EmpFirstName, E.EmpLastName,
J.JobID, J.JobDescription
FROM Employee AS E
JOIN EmployeeJobs EJ ON E. EmployeeID = EJ.EmployeeID
JOIN Job AS J
ON EJ.JobID = J.JobID 
ORDER BY E.EmployeeID, J.JobID


-----

SELECT p.ProjName,e.EmpFirstName,e.EmpLastName,j.JobDescription, jb.HoursBilled, jb.DateBilled
FROM JobsBilled AS jb
JOIN Project AS p 
    ON jb.ProjectID = p.ProjectID
JOIN Employee AS e
    ON jb.EmployeeID = e.EmployeeID
JOIN Job AS j
    ON jb.JobID = j.JobID
ORDER BY p.ProjName, e.EmpLastName, jb.DateBilled;



------


SELECT p.ProjName AS Project,
    SUM(jb.HoursBilled * j.ChargePerHour) AS TotalAmountBilled
FROM JobsBilled AS jb
JOIN Project AS p
    ON jb.ProjectID = p.ProjectID
JOIN Job AS j
    ON jb.JobID = j.JobID
GROUP BY p.ProjName




---For each manager, show how many employees report to them.

SELECT E1. EmployeeID as managerID, E1. EmpFirstName as ManagerFirstName, E1. EmpLastName as ManagerLastName, COUNT (E2. EmployeeID) as NumDirectReports
FROM Employee AS E1
JOIN Employee AS E2 ON E2.ReportsTo = E1.EmployeeID
GROUP BY E1.EmployeeID, E1.EmpFirstName, E1.EmpLastName
ORDER BY NumDirectReports DESC


-----
SELECT ProjectID, TotalBilled
FROM Project
WHERE TotalBilled > (
    SELECT AVG(TotalBilled)
    FROM Project
);
