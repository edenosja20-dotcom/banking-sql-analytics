USE NovaBankDB;
GO

-- =====================================================
/* Display every account together with the customer
   who owns it.

   Show:
   account_id
   first_name
   last_name
   account_type
   balance                           */
-- =====================================================

    SELECT 
      a.account_id,
      c.first_name,
      c.last_name,
      a.account_type,
      a.balance
      FROM account as a 
      JOIN customer as c
        on a.customer_id = c.customer_id ;

-- =====================================================
/* Display every account together with the branch
   where the account is registered.

   Show:
   account_id
   account_type
   branch_name
   city.     */
-- =====================================================

 SELECT 
    a.account_id,
    a.account_type,
    b.branch_name,
    b.city
    FROM Account as a
    JOIN Branch as b
    ON a.branch_id = b.branch_id;

-- =====================================================
/* Display customers together with their loans.

   Show:
   customer_id
   first_name
   last_name
   loan_type
   loan_amount
   interest_rate.   */
-- =====================================================

 SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    l.loan_type,
    l.loan_amount,
    l.interest_rate
    FROM Customer as c
    JOIN Loan as l
    ON c.customer_id = l.customer_id;

-- =====================================================

/* Display all cards together with the account
   they belong to.

   Show:
   card_id
   card_type
   status
   account_id
   account_type
   currency.  */
-- =====================================================

 SELECT 
    c.card_id,
    c.card_type,
    c.status,
    a.account_id,
    a.account_type,
    a.currency
    FROM Card as c
    JOIN Account as a
    ON c.account_id = a.account_id;

-- =====================================================
/* Display all transactions together with the
   account information.

   Show:
   transaction_id
   account_id
   account_type
   transaction_type
   amount
   transaction_date.            */
-- =====================================================

SELECT  
    t.transaction_id,
    a.account_id,
    a.account_type,
    t.transaction_type,
    t.amount,
    t.transaction_date
    FROM BankTransaction as t
    JOIN Account as a
    ON t.account_id = a.account_id;

-- =====================================================
/* Display every transaction together with the
   customer who owns the account.

   Show:
   transaction_id
   first_name
   last_name
   account_id
   transaction_type
   amount
   transaction_date. */
-- =====================================================

 SELECT     
    t.transaction_id,
    c.first_name,
    c.last_name,
    a.account_id,
    t.transaction_type,
    t.amount,
    t.transaction_date
    FROM BankTransaction as t           
    JOIN account as a       
    ON t.account_id = a.account_id
    JOIN customer as c  
    ON a.customer_id = c.customer_id;

-- =====================================================
/* Display every customer account together with
   the branch where it is registered.

   Show:
   customer_id
   first_name
   last_name
   account_id
   account_type
   balance
   branch_name
   branch city.   */
-- =====================================================

    SELECT
    c.customer_id,  
    c.first_name,
    c.last_name,
    a.account_id,
    a.account_type,
    a.balance,
    b.branch_name,
    b.city
    FROM Customer as c
    JOIN Account as a 
      ON c.customer_id = a.customer_id
    JOIN Branch as b 
      ON a.branch_id = b.branch_id;

-- =====================================================
/* Find all transactions greater than 20,000
   and display the customer who made them.

   Show:
   customer_id
   first_name
   last_name
   transaction_id
   transaction_type
   amount
   transaction_date

   Order the largest transaction first.  */
-- =====================================================

  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    t.transaction_id,
    t.transaction_type,
    t.amount,
    t.transaction_date
    FROM Customer as c
    JOIN Account as a 
      ON c.customer_id = a.customer_id
    JOIN BankTransaction as t 
      ON a.account_id = t.account_id
    WHERE t.amount > 20000
    ORDER BY t.amount DESC;

-- =====================================================
/* Find all active loans and display the customer
   who owns each loan.

   Show:
   customer_id
   first_name
   last_name
   loan_id
   loan_type
   loan_amount
   interest_rate          */
-- =====================================================

  SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    l.loan_id,
    l.loan_type,
    l.loan_amount,
    l.interest_rate
    FROM Customer as c
    JOIN Loan as l 
      ON c.customer_id = l.customer_id
    WHERE l.status = 'Active';

-- =====================================================
/* Display all active cards together with the
   customer who owns the account linked to the card.

   Show:
   customer_id
   first_name
   last_name
   account_id
    card_id
   card_type
   card status               */
-- =====================================================

  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    a.account_id,
    ca.card_id,
    ca.card_type,
    ca.status
    FROM Customer as c
    JOIN Account as a 
      ON c.customer_id = a.customer_id
    JOIN Card as ca
      ON a.account_id = ca.account_id;

-- =====================================================
/* Calculate the total transaction volume
   for each customer.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume

   Order from highest volume to lowest.  */
-- =====================================================

  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(t.amount) as total_transaction_volume
    FROM Customer as c
    JOIN Account as a 
      ON c.customer_id = a.customer_id
    JOIN BankTransaction as t 
      ON a.account_id = t.account_id
    GROUP BY c.customer_id, c.first_name, c.last_name
    ORDER BY total_transaction_volume DESC;

