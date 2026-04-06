




-- project tasks
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
select * from books;

insert into books(isbn,book_title,category , rental_price,status,author,publisher) 
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- verify
select * from books where book_title = 'To Kill a Mockingbird';


-- Task 2: Update an Existing Member's Address
select * from members;

UPDATE members 
SET 
    member_address = '199 Oat nt'
WHERE
    member_id = 'C104';
    
-- verify
select * from members where member_id = 'C104';


-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status WHERE issued_id = 'IS121';

delete from issued_status WHERE issued_id = 'IS121';

-- VERIFY
SELECT * FROM issued_status WHERE issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status WHERE issued_emp_id = 'E101';


-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT 
	issued_member_id,
    COUNT(issued_id) as total_books
FROM
    issued_status
GROUP BY issued_member_id
HAVING COUNT(issued_id) > 1;


-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_count AS SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS no_issued FROM
    books AS b
        JOIN
    issued_status AS ist ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn , book_title;

-- verify
select * from book_count;


-- Task 7. Retrieve All Books in a Specific Category: 
select * from books;

select * from books where category = 'Classic';



-- Task 8: Find Total Rental Income by Category:
select category , sum(rental_price)
FROM books group by category;

SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1;


-- task 9 List Members Who Registered in the Last 180 Days:

insert into members (member_id,member_name, member_address, reg_date)
values ('C130','Rahul', 'jorhat', '2020-01-01'),('C131','khemraj', 'guwahati', '2020-02-02');

SELECT * 
FROM members
WHERE reg_date >= '2024-01-01';

select * from members
where reg_date >= current_date() - interval 180 day;


-- task 10 List Employees with Their Branch Manager's Name and their branch details:
select * from branch;

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id;


-- task 11 Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE expensive_books AS SELECT * FROM
    books
WHERE
    rental_price > 7.00;

-- Task 12: Retrieve the List of Books Not Yet Returned
select * from books;
select * from issued_status;
select * from return_status;

SELECT 
    *
FROM
    issued_status AS ist
        LEFT JOIN
    return_status AS rst ON rst.issued_id = ist.issued_id
WHERE
    rst.issued_id IS NULL;




