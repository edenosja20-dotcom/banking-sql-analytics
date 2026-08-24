USE NovaBankDB;
GO 

-- =====================================================
/* Create a stored procedure called:

   sp_UpdateAccountStatus

   Parameters:
       @AccountId INT
       @NewStatus VARCHAR(20)

   - Check that the account exists.
   - Only allow these statuses:

         Active
         Inactive
         Closed

   - If the account does not exist, stop the procedure.
   - If the status is invalid, stop the procedure.
   - Update the Account table.
   - Return the updated account after the UPDATE.
*/
-- =====================================================

CREATE OR ALTER PROCEDURE sp_UpdateAccountStatus
    @AccountId INT,
    @NewStatus VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

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

     -- Validate status
    IF @NewStatus NOT IN ('Active', 'Inactive', 'Closed')
    BEGIN
        PRINT 'Invalid account status.';
        RETURN;
    END;

    -- UPDATE Account
    UPDATE Account
    SET status = @NewStatus
    WHERE account_id = @AccountId;

    SELECT
        account_id,
        customer_id,
        branch_id,
        account_type,
        balance,
        currency,
        opened_date,
        status
    FROM Account
    WHERE account_id = @AccountId;
END;
GO

EXEC sp_UpdateAccountStatus
    @AccountId = 10,
    @NewStatus = 'Inactive';