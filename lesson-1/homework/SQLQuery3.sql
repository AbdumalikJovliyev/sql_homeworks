--#### **5. CHECK Constraint**

--- Create a table named `account` with:
--  - `account_id` (integer, primary key)
--  - `balance` (decimal, should always be greater than or equal to 0)
--  - `account_type` (string, should only accept values `'Saving'` or `'Checking'`)
--- Use `CHECK` constraints to enforce these rules.
--- First, define the constraints inside `CREATE TABLE`.
--- Then, drop and re-add the `CHECK` constraints using `ALTER TABLE`.


drop table if exists account
create table account (
	account_id int primary key,
	balance decimal(10,2),
	account_type varchar(20),
	constraint chk_balance_non_negative check (balance >=0),
	constraint chk_account_type_valid check (account_type in ('Saving','Checking'))
);

ALTER TABLE account DROP CONSTRAINT chk_balance_non_negative;
ALTER TABLE account DROP CONSTRAINT chk_account_type_valid;

ALTER TABLE account
ADD CONSTRAINT chk_balance_non_negative CHECK (balance >= 0);

ALTER TABLE account
ADD CONSTRAINT chk_account_type_valid CHECK (account_type IN ('Saving', 'Checking'));


--#### **6. DEFAULT Constraint**

--- Create a table named `customer` with:
--  - `customer_id` (integer, primary key)
--  - `name` (string, no constraint)
--  - `city` (string, should have a default value of `'Unknown'`)
--- First, define the default value inside `CREATE TABLE`.
--- Then, drop and re-add the default constraint using `ALTER TABLE`.


drop table if exists customer 
create table customer (
	customer_id int primary key,
	name varchar(100),
	city varchar(100) constraint df_city default 'Unknown'
);

ALTER TABLE customer DROP CONSTRAINT df_city;
ALTER TABLE customer
ADD CONSTRAINT df_city DEFAULT 'Unknown' FOR city;


--#### **7. IDENTITY Column**

--- Create a table named `invoice` with:
--  - `invoice_id` (integer, should **auto-increment starting from 1**)
--  - `amount` (decimal, no constraint)
--- Insert 5 rows into the table without specifying `invoice_id`.
--- Enable and disable `IDENTITY_INSERT`, then manually insert a row with `invoice_id = 100`.

DROP TABLE IF EXISTS invoice;

CREATE TABLE invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,  -- Starts from 1, increments by 1
    amount DECIMAL(10, 2)
);

INSERT INTO invoice (amount) VALUES (100.00);
INSERT INTO invoice (amount) VALUES (250.50);
INSERT INTO invoice (amount) VALUES (75.25);
INSERT INTO invoice (amount) VALUES (400.00);
INSERT INTO invoice (amount) VALUES (600.75);

SET IDENTITY_INSERT invoice ON;
INSERT INTO invoice (invoice_id, amount) VALUES (100, 999.99);
SET IDENTITY_INSERT invoice OFF;

SELECT * FROM invoice;
