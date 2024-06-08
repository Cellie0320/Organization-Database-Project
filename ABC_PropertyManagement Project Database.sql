
--Creating of database
CREATE DATABASE ABC_PropertyManagement
on
(NAME = ABC_PropertyManagementFile1,
FILENAME = 'C:\Data\ABC_PropertyManagementFile1.mdf'
)
LOG ON
(NAME = ABC_PropertyManagementLogFile2,
FILENAME = 'C:\Data\ABC_PropertyManagementLogFile2.ldf')


GO
--creating tables
CREATE TABLE Property (
   PropertyID INT PRIMARY KEY,
   Address VARCHAR(255) NOT NULL,
   City VARCHAR(255) NOT NULL,
   State VARCHAR(255) NOT NULL,
   ZipCode VARCHAR(255) NOT NULL
);

CREATE TABLE Owner (
   OwnerID INT PRIMARY KEY,
   FirstName VARCHAR(255) NOT NULL,
   LastName VARCHAR(255) NOT NULL,
   Email VARCHAR(255) NOT NULL
);

CREATE TABLE Tenant (
   TenantID INT PRIMARY KEY,
   FirstName VARCHAR(255) NOT NULL,
   LastName VARCHAR(255) NOT NULL,
   Email VARCHAR(255) NOT NULL
);

CREATE TABLE Lease (
   LeaseID INT PRIMARY KEY,
   PropertyID INT FOREIGN KEY REFERENCES Property(PropertyID),
   TenantID INT FOREIGN KEY REFERENCES Tenant(TenantID),
   StartDate DATE NOT NULL,
   EndDate DATE NOT NULL
);

CREATE TABLE Payment (
   PaymentID INT PRIMARY KEY,
   LeaseID INT FOREIGN KEY REFERENCES Lease(LeaseID),
   Amount DECIMAL(10,2) NOT NULL,
   PaymentDate DATE NOT NULL
);



CREATE TABLE Maintenance (
   MaintenanceID INT PRIMARY KEY,
   Description TEXT NOT NULL,
   CompletionDate DATE NOT NULL
);

CREATE TABLE Employee (
   EmployeeID INT PRIMARY KEY,
   FirstName VARCHAR(255) NOT NULL,
   LastName VARCHAR(255) NOT NULL,
   Email VARCHAR(255) NOT NULL
);

CREATE TABLE WorkOrder (
    WorkOrderID INT PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employee(EmployeeID),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL
);
--insert data into the tables
INSERT INTO Property (PropertyID, Address, City, State, ZipCode)
VALUES (1, '123 Main St', 'Anytown', 'CA', '12345'),
(2, '456 Elm St', 'Othertown', 'NY', '67890'),
(3, '789 Oak St', 'Thirdtown', 'TX', '54321'),
(4, '321 Maple St', 'Fourthtown', 'FL', '98765'),
(5, '555 Pine St', 'Fifthtown', 'IL', '23456');

