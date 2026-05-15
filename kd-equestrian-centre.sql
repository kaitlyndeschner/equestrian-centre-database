--Create database
CREATE DATABASE KDEquestrianCentre

--Use database
USE KDEquestrianCentre

--Create Level table
CREATE TABLE Level
(
LevelID		VARCHAR(2)		NOT NULL,
LevelName	VARCHAR(12)		NOT NULL,

CONSTRAINT pkLevelID PRIMARY KEY (LevelID),

CONSTRAINT chkLevelID	CHECK (LevelID LIKE'B%' OR LevelID LIKE 'N%' OR LevelID LIKE 'I%' OR LevelID LIKE 'A%'),
CONSTRAINT chkLevelName CHECK (LevelName ='Beginner' OR LevelName = 'Novice' OR LevelName = 'Intermediate' OR LevelID = 'Advanced')
);

--Rectify error in Level table (typo in chkLevelName)
ALTER TABLE Level
DROP CONSTRAINT chkLevelName;

ALTER TABLE Level
ADD CONSTRAINT chkLevelName CHECK (LevelName ='Beginner' OR LevelName = 'Novice' OR LevelName = 'Intermediate' OR LevelName = 'Advanced')

--Create Customer table
CREATE TABLE Customer
(
CustomerID	VARCHAR(100)	NOT NULL,
Title		VARCHAR(4)		NOT NULL,
Surname		VARCHAR(40)		NOT NULL,
Forename	VARCHAR(30)		NOT NULL,
Street		VARCHAR(30)		NOT NULL,
Town		VARCHAR(30)		NOT NULL,
County		VARCHAR(30)		NOT NULL,
PostCode	VARCHAR(10)		NOT NULL,
Country		VARCHAR(30)		NOT NULL,
BirthDate	DATE			NOT NULL,
PhoneNum	VARCHAR(20)		NOT NULL,
Email		VARCHAR(50)		NOT NULL UNIQUE,

CONSTRAINT	pkCustomerID PRIMARY KEY (CustomerID),

CONSTRAINT	chkCustomerID			CHECK	(CustomerID LIKE 'C%'),
CONSTRAINT	chkCustomerTitle		CHECK	(Title ='Mr' OR Title = 'Dr' OR Title = 'Miss' OR Title = 'Mrs' OR Title = 'Ms'),
CONSTRAINT	chkCustomerBirthDate	CHECK	(DATEDIFF(YEAR, BirthDate, GETDATE()) >= 18),
CONSTRAINT	chkCustomerPhoneNum		CHECK	(PhoneNum LIKE '+[0-9]%' OR PhoneNum LIKE '07[0-9]%' AND PhoneNum NOT LIKE '%[^0-9]%'),
CONSTRAINT	chkCustomerEmail		CHECK	(Email LIKE '%@%')
);

--Create Rider table
CREATE TABLE Rider
(
RiderID			VARCHAR(100)	NOT NULL,
LevelID			VARCHAR(2)		NOT NULL,
Title			VARCHAR(4)		NOT NULL,
Surname			VARCHAR(40)		NOT NULL,
Forename		VARCHAR(30)		NOT NULL,
Street			VARCHAR(30)		NOT NULL,
Town			VARCHAR(30)		NOT NULL,
County			VARCHAR(30)		NOT NULL,
PostCode		VARCHAR(10)		NOT NULL,
Country			VARCHAR(30)		NOT NULL,
BirthDate		DATE			NOT NULL,
PhoneNum		VARCHAR(20)		NOT NULL,
Email			VARCHAR(50)		NOT NULL,
Gender			VARCHAR(2)		NOT NULL,
Height			TINYINT			NOT NULL,
Weight			SMALLINT		NOT NULL,
EContactName	VARCHAR(50)		NOT NULL,
EContactNum		VARCHAR(20)		NOT NULL,

CONSTRAINT	pkRiderID PRIMARY KEY (RiderID),
CONSTRAINT	fkRider FOREIGN KEY (LevelID) REFERENCES Level (LevelID),

CONSTRAINT	chkRiderID			CHECK	(RiderID LIKE 'R%'),
CONSTRAINT	chkRiderLevelID		CHECK	(LevelID LIKE'B%' OR LevelID LIKE 'N%' OR LevelID LIKE 'I%' OR LevelID LIKE 'A%'),
CONSTRAINT	chkRiderBirthDate	CHECK	(DATEDIFF(YEAR, BirthDate, GETDATE()) >= 5),
CONSTRAINT	chkRiderGender		CHECK	(Gender ='M' OR Gender = 'F'),
CONSTRAINT	chkRiderHeight		CHECK	(Height >= 50),
CONSTRAINT	chkRiderWeight		CHECK	(Weight >= 40 AND Weight <= 375),
CONSTRAINT	chkRiderPhoneNum	CHECK	(PhoneNum LIKE '+[0-9]%' OR PhoneNum LIKE '07[0-9]%' AND PhoneNum NOT LIKE '%[^0-9]%'),
CONSTRAINT	chkRiderEmail		CHECK	(Email LIKE '%@%'),
CONSTRAINT	chkEContactPhoneNum	CHECK	(PhoneNum LIKE '+[0-9]%' OR PhoneNum LIKE '07[0-9]%' AND PhoneNum NOT LIKE '%[^0-9]%')
);

--Rectifying error when inputting data into Rider table
ALTER TABLE Rider
DROP CONSTRAINT chkRiderEmail

ALTER TABLE Rider
ADD CONSTRAINT chkRiderEmail	CHECK	(Email LIKE '%@%' or Email = 'N/A');

--Create Horse table
CREATE TABLE Horse
(
HorseID		VARCHAR(100)	NOT NULL,
LevelID		VARCHAR(2)		NOT NULL,
Name		VARCHAR(40)		NOT NULL,
Gender		VARCHAR(8)		NOT NULL,
Breed		VARCHAR(20) 	NOT NULL,
Colour		VARCHAR(20)		NOT NULL,
Height		TINYINT			NOT NULL,
Weight		SMALLINT		NOT NULL,
BirthDate	DATE			NOT NULL,
RiderPref	VARCHAR(3)		NOT NULL,

CONSTRAINT	pkHorseID PRIMARY KEY (HorseID),
CONSTRAINT	fkHorseLevel FOREIGN KEY (LevelID) REFERENCES Level (LevelID),

CONSTRAINT	chkHorseID		CHECK	(HorseID LIKE 'H%'),
CONSTRAINT	chkHorseLevelID	CHECK	(LevelID LIKE'B%' OR LevelID LIKE 'N%' OR LevelID LIKE 'I%' OR LevelID LIKE 'A%'),
CONSTRAINT	chkHorseGender	CHECK	(Gender ='Mare' OR Gender='Gelding'),
CONSTRAINT	chkHorseHeight	CHECK	(Height >= 50),
CONSTRAINT	chkHorseWeight	CHECK	(Weight >= 500),
CONSTRAINT	chkRiderPref	CHECK	(RiderPref ='M' OR RiderPref = 'F' OR RiderPref = 'N/A')
);

