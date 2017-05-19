
INSERT INTO dbo.complexity (complexityLevel) VALUES
	('Beginner'),
	('Intermediate'),
	('Advanced'),
	('Non-Technical');

INSERT INTO dbo.roleTable(roleName) VALUES
	('Presenter'),
	('Attendee'),
	('Organizer'),
	('Volunteer'),
	('Sponsor');

INSERT INTO dbo.region(regionName) VALUES
	('Asia Pacific'),
	('Canada/US'),
	('Europe/Middle East/Africa'),
	('Latin America');

INSERT INTO dbo.sponsorLevel(sponsorLevel) VALUES
	('Platinum Sponsor'),
	('Gold Sponsor'),
	('Silver Sponsor'),
	('Bronze Sponsor');
		
INSERT INTO dbo.grade(grade) VALUES
	('A'),
	('B'),
	('C'),
	('D'),
	('F');

INSERT INTO dbo.track(trackName) VALUES
	('Advanced Analysis Techniques'),
	('Application & Database Development'),
	('BI Information Delivery'),
	('BI Platform Architecture, Development & Administration'),
	('Cloud Application Development & Deployment'),
	('Enterprise Database Administration & Deployment'),
	('Professional Development'),
	('Strategy and Architecture'),
	('Other');
	
INSERT INTO dbo.country(code2Char, code3Char, code3Num, countryName) 
SELECT [ISO ALPHA-2 Code], [ISO ALPHA-3 Code], 
		[ISO Numeric Code UN M49 Numerical Code],
		[Country or Area Name]
FROM excelCountry;


INSERT INTO dbo.venue (street,street2,city,subdivisionOrState,postalCode,countryID,regionID)
SELECT street,street2,city,subdivisionorstate,postalcode,countryid,regionID
FROM dbo.excelVenue

INSERT INTO DBO.events(eventName,eventNumber,eventDate,venueID ,regionID)
SELECT Title,EventNum,Date2, venueID, RegionID
FROM excelEvent

--adding to personRole from person table and imported test data
INSERT INTO dbo.personRole (personID,roleID)
SELECT personID,roleID
FROM dbo.excelPerson JOIN dbo.person ON excelPerson.lName = person.lastName 
AND excelPerson.FName = person.firstName

--adding to personRole from person table and imported excelPresenterLookup
INSERT INTO dbo.personRole (personID,roleID)
SELECT personID, 1 as presenterRole
FROM dbo.excelPresenterLookup 

--Adding sponsor
INSERT INTO dbo.sponsor(sponsorName,sponsorLevelID,gapSponsor)
SELECT sponsorName,sponsorLevelID,gapSponsor
FROM excelSponsor
		

--Adding room
INSERT INTO dbo.room(roomName,capacity,venueID)
SELECT roomName,capacity,venueID
FROM excelRoom


--Adding giftRaffle
UPDATE excelGiftRaffle
SET sponsor=1
WHERE sponsor=16

INSERT INTO dbo.giftRaffle(email,sponsorID)
SELECT email,sponsor
FROM excelGiftRaffle

--Adding presentations
INSERT INTO dbo.presentation(topicName,durationMinutes,complexityID,personID,
			trackID,eventID,gradeID)
SELECT title,60 as duration,levelID,personID,trackID,eventID,gradeID 
FROM excelPresentations


--adding schedule
INSERT INTO dbo.schedule(roomID,presentationID,classTime)
SELECT  roomID,presentationID,classTime
FROM EXCELSCHEDULE


/*----------------------------
	correction for excelPerson and excelPresenations
*/

DELETE excelPerson;
ALTER TABLE excelPerson
ALTER COLUMN [postal code]  VARCHAR(16);

ALTER TABLE track
ALTER COLUMN trackName VARCHAR(60);
DROP TABLE dbo.schedule
DROP TABLE dbo.presentation;
DROP TABLE dbo.track
select * from presentation

DELETE excelPresentations;
ALTER TABLE excelPresentations
ALTER COLUMN [personID]  INT;
select  * from excelpresentations

ALTER TABLE excelSchedule
ALTER COLUMN classTime time;
/*----------------------------
	End of correction for excelPerson
*/

--There was an error because there were duplicate emails with ajones@gmail.com,
--KBaker@gmail.com,ARamirez@yahoo.com
BEGIN TRY
	INSERT INTO person(firstName,lastName,email,streetAddress,streetAddress2,city,
				subdivisionOrState,postalCode,countryID)
	SELECT fName,lName,email,StreetAddress,StreetAddress2,City,excelPerson.State,
			[postal code],countryCode
	FROM excelPerson
END TRY
BEGIN CATCH
	PRINT 'Unable to append records.';
	PRINT 'ERROR ' + CONVERT(VARCHAR, ERROR_NUMBER(),1) + ': ' + ERROR_MESSAGE();
END CATCH;

--correction for bad emails
INSERT INTO person(firstName,lastName,email,streetAddress,streetAddress2,city,
				subdivisionOrState,postalCode,countryID)
SELECT fName,lName,IIF(EMAIL='ajones@gmail.com' or EMAIL='KBaker@gmail.com' or 
						EMAIL='ARamirez@yahoo.com',fName+lName+'@email_error.com',email) AS email,
		StreetAddress,StreetAddress2,City,excelPerson.State,
			[postal code],countryCode
FROM excelPerson;
select * FROM person
INSERT INTO person(firstName,lastName,email)
SELECT firstName,lastName,firstName + lastName + '@sponsor_email_error.com' AS email
FROM excelPresenterLookup



/*
INSERT INTO presentation(topicName,complexityID,
SELECT 
FROM excelPresentation

INSERT INTO 
SELECT
FROM excelPresenterLookup

INSERT INTO 
SELECT
FROM excelSponsor


SELECT * FROM complexity;
SELECT * FROM country;
SELECT * FROM events;
SELECT * FROM excelCountry;
SELECT * FROM excelEvent;
SELECT * FROM excelGiftRaffle;
SELECT * FROM excelPerson;
SELECT * FROM excelPresentation;
SELECT * FROM excelPresenterLookup;
SELECT * FROM excelRoom;
SELECT * FROM excelSchedule;
SELECT * FROM excelSponsor;
SELECT * FROM excelVenue;
SELECT * FROM giftRaffle;
SELECT * FROM grade;
SELECT * FROM person;
SELECT * FROM personRole;
SELECT * FROM presentation;
SELECT * FROM region;
SELECT * FROM roleTable;
SELECT * FROM room;
SELECT * FROM schedule;
SELECT * FROM sponsor;
SELECT * FROM sponsorLevel;
SELECT * FROM track;
SELECT * FROM venue;

*/