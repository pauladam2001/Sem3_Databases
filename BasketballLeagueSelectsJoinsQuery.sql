USE BasketballLeagueDB
GO

SELECT BP.PlayerName
FROM BasketballPlayer BP, Agent A							-- a. with UNION
WHERE BP.AgentID = A.AgentID AND A.AgentExperience = 2
UNION														-- return the name of the player which have an agent with experience 2 or 5
SELECT BP2.PlayerName
FROM BasketballPlayer BP2, Agent A2
WHERE BP2.AgentID = A2.AgentID AND A2.AgentExperience = 5
		
SELECT TOP 15 PERCENT BP.PlayerName							-- a. with OR, ORDER BY, TOP
FROM BasketballPlayer BP, Agent A			
WHERE BP.AgentID = a.AgentID and (A.AgentExperience = 2 OR A.AgentExperience = 5)
ORDER BY BP.PlayerName


SELECT TR.TeamID
FROM Team_Rules TR, Rules R
WHERE TR.RuleID = R.RuleID AND R.Penalty = '100 lei'
INTERSECT													-- b. with INTERSECT
SELECT TR2.TeamID											-- return the id of the teams that have both penalties of 100 and 300 lei
FROM Team_Rules TR2, Rules R2
WHERE TR2.RuleID = R2.RuleID AND R2.Penalty = '300 lei'

SELECT TR.TeamID	
FROM Team_Rules TR, Rules R									-- b. with IN
WHERE TR.RuleID = R.RuleID AND R.Penalty = '100 lei' AND	-- return the id of the teams that have both penalties of 100 and 300 lei
TR.TeamID IN (SELECT TR2.TeamID
			  FROM Rules R2, Team_Rules TR2
			  WHERE R2.Penalty = '300 lei')


SELECT DISTINCT TR.TeamID
FROM Team_Rules TR, Rules R									-- c. with EXCEPT, DISTINCT
WHERE TR.RuleID = R.RuleID AND R.Penalty IS NOT NULL		-- return the id of the teams that have any penalty but the 100 lei one
EXCEPT
SELECT TR2.TeamID
FROM Team_Rules TR2, Rules R2
WHERE TR2.RuleID = R2.RuleID AND R2.Penalty = '100 lei' 

SELECT DISTINCT TR.TeamID
FROM Team_Rules TR, Rules R									-- c. with NOT IN, DISTINCT
WHERE TR.RuleID = R.RuleID AND R.Penalty IS NOT NULL AND	-- return the id of the teams that have any penalty but the 100 lei one
	TR.TeamID NOT IN (SELECT TR2.TeamID
					  FROM Rules R2, Team_Rules TR2
					  WHERE R2.Penalty = '100 lei' AND TR2.RuleID = R2.RuleID)
					  

SELECT T.TeamName, T.TeamLocation, BP.PlayerName, E.Number
FROM Team T													-- d. INNER JOIN with 3 tables
INNER JOIN BasketballPlayer BP								-- find all players playing in all teams and their equipment number
ON T.TeamID = BP.TeamID
	INNER JOIN  Equipment E
	ON BP.PlayerID = E.PlayerID

SELECT TOP 5 *
FROM BasketballPlayer BP									-- d. LEFT JOIN, ORDER BY, TOP
LEFT JOIN Equipment E										-- find all players' equipments, including player with no equipment yet
ON BP.PlayerID = E.PlayerID
ORDER BY BP.PlayerExperience

SELECT TC.CompanyName, TC.SponsoredWith, T.TeamName, T.TeamLocation	
FROM Team_Company TC										-- d. RIGHT JOIN
RIGHT JOIN Team T											-- find all companies that are sponsors and the sponsored teams, including the teams that are not sponsored
ON TC.TeamID = T.TeamID

SELECT DISTINCT C.CompanyName
FROM Company C																-- d. FULL JOIN with 2 many-to-many relationships
FULL JOIN Team_Company TC ON TC.CompanyName = C.CompanyName					-- show me the companies that sponsor teams that won at least 3 matches
FULL JOIN Team T ON T.TeamID = TC.TeamID
FULL JOIN Team_Plays_Team TPT ON T.TeamID = TPT.TeamID1 
	WHERE 3 <= (SELECT COUNT(*)
				FROM Team_Plays_Team TPT2
				WHERE TPT2.WinningTeam = TPT.WinningTeam AND TPT.TeamID1 = TPT2.TeamID1)

--SELECT * FROM COMPANY
--SELECT * FROM Team_Company
--SELECT * FROM Team
--SELECT * FROM Team_Plays_Team


SELECT T.TeamName
FROM Team T													-- e. IN and subquery in WHERE clause
WHERE T.TeamID  IN											-- find the names of teams that play at 18:00
	(SELECT TPT.TeamID1
	FROM Team_Plays_Team TPT
	WHERE TPT.GameHour = '18:00')

SELECT T.TeamName
FROM Team T													-- e. IN and subquery in subquery in WHERE clause
WHERE T.TeamID IN											-- find the names of teams that have a players who has number 25 on equipment
	(SELECT BP.TeamID
	FROM BasketballPlayer BP
	WHERE BP.PlayerID IN
		(SELECT E.PlayerID
		FROM Equipment E
		WHERE E.Number = 55)
	)


SELECT BP.PlayerName										-- f. EXISTS and subquery in WHERE clause
FROM BasketballPlayer BP									-- find the names of players who have an agent with 10 years of experience
WHERE EXISTS (SELECT *
			FROM Agent A
			WHERE A.AgentExperience = 10 AND A.AgentID = BP.AgentID)

