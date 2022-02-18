INSERT INTO Team (TeamName, TeamLocation, YearOfAppearance)
VALUES ('CSM Medias', 'Medias', 2018),
	   ('CSU Sibiu', 'Sibiu', 1999),
	   ('U BT Cluj-Napoca', 'Cluj-Napoca', 1970),
	   ('CSA Steaua Eximbank', 'Bucuresti', 2005),
	   ('CSM Galati', 'Galati', 2010)

--SELECT * FROM Team

INSERT INTO Agent (AgentExperience, AgentAge, AgentName)
VALUES (10, 40, 'Ionut Georgescu'),
	   (5, 27, 'Daniel Anica')

--SELECT * FROM Agent

INSERT INTO BasketballPlayer
VALUES ('Adam Paul', 3, 1, 1),
	   ('Sergiu Idu', 4, 1, 1),
	   ('Dragos Andrei', 5, 1, 1),
	   ('Ciprian Albu', 3, 2, 2),
	   ('Sergiu Pop', 2, 2, 2),
	   ('Amedeo Casale', 12, 2, 2),
	   ('Cezar Suciu', 10, 3, 1),
	   ('Paul Suciu', 9, 3, 1),
	   ('Alex Damian', 7, 3, 1),
	   ('Titus Nicoara', 17, 4, 2),
	   ('Andrei Mandache', 13, 4, 2),
	   ('Stefan Grasu', 12, 4, 2),
	   ('Tudor Lungu', 3, 5, 1),
	   ('Alexandru Unitu', 5, 5, 1),
	   ('Tudor Sacara', 6, 5, 1),
	   ('Radu Radulescu', 1, 1, 2),
	   ('Radu Vrincian', 2, 2, 2),
	   ('Dominic Csender', 0, 3, 2),
	   ('Vlad Corpodean', 18, 4, 1),
	   ('Mihai Maciuca', 4, 5, 1)

--SELECT * FROM BasketballPlayer

INSERT INTO Equipment (Number, Size, Brand, PlayerID)
VALUES (55, 'S', 'Adidas', 1),
	   (35, 'S', 'Adidas', 2),
	   (23, 'L', 'Adidas', 3),
	   (24, 'L', 'Puma', 4),
	   (1, 'M', 'Puma', 5),
	   (2, 'XL', 'Puma', 6),
	   (7, 'XL', 'Puma', 7),
	   (9, 'XXL', 'Nike', 8),
	   (12, 'M', 'Nike', 9),
	   (41, 'S', 'Nike', 10),
	   (51, 'M', 'Nike', 11),
	   (14, 'M', 'Nike', 12),
	   (6, 'L', 'Nike', 13),
	   (3, 'S', 'Adidas', 14),
	   (69, 'XL', 'Nike', 15),
	   (92, 'L', 'Adidas', 16),
	   (0, 'XXL', 'Nike', 17),
	   (8, 'XXL', 'Adidas', 18),
	   (22, 'M', 'Nike', 19),
	   (27, 'L', 'Adidas', 20)

--SELECT * FROM Equipment

INSERT INTO Coach (CoachName, CoachSalary, CoachExperience, TeamID)
VALUES ('Mihai Popa', 4000, 3, 1),
	   ('Eugen Ilie', 4500, 7, 2),
	   ('Bruno Soce', 11000, 25, 3),
	   ('Mihai Silvasan', 7500, 5, 4),
	   ('Florin Nini', 6400, 10, 5)
	   --('Hristu Sapera', 4000, 3, 6),
	   --('Tudor Costescu', 4000, 3, 7),
	   --('Dan Fleseriu', 4000, 3, 8),
	   --('Cosmin Ploscar', 4000, 3, 9),
	   --('Dan Popa', 4000, 3, 10),
	   --('Sandu Rubint', 4000, 3, 11),
	   --('Alex Covacs', 4000, 3, 12),
	   --('Mircea Totolici', 4000, 3, 13),
	   --('Bogdan Pintea', 4000, 3, 14),
	   --('Mihai Racovitan', 4000, 3, 15),
	   --('Tudor Dumitrescu', 4000, 3, 16),
	   --('Cristian Achim', 4000, 3, 17),
	   --('', 4000, 3, 18),
	   --('', 4000, 3, 19),
	   --('', 4000, 3, 20)