--Create Booking table
CREATE TABLE
Booking
(
BookingID		VARCHAR(100)	NOT NULL,
CustomerID		VARCHAR(100)	NOT NULL,
DateBooked		DATE			NOT NULL,
LessonDate		DATE			NOT NULL,
LessonTime		TIME			NOT NULL,
LessonDuration	TINYINT			NOT NULL,
Paid			VARCHAR(1)		NOT NULL,

CONSTRAINT	pkBookingID PRIMARY KEY (BookingID),
CONSTRAINT	fkBooking FOREIGN KEY (CustomerID) REFERENCES Customer (CustomerID),

CONSTRAINT	chkBookingID		CHECK	(BookingID LIKE 'B%'),
CONSTRAINT	chkCustomerBID		CHECK	(CustomerID LIKE 'C%'),
CONSTRAINT	chkLessonTime		CHECK	(LessonTime >= '09:00:00' AND LessonTime <= '17:00:00'),
CONSTRAINT	chkLessonDuration	CHECK	(LessonDuration = 30 OR LessonDuration = 60),
CONSTRAINT 	chkPaid 			CHECK 	(Paid='T' OR Paid='F'),

CONSTRAINT	uqBooking			UNIQUE	(CustomerID, LessonDate, LessonTime)
);

--Create BookingDetails table
CREATE TABLE BookingDetails
(
BookingDetailID  INT IDENTITY(1000, 1)	NOT NULL,
BookingID        VARCHAR(100)			NOT NULL,
RiderID          VARCHAR(100)			NOT NULL,
HorseID          VARCHAR(100)			NOT NULL,

CONSTRAINT pkBookingDetails PRIMARY KEY (BookingDetailID),
CONSTRAINT fkBookingDetails FOREIGN KEY (BookingID) REFERENCES Booking (BookingID),

CONSTRAINT	chkBookingID2	CHECK	(BookingID LIKE 'B%'),
CONSTRAINT	chkRiderID2		CHECK	(RiderID LIKE 'R%'),
CONSTRAINT	chkHorseID2		CHECK	(HorseID LIKE 'H%'),

CONSTRAINT uqBookingDetails UNIQUE (BookingID, RiderID, HorseID)
);

--Add additional foreign keys to BookingDetails
ALTER TABLE BookingDetails
ADD CONSTRAINT fkBookingDetailsRider FOREIGN KEY (RiderID) REFERENCES Rider (RiderID);

ALTER TABLE BookingDetails
ADD CONSTRAINT fkBookingDetailsHorse FOREIGN KEY (HorseID) REFERENCES Horse (HorseID);

--Insert data into Level table
INSERT INTO Level (LevelID, LevelName)
VALUES 
('B1', 'Beginner'), ('N2', 'Novice'), ('I3', 'Intermediate'), ('A4', 'Advanced');

--Check data inserted into Level table
SELECT * FROM Level

--Insert data into Customer table
INSERT INTO Customer (CustomerID, Title, Surname, Forename, Street, Town, County, PostCode, Country, BirthDate, PhoneNum, Email) 
VALUES
('C1', 'Mrs', 'Simpson', 'Marge', '742 Evergreen Terrace', 'Springfield', 'Illinois', '62704', 'United States', '1976-03-19', '+19395550113', 'margesimpson@gmail.com'),
('C2', 'Mr', 'Carlin', 'Ryan', '20 Lampton Court', 'Strabane', 'Tyrone', 'BT82 7RA', 'Northern Ireland', '1994-06-16', '+447897246423', 'ryancarlin@gmail.com'),
('C3', 'Mrs', 'Smith', 'Lee-ann', '326 Beechwood Court', 'Saskatoon', 'Saskatchewan', 'S7K 1J7', 'Canada', '1976-04-22', '+13063818331', 'leeannsmith@sasktel.net'),
('C4', 'Mr', 'Murphy', 'Cillian', '3 Dublin Road', 'Dublin', 'Dublin', 'D02 X285', 'Republic of Ireland', '1976-05-25', '+353871234567', 'cillianmurphy@gmail.com'),
('C5', 'Mr', 'Shelby', 'Thomas', 'Arley Hall', 'Arley', 'Northwich', 'CW9 6NA', 'England', '1976-05-25', '+447515657770', 'by.order.of.the.peaker.blinders@gmail.com'),
('C6', 'Mr', 'Fraser', 'James', 'Lallybroch', 'South Queensferry', 'West Lothian', 'EH30 9SL', 'Scotland', '1980-04-30', '+449704626600', 'james.alexander.malcolm.mackenzie.fraser@gmail.com'),
('C7', 'Mr', 'Bing', 'Chandler', '20/90 Bedford Street', 'Greenwich Village', 'New York', '10014', 'United States', '1968-04-08', '+19395555544', 'chandler.m.bing@hotmail.com'),
('C8', 'Ms', 'Dawson', 'Rose', '4 Pine Road', 'Calabasas', 'California', '90001', 'United States', '1995-04-05', '+15595556969', 'illneverletgo@hotmail.com'),
('C9', 'Mr', 'Hemsworth', 'Chris', '74 Wellington Place', 'Melbourne', 'Victoria', '3065', 'Australia', '1983-08-11', '+61412345678', 'c.hemsworth@gmail.com'),
('C10', 'Miss', 'Smyth', 'Samantha', '1 Ross Mill Avenue', 'Belfast', 'Antrim', 'BT13 2QH', 'Northern Ireland', '1985-09-16', '+447597800566', 'sam.smyth123@gmail.com'),
('C11', 'Mr', 'Sherman', 'Peter', '42 Wallaby Way', 'Sydney', 'New South Wales', '2000', 'Australia', '2001-01-01', '+61412345444', 'findingnemo@hotmail.com'),
('C12', 'Mr', 'Butt', 'Brent', '3 Tisdale Street', 'Dog River', 'Saskatchewan', 'S7K 4K1', 'Canada', '1966-08-03', '+13062411147', 'cornergas@sasktel.net'),
('C13', 'Mrs', 'Carlin', 'Karen', '20 Main Street', 'Strabane', 'Tyrone', 'BT82 9RT', 'Northern Ireland', '1972-01-06', '+447597043352', 'karen.carlin@gmail.com'),
('C14', 'Mr', 'Smyth', 'Ernie', '123 Sesame Street', 'Moosejaw', 'Saskatchewan', 'SK7 2JK', 'Canada', '1968-05-03', '+13062221234', 'ernie.and.bert@gmail.com'),
('C15', 'Mr', 'Smith', 'Bert', '123 Sesame Street', 'Moosejaw', 'Saskatchewan', 'SK7 2JK', 'Canada', '1968-05-03', '+13062225544', 'bert.and.ernie@gmail.com'),
('C16', 'Miss', 'Doyle', 'Orla', '48 Towncastle Road', 'Holyhill', 'Tyrone', 'BT82 9FS', 'Northern Ireland', '1992-09-09', '+447897112268', 'foreverpaula@gmail.com'),
('C17', 'Mr', 'Doyle', 'Shane', '48 Towncastle Road', 'Holyhill', 'Tyrone', 'BT82 9FS', 'Northern Ireland', '1991-10-10', '+447899994566', 'fringer@gmail.com'),
('C18', 'Mr', 'Griffin', 'Brian', '55 State Street', 'Drumahoe', 'Derry', 'BT47 2AB', 'Northern Ireland', '1948-07-01', '+447866225887', 'brianthedog@gmail.com'),
('C19', 'Mr', 'Randall', 'Frank', '31 Cambirdge Road', 'Cambridge', 'Cambridgeshire', 'SG8 0NU', 'England', '1935-10-31', '+447813247778', 'frank.randall@gmail.com'),
('C20', 'Miss', 'Randall', 'Brianna', '31 Cambirdge Road', 'Cambridge', 'Cambridgeshire', 'SG8 0NU', 'England', '1949-10-01', '+447833318451', 'b.randall@gmail.com');

