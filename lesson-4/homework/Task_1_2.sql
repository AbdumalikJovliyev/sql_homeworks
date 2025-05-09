DROP TABLE IF EXISTS TestMultipleZero
CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);


--If all the columns having zero value then don't show that row.
<<<<<<< HEAD
select *from TestMultipleZero      --selecting all values and filtering them by rows.
where not (A=0 and B=0 and C=0 and D=0)    -- When not all of the values are equal to 0 then we show that row in the table.



=======

select *from TestMultipleZero
where not (A=0 and B=0 and C=0 and D=0)   
>>>>>>> 3cee64a7725154100da5c942448b92eee689a12e

--Write a query which will find maximum value from multiple columns of the table.

DROP TABLE IF EXISTS TestMax
CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);

<<<<<<< HEAD
SELECT 
    Year1, 
    Max1,
    Max2,        -- Adding other columns to better understand the table 
    Max3,
    MaxValue = (SELECT MAX(v) 
                FROM (VALUES (Max1), (Max2), (Max3)) AS ValueList(v))    -- we are taking the values of columns named Max1, Max2, Max3 and declare it as ValueList
				-- Then for that row we are using MAX function to find the greatest number in that row. 
FROM TestMax;


--method 2

SELECT Year1,
CASE
	 WHEN Max1>=Max2 and Max1>=Max3 THEN Max1    --Just comparing every values one by one
	 WHEN Max2>=Max1 and Max2>=Max3 THEN Max2
	 ELSE Max3
END AS MaxValue
FROM TestMax

=======
SELECT 
    Year1,
    Max1,
    Max2,
    Max3,
    MaxValue = (SELECT MAX(v) 
                FROM (VALUES (Max1), (Max2), (Max3)) AS ValueList(v))
FROM TestMax;




>>>>>>> 3cee64a7725154100da5c942448b92eee689a12e
