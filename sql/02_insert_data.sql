-- ===================================================================
-- Library Management System - SQL Project
-- File: 02_insert_data.sql
-- Purpose: Load sample data into all tables from the CSV files
-- Note: Run 01_schema.sql first so the tables already exist.
-- Update the file paths below to match where your CSVs are stored.
-- ===================================================================

-- Load Branch data
COPY branch(branch_id, manager_id, branch_address, contact_no)
FROM 'data/branch.csv'
DELIMITER ','
CSV HEADER;

-- Load Employees data
COPY employees(emp_id, emp_name, position, salary, branch_id)
FROM 'data/employees.csv'
DELIMITER ','
CSV HEADER;

-- Load Members data
COPY members(member_id, member_name, member_address, reg_date)
FROM 'data/members.csv'
DELIMITER ','
CSV HEADER;

-- Load Books data
COPY books(isbn, book_title, category, rental_price, status, author, publisher)
FROM 'data/books.csv'
DELIMITER ','
CSV HEADER;

-- Load Issued_status data
COPY issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
FROM 'data/issued_status.csv'
DELIMITER ','
CSV HEADER;

-- Load Return_status data
COPY return_status(return_id, issued_id, return_book_name, return_date, return_book_isbn)
FROM 'data/return_status.csv'
DELIMITER ','
CSV HEADER;

-- Quick check - confirm row counts after loading
SELECT 'branch' as table_name, COUNT(*) FROM branch
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
