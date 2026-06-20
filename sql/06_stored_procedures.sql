-- ===================================================================
-- Library Management System - SQL Project (MySQL version)
-- File: 06_stored_procedures.sql
-- Purpose: Stored procedures to issue and return books, keeping the
-- "books.status" column in sync automatically.
-- NOTE (MySQL): MySQL needs DELIMITER to be changed before writing a
-- procedure (since the procedure body itself contains semicolons).
-- Also, Postgres' "RAISE NOTICE" doesn't exist in MySQL - we use
-- SELECT statements to show a status message instead.
-- ===================================================================

USE library_db;

-- Task 19: Issue a Book
-- Objective: Manage the status of a book when it is issued.
-- - Takes book isbn as input.
-- - If the book is available (status = 'yes'), issue it and flip status to 'no'.
-- - If the book is not available (status = 'no'), show a message and do nothing.
DROP PROCEDURE IF EXISTS issue_book;

DELIMITER //

CREATE PROCEDURE issue_book(
    IN p_issued_id VARCHAR(10),
    IN p_issued_member_id VARCHAR(30),
    IN p_issued_book_isbn VARCHAR(30),
    IN p_issued_emp_id VARCHAR(10)
)
BEGIN
    DECLARE v_status VARCHAR(10);

    -- check if book is available
    SELECT status INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN

        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        SELECT CONCAT('Book records added successfully for isbn: ', p_issued_book_isbn) as message;

    ELSE
        SELECT CONCAT('Sorry, the book you requested is currently unavailable. isbn: ', p_issued_book_isbn) as message;
    END IF;

END //

DELIMITER ;

-- Testing issue_book
-- SELECT * FROM books;
-- CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');  -- available
-- CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');  -- not available


-- Task 14: Return a Book
-- Objective: Manage the status of a book when it is returned.
-- - Inserts a record into return_status.
-- - Looks up the original issued book's isbn.
-- - Flips the book's status back to 'yes' so it becomes available again.
DROP PROCEDURE IF EXISTS add_return_records;

DELIMITER //

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10),
    IN p_book_quality VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- log the return
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    -- find which book this issued_id belongs to
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- mark the book as available again
    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    SELECT CONCAT('Thank you for returning the book: ', v_book_name) as message;

END //

DELIMITER ;

-- Testing add_return_records
-- CALL add_return_records('RS138', 'IS135', 'Good');
-- CALL add_return_records('RS148', 'IS140', 'Good');
