-- ===================================================================
-- Library Management System - SQL Project (MySQL version)
-- File: 02_insert_data.sql
-- Purpose: Load sample data into all tables from the CSV files
-- Note: Run 01_schema.sql first so the tables already exist.
-- Update the file paths below to the FULL path of your data/ folder
-- on your Mac (MySQL needs an absolute path, not a relative one).
-- Example: /Users/akshaynehra23/Downloads/files/data/branch.csv
-- ===================================================================

USE library_db;

-- IMPORTANT (one-time setup):
-- MySQL Workbench blocks local file loading by default.
-- Run this first (only needed once per session) to allow it:
SET GLOBAL local_infile = 1;

-- Load Branch data
LOAD DATA LOCAL INFILE '/full/path/to/data/branch.csv'
INTO TABLE branch
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(branch_id, manager_id, branch_address, contact_no);

-- Load Employees data
LOAD DATA LOCAL INFILE '/full/path/to/data/employees.csv'
INTO TABLE employees
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(emp_id, emp_name, position, salary, branch_id);

-- Load Members data
LOAD DATA LOCAL INFILE '/full/path/to/data/members.csv'
INTO TABLE members
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(member_id, member_name, member_address, reg_date);

-- Load Books data
LOAD DATA LOCAL INFILE '/full/path/to/data/books.csv'
INTO TABLE books
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(isbn, book_title, category, rental_price, status, author, publisher);

-- Load Issued_status data
LOAD DATA LOCAL INFILE '/full/path/to/data/issued_status.csv'
INTO TABLE issued_status
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id);

-- Load Return_status data
LOAD DATA LOCAL INFILE '/full/path/to/data/return_status.csv'
INTO TABLE return_status
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(return_id, issued_id, return_book_name, return_date, return_book_isbn);

-- Quick check - confirm row counts after loading
SELECT 'branch' as table_name, COUNT(*) as total_rows FROM branch
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'members', COUNT(*) FROM members
UNION ALL
SELECT 'books', COUNT(*) FROM books
UNION ALL
SELECT 'issued_status', COUNT(*) FROM issued_status
UNION ALL
SELECT 'return_status', COUNT(*) FROM return_status;
