USE NovaBankDB ;
GO 

-- =====================================================
/*   Find all accounts whose balance is greater than
   the average balance of all accounts.

   Show:
   account_id
   account_type
   balance
   currency          */
-- =====================================================
  
   SELECT 
    account_id,
    account_type,
    balance,
    currency
    FROM Account
    WHERE balance > (SELECT AVG(balance) FROM Account)
    ORDER BY balance DESC;

-- =====================================================
/* Find all transactions whose amount is greater than
   the average transaction amount in the bank.

   Show:
   transaction_id
   account_id
   transaction_type
   amount
   transaction_date

   Order from highest amount to lowest. */
-- =====================================================
 
  SELECT 
   transaction_id,
   account_id,
   transaction_type,
   amount,
   transaction_date 
    FROM BankTransaction 
    WHERE amount > (SELECT AVG(amount) FROM BankTransaction)
    ORDER BY amount DESC ;

-- =====================================================
/* Find the account or accounts that have the
   highest balance in the bank.
 
   Show:
   account_id
   account_type
   balance
   currency                              */
-- =====================================================
  
     SELECT 
      a.account_id,
      a.account_type,
      a.balance,
      a.currency
      FROM account as a 
      WHERE a.balance = (SELECT max(balance) from account) 
      ORDER BY a.account_id ;

-- =====================================================
/* Find the loan or loans with the highest loan amount.
  
   Show:
   loan_id
   customer_id
   loan_type
   loan_amount             */
-- =====================================================

   SELECT
   l.loan_id,
   l.customer_id,
   l.loan_type,
   l.loan_amount
   FROM Loan as l
   WHERE l.loan_amount = (SELECT max(loan_amount) FROM loan) ;

-- =====================================================
/* Find customers who have at least one account.

   Show:
   customer_id
   first_name
   last_name           */
-- =====================================================

   SELECT
    c.customer_id,
    c.first_name,
    c.last_name
       FROM Customer AS c
       WHERE c.customer_id IN
( SELECT a.customer_id
    FROM Account AS a
);

-- =====================================================
/* Find customers who have a loan.

   Show:
   customer_id
   first_name
   last_name                */
-- =====================================================

     SELECT
      c.customer_id, 
      c.first_name,
      c.last_name 
      FROM customer as c  
      WHERE c.customer_id IN (
        SELECT 
        l.customer_id
        FROM loan as l
      ) ;

-- =====================================================
/* Find customers who do NOT have a loan.
  
   Show:
   customer_id
   first_name
   last_name            */
-- =====================================================

      SELECT 
      c.customer_id, 
      c.first_name, 
      c.last_name
      FROM customer as c  
      WHERE c.customer_id NOT IN (
        SELECT 
        l.customer_id 
        FROM loan as l
      ) ;

-- =====================================================
/* Find accounts that have at least one transaction
   greater than 25,000.
  
   Show:
   account_id
   account_type
   balance
   currency                            */
-- =====================================================

    SELECT 
     a.account_id, 
     a.account_type, 
     a.balance,
     a.currency 
     FROM account as a 
     WHERE a.account_id IN (
        SELECT 
        b.account_id 
        FROM BankTransaction as b 
        WHERE b.amount > 25000
     );

-- =====================================================
/* Find customers who own an account whose balance
   is greater than 40,000.
  
   Show:
   customer_id
   first_name
   last_name                   */
-- =====================================================

   SELECT 
   c.customer_id, 
   c.first_name, 
   c.last_name 
   FROM customer as c
   WHERE c.customer_id IN (
    SELECT 
    a.customer_id
    FROM account as a 
    WHERE a.balance > 40000
   ) ;

-- =====================================================
/* Find accounts whose total transaction volume is
   greater than the average total transaction volume
   across all accounts.
  
   Show:
    account_id
   total_transaction_volume.          */
-- =====================================================

SELECT 
  t.account_id,
  SUM(t.amount) as total_transaction_volume
FROM BankTransaction as t
GROUP BY t.account_id 
HAVING SUM (t.amount) > (
SELECT AVG(account_total) 
  FROM (
  SELECT 
    SUM(bt.amount) as account_total 
  FROM BankTransaction as bt  
  GROUP by bt.account_id  ) as total ) ;

-- =====================================================
/* Find transactions made from accounts whose balance
   is greater than the average account balance.
  
   Show:
   transaction_id
   account_id
   transaction_type
  amount                                */
-- =====================================================

 SELECT 
    bt.transaction_id, 
    bt.account_id, 
    bt.transaction_type, 
    bt.amount 
