/*
 Group Project-15 BUAN 6320
*/
--set schema path
set search_path=main_schema;

/* Populate all tables */

-- CUSTOMER TABLE
INSERT INTO Customer ( Cust_FirstName, Cust_LastName, Cust_Type, Cust_DOB, Cust_Contact, Cust_Email, Cust_State, Cust_City, Cust_Zipcode)
VALUES
('John', 'Smith', 'Regular', '1990-01-01', 1234567890,  'john.smith@example.com', 'California', 'Los Angeles', 90001),
('Mike', 'Johnson', 'Regular', '1988-08-20', 5551112233, 'mike.johnson@example.com', 'Texas', 'Houston', 77002),
('Alice', 'Johnson', 'Premium', '1987-08-22', 7778889999, 'alice.johnson@example.com', 'Texas', 'Houston', 77002),
('Bob', 'Brown', 'Regular', '1990-10-02', 3334445555, 'bob.brown@example.com', 'Florida', 'Miami', 33101),
( 'Mary', 'Davis', 'Regular', '1998-04-12', 6667778888, 'mary.davis@example.com', 'Texas', 'Houston', 77002),
('David', 'Wilson', 'Regular', '1988-07-04', 9990001111, 'davis.wilson@example.com', 'Illinois', 'Chicago', 60601),
( 'Emily', 'Jones', 'Regular', '1992-04-10', 4445556666, 'emily.jones@example.com', 'Florida', 'Miami', 33101),
('Daniel', 'Miller', 'Premium', '1980-11-25', 7888889999, 'daniel.miller@example.com', 'Illinois', 'Chicago', 60601),
('Sophia', 'Brown', 'Regular', '1995-07-08', 1112223333, 'sophia.brown@example.com', 'Arizona', 'Phoenix', 85001),
('Matthew', 'Davis', 'Premium', '1982-02-18', 2223334444, 'matthew.davis@example.com', 'Georgia', 'Atlanta', 30301)	;

--populate customer data
select * from customer;

--ACCOUNT TABLE
INSERT INTO Account ( Acc_Open_Bal, Acc_Open_Date, Acc_RoutingNumber, Acc_Status, Acc_Type, FK_Customer_PK_Cust_Id)
VALUES
( 5000, '2021-01-15',555111444, 'Active', 'Savings', 100),
( 3000, '2023-01-15', 888777666, 'Closed', 'Checking', 101),
( 6000, '2021-01-15',444333222, 'Active', 'Savings', 102),
( 7000, '2023-01-15', 876543210, 'Closed', 'Checking', 103),
( 8000, '2021-01-15',555144400, 'Active', 'Savings', 104),
( 9000, '2023-01-15', 987632178, 'Closed', 'Checking', 105),
( 3500, '2021-01-15',555114476, 'Active', 'Savings', 106),
( 800, '2021-01-15',511144489, 'Closed', 'Checking', 107),
( 8030, '2021-01-15',7778956234, 'Closed', 'Checking', 108),
( 5800, '2022-10-05',555123895, 'Closed', 'Savings', 109);

--Populate account table data
select * from account;

-- TRANSACTION TABLE
Insert into Transaction (transaction_mode,transaction_status,transaction_type,transaction_description,transaction_datetime,transaction_amt,fk_account_pk_acc_id) Values 
('Zelle','Success','Credit','Payment to Vendor','2023-09-10 14:23:09',3000,1000001),
('Venmo','Success','Debit','Payment to Amazon','2023-02-08 02:19:09',2290,1000021),
('Zelle','Failed','Debit','Payment to Vendor','2023-04-03 14:26:54',10000,1000031),
('Paypal','Failed','Debit','Payment to Amazon','2023-11-05 01:59:39',6764,1000041),
('Paypal','Success','Credit','Payment to TomThumb','2023-04-30 04:34:09',2920,1000051),
('Zelle','Success','Credit','Flipkart Purchase','2023-09-21 08:40:09',8900,1000061),
('Zelle','Success','Credit','Walmart Shipment','2023-10-22 10:47:46',12000,1000071),
('Cheque','Failed','Debit','Payment to Vendor','2023-07-31 12:23:10',1400,1000081),
('Zelle','Success','Debit','Debit card charges','2023-07-31 11:45:34',7.82,1000091),
('Cheque','Success','Credit','Payment to Vendor','2023-08-15 19:35:46',9016,1000001);

