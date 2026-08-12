USE NovaBankDB;
GO

-- =====================================================
-- Exercise 1
-- Business Question:
-- How many customers are registered in NovaBank?
-- Return the result as total_customers.
-- =====================================================

    SELECT 
    COUNT (*) as total_customers 
    FROM Customer;  


-- =====================================================
-- Exercise 2
-- Business Question:
-- How many accounts exist in the bank?
-- Return the result as total_accounts.
-- =====================================================
    
    SELECT
    COUNT (*) as total_accounts
    FROM Account;

-- =====================================================
-- Exercise 3
-- Business Question:
-- What is the total balance held across all bank accounts?
-- Return the result as total_bank_balance.
-- =====================================================

    SELECT 
    SUM(balance) as total_bank_balance
    FROM Account;

-- =====================================================
-- Exercise 4
-- Business Question:
-- What is the average balance of all bank accounts?
-- Return the result as average_account_balance.
-- =====================================================

    SELECT 
    AVG(balance) as average_account_balance
    FROM Account;

-- =====================================================
-- Exercise 5
-- Business Question:
-- Find the smallest and largest account balances.
-- Return both values in the same query.
-- Use aliases minimum_balance and maximum_balance.
-- =====================================================

    SELECT 
    MIN(balance) as minimum_balance,
    MAX(balance) as maximum_balance
    FROM Account;

-- =====================================================
-- Exercise 6
-- Business Question:
-- How many accounts exist for each currency?
--
-- Example output:
--
-- currency | number_of_accounts
-- ---------|-------------------
-- EUR      | ...
-- USD      | ...
-- ALL      | ...
-- GBP      | ...
--
-- =====================================================

    SELECT 
    currency,
    COUNT(*) as number_of_accounts
    FROM Account
    GROUP BY currency;

-- =====================================================
-- Exercise 7
-- Business Question:
-- Calculate the average account balance for each currency.
--
-- Show:
-- currency
-- average_balance
--
-- Order the result from highest average balance
-- to lowest average balance.
-- =====================================================

SELECT  
   currency,
   AVG(balance) as average_balance
   FROM Account
   GROUP BY currency
   ORDER BY average_balance DESC ;

-- =====================================================
-- Exercise 8
-- Business Question:
-- How many transactions exist for each transaction type?
--
-- Show:
-- transaction_type
-- number_of_transactions
--
-- Order from the most common transaction type
-- to the least common.
-- =====================================================
 
  SELECT                      
    transaction_type,
    COUNT(*) as number_of_transactions
    FROM BankTransaction
    GROUP BY transaction_type
    ORDER BY number_of_transactions DESC;

    
-- =====================================================
-- Exercise 9
-- Business Question:
-- Calculate the total transaction volume for each account.
--
-- Show:
-- account_id
-- total_transaction_volume
--
-- Order accounts from highest transaction volume
-- to lowest transaction volume.
-- =====================================================

 SELECT 
    account_id,
    SUM(amount) as total_transaction_volume
    FROM BankTransaction
    GROUP BY account_id
    ORDER BY total_transaction_volume DESC;

-- =====================================================
-- Exercise 10
-- Business Question:
-- Calculate the average transaction amount for each account.
--
-- Show:
-- account_id
-- average_transaction_amount
--
-- Order from highest average transaction amount
-- to lowest.
-- =====================================================

 SELECT 
    account_id,
    AVG(amount) as average_transaction_amount
    FROM BankTransaction
    GROUP BY account_id
    ORDER BY average_transaction_amount DESC;

-- =====================================================
-- Exercise 11
-- Business Question:
-- Find accounts that have more than 30 transactions.
--
-- Show:
-- account_id
-- transaction_count
--
-- HINT:
-- This question requires GROUP BY and HAVING.
-- =====================================================

    SELECT      
    account_id, 
    COUNT(*) as transaction_count
    FROM BankTransaction
    GROUP BY account_id
    HAVING COUNT(*) > 30;


-- =====================================================
-- Exercise 12
-- Business Question:
-- Find accounts whose total transaction volume
-- is greater than 400,000.
--
-- Show:
-- account_id
-- total_transaction_volume
--
-- Order the result from highest volume to lowest.
--
-- HINT:
-- You will need SUM(), GROUP BY and HAVING.
-- =====================================================

    SELECT 
    account_id,
    SUM(amount) as total_transaction_volume
    FROM BankTransaction
    GROUP BY account_id
    HAVING SUM(amount) > 400000
    ORDER BY total_transaction_volume DESC;


-- =====================================================
-- Exercise 13
-- Business Question:
-- Calculate the total loan amount for each loan type.
--
-- Show:
-- loan_type
-- total_loan_amount
--
-- Order from highest total loan exposure to lowest.
-- =====================================================

  SELECT 
    loan_type,
    SUM(loan_amount) as total_loan_amount
    FROM Loan
    GROUP BY loan_type
    ORDER BY total_loan_amount DESC;

-- =====================================================
-- Exercise 14
-- Business Question:
-- Calculate the average interest rate for each loan type.
--
-- Show:
-- loan_type
-- average_interest_rate
-- =====================================================

  SELECT 
    loan_type,
    AVG(interest_rate) as average_interest_rate
    FROM Loan
    GROUP BY loan_type
    ORDER BY average_interest_rate DESC;

-- =====================================================
-- Exercise 15
-- Business Question:
-- Count how many cards exist for each card status.
--
-- Show:
-- status
-- number_of_cards
-- =====================================================

   SELECT         
    status,
    COUNT(*) as number_of_cards
    FROM Card
    GROUP BY status
    ORDER BY number_of_cards DESC;