--Creation Script for Cruise Line (Demo)
--Graeme Beatie
--1/30/22

USE Master

IF EXISTS (SELECT * FROM sysdatabases WHERE name='Beatie_Ship')
DROP DATABASE Beatie_Ship

GO

CREATE DATABASE Beatie_Ship

ON PRIMARY 

(
NAME = 'Beatie_Ship',
FILENAME ='C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Beatie_Ship.mdf',
-- FILENAME LOCAL
SIZE = 12 MB, 
MAXSIZE = 50MB,
FILEGROWTH = 10%
)

LOG ON

(
NAME = 'Beatie_Ship_Log',
FILENAME ='C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Beatie_Ship.ldf',
--FILENAME LOCAL
SIZE = 4 MB, --4MB for Real only -- 25% heavy writes updates
MAXSIZE = 50MB,
FILEGROWTH = 10%
)

GO

USE Beatie_Ship

CREATE TABLE Ship
(
ShipID			int			NOT NULL		IDENTITY, -- (1,1) IS ASSUMED
ShipName		varchar(50)	NOT NULL,
ShipYearBuilt	char(4)		NULL,
ShipWeight		int			NOT NULL,
ShipCapacity	smallint	NOT NULL
)

CREATE TABLE Employee
(
EmpID			int			NOT NULL	IDENTITY(5000,1),
EmpFirst		varchar(40)	NOT NULL,
EmpLast			varchar(40) NOT NULL,
EmpDOB			smalldatetime NOT NULL,
EmpNationality	varchar(10)	NOT NULL,
EmpSupervisorID	int			NULL
)

CREATE TABLE Employee_Ship_Roster
(
ShipID			int				NOT NULL,
EmpID			int				NOT NULL,
StartDate		smalldatetime	NOT NULL,
Position		varchar(25)		NOT NULL
)

-- Made sure that the script runs so far and creates tables
-- Do keys and constraints after making the tables so you can control the key names

ALTER TABLE Ship
	ADD CONSTRAINT PK_ShipID
	PRIMARY KEY (ShipID)

ALTER TABLE Employee
	ADD CONSTRAINT PK_EmployeeID
	PRIMARY KEY (EmpID)

ALTER TABLE Employee_Ship_Roster
	ADD CONSTRAINT PK_EmpID_ShipID
	PRIMARY KEY (EmpID, ShipID) -- can only have one primary key constraint. But on multiple columns

-- Ensure PKs have been created before moving onto FKs

ALTER TABLE Employee
	ADD CONSTRAINT FK_SupervisorMustBeAnEmployee
	FOREIGN KEY (EmpSupervisorID) REFERENCES Employee (EmpID)
	ON UPDATE NO ACTION -- because this is a unary table don't want to get caught in a loop 
	ON DELETE NO ACTION

ALTER TABLE Employee_Ship_Roster
	ADD

	CONSTRAINT FK_EmpID
	FOREIGN KEY (EmpID) REFERENCES Employee (EmpID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_ShipID
	FOREIGN KEY (ShipID) REFERENCES Ship (ShipID)
	ON UPDATE Cascade
	ON DELETE Cascade

-- ensure that the fks are set up , then move on to check and default constraints
GO

ALTER TABLE Employee
ADD CONSTRAINT CK_EmployeeMustBeFromNorthAmerica
CHECK (EmpNationality IN ('USA', 'Canada', 'Mexico'))

ALTER TABLE Employee
ADD CONSTRAINT DK_DefaultSupervisor
DEFAULT 5000 for EmpSupervisorID

GO

-- INSERT SAMPLE

INSERT INTO Ship
VALUES ('Good_S0ip','2002', 33000, 2020),
		('Titanic', '2003', 48040, 4900),
		('SS_Graeme', '2008', 4083, 10)

INSERT INTO Employee
VALUES ('Rich','Fry', '7/7/2000', 'USA', NULL),
		('Jason', 'Borne','4/14/2001', 'Canada', 5000), -- could change country to get an error
		('Bernard', 'Smith', '2/2/2003', 'Mexico', 5001)


INSERT INTO Employee_Ship_Roster
VALUES (5001, 2, '10/10/2017', 'Chief Engineer'),
		(5001, 1, '11/11/2019', 'Captain'),
		(5000, 2, '7/7/2001', 'Navigator')

GO -- PUT HERE SO THAT THE BATCH HAS COMPLETED AND YOU CAN THEN PULL DATA

PRINT 'Here are my ships'
PRINT ' '
SELECT * FROM Ship