--Check data inserted into Customer table
SELECT * FROM Customer

--Insert data into Rider table
INSERT INTO Rider (RiderID, LevelID, Title, Surname, Forename, Street, Town, County, PostCode, Country, BirthDate, PhoneNum, Email, Gender, Height, Weight, EContactName, EContactNum)
VALUES
('R1', 'B1', 'Mr', 'Simpson', 'Homer', '742 Evergreen Terrace', 'Springfield', 'Illinois', '62704', 'United States', '1968-01-01', '+19395550114', 'homersimpson@gmail.com', 'M', 65, 300, 'Marge Simpson', '+19395550113'),
('R2', 'N2', 'Mr', 'Carlin', 'Ryan', '20 Ring Road', 'Clady', 'County Tyrone', 'BT82 9RS', 'Ireland', '1994-06-16', '+447897246423', 'ryancarlin@gmail.com', 'M', 75, 180, 'Caitlin Carlin', '+447499991234'),
('R3', 'B1', 'Miss', 'Carlin', 'Ivy', '20 Ring Road', 'Clady', 'County Tyrone', 'BT82 9RS', 'Ireland', '2018-03-03', '+447897246423', 'N/A', 'F', 54, 80, 'Caitlin Carlin', '+447499991234'),
('R4', 'N2', 'Mrs', 'Smith', 'Lee-ann', '326 Beechwood Crescent', 'Saskatoon', 'Saskatchewan', 'S7K 1J7', 'Canada', '1976-04-22', '+13063818331', 'leeannsmith@gmail.com', 'F', 70, 165, 'Paul Smith', '+13063844228'),
('R5', 'A4', 'Mr', 'Murphy', 'Cillian', '3 Dublin Road', 'Dublin', 'Dublin', 'D02 X285', 'Ireland', '1976-05-25', '+353871234567', 'cillianmurphy@gmail.com', 'M', 67, 145, 'Kaitlyn Deschner', '+447597150466'),
('R6', 'A4', 'Mr', 'Shelby', 'Thomas', 'Arley Hall', 'Arley', 'Northwich', 'CW9 6NA', 'England', '1976-05-25', '+447515657770', 'by.order.of.the.peaker.blinders@gmail.com', 'M', 75, 180, 'Grace Shelby', '+447597150469'),
('R7', 'I3', 'Mrs', 'Shelby', 'Grace', 'Arley Hall', 'Arley', 'Northwich', 'CW9 6NA', 'England', '1976-02-14', '+44751565774', 'grace.shelby@gmail.com', 'F', 66, 130, 'Thomas Shelby', '+447515657770'),
('R8', 'A4', 'Mr', 'Fraser', 'James', 'Lallybroch', 'South Queensferry', 'West Lothian', 'EH30 9SL', 'Scotland', '1980-04-30', '+449704626600', 'james.alexander.malcolm.mackenzie.fraser@gmail.com', 'M', 75, 210, 'Claire Fraser', '+447597426990'),
('R9', 'N2', 'Mrs', 'Fraser', 'Claire', 'Lallybroch', 'South Queensferry', 'West Lothian', 'EH30 9SL', 'Scotland', '1978-10-20', '+447597426990', 'claire.e.fraser@gmail.com', 'F', 66, 130, 'James Fraser', '+449704626600'),
('R10', 'A4', 'Mrs', 'Bing', 'Monica', '20/90 Bedford Street', 'Greenwich Village', 'New York', '10014', 'United States', '1969-04-22', '+19395555588', 'monica.bing@gmail.com', 'F', 65, 120, 'Chandler Bing', '+19395555544'),
('R11', 'A4', 'Mr', 'Hemsworth', 'Chris', '74 Wellington Place', 'Melbourne', 'Victoria', '3065', 'Australia', '1983-08-11', '+61412345678', 'c.hemsworth@gmail.com', 'M', 75, 220, 'Catriona Balfe', '+447876684430'),
('R12', 'I3', 'Ms', 'Smyth', 'Samantha', '1 Ross Mill Avenue', 'Belfast', 'Antrim', 'BT13 2QH', 'Ireland', '1985-09-16', '+447597800566', 'sam.smyth123@gmail.com', 'F', 70, 170, 'John Smyth', '+447597800577'),
('R13', 'I3', 'Mr', 'Sherman', 'Peter', '42 Wallaby Way', 'Sydney', 'New South Wales', '2000', 'Australia', '2001-01-01', '+61412345444', 'findingnemo@hotmail.com', 'M', 72, 180, 'Helen Sherman', '+61412345333'),
('R14', 'B1', 'Mr', 'LeRoy', 'Oscar', '12 3rd Avenue', 'Dog River', 'Saskatchewan', 'S7K 4K1', 'Canada', '1945-12-12', '+13062411985', 'jack.donkey@hotmail.com', 'M', 70, 170, 'Emma LeRoy', '+13062559985'),
('R15', 'B1', 'Mrs', 'Carlin', 'Karen', '20 Main Street', 'Strabane', 'Tyrone', 'BT82 9RT', 'Northern Ireland', '1972-01-06', '+447597043352', 'karen.carlin@gmail.com', 'F', 62, 150, 'Dominic Carlin', '+447894327441'),
('R16', 'N2', 'Mr', 'Smyth', 'Ernie', '123 Sesame Street', 'Moosejaw', 'Saskatchewan', 'SK7 2JK', 'Canada', '1968-05-03', '+13062221234', 'ernie.and.bert@gmail.com', 'M', 55, 110, 'Bert Smith', '+13062225544'),
('R17', 'B1', 'Mr', 'Smith', 'Bert', '123 Sesame Street', 'Moosejaw', 'Saskatchewan', 'SK7 2JK', 'Canada', '1968-05-03', '+13062225544', 'bert.and.ernie@gmail.com', 'M', 50, 100, 'Ernie Smyth', '+13062221234'),
('R18', 'I3', 'Miss', 'Doyle', 'Orla', '48 Towncastle Road', 'Holyhill', 'Tyrone', 'BT82 9FS', 'Northern Ireland', '1992-09-09', '+447897112268', 'foreverpaula@gmail.com', 'F', 80, 190, 'Shane Doyle', '+447899994566'),
('R19', 'B1', 'Mr', 'Doyle', 'Shane', '48 Towncastle Road', 'Holyhill', 'Tyrone', 'BT82 9FS', 'Northern Ireland', '1991-10-10', '+447899994566', 'fringer@gmail.com', 'M', 56, 120, 'Orla Doyle', '+447897112268'),
('R20', 'A4', 'Mr', 'Griffin', 'Brian', '55 State Street', 'Drumahoe', 'Derry', 'BT47 2AB', 'Northern Ireland', '1948-07-01', '+447866225887', 'brianthedog@gmail.com', 'M', 50, 100, 'Stewie Griffin', '+447865447789'),
('R21', 'A4', 'Mr', 'Randall', 'Frank', '31 Cambirdge Road', 'Cambridge', 'Cambridgeshire', 'SG8 0NU', 'England', '1935-10-31', '+447813247778', 'frank.randall@gmail.com', 'M', 69, 145, 'Mary Hawkins', '+447711568897'),
('R22', 'I3', 'Miss', 'Randall', 'Brianna', '31 Cambirdge Road', 'Cambridge', 'Cambridgeshire', 'SG8 0NU', 'England', '1949-10-01', '+447833318451', 'b.randall@gmail.com', 'F', 66, 130, 'Claire Fraser', '+447597426990');

