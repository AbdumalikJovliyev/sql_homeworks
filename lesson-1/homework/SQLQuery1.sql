-- Drop the 'student' table if it already exists
DROP TABLE IF EXISTS student;

-- Create the 'student' table
CREATE TABLE student (
    id INT,
    name VARCHAR(100),
    age INT
);

-- Select all from the 'student' table
SELECT * FROM student;

-- Alter the 'id' column to make it NOT NULL
ALTER TABLE student
ALTER COLUMN id INT NOT NULL;





-- Next: Drop and recreate the 'product' table
DROP TABLE IF EXISTS product;

-- Create the 'product' table
CREATE TABLE product (
    product_id INT,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    CONSTRAINT UQ_product_id UNIQUE (product_id)
);

-- Drop the unique constraint on 'product_id'
ALTER TABLE product
DROP CONSTRAINT UQ_product_id;

-- Add the unique constraint on 'product_id'
ALTER TABLE product
ADD CONSTRAINT UQ_product_id UNIQUE (product_id);

-- Drop the unique constraint on 'product_id'
ALTER TABLE product
DROP CONSTRAINT UQ_product_id;

-- Add a unique constraint on 'product_id' and 'product_name'
ALTER TABLE product
ADD CONSTRAINT UQ_product_id_name UNIQUE (product_id, product_name);

-- Select all from the 'product' table
SELECT * FROM product;




-- Next: Drop and recreate the 'orders' table with a primary key
DROP TABLE IF EXISTS orders;

-- Create the 'orders' table with a primary key on 'order_id'
CREATE TABLE orders (
    order_id INT,
    customer_name VARCHAR(100),
    order_date DATE,
    CONSTRAINT pk_order_id PRIMARY KEY(order_id)
);

-- Drop the primary key constraint
ALTER TABLE orders
DROP CONSTRAINT pk_order_id;

-- Re-add the primary key constraint
ALTER TABLE orders
ADD CONSTRAINT pk_order_id PRIMARY KEY(order_id);







-- Next: Drop and recreate the 'item' and 'category' tables with foreign key constraints
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS category;

-- Create the 'category' table
CREATE TABLE category (
    category_id INT,
    category_name VARCHAR(100),
    CONSTRAINT pk_cat_id PRIMARY KEY (category_id)
);

-- Create the 'item' table with a foreign key referencing 'category'
CREATE TABLE item (
    item_id INT,
    item_name VARCHAR(100),
    category_id INT,
    CONSTRAINT pk_item_id PRIMARY KEY (item_id),
    CONSTRAINT fk_category_id FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- Drop the foreign key constraint on 'category_id'
ALTER TABLE item
DROP CONSTRAINT fk_category_id;

-- Add the foreign key constraint on 'category_id'
ALTER TABLE item
ADD CONSTRAINT fk_category_id FOREIGN KEY (category_id) REFERENCES category(category_id);   