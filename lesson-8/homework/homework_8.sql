DROP TABLE IF EXISTS Groupings;

CREATE TABLE Groupings
(
StepNumber  INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NOT NULL,
[Status]    VARCHAR(100) NOT NULL
);
INSERT INTO Groupings (StepNumber, TestCase, [Status]) 
VALUES
(1,'Test Case 1','Passed'),
(2,'Test Case 2','Passed'),
(3,'Test Case 3','Passed'),
(4,'Test Case 4','Passed'),
(5,'Test Case 5','Failed'),
(6,'Test Case 6','Failed'),
(7,'Test Case 7','Failed'),
(8,'Test Case 8','Failed'),
(9,'Test Case 9','Failed'),
(10,'Test Case 10','Passed'),
(11,'Test Case 11','Passed'),
(12,'Test Case 12','Passed');

-----------------------------------------

DROP TABLE IF EXISTS [dbo].[EMPLOYEES_N];

CREATE TABLE [dbo].[EMPLOYEES_N]
(
    [EMPLOYEE_ID] [int] NOT NULL,
    [FIRST_NAME] [varchar](20) NULL,
    [HIRE_DATE] [date] NOT NULL
)
 
INSERT INTO [dbo].[EMPLOYEES_N]
VALUES
	(1001,'Pawan','1975-02-21'),
	(1002,'Ramesh','1976-02-21'),
	(1003,'Avtaar','1977-02-21'),
	(1004,'Marank','1979-02-21'),
	(1008,'Ganesh','1979-02-21'),
	(1007,'Prem','1980-02-21'),
	(1016,'Qaue','1975-02-21'),
	(1155,'Rahil','1975-02-21'),
	(1102,'Suresh','1975-02-21'),
	(1103,'Tisha','1975-02-21'),
	(1104,'Umesh','1972-02-21'),
	(1024,'Veeru','1975-02-21'),
	(1207,'Wahim','1974-02-21'),
	(1046,'Xhera','1980-02-21'),
	(1025,'Wasil','1975-02-21'),
	(1052,'Xerra','1982-02-21'),
	(1073,'Yash','1983-02-21'),
	(1084,'Zahar','1984-02-21'),
	(1094,'Queen','1985-02-21'),
	(1027,'Ernst','1980-02-21'),
	(1116,'Ashish','1990-02-21'),
	(1225,'Bushan','1997-02-21');
	

--1--Write an SQL statement that counts the consecutive values in the Status field.
-- Outer query: Get the minimum and maximum StepNumber for each consecutive group of same Status
SELECT
    MIN(g.StepNumber) AS [Min Step Number],   -- Start of the consecutive group
    MAX(g.StepNumber) AS [Max Step Number],   -- End of the consecutive group
    g.Status,                                 -- Status (e.g., 'Completed', 'Failed', etc.)
    COUNT(*) AS [Consecutive Count]           -- How many steps in this group
FROM (
    -- Inner query: Assign each row a group number based on breaks in sequence
    SELECT 
        StepNumber,
        Status,
        -- For same Status, subtract row number from general row number
        -- This gives same result for consecutive same-status rows
        ROW_NUMBER() OVER (ORDER BY StepNumber) - ROW_NUMBER() OVER (PARTITION BY Status ORDER BY StepNumber) AS grp
    FROM groupings  -- Table with StepNumber and Status
) AS g
-- Group by Status and grp (this 'grp' identifies consecutive blocks)
GROUP BY g.Status, g.grp
-- Sort results by the start of the step block
ORDER BY [Min Step Number];




--2--Find all the year-based intervals from 1975 up to current when the company did not hire employees.
-- Outer query: For each group of missing years, get the first and last year
SELECT 
    MIN(MissingYears.year) AS StartYear,  -- Start of missing period
    MAX(MissingYears.year) AS EndYear     -- End of missing period
FROM (
    -- Inner query: Find years with no hires and assign a group ID
    SELECT y.year,
           -- Subtract row number to detect consecutive years
           y.year - ROW_NUMBER() OVER (ORDER BY y.year) AS grp
    FROM (
        -- Generate all years from 1975 to 2025 using system table
        SELECT v.number + 1975 AS year
        FROM master..spt_values v
        WHERE v.type = 'P' AND v.number BETWEEN 0 AND 2025 - 1975
    ) AS y
    -- Filter out years where at least one employee was hired
    WHERE y.year NOT IN (
        SELECT DISTINCT YEAR(HIRE_DATE)
        FROM EMPLOYEES_N
    )
) AS MissingYears
-- Group by the calculated group ID
GROUP BY grp
-- Order the result by start year
ORDER BY StartYear;
