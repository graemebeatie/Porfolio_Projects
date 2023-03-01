--Creation Script for A3 
--Graeme Beatie
--2/1/22

USE Master

IF EXISTS (SELECT * FROM sysdatabases WHERE name='A3_Beatie')
DROP DATABASE A3_Beatie

GO

CREATE DATABASE A3_Beatie

ON PRIMARY 

(
NAME = 'A3_Beatie',
FILENAME ='C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\A3_Beatie.mdf',
SIZE = 12 MB, 
MAXSIZE = 50MB,
FILEGROWTH = 10%
)

LOG ON

(
NAME = 'A3_Beatie_Log',
FILENAME ='C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\A3_Beatie.ldf',
SIZE = 4 MB, --4MB for Real only -- 25% heavy writes updates
MAXSIZE = 50MB,
FILEGROWTH = 10%
)

GO

USE A3_Beatie

CREATE TABLE Student
(
StudentID				int			NOT NULL			IDENTITY(5000,1),
StudentEmail			varchar(60)					UNIQUE,
Dept_No					char(4), -- need to add check constraints for values
FName					varchar(25)	NOT NULL,
LName					varchar(25)	NOT NULL
)

CREATE TABLE Assignment
(
AssignmentID			int			NOT NULL			IDENTITY,
AssignmentName			varchar(60)	NULL,  -- need to add default name
AssignmentDescription	varchar(99) NULL,
DueDate					datetime	NOT NULL,
MaxPossibleGrade		smallint	NULL, -- need to add check constraint for 0 - 200
SubmissionType			varchar(30)	NULL, -- need to add check for correct values
)

CREATE TABLE StudentAssignment
(
StudentID				int			NOT NULL,
AssignmentID			int			NOT NULL,
Grade					smallint	NULL, -- need to add check constraint for 0 - 200
SubmissionDate			datetime	NULL
)
-- Made sure that script runs so far
-- Now do altering for primary keys

ALTER TABLE Student
	ADD CONSTRAINT PK_StudentID
	PRIMARY KEY (StudentID)

ALTER TABLE Assignment
	ADD CONSTRAINT PK_AssignmentID
	PRIMARY KEY (AssignmentID)

ALTER TABLE StudentAssignment
	ADD CONSTRAINT PK_StudentID_AssignmentID
	PRIMARY KEY (StudentID, AssignmentID)

-- made sure that script runs so far
-- now add foreign keys

ALTER TABLE StudentAssignment
	ADD 

	CONSTRAINT FK_StudentID
	FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_AssignmentID
	FOREIGN KEY (AssignmentID) REFERENCES Assignment(AssignmentID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

-- made sure that script runs so far
-- now add check constraints and defaults
GO

ALTER TABLE Student
	ADD CONSTRAINT UC_UniqueStudentEmail
	UNIQUE (StudentEmail)

-- Only adding constraint for values not limit because that was done during creation
ALTER TABLE Student
	ADD CONSTRAINT CK_CheckForCorrectDepartmentValue
	CHECK (Dept_No IN ('CS','EE','PH','LIT','ENG','MATH'))

ALTER TABLE Assignment
	ADD CONSTRAINT DK_DefaultAssignmentName
	DEFAULT 'CS 3550 Assignment' FOR AssignmentName

ALTER TABLE Assignment
	ADD CONSTRAINT CK_MaxValueBetweenZeroAndTwoHundred
	CHECK (MaxPossibleGrade>= 0 AND MaxPossibleGrade <= 200) 


ALTER TABLE StudentAssignment
	ADD CONSTRAINT CK_GradeValueBetweenZeroAndTwoHundred
	CHECK (Grade >= 0 AND Grade <= 200)

ALTER TABLE Assignment
	ADD CONSTRAINT CK_CheckForCorrectSubType
	CHECK (SubmissionType IN ('Text Entry', 'Media Recording', 'File Upload', 'Website URL'))


-- made sure that script runs so far
-- now try bulk inserts
GO

BULK INSERT Student FROM 'C:\Users\graem\OneDrive\Documents\Comp_Stats\Database_programming\A3_PhysicalScripting\A3_Student_table.csv' 
WITH (
	FORMAT = 'CSV',
	FIRSTROW=2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
	) 

SELECT * FROM Student