USE NovaBankDB;
GO

-- =====================================================
/* Identify the 10 customers who generated the highest
   total transaction volume.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume

   Order from highest transaction volume to lowest. */
-- =====================================================

       SELECT TOP 10 
        c.customer_id, 
        c.first_name, 
        c.last_name, 
        SUM(t.amount) as total_transaction_volume 
        FROM customer as c 
        JOIN account as a   
          on c.customer_id = a.customer_id 
        JOIN BankTransaction as t 
          on t.account_id = a.account_id   
        GROUP BY c.customer_id, c.first_name, c.last_name 
        ORDER BY total_transaction_volume DESC ;

-- =====================================================
/* Identify the 10 customers with the highest total
   account balance.

   A customer may own multiple accounts.

   Show:
   customer_id
   first_name
   last_name
   total_account_balance

   Order from highest balance to lowest. */
-- =====================================================







-- =====================================================
/* Create a branch performance report.

   Show:
   branch_id
   branch_name
   city
   number_of_accounts
   number_of_transactions
   total_transaction_volume
   average_transaction_amount

   Order branches by total transaction volume
   from highest to lowest. */
-- =====================================================







-- =====================================================
/* Analyze transaction activity by transaction type.

   Show:
   transaction_type
   number_of_transactions
   total_transaction_volume
   average_transaction_amount
   largest_transaction

   Order by total transaction volume from highest
   to lowest. */
-- =====================================================







-- =====================================================
/* Create a monthly transaction performance report.

   Show:
   transaction_year
   transaction_month
   number_of_transactions
   total_transaction_volume
   average_transaction_amount

   Order chronologically from oldest month
   to newest month. */
-- =====================================================







-- =====================================================
/* Calculate the month-over-month change in total
   transaction volume.

   Show:
   transaction_year
   transaction_month
   total_transaction_volume
   previous_month_volume
   volume_difference

   volume_difference should be:

   current month volume - previous month volume

   Order chronologically. */
-- =====================================================







-- =====================================================
/* Find customers whose total transaction volume
   is greater than the average total transaction
   volume per customer.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume

   Order from highest volume to lowest. */
-- =====================================================







-- =====================================================
/* Find customers whose total account balance
   is greater than the average total account
   balance per customer.

   Show:
   customer_id
   first_name
   last_name
   total_account_balance

   Order from highest balance to lowest. */
-- =====================================================







-- =====================================================
/* Find customers who own more than one account
   and calculate their total balance.

   Show:
   customer_id
   first_name
   last_name
   number_of_accounts
   total_account_balance

   Order customers with the highest number
   of accounts first. */
-- =====================================================







-- =====================================================
/* Analyze the bank's loan portfolio by loan type.

   Show:
   loan_type
   number_of_loans
   total_loan_amount
   average_loan_amount
   average_interest_rate
   largest_loan_amount

   Order by total loan amount from highest to lowest. */
-- =====================================================







-- =====================================================
/* Identify the 10 customers with the highest
   total loan exposure.

   A customer may have more than one loan.

   Show:
   customer_id
   first_name
   last_name
   number_of_loans
   total_loan_amount

   Order highest loan exposure first. */
-- =====================================================







-- =====================================================
/* Create a customer financial profile.

   Show:
   customer_id
   first_name
   last_name
   total_account_balance
   total_transaction_volume
   total_loan_amount

   Include customers even if they do not have a loan.

   Order by total_transaction_volume from highest
   to lowest. */
-- =====================================================







-- =====================================================
/* Find customers who have an active loan
   and whose total transaction volume is greater
   than 500,000.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume
   total_active_loan_amount

   Order by transaction volume from highest to lowest. */
-- =====================================================







-- =====================================================
/* Analyze accounts by currency.

   Show:
   currency
   number_of_accounts
   total_account_balance
   average_account_balance
   total_transaction_volume

   Order by total transaction volume from highest
   to lowest. */
-- =====================================================







-- =====================================================
/* Compare active and inactive accounts.

   Show:
   account_status
   number_of_accounts
   total_account_balance
   average_account_balance
   total_transaction_volume

   This should provide one summary row for each
   account status. */
-- =====================================================







-- =====================================================
/* Identify each customer's largest transaction.

   Show:
   customer_id
   first_name
   last_name
   transaction_id
   transaction_date
   transaction_type
   amount

   Return one largest transaction per customer.

   Order from the largest transaction to the smallest. */
-- =====================================================







-- =====================================================
/* Find the three largest transactions for every
   transaction type.

   Show:
   transaction_type
   transaction_id
   account_id
   amount
   transaction_date
   transaction_rank

   Return only the top three transactions
   within each transaction type. */
-- =====================================================







-- =====================================================
/* Find customers who have no loan but have a total
   account balance greater than 40,000.

   Show:
   customer_id
   first_name
   last_name
   total_account_balance

   Order from highest balance to lowest. */
-- =====================================================







-- =====================================================
/* Identify high-value customers who satisfy BOTH:

   1. Their total account balance is greater than the
      average customer total account balance.

   2. Their total transaction volume is greater than the
      average customer total transaction volume.

   Show:
   customer_id
   first_name
   last_name
   total_account_balance
   total_transaction_volume

   Order by total transaction volume from highest
   to lowest. */
-- =====================================================







-- =====================================================
/* Measure customer concentration in transaction volume.

   Find the top 10 customers by total transaction volume
   and calculate what percentage of the bank's entire
   transaction volume each customer represents.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume
   percentage_of_bank_volume
   customer_rank

   Order by customer_rank. */
-- =====================================================