--Check data inserted into Rider table
SELECT * FROM Rider

--Insert data into Horse table
INSERT INTO Horse (HorseID, LevelID, Name, Gender, Breed, Colour, Height, Weight, BirthDate, RiderPref)
VALUES
('H1', 'B1', 'Lady', 'Mare', 'Thoroughbred', 'Chestnut', 68, 1200, '1999-10-12', 'M'),
('H2', 'B1', 'Indigo', 'Mare', 'Quarter Horse', 'Blue Roan', 56, 1000, '2011-11-11', 'N/A'),
('H3', 'B1', 'Bob', 'Gelding', 'Irish Sport Horse', 'Dun', 68, 1300, '2019-05-03', 'N/A'),
('H4', 'B1', 'Angel', 'Mare', 'Irish Sport Horse', 'Tobino', 66, 1200, '2005-05-11', 'F'),
('H5', 'B1', 'May the Fourth be With You', 'Gelding', 'Morgan', 'Black', 60, 1000, '2018-05-04', 'N/A'),
('H6', 'B1', 'Good Vibes', 'Mare', 'Cleveland Bay', 'Bay', 55, 1300, '2000-02-22', 'N/A'),
('H7', 'B1', 'Nanaimo Bar', 'Gelding', 'Canadian Horse', 'Black', 62, 1100, '1996-07-01', 'N/A'),
('H8', 'B1', 'Grumpy', 'Gelding', 'Shetland', 'Grey', 50, 500, '1979-05-26', 'N/A'),
('H9', 'B1', 'Kentucky Fried Chicken', 'Gelding', 'Percheron', 'Chestnut', 70, 2500, '2003-09-19', 'N/A'),
('H10', 'B1', 'Brian', 'Gelding', 'Percheron', 'Dark Bay', 68, 2300, '2001-05-12', 'M'),
('H11', 'N2', 'Misty', 'Mare', 'Andalusion', 'Grey', 60, 1200, '2009-05-06', 'N/A'),
('H12', 'N2', 'Spartan', 'Gelding', 'Thoroughbred', 'Black', 67, 1100, '2009-03-03', 'F'),
('H13', 'N2', 'Rocky', 'Gelding', 'Irish Draught', 'Grey', 65, 1300, '2004-06-16', 'N/A'),
('H14', 'N2', 'Autumn', 'Mare', 'Quarter Horse', 'Sorrel', 60, 1200, '2015-07-23', 'N/A'),
('H15', 'N2', 'Lacey', 'Mare', 'Arabian', 'Bucksin', 56, 1000, '2001-05-05', 'N/A'),
('H16', 'N2', 'Ghost', 'Gelding', 'Quarter Horse', 'Grey', 58, 1100, '2000-10-31', 'N/A'),
('H17', 'N2', 'Flash', 'Gelding', 'Quarter Horse', 'Liver Chestnut', 59, 1000, '2000-08-14', 'M'),
('H18', 'I3', 'Satan', 'Gelding', 'Welsh', 'Palomino', 55, 1300, '2011-12-25', 'N/A'),
('H19', 'I3', 'April Fools', 'Mare', 'Arabian', 'Red Roan', 57, 900, '2016-04-01', 'N/A'),
('H20', 'I3', 'Maple Syrup', 'Mare', 'Canadian Horse', 'Bay', 60, 1000, '2010-06-02', 'N/A'),
('H21', 'I3', 'Budweiser', 'Gelding', 'Clydsdale', 'Bay', 72, 2000, '2012-03-03', 'N/A'),
('H22', 'I3', 'Pirate of the Caribbean', 'Gelding', 'Barb', 'Dark Bay', 59, 1000, '2003-07-09', 'N/A'),
('H23', 'I3', 'Spirit', 'Gelding', 'Mustang', 'Buckskin', 60, 900, '2002-05-24', 'M'),
('H24', 'I3', 'King of Spades', 'Gelding', 'Thoroughbred', 'Dark Bay', 72, 1400, '2019-09-19', 'N/A'),
('H25', 'A4', 'Secretariat', 'Gelding', 'Thoroughbred', 'Chestnut', 66, 1200, '1970-03-30', 'N/A'),
('H26', 'A4', 'Grace''s Secret', 'Mare', 'Thoroughbred', 'Grey', 65, 1100, '2017-06-16', 'M'),
('H27', 'A4', 'Death Wish', 'Gelding', 'Shire', 'Dark Bay', 75, 2500, '2003-07-13', 'N/A'),
('H28', 'A4', 'Arabian Knights', 'Gelding', 'Arabian', 'Black', 61, 1100, '2018-04-20', 'N/A'),
('H29', 'A4', 'Vhagar', 'Mare', 'Irish Sport Horse', 'Black', 72, 1400, '2016-02-23', 'F'),
('H30', 'A4', 'Roxy', 'Mare', 'Hackney Horse', 'Liver Chestnut', 58, 1400, '2017-10-07', 'N/A');

--Check data inserted into Horse table
SELECT * FROM Horse

