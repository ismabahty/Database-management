use ProShop

 ------- SELECT 10 Queries with WHERE
------------------------------------------------------------

SELECT * FROM Employee
---1
SELECT *
FROM EMPLOYEE
WHERE DeptID = 'D001';

-- 2
SELECT FirstName, LastName, Emp_HireDate
FROM EMPLOYEE
WHERE Emp_HireDate > '2020-01-01';

-----3
SELECT FirstName, LastName, Emp_Base_Salary
FROM EMPLOYEE
WHERE Emp_Base_Salary >= 60000;

-----4
SELECT FirstName, LastName, Emp_CommRate
FROM EMPLOYEE
WHERE Emp_CommRate BETWEEN 0.050 AND 0.100;

----- 5
SELECT DepartmentID, DepartmentName
FROM DEPARTMENT
WHERE DepartmentName LIKE '%Sales%';

----- 6
SELECT *
FROM EDUCATION
WHERE EducationCode = 'BS';

------7
SELECT *
FROM EMPLOYEE_EDUCATION
WHERE DateEarned >= '2018-01-01';

------8
SELECT *
FROM EMPLOYEE_TRAINING
WHERE DateEarned IS NULL;

----- 9
SELECT TrainingID, TrainingDesc
FROM TRAINING
WHERE TrainingDesc LIKE '%Safety%';

----- 10
SELECT *
FROM EMPLOYEE
WHERE Emp_DOB < '1990-01-01';


------------------------------------------------------------
---- GROUP BY + HAVING Queries
------------------------------------------------------------

------ 1
SELECT DeptID,
       COUNT(*) AS EmployeeCount
FROM EMPLOYEE
GROUP BY DeptID
HAVING COUNT(*) >= 3;

----- 2
SELECT DeptID,
       AVG(Emp_Base_Salary) AS AvgSalary
FROM EMPLOYEE
GROUP BY DeptID
HAVING AVG(Emp_Base_Salary) > 60000;

----- 3
SELECT EmployeeID,
       COUNT(*) AS TrainingCount
FROM EMPLOYEE_TRAINING
GROUP BY EmployeeID
HAVING COUNT(*) >= 2;

----- 4
SELECT EmployeeID,
       COUNT(*) AS DegreeCount
FROM EMPLOYEE_EDUCATION
GROUP BY EmployeeID
HAVING COUNT(*) >= 2;

----- 5
SELECT EducationID,
       COUNT(*) AS EmployeeCount
FROM EMPLOYEE_EDUCATION
GROUP BY EducationID
HAVING COUNT(*) >= 2;




------------------------------------------------------------
-----4 UPDATE Statements
------------------------------------------------------------


------ 1

UPDATE EMPLOYEE
SET Emp_Base_Salary = Emp_Base_Salary * 1.05
WHERE DeptID = 'D001';



---- 2

UPDATE EMPLOYEE
SET Emp_CommRate = 0.050
WHERE Emp_CommRate IS NULL;


---- 3

UPDATE DEPARTMENT
SET DepartmentName = 'Human Resources'
WHERE DepartmentID = 'D002';


--- 4

UPDATE TRAINING
SET TrainingDesc = 'Advanced Safety Training'
WHERE TrainingID = 'T1';




------------------------------------------------------------
---- 4 DELETE Statements
------------------------------------------------------------
---- 1
DELETE FROM EMPLOYEE_TRAINING
WHERE DateEarned IS NULL;

---- 2
DELETE FROM EMPLOYEE_EDUCATION
WHERE SchoolName = 'Test School';

---- 3
DELETE FROM TRAINING
WHERE TrainingID = 'T9';

---- 4
DELETE FROM Education
WHERE EducationID = 3;

--- 5
DELETE FROM Department
WHERE DepartmentID = 40;

