USE NovaBankDB;
GO

INSERT INTO Branch (branch_name, city)
VALUES
('Tirana Main Branch', 'Tirana'),
('Blloku Branch', 'Tirana'),
('Shkoder Branch', 'Shkoder'),
('Durres Branch', 'Durres'),
('Vlore Branch', 'Vlore'),
('Korce Branch', 'Korce');

DECLARE @i INT = 1;

WHILE @i <= 120
BEGIN

    INSERT INTO Customer
    (
        first_name,
        last_name,
        date_of_birth,
        email,
        phone,
        city
    )
    VALUES
    (
        CONCAT('Customer', @i),

        CONCAT('Lastname', @i),

        DATEADD(
            DAY,
            -((@i * 137) % 12000),
            '2005-01-01'
        ),

        CONCAT(
            'customer',
            @i,
            '@novabank-demo.com'
        ),

        CONCAT(
            '069',
            RIGHT(
                '0000000' + CAST(@i AS VARCHAR(7)),
                7
            )
        ),

        CASE
            WHEN @i % 6 = 0 THEN 'Tirana'
            WHEN @i % 6 = 1 THEN 'Shkoder'
            WHEN @i % 6 = 2 THEN 'Durres'
            WHEN @i % 6 = 3 THEN 'Vlore'
            WHEN @i % 6 = 4 THEN 'Korce'
            ELSE 'Elbasan'
        END
    );

    SET @i = @i + 1;

END;



DECLARE @accountNumber INT = 1;

WHILE @accountNumber <= 180
BEGIN

    INSERT INTO Account
    (
        customer_id,
        branch_id,
        account_type,
        balance,
        currency,
        opened_date,
        status
    )
    VALUES
    (
        ((@accountNumber - 1) % 120) + 1,

        ((@accountNumber - 1) % 6) + 1,

        CASE
            WHEN @accountNumber % 3 = 0 THEN 'Savings'
            WHEN @accountNumber % 3 = 1 THEN 'Checking'
            ELSE 'Business'
        END,

        CAST(
            500 + ((@accountNumber * 347) % 50000)
            AS DECIMAL(18,2)
        ),

        CASE
            WHEN @accountNumber % 4 = 0 THEN 'ALL'
            WHEN @accountNumber % 4 = 1 THEN 'EUR'
            WHEN @accountNumber % 4 = 2 THEN 'USD'
            ELSE 'GBP'
        END,

        DATEADD(
            DAY,
            -((@accountNumber * 17) % 1800),
            CAST(GETDATE() AS DATE)
        ),

        CASE
            WHEN @accountNumber % 15 = 0
                THEN 'Inactive'
            ELSE 'Active'
        END
    );

    SET @accountNumber = @accountNumber + 1;

END;



DECLARE @transactionNumber INT = 1;

WHILE @transactionNumber <= 6000
BEGIN

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
        ((@transactionNumber - 1) % 180) + 1,

        CASE
            WHEN @transactionNumber % 5 = 0 THEN 'Transfer'
            WHEN @transactionNumber % 5 = 1 THEN 'Card Payment'
            WHEN @transactionNumber % 5 = 2 THEN 'Deposit'
            WHEN @transactionNumber % 5 = 3 THEN 'Withdrawal'
            ELSE 'Bank Transfer'
        END,

        CAST(
            10 +
            ABS(CHECKSUM(NEWID()) % 30000)
            AS DECIMAL(18,2)
        ),

        DATEADD(
            MINUTE,
            -ABS(CHECKSUM(NEWID()) % 1000000),
            GETDATE()
        ),

        CASE
            WHEN @transactionNumber % 5 = 0 THEN 'Online transfer'
            WHEN @transactionNumber % 5 = 1 THEN 'POS card purchase'
            WHEN @transactionNumber % 5 = 2 THEN 'Account deposit'
            WHEN @transactionNumber % 5 = 3 THEN 'ATM withdrawal'
            ELSE 'Interbank payment'
        END
    );

    SET @transactionNumber =
        @transactionNumber + 1;

END;

/* check if the data has been inserted correctly 
     SELECT COUNT(*) AS total_transactions
     FROM BankTransaction; 
*/


DECLARE @loanNumber INT = 1;

WHILE @loanNumber <= 40
BEGIN

    INSERT INTO Loan
    (
        customer_id,
        loan_type,
        loan_amount,
        interest_rate,
        start_date,
        end_date,
        status
    )
    VALUES
    (
        ((@loanNumber * 3 - 1) % 120) + 1,

        CASE
            WHEN @loanNumber % 4 = 0 THEN 'Mortgage'
            WHEN @loanNumber % 4 = 1 THEN 'Personal'
            WHEN @loanNumber % 4 = 2 THEN 'Auto'
            ELSE 'Business'
        END,

        CAST(
            5000 + ((@loanNumber * 7319) % 150000)
            AS DECIMAL(18,2)
        ),

        CAST(
            2.50 + ((@loanNumber % 8) * 0.50)
            AS DECIMAL(5,2)
        ),

        DATEADD(
            MONTH,
            -(@loanNumber % 36),
            CAST(GETDATE() AS DATE)
        ),

        DATEADD(
            YEAR,
            5 + (@loanNumber % 15),
            CAST(GETDATE() AS DATE)
        ),

        CASE
            WHEN @loanNumber % 10 = 0 THEN 'Closed'
            ELSE 'Active'
        END
    );

    SET @loanNumber = @loanNumber + 1;

END;


DECLARE @cardNumber INT = 1;

WHILE @cardNumber <= 140
BEGIN

    INSERT INTO Card
    (
        account_id,
        card_type,
        issued_date,
        expiry_date,
        status
    )
    VALUES
    (
        ((@cardNumber - 1) % 180) + 1,

        CASE
            WHEN @cardNumber % 3 = 0 THEN 'Credit'
            ELSE 'Debit'
        END,

        DATEADD(
            MONTH,
            -(@cardNumber % 36),
            CAST(GETDATE() AS DATE)
        ),

        DATEADD(
            YEAR,
            4,
            DATEADD(
                MONTH,
                -(@cardNumber % 36),
                CAST(GETDATE() AS DATE)
            )
        ),

        CASE
            WHEN @cardNumber % 20 = 0 THEN 'Blocked'
            ELSE 'Active'
        END
    );

    SET @cardNumber = @cardNumber + 1;

END;



SELECT 'Customers' AS table_name, COUNT(*) AS total
FROM Customer
UNION ALL
SELECT 'Branches', COUNT(*)
FROM Branch
UNION ALL
SELECT 'Accounts', COUNT(*)
FROM Account
UNION ALL
SELECT 'Transactions', COUNT(*)
FROM BankTransaction
UNION ALL
SELECT 'Loans', COUNT(*)
FROM Loan
UNION ALL
SELECT 'Cards', COUNT(*)
FROM Card;