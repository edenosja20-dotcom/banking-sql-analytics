USE NovaBankDB;
GO

-- =====================================================
/* Create a stored procedure called:

   sp_GetCustomerTransactions

   Parameters:

       @CustomerId INT
       @StartDate DATE
       @EndDate DATE

   Return all transactions belonging to the customer
   between the specified dates.

   Show:
       transaction_id
       account_id
       transaction_type
       amount
       transaction_date
       description

   Requirements:
   - Order transactions from newest to oldest.
*/
-- =====================================================

CREATE OR ALTER PROCEDURE sp_GetCustomerTransactions
    @CustomerId INT,
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
   IF NOT EXISTS
    (
        SELECT 1
        FROM Customer
        WHERE customer_id = @CustomerId
    )
    BEGIN
        PRINT 'Customer does not exist.';
        RETURN;
    END;

      SELECT
        t.transaction_id, 
        t.account_id, 
        t.transaction_type, 
        t.amount, 
        t.transaction_date, 
        t.description 
      FROM Account as a   
      JOIN BankTransaction AS t 
          on a.account_id = t.account_id
      WHERE a.customer_id = @CustomerId
      AND t.transaction_date >= @StartDate
      AND t.transaction_date < DATEADD(DAY, 1 , @EndDate)
      ORDER BY t.transaction_date DESC ;
END;
GO

EXEC sp_GetCustomerTransactions
    @CustomerId = 10,
    @StartDate = '2026-01-01',
    @EndDate = '2026-08-21';