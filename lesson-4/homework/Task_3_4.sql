--TASK 3
drop table if exists EmpBirth 
CREATE TABLE EmpBirth
(
    EmpId INT  IDENTITY(1,1) 
    ,EmpName VARCHAR(50) 
    ,BirthDate DATETIME 
);
 
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';


--Write a query which will find the Date of Birth of employees whose birthdays lies between May 7 and May 15.
select EmpId, EmpName from EmpBirth        -- choosing the id and name of the employees to filter our data
where month(BirthDate)= '05' and (day(BirthDate)>=7 and day(BirthDate)<=15);         -- checking if the month is may by month = 5. also checking for days that lies between 7 and 15. 



--## Task 4

--- Order letters but 'b' must be first/last
--- Order letters but 'b' must be 3rd (Optional)

-- Drop the 'letters' table if it already exists to avoid errors when recreating it
DROP TABLE IF EXISTS letters;

-- Create a new table named 'letters' with a single column of one-character strings
CREATE TABLE letters (
    letter CHAR(1)
);

-- Insert sample values into the 'letters' table
INSERT INTO letters
VALUES ('a'), ('a'), ('a'), 
       ('b'), ('c'), ('d'), ('e'), ('f');



-- 1. Selecting all letters but 'b' comes first in the result
-- Assigning 'b' as a sorting value of 0 (highest priority), and all others get 1 (lower priority)

SELECT * 
FROM letters
ORDER BY 
  CASE 
    WHEN letter = 'b' THEN 0 
    ELSE 1                   -- Within each group (0s then 1s), we sort alphabetically 
  END,
  letter;    



-- 2. Select all letters but make sure 'b' comes last in the result
-- Assigning 'b' as a sorting value of 1 (lowest priority), and all others get 0 (higher priority)
-- Then sort alphabetically within those groups
SELECT * 
FROM letters
ORDER BY 
  CASE 
    WHEN letter = 'b' THEN 1 
    ELSE 0 
  END,
  letter;



-- 3. Select all letters with 'b' in the second position
-- First, assigning priorities according to our question: 1) a 2)b  3) others
-- To place several 'a' letters after 'b', adding a second sorting layer is needed:
-- The first 'a' comes before 'b', but the rest of the 'a's come after it
SELECT * 
FROM letters
ORDER BY 
  CASE 
    WHEN letter = 'a' THEN 0      -- All 'a's first
    WHEN letter = 'b' THEN 1      -- Then 'b'
    ELSE 2                        -- Then everything else
  END,
  CASE 
    WHEN letter = 'a' THEN 1      -- Among 'a's, delay the second/third ones
    ELSE 0                        -- 'b' and others remain unchanged
  END;
