-- Create a database and switch to it
CREATE DATABASE IF NOT EXISTS demo_db;           -- creates a schema
USE demo_db;                                     -- selects the schema

-- Create a base table with constraints
CREATE TABLE customers (                         -- define a table
  customer_id INT PRIMARY KEY,                   -- primary key (unique identifier)
  email VARCHAR(255) UNIQUE NOT NULL,            -- unique + not null constraint
  name VARCHAR(100) NOT NULL,                    -- required text column
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP  -- default value on insert
);

-- Create a related table with a foreign key
CREATE TABLE orders (                            -- orders belong to customers
  order_id INT PRIMARY KEY,                      -- primary key
  customer_id INT NOT NULL,                      -- FK to customers
  order_total DECIMAL(10,2) NOT NULL,            -- currency/amount
  order_date DATE NOT NULL,                      -- order date
  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)  -- FK constraint
);

-- Create a table from a SELECT (copy structure/data)
CREATE TABLE big_spenders AS                     -- create table from a query
SELECT customer_id, SUM(order_total) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(order_total) > 1000;                  -- filter groups in CTAS


-- Insert single rows
INSERT INTO customers (customer_id, email, name)
VALUES (1, 'alice@example.com', 'Alice');        -- adds one row

-- Insert multiple rows efficiently
INSERT INTO customers (customer_id, email, name)
VALUES
  (2, 'bob@example.com', 'Bob'),
  (3, 'carol@example.com', 'Carol');            -- adds many rows at once

-- Insert with ON DUPLICATE KEY UPDATE (upsert pattern)
INSERT INTO customers (customer_id, email, name)
VALUES (2, 'bob@newmail.com', 'Bob')
ON DUPLICATE KEY UPDATE email = VALUES(email);   -- updates on key conflict

-- Add a new column to an existing table
ALTER TABLE customers
ADD COLUMN phone VARCHAR(30) NULL;               -- adds a column

-- Modify a column definition (e.g., widen length)
ALTER TABLE customers
MODIFY COLUMN name VARCHAR(150) NOT NULL;        -- changes type/length/nullability

-- Add an index for faster lookups
ALTER TABLE orders
ADD INDEX idx_orders_customer_date (customer_id, order_date);  -- composite index


-- Delete specific rows using a filter
DELETE FROM customers
WHERE customer_id = 3;                           -- removes matching rows only

-- Delete all rows (use with caution)
DELETE FROM orders;                              -- row-by-row delete of all data

-- Quickly remove all rows and reset auto-increment (DDL)
TRUNCATE TABLE orders;                           -- fast, empties table data

-- Drop a table permanently (structure + data)
DROP TABLE IF EXISTS big_spenders;               -- removes the table entirely


-- Prepare some order rows
INSERT INTO orders (order_id, customer_id, order_total, order_date)
VALUES
  (101, 1, 250.00, '2025-10-01'),
  (102, 1, 125.50, '2025-10-05'),
  (103, 2, 999.99, '2025-10-10');                -- sample orders

-- INNER JOIN: only customers who have orders
SELECT c.customer_id, c.name, o.order_id, o.order_total
FROM customers AS c
INNER JOIN orders AS o
  ON o.customer_id = c.customer_id;              -- match rows across tables

-- LEFT JOIN: all customers, even without orders
SELECT c.customer_id, c.name, o.order_id, o.order_total
FROM customers AS c
LEFT JOIN orders AS o
  ON o.customer_id = c.customer_id;              -- non-matching rows show NULLs

-- RIGHT JOIN: all orders' customers (symmetric idea)
SELECT c.customer_id, c.name, o.order_id, o.order_total
FROM customers AS c
RIGHT JOIN orders AS o
  ON o.customer_id = c.customer_id;              -- keeps all right-side rows

-- CROSS JOIN: Cartesian product (use sparingly)
SELECT c.customer_id, o.order_id
FROM customers AS c
CROSS JOIN orders AS o;                          -- all combinations

-- USING: shorthand when column name is identical in both tables
SELECT c.name, o.order_id, o.order_total
FROM customers AS c
JOIN orders AS o USING (customer_id);            -- equivalent to ON c.customer_id = o.customer_id


-- Total spend per customer
SELECT c.customer_id,
       c.name,
       SUM(o.order_total) AS total_spent,        -- aggregate across rows
       COUNT(*) AS order_count
FROM customers AS c
JOIN orders AS o USING (customer_id)
GROUP BY c.customer_id, c.name;                  -- group rows by customer

-- Filter groups (HAVING works on aggregates)
SELECT c.customer_id,
       c.name,
       SUM(o.order_total) AS total_spent
FROM customers AS c
JOIN orders AS o USING (customer_id)
GROUP BY c.customer_id, c.name
HAVING SUM(o.order_total) >= 300;                -- keep only groups meeting condition


-- Sort by total spend descending, then name ascending
SELECT c.customer_id,
       c.name,
       SUM(o.order_total) AS total_spent
FROM customers AS c
JOIN orders AS o USING (customer_id)
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC, c.name ASC;           -- multi-column sort

-- Pagination with LIMIT and OFFSET
SELECT o.order_id, o.customer_id, o.order_total, o.order_date
FROM orders AS o
ORDER BY o.order_date DESC                        -- newest first
LIMIT 10 OFFSET 0;                                -- first page of 10 rows
