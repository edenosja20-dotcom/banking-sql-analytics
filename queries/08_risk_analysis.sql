USE NovaBankDB;
GO

-- =====================================================
/* Find all high-value transactions with an amount
   greater than 25,000.

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
        WHERE amount > 25000
        ORDER BY amount DESC ;

-- =====================================================
/* Identify transactions whose amount is greater than
   three times the average transaction amount of the
   same account.

   Show:
   transaction_id
   account_id
   amount
   average_account_transaction
   transaction_date

   Order by amount from highest to lowest. */
-- =====================================================

   WITH Transaction_avg as (
    SELECT 
      t.transaction_id, 
      t.account_id, 
      t.amount, 
      AVG(t.amount) OVER (PARTITION BY t.account_id ) AS average_account_transaction,
      t.transaction_date 
      FROM BankTransaction AS t
   )
    
       SELECT 
         transaction_id, 
         account_id, 
         amount, 
         average_account_transaction,
         transaction_date
       FROM Transaction_avg 
       WHERE amount > 3 * average_account_transaction
       ORDER BY amount DESC ; 

-- =====================================================
/* Identify transactions whose amount is greater than
   twice the average transaction amount of the customer
   who made the transaction.

   Show:
   customer_id
   first_name
   last_name
   transaction_id
   amount
   customer_average_transaction
   transaction_date

   Order by amount from highest to lowest. */
-- =====================================================
 
 WITH Transaction_average as (
     SELECT 
       c.customer_id, 
       c.first_name, 
       c.last_name, 
       t.transaction_id, 
       t.amount, 
       AVG(t.amount) OVER (PARTITION BY c.customer_id) as customer_average_transaction,
       t.transaction_date 
     FROM customer as c 
     JOIN account as a 
         on c.customer_id = a.customer_id 
     JOIN BankTransaction as t 
         on t.account_id = a.account_id 
 )
   SELECT 
    customer_id, 
    first_name,
    last_name, 
    transaction_id, 
    amount, 
    customer_average_transaction,
    transaction_date 
   FROM Transaction_average
   WHERE amount > 2* customer_average_transaction
   ORDER BY amount DESC ;

-- =====================================================
/* Find accounts that have made at least five
   transactions greater than 20,000.

   Show:
   account_id
   customer_id
   number_of_high_value_transactions
   total_high_value_volume

   Order by number of high-value transactions
   from highest to lowest. */
-- =====================================================


    




-- =====================================================
/* Find customers whose total transaction volume is
   greater than 1,000,000.

   Show:
   customer_id
   first_name
   last_name
   number_of_transactions
   total_transaction_volume
   average_transaction_amount

   Order by total transaction volume from highest
   to lowest. */
-- =====================================================







-- =====================================================
/* Identify accounts where at least one transaction
   is greater than the current account balance.

   Show:
   account_id
   customer_id
   balance
   transaction_id
   transaction_amount
   transaction_date

   Order by the difference between transaction amount
   and account balance from highest to lowest. */
-- =====================================================







-- =====================================================
/* Find customers whose total transaction volume is
   more than five times their total account balance.

   Show:
   customer_id
   first_name
   last_name
   total_account_balance
   total_transaction_volume
   transaction_to_balance_ratio

   Order by the ratio from highest to lowest. */
-- =====================================================







-- =====================================================
/* Calculate the total transaction volume for each
   account for each day.

   Return only account-days where the total daily
   transaction volume is greater than 50,000.

   Show:
   account_id
   transaction_date
   number_of_transactions
   daily_transaction_volume

   Order by daily transaction volume from highest
   to lowest. */
-- =====================================================







-- =====================================================
/* Find accounts that made more than five transactions
   on the same day.

   Show:
   account_id
   transaction_date
   number_of_transactions
   total_daily_volume

   Order by number of transactions from highest
   to lowest. */
-- =====================================================







