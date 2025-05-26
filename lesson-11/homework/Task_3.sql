-- ==============================================================
--                          Puzzle 3 DDL
-- ==============================================================
DROP TABLE IF EXISTS Worklog
CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9)

go
CREATE VIEW vw_MonthlyWorkSummary AS
SELECT
    e.EmployeeID,                         
    e.EmployeeName,                       
    e.Department,                         
    SUM(e.HoursWorked) AS TotalHoursWorked, -- Total hours worked by this employee
    d.TotalHoursDepartment,              -- Total hours worked by all employees in the same department
    ROUND(d.AvgHoursDepartment, 4) AS AvgHoursDepartment -- Average hours in the department (rounded to 4 decimals)
FROM WorkLog e
-- Subquery calculates total and average hours per department
JOIN (
    SELECT
        Department,                         -- Department name
        SUM(HoursWorked) AS TotalHoursDepartment,         -- Total hours for the department
        AVG(HoursWorked * 1.0) AS AvgHoursDepartment      -- Average hours for the department (cast to float)
    FROM WorkLog
    GROUP BY Department
) d ON e.Department = d.Department         -- Join on department to match each employee with their dept stats
GROUP BY
    e.EmployeeID,
    e.EmployeeName,
    e.Department,
    d.TotalHoursDepartment,
    d.AvgHoursDepartment;                 -- Group by necessary fields for correct aggregation

-- Retrieve all records from the created view
SELECT * FROM vw_MonthlyWorkSummary;