--Insert data into Booking table
INSERT INTO Booking (BookingID, CustomerID, DateBooked, LessonDate, LessonTime, LessonDuration, Paid)
VALUES
('B1-L1', 'C1', '2024-01-01', '2024-01-15', '13:00', 30, 'T'),
('B2-L1', 'C2', '2024-01-03', '2024-01-16', '14:00', 30, 'T'),
('B2-L2', 'C2', '2024-01-03', '2024-01-16', '14:30', 30, 'T'),
('B3-L1', 'C3', '2024-01-06', '2024-01-16', '16:00', 30, 'T'),
('B4-L1', 'C4', '2024-01-10', '2024-01-20', '11:00', 30, 'T'),
('B5-L1', 'C5', '2024-01-15', '2024-01-20', '13:00', 30, 'T'),
('B5-L2', 'C5', '2024-01-15', '2024-01-20', '13:30', 30, 'T'),
('B6-L1', 'C6', '2024-01-22', '2024-01-28', '15:00', 30, 'T'),
('B6-L2', 'C6', '2024-01-22', '2024-01-28', '15:30', 30, 'T'),
('B6-L3', 'C6', '2024-01-23', '2024-01-28', '16:00', 60, 'T'),
('B7-L1', 'C2', '2024-01-23', '2024-01-28', '17:00', 60, 'T'),
('B8-L1', 'C7', '2024-01-25', '2024-02-04', '14:00', 30, 'T'),
('B9-L1', 'C9', '2024-01-26', '2024-02-04', '15:00', 30, 'T'),
('B10-L1', 'C10', '2024-02-01', '2024-02-03', '12:00', 30, 'T'),
('B10-L2', 'C10', '2024-02-04', '2024-02-05', '12:00', 60, 'T'),
('B11-L1', 'C11', '2024-02-04', '2024-02-05', '15:00', 30, 'T'),
('B12-L1', 'C12', '2024-02-10', '2024-02-20', '12:00', 30, 'F'),
('B10-L3', 'C10', '2024-02-15', '2024-02-20', '13:00', 60, 'T'),
('B13-L1', 'C2', '2024-02-18', '2024-02-23', '10:00', 60, 'T'),
('B13-L2', 'C2', '2024-02-18', '2024-02-23', '11:00', 60, 'T'),
('B14-L1', 'C7', '2024-02-20', '2024-02-23', '12:00', 60, 'T'),
('B15-L1', 'C5', '2024-02-20', '2024-02-23', '14:00', 60, 'T'),
('B16-L1', 'C9', '2024-02-21', '2024-02-23', '15:00', 30, 'T'),
('B17-L1', 'C4', '2024-02-21', '2024-02-23', '17:00', 60, 'T'),
('B14-L2', 'C7', '2024-04-03', '2024-04-04', '11:00', 30, 'T'),
('B16-L2', 'C9', '2024-04-04', '2024-04-10', '12:00', 60, 'T'),
('B18-L1', 'C5', '2024-04-11', '2024-04-15', '14:00', 60, 'T'),
('B18-L2', 'C5', '2024-04-11', '2024-04-15', '15:00', 60, 'T'),
('B19-L1', 'C2', '2024-04-20', '2024-05-04', '15:00', 60, 'T'),
('B19-L2', 'C2', '2024-04-21', '2024-05-04', '16:00', 60, 'T'),
('B22-L1', 'C3', '2024-04-21', '2024-05-05', '12:00', 30, 'F'),
('B23-L1', 'C13', '2024-04-22', '2024-05-05', '13:00', 30, 'T'),
('B24-L1', 'C14', '2024-05-01', '2024-05-20', '11:00', 60, 'T'),
('B25-L1', 'C15', '2024-05-01', '2024-05-20', '12:00', 60, 'T'),
('B26-L1', 'C16', '2024-05-02', '2024-05-21', '14:00', 60, 'T'),
('B27-L1', 'C17', '2024-05-02', '2024-05-21', '15:00', 30, 'F'),
('B28-L1', 'C18', '2024-06-06', '2024-06-08', '16:00', 60, 'T'),
('B29-L1', 'C19', '2024-06-15', '2024-06-21', '15:00', 60, 'T'),
('B30-L1', 'C20', '2024-06-15', '2024-06-21', '16:00', 60, 'T');

--Check data inserted into Booking table
SELECT * FROM Booking

--Insert data into BookingDetails table
INSERT INTO BookingDetails (BookingID, RiderID, HorseID)
VALUES
('B1-L1', 'R1', 'H9'),
('B2-L1', 'R2', 'H13'),
('B2-L2', 'R3', 'H6'),
('B3-L1', 'R4', 'H4'),
('B4-L1', 'R5', 'H28'),
('B5-L1', 'R6', 'H26'),
('B5-L2', 'R7', 'H22'),
('B6-L1', 'R8', 'H27'),
('B6-L2', 'R9', 'H11'),
('B6-L3', 'R6', 'H26'),
('B7-L1', 'R3', 'H6'),
('B8-L1', 'R10', 'H28'),
('B9-L1', 'R11', 'H27'),
('B10-L1', 'R12', 'H13'),
('B10-L2', 'R12', 'H24'),
('B11-L1', 'R13', 'H24'),
('B12-L1', 'R14', 'H10'),
('B10-L3', 'R12', 'H24'),
('B13-L1', 'R3', 'H6'),
('B13-L2', 'R2', 'H13'),
('B14-L1', 'R10', 'H28'),
('B15-L1', 'R7', 'H22'),
('B16-L1', 'R11', 'H27'),
('B17-L1', 'R5', 'H28'),
('B14-L2', 'R10', 'H29'),
('B16-L2', 'R11', 'H27'),
('B18-L1', 'R6', 'H26'),
('B18-L2', 'R7', 'H22'),
('B19-L1', 'R2', 'H13'),
('B19-L2', 'R3', 'H5'),
('B22-L1', 'R4', 'H4'),
('B23-L1', 'R15', 'H4'),
('B24-L1', 'R16', 'H17'),
('B25-L1', 'R17', 'H2'),
('B26-L1', 'R18', 'H21'),
('B27-L1', 'R19', 'H2'),
('B28-L1', 'R20', 'H30'),
('B29-L1', 'R21', 'H30'),
('B30-L1', 'R22', 'H22');

--Check data inserted into BookingDetails table
SELECT * FROM BookingDetails

