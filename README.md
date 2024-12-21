# Project Description
# Introduction
This project involved creating a relational database in Excel with deliberate errors, cleaning the data using Excel formulas and functions, and importing the cleaned database into SQL for further processing. 
The goal was to ensure the database adhered to third normal form (3NF) and to document the process thoroughly.

### Part 1 – Excel
Step 1: Creating the Database with Errors

•	A relational database was created in Excel, containing 8 entities and at least 10 records per entity.

•	Intentional errors were introduced to test data accuracy, completeness, consistency, reliability, and timeliness.

•	The database file was saved as ExcelInclErrors.xlsx.

•	All errors were documented, categorized, and included in a report.


Step 2: Cleaning the Data

•	The database was copied and cleaned using Excel formulas and tools.

•	Issues were resolved using techniques like:

    o	Correcting inaccuracies (e.g., typos, invalid data).
    
    o	Filling in missing data to ensure completeness.
    
    o	Standardizing inconsistent formats (e.g., date formats).
    
    o	Ensuring data reliability by removing duplicates or verifying calculations.
    
    o	Checking timeliness by updating outdated data.
  
•	Z-Scores were calculated for at least two columns to identify and handle outliers.

•	The cleaned database was saved as ExcelCleaned.xlsx.


Step 3: Error Report

•	A report named ExcelErrorReport.docx was written to document:

    o	All identified errors.
    
    o	Their corresponding categories (e.g., Accuracy, Completeness).
    
    o	The steps taken to clean the data.



### Part 2 – SQL
Step 1: Importing the Cleaned Database

•	The cleaned Excel database was imported into MS-SQL and saved as SQLQualityCleaned.


Step 2: Ensuring Third Normal Form (3NF)

•	The database was checked to ensure compliance with 3NF.

    o	Redundant data was removed.
    
    o	Tables were structured to ensure that attributes depended only on the primary key.
    
    o	Relationships between entities were normalized.
  
•	SQL syntax was used to verify the absence of errors and redundancy.


Step 3: Writing Queries and Procedures

•	A series of SQL queries were written to interact with the database, including:

    o	Basic SELECT queries for retrieving data.
    
    o	JOIN operations to combine data from multiple tables.
    
    o	Views to simplify complex queries.
    
    o	Stored Procedures for reusable and parameterized operations.
  
  
Step 4: Documenting the Process

•	A diary or report was written to document the entire workflow, including reflections on challenges, solutions, and insights gained.



## Outcome
The project delivered:

• An Excel database with errors (ExcelInclErrors.xlsx).

• A cleaned version of the database (ExcelCleaned.xlsx).

• A detailed error report (ExcelErrorReport.docx).

• A normalized SQL database (SQLQualityCleaned).

• A set of SQL queries, joins, views, and stored procedures.

• A work diary or report documenting the entire process and reflections.

This project ensured the data met high-quality standards and showcased expertise in both data cleaning and database management.

