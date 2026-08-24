USE NovaBankDB;
GO

-- =====================================================
/* Add data integrity constraints.

   Account:
   - balance cannot be negative
   - status can only be:
       Active
       Inactive
       Closed
   - currency can only be:
       EUR
       USD
       ALL

   BankTransaction:
   - amount must be greater than 0

   Loan:
   - loan_amount must be greater than 0
   - interest_rate cannot be negative
   - end_date must be after start_date
*/
-- =====================================================

-- Balance cannot be negative
ALTER TABLE Account
ADD CONSTRAINT CK_Account_Balance
CHECK (balance >= 0);
GO

-- Status must have one of the allowed values
ALTER TABLE Account
ADD CONSTRAINT CK_Account_Status
CHECK (status IN ('Active', 'Inactive', 'Closed'));
GO

-- Currency must have one of the allowed values
ALTER TABLE Account
ADD CONSTRAINT CK_Account_Currency
CHECK (currency IN ('EUR', 'USD', 'ALL', 'GBP'));
GO



-- Transaction amount must be greater than 0
ALTER TABLE BankTransaction
ADD CONSTRAINT CK_BankTransaction_Amount
CHECK (amount > 0);
GO



-- Loan amount must be greater than 0
ALTER TABLE Loan
ADD CONSTRAINT CK_Loan_Amount
CHECK (loan_amount > 0);
GO


-- Interest rate cannot be negative
ALTER TABLE Loan
ADD CONSTRAINT CK_Loan_InterestRate
CHECK (interest_rate >= 0);
GO


-- Loan end date must be after start date
ALTER TABLE Loan
ADD CONSTRAINT CK_Loan_Dates
CHECK (end_date > start_date);
GO