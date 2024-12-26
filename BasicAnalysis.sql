SELECT * FROM BOOKS;
SELECT * FROM branch;
SELECT * FROM employees;
select * from issued_status;
select * from return_status;

-- Analysis
-- List of Members who have issued more than one book -- Objective: Ue GROUP BY to find members who have issued more than one book.
select issued_emp_id,count(issued_id) as total_book_issued from issued_status
group by issued_emp_id
having count(issued_id)>1;

-- CTAS : Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt
select b.isbn, b.book_title, COUNT(ist.issued_id) as no_issued from books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
group by 1,2;

--we want this query to be saved as a summary table which we cna refer later. So we create a CTAS 
CREATE TABLE book_cnts
AS
select b.isbn, b.book_title, COUNT(ist.issued_id) as no_issued from books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
group by 1,2;


select * from book_cnts;

-- Find Total Rental Income by Category:
select b.category, SUM(b.rental_price), count(*) from books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
group by 1;


-- List of Members who joined in the last 300 days 
select * from members 
where reg_date >= CURRENT_DATE - INTERVAL '300 days';


-- List Employees with Their Branch Manager's Name and their branch details:
select * from employees;
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
ON e2.emp_id = b.manager_id


--  Retrieve the List of Books Not Yet Returned
select * from issued_status;
select * from return_status;

select ist.issued_id, ist.issued_member_id, ist.issued_book_name from issued_status as ist
left join return_status as rs
on ist.issued_id = rs.issued_id
where rs.return_date is NULL;
