# Library-Management-System-with-SQL
This project demonstrates the implementation of a comprehensive Library Management System (LMS) using PostgreSQL. The system is designed to efficiently manage and manipulate data related to library operations, including the management of books, members, employees, and the overall library branches. The project showcases advanced database management techniques such as CRUD operations, CTAS (Create Table As Select), and the ability to execute complex SQL queries for data analysis and reporting.

## 1. Database Setup
The first step in building the Library Management System involved setting up the database and creating the necessary tables to store various pieces of data related to library operations. The following tables were created:

  ![image](https://github.com/user-attachments/assets/b9327ebb-0e1e-4f03-9228-b831c3f5b479)

-  Branches Table: Stores information about different library branches (branch ID, manager, contact info, etc.).
-  Employees Table: Stores employee details (employee ID, name, position, salary, and branch affiliation).
-  Members Table: Stores member details (member ID, name, address, registration date).
-  Books Table: Stores book details (book ISBN, title, author, publisher, category, rental price, and status).
-  Issued Status Table: Records the books that have been issued to members (issue ID, member ID, book ISBN, issue date, employee ID responsible).
-  Return Status Table: Records the return of issued books and includes the condition of the book when returned (return ID, issue ID, book quality).
These tables were designed with foreign key relationships to enforce data integrity between members, employees, books, and branches, ensuring proper references and relationships between the entities.

## 2. CRUD Operations
  CRUD (Create, Read, Update, Delete) operations were performed to ensure that the data could be properly managed within the system:
- Create: Sample records were inserted into the books, members, and other relevant tables. This includes adding new books to the inventory, registering new members, and hiring new employees.
- Read:SQL queries were used to retrieve and display data from various tables, such as:
  - Displaying a list of all available books.
  - Retrieving member details and their issued books.

- Update:Records were updated to simulate real-world changes, such as:
  - Updating employee details (e.g., changing a member’s address or updating an employee's salary).
  - Modifying book availability after it has been issued or returned.
  
- Delete: Records were deleted from the members table to simulate the removal of a member who no longer uses the library or when a book is permanently removed from the library’s inventory.

## 3. CTAS (Create Table As Select)
The CTAS (Create Table As Select) statement was used to create new summary tables based on specific query results. This functionality was utilized for:

- ### Creating Summary Tables:
  New tables were created to store the aggregated data, such as the total number of books issued and the total rental revenue generated from book rentals.
  Example:
  Summary of Books Issued: A new table was generated showing each book and its total number of issues, useful for analyzing the popularity of books.
  This feature allowed for the efficient creation of reports and analytics, ensuring data could be summarized and further processed in a streamlined way.

## 4. Data Analysis and Findings
Several advanced SQL queries were developed to analyze and retrieve specific data insights. The following tasks were accomplished:

### Task 1: Identify Members with Overdue Books
To identify members who have overdue books. The query calculates the overdue days assuming a 30-day return period and retrieves the member's ID, name, book title, issue date, and the number of days overdue.

### Task 2: Update Book Status on Return
When a book is returned, its status is updated in the books table. A query was written to update the book status to "Available" (i.e., "Yes") based on the entries in the return_status table where the book has been returned.

### Task 3: Branch Performance Report
A detailed performance report for each branch was created, which includes:

- The number of books issued by the branch.
- The number of books returned.
- The total revenue generated from book rentals (based on rental price and the number of books issued).
### Task 4: Active Members Table (CTAS)
A new table active_members was created using CTAS, containing only those members who have issued at least one book in the last two months. This allows the system to track active members, and potentially target them for promotions or reminders.

### Task 5: Top Employees by Book Issues
To find the top 3 employees who have processed the most book issues. The query retrieves employee names, the number of books they processed, and their branch, providing insight into the most efficient staff.

### Task 6: High-Risk Books Issued by Members
A query was created to identify members who have issued damaged books more than twice. This helps in tracking members who may be more prone to mishandling books, and can aid in future decision-making regarding book handling or member privileges.

## 5. Stored Procedure for Book Status Management
A stored procedure was created to manage the status of books when they are issued. The procedure operates as follows:

- Input: Takes the book_id as an input parameter.
- ### Functionality:
- First, it checks if the book's current status is 'Available' (i.e., "Yes").
- If the book is available, the status is updated to 'Issued' (i.e., "No"), and the book is marked as unavailable for others to issue.
- If the book is not available (status is 'No'), the procedure returns an error message indicating that the book is currently not available for issuance.
- This stored procedure ensures that the library maintains accurate records of book availability, and prevents books from being issued when they are unavailable.

### Conclusion
The Library Management System (LMS) project provides a solid demonstration of how a relational database can be designed and implemented to manage library operations effectively. The project covers a wide range of functionality from basic CRUD operations to more advanced SQL techniques such as CTAS, complex data analysis, and the creation of stored procedures. The system is designed to be scalable and flexible, ensuring that it can handle a growing library database and assist in decision-making for library management. The implementation also highlights strong SQL query optimization and best practices in database design.