--Stored procedure for adding customer
CREATE PROCEDURE spAddCustomer
    @CustomerID VARCHAR(100),
    @Title VARCHAR(4),
    @Surname VARCHAR(40),
    @Forename VARCHAR(30),
    @Street VARCHAR(30),
    @Town VARCHAR(30),
    @County VARCHAR(30),
    @PostCode VARCHAR(10),
    @Country VARCHAR(30),
    @BirthDate DATE,
    @PhoneNum VARCHAR(20),
    @Email VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            RAISERROR('Customer ID already exists!', 11, 1);
            RETURN;
        END
        IF (@CustomerID NOT LIKE 'C%')
        BEGIN
            RAISERROR('Customer ID must begin with C.', 11, 1);
            RETURN;
        END
        IF (@Title NOT IN ('Mr', 'Dr', 'Miss', 'Ms', 'Mrs'))
        BEGIN
            RAISERROR('Please select Mr, Dr, Miss, Ms, or Mrs as a title.', 11, 1);
            RETURN;
        END
        IF (DATEDIFF(YEAR, @BirthDate, GETDATE()) < 5)
        BEGIN
            RAISERROR('All customers must be at least 18 years old.', 11, 1);
            RETURN;
        END
        IF (@PhoneNum LIKE '+[0-9]%' OR @PhoneNum LIKE '07[0-9]%' AND @PhoneNum NOT LIKE '%[^0-9]%')
        BEGIN
            RAISERROR('Phone number must begin with either + or 07 and contain numeric values.', 11, 1);
            RETURN;
        END
        IF EXISTS (SELECT * FROM Customer WHERE Email = @Email)
        BEGIN
            RAISERROR('This Email already exists!', 11, 1);
            RETURN;
        END
        INSERT INTO Customer (CustomerID, Title, Surname, Forename, Street, Town, County, PostCode, Country, BirthDate, PhoneNum, Email)
        VALUES (@CustomerID, @Title, @Surname, @Forename, @Street, @Town, @County, @PostCode, @Country, @BirthDate, @PhoneNum, @Email);
    END TRY
    BEGIN CATCH
        DECLARE @AddCustomerErrorMessage VARCHAR(100);
        SELECT @AddCustomerErrorMessage = ERROR_MESSAGE();
        PRINT @AddCustomerErrorMessage;
    END CATCH
END

--Altering stored procedure (error in phone number if statment)
DROP PROCEDURE spAddCustomer

CREATE PROCEDURE spAddCustomer
    @CustomerID VARCHAR(100),
    @Title VARCHAR(4),
    @Surname VARCHAR(40),
    @Forename VARCHAR(30),
    @Street VARCHAR(30),
    @Town VARCHAR(30),
    @County VARCHAR(30),
    @PostCode VARCHAR(10),
    @Country VARCHAR(30),
    @BirthDate DATE,
    @PhoneNum VARCHAR(20),
    @Email VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Customer WHERE CustomerID = @CustomerID)
        BEGIN
            RAISERROR('Customer ID already exists!', 11, 1);
            RETURN;
        END
        IF (@CustomerID NOT LIKE 'C%')
        BEGIN
            RAISERROR('Customer ID must begin with C.', 11, 1);
            RETURN;
        END
        IF (@Title NOT IN ('Mr', 'Dr', 'Miss', 'Ms', 'Mrs'))
        BEGIN
            RAISERROR('Please select Mr, Dr, Miss, Ms, or Mrs as a title.', 11, 1);
            RETURN;
        END
        IF (DATEDIFF(YEAR, @BirthDate, GETDATE()) < 5)
        BEGIN
            RAISERROR('All customers must be at least 18 years old.', 11, 1);
            RETURN;
        END
        IF (@PhoneNum LIKE '+[0-9]%' AND @PhoneNum LIKE '07[0-9]%' AND @PhoneNum NOT LIKE '%[^0-9]%')
        BEGIN
            RAISERROR('Phone number must begin with either + or 07 and contain numeric values.', 11, 1);
            RETURN;
        END
        IF EXISTS (SELECT * FROM Customer WHERE Email = @Email)
        BEGIN
            RAISERROR('This Email already exists!', 11, 1);
            RETURN;
        END
        INSERT INTO Customer (CustomerID, Title, Surname, Forename, Street, Town, County, PostCode, Country, BirthDate, PhoneNum, Email)
        VALUES (@CustomerID, @Title, @Surname, @Forename, @Street, @Town, @County, @PostCode, @Country, @BirthDate, @PhoneNum, @Email);
    END TRY
    BEGIN CATCH
        DECLARE @AddCustomerErrorMessage VARCHAR(100);
        SELECT @AddCustomerErrorMessage = ERROR_MESSAGE();
        PRINT @AddCustomerErrorMessage;
    END CATCH
END

--Testing stored procedure for adding customer
EXEC spAddCustomer 'C99', 'Miss', 'Deschner', 'Kaitlyn', '123 Main Street', 'Saskatoon', 'Saskatchewan', 'S7K 2J6', 'Canada', '1996-02-23', '+13063717338', 'k.deschner@sasktel.net'

SELECT * FROM Customer
WHERE CustomerID = 'C99'

DELETE FROM Customer
WHERE CustomerID = 'C99'

--Stored procedure for adding rider
CREATE PROCEDURE spAddRider
    @RiderID VARCHAR(100),
    @LevelID VARCHAR(2),
    @Title VARCHAR(4),
    @Surname VARCHAR(40),
    @Forename VARCHAR(30),
    @Street VARCHAR(30),
    @Town VARCHAR(30),
    @County VARCHAR(30),
    @PostCode VARCHAR(10),
    @Country VARCHAR(30),
    @BirthDate DATE,
    @PhoneNum VARCHAR(20),
    @Email VARCHAR(50),
    @Gender VARCHAR(2),
    @Height TINYINT,
    @Weight SMALLINT,
    @EContactName VARCHAR(50),
    @EContactNum VARCHAR(20)
AS
BEGIN
    BEGIN TRY
        IF EXISTS (SELECT * FROM Rider WHERE RiderID = @RiderID)
        BEGIN
            RAISERROR('Rider ID already exists!', 11, 1);
            RETURN;
        END
        IF (@RiderID NOT LIKE 'R%')
        BEGIN
            RAISERROR('Rider ID must begin with R.', 11, 1);
            RETURN;
        END
        IF (@Title NOT IN ('Mr', 'Dr', 'Miss', 'Ms', 'Mrs'))
        BEGIN
            RAISERROR('Please select Mr, Dr, Miss, Ms, or Mrs as a title.', 11, 1);
            RETURN;
        END
        IF (DATEDIFF(YEAR, @BirthDate, GETDATE()) < 5)
        BEGIN
            RAISERROR('All riders must be at least 5 years old.', 11, 1);
            RETURN;
        END
        IF (@PhoneNum LIKE '+[0-9]%' AND @PhoneNum LIKE '07[0-9]%' AND @PhoneNum NOT LIKE '%[^0-9]%')
        BEGIN
            RAISERROR('Phone number must begin with either + or 07 and contain numeric values.', 11, 1);
            RETURN;
        END
        IF (@Email != 'N/A' AND EXISTS (SELECT * FROM Rider WHERE Email = @Email))
        BEGIN
            RAISERROR('This Email already exists!', 11, 1);
            RETURN;
        END
        INSERT INTO Rider (RiderID, LevelID, Title, Surname, Forename, Street, Town, County, PostCode, Country, BirthDate, PhoneNum, Email, Gender, Height, Weight, EContactName, EContactNum)
        VALUES (@RiderID, @LevelID, @Title, @Surname, @Forename, @Street, @Town, @County, @PostCode, @Country, @BirthDate, @PhoneNum, @Email, @Gender, @Height, @Weight, @EContactName, @EContactNum);
    END TRY
    BEGIN CATCH
        DECLARE @RiderErrorMessage VARCHAR(100);
        SELECT @RiderErrorMessage = ERROR_MESSAGE();
        PRINT @RiderErrorMessage;
    END CATCH
