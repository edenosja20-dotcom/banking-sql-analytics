USE NovaBankDB;
GO

-- =====================================================
-- DATABASE VALIDATION
-- =====================================================

-- Number of customers
SELECT COUNT(*) AS total_customers
FROM Customer;


-- Number of accounts
SELECT COUNT(*) AS total_accounts
FROM Account;


-- Number of transactions
SELECT COUNT(*) AS total_transactions
FROM BankTransaction;


-- Number of loans
SELECT COUNT(*) AS total_loans
FROM Loan;


-- Number of cards
SELECT COUNT(*) AS total_cards
FROM Card;


-- Number of branches
SELECT COUNT(*) AS total_branches
FROM Branch;


-- =====================================================
-- CHECK VIEWS
-- =====================================================

SELECT TOP 10 *
FROM vw_CustomerFinancialProfile;

SELECT TOP 10 *
FROM vw_CustomerRiskProfile;


-- =====================================================
-- CHECK INDEXES
-- =====================================================

SELECT
    OBJECT_NAME(i.object_id) AS table_name,
    i.name AS index_name,
    i.type_desc
FROM sys.indexes AS i
WHERE i.name IS NOT NULL
ORDER BY table_name, index_name;


-- =====================================================
-- CHECK FOREIGN KEYS
-- =====================================================

SELECT
    name AS foreign_key_name,
    OBJECT_NAME(parent_object_id) AS table_name
FROM sys.foreign_keys
ORDER BY table_name;
GO