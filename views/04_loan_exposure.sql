USE NovaBankDB;
GO

-- =====================================================
/* Create a view called vw_LoanExposure.

   Return one row per customer who has at least one loan.

   Show:
   customer_id
   first_name
   last_name
   number_of_loans
   total_loan_amount
   average_loan_amount
   largest_loan_amount
   average_interest_rate
*/
-- =====================================================

CREATE VIEW vw_LoanExposure as 
  
   SELECT 
      c.customer_id, 
      c.first_name,
      c.last_name, 
      COUNT(l.loan_id) as number_of_loans,
      SUM(l.loan_amount) as total_loan_amount, 
      AVG(l.loan_amount) as average_loan_amount,
      MAX(l.loan_amount) as largest_loan_amount,
      AVG(l.interest_rate) as average_interest_rate
    FROM customer as c 
    JOIN loan as l  
      on c.customer_id = l.customer_id 
    GROUP BY c.customer_id, c.first_name, c.last_name   ;
GO  

 SELECT * 
 FROM vw_LoanExposure;