
/* All at once */
-- Drop the 'books' table if it already exists
DROP TABLE IF EXISTS books;

-- Create the 'books' table with multiple constraints: IDENTITY, CHECK, and DEFAULT
CREATE TABLE books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-incrementing primary key for book_id
    title VARCHAR(200) CHECK (title <> ''),  -- Title must not be empty
    price DECIMAL(10,2) CHECK (price > 0),  -- Price must be greater than 0
    genre VARCHAR(100) DEFAULT 'Unknown'  -- Default genre is 'Unknown' if not provided
);

-- Insert a valid book
INSERT INTO books (title, price) VALUES ('1984', 12.99);







/* Library Management System */
-- Drop the tables if they already exist
DROP TABLE IF EXISTS loan;
DROP TABLE IF EXISTS member;
DROP TABLE IF EXISTS book;

CREATE TABLE book (
    book_id INT PRIMARY KEY,  -- Primary key on book_id
    title TEXT,  
    author TEXT,  
    published_year INT 
);

-- Create the 'member' table with member information
CREATE TABLE member (
    member_id INT PRIMARY KEY,  -- Primary key on member_id
    name TEXT,  
    email TEXT,  
    phone_number TEXT  
);

-- Create the 'loan' table to track which books are borrowed by which members
CREATE TABLE loan (
    loan_id INT PRIMARY KEY,  -- Primary key on loan_id
    book_id INT,  -- Foreign key to 'book' table
    member_id INT,  -- Foreign key to 'member' table
    loan_date DATE,  -- Date the book was borrowed
    return_date DATE,  -- Date the book was returned (can be NULL if not returned)
    CONSTRAINT fk_loan_book FOREIGN KEY (book_id) REFERENCES book(book_id),  -- Foreign key constraint for book_id
    CONSTRAINT fk_loan_member FOREIGN KEY (member_id) REFERENCES member(member_id)  -- Foreign key constraint for member_id
);

-- Insert sample data into the 'book' table
INSERT INTO book VALUES (1, 'The Hobbit', 'J.R.R. Tolkien', 1937);

-- Insert sample data into the 'member' table
INSERT INTO member VALUES (1, 'Alice', 'alice@email.com', '1234567890');

-- Insert a loan record (book borrowed by Alice, not returned yet)
INSERT INTO loan VALUES (1, 1, 1, GETDATE(), NULL);  -- GETDATE() returns the current date
