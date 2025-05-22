-- Calculate factorials from 1! to 10!
;WITH FactorialCTE AS (
    -- Base case: 1! = 1
    SELECT 
        n = 1,
        factorial = 1
    UNION ALL
    -- Recursive case: n! = n × (n-1)!
    SELECT 
        n + 1, 
        factorial * (n + 1)
    FROM FactorialCTE
    WHERE n < 10  -- Change this value for more terms
)
SELECT * FROM FactorialCTE;
