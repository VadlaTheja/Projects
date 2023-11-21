/*
 Group Project-15 BAUN 6320 - UTD
*/


/* DROP statements to clean up objects from previous run */
-- Triggers
set search_path=main_schema;

DROP TRIGGER IF EXISTS TRG_CustomerId on Customer;
DROP TRIGGER IF EXISTS TRG_AccountId on Account;
DROP TRIGGER IF EXISTS TRG_TransactionId on Transaction;
DROP TRIGGER IF EXISTS TRG_BranchId on Branch;
DROP TRIGGER IF EXISTS TRG_DepartmentId on Department;
DROP TRIGGER IF EXISTS TRG_EmployeeId on Employee;


-- Sequences
DROP SEQUENCE IF EXISTS SEQ_CustomerId;
DROP SEQUENCE IF EXISTS SEQ_AccountId;
DROP SEQUENCE IF EXISTS SEQ_TransactionId;
DROP SEQUENCE IF EXISTS SEQ_BranchId;
DROP SEQUENCE IF EXISTS SEQ_DepartmentId;
DROP SEQUENCE IF EXISTS SEQ_EmployeeId;


-- Views
DROP VIEW IF EXISTS  Credit_Transaction;
DROP VIEW IF EXISTS High_balance_account;
DROP VIEW IF EXISTS Customer_Premium;
DROP VIEW IF EXISTS AccountsInfo;


-- Indices
DROP INDEX IF EXISTS IDX_CustomerId;

DROP INDEX IF EXISTS IDX_AccountId;
DROP INDEX IF EXISTS IDX_Customer_CustId_FK;

DROP INDEX IF EXISTS IDX_TransactionId;
DROP INDEX IF EXISTS IDX_Account_AcctId_FK;

DROP INDEX IF EXISTS IDX_BranchId;

DROP INDEX IF EXISTS IDX_DepartmentId;
DROP INDEX IF EXISTS IDX_Branch_BranchId_FK;

DROP INDEX IF EXISTS IDX_EmployeeId;
DROP INDEX IF EXISTS IDX_Department_DeptId_FK;


-- Tables
DROP TABLE IF EXISTS Savings_Acc;
DROP TABLE IF EXISTS Checking_Acc;
DROP TABLE IF EXISTS Transaction;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Branch;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Customer;



/* Create tables based on entities */
-- CUSTOMER
CREATE TABLE Customer (
    Cust_Id        Integer PRIMARY KEY NOT NULL,
    Cust_FirstName Varchar(30)         NOT NULL,
    Cust_LastName  Varchar(30),
    Cust_Type      Varchar(12),
    Cust_DOB       DATE,
    Cust_Contact   NUMERIC(10,0),
    Cust_Email     Varchar(50),
    Cust_State     Varchar(30), 
    Cust_City      Varchar(30),
    Cust_Zipcode   NUMERIC(7,0)
);

-- ACCOUNT
CREATE TABLE Account(
	Acc_Id INTEGER PRIMARY KEY NOT NULL,
	Acc_Open_Bal FLOAT,
	Acc_Open_Date DATE,
	Acc_RoutingNumber VARCHAR (30),
	Acc_Status Varchar(20),
	Acc_Type Varchar(20),
	FK_Customer_PK_Cust_Id Integer, 
	Constraint FK_Customer 
	FOREIGN KEY (FK_Customer_PK_Cust_Id) 
	REFERENCES Customer(Cust_Id) ON DELETE CASCADE
);

-- SAVINGS ACCOUNT
CREATE TABLE Savings_Acc(
	Acc_Id Integer REFERENCES Account(Acc_Id) ON DELETE CASCADE PRIMARY KEY, 
	Savings_Acc_Bal FLOAT,
	Savings_Acc_Status VARCHAR(20)
);

-- CHECKING ACCOUNT
CREATE TABLE Checking_Acc(
	Acc_Id Integer REFERENCES Account(Acc_Id) ON DELETE CASCADE PRIMARY KEY, 
	CheckingAcc_Bal FLOAT,
	CheckingAcc_Status VARCHAR(20)
);

-- TRANSACTION
CREATE TABLE Transaction (
	Transaction_Id Integer Primary Key NOT NULL,
	Transaction_Mode  Varchar(20),
	Transaction_Status Varchar(20),
	Transaction_Type Varchar(20),
	Transaction_Description Varchar(50),
	Transaction_DateTime TIMESTAMP,
	Transaction_Amt Float,
	FK_Account_PK_Acc_Id Integer,
	Constraint FK_Account
	FOREIGN KEY (FK_Account_PK_Acc_Id)
	REFERENCES Account (Acc_Id)
);

