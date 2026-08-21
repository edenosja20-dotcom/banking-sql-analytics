USE NovaBankDB;
GO  
-- =====================================================
/* Create a view called vw_CustomerRiskProfile.

   Return one row per customer.

   Show:
   customer_id
   first_name
   last_name
   total_account_balance
   total_transaction_volume
   largest_transaction
   total_loan_amount
   number_of_accounts
   number_of_transactions
   high_transaction_flag
   high_volume_flag
   loan_exposure_flag
   risk_score

   high_transaction_flag:
       1 if largest_transaction > 25000
       otherwise 0
   high_volume_flag:
       1 if total_transaction_volume > 1000000
       otherwise 0
   loan_exposure_flag:
       1 if total_loan_amount > total_account_balance
       otherwise 0
   risk_score =
       high_transaction_flag
       + high_volume_flag
       + loan_exposure_flag
*/
-- =====================================================

CREATE VIEW vw_CustomerRiskProfile
AS

WITH account_totals AS
(
    SELECT 
      a.customer_id, 
      SUM(a.balance) as total_account_balance,
      COUNT(a.account_id) as number_of_accounts
    FROM account as a   
    GROUP BY a.customer_id 
),
transaction_totals AS
(
   SELECT 
     a.customer_id, 
     SUM(t.amount) as total_transaction_volume,
     MAX(t.amount) as largest_transaction,
     COUNT(t.transaction_id) as number_of_transactions
   FROM account as a
   JOIN BankTransaction as t  
     on a.account_id = t.account_id  
   GROUP BY a.customer_id
),
loan_totals AS
(
    SELECT 
       l.customer_id, 
       SUM(l.loan_amount) as total_loan_amount
    FROM loan as l  
    GROUP BY l.customer_id
),

risk_profile AS
(
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        COALESCE(a.total_account_balance, 0) AS total_account_balance,
        COALESCE(t.total_transaction_volume, 0) AS total_transaction_volume,
        COALESCE(t.largest_transaction, 0) AS largest_transaction,
        COALESCE(l.total_loan_amount, 0) AS total_loan_amount,
        COALESCE(a.number_of_accounts, 0) AS number_of_accounts,
        COALESCE(t.number_of_transactions, 0) AS number_of_transactions,
        CASE
            WHEN COALESCE(t.largest_transaction, 0) > 25000
            THEN 1
            ELSE 0
        END AS high_transaction_flag,
        CASE
            WHEN COALESCE(t.total_transaction_volume, 0) > 1000000
            THEN 1
            ELSE 0
        END AS high_volume_flag,
        CASE
            WHEN COALESCE(l.total_loan_amount, 0) > COALESCE(a.total_account_balance, 0)
            THEN 1
            ELSE 0
        END AS loan_exposure_flag
    FROM Customer AS c
    LEFT JOIN account_totals AS a
       ON c.customer_id = a.customer_id
    LEFT JOIN transaction_totals AS t
        ON c.customer_id = t.customer_id
    LEFT JOIN loan_totals AS l
        ON c.customer_id = l.customer_id
)
SELECT
    customer_id, 
    first_name, 
    last_name,
    total_account_balance,
    total_transaction_volume,
    largest_transaction,
    total_loan_amount,
    number_of_accounts,
    number_of_transactions, 
    high_transaction_flag,
    high_volume_flag,
    loan_exposure_flag,
    high_transaction_flag + high_volume_flag  + loan_exposure_flag AS risk_score
FROM risk_profile;
GO

SELECT *
FROM vw_CustomerRiskProfile;