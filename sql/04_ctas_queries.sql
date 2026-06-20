-- ===================================================================
-- Library Management System - SQL Project (MySQL version)
-- File: 04_ctas_queries.sql
-- Purpose: CTAS (Create Table As Select) and core data analysis queries
-- ===================================================================

USE library_db;

-- Task 6: Create Summary Tables
-- Used CTAS to generate a new table based on query results
-- - each book and its total issue count
DROP TABLE IF EXISTS book_issued_cnt;
CREATE TABLE book_issued_cnt AS
SELECT
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
    ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

SELECT * FROM book_issued_cnt;


-- Task 7: Retrieve All Books in a Specific Category
SELECT *
FROM books
WHERE category = 'Classic';


-- Task 8: Find Total Rental Income by Category
SELECT
    b.category,
    SUM(b.rental_price) as total_income,
    COUNT(*) as total_books_issued
FROM issued_status as ist
JOIN books as b
    ON b.isbn = ist.issued_book_isbn
GROUP BY b.category;


-- Task 9: List Members Who Registered in the Last 180 Days
-- NOTE (MySQL): use INTERVAL 180 DAY instead of Postgres' INTERVAL '180 days'
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 DAY;


-- Task 10: List Employees with Their Branch Manager's Name and Branch Details
SELECT
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN branch as b
    ON e1.branch_id = b.branch_id
JOIN employees as e2
    ON e2.emp_id = b.manager_id;


-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold
DROP TABLE IF EXISTS expensive_books;
CREATE TABLE expensive_books AS
SELECT *
FROM books
WHERE rental_price > 7.00;

SELECT * FROM expensive_books;


-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT *
FROM issued_status as ist
LEFT JOIN return_status as rs
    ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
