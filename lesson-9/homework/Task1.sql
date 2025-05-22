DROP TABLE IF EXISTS Employees
CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

-- Define Common Table Expression
;WITH EmployeeHierarchy AS (
    -- Anchor member: Select the top-level employee(s), i.e., those with no manager
    SELECT 
        EmployeeID,          -- Unique identifier for the employee
        ManagerID,           -- NULL indicates no manager (top of hierarchy)
        JobTitle,            -- Job title of the employee
        0 AS Level           -- Top-level employees are at Level 0
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    -- Recursive member: Join each employee to their manager in the hierarchy
    SELECT 
        e.EmployeeID,        -- Employee's ID
        e.ManagerID,         -- Who they report to
        e.JobTitle,          -- Their job title
        eh.Level + 1         -- Increment level from their manager's level
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh 
        ON e.ManagerID = eh.EmployeeID  -- Match employee's manager to a known employee in the hierarchy
)

-- Final output: return the full hierarchy with level depth
SELECT * 
FROM EmployeeHierarchy
ORDER BY Level, EmployeeID;  -- Order by hierarchy level, then employee ID

