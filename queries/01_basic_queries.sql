USE NovaBankDB;
GO

USE NovaBankDB;
GO

-- =====================================================
-- Exercise 1
-- Business Question:
-- Display all customers registered in NovaBank.
-- =====================================================

     SELECT *
     FROM Customer;

-- =====================================================
-- Exercise 2
-- Business Question:
-- Display only the customer ID, first name,
-- last name, and city for every customer.
-- =====================================================

     SELECT 
     c.customer_id,
     c.first_name,
     c.last_name,
     c.city
     FROM Customer as c ;

-- =====================================================
-- Exercise 3
-- Business Question:
-- Find all customers who live in Tirana.
-- =====================================================

  SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.city
  FROM Customer as c 
  WHERE c.city = 'Tirana';

-- =====================================================
-- Exercise 4
-- Business Question:
-- Display all accounts that are currently active.
-- =====================================================

      SELECT
       a.*
       FROM account as a 
       where a.status = 'Active' ;

-- =====================================================
-- Exercise 5
-- Business Question:
-- Find all accounts with a balance greater than 20,000.
-- =====================================================
    
     SELECT 
      a.account_id,
      a.balance
      FROM account as a
      WHERE a.balance > 20000 ;

-- =====================================================
-- Exercise 6
-- Business Question:
-- Display the 10 accounts with the highest balances.
-- Show the account ID, account type, balance, and currency.
-- =====================================================

        SELECT TOP 10
        a.account_id,
        a.account_type,
        a.balance,
        a.currency
        FROM account as a
        ORDER BY a.balance DESC ;

-- =====================================================
-- Exercise 7
-- Business Question:
-- Find all accounts whose currency is EUR.
-- =====================================================

     SELECT 
      a.account_id,
      a.account_type,
      a.balance,
      a.currency
     FROM account as a 
     WHERE a.currency = 'EUR' ;

-- =====================================================
-- Exercise 8
-- Business Question:
-- Display all accounts that are inactive.
-- =====================================================

     SELECT
     a.account_id,
     a.account_type,
     a.balance,
     a.status
     FROM account as a 
     WHERE a.status = 'Inactive' ;

-- =====================================================
-- Exercise 9
-- Business Question:
-- Find all bank transactions with an amount
-- greater than 20,000.
-- =====================================================

    SELECT
    t.transaction_id,
    t.account_id,
    t.transaction_type,
    t.amount,
    t.transaction_date
    FROM BankTransaction as t
    WHERE t.amount > 20000 ;

-- =====================================================
-- Exercise 10
-- Business Question:
-- Display the 20 largest transactions,
-- ordered from largest amount to smallest amount.
-- Show transaction ID, account ID, transaction type,
-- amount, and transaction date.
-- =====================================================
  
     SELECT TOP 20
        t.transaction_id,
        t.account_id,
        t.transaction_type,
        t.amount,
        t.transaction_date
        FROM BankTransaction as t
        ORDER BY t.amount DESC ;
        