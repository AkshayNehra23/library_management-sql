-- ===================================================================
-- Library Management System - SQL Project
-- File: 05_advanced_queries.sql
-- Purpose: Advanced analysis queries (joins, window logic, CTAS)
-- Note: Stored procedures (Task 14 & 19) live in 06_stored_procedures.sql
-- ===================================================================

-- Task 13: Identify Members with Overdue Books
-- Assume a 30-day return period.
-- Display member id, member name, book title, issue date, and days overdue.
SELECT
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    CURRENT_DATE - ist.issued_date as over_due_days
FROM issued_status as ist
JOIN members as m
    ON m.member_id = ist.issued_member_id
JOIN books as bk
    ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status as rs
    ON rs.issued_id = ist.issued_id
WHERE
    rs.return_date IS NULL
    AND (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;


-- Task 15: Branch Performance Report
-- Number of books issued, number returned, and total revenue per branch.
DROP TABLE IF EXISTS branch_reports;
CREATE TABLE branch_reports AS
SELECT
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN employees as e
    ON e.emp_id = ist.issued_emp_id
JOIN branch as b
    ON e.branch_id = b.branch_id
LEFT JOIN return_status as rs
    ON rs.issued_id = ist.issued_id
JOIN books as bk
    ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;

SELECT * FROM branch_reports;


-- Task 16: CTAS - Create a Table of Active Members
-- Members who have issued at least one book in the last 2 months.
DROP TABLE IF EXISTS active_members;
CREATE TABLE active_members AS
SELECT *
FROM members
WHERE member_id IN (
    SELECT DISTINCT issued_member_id
    FROM issued_status
    WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month'
);

SELECT * FROM active_members;


-- Task 17: Find Employees with the Most Book Issues Processed
-- Top 3 employees by number of books processed, with their branch.
SELECT
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN employees as e
    ON e.emp_id = ist.issued_emp_id
JOIN branch as b
    ON e.branch_id = b.branch_id
GROUP BY 1, 2
ORDER BY no_book_issued DESC
LIMIT 3;


-- Task 18: Identify Members Issuing High-Risk Books
-- Members who have issued the same book more than twice with status "damaged".
SELECT
    m.member_name,
    bk.book_title,
    COUNT(*) as damaged_count
FROM return_status as rs
JOIN issued_status as ist
    ON rs.issued_id = ist.issued_id
JOIN members as m
    ON ist.issued_member_id = m.member_id
JOIN books as bk
    ON ist.issued_book_isbn = bk.isbn
WHERE rs.book_quality = 'Damaged'
GROUP BY m.member_name, bk.book_title
HAVING COUNT(*) > 2;


-- Task 20: CTAS - Overdue Books and Fines
-- For each member: number of overdue books and total fine ($0.50/day overdue).
DROP TABLE IF EXISTS overdue_fines;
CREATE TABLE overdue_fines AS
SELECT
    ist.issued_member_id,
    COUNT(*) as total_overdue_books,
    SUM((CURRENT_DATE - ist.issued_date - 30) * 0.50) as total_fine
FROM issued_status as ist
LEFT JOIN return_status as rs
    ON rs.issued_id = ist.issued_id
WHERE
    rs.return_date IS NULL
    AND (CURRENT_DATE - ist.issued_date) > 30
GROUP BY ist.issued_member_id;

SELECT * FROM overdue_fines;
