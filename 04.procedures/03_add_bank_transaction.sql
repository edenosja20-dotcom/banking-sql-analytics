USE NovaBankDB;
GO

-- =====================================================
/* Create a stored procedure called:

   sp_AddBankTransaction

   Parameters:

       @AccountId INT
       @TransactionType VARCHAR(20)
       @Amount DECIMAL(18,2)
       @Description VARCHAR(255)

   The procedure should insert a new transaction
   into BankTransaction.

   Requirements:

   - Check that the account exists.
   - Amount must be greater than 0.
   - If the account does not exist, stop the procedure.
   - If amount <= 0, stop the procedure.
   - transaction_date should use the current date/time.
   - After inserting, return the newly created
     transaction.
*/
-- =====================================================

CREATE OR ALTER PROCEDURE sp_AddBankTransaction
    @AccountId int,
    @TransactionType VARCHAR(20),
    @Amount DECIMAL (18,2) ,
    @Description VARCHAR(255)
AS 
BEGIN    
   -- if account exists
    IF NOT EXISTS
    (
        SELECT 1
        FROM Account
        WHERE account_id = @AccountId
    )
    BEGIN
        PRINT 'Account does not exist.';
        RETURN;
    END;

    -- if amount is valid
    IF @Amount <= 0
    BEGIN
        PRINT 'Amount must be greater than 0.';
        RETURN;
    END;

    INSERT INTO BankTransaction
    (
        account_id,
        transaction_type,
        amount,
        transaction_date,
        description
    )
    VALUES
    (
        @AccountId,
        @TransactionType,
        @Amount,
        GETDATE(),
        @Description
    );

    DECLARE @NewTransactionId BIGINT;
    SET @NewTransactionId = SCOPE_IDENTITY();

   -- Return the newly created transaction
    SELECT
        transaction_id,
        account_id,
        transaction_type,
        amount,
        transaction_date,
        description
    FROM BankTransaction
    WHERE transaction_id = @NewTransactionId;

END;
GO


EXEC sp_AddBankTransaction
    @AccountId = 10,
    @TransactionType = 'Deposit',
    @Amount = 1500.00,
    @Description = 'Salary payment';