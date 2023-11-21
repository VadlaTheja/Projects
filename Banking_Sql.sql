/*
 Group Project-15 BUAN 6320
*/

--set schema path
set search_path=main_schema;

--Query 1 Select all columns and all rows from one table

Select * from Customer;

--Query 2 Select five columns and all rows from one table
Select Branch_name,Branch_Manager_Name,Branch_Zip,Branch_Location,FK_Account_PK_Acc_Id
From branch;

--Query 3 Select all columns from all rows from one view
Select * from High_balance_account;

--Query 4 Using a join on 2 tables, select all columns and all rows
Select * from Account full outer join Transaction on Account.acc_id = Transaction.fk_account_pk_acc_id;

--Query 5 Select and order data retrieved from one table
Select * from Transaction order by transaction_amt DESC;

--Query 6 Using a join on 3 tables, select 5 columns from the 3 tables.  Use syntax that would limit the output to 10 rows
Select A.acc_id,a.acc_status,t.transaction_amt,c.cust_id,c.cust_email
from Account A
join Transaction T 
on A.acc_id = T.fk_account_pk_acc_id 
join Customer C
On C.Cust_id=A.FK_Customer_PK_Cust_Id
limit 10;

---Query 7	Select distinct rows using joins on 3 tables
SELECT  DISTINCT(AC.Acc_Id) AS Distinct_Account,CU.Cust_Id, T.transaction_id, T.transaction_amt, CU.cust_firstname,CU.cust_lastname  
FROM Customer AS CU
JOIN ACCOUNT AS AC 
	ON CU.Cust_Id = AC.FK_Customer_PK_Cust_Id
JOIN transaction AS T
	ON AC.Acc_Id = T.fk_account_pk_acc_id;
	
--Query 8 Use GROUP BY and HAVING in a select statement using one or more tables
SELECT  T.transaction_mode, SUM(T.transaction_amt) AS Summation_of_mode
FROM Account AS AC
INNER JOIN transaction AS T
ON AC.acc_id = T.fk_account_pk_acc_id
GROUP BY T.transaction_mode
HAVING SUM(T.transaction_amt) > 1000
ORDER BY Summation_of_mode;

--Query 9 Use IN clause to select data from one or more tables
SELECT * FROM Employee 
WHERE fk_department_pk_dept_id IN (
		SELECT dept_id FROM department
		WHERE dept_name like '%Resources%');

--Query 10 Select length of one column from one table (use LENGTH function)
Select length(Emp_Fname) from Employee;

--Query 11 Delete one record from one table.  Use select statements to demonstrate the table contents before and after the DELETE statement. 
--Make sure you use ROLLBACK afterwards so that the data will not be physically removed
BEGIN;
Select * from Transaction;
Delete from Transaction where transaction_amt>10000;
Select * from Transaction;
Rollback;
END;


--Query 12 Update one record from one table.  Use select statements to demonstrate the table contents before and after the UPDATE statement. 
--Make sure you use ROLLBACK afterwards so that the data will not be physically removed
BEGIN;
Select * from Employee;
Update Employee
Set emp_designation='Sales Manager'
Where emp_fname='Jessica' and emp_lname='Martinez';
Select * from Employee;
Rollback;
End;

--Advance Query1 to select account and associated customer and categorize each account based on its opening balance.
--If account balance greater than 5000 then labeled as Business account else Student account
SELECT  AC.acc_id,CU.cust_firstname,CU.cust_lastname,
AC.acc_open_bal,
CASE WHEN AC.acc_open_bal <=5000 THEN 'Student_Acc'
	 WHEN AC.acc_open_bal > 5000 THEN 'Business_Acc' 
END AS
Business_Type
FROM Account AS AC
INNER JOIN Customer AS CU
ON AC.fk_customer_pk_cust_id = CU.cust_id
ORDER BY AC.acc_open_bal ;

--Advance Query2 Identify the branch with the highest total transaction amount
SELECT
    Branch.Branch_ID,
    Branch.Branch_Name,
    COALESCE(SUM(Transaction.Transaction_Amt), 0) AS TotalTransactionAmount
FROM
    Branch
INNER JOIN
    Account ON Account.Acc_Id = Branch.FK_Account_PK_Acc_Id
LEFT JOIN
    Transaction ON Account.Acc_Id = Transaction.FK_Account_PK_Acc_Id	
GROUP BY
    Branch.Branch_ID, Branch.Branch_Name	
ORDER BY
    TotalTransactionAmount DESC 
LIMIT 1;

