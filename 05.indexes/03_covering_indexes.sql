USE NovaBankDB;
GO

CREATE INDEX IX_BankTransaction_Account_Date_Covering
ON BankTransaction
(
    account_id,
    transaction_date
)
INCLUDE
(
    amount,
    transaction_type,
    description
);
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    transaction_id,
    account_id,
    transaction_type,
    amount,
    transaction_date,
    description
FROM BankTransaction
WHERE account_id = 25
  AND transaction_date >= '2026-01-01'
ORDER BY transaction_date DESC;