-- BRANCH
CREATE Table Branch (
	Branch_Id Integer PRIMARY KEY ,
	Branch_Location Varchar(30),
	Branch_Manager_Name Varchar(50),
	Branch_Name varchar(30),
	Branch_Zip Varchar(7),
	FK_Account_PK_Acc_Id Integer,
	Constraint FK_Acccount 
	FOREIGN KEY (FK_Account_PK_Acc_Id) 
	References Account (Acc_Id)
);

-- DEPARTMENT
CREATE Table Department (
	Dept_Id Integer PRIMARY KEY,
	Dept_Head Varchar(80),
	Dept_name Varchar(50),
	Dept_Service Varchar(50),
	Dept_Contact Numeric(10,0),
	Dept_Email varchar(50),
	FK_Branch_PK_Branch_Id Integer,
	Constraint FK_Branch 
	FOREIGN KEY (FK_Branch_PK_Branch_Id) 
	References Branch (Branch_Id)
);

-- EMPLOYEE
CREATE TABLE Employee (
	Emp_Id Integer Primary Key,
	Emp_Designation Varchar(30),
	Emp_Email_id Varchar(50),
	Emp_Fname Varchar(30),
	Emp_Contact Numeric(10,0),
	Emp_Lname Varchar(30),
	FK_Department_Pk_Dept_Id Integer,
	Constraint FK_Dept 
	FOREIGN KEY (FK_Department_Pk_Dept_Id) 
	References Department (Dept_Id)
);


/* Create indices for natural keys, foreign keys, and frequently-queried columns */
-- Customer
-- Natural Keys
CREATE UNIQUE INDEX IDX_CustomerId ON Customer (cust_id);

-- Account
-- Natural Keys
CREATE UNIQUE INDEX IDX_AccountId ON Account (Acc_Id);
-- Foreign Keys
CREATE INDEX IDX_Customer_CustId_FK ON Account (FK_Customer_PK_Cust_Id);

-- Transaction
-- Natural keys
CREATE INDEX IDX_TransactionId  ON Transaction (Transaction_Id);
--  Foreign Keys
CREATE INDEX IDX_Account_AcctId_FK ON Transaction (FK_Account_PK_Acc_Id);

-- Branch
-- Natural Keys
CREATE INDEX IDX_BranchId ON Branch (Branch_Id);

-- Department
-- Natural Key
CREATE INDEX IDX_DepartmentId  ON Department (Dept_id);
-- Foreign Keys
CREATE INDEX IDX_Branch_BranchId_FK ON Department (FK_Branch_PK_Branch_Id);

-- Employee
-- Natural Key
CREATE INDEX IDX_EmployeeId ON Employee(Emp_Id);
-- Foreign Key
CREATE INDEX IDX_Department_DeptId_FK ON Employee (FK_Department_Pk_Dept_Id);


/* Alter Tables by adding Audit Columns */
ALTER TABLE Account ADD COLUMN Nominee VARCHAR(3);

ALTER TABLE Transaction ADD COLUMN Transaction_Receipt VARCHAR(3);
 
ALTER TABLE Branch ADD COLUMN Branch_Contact Numeric(10,0);

ALTER TABLE Department ADD COLUMN Department_floor Integer;


/* Create Views */
-- Business purpose: The AccountInfo view will be used primarily for rapidly fetching information about accounts for populating account data.
CREATE OR REPLACE VIEW AccountsInfo AS
SELECT Acc_Open_Bal, Acc_Open_Date, Acc_RoutingNumber, Acc_Status, Acc_Type, FK_Customer_PK_Cust_Id
FROM Account;

-- Business purpose: The High_balance_account view will be used primarily for rapidly fetching account data haing balance greater than 5000.
Create OR REPLACE VIEW High_balance_account as
SELECT Acc_Id, Acc_Open_Bal, FK_Customer_PK_Cust_Id, Acc_Status, Acc_Type
From Account
Where Acc_Open_Bal>5000;

-- Business purpose: The Credit_Transaction view will be used primarily for rapidly fetching credit type transactions done via zelle mode.
Create OR REPLACE VIEW Credit_Transaction AS
SELECT transaction_mode,transaction_status,transaction_type,transaction_description,transaction_datetime,transaction_amt
From Transaction
Where transaction_mode='Zelle' AND transaction_type = 'Credit'; 

-- Business purpose: The Customer_Premium view will be used primarily for rapidly fetching premium customer type.
Create OR REPLACE VIEW Customer_Premium AS
SELECT Cust_FirstName, Cust_LastName, Cust_Type, Cust_DOB
From Customer
Where Cust_Type='Premium';


