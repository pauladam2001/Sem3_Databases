CREATE TABLE Team
	(TeamID INT IDENTITY(1,1) PRIMARY KEY,
	TeamName VARCHAR(40),
	TeamLocation VARCHAR(40),
	YearOfAppearance INTEGER CHECK (YearOfAppearance >= 1930 AND YearOfAppearance <= 2021))

CREATE TABLE Coach
	(CoachID INT IDENTITY(1,1) PRIMARY KEY,
	CoachName VARCHAR(40),
	CoachSalary INT,
	CoachExperience INT CHECK (CoachExperience >=0 AND CoachExperience <= 60),
	TeamID INT FOREIGN KEY REFERENCES Team(TeamID) UNIQUE)		-- not unique anymore in order to test the table

ALTER TABLE Coach
DROP INDEX TeamID

CREATE TABLE Company
	(CompanyName VARCHAR(40) PRIMARY KEY,
	NrOfEmployees INT,
	MarketPower INTEGER CHECK (MarketPower >= 0 AND MarketPower <= 10))

CREATE TABLE Team_Company
	(TeamID INT REFERENCES Team(TeamID),	-- not referencing Team(TeamID) anymore in order to test the table
	CompanyName VARCHAR(40) REFERENCES Company(CompanyName),	-- not referencing Company(CompanyName) anymore in order to test the table
	SponsoredWith VARCHAR(40),
	PRIMARY KEY(TeamID, CompanyName))

CREATE TABLE Rules
	(RuleID INT IDENTITY(1,1) PRIMARY KEY,
	RuleStatement VARCHAR(100),
	Penalty VARCHAR(50))

CREATE TABLE Team_Rules
	(TeamID INT REFERENCES Team(TeamID),
	RuleID INT REFERENCES Rules(RuleID),
	PRIMARY KEY(TeamID, RuleID))

CREATE TABLE Team_Plays_Team
	(TeamID1 INT REFERENCES Team(TeamID),
	TeamID2 INT REFERENCES Team(TeamID),
	GameDate DATE,
	GameHour TIME,
	PRIMARY KEY(TeamID1, TeamID2), CHECK (TeamID1 <> TeamID2))

CREATE TABLE Agent
	(AgentID INT IDENTITY(1,1) PRIMARY KEY,
	AgentExperience INT CHECK (AgentExperience >=0 AND AgentExperience <= 60),
	AgentAge INTEGER)

CREATE TABLE BasketballPlayer
	(PlayerID INT IDENTITY(1,1) PRIMARY KEY,
	PlayerName VARCHAR(50) DEFAULT 'UNKNOWN',
	PlayerExperience INT CHECK (PlayerExperience >=0 AND PlayerExperience <= 21),
	TeamID INT REFERENCES Team(TeamID) ON DELETE SET NULL,
	AgentID INT REFERENCES Agent(AgentID) ON DELETE SET NULL)	-- not a foreign key anymore in order to test the tables

CREATE TABLE Equipment
	(Number INTEGER PRIMARY KEY,
	Size VARCHAR(3) CHECK (Size = 'S' OR Size = 'M' OR Size = 'L' OR Size = 'XL' OR Size = 'XXL'),
	Brand VARCHAR(20),
	PlayerID INT FOREIGN KEY REFERENCES BasketballPlayer(PlayerID) UNIQUE)

USE BasketballLeagueDB
GO
ALTER TABLE Team_Plays_Team
ADD WinningTeam INT

SELECT * FROM Team_Plays_Team

UPDATE Team_Plays_Team
SET WinningTeam = 4
WHERE TeamID1 = 4 AND TeamID2 = 5