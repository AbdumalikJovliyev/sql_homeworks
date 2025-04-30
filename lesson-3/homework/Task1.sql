DROP TABLE IF EXISTS Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate)
VALUES 
    (1, 'Alice', 'Johnson', 'HR', 60000, '2019-03-15'),
    (2, 'Bob', 'Smith', 'IT', 85000, '2018-07-20'),
    (3, 'Charlie', 'Brown', 'Finance', 95000, '2017-01-10'),
    (4, 'David', 'Williams', 'HR', 50000, '2021-05-22'),
    (5, 'Emma', 'Jones', 'IT', 110000, '2016-12-02'),
    (6, 'Frank', 'Miller', 'Finance', 40000, '2022-06-30'),
    (7, 'Grace', 'Davis', 'Marketing', 75000, '2020-09-14'),
    (8, 'Henry', 'White', 'Marketing', 72000, '2020-10-10'),
    (9, 'Ivy', 'Taylor', 'IT', 95000, '2017-04-05'),
    (10, 'Jack', 'Anderson', 'Finance', 105000, '2015-11-12');




-- Select the top 10% highest-paid employees
SELECT TOP 10 PERCENT *
FROM Employees
ORDER BY Salary DESC;


-- Calculate average salary per department
SELECT 
    Department,
    AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department;

-- Add salary categories dynamically
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Department,
    Salary,
    HireDate,
    CASE
        WHEN Salary > 80000 THEN 'High'
        WHEN Salary BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees;

-- Select all employees, calculate their department's average salary, and assign salary categories
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Department,
    e.Salary,
    e.HireDate,
    -- Calculate AverageSalary per department
    (SELECT AVG(Salary) FROM Employees AS e2 WHERE e2.Department = e.Department) AS AverageSalary,
    -- Assign SalaryCategory based on salary range
    CASE
        WHEN e.Salary > 80000 THEN 'High'
        WHEN e.Salary BETWEEN 50000 AND 80000 THEN 'Medium'
        ELSE 'Low'
    END AS SalaryCategory
FROM Employees e
WHERE e.Salary IN (
    -- Select the top 10% highest-paid employees
    SELECT TOP 10 PERCENT Salary
    FROM Employees
    ORDER BY Salary DESC
)
ORDER BY AverageSalary DESC
OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY;
