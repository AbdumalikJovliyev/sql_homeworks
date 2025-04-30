DROP TABLE IF EXISTS Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);


INSERT INTO Products (ProductID, ProductName, Category, Price, Stock)
VALUES 
    (1, 'Laptop', 'Electronics', 1200, 15),
    (2, 'Smartphone', 'Electronics', 800, 30),
    (3, 'Desk Chair', 'Furniture', 150, 5),
    (4, 'LED TV', 'Electronics', 1400, 8),
    (5, 'Coffee Table', 'Furniture', 250, 0),
    (6, 'Headphones', 'Accessories', 200, 25),
    (7, 'Monitor', 'Electronics', 350, 12),
    (8, 'Sofa', 'Furniture', 900, 2),
    (9, 'Backpack', 'Accessories', 75, 50),
    (10, 'Gaming Mouse', 'Accessories', 120, 20);

-- Query to select the most expensive product in each category
SELECT 
    Category,               -- Select the category, Productname and Price
    ProductName,            
    Price                   
FROM 
    Products p
WHERE 
    Price = (               -- select the most expensive product
        SELECT MAX(Price)   -- Subquery to find the maximum price within the same category
        FROM Products
        WHERE Category = p.Category  -- Ensure the subquery checks the same category as the outer query
    );


SELECT 
    ProductID,              -- Selecting needed columns to perform asked operation
    ProductName,            
    Category,               
    Price,                  
    Stock,                  
    IIF(Stock = 0, 'Out of Stock',        -- If stock is 0, set inventory status as 'Out of Stock'
        IIF(Stock BETWEEN 1 AND 10, 'Low Stock',  -- If stock is between 1 and 10, set status as 'Low Stock'
            'In Stock')) AS InventoryStatus  -- Otherwise, set status as 'In Stock'
FROM 
    Products
ORDER BY 
    Price DESC              -- Sort results by price in descending order (most expensive first)
OFFSET 5 ROWS;             -- Skip the first 5 rows (i.e., the 5 most expensive products)
