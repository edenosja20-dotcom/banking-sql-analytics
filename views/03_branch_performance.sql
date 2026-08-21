USE NovaBankDB;
GO

-- =====================================================
/* Create a view called vw_BranchPerformance.

   Return one row per branch.

   Show:
   branch_id
   branch_name
   city
   number_of_accounts
   number_of_transactions
   total_transaction_volume
   average_transaction_amount

*/
-- =====================================================

CREATE VIEW vw_BranchPerformance AS 

 WITH BranchProfile as (
    SELECT    
       b.branch_id, 
       b.branch_name, 
       b.city,
       COUNT(DISTINCT a.account_id) as number_of_accounts,
       COUNT(t.transaction_id) as number_of_transactions,
       COALESCE(SUM(t.amount),0) as total_transaction_volume,
       COALESCE(AVG(t.amount), 0) as average_transaction_amount
    FROM branch as b  
    LEFT JOIN account as a  
          on b.branch_id = a.branch_id 
    LEFT JOIN BankTransaction AS t 
          on t.account_id = a.account_id    
    GROUP BY b.branch_id, b.branch_name, b.city
 )

  SELECT 
   branch_id, 
   branch_name, 
   city,
   number_of_accounts, 
   number_of_transactions,
   total_transaction_volume,
   average_transaction_amount
FROM BranchProfile ;
GO

SELECT *
FROM vw_BranchPerformance;