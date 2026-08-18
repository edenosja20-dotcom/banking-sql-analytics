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

   SELECT TOP 10 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    SUM(t.amount) as total_account_balance
    FROM customer as c  
    JOIN account as a   
      on c.customer_id = a.customer_id 
    JOIN BankTransaction as t 
      on t.account_id = a.account_id 
    GROUP BY c.customer_id, c.first_name, c.last_name
    ORDER BY total_account_balance DESC ;   

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

    SELECT
      b.branch_id,
      b.branch_name,
      b.city,
      COUNT(DISTINCT a.account_id) AS number_of_accounts,
      COUNT(t.transaction_id) AS number_of_transactions,
      SUM(t.amount) AS total_transaction_volume,
      AVG(t.amount) AS average_transaction_amount
    FROM Branch AS b
    JOIN Account AS a
      ON b.branch_id = a.branch_id
    JOIN BankTransaction AS t
      ON a.account_id = t.account_id
    GROUP BY b.branch_id, b.branch_name, b.city
    ORDER BY total_transaction_volume DESC;
   
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

     SELECT 
       t.transaction_type, 
       COUNT(t.transaction_type) as number_of_transactions, 
       SUM(t.amount) as total_transaction_volume, 
       AVG(t.amount) as average_transaction_amount, 
       MAX(t.amount) as largest_transaction 
       FROM BankTransaction as t 
       GROUP BY t.transaction_type 
       ORDER BY total_transaction_volume DESC ;

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

         SELECT
          YEAR(t.transaction_date) AS transaction_year,
          MONTH(t.transaction_date) AS transaction_month,
          COUNT(*) AS number_of_transactions,
          SUM(t.amount) AS total_transaction_volume,
          AVG(t.amount) AS average_transaction_amount
        FROM BankTransaction AS t
        GROUP BY YEAR(t.transaction_date), MONTH(t.transaction_date)
        ORDER BY transaction_year ASC, transaction_month ASC;

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
    
       WITH monthly_volume AS (
        SELECT 
           YEAR(t.transaction_date) AS transaction_year, 
           MONTH(t.transaction_date) AS transaction_month, 
           SUM(t.amount) as total_transaction_volume 
           FROM BankTransaction as t 
           GROUP BY YEAR(t.transaction_date), MONTH(t.transaction_date) 
       )

         SELECT 
          transaction_year, 
          transaction_month, 
          total_transaction_volume, 
          LAG(total_transaction_volume) OVER (
              ORDER BY transaction_year, transaction_month
          ) as previous_month_volume,
          total_transaction_volume - LAG(total_transaction_volume) OVER (
              ORDER BY transaction_year, transaction_month 
          ) as volume_difference 
        FROM monthly_volume 
        ORDER BY transaction_year ASC, transaction_month ASC ;

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
   
       WITH total_trans_volume1 as (
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
            FROM total_trans_volume1 
            WHERE total_trans_volume > (
                SELECT AVG(total_trans_volume)
                FROM total_trans_volume1 
            )
            ORDER BY total_trans_volume DESC ;

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

      WITH total_balance as (
         SELECT 
           c.customer_id, 
           c.first_name, 
           c.last_name, 
           SUM(a.balance) as total_account_balance 
           FROM customer as c  
           JOIN account as a   
             on c.customer_id = a.customer_id  
           GROUP BY c.customer_id, c.first_name, c.last_name
      )
        SELECT 
         customer_id,
         first_name, 
         last_name, 
         total_account_balance 
        FROM total_balance 
        WHERE total_account_balance > (
            SELECT AVG(total_account_balance)
            FROM total_balance
        )
        ORDER BY total_account_balance DESC ;

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

  WITH nr_of_accounts as (
     SELECT 
      c.customer_id, 
      c.first_name, 
      c.last_name, 
      COUNT(*) as number_of_accounts, 
      SUM(a.balance) as total_account_balance 
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
       number_of_accounts,
       total_account_balance
    FROM nr_of_accounts
    WHERE number_of_accounts > 1 
    ORDER BY number_of_accounts DESC ;

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

SELECT 
    l.loan_type,
    COUNT(*) AS number_of_loans,
    SUM(l.loan_amount) AS total_loan_amount,
    AVG(l.loan_amount) AS average_loan_amount,
    AVG(l.interest_rate) AS average_interest_rate,
    MAX(l.loan_amount) AS largest_loan_amount
FROM loan AS l
GROUP BY l.loan_type
ORDER BY total_loan_amount DESC;

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

   SELECT TOP 10
      c.customer_id, 
      c.first_name, 
      c.last_name, 
      COUNT(*) as number_of_loans, 
      SUM(l.loan_amount) as total_loan_amount 
    FROM customer as c  
    JOIN loan as l
      on c.customer_id = l.customer_id 
    GROUP BY c.customer_id, c.first_name, c.last_name 
    ORDER BY total_loan_amount DESC ;

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
    
    WITH account_totals AS
  (
    SELECT
        a.customer_id,
        SUM(a.balance) AS total_account_balance
    FROM Account AS a
    GROUP BY a.customer_id
  ),
   transaction_totals AS (
    SELECT
        a.customer_id,
        SUM(t.amount) AS total_transaction_volume
    FROM Account AS a
    JOIN BankTransaction AS t
        ON t.account_id = a.account_id
    GROUP BY a.customer_id
  ),
    loan_totals AS (
    SELECT
        l.customer_id,
        SUM(l.loan_amount) AS total_loan_amount
    FROM Loan AS l
    GROUP BY l.customer_id
)
       SELECT
          c.customer_id,
          c.first_name,
          c.last_name,
          COALESCE(at.total_account_balance, 0) AS total_account_balance,
          COALESCE(tt.total_transaction_volume, 0) AS total_transaction_volume,
          COALESCE(lt.total_loan_amount, 0) AS total_loan_amount
        FROM Customer AS c
        LEFT JOIN account_totals AS at
          ON at.customer_id = c.customer_id
        LEFT JOIN transaction_totals AS tt
          ON tt.customer_id = c.customer_id
        LEFT JOIN loan_totals AS lt
          ON lt.customer_id = c.customer_id
        ORDER BY total_transaction_volume DESC;

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

WITH total_trans_volume as (
    SELECT 
      a.customer_id,
      SUM(t.amount) as total_transaction_volume 
    FROM BankTransaction as t 
    JOIN account as a 
      on a.account_id = t.account_id
    GROUP BY a.customer_id
),
  total_loan_amount as (
      SELECT 
        l.customer_id, 
        SUM(l.loan_amount) as total_active_loan_amount
      FROM loan as l 
      GROUP BY l.customer_id 
  ) 
      SELECT 
        c.customer_id,
        c.first_name, 
        c.last_name, 
        tt.total_transaction_volume, 
        total_active_loan_amount
      FROM customer as c 
      JOIN total_trans_volume as tt 
         on c.customer_id = tt.customer_id 
      JOIN total_loan_amount as tl  
         on tl.customer_id = c.customer_id 
      ORDER BY  tt.total_transaction_volume DESC ;

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

     SELECT 
        a.currency, 
        COUNT(*) as number_of_accounts,
        SUM(a.balance) as total_account_balance,
        AVG(a.balance) as average_account_balance,
        SUM(t.amount) as total_transaction_volume 
      FROM account as a 
      JOIN BankTransaction as t
         on a.account_id = t.account_id 
      GROUP BY a.currency
      ORDER BY total_transaction_volume DESC ; 

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

     SELECT 
        a.status,
        COUNT(*) as number_of_accounts, 
        SUM(a.balance) as total_account_balance, 
        AVG(a.balance) as average_account_balance, 
        SUM(t.amount) as total_transaction_volume
      FROM account as a 
      JOIN BankTransaction as t
         on a.account_id = t.account_id 
       GROUP BY a.status ;

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