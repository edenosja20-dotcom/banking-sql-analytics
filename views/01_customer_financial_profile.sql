USE NovaBankDB;
GO

CREATE VIEW vw_CustomerFinancialProfile as
 
 WITH account_totals as (
    SELECT
        customer_id, 
        SUM(balance) as total_account_balance
    FROM account
    GROUP BY customer_id 
 ),
  transaction_totals AS (
            
    SELECT 
        a.customer_id,
        SUM(t.amount) AS total_transaction_volume
    FROM Account AS a
    JOIN BankTransaction AS t
        ON a.account_id = t.account_id
    GROUP BY a.customer_id
  ),
  loan_totals as (
      SELECT 
        customer_id,
        SUM(loan_amount) as total_loan_amount
      FROM loan 
      GROUP BY customer_id
  )

     SELECT 
        c.customer_id, 
        c.first_name, 
        c.last_name, 
        COALESCE(at.total_account_balance, 0) AS total_account_balance,
        COALESCE(tt.total_transaction_volume, 0) AS total_transaction_volume,
        COALESCE(tl.total_loan_amount, 0) AS total_loan_amount
      FROM customer as c 
      LEFT JOIN account_totals as at 
         on  c.customer_id = at.customer_id 
      LEFT JOIN transaction_totals as tt 
        on tt.customer_id = c.customer_id 
      LEFT JOIN loan_totals as tl  
        on tl.customer_id = c.customer_id   ; 
        GO  

SELECT *
FROM vw_CustomerFinancialProfile;