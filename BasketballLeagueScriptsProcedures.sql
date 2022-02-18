USE BasketballLeagueDB
GO


-- a. modify the type of column

CREATE OR ALTER PROC uspChangeRulePenalty
AS
BEGIN
	ALTER TABLE Rules
	ALTER COLUMN Penalty CHAR(50)
END
GO

-- a. undo

CREATE OR ALTER PROC UNDOuspChangeRulePenalty
AS
BEGIN
	ALTER TABLE Rules
	ALTER COLUMN Penalty VARCHAR(50)
END
GO


-- b. add/remove a column

CREATE OR ALTER PROC uspRemoveCompanyNrOfEmployees
AS
BEGIN
	ALTER TABLE Company
	DROP COLUMN NrOfEmployees
END
GO

-- b. undo

CREATE OR ALTER PROC UNDOuspRemoveCompanyNrOfEmployees
AS
BEGIN
	ALTER TABLE Company
	ADD NrOfEmployees INT
END
GO

-- c. add/remove a DEFAULT constraint

CREATE OR ALTER PROC uspAddDefaultConstraintCoachExperience
AS
BEGIN
	ALTER TABLE Coach
	ADD CONSTRAINT default_experience DEFAULT 0 FOR CoachExperience
END
GO

-- c. undo

CREATE OR ALTER PROC UNDOuspAddDefaultConstraintCoachExperience
AS
BEGIN
	ALTER TABLE Coach
	DROP CONSTRAINT default_experience
END
GO

-- SELECT * FROM sys.default_constraints


-- d. add/remove a primary key

CREATE OR ALTER PROC uspRemovePrimayKeyCoachID
AS
BEGIN
	ALTER TABLE Coach
	DROP CONSTRAINT PK_CoachID
END
GO

-- d. undo

CREATE OR ALTER PROC UNDOuspRemovePrimayKeyCoachID
AS
BEGIN
	ALTER TABLE Coach
	ADD CONSTRAINT PK_CoachID PRIMARY KEY (CoachID)
END
GO

--SELECT name
--FROM sys.key_constraints
--WHERE type = 'PK'


-- e. add/remove a candidate key

CREATE OR ALTER PROC uspAddCanditateKeyAgentNameAge
AS
BEGIN
	ALTER TABLE Agent
	ADD CONSTRAINT UQ_NAME_AGE UNIQUE(AgentName, AgentAge)
END
GO

-- e. undo

CREATE OR ALTER PROC UNDOuspAddCanditateKeyAgentNameAge
AS
BEGIN
	ALTER TABLE Agent
	DROP CONSTRAINT UQ_NAME_AGE
END
GO


-- f. add/remove a foreign key

CREATE OR ALTER PROC uspRemoveForeignKeyBasketballPlayerAgent
AS
BEGIN
	ALTER TABLE BasketballPlayer
	DROP CONSTRAINT FK_Basketball_Agent
END
GO

--EXEC uspRemoveForeignKeyBasketballPlayerAgent

-- f. undo

CREATE OR ALTER PROC UNDOuspRemoveForeignKeyBasketballPlayerAgent
AS
BEGIN
	ALTER TABLE BasketballPlayer
	ADD CONSTRAINT FK_Basketball_Agent FOREIGN KEY (AgentID) REFERENCES Agent(AgentID)
END
GO

--EXEC sp_fkeys Agent


-- g. create/drop a table

CREATE OR ALTER PROC uspCreateTestTable
AS
BEGIN
	CREATE TABLE TestTable
	(testID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	testMessage VARCHAR(50),
	testResult BIT DEFAULT 1)
END
GO

-- g. undo

CREATE OR ALTER PROC UNDOuspCreateTestTable
AS
BEGIN
	DROP TABLE IF EXISTS TestTable
END
GO

-- create a table that holds the versions of the database schema (the version is an integer number)

CREATE TABLE PreviousVersions
	(storedProcedure VARCHAR(50),
	versionTo INT)
GO

INSERT INTO PreviousVersions(storedProcedure, versionTo)
VALUES ('uspChangeRulePenalty', 1),
	   ('uspRemoveCompanyNrOfEmployees', 2),
	   ('uspRemoveForeignKeyBasketballPlayerAgent', 3),
	   ('uspRemovePrimayKeyCoachID', 4),
	   ('uspCreateTestTable', 5),
	   ('uspAddDefaultConstraintCoachExperience', 6),
	   ('uspAddCanditateKeyAgentNameAge', 7)
	   
SELECT * FROM PreviousVersions


-- create a table that keeps only the current version (the version is an integer number)

