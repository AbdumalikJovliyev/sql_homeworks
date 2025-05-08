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

select *from TestMultipleZero
where not (A=0 and B=0 and C=0 and D=0)   

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

SELECT 
    Year1,
    Max1,
    Max2,
    Max3,
    MaxValue = (SELECT MAX(v) 
                FROM (VALUES (Max1), (Max2), (Max3)) AS ValueList(v))
FROM TestMax;




