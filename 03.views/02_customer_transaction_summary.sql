USE NovaBankDB;
GO

-- =====================================================
/* Create a view called vw_CustomerTransactionSummary.

   Return one row per customer.

   Show:
   customer_id
   first_name
   last_name
   number_of_transactions
   total_transaction_volume
   average_transaction_amount
   largest_transaction
   last_transaction_date
*/
-- =====================================================

CREATE VIEW vw_CustomerTransactionSummary as 

 WITH Transaction_summary as (
    SELECT
       a.customer_id, 
       COUNT(bt.transaction_id) as number_of_transactions,
       SUM(bt.amount) as total_transaction_volume,
       AVG(bt.amount) as average_transaction_amount,
       MAX(bt.amount) as largest_transaction,
       MAX(bt.transaction_date) as last_transaction_date
     FROM account as a   
     LEFT JOIN BankTransaction as bt     
        on a.account_id = bt.account_id
     GROUP BY customer_id 
 )
  SELECT
    c.customer_id,
    c.first_name, 
    c.last_name, 
    COALESCE(t.number_of_transactions, 0) as number_of_transactions,
    COALESCE(t.total_transaction_volume, 0) as total_transaction_volume,
    COALESCE(t.average_transaction_amount, 0) as average_transaction_amount,
    COALESCE(t.largest_transaction, 0) as largest_transaction,
    t.last_transaction_date
  FROM customer as c 
  LEFT JOIN Transaction_summary as t 
    on c.customer_id = t.customer_id ;
GO

SELECT *
FROM vw_CustomerTransactionSummary;