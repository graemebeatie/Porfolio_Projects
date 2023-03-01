--Creation Script for A4 
--Graeme Beatie
--2/14/22

USE Master

IF EXISTS (SELECT * FROM sysdatabases WHERE name='Beatie_FARMS')
DROP DATABASE Beatie_FARMS

GO

CREATE DATABASE Beatie_FARMS

ON PRIMARY 

(
NAME = 'Beatie_FARMS',
FILENAME ='C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Beatie_FARMS.mdf',
SIZE = 4 MB, 
MAXSIZE = 4 MB,
FILEGROWTH = 500 KB
)

LOG ON

(
NAME = 'Beatie_FARMS_LOG',
FILENAME ='C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Beatie_FARMS.ldf',
SIZE = 4 MB, --4MB for Real only -- 25% heavy writes updates
MAXSIZE = 4MB,
FILEGROWTH = 500 KB
)

GO

USE Beatie_FARMS

CREATE TABLE Reservation
(
ReservationID			smallint		NOT NULL		IDENTITY(5000,1),
ReservationDate			date			NOT NULL,
ReservationStatus		char(1)			NOT NULL,		-- add check
ReservationComments		varchar(200)	NULL,
CreditCardID			smallint		NOT NULL
)

CREATE TABLE Guest
(
GuestID					smallint		NOT NULL		IDENTITY(1500,1),
GuestFirst				varchar(20)		NOT NULL,
GuestLast				varchar(20)		NOT NULL,
GuestAddress1			varchar(30)		NOT NULL,			
GuestAddress2			varchar(10)		NULL,
GuestCity				varchar(20)		NOT NULL,
GuesetState				char(2)			NULL,
GuestPostalCode			char(10)		NOT NULL,
GuestCountry			varchar(20)		NOT NULL,
GuestPhone				varchar(20)		NOT NULL,
GuestEmail				varchar(30)		NULL,
GuesetComments			varchar(200)	NULL
)

CREATE TABLE RoomType
(
RoomTypeID				smallint		NOT NULL		IDENTITY,
RTDescription			varchar(200)	NOT NULL
)

CREATE TABLE CreditCard
(
CreditCardID			smallint		NOT NULL		IDENTITY,
GuestID					smallint		NOT NULL,
CCType					varchar(5)		NOT NULL,
CCNumber				varchar(16)		NOT NULL,
CCCompany				varchar(40)		NULL,
CCCardHolder			varchar(40)		NOT NULL,
CCExpiration			smalldatetime	NOT NULL
)

CREATE TABLE Discount
(
DiscountID				smallint		NOT NULL		IDENTITY,
DiscountDescription		varchar(50)		NOT NULL,
DiscountExpiration		date			NOT NULL,
DiscountRules			varchar(100)	NULL,
DiscountPercent			decimal(4,2)	NULL,
DiscountAmount			smallmoney		NULL
)

CREATE TABLE RackRate
(
RackRateID				smallint		NOT NULL		IDENTITY,
RoomTypeID				smallint		NOT NULL,
HotelID					smallint		NOT NULL,
RackRate				smallmoney		NOT NULL,
RackRateBegin			date			NOT NULL,
RackRateEnd				date			NOT NULL,
RackRateDescription		varchar(200)	NOT NULL
)

CREATE TABLE Room
(
RoomID					smallint		NOT NULL		IDENTITY,
RoomNumber				varchar(5)		NOT NULL,
RoomDescription			varchar(200)	NOT NULL,
RoomSmoking				bit				NOT NULL,
RoomBedConfiguration	char(2)			NOT NULL, -- add check
HotelID					smallint		NOT NULL,
RoomTypeID				smallint
)

