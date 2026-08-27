# Banking SQL Analytics

A SQL Server portfolio project that simulates a banking database and demonstrates database design, data analysis, risk analysis, stored procedures, transactions, indexing, query optimization, and data integrity.

## Project Overview

This project models a fictional banking system containing customers, accounts, branches, transactions, loans, and cards.
The goal of the project is to demonstrate practical SQL Server and T-SQL skills through realistic banking and financial analysis scenarios.

The project includes:

- Relational database design
- Primary and foreign keys
- Sample banking data
- Basic and advanced SQL queries
- Aggregations
- JOIN operations
- Subqueries
- Common Table Expressions (CTEs)
- Window functions
- Business analysis
- Risk analysis
- SQL Views
- Stored Procedures
- INSERT and UPDATE procedures
- SQL Transactions
- TRY/CATCH error handling
- COMMIT and ROLLBACK
- Indexing
- Composite indexes
- Covering indexes
- SARGable queries
- Execution plan analysis
- Data integrity constraints

## Database Schema

The following ER diagram shows the main relationships between customers, accounts, branches, transactions, loans, and cards.

![Banking Database ER Diagram](07.docs/database_diagram.png)

### Customer

Stores customer information.

Main columns:

- customer_id
- first_name
- last_name
- date_of_birth
- email
- phone
- city
- created_at

### Branch

Stores bank branch information.

Main columns:

- branch_id
- branch_name
- city

### Account

Stores customer bank accounts.

Main columns:

- account_id
- customer_id
- branch_id
- account_type
- balance
- currency
- opened_date
- status

### BankTransaction

Stores transactions made through customer accounts.

Main columns:

- transaction_id
- account_id
- transaction_type
- amount
- transaction_date
- description

### Loan

Stores customer loans.

Main columns:

- loan_id
- customer_id
- loan_type
- loan_amount
- interest_rate
- start_date
- end_date
- status

### Card

Stores cards connected to bank accounts.

Main columns:

- card_id
- account_id
- card_type
- issued_date
- expiry_date
- status


## Database Relationships

```text
Customer
   |
   |----< Account >---- Branch
   |         |
   |         |----< BankTransaction
   |         |
   |         |----< Card
   |
   |----< Loan