CREATE TABLE CurrentVersion
	(currentVersion INT DEFAULT 0)

INSERT INTO CurrentVersion VALUES(0)

SELECT * FROM CurrentVersion


-- write a stored procedure that receives as a parameter a version number and brings the database to that version

GO
CREATE OR ALTER PROCEDURE modifyVersion (@version INT)
AS
BEGIN
	DECLARE @currentVersion INT
	DECLARE @currentProc NVARCHAR(50)
	SET @currentVersion = (SELECT currentVersion FROM CurrentVersion)			-- get the current version of the database
	DECLARE @numberOfVersions INT
	SELECT @numberOfVersions = COUNT(*) FROM PreviousVersions		-- get how many versions we have in order to display an error message
	DECLARE @ErrorMessage NVARCHAR(100)
	SET @ErrorMessage = N'Version number must be bigger than 0 and smaller or equal with ' + CAST(@numberOfVersions AS NVARCHAR(5))

	IF @version < 0 OR @version > @numberOfVersions			-- check if the parameter is ok
		BEGIN
			RAISERROR(@ErrorMessage, 17, 1)
			RETURN
		END
	ELSE
		IF @version = @currentVersion			-- check if the version parameter is the current version
			BEGIN
				PRINT 'Already on this version!'
				RETURN
			END
		ELSE
		IF @currentVersion < @version	-- if the version where we want to go is bigger than the current one
			BEGIN
				WHILE @currentVersion < @version
					BEGIN
						PRINT N'Now we are at version ' + CAST(@currentVersion AS NVARCHAR(5))

						DECLARE versionCursor CURSOR SCROLL FOR			-- declaring the cursor
							SELECT storedProcedure
							FROM PreviousVersions
							WHERE versionTo = @currentVersion + 1

						OPEN versionCursor							-- populate the cursor (the cursor is necessary if we have multiple procedures between 2 versions)
						PRINT 'verionCursor opened!'

						FETCH FIRST						-- returns the first row from the cursor
							FROM versionCursor
							INTO @currentProc
						PRINT 'Fetched first!'

						WHILE @@FETCH_STATUS = 0		-- a system function that returns the status of the last FETCH statement issued against any opened cursor
							BEGIN
								EXEC(@currentProc)										-- executing the procedure
								PRINT N'Procedure ' + @currentProc + ' executed!'
								
								FETCH NEXT			-- returns the row immediately following the current row
									FROM versionCursor
									INTO @currentProc
								PRINT 'Fetched next!'
							END

						CLOSE versionCursor				-- close the cursor and free the resources allocated
						DEALLOCATE versionCursor
						PRINT 'Closed versionCursor!'

						SET @currentVersion = @currentVersion + 1		-- increment the currentVersion of the database
					END
			END
		ELSE
		IF @currentVersion > @version				-- if the version where we want to go is smaller than the current one
			BEGIN
				DECLARE @undoProc NVARCHAR(100)

				WHILE @currentVersion > @version
					BEGIN
						PRINT N'Now we are at version ' + CAST(@currentVersion AS NVARCHAR(5))

						DECLARE undoVersionCursor CURSOR SCROLL FOR		-- declaring the cursor
							SELECT storedProcedure
							FROM PreviousVersions
							WHERE versionTo = @currentVersion

						OPEN undoVersionCursor					-- populate the cursor (the cursor is necessary if we have multiple procedures between 2 versions)
						PRINT 'undoVerionCursor opened!'

						FETCH LAST								-- returns the last row in the cursor
							FROM undoVersionCursor
							INTO @currentProc
						PRINT 'Fetched last!'

						WHILE @@FETCH_STATUS = 0			-- a system function that returns the status of the last FETCH statement issued against any opened cursor
							BEGIN
								SET @undoProc = 'UNDO' + @currentProc
								EXEC(@undoProc)												-- executing the undo procedure
								PRINT N'Undo procedure ' + @currentProc + ' executed!'

								FETCH PRIOR							-- returns the row before the current row
									FROM undoVersionCursor
									INTO @currentProc
								PRINT 'Fetched prior!'
							END

						CLOSE undoVersionCursor						-- close the cursor and free the resources allocated
						DEALLOCATE undoVersionCursor
						PRINT 'undoVersionCursor closed!'

						SET @currentVersion = @currentVersion - 1		-- decrement the currentVersion of the database
					END
			END

		UPDATE CurrentVersion
			SET currentVersion = @currentVersion			-- update the currentVersion of the database in the table also
		PRINT 'Current version updated!'
END

EXEC modifyVersion 1

SELECT * FROM TestTable