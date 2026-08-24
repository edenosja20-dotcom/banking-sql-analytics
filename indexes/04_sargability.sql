USE NovaBankDB;
GO 

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- =====================================================
-- NON-SARGABLE QUERY
-- =====================================================

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM BankTransaction
WHERE YEAR(transaction_date) = 2026;
GO

-- =====================================================
-- SARGABLE QUERY
-- =====================================================

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM BankTransaction
WHERE transaction_date >= '2026-01-01'
  AND transaction_date < '2027-01-01';
GO

CREATE INDEX IX_BankTransaction_TransactionDate
ON BankTransaction(transaction_date);
GO