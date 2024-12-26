-- Advanced SQL Queries
select * from books ;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;

/*
Task 1: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
*/

-- First We'll see which members have issued which books and on which date and whether they have returned or not
--For that Issued_status == members == books == return_status
-- filter books which is returned 
-- overdue > 30
select ist.issued_member_id, m.member_name, b.book_title, ist.issued_date,rs.return_date, CURRENT_DATE - ist.issued_date as over_due_days  from issued_status as ist
JOIN members as m 
ON ist.issued_member_id = m.member_id
JOIN books as b
ON b.isbn = ist.issued_book_isbn
LEFT JOIN return_status as rs     
ON rs.issued_id = ist.issued_id
WHERE rs.return_date is null
AND (CURRENT_DATE - ist.issued_date) > 30
order by 1;
--We're doing Left join bcz here in return status we only have 19 records where books are being returned but overall we have 39 records if we look at the above half query. We also want the records which consists of the books which are not returned. Hence, left join.


/*Task 2: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
*/
-- This can be done in two ways either manually or using stored procedures
CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(30) ,p_book_quality VARCHAR(15))
LANGUAGE plpgsql
AS $$

DECLARE
	v_isbn VARCHAR(50);
	v_book_name VARCHAR(80);
BEGIN
	-- all your logic and code
	-- inserting into returns based on user's input
	INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
	VALUES (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

	SELECT 
		issued_book_isbn,
		issued_book_name
		INTO 
		v_isbn,
		v_book_name
	FROM issued_status
	WHERE issued_id = p_issued_id;

	-- Now since the books will be available after the book has been returned so the books table should also be updated.
	UPDATE books
	SET status = 'yes'
	WHERE isbn = v_isbn;

	RAISE NOTICE 'Thank You for returning the Book: %', v_book_name;

END;
$$

call add_return_records();


--Checking for the books which has not been returned still
select * from books where isbn = '978-0-307-58837-1'; -- adn the status is no 
-- issued_id = IS135, ISBN = 978-0-307-58837-1

--Testing Function

SELECT * from books
WHERE isbn = '978-0-307-58837-1';

SELECT * from issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * from return_status 
WHERE issued_id = 'IS135'

--calling function
call add_return_records('RS138', 'IS135', 'Good');

/*Task: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/
SELECT * FROM branch;

SELECT * FROM issued_status;

SELECT * FROM employees;

SELECT * FROM books;

SELECT * FROM return_status;

CREATE TABLE branch_reports
AS
SELECT 
	br.branch_id,
	br.manager_id,
	COUNT(ist.issued_id) as no_of_books_issued,
	COUNT(rs.return_id) as no_of_books_returned,
	SUM(bk.rental_price) as total_revenue
FROM issued_status as ist 
JOIN employees as emp 
ON emp.emp_id = ist.issued_emp_id
JOIN branch as br
ON br.branch_id = emp.branch_id
LEFT JOIN return_status as rs
ON rs.issued_id = ist.issued_id
JOIN books as bk
ON bk.isbn = ist.issued_book_isbn
GROUP BY 1,2;

SELECT * from branch_reports;


/*
CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
*/

select * from members;
select * from issued_status;

select * from members 
where member_id IN (SELECT DISTINCT issued_member_id FROM issued_status WHERE issued_date >= CURRENT_DATE - INTERVAL '2 months');


/*
Task: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
*/
select * from employees;
select* from issued_status;
select * from books;
select * from branch;

select 
	emp.emp_name,
	br.*,
	COUNT(ist.issued_id)
from issued_status as ist
JOIN employees as emp 
ON emp.emp_id = ist.issued_emp_id
JOIN branch as br 
ON br.branch_id = emp.branch_id
GROUP BY 1,2;


/*
Task: Identify Members Issuing high risk books
Write a query to identify members who have issued books more than twice the status "damaged" in the books table. Display the member name, book title,  and the number of times they've issued damaged books.
*/
select * from return_status;
select * from issued_status;
select * from members;
select * from books;

select 
	m.member_name,
	b.book_title,
	rst.book_quality,
	COUNT(ist.issued_id) as Count_of_Books
from issued_status as ist
LEFT JOIN return_status as rst 
ON rst.issued_id = ist.issued_id
JOIN members as m
ON m.member_id = ist.issued_member_id
JOIN books as b
ON b.isbn = ist.issued_book_isbn
WHERE rst.book_quality='Damaged'
GROUP BY 1,2,3;
--HAVING COUNT(ist.issued_id)>2;
-- There are no Damaged Books issued more than twice hence the output is Blank. SO, commenting the HAVING Count>2 part.

/*
Task: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance.
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the 
status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/

CREATE OR REPLACE PROCEDURE issue_book(p_issue_id VARCHAR(10), p_issued_member_id VARCHAR(10), p_issued_book_isbn VARCHAR(25), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
-- all the variable 
	v_status VARCHAR(15);

BEGIN
	--alll the code
	-- first we'll check is the book is availble or not 
	-- 'if yes'
	SELECT 
		status 
		INTO
		v_status 
	from books 
	where isbn = p_issued_book_isbn;

	-- if the book is not available,
	IF v_status = 'yes' THEN 

		INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
		VALUES(p_issue_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);
	
		UPDATE books
		SET status = 'no'
		where isbn = p_issued_book_isbn;
		
		RAISE NOTICE 'Book records added successfully for book isbn: %', p_issued_book_isbn;
	
	ELSE
		RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %',p_issued_book_isbn;
	END IF;

END;
$$

SELECT * FROM books;
--"978-0-553-29698-2" yes
-- "978-0-375-41398-8" no

SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');

CALL issue_book ('IS155', 'C108', '978-0-375-41398-8', 'E104');