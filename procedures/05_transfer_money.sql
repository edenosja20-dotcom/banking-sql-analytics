USE NovaBankDB;
GO

-- =====================================================
/* Create a stored procedure called:

   sp_TransferMoney

   Parameters:

       @FromAccountId INT
       @ToAccountId INT
       @Amount DECIMAL(18,2)

-   Both UPDATE operations must succeed together.

   If anything fails:
       ROLLBACK

   If everything succeeds:
       COMMIT
*/
-- =====================================================

CREATE OR ALTER PROCEDURE sp_TransferMoney
    @FromAccountId INT,
    @ToAccountId INT,
    @Amount DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Amount <= 0
    BEGIN
        PRINT 'Amount must be greater than 0.';
        RETURN;
    END;

    IF @FromAccountId = @ToAccountId
    BEGIN
        PRINT 'Source and destination accounts cannot be the same.';
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM Account
        WHERE account_id = @FromAccountId
    )
    BEGIN
        PRINT 'Source account does not exist.';
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM Account
        WHERE account_id = @ToAccountId
    )
    BEGIN
        PRINT 'Destination account does not exist.';
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM Account
        WHERE account_id = @FromAccountId
          AND status = 'Active'
    )
    BEGIN
        PRINT 'Source account is not active.';
        RETURN;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM Account
        WHERE account_id = @ToAccountId
          AND status = 'Active'
    )
    BEGIN
        PRINT 'Destination account is not active.';
        RETURN;
    END;

    IF
    (
        SELECT balance
        FROM Account
        WHERE account_id = @FromAccountId
    ) < @Amount
    BEGIN
        PRINT 'Insufficient balance.';
        RETURN;
    END;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Remove money from source account
        UPDATE Account
        SET balance = balance - @Amount
        WHERE account_id = @FromAccountId;

        -- Add money to destination account
        UPDATE Account
        SET balance = balance + @Amount
        WHERE account_id = @ToAccountId;

        COMMIT TRANSACTION;

        -- Return both updated accounts
        SELECT
            account_id,
            customer_id,
            account_type,
            balance,
            currency,
            status
        FROM Account
        WHERE account_id IN (@FromAccountId, @ToAccountId);

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;

        THROW;

    END CATCH;

END;
GO

EXEC sp_TransferMoney
    @FromAccountId = 2,
    @ToAccountId = 20,
    @Amount = 100.00;