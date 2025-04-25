-- Step 1: Create the student table with a computed column
DROP TABLE IF EXISTS students
CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    classes INT,
    tuition_per_class DECIMAL(10, 2),
    
    -- Computed column: total_tuition = classes * tuition_per_class
    total_tuition AS (classes * tuition_per_class)
);

-- Inserting 3 sample rows
INSERT INTO students (id, name, classes, tuition_per_class)
VALUES 
    (1, 'Alish', 4, 1000.00),
    (2, 'Bob', 5, 750.00),
    (3, 'Isa', 3, 1200.00);

--Retrieve all data to check if the computed column works
SELECT * FROM students;   
-- worked correctly 


-- TASK 5

-- Creating the target table for CSV import
DROP table if exists worker
CREATE TABLE worker (
    id INT,
    name VARCHAR(100)
);

-- Step 2: Use BULK INSERT to load data from the CSV file
-- Make sure the file path is accessible to SQL Server
-- The 'FIRSTROW = 2' option skips the CSV header row
BULK INSERT worker
FROM 'C:\Users\acer nitro\OneDrive\Desktop\Data_science\sqlhomeworks\lesson-2\homework\worker.csv'
WITH (
    FIELDTERMINATOR = ',',     -- Columns are separated by commas
    ROWTERMINATOR = '\n',      -- Rows are separated by new lines
    FIRSTROW = 2               -- Skip header row
);

-- Step 3: Verify imported data
SELECT * FROM worker;