-- =====================================================
/* Count how many accounts each customer owns.

   Show:
   customer_id
   first_name
   last_name
   number_of_accounts

   Order customers with the most accounts first. */
-- =====================================================

  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(a.account_id) as number_of_accounts
    FROM Customer as c
    JOIN Account as a 
      ON c.customer_id = a.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
    ORDER BY number_of_accounts DESC;

-- =====================================================
/* Calculate the total account balance for each customer.

   A customer may own more than one account.

   Show:
   customer_id
   first_name
   last_name
   total_balance

   Order from highest total balance to lowest. */
-- =====================================================

  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(a.balance) as total_balance
    FROM Customer as c
    JOIN Account as a 
      ON c.customer_id = a.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
    ORDER BY total_balance DESC;

-- =====================================================
/* Calculate the total transaction volume handled
   by each bank branch.

   Show:
   branch_id
   branch_name
   city
   total_transaction_volume
 
   Order from highest transaction volume to lowest. */
-- =====================================================

  SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    SUM(t.amount) as total_transaction_volume
    FROM Branch as b
    JOIN Account as a 
      ON b.branch_id = a.branch_id
    JOIN BankTransaction as t 
      ON a.account_id = t.account_id
    GROUP BY b.branch_id, b.branch_name, b.city
    ORDER BY total_transaction_volume DESC;

-- =====================================================
/* Count the number of transactions processed
   through each branch.

   Show:
   branch_id
   branch_name
   number_of_transactions

   Order the busiest branch first. */
-- =====================================================

SELECT
    b.branch_id,
    b.branch_name,
    COUNT(t.transaction_id) as number_of_transactions
    FROM Branch as b
    JOIN Account as a 
      ON b.branch_id = a.branch_id
    JOIN BankTransaction as t 
      ON a.account_id = t.account_id
    GROUP BY b.branch_id, b.branch_name
    ORDER BY number_of_transactions DESC;

-- =====================================================
/* Find customers who own more than one account.

   Show:
   customer_id
   first_name
   last_name
   number_of_accounts.         */
-- =====================================================

 SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(a.account_id) as number_of_accounts
    FROM Customer as c
    JOIN Account as a 
      ON c.customer_id = a.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
    HAVING COUNT(a.account_id) > 1
    ORDER BY number_of_accounts DESC;

-- =====================================================
/* Find customers whose total transaction volume
   is greater than 500,000.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume
  
   Order highest first.  */
-- =====================================================

 SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(t.amount) as total_transaction_volume
    FROM Customer as c
    JOIN Account as a 
      ON c.customer_id = a.customer_id
    JOIN BankTransaction as t 
      ON a.account_id = t.account_id
    GROUP BY c.customer_id, c.first_name, c.last_name
    HAVING SUM(t.amount) > 500000
    ORDER BY total_transaction_volume DESC;

-- =====================================================
/* Find the average transaction amount for each customer.

   Show:
   customer_id
   first_name
   last_name
   average_transaction_amount
  
   Order highest average first.  */
-- =====================================================

 SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    AVG(t.amount) as average_transaction_amount
    FROM Customer as c
    JOIN Account as a 
      ON c.customer_id = a.customer_id
    JOIN BankTransaction as t 
      ON a.account_id = t.account_id
    GROUP BY c.customer_id, c.first_name, c.last_name
    ORDER BY average_transaction_amount DESC;

-- =====================================================
/* Display customers who have a loan together with
   their total account balance.
  
   Show:
   customer_id
   first_name
   last_name
   loan_type
   loan_amount
   total_account_balance.       */
-- =====================================================

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    l.loan_type,
    l.loan_amount,
    SUM(a.balance) AS total_account_balance
FROM Customer AS c
JOIN Loan AS l 
    ON c.customer_id = l.customer_id
JOIN Account AS a 
    ON c.customer_id = a.customer_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name,
    l.loan_id,
    l.loan_type,
    l.loan_amount;

-- =====================================================
/* Create a detailed banking report showing
   transactions together with the customer,
   account, and branch information.
 
   Show:
   transaction_id
   transaction_date
   transaction_type
   amount
   customer_id
   first_name
   last_name
   account_id
   account_type
   currency
   branch_name
   branch city
  
   Order newest transactions first.  */
-- =====================================================
    
  SELECT
    t.transaction_id,
    t.transaction_date,
    t.transaction_type,
    t.amount,
    c.customer_id,
    c.first_name,
    c.last_name,
    a.account_id,
    a.account_type,
    a.currency,
    b.branch_name,
    b.city
    FROM BankTransaction as t
    JOIN Account as a 
      ON t.account_id = a.account_id
    JOIN Customer as c 
      ON a.customer_id = c.customer_id
    JOIN Branch as b 
      ON a.branch_id = b.branch_id
    ORDER BY t.transaction_date DESC;

