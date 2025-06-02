-- Set the target month and year
DECLARE @Year INT = 2025;
DECLARE @Month INT = 6; -- May 2025

-- Generate list of all dates in the target month
WITH DateList AS (
    SELECT DATEADD(DAY, number, DATEFROMPARTS(@Year, @Month, 1)) AS CalendarDate
    FROM master.dbo.spt_values
    WHERE type = 'P'
      AND number BETWEEN 0 AND DATEDIFF(DAY, DATEFROMPARTS(@Year, @Month, 1), EOMONTH(DATEFROMPARTS(@Year, @Month, 1)))
),

-- Assign week numbers starting from the first week of the month
-- Sunday = 1, Saturday = 7
-- This guarantees a culture-invariant day ordering
WeekDays AS (
    SELECT 
        CalendarDate,
        DATEPART(WEEKDAY, CalendarDate) AS WeekdayNumber, -- 1 = Sunday, 7 = Saturday (default in US English)
        DATEPART(DAY, CalendarDate) AS DayOfMonth,
        DENSE_RANK() OVER (ORDER BY DATEPART(WEEK, CalendarDate)) AS WeekNumber
    FROM DateList
)

-- Pivot the days into weekly rows with days as columns
SELECT 
    WeekNumber,
    MAX(CASE WHEN WeekdayNumber = 1 THEN DayOfMonth END) AS Sunday,
    MAX(CASE WHEN WeekdayNumber = 2 THEN DayOfMonth END) AS Monday,
    MAX(CASE WHEN WeekdayNumber = 3 THEN DayOfMonth END) AS Tuesday,
    MAX(CASE WHEN WeekdayNumber = 4 THEN DayOfMonth END) AS Wednesday,
    MAX(CASE WHEN WeekdayNumber = 5 THEN DayOfMonth END) AS Thursday,
    MAX(CASE WHEN WeekdayNumber = 6 THEN DayOfMonth END) AS Friday,
    MAX(CASE WHEN WeekdayNumber = 7 THEN DayOfMonth END) AS Saturday
FROM WeekDays
GROUP BY WeekNumber
ORDER BY WeekNumber;