END

--Testing stored procedure for adding rider
EXEC spAddRider 'R99', 'A4', 'Miss', 'Deschner', 'Kaitlyn', '123 Main Street', 'Saskatoon', 'Saskatchewan', 'S7K 2J6', 'Canada', '1996-02-23', '+13063712222', 'N/A', 'F', 66, 130, 'Cillian Murphy', '+353123451234';

SELECT * FROM Rider
WHERE RiderID = 'R99'

DELETE FROM Rider
WHERE RiderID = 'R99'

--Stored procedure for adding Horse
CREATE PROCEDURE spAddHorse 
	@HorseID VARCHAR(10),
	@LevelID VARCHAR(10),
	@Name VARCHAR(40),
	@Gender VARCHAR(8),
	@Breed VARCHAR(20),
	@Colour VARCHAR(20),
	@Height TINYINT,
	@Weight SMALLINT,
	@BirthDate DATE,
	@RiderPref VARCHAR(3)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM Horse WHERE HorseID = @HorseID)
		BEGIN
			RAISERROR('Horse ID already exists!', 11, 1)
			RETURN;
		END
		IF (@HorseID NOT LIKE 'H%')
		BEGIN
			RAISERROR('Horse ID must begin with H.', 11, 1)
			RETURN;
		END
		IF (@Gender !='Mare' AND @Gender !='Gelding')
		BEGIN
			RAISERROR('Please enter either mare or gelding.', 11, 1)
			RETURN;
		END
		IF (@Height < 50)
		BEGIN
			RAISERROR('Horses must be a minimum of 50 inches tall.', 11, 1)
			RETURN;
		END
		IF (@Weight < 500)
		BEGIN
			RAISERROR('Horses must be a minium of 500 pounds.', 11, 1)
			RETURN;
		END
		IF (@RiderPref !='M' AND @RiderPref != 'F' AND @RiderPref != 'N/A')
		BEGIN
			RAISERROR('Please enter either male or female rider gender preference (M/F)', 11, 1)
			RETURN;
		END
		INSERT INTO Horse (HorseID, LevelID, Name, Gender, Breed, Colour, Height, Weight, BirthDate, RiderPref)
		VALUES(@HorseID, @LevelID, @Name, @Gender, @Breed, @Colour, @Height, @Weight, @BirthDate, @RiderPref);
	END TRY
BEGIN CATCH
	DECLARE @AddHorseErrorMessage VARCHAR(100);
	SELECT @AddHorseErrorMessage = ERROR_MESSAGE();
	PRINT @AddHorseErrorMessage;
END CATCH
END

--Testing stored procedure for adding horses
EXEC spAddHorse 'H99', 'A4', 'Violet', 'Mare', 'Irish Sport Horse', 'Black', '60', '1200', '2021-01-23', 'N/A'

SELECT * FROM Horse
WHERE HorseID = 'H99'

DELETE FROM Horse
WHERE HorseID = 'H99'

--Stored procedure for adding bookings
CREATE PROCEDURE spAddBooking
	@BookingID VARCHAR(100),
	@CustomerID VARCHAR(100),
	@DateBooked DATE,
	@LessonDate DATE,
	@LessonTime TIME,
	@LessonDuration TINYINT,
	@Paid VARCHAR(1)
AS
BEGIN
	BEGIN TRY
		IF (@BookingID NOT LIKE 'B%')
		BEGIN
			RAISERROR('Booking ID must begin with B.', 11, 1)
			RETURN;
		END
		IF (@CustomerID NOT LIKE 'C%')
		BEGIN
			RAISERROR('Booking ID must begin with B.', 11, 1)
			RETURN;
		END
		IF (@LessonTime < '09:00:00' AND @LessonTime > '17:00:00')
		BEGIN
			RAISERROR('Lessons only take place between 9am and 5pm.', 11, 1)
			RETURN;
		END
		IF (@LessonDuration != 30 AND @LessonDuration != 60)
		BEGIN
			RAISERROR('Lessons are for either 30 or 60 minute durations.', 11, 1)
			RETURN;
		END
		IF (@Paid != 'T' AND @Paid !='F')
		BEGIN
			RAISERROR('Please verify if the lesson has been paid for (T/F).', 11, 1)
			RETURN;
		END
		INSERT INTO Booking (BookingID, CustomerID, DateBooked, LessonDate, LessonTime, LessonDuration, Paid)
		VALUES (@BookingID, @CustomerID, @DateBooked, @LessonDate, @LessonTime, @LessonDuration, @Paid);
	END TRY
BEGIN CATCH
	DECLARE @AddBookingErrorMessage VARCHAR(100);
	SELECT @AddBookingErrorMessage = ERROR_MESSAGE();
	PRINT @AddBookingErrorMessage;
END CATCH
END

--Testing spAddBooking
EXEC spAddBooking 'B99-L1', 'C2', '2024-11-11', '2024-12-12', '09:00', '60', 'T'

SELECT * FROM Booking
WHERE BookingID = 'B99-L1'

DELETE FROM Booking
WHERE BookingID = 'B99-L1'

--Stored procedure for locating emergency contact information
CREATE PROCEDURE spEmergencyContact 
    @Forename VARCHAR(30) = NULL,
    @Surname VARCHAR(40) = NULL
AS
BEGIN
    BEGIN TRY
        DECLARE @EContactName VARCHAR(50), @EContactNum VARCHAR(20);
        IF (@Forename IS NOT NULL AND @Surname IS NOT NULL)
        BEGIN
            SELECT 
                @EContactName = EContactName,
                @EContactNum = EContactNum
            FROM Rider
            WHERE Forename = @Forename AND Surname = @Surname;
        END
        ELSE IF (@Forename IS NOT NULL)
        BEGIN
            SELECT 
                @EContactName = EContactName,
                @EContactNum = EContactNum
            FROM Rider
            WHERE Forename = @Forename;
        END
        ELSE IF (@Surname IS NOT NULL)
        BEGIN
            SELECT 
                @EContactName = EContactName,
                @EContactNum = EContactNum
            FROM Rider
            WHERE Surname = @Surname;
        END
        SELECT 
            @EContactName AS EmergencyContactName,
            @EContactNum AS EmergencyContactNumber;
    END TRY
    BEGIN CATCH
        DECLARE @EmergencyContactErrorMessage VARCHAR(100);
        SELECT @EmergencyContactErrorMessage = ERROR_MESSAGE();
        PRINT @EmergencyContactErrorMessage;
    END CATCH
