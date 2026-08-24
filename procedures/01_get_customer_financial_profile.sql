USE NovaBankDB;
GO

-- =====================================================
/* Create a stored procedure called:

   sp_GetCustomerFinancialProfile

   The procedure should receive:

       @CustomerId INT

   Return the financial profile only for the
   requested customer.

   Show:
   customer_id
   first_name
   last_name
   total_account_balance
   total_transaction_volume
   total_loan_amount

   You may reuse:
       vw_CustomerFinancialProfile

   Example execution:

       EXEC sp_GetCustomerFinancialProfile
            @CustomerId = 10;

*/
-- =====================================================

ALTER PROCEDURE sp_GetCustomerFinancialProfile
    @CustomerId INT
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
        customer_id,
        first_name,
        last_name,
        total_account_balance,
        total_transaction_volume,
        total_loan_amount
    FROM vw_CustomerFinancialProfile
    WHERE customer_id = @CustomerId;

END;
GO

EXEC sp_GetCustomerFinancialProfile
    @CustomerId = 999;