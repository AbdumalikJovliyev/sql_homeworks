DROP TABLE IF EXISTS Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

DROP TABLE IF EXISTS Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

DROP TABLE IF EXISTS OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

DROP TABLE IF EXISTS Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

INSERT INTO Customers VALUES 
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

INSERT INTO Orders VALUES 
(101, 1, '2024-01-01'), (102, 1, '2024-02-15'),
(103, 2, '2024-03-10'), (104, 2, '2024-04-20');

INSERT INTO OrderDetails VALUES 
(1, 101, 1, 2, 10.00), (2, 101, 2, 1, 20.00),
(3, 102, 1, 3, 10.00), (4, 103, 3, 5, 15.00),
(5, 104, 1, 1, 10.00), (6, 104, 2, 2, 20.00);

INSERT INTO Products VALUES 
(1, 'Laptop', 'Electronics'), 
(2, 'Mouse', 'Electronics'),
(3, 'Book', 'Stationery');

SELECT * FROM Orders
SELECT * FROM Customers
Select * from OrderDetails
Select * from Products


--**1️ Retrieve All Customers With Their Orders (Include Customers Without Orders)**
--- Use an appropriate `JOIN` to list all customers, their order IDs, and order dates.
--- Ensure that customers with no orders still appear.

SELECT Customers.CustomerID,               -- Select customer ID
       Customers.CustomerName,            -- Select customer name
       Orders.OrderID,                    -- Include order ID (may be NULL if no order)
       Orders.OrderDate                   -- Include order date (may be NULL)
FROM Customers
LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID  -- LEFT JOIN ensures all customers are shown even if no matching order


--**2️ Find Customers Who Have Never Placed an Order**
--- Return customers who have no orders.

SELECT Customers.CustomerID,               -- Select customer ID
       Customers.CustomerName             -- Select customer name
FROM Customers
LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID  -- Try to match each customer with their orders
WHERE Orders.OrderID IS NULL    -- Filter only those without any matching order (null OrderID)


--**3️ List All Orders With Their Products**
--- Show each order with its product names and quantity.

SELECT OrderDetails.OrderID,       -- Order ID
       OrderDetails.ProductID,     -- Product ID in the order
       OrderDetails.Quantity,      -- Quantity of that product in the order
       Products.ProductName        -- Name of the product
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID  -- Join to get product names
ORDER BY Quantity           -- Sort results by quantity


--**4️ Find Customers With More Than One Order**
--- List customers who have placed more than one order.

SELECT c.CustomerID, c.CustomerName, COUNT(o.OrderID) AS OrderCount  -- Count how many orders each customer has
FROM Customers AS c
JOIN Orders AS o ON c.CustomerID = o.CustomerID       -- Join orders to customers
GROUP BY c.CustomerID, c.CustomerName     -- Group by customer to count their orders
HAVING COUNT(o.OrderID) > 1              -- Only show those with more than one order



--**5️ Find the Most Expensive Product in Each Order**
SELECT od.OrderID, od.ProductID, p.ProductName, od.Price    -- Show order ID, product ID, name, and price
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID     -- Join to get product names
JOIN (
    SELECT OrderID, MAX(Price) AS MaxPrice        -- Subquery to find the highest price per order
    FROM OrderDetails
    GROUP BY OrderID
) max_prices
ON od.OrderID = max_prices.OrderID AND od.Price = max_prices.MaxPrice  -- Join only the rows where price matches max price per order


--**6️ Find the Latest Order for Each Customer**
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate         -- Show customer and their latest order
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN (
    SELECT CustomerID, MAX(OrderDate) AS LatestOrderDate            -- Subquery to find latest order date per customer
    FROM Orders
    GROUP BY CustomerID
) latest 
ON o.CustomerID = latest.CustomerID AND o.OrderDate = latest.LatestOrderDate  -- Join only rows with latest order per customer


--**7️ Find Customers Who Ordered Only 'Electronics' Products**
--- List customers who **only** purchased items from the 'Electronics' category.
SELECT DISTINCT c.CustomerID, c.CustomerName                        -- Show unique customers
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID    -- Joining 3 tables to get required customers 
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT CASE WHEN p.Category <> 'Electronics' THEN p.Category END) = 0  
-- Group customers who have no product outside Electronics (non-electronics count is 0)


--**8️ Find Customers Who Ordered at Least One 'Stationery' Product**
--- List customers who have purchased at least one product from the 'Stationery' category.
SELECT DISTINCT c.CustomerID, c.CustomerName        -- Show unique customers
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Category = 'Stationery'           -- Only include if any product was from 'Stationery'


--**9️ Find Total Amount Spent by Each Customer**
--- Show `CustomerID`, `CustomerName`, and `TotalSpent`.

SELECT c.CustomerID, c.CustomerName, 
       SUM(od.Quantity * od.Price) AS TotalSpent    -- Calculate total money spent: quantity × price
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName            -- Group by customer to compute total spent
