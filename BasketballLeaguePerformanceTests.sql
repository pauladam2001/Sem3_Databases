if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunTables_Tables]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestRunTables] DROP CONSTRAINT FK_TestRunTables_Tables
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestTables_Tables]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestTables] DROP CONSTRAINT FK_TestTables_Tables
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunTables_TestRuns]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestRunTables] DROP CONSTRAINT FK_TestRunTables_TestRuns
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunViews_TestRuns]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestRunViews] DROP CONSTRAINT FK_TestRunViews_TestRuns
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestTables_Tests]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestTables] DROP CONSTRAINT FK_TestTables_Tests
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestViews_Tests]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestViews] DROP CONSTRAINT FK_TestViews_Tests
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestRunViews_Views]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestRunViews] DROP CONSTRAINT FK_TestRunViews_Views
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[FK_TestViews_Views]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [TestViews] DROP CONSTRAINT FK_TestViews_Views
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Tables]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Tables]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TestRunTables]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [TestRunTables]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TestRunViews]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [TestRunViews]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TestRuns]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [TestRuns]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TestTables]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)

drop table [TestTables]

GO

if exists (select * from dbo.sysobjects where id = object_id(N'[TestViews]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [TestViews]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Tests]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Tests]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[Views]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Views]
GO


CREATE TABLE [Tables] (
	[TableID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	)  ON [PRIMARY]
GO

CREATE TABLE [TestRunTables] (
	[TestRunID] [int] NOT NULL ,
	[TableID] [int] NOT NULL ,
	[StartAt] [datetime] NOT NULL ,
	[EndAt] [datetime] NOT NULL 
	)  ON [PRIMARY]
GO

CREATE TABLE [TestRunViews] (
	[TestRunID] [int] NOT NULL ,
	[ViewID] [int] NOT NULL ,
	[StartAt] [datetime] NOT NULL ,
	[EndAt] [datetime] NOT NULL 
	)  ON [PRIMARY]
GO

CREATE TABLE [TestRuns] (
	[TestRunID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[StartAt] [datetime] NULL ,
	[EndAt] [datetime] NULL 
	)  ON [PRIMARY]
GO

CREATE TABLE [TestTables] (
	[TestID] [int] NOT NULL ,
	[TableID] [int] NOT NULL ,
	[NoOfRows] [int] NOT NULL ,
	[Position] [int] NOT NULL 
	)  ON [PRIMARY]
GO

CREATE TABLE [TestViews] (
	[TestID] [int] NOT NULL ,
	[ViewID] [int] NOT NULL 
	)  ON [PRIMARY]
GO

CREATE TABLE [Tests] (
	[TestID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	)  ON [PRIMARY]
GO

CREATE TABLE [Views] (
	[ViewID] [int] IDENTITY (1, 1) NOT NULL ,
	[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
	)  ON [PRIMARY]
GO

ALTER TABLE [Tables] WITH NOCHECK ADD 
	CONSTRAINT [PK_Tables] PRIMARY KEY  CLUSTERED 
	(
		[TableID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestRunTables] WITH NOCHECK ADD 
	CONSTRAINT [PK_TestRunTables] PRIMARY KEY  CLUSTERED 
	(
		[TestRunID],
		[TableID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestRunViews] WITH NOCHECK ADD 
	CONSTRAINT [PK_TestRunViews] PRIMARY KEY  CLUSTERED 
	(
		[TestRunID],
		[ViewID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestRuns] WITH NOCHECK ADD 
	CONSTRAINT [PK_TestRuns] PRIMARY KEY  CLUSTERED 
	(
		[TestRunID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestTables] WITH NOCHECK ADD 
	CONSTRAINT [PK_TestTables] PRIMARY KEY  CLUSTERED 
	(
		[TestID],
		[TableID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestViews] WITH NOCHECK ADD 
	CONSTRAINT [PK_TestViews] PRIMARY KEY  CLUSTERED 
	(
		[TestID],
		[ViewID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [Tests] WITH NOCHECK ADD 
	CONSTRAINT [PK_Tests] PRIMARY KEY  CLUSTERED 
	(
		[TestID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [Views] WITH NOCHECK ADD 
	CONSTRAINT [PK_Views] PRIMARY KEY  CLUSTERED 
	(
		[ViewID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [TestRunTables] ADD 
	CONSTRAINT [FK_TestRunTables_Tables] FOREIGN KEY 
	(
		[TableID]
	) REFERENCES [Tables] (
		[TableID]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_TestRunTables_TestRuns] FOREIGN KEY 
	(
		[TestRunID]
	) REFERENCES [TestRuns] (
		[TestRunID]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

ALTER TABLE [TestRunViews] ADD 
	CONSTRAINT [FK_TestRunViews_TestRuns] FOREIGN KEY 
	(
		[TestRunID]
	) REFERENCES [TestRuns] (
		[TestRunID]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_TestRunViews_Views] FOREIGN KEY 
	(
		[ViewID]
	) REFERENCES [Views] (
		[ViewID]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

ALTER TABLE [TestTables] ADD 
	CONSTRAINT [FK_TestTables_Tables] FOREIGN KEY 
	(
		[TableID]
	) REFERENCES [Tables] (
		[TableID]
	) ON DELETE CASCADE  ON UPDATE CASCADE ,
	CONSTRAINT [FK_TestTables_Tests] FOREIGN KEY 
	(
		[TestID]
	) REFERENCES [Tests] (
		[TestID]
	) ON DELETE CASCADE  ON UPDATE CASCADE 
GO

ALTER TABLE [TestViews] ADD 
	CONSTRAINT [FK_TestViews_Tests] FOREIGN KEY 
	(
		[TestID]
	) REFERENCES [Tests] (
		[TestID]
	),
	CONSTRAINT [FK_TestViews_Views] FOREIGN KEY 
	(
		[ViewID]
	) REFERENCES [Views] (
		[ViewID]
	)
GO


-- Table with a single-column primary key and no foreign keys: Agent
-- Table with a single-column primary key and at least one foreign key: Coach
-- Table with a multicolumn primary key: Team_Company


-- view with a SELECT statement operating on one table
CREATE OR ALTER VIEW ViewOnOneTable
AS
	SELECT BP.PlayerName
	FROM BasketballPlayer BP
	WHERE BP.PlayerExperience = 5
GO

-- SELECT * FROM ViewOnOneTable

-- view with a SELECT statement operating on at least 2 tables
CREATE OR ALTER VIEW ViewOnMinTwoTables
AS
	SELECT T.TeamName, T.TeamLocation, BP.PlayerName, E.Number
	FROM Team T
	INNER JOIN BasketballPlayer BP								-- find all players playing in all teams and their equipment number
	ON T.TeamID = BP.TeamID
		INNER JOIN  Equipment E
		ON BP.PlayerID = E.PlayerID
GO

-- SELECT * FROM ViewOnMinTwoTables

-- view with a SELECT statement that has GROUP BY clause and operates on at least 2 tables
CREATE OR ALTER VIEW ViewWithGroupBy
AS
	SELECT C.CoachExperience, MAX(C.CoachSalary) AS MaxCoachSalary
	FROM Coach C														-- find the maximum salary of coaches who have a salary > 1000 for each experience with
	WHERE C.CoachSalary > 1000											-- at least 1 entry
	GROUP BY C.CoachExperience
	HAVING 1 <= (SELECT COUNT(*)
				FROM Coach C2
				WHERE C2.CoachExperience = C.CoachExperience)
GO

-- SELECT * FROM ViewWithGroupBy


-- populating the tables
INSERT INTO Tables
VALUES ('Agent'),
	   ('Coach'),
	   ('Team_Company')

-- SELECT * FROM Tables

INSERT INTO Views
VALUES ('ViewOnOneTable'),
	   ('ViewOnMinTwoTables'),
	   ('ViewWithGroupBy')

-- SELECT * FROM Views

INSERT INTO Tests
VALUES ('test1'),	-- 5 rows
	   ('test2'),	-- 15 rows
	   ('test3'),	-- 150 rows
	   ('test4')	-- 1500 rows

INSERT INTO Tests
VALUES ('test5')

-- SELECT * FROM Tests

INSERT INTO TestTables
VALUES (1, 1005, 5, 1),
	   (1, 1006, 5, 2),		-- Position = dictates the order in which the tables of the test are deleted and the reverse order of insertion
	   (1, 1007, 5, 3),		-- NoOfRows = the number of records to insert
	   (2, 1005, 15, 2),
	   (2, 1006, 15, 3),
	   (2, 1007, 15, 1),
	   (3, 1005, 150, 3),
	   (3, 1006, 150, 1),
	   (3, 1007, 150, 2),
	   (4, 1005, 1500, 1),
	   (4, 1006, 1500, 3),
	   (4, 1007, 1500, 2)

INSERT INTO TestTables
VALUES (1002, 1005, 5000, 2),
	   (1002, 1006, 5000, 1),
	   (1002, 1007, 5000, 3)

-- SELECT * FROM TestTables

INSERT INTO TestViews
VALUES (1, 1),
	   (1, 2),
	   (1, 3),
	   (2, 1),
	   (2, 2),
	   (2, 3),
	   (3, 1),
	   (3, 2),
	   (3, 3),
	   (4, 1),
	   (4, 2),
	   (4, 3)

INSERT INTO TestViews
VALUES (1002, 1),
	   (1002, 2),
	   (1002, 3)

-- SELECT * FROM TestViews


GO
CREATE OR ALTER PROCEDURE uspDeleteDataFromTable (@table VARCHAR(30))
AS
BEGIN
	IF EXISTS (SELECT * FROM BasketballLeagueDB.sys.tables WHERE tables.name IN ('Agent', 'Coach', 'Team_Company') AND tables.name = @table)
	BEGIN
		DECLARE @execDelete NVARCHAR(100)				-- we need this variable in order to execute the delete dynamically
		SET @execDelete = N'DELETE FROM ' + @table
		EXECUTE sp_executesql @execDelete
	END
	ELSE
	BEGIN
		RAISERROR('Introduce a valid table name!', 17, 1)
		RETURN
	END
END

-- EXEC uspDeleteDataFromTable 'Coach'

GO
CREATE OR ALTER PROCEDURE uspEvaluateView (@view VARCHAR(30))
AS
BEGIN
	IF EXISTS (SELECT * FROM BasketballLeagueDB.sys.views WHERE views.name = @view)
	BEGIN
		DECLARE @execView NVARCHAR(100)					-- we need this variable in order to execute the view dynamically with sp_executesql
		SET @execView = N'SELECT * FROM ' + @view
		EXECUTE sp_executesql @execView
	END
	ELSE
	BEGIN
		RAISERROR('Introduce a valid view name!', 17, 1)
		RETURN
	END
END

-- EXEC uspEvaluateView 'ViewOnOneTable'

GO
CREATE OR ALTER PROCEDURE uspInsertDataInTable (@tableName VARCHAR(30), @nrOfRows INT)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM BasketballLeagueDB.sys.tables WHERE tables.name IN ('Agent', 'Coach', 'Team_Company') AND tables.name = @tableName)
	BEGIN
		RAISERROR('Introduce a valid view name!', 17, 1)
		RETURN
	END

	SELECT
		tables.name AS TableName,
		columns.name AS ColumnName,
		columns.max_length AS ColumnLength,
		types.name AS TypeName
	FROM BasketballLeagueDB.sys.tables
	INNER JOIN BasketballLeagueDB.sys.columns
	ON tables.object_id = columns.object_id
	INNER JOIN BasketballLeagueDB.sys.types
	ON types.user_type_id = columns.user_type_id
	WHERE tables.name = @tableName
END

-- EXEC uspInsertDataInTable @tableName = 'Coach', @nrOfRows = 50

GO
CREATE OR ALTER PROCEDURE uspInsertDataInTableNotDynamically (@tableName VARCHAR(30), @nrOfRows INT)
AS
BEGIN
	IF @tableName = 'Coach'
	BEGIN
		DECLARE @CoachName VARCHAR(40)
		DECLARE @CoachSalary INT
		DECLARE @CoachExperience INT
		DECLARE @TeamID INT

		WHILE @nrOfRows > 0
		BEGIN
			SET @CoachName = CONVERT(VARCHAR(40), NEWID())
			SET @CoachSalary = ABS(CHECKSUM(NEWID())) % 15000
			SET @CoachExperience = ABS(CHECKSUM(NEWID())) % 35
			SET @TeamID = (SELECT TOP 1 TeamID1 FROM Team_Plays_Team ORDER BY TeamID1 DESC)		-- foreign key

			INSERT INTO Coach
			VALUES (@CoachName, @CoachSalary, @CoachExperience, @TeamID)

			SET @nrOfRows = @nrOfRows - 1
		END
	END
	ELSE IF @tableName = 'Agent'
	BEGIN
		DECLARE @AgentExperience INT
		DECLARE @AgentAge INT
		DECLARE @AgentName VARCHAR(50)

		WHILE @nrOfRows > 0
		BEGIN
			SET @AgentExperience = ABS(CHECKSUM(NEWID())) % 35
			SET @AgentAge = ABS(CHECKSUM(NEWID())) % 35 + 20
			SET @AgentName = CONVERT(VARCHAR(50), NEWID())

			INSERT INTO Agent
			VALUES (@AgentExperience, @AgentAge, @AgentName)
			
			SET @nrOfRows = @nrOfRows - 1 
		END
	END
	ELSE IF @tableName = 'Team_Company'
	BEGIN
		DECLARE @teamIDD INT
		DECLARE @CompanyName VARCHAR(40)
		DECLARE @SponsoredWith VARCHAR(40)

		WHILE @nrOfRows > 0
		BEGIN
			-- SET @teamIDD = (SELECT TOP 1 TeamID1 FROM Team_Plays_Team)
			-- SET @CompanyName = (SELECT TOP 1 CompanyName FROM Company)
			SET @teamIDD = ABS(CHECKSUM(NEWID())) % 4000
			SET @CompanyName = CONVERT(VARCHAR(40), NEWID())
			SET @SponsoredWith = CONVERT(VARCHAR(40), NEWID())

			INSERT INTO Team_Company
			VALUES (@teamIDD, @CompanyName, @SponsoredWith)

			SET @nrOfRows = @nrOfRows - 1
		END
	END
	ELSE
	BEGIN
		RAISERROR('Introduce a valid view name!', 17, 1)
		RETURN
	END
END

-- EXEC uspInsertDataInTableNotDynamically @tableName = 'Team_Company', @nrOfRows = 0
-- SELECT * FROM Agent
-- SELECT * FROM Coach
-- SELECT * FROM Team_Company

GO
CREATE OR ALTER PROCEDURE uspTestsMain (@testID INT)
AS
BEGIN
	DECLARE @testRunID INT
	DECLARE @viewID INT
	DECLARE @viewName VARCHAR(30)
	DECLARE @tableID INT
	DECLARE @tableName VARCHAR(30)
	DECLARE @startTime DATETIME
	DECLARE @endTime DATETIME
	DECLARE @nrOfRows INT

	INSERT INTO TestRuns VALUES ((SELECT T.Name 
								  FROM Tests T 
								  WHERE T.TestID = @testID),
								  GETDATE(),
								  GETDATE())
	SET @testRunID = (SELECT MAX(T.TestRunID) FROM TestRuns T)

	PRINT 'TestRuns passed'

	DECLARE deleteCursor CURSOR FOR
		SELECT TableID
		FROM TestTables
		WHERE TestID = @testID
		ORDER BY Position ASC

	OPEN deleteCursor

	FETCH NEXT
		FROM deleteCursor
		INTO @tableID

	PRINT 'deleteCursor'

	WHILE @@FETCH_STATUS = 0
	BEGIN	
		SET @tableName = (SELECT Name FROM Tables WHERE TableID = @tableID)
		EXEC uspDeleteDataFromTable @tableName
		FETCH NEXT
			FROM deleteCursor
			INTO @tableID
		PRINT 'Fetched next deleteCursor'
	END

	CLOSE deleteCursor
	DEALLOCATE deleteCursor

	DECLARE insertCursor CURSOR FOR
		SELECT TableID, NoOfRows
		FROM TestTables
		WHERE TestID = @testID
		ORDER BY Position DESC

	OPEN insertCursor

	FETCH NEXT
		FROM insertCursor
		INTO @tableID, @nrOfRows

	PRINT 'insertCursor'

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @tableName = (SELECT Name from Tables WHERE TableID = @tableID)
		SET @startTime = GETDATE()
		EXEC uspInsertDataInTableNotDynamically @tableName, @nrOfRows
		SET @endTime = GETDATE()
		INSERT INTO TestRunTables VALUES (@testRunID, @tableID, @startTime, @endTime)
		FETCH NEXT
			FROM insertCursor
			INTO @tableID, @nrOfRows
		PRINT 'Fetched next insertCursor'
	END

	CLOSE insertCursor
	DEALLOCATE insertCursor

	DECLARE viewsCursor CURSOR FOR
		SELECT ViewID
		FROM TestViews
		WHERE TestID = @testID

	OPEN viewsCursor

	FETCH NEXT
		FROM viewsCursor
		INTO @viewID

	PRINT 'viewsCursor'

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @viewName = (SELECT Name FROM Views WHERE ViewID = @viewID)
		SET @startTime = GETDATE()
		EXEC uspEvaluateView @viewName
		SET @endTime = GETDATE()
		INSERT INTO TestRunViews VALUES (@testRunID, @viewID, @startTime, @endTime)
		FETCH NEXT
			FROM viewsCursor
			INTO @viewID
		PRINT 'Fetched next viewsCursor'
	END

	CLOSE viewsCursor
	DEALLOCATE viewsCursor

	UPDATE TestRuns
		SET EndAt = GETDATE()
		WHERE TestRunID = @testRunID

	PRINT 'Updated TestRuns'
END

-- EXEC uspTestsMain 1002			-- for 5000 rows -> 1002
-- SELECT * FROM TestRuns
-- SELECT * FROM TestRunTables
-- SELECT * FROM TestRunViews

-- SELECT * FROM Agent
-- SELECT * FROM Coach
-- SELECT * FROM Team_Company

-- DELETE FROM TestRuns
-- DELETE FROM TestRunTables
-- DELETE FROM TestRunViews