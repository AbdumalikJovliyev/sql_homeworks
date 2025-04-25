--DELETE
-- Drop the table if it already exists
DROP TABLE IF EXISTS test_identity;
-- Create a new table with an IDENTITY column
CREATE TABLE test_identity (
    id INT IDENTITY PRIMARY KEY, -- Auto-incrementing primary key
    name VARCHAR(50)
);
-- Insert 5 rows into the table
INSERT INTO test_identity (name)
VALUES ('isa'), ('Bob'), ('Behhi'), ('Zufar'), ('Alisher');

-- View the inserted data
SELECT * FROM test_identity;

-- Delete all rows from the table (identity seed is NOT reset)
DELETE FROM test_identity;

-- Insert a new row after DELETE
INSERT INTO test_identity (name)
VALUES ('Frank');

-- View the data to observe the ID value
SELECT * FROM test_identity;

-- Delete deletes the table but id will continue from the last point. In this case Frank named person appears as 6th in table but no other values




--TRUNCATE
-- Recreate the table to start fresh
DROP TABLE IF EXISTS test_identity;
CREATE TABLE test_identity (
    id INT IDENTITY PRIMARY KEY,
    name VARCHAR(50)
);

-- Insert initial values
INSERT INTO test_identity (name)
VALUES ('Alice'), ('Bob'), ('Charlie'), ('David'), ('Eve');

-- Use TRUNCATE to remove all rows and reset identity
TRUNCATE TABLE test_identity;
-- Insert new data after TRUNCATE
INSERT INTO test_identity (name)
VALUES ('George');

-- View result
SELECT * FROM test_identity;
-- TRUNCATE removes all data and resets identity. George gets id=1




--DROP
-- Completely remove the table structure and data
DROP TABLE test_identity;
-- DROP deletes the table itself — both data and structure are gone. 



-- TASK 2

-- Drop table if it already exists
DROP TABLE IF EXISTS data_types_demo;

-- Create a table using various data types
CREATE TABLE data_types_demo (
	id TINYINT,                          -- Small integer (0 to 255)
	small_value SMALLINT,               -- Small integer (-32k to 32k)
	regular_int INT,                    -- Standard integer (-2B to 2B)
	large_int BIGINT,                   -- Very large integer
	price_fixed DECIMAL(10, 2),         -- Fixed precision: 2 decimal places
	price_float FLOAT,                  -- Approximate float
	name VARCHAR(100),                  -- Variable-length string
	description TEXT,                   -- Large text (deprecated in newer versions)
	birth_date DATE,                    -- Date only
	exam_time TIME,                     -- Time only
	created_at DATETIME,                -- Date and time
	guid_col UNIQUEIDENTIFIER,          -- Globally unique ID
	image VARBINARY(MAX)                -- Binary data (e.g., image)
);

-- Insert sample data into the table
INSERT INTO data_types_demo (
	id, small_value, regular_int, large_int, price_fixed, price_float, name, description, 
	birth_date, exam_time, created_at, guid_col, image
)
SELECT 
	2,                                 -- TINYINT
	31000,                             -- SMALLINT
	1500000000,                        -- INT
	1234567890123456789,               -- BIGINT
	75.50,                             -- DECIMAL
	45.123,                            -- FLOAT
	'Apple',                           -- VARCHAR
	'Inserted with image',            -- TEXT
	'2010-10-10',                      -- DATE
	'10:10:10',                        -- TIME
	GETDATE(),                         -- DATETIME
	NEWID(),                           -- UNIQUEIDENTIFIER
	BulkColumn                         -- VARBINARY (image)
FROM OPENROWSET(
	BULK 'C:\Users\acer nitro\OneDrive\Desktop\Application\Images\IMG_white_.JPG',
	SINGLE_BLOB
) AS img;

-- View the inserted data
SELECT * FROM data_types_demo;
