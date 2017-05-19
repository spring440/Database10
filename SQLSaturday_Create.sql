USE [master];
GO

IF DB_ID('SQLSaturday') IS NOT NULL
	DROP DATABASE [SQLSaturday];
GO

CREATE DATABASE [SQLSaturday];
GO

USE SQLSaturday;
GO
/* ---------------------------------------------
	tables with no fk in Alpha Order
   ----------------------------------------------*/

--complexity is for the complexity level of the presentations
CREATE TABLE complexity (
	complexityID INT Not Null identity PRIMARY KEY, 
	complexityLevel VARCHAR(20),
);

--country is the table that stores the various country codes
CREATE TABLE country(
	code2Char VARCHAR(2) NOT NULL PRIMARY KEY,
	code3Char VARCHAR(3) NOT NULL,
	code3Num VARCHAR(3) NOT NULL,
	countryName VARCHAR(50)
);

--GRADES
CREATE TABLE grade(
	gradeID INT IDENTITY NOT NULL PRIMARY KEY,
	grade VARCHAR(1)
);

--Country's region
CREATE TABLE region (
	regionID INT NOT NULL IDENTITY PRIMARY KEY,
	regionName VARCHAR(30)
);

--roleTable (named this way because role is a keyword)
CREATE TABLE roleTable (
	roleID INT NOT NULL IDENTITY PRIMARY KEY,
	roleName VARCHAR(30)
);

--sponsorLevel
CREATE TABLE sponsorLevel (
	sponsorLevelID INT NOT NULL IDENTITY PRIMARY KEY,
	sponsorLevel VARCHAR(30)
);

--track
CREATE TABLE track (
	trackID INT NOT NULL IDENTITY PRIMARY KEY,
	trackName VARCHAR(60)
)

GO

/* ---------------------------------------------
	tables with >=1 fk in dependency Order
   ----------------------------------------------*/

--venues where all sql saturday events are held
CREATE TABLE venue(
	venueID INT NOT NULL IDENTITY PRIMARY KEY,
	street VARCHAR(50),
	street2 VARCHAR(50),
	city VARCHAR(50),
	subdivisionOrState VARCHAR(100),
	postalCode VARCHAR(16),
	countryID VARCHAR(2) REFERENCES country(code2char),
	regionID INT REFERENCES region(regionID)
);

GO
--person
CREATE TABLE person(
	personID INT IDENTITY NOT NULL PRIMARY KEY,
	firstName VARCHAR(40),
	lastName VARCHAR(40),
	email VARCHAR(100) UNIQUE,
	streetAddress VARCHAR(50),
	streetAddress2 VARCHAR(50),
	city VARCHAR(50),
	subdivisionOrState VARCHAR(100),
	postalCode VARCHAR(16),
	countryID VARCHAR(2) REFERENCES country(code2char)
);

GO

--personRole
CREATE TABLE personRole(
	personID INT NOT NULL REFERENCES person(personID),
	roleID INT NOT NULL REFERENCES roleTable(roleID)
);

GO

ALTER TABLE personRole
ADD PRIMARY KEY(personID,roleID);

GO
--event holds all events
CREATE TABLE events(
	eventID INT NOT NULL IDENTITY PRIMARY KEY,
	eventName VARCHAR(100) NOT NULL,
	eventNumber INT,
	eventDate DATE NOT NULL,
	venueID INT REFERENCES venue(venueID) ,
	regionID INT REFERENCES region(regionID)
);

GO

--presentation information table
CREATE TABLE presentation(
	presentationID INT IDENTITY NOT NULL PRIMARY KEY,
	topicName VARCHAR(100),
	topicDescription VARCHAR(255),
	durationMinutes INT,
	complexityID INT REFERENCES complexity(complexityID),
	personID INT REFERENCES person(personID),
	approved BIT DEFAULT 0,
	trackID INT REFERENCES track(trackID),
	eventID INT REFERENCES events(eventID),
	gradeID INT REFERENCES grade(gradeID)
);

GO

--sponsor (formerly vendor)
CREATE TABLE sponsor (
	sponsorID INT NOT NULL IDENTITY PRIMARY KEY,
	sponsorName VARCHAR(40),
	softwareSolution VARCHAR(50),
	sponsorLevelID INT REFERENCES sponsorLevel(sponsorLevelID),
	gapSponsor BIT
);

GO

--giftRaffle
CREATE TABLE giftRaffle(
	email VARCHAR(100) REFERENCES person(email),
	sponsorID INT REFERENCES sponsor(sponsorID)
);

--room
CREATE TABLE room (
	roomID INT NOT NULL IDENTITY PRIMARY KEY,
	roomName VARCHAR(30),
	capacity INT,
	venueID INT REFERENCES venue(venueID)
);

GO
--schedule
CREATE TABLE schedule(
	scheduleID INT NOT NULL IDENTITY PRIMARY KEY,
	roomID INT REFERENCES room(roomID),
	presentationID INT REFERENCES presentation(presentationID),
	classTime time
);

/* Useful code 


--creating unique Index for email on a persom
ALTER TABLE person
ADD UNIQUE (email);

--delete a table
DELETE person;

INSERT INTO person (firstName,email) VALUES
('person1','person@gmail.com'),
('person2','person2@gmail.com');

INSERT INTO dbo.complexity (level) VALUES
	('Beginner'),
	('Intermediate'),
	('Advanced');

SELECT * FROM presentation;

--rename a column
sp_rename 'complexity.level', 'complexityLevel', 'COLUMN';

DROP TABLE presentation;

DROP DATABASE sqlSaturday;	

*/