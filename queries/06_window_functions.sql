USE NovaBankDB ;
GO 

-- =====================================================
/* Display every transaction together with the
   average transaction amount for the entire bank.

   Show:
   transaction_id
   account_id
   amount
   average_bank_transaction

   Use AVG() OVER(). */
-- =====================================================

    SELECT 
      t.transaction_id, 
      t.account_id, 
      t.amount, 
      AVG(t.amount) OVER () AS avg_bank_trans 
     FROM BankTransaction as t ;

-- =====================================================
/* Display every transaction together with the
   average transaction amount for that same account.

   Show:
   transaction_id
   account_id
   amount
   average_account_transaction

   Use:
   AVG() OVER()
   PARTITION BY account_id */
-- =====================================================

   SELECT 
    t.transaction_id, 
    t.account_id, 
    t.amount, 
    AVG(t.amount) OVER (
        PARTITION BY t.account_id
    ) as average_account_transaction 
    FROM BankTransaction as t ;

-- =====================================================
/* Display every transaction together with the
   total transaction volume for that same account.

   Show:
   transaction_id
   account_id
   amount
   total_account_transaction_volume

   Keep every individual transaction row.

   Use SUM() OVER() with PARTITION BY. */
-- =====================================================

       SELECT 
        t.transaction_id, 
        t.account_id,
        t.amount, 
        SUM(t.amount) OVER (
            PARTITION BY t.account_id 
        ) as total_account_transaction_volume
        FROM BankTransaction as t ;

-- =====================================================
/* Display every account and rank all accounts
   from highest balance to lowest balance.

   Show:
   account_id
   account_type
   balance
   balance_rank

   Use RANK(). */
-- =====================================================

     SELECT 
      a.account_id, 
      a.account_type, 
      a.balance, 
      RANK() OVER (
        ORDER BY a.balance DESC 
      ) AS balance_rank
    FROM account as a ;

-- =====================================================
/* Display every account and assign a unique row number
   based on balance from highest to lowest.

   Show:
   account_id
   account_type
   balance
   row_number

   Use ROW_NUMBER(). */
-- =====================================================

      SELECT 
      a.account_id, 
      a.account_type, 
      a.balance, 
      ROW_NUMBER() OVER (
        ORDER BY a.balance DESC
      ) as row_number 
      FROM account as a ;

-- =====================================================
/* Rank accounts from highest balance to lowest balance
   using DENSE_RANK().

   Show:
   account_id
   balance
   balance_rank

   Compare the result mentally with RANK(). */
-- =====================================================

      SELECT 
        a.account_id, 
        a.balance, 
        DENSE_RANK() OVER (
            ORDER BY a.balance DESC 
        ) as balance_rank
        FROM account as a ;

-- =====================================================
/* Rank accounts by balance separately inside
   each currency.

   Show:
   account_id
   currency
   balance
   currency_balance_rank

   Example:

   EUR accounts should be ranked only against EUR accounts.
   USD accounts should be ranked only against USD accounts.

   Use:
   RANK()
   PARTITION BY currency */
-- =====================================================

    SELECT 
     a.account_id, 
     a.currency, 
     a.balance, 
     RANK() OVER (
        PARTITION BY a.currency 
        ORDER BY a.balance DESC
     ) as currency_balance_rank
    FROM account as a ;

-- =====================================================
/* Rank transactions from largest to smallest
   separately for each account.

   Show:
   transaction_id
   account_id
   amount
   transaction_rank

   Use:
   ROW_NUMBER() or RANK()
   PARTITION BY account_id
   ORDER BY amount DESC */
-- =====================================================

   SELECT 
     t.transaction_id,
     t.account_id, 
     t.amount, 
    RANK() OVER (
        PARTITION BY t.account_id 
        ORDER BY t.amount DESC 
    ) as transaction_rank 
    FROM BankTransaction as t ;

-- =====================================================
/* Display each transaction together with the amount
   of the previous transaction for the same account.

   Show:
   transaction_id
   account_id
   transaction_date
   amount
   previous_transaction_amount

   Use LAG().

   Transactions must be ordered chronologically
   inside each account. */
