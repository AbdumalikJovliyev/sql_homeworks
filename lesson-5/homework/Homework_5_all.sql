DROP TABLE IF EXISTS Employees
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);

INSERT INTO Employees (Name, Department, Salary, HireDate) VALUES
    ('Alice', 'HR', 50000, '2020-06-15'),
    ('Bob', 'HR', 60000, '2018-09-10'),
    ('Charlie', 'IT', 70000, '2019-03-05'),
    ('David', 'IT', 80000, '2021-07-22'),
    ('Eve', 'Finance', 90000, '2017-11-30'),
    ('Frank', 'Finance', 75000, '2019-12-25'),
    ('Grace', 'Marketing', 65000, '2016-05-14'),
    ('Hank', 'Marketing', 72000, '2019-10-08'),
    ('Ivy', 'IT', 67000, '2022-01-12'),
    ('Jack', 'HR', 52000, '2021-03-29');






--* [1] Assign a Unique Rank to Each Employee Based on Salary
SELECT *, 
	RANK() OVER (ORDER BY salary DESC) AS salary_rank  -- Assigns unique rank based on descending salary
FROM Employees;


--* [2] Find Employees Who Have the Same Salary Rank
SELECT *, 
	DENSE_RANK() OVER (ORDER BY salary DESC) AS eq_salary_rank  -- Equal salaries get the same rank, no gaps
FROM Employees;



--* [3] Identify the Top 2 Highest Salaries in Each Department
SELECT *  -- Final result with only top 2 salaries per department
FROM (
    SELECT *, 
	RANK() OVER (PARTITION BY Department ORDER BY salary DESC) AS salary_rank  -- Ranking within each department
    FROM Employees            -- From Employees table
) ranked
WHERE salary_rank <= 2;  -- Filter to top 2 ranked salaries



--* [4] Find the Lowest-Paid Employee in Each Department
SELECT Name, Salary, Department  -- Show only employees whose salaries are minimum
FROM (
    SELECT 
        Name,
        Salary,
        Department,
        MIN(Salary) OVER (PARTITION BY Department) AS lowest  -- Calculates minimum salary per department
    FROM Employees
) AS sub
WHERE Salary = lowest;  -- Filter to lowest-paid employee(s)



--* [5] Calculate the Running Total of Salaries in Each Department
SELECT *, 
	SUM(Salary) OVER (PARTITION BY Department ORDER BY Salary) AS running_total  -- Cumulative salary total ordered by salary
FROM Employees;


--* [6] Find the Total Salary of Each Department Without GROUP BY
SELECT DISTINCT *,  --It only takes unique data from the table
	SUM(Salary) OVER (PARTITION BY Department) AS TotalSalary  -- Total salary of each department 
FROM Employees;


--* [7] Calculate the Average Salary in Each Department Without GROUP BY
SELECT *, 
	CAST(AVG(Salary) OVER (PARTITION BY Department) AS Decimal(10,2)) AS Salary_Avg  -- Avg per department with formatting
	-- CAST is used for converting from data type to another one (in here it is converting to Decimal(10,2))
	-- AVG for finding the average of salaries
	-- Partition by is groups the similar info according to the given column name. 
FROM Employees;



--* [8] Find the Difference Between an Employee’s Salary and Their Department’s Average
SELECT *,
    CAST(AVG(Salary) OVER (PARTITION BY Department) AS Decimal(10,2)) AS Salary_Avg,  -- Department average
    Salary - CAST(AVG(Salary) OVER (PARTITION BY Department) AS Decimal(10,2)) AS Salary_Difference  -- Difference from average
	-- CAST is used for converting from data type to another one (in here it is converting to Decimal(10,2))
	-- AVG for finding the average of salaries
	-- Partition by is groups the similar info according to the given column name. 
FROM Employees;



--* [9] Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
SELECT *, 
	SUM(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS Moving_Average_3  -- Sliding sum for 3 rows
	-- SUM for finding the summation of the datas from table. 
	-- ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING   -->choosing one preceding and following data from Salary column
FROM Employees; 



--* [10] Find the Sum of Salaries for the Last 3 Hired Employees
SELECT SUM(Salary) AS SumOfLast3Salaries  -- Total of top 3 most recently hired
FROM (
    SELECT TOP 3 Salary       -- Selecting Top3 employess 
    FROM Employees
    ORDER BY HireDate DESC  -- Most recent hires first
) AS Last3;                 -- Descending order helps to find the latest hired employees



--* [11] Calculate the Running Average of Salaries Over All Previous Employees
SELECT *, 
	AVG(Salary) OVER (ORDER BY HireDate)  -- AVG for finding the average of salaries
	 --THe over() works without ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW as expected, because it is default
	AS RunningAverageSalary  -- Cumulative average up to each row
FROM Employees              
ORDER BY HireDate;         -- Ordering by HireDate. 



--* [12] Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After
SELECT *, 
	MAX(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING)   --choosing two preceding and two following data from Salary column also including the itself
	AS MaxSalaryInWindow  -- Sliding max for 5 rows
FROM Employees
ORDER BY HireDate;




--* [13] Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary
SELECT *, 
	CAST((Salary * 100.0) / SUM(Salary) OVER (PARTITION BY Department) AS DECIMAL(5,2)) -- Salary % of department total
	AS PercentageContribution  
FROM Employees
ORDER BY Department;
