USE NovaBankDB;
GO

CREATE INDEX IX_BankTransaction_Account_Date
ON BankTransaction
(
    account_id,
    transaction_date
);
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;


SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM BankTransaction
WHERE account_id = 25
  AND transaction_date >= '2026-01-01'
ORDER BY transaction_date DESC;