-- =====================================================

   SELECT 
     t.transaction_id,
     t.account_id, 
     t.transaction_date, 
     t.amount,
    LAG(t.amount) OVER (
     PARTITION BY t.account_id
     ORDER BY t.transaction_date 
   ) AS previous_transaction_amount
   FROM BankTransaction as t 
   ORDER BY t.account_id, t.transaction_date ;

-- =====================================================
/* Display each transaction together with the amount
   of the next transaction for the same account.

   Show:
   transaction_id
   account_id
   transaction_date
   amount
   next_transaction_amount

   Use LEAD(). */
-- =====================================================
     
     SELECT
      t.transaction_id,
      t.account_id,
      t.transaction_date,
      t.amount,
      LEAD(t.amount) OVER
      (
        PARTITION BY t.account_id
        ORDER BY t.transaction_date
      ) AS next_transaction_amount
      FROM BankTransaction AS t
      ORDER BY t.account_id, t.transaction_date;

-- =====================================================
/* Compare each transaction with the previous transaction
   for the same account.

   Show:
   transaction_id
   account_id
   transaction_date
   amount
   previous_amount
   amount_difference

   amount_difference should be:

   current amount - previous amount

   Use LAG(). */
-- =====================================================

    SELECT 
      t.transaction_id, 
      t.account_id, 
      t.transaction_date, 
      t.amount, 
      LAG(t.amount) OVER (
        PARTITION BY t.account_id 
        ORDER BY t.transaction_date
    ) as previous_amount, 
      t.amount - LAG(t.amount) OVER (
        PARTITION BY t.account_id 
        ORDER BY t.transaction_date
    ) as amount_difference 
    FROM BankTransaction as t 
    ORDER BY t.account_id, t.transaction_date ;

-- =====================================================
/* Display transactions whose amount increased compared
   with the previous transaction for the same account.

   Show:
   transaction_id
   account_id
   transaction_date
   amount
   previous_amount

   HINT:
   First calculate LAG() inside a CTE.
   Then filter in the outer query.

   Return only:
   amount > previous_amount */
-- =====================================================

    WITH transaction_comparison as (  
       SELECT 
        t.transaction_id, 
        t.account_id, 
        t.transaction_date, 
        t.amount,
        LAG(t.amount) OVER (
          PARTITION BY t.account_id 
          ORDER BY t.transaction_date 
        )  as previous_amount
      FROM BankTransaction as t       
    )
       SELECT 
       transaction_id, 
       account_id, 
       transaction_date, 
       amount, 
       previous_amount 
       FROM transaction_comparison
       WHERE amount > previous_amount
    ORDER BY account_id, transaction_date ;
   
-- =====================================================
/* Calculate a running transaction total for each account.

   Show:
   transaction_id
   account_id
   transaction_date
   amount
   running_total

   The running total should increase transaction by
   transaction chronologically.

   Use:

   SUM(amount) OVER
   (
       PARTITION BY account_id
       ORDER BY transaction_date
   ) */
-- =====================================================
   
       SELECT 
        t.transaction_id, 
        t.account_id, 
        t.transaction_date, 
        t.amount, 
        SUM(t.amount) OVER (
            PARTITION BY t.account_id 
            ORDER BY t.transaction_date 
        ) as running_total 
        FROM BankTransaction as t ;

-- =====================================================
/* Calculate a running transaction count for each account.

   Show:
   transaction_id
   account_id
   transaction_date
   transaction_count_so_far

   Example:

   first transaction  -> 1
   second transaction -> 2
   third transaction  -> 3

   Use COUNT() OVER(). */
-- =====================================================

          SELECT 
            t.transaction_id, 
            t.account_id, 
            t.transaction_date, 
            COUNT(t.transaction_id) OVER (
            PARTITION BY t.account_id 
            ORDER BY t.transaction_date 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) as transaction_count_so_far
         FROM banktransaction as t 
         ORDER BY t.account_id, t.transaction_date ;

