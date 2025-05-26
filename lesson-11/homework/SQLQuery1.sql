-- ==============================================================
--                          Puzzle 1 DDL                         
-- ==============================================================
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'Sales', 6000),
    (4, 'David', 'HR', 5500),
    (5, 'Emma', 'IT', 7200);

-- Create temporary table #EmployeeTransfers
DROP TABLE IF EXISTS #EmployeeTransfers;
CREATE TABLE #EmployeeTransfers (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2) 
);

-- Insert updated data with department swapped circularly
INSERT INTO #EmployeeTransfers (EmployeeID, Name, Department, Salary)
SELECT 
    EmployeeID,
    Name,
    CASE 
        WHEN Department = 'HR' THEN 'IT'
        WHEN Department = 'IT' THEN 'Sales'
        WHEN Department = 'Sales' THEN 'HR'
        ELSE Department -- fallback just in case
    END AS Department,
    Salary
FROM Employees;

--View the transferred data
SELECT * FROM #EmployeeTransfers;
