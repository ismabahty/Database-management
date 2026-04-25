use ProShop

-------------------------------------------------------------------
   ------4 — DDL SCRIPT (Create Tables + Constraints)
--------------------------------------------------------------------
   Tables: Employee, Department, Training, Employee_Training,
           Education, Employee_Education
  

-- 1. DEPARTMENT
CREATE TABLE Department (
    DepartmentID   CHAR(4)     PRIMARY KEY,
    DepartmentName VARCHAR(45) NOT NULL,
    EmpID          INT NULL              -- optional manager
);
GO

-- 2. EMPLOYEE
CREATE TABLE Employee (
    EmployeeID      INT          PRIMARY KEY,
    FirstName       VARCHAR(30)  NOT NULL,
    LastName        VARCHAR(45)  NOT NULL,
    Emp_DOB         DATE         NULL,
    Emp_HireDate    DATE         NULL,
    DeptID          CHAR(4)      NULL,
    JOBID           CHAR(3)      NULL,
    Emp_Base_Salary DECIMAL(8,2) NULL,
    Emp_CommRate    DECIMAL(4,3) NULL,
    FOREIGN KEY (DeptID) REFERENCES Department(DepartmentID)
);

-- 3. EDUCATION
CREATE TABLE Education (
    EducationID   INT          PRIMARY KEY,
    EducationCode CHAR(3)      NOT NULL,
    EducationDesc VARCHAR(45)  NOT NULL
);

-- 4. EMPLOYEE_EDUCATION (M:N bridge)
CREATE TABLE Employee_Education (
    EmployeeID INT         NOT NULL,
    EducationID INT        NOT NULL,
    DateEarned DATE        NULL,
    SchoolName VARCHAR(45) NULL,
    PRIMARY KEY (EmployeeID, EducationID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (EducationID) REFERENCES Education(EducationID)
);

-- 5. TRAINING
CREATE TABLE TRAINING (
    TrainingID   CHAR(2)     PRIMARY KEY,
    TrainingDesc VARCHAR(45) NOT NULL
);

-- 6. EMPLOYEE_TRAINING (M:N bridge)
CREATE TABLE Employee_Training (
    EmployeeID INT     NOT NULL,
    TrainingID CHAR(2) NOT NULL,
    DateEarned DATE    NULL,
    PRIMARY KEY (EmployeeID, TrainingID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (TrainingID) REFERENCES Training(TrainingID)
);



----------------------------------------------------------
   ----- 5 — DML SCRIPT (Insert Sample Data + Problems)
   At least 3–5 rows per table
 

-- Insert into DEPARTMENT
INSERT INTO Department VALUES
('D001', 'Human Resources', NULL),
('D002', 'Finance',         NULL),
('D003', 'IT Support',      NULL);

-- Insert into EMPLOYEE
INSERT INTO Employee VALUES
(1, 'Anna',  'Lee',   '1990-05-10', '2020-02-01', 'D001', 'A01', 60000, 0.050),
(2, 'James', 'Kim',   '1988-11-20', '2018-06-15', 'D002', 'B01', 72000, 0.060),
(3, 'Maria', 'Lopez', '1995-03-25', '2021-09-10', 'D003', 'C01', 55000, 0.040);

-- Problem note:
-- At first I tried to insert employees before departments.
-- This caused a FOREIGN KEY error on DeptID.
-- I fixed it by inserting Department rows first, then Employee.

-- Insert into EDUCATION
INSERT INTO Education VALUES
(101, 'BS',  'Bachelor of Science'),
(102, 'MS',  'Master of Science'),
(103, 'PHD', 'Doctorate Degree');

-- Problem note:
-- When I accidentally reused the same EducationID, SQL Server raised
-- a PRIMARY KEY ERROR. I corrected it by giving each EducationID
-- a unique value.

-- Insert into EMPLOYEE_EDUCATION
INSERT INTO Employee_Education VALUES
(1, 101, '2012-05-10', 'NYU'),
(1, 102, '2018-05-10', 'Columbia University'),
(2, 101, '2010-06-01', 'UCLA');

-- Problem note:
-- Inserting Employee_Education rows before Employee or Education
-- caused FOREIGN KEY errors. I fixed this by inserting into the
-- parent tables (Employee, Education) first.

-- Insert into TRAINING
INSERT INTO Training VALUES
('T1', 'Safety Training'),
('T2', 'Leadership Training'),
('T3', 'Customer Service');

-- Insert into EMPLOYEE_TRAINING
INSERT INTO Employee_Training VALUES
(1, 'T1', '2020-12-01'),
(2, 'T2', '2019-10-15'),
(3, 'T3', NULL);

-- Problem note:
-- When I tried to use a TrainingID that did not exist in Training,
-- I received a FOREIGN KEY error. I fixed it by inserting valid
-- TrainingIDs into the Training table first, and only then inserting
-- rows into Employee_Training.
