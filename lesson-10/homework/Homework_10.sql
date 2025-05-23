--A factory has records of Large Tractor shipments spanning 40 days (see table below). 
--In some of the 40 days, the factory shipped zero tractors and the zeros we not recorded. 
--What is the median number of tractors shipped per day based on the last 40 days?

DROP TABLE IF EXISTS Shipments
CREATE TABLE Shipments (
    N INT PRIMARY KEY,
    Num INT
);

INSERT INTO Shipments (N, Num) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1), (8, 1),
(9, 2), (10, 2), (11, 2), (12, 2), (13, 2), (14, 4), (15, 4), 
(16, 4), (17, 4), (18, 4), (19, 4), (20, 4), (21, 4), (22, 4), 
(23, 4), (24, 4), (25, 4), (26, 5), (27, 5), (28, 5), (29, 5), 
(30, 5), (31, 5), (32, 6), (33, 7);


-- Step 1: Create a table of 40 days (1 to 40)
WITH AllDays AS (
    SELECT TOP (40) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS DayNum
    FROM master.dbo.spt_values  -- A system table with many rows (good for generating numbers)
),

-- Step 2: Join shipment records with the 40-day list to find missing days
-- Any day without a shipment will get NULL
DaysWithShipments AS (
    SELECT 
        a.DayNum,
        ISNULL(s.Num, 0) AS Num  -- Replace NULLs with 0 (i.e., no shipment that day)
    FROM AllDays a
    LEFT JOIN Shipments s ON a.DayNum = s.N
),

-- Step 3: Sort and assign row numbers for median calculation
Ordered AS (
    SELECT 
        Num,
        ROW_NUMBER() OVER (ORDER BY Num) AS rn
    FROM DaysWithShipments
),

-- Step 4: Count total number of days (should always be 40)
Counted AS (
    SELECT COUNT(*) AS total FROM Ordered
)

-- Step 5: Pick the 20th and 21st values (for even total of 40)
SELECT 
    AVG(Num * 1.0) AS Median
FROM Ordered, Counted
WHERE rn IN (total / 2, total / 2 + 1);