-- =====================================================
/* Display every transaction together with:

   transaction_id
   account_id
   amount
   average_account_transaction
   difference_from_account_average

   Calculate:

   amount - average transaction amount for that account

   Use AVG() OVER(PARTITION BY account_id). */
-- =====================================================

    SELECT 
      t.transaction_id,
      t.account_id,
      t.amount,
      AVG(t.amount) OVER (
        PARTITION BY t.account_id 
      ) as average_account_transaction ,
      t.amount -  AVG(t.amount) OVER (
        PARTITION BY t.account_id 
      ) AS difference_from_account_average
     FROM BankTransaction as t ;

-- =====================================================
/* Find transactions whose amount is greater than
   the average transaction amount for their own account.

   Show:
   transaction_id
   account_id
   amount
   average_account_transaction

   Use a window function inside a CTE.

   Then filter the result in the outer query. */
-- =====================================================

  WITH average_trans_amount as (
    SELECT 
     t.transaction_id, 
     t.account_id, 
     t.amount, 
     AVG(t.amount) OVER (
         PARTITION BY t.account_id
     ) as average_account_trans
     FROM BankTransaction as t 
  )

    SELECT 
     transaction_id, 
     account_id, 
     amount, 
     average_account_trans
     FROM average_trans_amount 
     WHERE amount > average_account_trans ;

-- =====================================================
/* Find the largest transaction for each account.

   Show:
   account_id
   transaction_id
   amount
   transaction_date

   Use ROW_NUMBER().

   Rank transactions inside each account by amount DESC.

   Return only row_number = 1. */
-- =====================================================
     
 WITH ranked_transaction as (
     SELECT 
      t.account_id, 
      t.transaction_id, 
      t.amount, 
      t.transaction_date, 
      ROW_NUMBER() OVER (
        PARTITION BY t.account_id 
        ORDER BY t.amount DESC 
      ) as row_num
      FROM BankTransaction as t 
 )
      SELECT 
        account_id, 
        transaction_id,
        amount, 
        transaction_date 
      FROM ranked_transaction
      WHERE row_num = 1 
      ORDER BY account_id ;

-- =====================================================
/* Find the three largest transactions for each account.

   Show:
   account_id
   transaction_id
   amount
   transaction_rank

   Use a CTE with ROW_NUMBER() or DENSE_RANK().

   Return only ranks <= 3. */
-- =====================================================

      WITH top3_transaction as (
        SELECT 
          t.account_id, 
          t.transaction_id, 
          t.amount, 
          ROW_NUMBER() OVER (
            PARTITION BY t.account_id 
            ORDER BY t.amount DESC 
         ) as transaction_rank 
         FROM BankTransaction as t 
      )
        SELECT
          account_id, 
          transaction_id, 
          amount, 
          transaction_rank 
        FROM top3_transaction 
        WHERE transaction_rank <=3 ;

-- =====================================================
/* Find the highest-balance account for each currency.

   Show:
   account_id
   currency
   balance

   Use ROW_NUMBER() or RANK().

   Partition by currency and order by balance DESC.

   Return only the top-ranked account or accounts. */
-- =====================================================

   WITH highest_balance_currency as (
      SELECT 
        a.account_id, 
        a.currency, 
        a.balance, 
        ROW_NUMBER() OVER (
        PARTITION BY a.currency 
        ORDER BY a.balance DESC 
       )as row_num 
      FROM account AS a  
 )
    SELECT 
      account_id, 
      currency, 
      balance 
    FROM highest_balance_currency 
    WHERE row_num = 1 ; 

-- =====================================================
/* Display every customer's account together with their
   total balance across all accounts.

   Show:
   customer_id
   first_name
   last_name
   account_id
   balance
   customer_total_balance

   Keep one row per account.

   Use:

   SUM(a.balance) OVER
   (
       PARTITION BY customer_id
   )

   You will need Customer and Account. */
-- =====================================================

      SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    a.account_id,
    a.balance,
    SUM(a.balance) OVER
    (
        PARTITION BY c.customer_id
    ) AS customer_total_balance
