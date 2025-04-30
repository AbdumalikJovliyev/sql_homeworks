DROP TABLE IF EXISTS Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

INSERT INTO Orders (OrderID, CustomerName, OrderDate, TotalAmount, Status)
VALUES 
    (101, 'John Doe', '2023-01-15', 2500, 'Shipped'),
    (102, 'Mary Smith', '2023-02-10', 4500, 'Pending'),
    (103, 'James Brown', '2023-03-25', 6200, 'Delivered'),
    (104, 'Patricia Davis', '2023-05-05', 1800, 'Cancelled'),
    (105, 'Michael Wilson', '2023-06-14', 7500, 'Shipped'),
    (106, 'Elizabeth Garcia', '2023-07-20', 9000, 'Delivered'),
    (107, 'David Martinez', '2023-08-02', 1300, 'Pending'),
    (108, 'Susan Clark', '2023-09-12', 5600, 'Shipped'),
    (109, 'Robert Lewis', '2023-10-30', 4100, 'Cancelled'),
    (110, 'Emily Walker', '2023-12-05', 9800, 'Delivered');


SELECT 
    -- Create a new column 'OrderStatus' based on original 'Status'
    CASE 
        WHEN Status IN ('Shipped', 'Delivered') THEN 'Completed'  -- Treat 'Shipped' and 'Delivered' as 'Completed'
        WHEN Status = 'Pending' THEN 'Pending'                    -- Keep 'Pending' as-is
        WHEN Status = 'Cancelled' THEN 'Cancelled'                -- Keep 'Cancelled' as-is
    END AS OrderStatus,

    COUNT(*) AS TotalOrders,          -- Count the number of orders in each group
    SUM(TotalAmount) AS TotalRevenue  -- Sum the total amount in each group

FROM Orders

-- Filter records to include only those within the 2023 calendar year
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31'

-- Group by the transformed OrderStatus to perform aggregation
GROUP BY 
    CASE 
        WHEN Status IN ('Shipped', 'Delivered') THEN 'Completed'
        WHEN Status = 'Pending' THEN 'Pending'
        WHEN Status = 'Cancelled' THEN 'Cancelled'
    END

-- Only include groups where the total revenue is greater than 5000
HAVING SUM(TotalAmount) > 5000

-- Order the results by revenue from highest to lowest
ORDER BY TotalRevenue DESC;

SELECT * FROM Orders