CREATE TABLE Folio
(
FolioID					smallint		NOT NULL		IDENTITY,
ReservationID			smallint		NOT NULL,
GuestID					smallint		NOT NULL,
RoomID					smallint		NOT NULL,
QuotedRate				smallmoney		NOT NULL,
CheckinDate				smalldatetime	NOT NULL,
Nights					tinyint			NOT NULL,
[Status]				char(1)			NOT NULL, -- add check for correct chars
Comments				varchar(200)	NULL,
DiscountID				smallint		NOT NULL -- add default discount of 1
)

CREATE TABLE Hotel
(
HotelID					smallint		NOT NULL,
HotelName				varchar(30)		NOT NULL,
HotelAddress			varchar(30)		NOT NULL,
HotelCity				varchar(20)		NOT NULL,
HotelState				char(2)			NULL,
HotelCountry			varchar(20)		NOT NULL,
HotelPostalCode			char(10)		NOT NULL,
HotelStarRating			char(1)			NULL,
HotelPictureLink		varchar(100)	NULL,
TaxLocationID			smallint		NOT NULL
)

CREATE TABLE Billing
(
FolioBillingID			smallint		NOT NULL		IDENTITY,
FolioID					smallint		NOT NULL,
BillingCategoryID		smallint		NOT NULL,
BillingDescription		char(30)		NOT NULL,
BillingAmount			smallmoney		NOT NULL,
BillingItemQty			tinyint			NOT NULL,
BillingItemDate			date			NOT NULL
)

CREATE TABLE Payment
(
PaymentID				smallint		NOT NULL		IDENTITY(8000,1),
FolioID					smallint		NOT NULL,
PaymentDate				date			NOT NULL,
PaymentAmount			smallmoney		NOT NULL,
PaymentComments			varchar(200)	NULL,
)

CREATE TABLE BillingCategory
(
BillingCategoryID		smallint		NOT NULL		IDENTITY,
BillingCatDescription	varchar(30)		NOT NULL,
BillingCatTaxable		bit				NOT NULL
)

CREATE TABLE TaxRate
(
TaxLocationID			smallint		NOT NULL		IDENTITY,
TaxDescription			varchar(30)		NOT NULL,
RoomTaxRate				decimal(6,4)	NOT NULL,
SalesTaxRate			decimal(6,4)	NOT NULL
)

GO

-- all runs up until this point
-- now alter all pk's

ALTER TABLE Reservation
	ADD CONSTRAINT PK_ReservationID
	PRIMARY KEY (ReservationID)

ALTER TABLE Guest
	ADD CONSTRAINT PK_GuestID
	PRIMARY KEY (GuestID)

ALTER TABLE RoomType
	ADD CONSTRAINT PK_RoomTypeID
	PRIMARY KEY (RoomTypeID)

ALTER TABLE CreditCard
	ADD CONSTRAINT PK_CreditCardID
	PRIMARY KEY (CreditCardID)

ALTER TABLE Discount
	ADD CONSTRAINT PK_DiscountID
	PRIMARY KEY (DiscountID)

ALTER TABLE RackRate
	ADD CONSTRAINT PK_RackRateID
	PRIMARY KEY (RackRateID)

ALTER TABLE Room
	ADD CONSTRAINT PK_RoomID
	PRIMARY KEY (RoomID)

ALTER TABLE Folio
	ADD CONSTRAINT PK_FolioID
	PRIMARY KEY (FolioID)

ALTER TABLE Hotel
	ADD CONSTRAINT PK_HotelID
	PRIMARY KEY (HotelID)

ALTER TABLE Billing
	ADD CONSTRAINT PK_FolioBillingID
	PRIMARY KEY (FolioBillingID)

ALTER TABLE Payment
	ADD CONSTRAINT PK_PaymentID
	PRIMARY KEY (PaymentID)

ALTER TABLE BillingCategory
	ADD CONSTRAINT PK_BillingCategoryID
	PRIMARY KEY (BillingCategoryID)

ALTER TABLE TaxRate
	ADD CONSTRAINT PK_TaxLocationID
	PRIMARY KEY (TaxLocationID)

GO

-- all pk's ran successfully
-- now add all the fk's