SELECT C.CompanyName										-- f. EXISTS and subquery in WHERE clause
FROM Company C												-- find the companies who sponsor the team with ID 1
WHERE EXISTS (SELECT *
			FROM Team_Company TC
			WHERE TC.TeamID = 1 AND TC.CompanyName = C.CompanyName)


SELECT T.TeamID, T.TeamName, T.YearOfAppearance-2021 AS YearOfAppMinus2021		-- g. subquery in the FROM clause, arithmetic expression
FROM Team T INNER JOIN														-- find the teams that have a coach with a salary equal to 5000
	(SELECT *
	FROM Coach C
	WHERE C.CoachSalary = 5000) r
ON T.TeamID = r.TeamID

SELECT R.RuleStatement, R.Penalty									-- g. subquery in the FROM clause
FROM Rules R INNER JOIN												-- find the rules that are present in regulations of the team with ID 1
	(SELECT *
	FROM Team_Rules TR
	WHERE TR.TeamID = 1) t
ON R.RuleID = t.RuleID


SELECT C.CoachSalary*2 AS CoachSalaryDoubled, MIN(C.CoachExperience) AS MinCoachExperience		-- h. query with GROUP BY, arithmetic expression
FROM Coach C																					-- find the minimum experience of the coach for each salary
GROUP BY C.CoachSalary

SELECT C.CoachSalary, AVG(C.CoachExperience) AS AvgCoachExperience		-- h. query with GROUP BY and HAVING
FROM Coach C															-- find the average experience for each salary with at least 2 coaches
GROUP BY C.CoachSalary
HAVING COUNT(*) >= 2

SELECT C.CoachExperience, MAX(C.CoachSalary) AS MaxCoachSalary			-- h. query with GROUP BY and HAVING and with a subquery in the HAVING clause
FROM Coach C															-- find the maximum salary of coaches who have a salary > 1000 for each experience with
WHERE C.CoachSalary > 1000													-- at least 1 entry
GROUP BY C.CoachExperience
HAVING 1 <= (SELECT COUNT(*)
			FROM Coach C2
			WHERE C2.CoachExperience = C.CoachExperience)

SELECT E.Brand, MIN(E.Number) AS MinNumber								-- h. query with GROUP BY and HAVING and with a subquery in the HAVING clause
FROM Equipment E														-- find the minimum number on equipments for each brand with at least 3 appearances
GROUP BY E.Brand
HAVING 2 < (SELECT COUNT(*)
			FROM Equipment E2
			WHERE E2.Brand = E.Brand)


SELECT BP.PlayerName, BP.PlayerExperience/2 AS PlayerExpDivBy2			-- i. query with ANY and a subquery in WHERE clause
FROM BasketballPlayer BP												-- find players whose experience is grater than the experience of some player called Adam
WHERE BP.PlayerExperience > ANY
	(SELECT BP2.PlayerExperience
	FROM BasketballPlayer BP2
	WHERE BP2.PlayerName = 'Adam Paul')

SELECT BP.PlayerName, BP.PlayerExperience								-- i. query with aggregation operator MIN and a subquery in WHERE clause
FROM BasketballPlayer BP												-- find players whose experience is grater than the experience of some player called Adam
WHERE BP.PlayerExperience >
	(SELECT MIN(BP2.PlayerExperience)
	FROM BasketballPlayer BP2
	WHERE BP2.PlayerName = 'Adam Paul')

SELECT E.PlayerID, E.Number												-- i. query with ANY and a subquery in WHERE clause
FROM Equipment E														-- find equipments that are worn by players with an experience of exactly 3 years
WHERE E.PlayerID = ANY
	(SELECT BP.PlayerID
	FROM BasketballPlayer BP
	WHERE BP.PlayerExperience = 3)

SELECT E.PlayerID, E.Number												-- i. query with IN and a subquery in WHERE clause
FROM Equipment E														-- find equipments that are worn by players with an experience of exactly 3 years
WHERE E.PlayerID IN
	(SELECT BP.PlayerID
	FROM BasketballPlayer BP
	WHERE BP.PlayerExperience = 3)

SELECT BP.PlayerName, BP.PlayerExperience								-- i. query with ALL and a subquery in WHERE clause
FROM BasketballPlayer BP												-- find players whose experience is grater than the experience of all players who are managed
WHERE BP.PlayerExperience > ALL												-- by the agent with ID 2
	(SELECT BP2.PlayerExperience
	FROM BasketballPlayer BP2
	WHERE BP2.AgentID = 2)

SELECT BP.PlayerName, BP.PlayerExperience								-- i. query with ALL and a subquery in WHERE clause
FROM BasketballPlayer BP												-- find players whose experience is grater than the experience of all players who are managed
WHERE BP.PlayerExperience >													-- by the agent with ID 2
	(SELECT MAX(BP2.PlayerExperience)
	FROM BasketballPlayer BP2
	WHERE BP2.AgentID = 2)

SELECT E.PlayerID, E.Number												-- i. query with ALL and a subquery in WHERE clause
FROM Equipment E														-- find equipments that are worn by players with an experience different than 3 years
WHERE E.PlayerID <> ALL
	(SELECT BP.PlayerID
	FROM BasketballPlayer BP
	WHERE BP.PlayerExperience = 3)

SELECT E.PlayerID, E.Number												-- i. query with NOT IN and a subquery in WHERE clause
FROM Equipment E														-- find equipments that are worn by players with an experience different than 3 years
WHERE E.PlayerID NOT IN
	(SELECT BP.PlayerID
	FROM BasketballPlayer BP
	WHERE BP.PlayerExperience = 3)