-- =====================================================
/* Compare every transaction with the previous
   transaction for the same account.

   Find transactions whose amount is at least twice
   the amount of the previous transaction.

   Show:
   account_id
   transaction_id
   transaction_date
   previous_transaction_amount
   current_transaction_amount
   amount_difference

   Order by amount_difference from highest to lowest. */
-- =====================================================







-- =====================================================
/* Identify unusually large transactions using the
   statistical behavior of the entire bank.

   Return transactions whose amount is greater than:

       average transaction amount
       +
       2 * standard deviation

   Show:
   transaction_id
   account_id
   amount
   bank_average_transaction
   bank_transaction_stddev
   transaction_date

   Order by amount from highest to lowest. */
-- =====================================================







-- =====================================================
/* Find each customer's largest transaction and
   calculate what percentage of that customer's total
   transaction volume it represents.

   Show:
   customer_id
   first_name
   last_name
   largest_transaction
   total_transaction_volume
   largest_transaction_percentage

   Order by largest_transaction_percentage from
   highest to lowest. */
-- =====================================================







-- =====================================================
/* Identify customers whose total loan exposure is
   greater than their total account balance.

   Show:
   customer_id
   first_name
   last_name
   total_account_balance
   total_loan_amount
   loan_to_balance_ratio

   Order by loan_to_balance_ratio from highest
   to lowest. */
-- =====================================================







-- =====================================================
/* Find customers who have an active loan but whose
   total account balance is less than 20,000.

   Show:
   customer_id
   first_name
   last_name
   total_account_balance
   total_active_loan_amount

   Order by total active loan amount from highest
   to lowest. */
-- =====================================================







-- =====================================================
/* Identify customers who simultaneously have:

   - at least one active loan
   - total transaction volume greater than 500,000
   - total account balance below the average customer
     account balance

   Show:
   customer_id
   first_name
   last_name
   total_account_balance
   total_transaction_volume
   total_active_loan_amount

   Order by transaction volume from highest to lowest. */
-- =====================================================







-- =====================================================
/* Find accounts whose most recent transaction happened
   more than 90 days ago.

   Show:
   account_id
   customer_id
   account_status
   balance
   last_transaction_date

   Order from the oldest last transaction to
   the newest. */
-- =====================================================







-- =====================================================
/* Identify customers who have multiple accounts and
   calculate the transaction volume generated by each
   account.

   Rank each customer's accounts from highest
   transaction volume to lowest.

   Show:
   customer_id
   account_id
   account_type
   account_balance
   account_transaction_volume
   account_rank

   Return only customers who own more than one account. */
-- =====================================================







-- =====================================================
/* Find customers whose transaction volume increased
   significantly from one month to the next.

   First calculate monthly transaction volume for
   each customer.

   Return customer-months where the current month's
   volume is more than 50% higher than the previous
   month's volume.

   Show:
   customer_id
   transaction_year
   transaction_month
   current_month_volume
   previous_month_volume
   percentage_increase

   Order by percentage_increase from highest
   to lowest. */
-- =====================================================







-- =====================================================
/* Identify the 10 accounts with the highest ratio
   between their largest transaction and their average
   transaction amount.

   Show:
   account_id
   average_transaction_amount
   largest_transaction_amount
   max_to_average_ratio
   number_of_transactions

   Order by the ratio from highest to lowest. */
-- =====================================================







-- =====================================================
/* Create a customer risk overview.

   For every customer calculate:

   total_account_balance
   total_transaction_volume
   largest_transaction
   total_loan_amount
   number_of_accounts
   number_of_transactions

   Also create the following risk flags:

   high_transaction_flag:
       1 if largest transaction > 25,000
       otherwise 0

   high_volume_flag:
       1 if total transaction volume > 1,000,000
       otherwise 0

   loan_exposure_flag:
       1 if total loan amount > total account balance
       otherwise 0

   Create:

       risk_score =
       high_transaction_flag
       + high_volume_flag
       + loan_exposure_flag

   Show all customer information and risk_score.

   Order customers by risk_score from highest to
   lowest, then by transaction volume from highest
   to lowest. */
-- =====================================================