ALTER TABLE Reservation
	ADD CONSTRAINT FK_CreditCardID
	FOREIGN KEY (CreditCardID) REFERENCES CreditCard (CreditCardID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE CreditCard
	ADD CONSTRAINT FK_GuestID
	FOREIGN KEY	(GuestID) REFERENCES Guest (GuestID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE RackRate
	ADD 
	
	CONSTRAINT FK_RackRoomTypeID
	FOREIGN KEY (RoomTypeID) REFERENCES RoomType (RoomTypeID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_RackHotelID
	FOREIGN KEY (HotelID) REFERENCES Hotel (HotelID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE Room
	ADD

	CONSTRAINT FK_RoomHotelID 
	FOREIGN KEY (HotelID) REFERENCES Hotel (HotelID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_RoomRoomTypeID 
	FOREIGN KEY (RoomTypeID) REFERENCES RoomType (RoomTypeID)
	ON UPDATE CASCADE
	ON DELETE CASCADE


ALTER TABLE Folio
	ADD

	CONSTRAINT FK_ReservationID
	FOREIGN KEY (ReservationID)	REFERENCES Reservation (ReservationID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_RoomID
	FOREIGN KEY (RoomID) REFERENCES Room (RoomID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_DiscountID
	FOREIGN KEY (DiscountID) REFERENCES Discount (DiscountID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE Billing
	ADD

	CONSTRAINT FK_BillingFolioID
	FOREIGN KEY (FolioID) REFERENCES Folio (FolioID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,

	CONSTRAINT FK_BillingCategoryID
	FOREIGN KEY (BillingCategoryID) REFERENCES BillingCategory (BillingCategoryID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE HOTEL
	ADD CONSTRAINT FK_TaxLocationID
	FOREIGN KEY (TaxLocationID) REFERENCES TaxRate (TaxLocationID)


ALTER TABLE PAYMENT
	ADD CONSTRAINT FK_PaymentFolioID
	FOREIGN KEY (FolioID) REFERENCES Folio (FolioID)

GO

-- all runs so far
-- now add the defaults and checks

ALTER TABLE Folio
	ADD CONSTRAINT DK_DefaultDiscountID
	DEFAULT 1 FOR DiscountID

ALTER TABLE Reservation
	ADD CONSTRAINT CK_CheckForCorrectResStatus
	CHECK (ReservationStatus IN ('R','A', 'C','X'))

ALTER TABLE Room
	ADD CONSTRAINT CK_CheckForCorrectBedConfig
	CHECK (RoomBedConfiguration IN ('K','Q','F','2Q','2K','2F'))

ALTER TABLE Folio
	ADD CONSTRAINT CK_CheckForCorrectStatus
	CHECK ([Status] IN ('R','A', 'C','X'))

GO

-- all runs so far
-- now to bring in bulk insert csv

BULK INSERT Billing FROM 'C:\Stage\FARMS1-1\Billing.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)

--SELECT * FROM Billing

BULK INSERT BillingCategory FROM 'C:\Stage\FARMS1-1\BillingCategory.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT CreditCard FROM 'C:\Stage\FARMS1-1\CreditCard.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT Discount FROM 'C:\Stage\FARMS1-1\Discount.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT Folio FROM 'C:\Stage\FARMS1-1\Folio.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT Guest FROM 'C:\Stage\FARMS1-1\Guest.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT Hotel FROM 'C:\Stage\FARMS1-1\Hotel.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT Payment FROM 'C:\Stage\FARMS1-1\Payment.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT RackRate FROM 'C:\Stage\FARMS1-1\RackRate.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT Reservation FROM 'C:\Stage\FARMS1-1\Reservation.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT Room FROM 'C:\Stage\FARMS1-1\Room.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT RoomType FROM 'C:\Stage\FARMS1-1\RoomType.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

BULK INSERT TaxRate FROM 'C:\Stage\FARMS1-1\TaxRate.txt'
WITH (
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
	)
GO