END

--Testing spEmergencyContact
EXEC spEmergencyContact @Surname = 'Murphy', @Forename = 'Cillian'

EXEC spEmergencyContact @Forename = 'Cillian'

EXEC spEmergencyContact @Surname = 'Murphy'

EXEC spEmergencyContact @Surname = 'Thisisnotaname', @Forename = 'Thisisnotaname'

--Stored procedure for matching riders to horses
CREATE PROCEDURE spHorseAndRider
    @Forename	VARCHAR(30),
    @Surname	VARCHAR(40),
	@HorseName	VARCHAR(40)
AS
BEGIN
    BEGIN TRY
        DECLARE @RiderLevel VARCHAR(2), @RiderWeight SMALLINT, @RiderGender VARCHAR(1);
        DECLARE @HorseLevel VARCHAR(2), @HorseWeight SMALLINT, @HorseRiderPref VARCHAR(3);
		DECLARE @HRCheck TINYINT;
        
        SELECT 
			@RiderLevel = LevelID,
            @RiderWeight = Weight,
            @RiderGender = Gender
        FROM Rider
        WHERE Forename = @Forename AND Surname = @Surname;

        SELECT 
            @HorseLevel = LevelID,
            @HorseWeight = Weight,
            @HorseRiderPref = RiderPref
        FROM Horse
        WHERE Name = @HorseName;

        IF (@RiderLevel = 'A4' OR
           (@RiderLevel = 'I3' AND @HorseLevel IN ('I3', 'N2', 'B1')) OR
           (@RiderLevel = 'N2' AND @HorseLevel IN ('N2', 'B1')) OR
           (@RiderLevel = 'B1' AND @HorseLevel = 'B1'))
        BEGIN
            SET @LevelCheck = 1;
        END
        ELSE
        BEGIN
            RAISERROR('The rider is not experienced enough for this horse!', 11, 1);
            RETURN;
        END
        IF (@RiderWeight > @HorseWeight * 0.15)
        BEGIN
            RAISERROR('The rider exceeds the weight limit for this horse!', 11, 1);
            RETURN;
        END
        IF (@HorseRiderPref != 'N/A' AND @HorseRiderPref != @RiderGender)
        BEGIN
            RAISERROR('The horse is not suitable for riders of this gender.', 11, 1);
            RETURN;
        END
        PRINT 'The selected rider is suitable for this horse.';
    END TRY
    BEGIN CATCH
        DECLARE @HorseAndRiderErrorMessage VARCHAR(100);
        SELECT @HorseAndRiderErrorMessage = ERROR_MESSAGE();
        PRINT @HorseAndRiderErrorMessage;
    END CATCH
END

--Testing spHorseAndRider
EXEC spHorseAndRider @Forename = 'Homer', @Surname = 'Simpson', @HorseName = 'Roxy'

EXEC spHorseAndRider @Forename = 'Homer', @Surname = 'Simpson', @HorseName = 'Grumpy'

EXEC spHorseAndRider @Forename = 'Ivy', @Surname = 'Carlin', @HorseName = 'Lady'

EXEC spHorseAndRider @Forename = 'Homer', @Surname = 'Simpson', @HorseName = 'Kentucky Fried Chicken'

--Adding new rider and customer to database
EXEC spAddRider @RiderID = 'R23', @LevelID = 'I3', @Title = 'Mr', @Surname = 'Jackson', @Forename = 'Michael', @Street = '45 Thriller Street', @Town = 'Belfast', @County ='Antrim', @PostCode = 'BT13 2QS', @Country = 'Northern Ireland', @BirthDate = '1958-08-29', @PhoneNum ='07599995547', @Email = 'blackandwhite@gmail.com', @Gender = 'M', @Height = '69', @Weight = '136', @EContactName = 'Blanket Jackson', @EContactNum = '+447411256897'

SELECT * FROM Rider
WHERE RiderID = 'R23'

EXEC spAddCustomer @CustomerID = 'C21', @Title = 'Mr', @Surname = 'Jackson', @Forename = 'Michael', @Street = '45 Thriller Street', @Town = 'Belfast', @County ='Antrim', @PostCode = 'BT13 2QS', @Country = 'Northern Ireland', @BirthDate = '1958-08-29', @PhoneNum ='07599995547', @Email = 'blackandwhite@gmail.com' 

SELECT * FROM Customer
WHERE CustomerID = 'C21'

--Locating top customer
SELECT b.CustomerID, c.Title, c.Surname, c.Forename, c.PhoneNum, c.Email,
COUNT(b.BookingID) AS Bookings
FROM Booking b
JOIN Customer c ON b.CustomerID = c.CustomerID
GROUP BY b.CustomerID, c.Title, c.Surname, c.Forename, c.PhoneNum, c.Email
ORDER BY Bookings DESC;

--Locating top rider
SELECT bd.RiderID, r.Title, r.Surname, r.Forename, r.PhoneNum, r.Email,
COUNT(bd.BookingID) AS Bookings
FROM BookingDetails bd
JOIN Rider r ON bd.RiderID = r.RiderID
GROUP BY bd.RiderID, r.Title, r.Surname, r.Forename, r.PhoneNum, r.Email
ORDER BY Bookings DESC;

--Locating horses not in use
SELECT h.HorseID, h.Name, h.Gender, h.Breed, h.Colour, h.Height, h.Weight, h.BirthDate, h.LevelID, h.RiderPref FROM Horse h
JOIN BookingDetails bd ON h.HorseID = bd.HorseID
JOIN Booking b ON bd.BookingID = b.BookingID
WHERE NOT EXISTS (SELECT 1 FROM BookingDetails bd 
WHERE bd.HorseID = h.HorseID
AND b.LessonDate >= DATEADD(MONTH, -6, GETDATE()))
ORDER BY
CASE
	WHEN h.LevelID = 'A%' THEN 1
	WHEN h.LevelID = 'I%' THEN 2
	WHEN h.LevelID = 'N%' THEN 3
	WHEN h.LevelID = 'B%' THEN 4
END ASC,
h.BirthDate ASC;

--Locating horse for Michael Jackson
SELECT Name FROM Horse
WHERE Breed = 'Thoroughbred' AND LevelID = 'I3'

EXEC spHorseAndRider @Surname = 'Jackson', @Forename = 'Michael', @HorseName = 'King of Spades'

EXEC spAddBooking @BookingID = 'B31-L1', @CustomerID = 'C21', @DateBooked = '2024-11-29', @LessonDate = '2024-12-25', @LessonTime = '10:00' , @LessonDuration = '60', @Paid = 'T'

SELECT * FROM Booking
WHERE BookingID = 'B31-L1'