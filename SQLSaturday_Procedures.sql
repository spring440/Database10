--Adds presenter to personRole
CREATE PROC addToPersonRole
            @personID INT
           
AS
BEGIN
	INSERT INTO personRole(personID, roleID)
    SELECT *
    FROM (VALUES 
			(@personID, 1))AS myTable(a,b);
END
/*---------------------------------------------------*/
--Adds presenter to personRole AND person
CREATE PROC addPersonPresenter
            @fName VARCHAR(40),
            @lName VARCHAR(40),
            @email VARCHAR(100)= NULL
           
AS
BEGIN
	DECLARE
        @recordNum INT,
        @emptyEmail VARCHAR(100);
--Adding to person
    IF @email IS NULL               
        BEGIN                        
            SET @emptyEmail = @fName + @lName + '@' +GETDATE() + '.error'
            INSERT INTO dbo.person(firstName, lastName, email)
            SELECT *
            FROM (VALUES	
					(@fName, @lName, @emptyEmail)) AS myTable(a,b,c)
        END
    ELSE
        BEGIN
            INSERT INTO person(firstName, lastName, email)
            SELECT *
            FROM (VALUES
				(@fName, @lName, @email)) AS myTable(a,b,c)
        END
    SET @recordNum = @@IDentity;
	EXEC addToPersonRole @recordNum;    
           
END;
/*-----------------------------------------------------------*/
--procedure to insert presentation
CREATE PROC insertPresentation
	@speaker VARCHAR(80),
	@presentationTitle VARCHAR(100),
	@email VARCHAR(100)= NULL

AS
DECLARE
@fName VARCHAR(40),
@lName VARCHAR(40),
@myRowNum INT

BEGIN TRY
	IF (SELECT count(*) FROM splitstring(@speaker)) >1
		BEGIN
			SET @fName = (SELECT name FROM splitstring(@speaker) WHERE nameID=1);		
			SET @lName = (SELECT name FROM splitstring(@speaker) WHERE nameID=2);
		
			IF NOT EXISTS ( SELECT *
								FROM personRole 
								WHERE (SELECT personID 
										FROM person 
										WHERE firstName=@fName AND lastName=@lName)=personID AND 1=roleID )
				BEGIN 
					set @myRowNum = (SELECT personID FROM person WHERE firstName=@fName AND lastName=@lName);
					IF @myRowNum IS NULL
						exec addPersonPresenter @fName, @lName, @email;
					ELSE
						exec addToPersonRole @myRowNum;
				END;
			INSERT INTO presentation(topicName, personID)
				SELECT *
				FROM ( 
					VALUES (@presentationTitle,101)) AS tbl (a,b);
		END;
	ELSE
		PRINT 'Error speaker must be in ''firstName lastName'' format with a space between';
END Try
BEGIN CATCH
	PRINT 'Unable to append records.';
	PRINT 'ERROR ' + CONVERT(VARCHAR, ERROR_NUMBER(),1) + ': ' + ERROR_MESSAGE();
END CATCH;


/*---------------Presentation per track in Budapest------------------------*/
CREATE PROC getPresPerTrackBudapest

AS

SELECT trackName,topicName,city
FROM presentation JOIN (events JOIN venue ON events.venueID = venue.venueID)
		  ON presentation.eventID = events.eventID
		  JOIN track ON presentation.trackID=track.trackID
WHERE city='Budapest'
ORDER BY trackName;

/*---------------getPresentations------------------------*/
CREATE PROC getPresentationsBySpeakers

AS

SELECT firstName + ' ' + lastName as fullName,topicName
FROM presentation join person ON presentation.personID=person.personID join 
(select personID from personRole 
 where personRole.roleID=1)as pr on person.personID=pr.personID
ORDER BY fullName

/*---------------getPresentationsForASpeaker------------------------*/
CREATE PROC getPresentationsForASpeaker
			@name VARCHAR(80)

AS
SELECT (firstName + ' ' + lastName) AS fullName,topicName
FROM presentation join person ON presentation.personID=person.personID join 
	(SELECT personID FROM personRole 
	WHERE personRole.roleID=1)AS pr on person.personID=pr.personID
	WHERE (firstName + ' ' + lastName)=@name

/*---------------TESTS------------------------*/
EXEC insertPresentation 'mytest','Presentation 1'
EXEC insertPresentation 'Steve Simon','Presentation 1'
EXEC insertPresentation 'Cheryl Huber','Cheryl''s rad presentation'
EXEC insertPresentation 'Cassie Huber','Cassie BI lecture','cass@gmail.com'
EXEC getPresPerTrackBudapest;
EXEC getPresentationsBySpeakers;
SELECT * FROM splitstring('MY TEST')
exec getPresentationsForASpeaker 'Allan Hirt'

/*---------------DROPS------------------------*/
DROP PROC insertPresentation
DROP PROC addPersonPresenter
DROP PROC addToPersonRole
DROP PROC getPresentationsBySpeakers
DROP PROC getPresentationsForASpeaker
DROP FUNCTION DBO.splitstring

/*STRING TOKENIZER*/

CREATE FUNCTION dbo.splitstring ( @stringToSplit VARCHAR(MAX) )
RETURNS
 @returnList TABLE (nameID INT IDENTITY, [Name] [nvarchar] (500))
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(' ', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(' ', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END