--Populate transaction data
select * from transaction;

--BRANCH TABLE
Insert into Branch(Branch_name,Branch_Manager_Name,Branch_Zip,Branch_Location,FK_Account_PK_Acc_Id)
values 
('Harbor Trust Plaza','Alex Thompson',12345,'City Square',1000011),
('Crestview Banking Hub','Sarah Miller',56895,' Green Valley',1000021),
(' Harbor Heights Branch','David Rodriguez',75080,'Oceanfront Plaza',1000031),
('United Hub','Brian Davis',72014,'Center Square',1000041),
('Oceanfront Plaza Plaza','Emily Harris',20358,'Oceanfront Plaza',1000051),
('Pioneer Plaza Bankin','Jessica Smith',74205,'Mountain Viewe',1000061),
('evergreen Exchange Center,','Kevin Turner',74603,'Downtown Core',1000071),
('Metro Financial Square','Samantha White',56974,'Pine Grove',1000081),
('Oasis Community Plaza','Michael Johnson',25498,'Urban Heightse',1000091),
('Unity United Hub','Laura Wilson',36985,'Desert Oasis',1000001);

--Populate Branch data
select * from branch;

--DEPARTMENT TABLE
Insert into department (Dept_Head,Dept_name,Dept_Service,Dept_Contact,Dept_Email,FK_Branch_PK_Branch_Id)
values 
('Kimberly Anderson',' Human Resources','Employee Relations',5551235689,'hr@company.com',102),
('Brian Johnson',' IT Resources','Employee Relations',557890123,'it@company.com',103),
('Jessica Martinez',' marketing Resources','Employee Relations',555896523,'mrketing@company.com',104),
('Daniel Lee',' Finace','Employee Relations',555124589,'finance@company.com',105),
('Amanda White',' Customer Resources','Employee Relations',555789456,'cr@company.com',106),
('Christopher Taylor',' R&D','Employee Relations',555794613,'rnd@company.com',107),
('Megan Davis','  Client Acquisition','Employee Relations',555159753,'ca@company.com',108),
('Richard Brown',' Legal Affairs','Employee Relations',555369753,'la@company.com',109),
('Olivia Robinson',' Facilities Management','Employee Relations',555456381,'fm@company.com',110),
('Nathan Smith',' Quality Assurance','Employee Relations',555754123,'qa@company.com',101);

--Populate Department data
select * from department;

--EMPLOYEE TABLE
Insert into employee (Emp_Fname,Emp_Lname,Emp_Designation,Emp_Email_id,Emp_Contact,FK_Department_Pk_Dept_Id)
Values
('Jennifer','Smith','Senior Developer','jennifer.smith@email.com',787589623,1),
('Michael','Johnson','Marketing Specialis',' michael.johnson@email.com',787451256,2),
('Emily','Davis','HR Manager','emily.davis@email.com',787458920,3),
('Kevin','Turner','IT Support Analyst','kevin.turner@email.com',8956231475,4),
('Jessica','Martinez','Sales Executive',' jessica.martinez@email.com',8945123698,5),
('Brian','Anderson','Finance Analyst','brian.anderson@email.com',7856231245,6),
('Laura','White','Customer Service Representativ',' laura.white@email.com',8521479632,7),
('Daniel','Lee','Legal Counsel','daniel.lee@email.com',2356892310,8),
('Olivia','Robinson','Facilities Coordinator','olivia.robinson@email.com',7845138956,9),
('Christopher','Taylor','Research Scientist',' christopher.taylor@email.com',1597532684,10);

--Populate Employee data
select * from employee;
