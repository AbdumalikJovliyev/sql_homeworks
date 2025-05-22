-- Generate Fibonacci sequence using recursive Common Table Expression (CTE)
;WITH FibonacciCTE AS (
    -- Base case: starting the Fibonacci sequence with n = 1
    -- [current] = 1 (1st Fibonacci number)
    -- [next] = 1 (2nd Fibonacci number, used for calculating the next in the sequence)
    SELECT
        n = 1,
        [current] = 1,
        [next] = 1

    UNION ALL
    -- Recursive step:
    -- Each row calculates the next Fibonacci number using the previous two
    -- [current] becomes the previous [next]
    -- [next] becomes the sum of previous [current] + [next]
    -- This way, we keep sliding through the sequence using only two variables
    SELECT
        n + 1,                    -- Increase the position (n) by 1
        [next],                  -- Next number becomes the new current
        [current] + [next]       -- Sum of current and next becomes the new next
    FROM FibonacciCTE
    WHERE n < 10  -- Limit the recursion to 10 Fibonacci numbers
)
-- Final result: show the sequence
SELECT 
    n, 
    [current] AS FibonacciNumber -- Show the actual Fibonacci number for each n
FROM FibonacciCTE
ORDER BY n; -- Order by sequence position (n)