INSERT INTO Owner (OwnerID, FirstName, LastName, Email)
VALUES (1, 'John', 'Doe', 'johndoe@email.com'),
(2, 'Jane', 'Smith', 'janesmith@email.com'),
(3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
(4, 'Samantha', 'Lee', 'samanthalee@email.com'),
(5, 'Mike', 'Brown', 'mikebrown@email.com');

INSERT INTO Tenant (TenantID, FirstName, LastName, Email)
VALUES (1, 'Amy', 'Jones', 'amyjones@email.com'),
(2, 'Tom', 'Smith', 'tomsmith@email.com'),
(3, 'Lisa', 'Kim', 'lisakim@email.com'),
(4, 'David', 'Lee', 'davidlee@email.com'),
(5, 'Sarah', 'Wang', 'sarahwang@email.com');

INSERT INTO Lease (LeaseID, PropertyID, TenantID, StartDate, EndDate)
VALUES (1, 1, 1, '2022-01-01', '2022-12-31'),
(2, 2, 2, '2023-03-01', '2024-02-28'),
(3, 3, 3, '2022-06-01', '2023-05-31'),
(4, 4, 4, '2022-02-15', '2023-02-14'),
(5, 5, 5, '2022-09-01', '2023-08-31');

INSERT INTO Payment (PaymentID, LeaseID, Amount, PaymentDate)
VALUES (1, 1, 1000.00, '2022-01-01'),
(2, 2, 1500.00, '2023-03-05'),
(3, 3, 1200.00, '2022-06-01'),
(4, 4, 800.00, '2022-02-28'),
(5, 5, 2000.00, '2022-09-01');

INSERT INTO Maintenance (MaintenanceID, Description, CompletionDate)
VALUES (1, 'Fix leaky faucet', '2022-01-05'),
(2, 'Replace broken window', '2022-02-15'),
(3, 'Unclog drain', '2022-03-10'),
(4, 'Replace light fixture', '2022-04-20'),
(5, 'Repair roof', '2022-05-25');

INSERT INTO Employee (EmployeeID, FirstName, LastName, Email)
VALUES (1, 'Mark', 'Johnson', 'markjohnson@email.com'),
       (2, 'Sara', 'Lee', 'saralee@email.com'),
       (3, 'Mike', 'Smith', 'mikesmith@email.com'),
       (4, 'Jessica', 'Chen', 'jessicachen@email.com'),
       (5, 'David', 'Kim', 'davidkim@email.com');

INSERT INTO WorkOrder (WorkOrderID, EmployeeID, StartDate, EndDate)
VALUES (1, 1, '2022-01-05', '2022-01-10'),
       (2, 2, '2022-02-15', '2022-02-20'),
       (3, 3, '2022-03-10', '2022-03-15'),
       (4, 4, '2022-04-20', '2022-04-25'),
       (5, 5, '2022-05-25', '2022-05-30');

	   --do querries, create triggers, 
	   --sub query: This query returns all properties that are leased by tenants with the first name ‘David’.
	   SELECT *
FROM Property
WHERE PropertyID IN (
   SELECT PropertyID
   FROM Lease
   WHERE TenantID IN (
      SELECT TenantID
      FROM Tenant
      WHERE FirstName = 'David'
   )
);

--CTE:This query creates a CTE named PropertyCTE that selects all properties in California state. 
--The second part of the query selects all properties in Anytown from the CTE

WITH PropertyCTE AS (
   SELECT *
   FROM Property
   WHERE State = 'CA'
)
SELECT *
FROM PropertyCTE
WHERE City = 'Anytown';


--Join:This query will return the PropertyID and Address columns from the Property table and the FirstName and LastName columns from the Tenant table for all rows where there is a match in all three tables. 
--This can be useful if you want to see which tenants are associated with which properties.
SELECT Property.PropertyID, Property.Address, Tenant.FirstName, Tenant.LastName
FROM Property
INNER JOIN Lease ON Property.PropertyID = Lease.PropertyID
INNER JOIN Tenant ON Lease.TenantID = Tenant.TenantID;
--view:
--This query creates a view called WorkOrderView that contains the columns WorkOrderID, FirstName, LastName, StartDate, and EndDate. 
--It then selects these columns from the WorkOrder and Employee tables
go
CREATE VIEW WorkOrderView AS (
  SELECT WorkOrder.WorkOrderID, Employee.FirstName, Employee.LastName, WorkOrder.StartDate, WorkOrder.EndDate
  FROM WorkOrder
  INNER JOIN Employee ON WorkOrder.EmployeeID = Employee.EmployeeID
);
go
--cursor query:This example declares a cursor named PropertyCursor that retrieves data from the Property table. 
--The cursor retrieves all columns from the table and stores them in variables that are declared at the beginning of the script. 
--The OPEN statement opens the cursor and retrieves the first row of data. The WHILE loop iterates through each row of data returned by the cursor and prints out each column value. 
--Finally, the CLOSE statement closes the cursor and deallocates it.
DECLARE @PropertyID INT;
DECLARE @Address VARCHAR(255);
DECLARE @City VARCHAR(255);
DECLARE @State VARCHAR(255);
DECLARE @ZipCode VARCHAR(255);

DECLARE PropertyCursor CURSOR FOR
SELECT PropertyID, Address, City, State, ZipCode
FROM Property;

OPEN PropertyCursor;

FETCH NEXT FROM PropertyCursor INTO @PropertyID, @Address, @City, @State, @ZipCode;

WHILE @@FETCH_STATUS = 0
BEGIN
   PRINT 'PropertyID: ' + CAST(@PropertyID AS VARCHAR(255)) + ', Address: ' + @Address + ', City: ' + @City + ', State: ' + @State + ', ZipCode: ' + @ZipCode;
   FETCH NEXT FROM PropertyCursor INTO @PropertyID, @Address, @City, @State, @ZipCode;
END;

CLOSE PropertyCursor;
DEALLOCATE PropertyCursor;

--Stored Procedure:This stored procedure returns lease details for a specific property ID. 
--It joins the Lease, Property and Tenant tables to return the lease details along with tenant information. 
--You can modify this stored procedure to suit your needs by changing the columns returned or adding additional filters.
go
CREATE PROCEDURE sp_GetLeaseDetails
@PropertyID INT
AS
BEGIN
SELECT l.LeaseID, p.Address, p.City, p.State, p.ZipCode, t.FirstName + ' ' + t.LastName AS TenantName,
t.Email AS TenantEmail, l.StartDate, l.EndDate
FROM Lease l
INNER JOIN Property p ON l.PropertyID = p.PropertyID
INNER JOIN Tenant t ON l.TenantID = t.TenantID
WHERE l.PropertyID = @PropertyID
END
--Trigger: trigger that fires when you try to insert a new row into the Lease table:
go
CREATE TRIGGER tr_Lease_Insert
ON Lease
FOR INSERT
AS
BEGIN
Print'New row is inserted into the lease table'
END
--testing the trigger

INSERT INTO Lease (LeaseID, PropertyID, TenantID, StartDate, EndDate)
VALUES (6, 6, 6, '2022-02-04', '2023-01-31')

--create a user defined functions
--This function returns a single value of the total amount of payments made.
go
CREATE FUNCTION dbo.GetTotalPayments()
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @TotalPayments DECIMAL(10,2)
    SELECT @TotalPayments = SUM(Amount)
    FROM Payment
    RETURN @TotalPayments
END;
go
-- This will create a new view called PaymentCaseStatementView that includes the PaymentID, Amount, PaymentDate,
--and a new column called PaymentAmountCategory that categorizes the payment amount 
--as either ‘High’, ‘Medium’, or ‘Low’ based on the payment amount value.
CREATE VIEW PaymentCaseStatementView AS
SELECT 
   PaymentID,
   Amount,
   PaymentDate,
   CASE 
      WHEN Amount > 1000 THEN 'High'
      WHEN Amount > 500 THEN 'Medium'
      ELSE 'Low'
   END AS PaymentAmountCategory
FROM Payment;
go

--LOGIN 1 FOR MANAGER
CREATE LOGIN Login01
WITH PASSWORD='Password01'
go

USE ABC_PropertyManagement 
CREATE USER User_1
FOR LOGIN Login01

GO
--GRANT ACCESS TO USER_1
GRANT CONTROL
TO User_1

CREATE LOGIN Login02
WITH PASSWORD='Password02'

GO
--Login 2
USE ABC_PropertyManagement 
CREATE USER User_2
FOR LOGIN Login02

--Secretary is only allowed to insert,update,select something from the lease table and by that does not have access to the employee table
GRANT SELECT,UPDATE, INSERT
ON Lease
TO User_2
GO
--creates the backup
 BACKUP DATABASE ABC_PropertyManagement
  TO DISK = 'C:\Data\ABC_PropertyManagement.bak'
GO 
