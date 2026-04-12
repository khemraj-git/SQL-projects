

INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 24 day,'978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL 13 day,  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL 7 day,  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL 32 day,  '978-0-375-50167-0', 'E101');

-- Adding new column in return_status
ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
SELECT * FROM return_status;


-- Advanced SQL Operations
select * from books;
select * from branch;
select * from book_count;
select * from employees;
select * from expensive_books;
select * from issued_status;
select * from members;
select * from return_status;


-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period).
--  Display the member's_id, member's name, book title, 
-- issue date, and days overdue.


-- issued status == members == books == return_status
-- filter books which is returned 
-- overdue > 30 days
select current_date();

SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    CURRENT_DATE() - ist.issued_date AS over_due_days
FROM
    issued_status AS ist
        JOIN
    members AS m ON m.member_id = ist.issued_member_id
        JOIN
    books AS bk ON bk.isbn = ist.issued_book_isbn
        LEFT JOIN
    return_status AS rst ON rst.issued_id = ist.issued_id
WHERE
    rst.return_date IS NULL
        AND (CURRENT_DATE() - ist.issued_date) > 30
ORDER BY 1;




-- 
-- 
/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table).
*/

select * from issued_status
where issued_book_isbn='978-0-06-025492-6';
-- 1. manual update
select * from books
where isbn='978-0-06-025492-6';

update books set status = 'no'
where isbn='978-0-06-025492-6';

select * from return_status
where issued_id = 'IS123';

-- this is manual update when the book is returned 
-- 1.
INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
VALUES
('RS126', 'IS123', CURRENT_DATE, 'Good');

-- 2.
SELECT * FROM return_status
WHERE issued_id = 'IS123';

-- 3.
update books set status = 'yes'
where isbn='978-0-06-025492-6';

-- 4.
select * from books
where isbn='978-0-06-025492-6';


-- we can do this using STORED PROCEDURE where i will do automatically 
-- Change delimiter because procedure contains multiple SQL statements
DELIMITER $$
DROP PROCEDURE IF EXISTS add_return_records $$
CREATE PROCEDURE add_return_records(
     IN p_return_id VARCHAR(10),      -- input parameter for return id
    IN p_issued_id VARCHAR(10),      -- input parameter for issued id
    IN p_book_quality VARCHAR(10)    -- input parameter for book condition
)

BEGIN

	-- Declare variables to store book details temporarily
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

--   --------------------------------------------------------
    -- Step 1: Insert return record into return_status table
   -- --------------------------------------------------------

    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

	-- --------------------------------------------------------
    -- Step 2: Get book details from issued_status table
    -- using issued_id
   -- --------------------------------------------------------

    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;
  -- ------------------------------------------------------
    -- Step 3: Update books table
    -- Mark book as available after return
    -- ------------------------------------------------------

    UPDATE books
    SET status = 'Yes'
    WHERE isbn = v_isbn;

END $$

DELIMITER ;

CALL add_return_records('RS138', 'IS135', 'Good');

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/
-- TABLES REQUIRED 
SELECT * FROM branch;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM books;
SELECT * FROM employees;

create table branch_reports as 
SELECT 
	b.branch_id,
	count(ist.issued_id) as total_issued,
    count(rst.return_id) as total_returned,
    sum(book.rental_price) as total_revenue
    
FROM branch AS b
left JOIN 
employees as emp 
on b.branch_id = emp.branch_id
left join 
issued_status as ist 
on emp.emp_id = ist.issued_emp_id
left join 
books as book
on ist.issued_book_isbn = book.isbn
left join
return_status as rst
on ist.issued_id = rst.issued_id
group by b.branch_id;

select * from branch_reports;
-- 



-- -- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

select * from books;
select * from members;
select * from issued_status;

SELECT current_date();

drop table if exists active_members;
CREATE TABLE active_members AS SELECT DISTINCT m.* FROM
    members AS m
        JOIN
    issued_status AS ist ON m.member_id = ist.issued_member_id
WHERE
    issued_date >= CURRENT_DATE() - INTERVAL 2 MONTH;
-- group by m.member_id;

SELECT 
    *
FROM
    active_members;
    
    
    
-- 
-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
SELECT 
    e.emp_name,
    b.branch_id,
    b.manager_id,
    b.branch_address,
    COUNT(ist.issued_id) AS no_book_issued
FROM issued_status AS ist
JOIN employees AS e
    ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
    ON e.branch_id = b.branch_id
GROUP BY 
    e.emp_id,
    e.emp_name,
    b.branch_id,
    b.manager_id,
    b.branch_address
ORDER BY no_book_issued DESC
LIMIT 3;










    








