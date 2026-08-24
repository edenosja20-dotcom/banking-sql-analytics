USE NovaBankDB;
GO

-- =====================================================
-- ADD A COMPOSITE UNIQUE CONSTRAINT
-- =====================================================

/*
   Do not allow two branches with exactly the same
   branch_name and city.
*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.key_constraints
    WHERE name = 'UQ_Branch_Name_City'
)
BEGIN
    ALTER TABLE Branch
    ADD CONSTRAINT UQ_Branch_Name_City
    UNIQUE (branch_name, city);
END;
GO

-- =====================================================
-- DEFAULT CONSTRAINTS
-- =====================================================

/*
   Some tables already have DEFAULT values.

   Examples from our database:

   Customer.created_at      -> GETDATE()
   Account.balance          -> 0
   Account.opened_date      -> GETDATE()
   Account.status           -> Active
   BankTransaction.transaction_date -> GETDATE()
   Loan.status              -> Active

   Let's inspect the defaults that currently exist.
*/

SELECT
    OBJECT_NAME(dc.parent_object_id) AS table_name,
    c.name AS column_name,
    dc.name AS default_constraint,
    dc.definition AS default_value
FROM sys.default_constraints AS dc
JOIN sys.columns AS c
    ON dc.parent_object_id = c.object_id
   AND dc.parent_column_id = c.column_id
ORDER BY table_name, column_name;
GO

-- =====================================================
-- FOREIGN KEYS
-- =====================================================

/*
   Foreign Keys enforce relationships such as:

   Customer -> Account
   Branch   -> Account
   Account  -> BankTransaction
   Customer -> Loan
   Account  -> Card
*/

SELECT
    fk.name AS foreign_key_name,
    OBJECT_NAME(fk.parent_object_id) AS child_table,
    COL_NAME(
        fkc.parent_object_id,
        fkc.parent_column_id
    ) AS child_column,
    OBJECT_NAME(fk.referenced_object_id) AS parent_table,
    COL_NAME(
        fkc.referenced_object_id,
        fkc.referenced_column_id
    ) AS parent_column
FROM sys.foreign_keys AS fk
JOIN sys.foreign_key_columns AS fkc
    ON fk.object_id = fkc.constraint_object_id
ORDER BY child_table;
GO