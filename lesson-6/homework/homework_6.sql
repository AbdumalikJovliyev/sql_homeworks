-- Create the Departments table
DROP TABLE IF EXISTS Departments 
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS Employees 
-- Create the Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    DepartmentID INT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE SET NULL
);

DROP TABLE IF EXISTS Projects
-- Create the Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50) NOT NULL,
    EmployeeID INT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL
);


-- Insert sample data into Departments table
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

-- Insert sample data into Employees table
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);

-- Insert sample data into Projects table
INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);


select * from Employees
select * from Departments
select * from Projects

--* **INNER JOIN**
--  - Write a query to get a list of employees along with their department names.
SELECT 
	emp.Name, 
	dep.DepartmentID   -- Selecting which column names should be shown in the table
FROM 
	Employees as emp   -- From Employees table and aliased as emp for more comfort for the future use
INNER JOIN Departments as dep    -- Making inner join with Departments table and aliased as dep that will be more easy to use.
	ON emp.DepartmentID=dep.DepartmentID;   -- Join condition: Match rows where DepartmentID values are equal in both tables.



--* **LEFT JOIN**
--  - Write a query to list all employees, including those who are not assigned to any department.
SELECT 
    emp.Name,        -- Selecting 
    emp.DepartmentID,  -- Name, DepartmentID and Department Name
    dep.DepartmentName
FROM 
    Employees as emp    -- Main table: Employees (aliased as emp)
LEFT JOIN				-- LEFT JOIN ensures all employees are included, even if they don't belong to a department
    Departments dep     -- Table to join: Departments (aliased as dep)
    ON emp.DepartmentID = dep.DepartmentID;   -- Matching condition (joins on DepartmentID)
 

--* **RIGHT JOIN**
--  - Write a query to list all departments, including those without employees.
SELECT 
	emp.Name,
	dep.DepartmentID,      -- Selecting Name, DepartmentID and DepartmentName
	dep.DepartmentName
FROM Employees as emp      -- Main table (Employees) aliased as emp
RIGHT JOIN
	Departments as dep ON emp.DepartmentID=dep.DepartmentID    --Matching condition (joins on DepartmentID)
	-- Right join returns all records from right table and matching records from left table.
	-- If there is no match, the result is 0 records from the left table.


--* **FULL OUTER JOIN**
--  - Write a query to retrieve all employees and all departments, even if there’s no match between them.
SELECT 
    emp.EmployeeID,         -- Employee ID (NULL if no employee exists)
    emp.Name,               -- Employee Name
    emp.DepartmentID AS EmpDeptID,  -- Employee's DepartmentID
    dep.DepartmentID AS DeptID,     -- Department ID from Departments
    dep.DepartmentName      -- Department Name
FROM Employees emp
FULL OUTER JOIN 
    Departments dep ON emp.DepartmentID = dep.DepartmentID;  -- Join on matching DepartmentID


--* **JOIN with Aggregation**
--  - Write a query to find the total salary expense for each department.
SELECT 
    dep.DepartmentName,               -- Department name
    SUM(emp.Salary) AS TotalSalary   -- Total salary expense for that department
FROM Employees emp
INNER JOIN 
    Departments dep ON emp.DepartmentID = dep.DepartmentID  -- Match on DepartmentID
GROUP BY dep.DepartmentName;    -- Group by department to aggregate salary

--* **CROSS JOIN**
--  - Write a query to generate all possible combinations of departments and projects.
SELECT 
    dep.DepartmentName,   -- Department name
    prj.ProjectName       -- Project name
FROM Departments as dep   -- Departments table alias dep
CROSS JOIN Projects as prj;         -- No join condition, every department matches every project


--* **MULTIPLE JOINS**
--  - Write a query to get a list of employees with their department names and assigned project names.
--  - Include employees even if they don’t have a project.

SELECT 
    emp.EmployeeID,             -- Employee ID
    emp.Name,                   -- Employee Name
    dep.DepartmentName,         -- Department Name
    prj.ProjectName             -- Project Name (NULL if not assigned)
FROM Employees as emp           -- Table Employees alias emp
LEFT JOIN Departments as dep    -- Table Depatments alias dep
	ON emp.DepartmentID = dep.DepartmentID      -- Join employee to their department
LEFT JOIN Projects as prj       -- Table Projects alias prj
    ON emp.EmployeeID = prj.EmployeeID    -- Join employee to their project (if any)
