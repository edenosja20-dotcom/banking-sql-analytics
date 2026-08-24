USE NovaBankDB;
GO

-- =====================================================
/* Create useful indexes for common banking queries.

   Create an index on:

   BankTransaction(account_id)

   because transactions are frequently searched
   and joined by account_id.

   Create an index on:

   Account(customer_id)

   because accounts are frequently searched
   and joined by customer_id.

   Create an index on:

   Loan(customer_id)

   because loans are frequently searched
   and joined by customer_id.
*/
-- =====================================================

CREATE INDEX IX_BankTransaction_AccountId
ON BankTransaction(account_id);
GO

CREATE INDEX IX_Account_CustomerId
ON Account(customer_id);
GO

CREATE INDEX IX_Loan_CustomerId
ON Loan(customer_id);
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM BankTransaction
WHERE account_id = 25;

SELECT
    i.name AS index_name,
    i.type_desc AS index_type,
    i.is_primary_key
FROM sys.indexes AS i
WHERE i.object_id = OBJECT_ID('BankTransaction');