FROM BankTransaction AS bt
WHERE bt.account_id IN (
    SELECT
        a.account_id
    FROM Account AS a
    WHERE a.balance > (
        SELECT AVG(a2.balance)
        FROM Account AS a2
    )
);

-- =====================================================
/* Find customers whose account balance is greater
   than the average account balance.
  
   Show:
   customer_id
   first_name
   last_name

   Avoid duplicate customers.           */
-- =====================================================

  SELECT 
  c.customer_id, 
  c.first_name,
  c.last_name
  FROM customer as c   
  WHERE c.customer_id IN (
    SELECT
    a.customer_id 
    FROM account as a 
    WHERE a.balance > (
   SELECT 
    AVG(a2.balance)
    FROM account as a2
    )
  ) ;

-- =====================================================
/* Find customers who have at least one active loan
   using EXISTS.
  
   Show:
   customer_id
   first_name
   last_name.                   */
-- =====================================================

         SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM Customer AS c
WHERE EXISTS
(
    SELECT 1
    FROM Loan AS l
    WHERE l.customer_id = c.customer_id
      AND l.status = 'Active'
);

-- =====================================================
/* Find customers who do NOT have any loan.
    (NOT EXISTS instead of NOT IN)

   Show:
   customer_id
   first_name
   last_name                      */
-- =====================================================

  SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM Customer AS c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Loan AS l
    WHERE l.customer_id = c.customer_id
);

-- =====================================================
/* Find accounts that have at least one transaction
   greater than 20,000 using EXISTS.
  
   Show:
   account_id
   account_type
   balance                                */
-- =====================================================

      SELECT 
      a.account_id,
      a.account_type, 
      a.balance 
      FROM account as a 
      WHERE EXISTS (
         SELECT 1 
         From BankTransaction as bt 
         WHERE a.account_id = bt.account_id 
         AND bt.amount > 20000 
      );

-- =====================================================
/* Find customers whose total account balance is greater
   than the average total account balance per customer.
  
   Show:
   customer_id
   first_name
   last_name
   total_balance                */
-- =====================================================
  
         SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(a.balance) as total_balance
        FROM customer as c
        JOIN account as a
          on c.customer_id = a.customer_id
         GROUP BY 
             c.customer_id,
             c.first_name, 
             c.last_name
         HAVING SUM(a.balance) > (  
           SELECT         
          AVG(customer_total) FROM 
            (
               SELECT  
               SUM(ac.balance) as customer_total
               From account as ac 
               Group by ac.customer_id 
            ) as customer_totals
         ) ;

-- =====================================================
/* Find transactions whose amount is greater than
   the average transaction amount for THAT SAME account.

   Show:
   transaction_id
   account_id
   amount
   transaction_date           */
-- =====================================================

  SELECT
    t.transaction_id,
    t.account_id,
    t.amount,
    t.transaction_date
FROM BankTransaction AS t
WHERE t.amount >
(
    SELECT AVG(bt.amount)
    FROM BankTransaction AS bt
    WHERE bt.account_id = t.account_id
);

-- =====================================================
/* Find accounts whose balance is greater than
   the average balance of accounts using the
   same currency.
  
   Show:
   account_id
   account_type
   currency
   balance                    */
-- =====================================================

      SELECT 
       a.account_id, 
       a.account_type, 
       a.currency, 
       a.balance 
       FROM account as a 
       WHERE a.balance > (
               SELECT 
               AVG(ac.balance)
               FROM account as ac 
      WHERE a.currency = ac.currency ) ;

-- =====================================================
/* Find customers who have BOTH:
 
   1. At least one loan
   2. At least one account with balance greater than 30,000
 
   Show:
   customer_id
   first_name
   last_name                         */
-- =====================================================
    
     SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM Customer AS c
WHERE EXISTS
(
    SELECT 1
    FROM Loan AS l
    WHERE l.customer_id = c.customer_id
)
AND EXISTS
(
    SELECT 1
    FROM Account AS a
    WHERE a.customer_id = c.customer_id
      AND a.balance > 30000
);

-- =====================================================
/* Find customers who have at least one transaction
   greater than the average transaction amount
   across the entire bank.
  
   Show:
   customer_id
   first_name
   last_name

   Avoid duplicate customers.        */
-- =====================================================

     SELECT 
      c.customer_id, 
      c.first_name, 
      c.last_name 
      FROM customer as c
        WHERE EXISTS
    ( 
        SELECT 1
      FROM account as a 
      WHERE a.customer_id = c.customer_id 
      AND EXISTS  
        (
           SELECT 1
           FROM BankTransaction as t 
           WHERE t.account_id = a.account_id 
            AND t.amount > 
            (
                SELECT 
                 AVG(bt.amount)
                FROM BankTransaction as bt 
             )
        ) 
    );
