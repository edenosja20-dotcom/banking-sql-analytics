USE NovaBankDB;
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO


-- =====================================================
-- Query 1
-- Search transactions by account_id
-- =====================================================

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM BankTransaction
WHERE account_id = 25;
GO


-- =====================================================
-- Query 2
-- Search using account_id + transaction_date
-- =====================================================

SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date
FROM BankTransaction
WHERE account_id = 25
  AND transaction_date >= '2026-01-01'
  AND transaction_date < '2027-01-01';
GO


-- =====================================================
-- Query 3
-- Non-SARGable example
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
-- Query 4
-- SARGable version
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