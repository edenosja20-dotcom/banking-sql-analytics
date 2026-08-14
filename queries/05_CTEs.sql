
USE NovaBankDB ;
GO 


-- =====================================================
/* Calculate the total transaction volume for each account.

   Show:
   account_id
   total_transaction_volume

   Use a CTE named AccountTotals.

   Order from highest transaction volume to lowest. */
-- =====================================================
     
      WITH AccountTotals AS
        (
           SELECT
             account_id,
             SUM(amount) AS total_transaction_volume
           FROM BankTransaction
           GROUP BY account_id
        )
           SELECT
           account_id,
           total_transaction_volume
           FROM AccountTotals
           ORDER BY total_transaction_volume DESC;

-- =====================================================
/* Calculate the total account balance for each customer.

   Show:
   customer_id
   total_balance

   Use a CTE named CustomerBalances.

   Order from highest total balance to lowest. */
-- =====================================================

   WITH CustomerBalances as (
           
             SELECT
               c.customer_id, 
               SUM(a.balance) as total_balance 
              FROM customer as c 
              JOIN account as a 
                 on c.customer_id = a.customer_id 
               group by c.customer_id 

   ) 
      SELECT
      customer_id, 
      total_balance
      FROM CustomerBalances  
      ORDER BY total_balance DESC; 

-- =====================================================
/* Calculate the number of transactions for each account.

   Show:
   account_id
   transaction_count

   Use a CTE named TransactionCounts.

   Order from the account with the most transactions
   to the account with the fewest. */
-- =====================================================

    WITH TransactionCounts as (
        
          SELECT 
           account_id, 
           COUNT(transaction_id) as transaction_count
           FROM BankTransaction
           GROUP BY account_id  

    )
     SELECT 
      account_id, 
      transaction_count 
      FROM TransactionCounts 
      ORDER BY transaction_count DESC ;

-- =====================================================
/* Find accounts whose total transaction volume
   is greater than 400,000.

   Show:
   account_id
   total_transaction_volume

   First calculate the transaction totals inside a CTE,
   then filter the CTE in the outer query.

   Order from highest volume to lowest. */
-- =====================================================

     WITH volume_counts  as (

         SELECT 
          bt.account_id,
          SUM(bt.amount) as total_transaction_volume
          FROM BankTransaction as bt
          GROUP BY account_id 

     )
         SELECT 
     account_id,
     total_transaction_volume 
     FROM volume_counts
     WHERE total_transaction_volume > 400000
     ORDER BY total_transaction_volume DESC ;

-- =====================================================
/* Find customers whose total account balance
   is greater than 40,000.

   Show:
   customer_id
   first_name
   last_name
   total_balance

   Use a CTE that joins Customer and Account
   and calculates SUM(balance) per customer. */
-- =====================================================

      WITH totBalance_Customer as (
         
          SELECT 
          c.customer_id, 
          c.first_name, 
          c.last_name, 
          SUM(a.balance) as total_balance
          FROM Customer as c 
          JOIN account as a 
             on c.customer_id = a.customer_id 
          GROUP BY c.customer_id, c.first_name, c.last_name     
      )
      SELECT 
       customer_id, 
       first_name, 
       last_name, 
       total_balance 
       FROM totBalance_Customer
       WHERE total_balance > 40000 ;
         
-- =====================================================
/* Calculate the total transaction volume for each customer.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume

   Use:
   Customer
   Account
   BankTransaction

   Build the result inside a CTE.

   Order from highest transaction volume to lowest. */
-- =====================================================

     WITH total_trans_volume as (

        SELECT 
          c.customer_id, 
          c.first_name, 
          c.last_name, 
          SUM(t.amount) as total_trans_volume1 
          FROM customer as c  
          JOIN account as a 
            on c.customer_id = a.customer_id  
          JOIN BankTransaction as t 
            on a.account_id = t.account_id   
          GROUP BY c.customer_id, c.first_name, c.last_name 
     )
        SELECT 
        customer_id, 
        first_name, 
        last_name,
        total_trans_volume1  
        FROM total_trans_volume 
        ORDER BY total_trans_volume1 DESC ;

-- =====================================================
/* Find customers whose total transaction volume
   is greater than 500,000.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume

   First calculate customer transaction totals
   inside a CTE.

   Filter the CTE in the outer query. */
-- =====================================================

       WITH tot_trans_volume as (
           SELECT 
            c.customer_id, 
            c.first_name, 
            c.last_name, 
            SUM(t.amount) as total_trans_volume 
          FROM customer as c 
          JOIN account as a   
            on c.customer_id = a.customer_id 
          JOIN BankTransaction as t 
            on t.account_id = a.account_id 
           GROUP BY c.customer_id, c.first_name, c.last_name  
       )
            SELECT 
              customer_id, 
              first_name, 
              last_name, 
              total_trans_volume
            FROM tot_trans_volume 
            WHERE total_trans_volume > 500000;