--SELECT * FROM Coach

INSERT INTO Company (CompanyName, NrOfEmployees, MarketPower)
VALUES ('Endava', 1000, 6),
	   ('NTT Data', 1500, 8),
	   ('Baum Bet', 500, 3),
	   ('Trasngaz', 3000, 8),
	   ('Romgaz', 3500, 8),
	   ('IBM', 5000, 9)

--SELECT * FROM Company

INSERT INTO Team_Company (TeamID, CompanyName, SponsoredWith)
VALUES (1, 'IBM', 'money'),
	   (1, 'Baum Bet', 'balls'),
	   (3, 'NTT Data', 'money'),
	   (4, 'Trasngaz', 'equipment'),
	   (5, 'Romgaz', 'food')

--SELECT * FROM Team_Company

INSERT INTO Team_Plays_Team (TeamID1, TeamID2, GameDate, GameHour)
VALUES (1, 2, '2021-10-20', '18:00'),
	   (1, 3, '2021-10-21', '19:00'),
	   (2, 4, '2021-10-24', '18:00'),
	   (2, 3, '2021-10-23', '17:00'),
	   (1, 5, '2021-10-21', '18:00'),
	   (4, 5, '2021-10-20', '20:30'),
	   (3, 4, '2021-10-28', '18:00')

--SELECT * FROM Team_Plays_Team

INSERT INTO Rules (RuleStatement, Penalty)
VALUES ('A player can not miss practice', '100 lei'),
	   ('A player can not swear', '20 push-ups'),
	   ('A coach can not yell at his players', '300 lei'),
	   ('A player can not be late at games', '1000 lei'),
	   ('All players need to be friends', 'bad chemistry')

--SELECT * FROM Rules

INSERT INTO Team_Rules (TeamID, RuleID)
VALUES (1, 1),
	   (1, 3),
	   (2, 1),
	   (2, 3),
	   (2, 5),
	   (3, 5),
	   (4, 4),
	   (4, 5)

--SELECT * FROM Team_Rules


INSERT INTO Team_Plays_Team (TeamID1, TeamID2, GameDate, GameHour)			-- violates referential integrity constraint, we don't have a team with id 6
VALUES (1, 6, '2021-10-20', '18:00'),
	   (2, 5, '2022-01-01', '19:00')


UPDATE Equipment			-- now Nike produces equipment only for sizes M and L, the old Nike equipments with larger or smaller sizes remain
SET Brand = 'Nike'
WHERE Size IN ('M', 'L')

UPDATE Team_Plays_Team													-- change game hour for team with id 1 when they play at 18 or in 21 oct.
SET GameHour = '20:00'
WHERE TeamID1 = 1 AND GameHour = '18:00' OR GameDate = '2021-10-21'

UPDATE Coach
SET CoachSalary = '5000'														-- change salary to 5000 for all coaches that have a salary between 3000 and 7000 and have an experience bigger than 5 years
WHERE CoachSalary BETWEEN 3000 AND 7000 AND CoachExperience NOT BETWEEN 0 AND 5


DELETE FROM Team_Company									-- Romgaz is not sponsoring anymore and nobody sponsors with things that start with e
WHERE CompanyName = 'Romgaz' OR SponsoredWith LIKE 'e%'

DELETE FROM Company											-- Delete companies that do not sponsor any team
WHERE CompanyName NOT IN (SELECT tc.CompanyName
						  FROM Team_Company tc)

DELETE FROM BasketballPlayer								-- Delete the players that don't have an associated name
WHERE PlayerName IS NULL