/* Create Sequences */
CREATE SEQUENCE SEQ_CustomerId AS INTEGER
    INCREMENT BY 1
    MINVALUE 100
    MAXVALUE 2000
    START WITH 100;
 
CREATE SEQUENCE SEQ_AccountId AS INTEGER
START WITH 1000001
INCREMENT BY 10
MAXVALUE 100000000;
 
CREATE SEQUENCE SEQ_TransactionId AS INTEGER
	INCREMENT BY 1
    START WITH 1
    MINVALUE 1;
 
CREATE SEQUENCE SEQ_BranchId AS INTEGER
	INCREMENT BY 1
    START WITH 101
    MINVALUE 101;
	
CREATE SEQUENCE SEQ_DepartmentId AS INTEGER
	INCREMENT BY 1
    START WITH 1
    MINVALUE 1;	
	
CREATE SEQUENCE SEQ_EmployeeId AS INTEGER
	INCREMENT BY 1
	START WITH 1
	MINVALUE 1;	


/* Create Triggers */

-- Business purpose: The TRG_customerId trigger automatically assigns a sequential level ID to a newly-inserted row in the Customer table.
-- Create a trigger function to set customer id
CREATE OR REPLACE FUNCTION set_customer_id_function()
RETURNS TRIGGER AS $$
BEGIN
    NEW.cust_id = NEXTVAL('SEQ_CustomerId');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger for customer 
CREATE TRIGGER TRG_CustomerId
	BEFORE INSERT ON Customer
	FOR EACH ROW
	EXECUTE FUNCTION set_customer_id_function();

-- Business purpose: The TRG_AccountId trigger automatically assigns a sequential level ID to a newly-inserted row in the Account table.
-- Create a trigger function to set Account_Id
CREATE OR REPLACE FUNCTION account_id_function()
RETURNS TRIGGER AS $$
BEGIN 
	NEW.Acc_Id = NEXTVAL('SEQ_AccountId');
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Create trigger for Account 
CREATE TRIGGER TRG_AccountId
	BEFORE INSERT ON Account
	FOR EACH ROW
	EXECUTE FUNCTION account_id_function();

-- Business purpose: The TRG_TransactionId trigger automatically assigns a sequential level ID to a newly-inserted row in the Transaction table.
-- Create a trigger function to set Transaction_Id
CREATE OR REPLACE FUNCTION set_Transaction_id_function()
RETURNS TRIGGER AS $$
BEGIN
    NEW.Transaction_id = NEXTVAL('SEQ_TransactionId');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Create a trigger for Transaction
CREATE TRIGGER TRG_TransactionId
	BEFORE INSERT ON Transaction
	FOR EACH ROW
	EXECUTE FUNCTION set_Transaction_id_function();	

-- Business purpose: The TRG_BranchId trigger automatically assigns a sequential level ID to a newly-inserted row in the Branch table.
-- Create a trigger function to set Branch_Id
CREATE OR REPLACE FUNCTION set_Branch_id_function()
RETURNS TRIGGER AS $$
BEGIN
    NEW.Branch_id = NEXTVAL('SEQ_BranchId');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;	
 
--Create a trigger for Branch
CREATE TRIGGER TRG_BranchId
	BEFORE INSERT ON Branch
	FOR EACH ROW
	EXECUTE FUNCTION set_Branch_id_function();
	
-- Business purpose: The TRG_DepartmentId trigger automatically assigns a sequential level ID to a newly-inserted row in the Department table.
-- Create a trigger function to set Department id
CREATE OR REPLACE FUNCTION set_Dept_id_function()
RETURNS TRIGGER AS $$
BEGIN
    NEW.Dept_id = NEXTVAL('SEQ_DepartmentId');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Create a trigger for Department
CREATE TRIGGER TRG_DepartmentId
	BEFORE INSERT ON Department
	FOR EACH ROW
	EXECUTE FUNCTION set_Dept_id_function();

-- Business purpose: The TRG_EmployeeId trigger automatically assigns a sequential level ID to a newly-inserted row in the Employee table.
-- Create a trigger function to set Employee id
CREATE OR REPLACE FUNCTION set_Emp_id_function()
RETURNS TRIGGER AS $$
BEGIN
    NEW.Emp_id = NEXTVAL('SEQ_EmployeeId');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--Create a trigger for Employee
CREATE TRIGGER TRG_EmployeeId
	BEFORE INSERT ON Employee
	FOR EACH ROW
	EXECUTE FUNCTION set_Emp_id_function();


-- Check the DBMS data dictionary to make sure that all objects have been created successfully

SELECT table_name FROM information_schema.tables WHERE table_schema = 'main_schema';

	
	
