-- =====================================================
/* Calculate the total transaction volume handled
   by each branch.

   Show:
   branch_id
   branch_name
   city
   total_transaction_volume

   Use:
   Branch
   Account
   BankTransaction

   Build the branch totals inside a CTE.

   Order from highest volume to lowest. */
-- =====================================================

  WITH total_volume_perBranch as (

      SELECT 
       b.branch_id, 
       b.branch_name, 
       b.city, 
       COUNT(t.amount) as total_trans_volume
       FROM Branch as b 
       JOIN account as a    
         on b.branch_id = a.branch_id 
       JOIN banktransaction as t 
         on t.account_id = t.account_id 
        GROUP BY b.branch_id, b.branch_name, b.city 
  )     
    SELECT 
     branch_id, 
     branch_name, 
     city, 
     total_trans_volume 
     FROM total_volume_perBranch 
     ORDER BY total_trans_volume DESC;    
               
-- =====================================================
/* Find accounts whose total transaction volume is
   greater than the average total transaction volume
   across all accounts.

   Show:
   account_id
   total_transaction_volume


   Then compare each total with the average
   of total_transaction_volume from that CTE. */
-- =====================================================
   
     WITH total_trans_volume as (

          SELECT 
          t.account_id, 
          SUM(t.amount) as total_trans_volume1 
          FROM BankTransaction as t 
          GROUP BY t.account_id
     ) 
       SELECT 
         account_id,
         total_trans_volume1 
         FROM total_trans_volume
         WHERE total_trans_volume1 > (
            SELECT AVG(total_trans_volume1)
            FROM total_trans_volume
         ) ;

-- =====================================================
/* Find customers whose total account balance is
   greater than the average total account balance
   across all customers.

   Show:
   customer_id
   total_balance

   Create a CTE that calculates SUM(balance)
   for each customer.

   Then compare each customer's total_balance
   with AVG(total_balance) from the CTE. */
-- =====================================================






-- =====================================================
/* Find the customers with the highest total
   transaction volume.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume

   Use a CTE to calculate the transaction volume
   for every customer.

   Return the customer or customers whose volume
   equals the maximum total_transaction_volume. */
-- =====================================================






-- =====================================================
/* Calculate the average transaction amount
   for each customer.

   Show:
   customer_id
   first_name
   last_name
   average_transaction_amount

   Use a CTE involving:
   Customer
   Account
   BankTransaction

   Order from highest average to lowest. */
-- =====================================================






-- =====================================================
/* Find customers who own more than one account.

   Show:
   customer_id
   first_name
   last_name
   number_of_accounts

   Create a CTE that counts the number of accounts
   owned by each customer.

   Filter the CTE in the outer query so that only
   customers with more than one account are returned. */
-- =====================================================






-- =====================================================
/* Find the total number of transactions and
   total transaction volume for each customer.

   Show:
   customer_id
   first_name
   last_name
   transaction_count
   total_transaction_volume

   Use a CTE.

   Order from highest transaction volume to lowest. */
-- =====================================================






-- =====================================================
/* Find customers who have both:

   1. A total account balance greater than 30,000
   2. A total transaction volume greater than 500,000

   Show:
   customer_id
   first_name
   last_name
   total_balance
   total_transaction_volume

   Use TWO CTEs:

   CustomerBalances
   CustomerTransactionTotals

   Then join the two CTEs together in the final query. */
-- =====================================================






-- =====================================================
/* Compare each customer's total transaction volume
   with the average customer transaction volume.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume

   Return only customers whose transaction volume
   is above the average customer transaction volume.

   Use a CTE to calculate customer totals first. */
-- =====================================================






-- =====================================================
/* Find branches whose total transaction volume
   is greater than the average transaction volume
   across all branches.

   Show:
   branch_id
   branch_name
   city
   total_transaction_volume

   First calculate transaction volume per branch
   inside a CTE.

   Then compare each branch total with the
   average of the CTE results. */
-- =====================================================






-- =====================================================
/* Create two CTEs.

   The first CTE should calculate:
   total account balance per customer.

   The second CTE should calculate:
   total loan amount per customer.

   Then combine them to display:

   customer_id
   first_name
   last_name
   total_account_balance
   total_loan_amount

   Return only customers who have a loan.

   Order from highest total loan amount to lowest. */
-- =====================================================