FROM Customer AS c
JOIN Account AS a
    ON c.customer_id = a.customer_id
ORDER BY
    c.customer_id,
    a.account_id;
       
-- =====================================================
/* Rank customers according to total account balance.

   Show:
   customer_id
   first_name
   last_name
   total_balance
   customer_rank

   First calculate total balance per customer in a CTE.

   Then use DENSE_RANK() over total_balance DESC. */
-- =====================================================

  WITH total_balance_percustomer as (
      SELECT 
        c.customer_id, 
        c.first_name, 
        c.last_name,
        SUM(a.balance) as total_balance 
        FROM customer as c 
        JOIN account as a 
           on a.customer_id = c.customer_id
        GROUP BY c.customer_id, c.first_name, c.last_name    
   )  

   SELECT 
     customer_id, 
     first_name, 
     last_name, 
     total_balance,
     DENSE_RANK() OVER (
        ORDER BY total_balance DESC 
     ) as customer_rank 
     FROM total_balance_percustomer  
     ORDER BY customer_rank ;

-- =====================================================
/* Rank customers according to total transaction volume.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume
   customer_rank

   First calculate transaction volume per customer
   using Customer, Account and BankTransaction.

   Then use DENSE_RANK(). */
-- =====================================================

  WITH total_trans_volume as (
      SELECT 
       c.customer_id, 
       c.first_name, 
       c.last_name, 
       SUM(t.amount) as transaction_volume_percustomer
       FROM BankTransaction as t 
       JOIN account as a 
         on t.account_id = a.account_id 
       JOIN customer as c 
         on c.customer_id = a.customer_id 
         GROUP BY c.customer_id, c.first_name, c.last_name  
  )
         SELECT 
           customer_id, 
           first_name, 
           last_name, 
           transaction_volume_percustomer, 
           DENSE_RANK() OVER (
             ORDER BY transaction_volume_percustomer DESC
           ) as customer_rank
        FROM total_trans_volume 
        ORDER BY customer_rank ;

-- =====================================================
/* Find the top 5 customers by total transaction volume.

   Show:
   customer_id
   first_name
   last_name
   total_transaction_volume
   customer_rank

   Use:

   CTE
   +
   DENSE_RANK() or ROW_NUMBER()

   Return only ranks <= 5. */
-- =====================================================

WITH top5_transaction as (
    SELECT 
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
),
ranked_customers AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        total_transaction_volume,
        DENSE_RANK() OVER (
            ORDER BY total_transaction_volume DESC
        ) AS customer_rank
    FROM top5_transaction
)
       
       SELECT 
        customer_id, 
        first_name,
        last_name, 
        total_transaction_volume, 
        customer_rank 
    FROM ranked_customers 
    WHERE customer_rank <= 5 
    ORDER BY customer_rank ;
 
-- =====================================================
/* Display each transaction together with:

   transaction_id
   account_id
   transaction_date
   amount
   previous_amount
   next_amount
   average_account_amount
   running_total

   Use multiple window functions in the same query:

   LAG()
   LEAD()
   AVG() OVER()
   SUM() OVER()

   Partition everything by account_id. */
-- =====================================================

SELECT
    t.transaction_id,
    t.account_id,
    t.transaction_date,
    t.amount,

    LAG(t.amount) OVER
    (
        PARTITION BY t.account_id
        ORDER BY t.transaction_date, t.transaction_id
    ) AS previous_amount,

    LEAD(t.amount) OVER
    (
        PARTITION BY t.account_id
        ORDER BY t.transaction_date, t.transaction_id
    ) AS next_amount,

    AVG(t.amount) OVER
    (
        PARTITION BY t.account_id
    ) AS average_account_amount,

    SUM(t.amount) OVER
    (
        PARTITION BY t.account_id
        ORDER BY t.transaction_date, t.transaction_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM BankTransaction AS t
ORDER BY
    t.account_id,
    t.transaction_date,
    t.transaction_id;