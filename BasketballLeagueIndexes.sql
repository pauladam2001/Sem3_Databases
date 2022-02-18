USE BasketballLeagueDB
GO

CREATE TABLE Ta
	(aid INT PRIMARY KEY,
	 a2 INT UNIQUE,
	 a3 VARCHAR(40))

CREATE TABLE Tb
	(bid INT PRIMARY KEY,
	 b2 INT)

CREATE TABLE Tc
	(cid INT PRIMARY KEY,
	 aid INT FOREIGN KEY REFERENCES Ta(aid),
	 bid INT FOREIGN KEY REFERENCES Tb(bid),
	 c1 VARCHAR(40))

-- DROP TABLE Ta
-- DROP TABLE Tb
-- DROP TABLE Tc

-- INSERT INTO Ta VALUES (1, 10, 'AA'), (5, 14, 'EE'), (2, 11, 'BB'), (4, 13, 'DD'), (3, 12, 'CC')
-- INSERT INTO Tb VALUES (5, 25), (3, 23), (1, 21), (2, 22), (4, 24)
-- INSERT INTO Tc VALUES (2, 3, 3, 'stringB'), (4, 4, 5, 'stringD'), (3, 2, 1, 'stringC'), (1, 1, 2, 'stringA'), (5, 5, 3, 'stringE')

GO
CREATE OR ALTER PROCEDURE uspInsertInTa (@rows INT)
AS
BEGIN
	DECLARE @a2 INT
	SET @a2 = @rows * 3
	DECLARE @a3 VARCHAR(10)

	WHILE @rows > 0
	BEGIN
		SET @a3 =  CONVERT(VARCHAR(40), NEWID())
		INSERT INTO Ta VALUES (@rows, @a2, @a3)
		SET @rows = @rows - 1
		SET @a2 = @a2 - 3
	END
END

GO
CREATE OR ALTER PROCEDURE uspInsertInTb (@rows INT)
AS
BEGIN
	DECLARE @b2 INT
	SET @b2 = @rows * 5

	WHILE @rows > 0
	BEGIN
		INSERT INTO Tb VALUES (@rows, @b2)
		SET @rows = @rows - 1
		SET @b2 = @b2 + 1
	END
END

GO
CREATE OR ALTER PROCEDURE uspInsertInTc (@rows INT)
AS
BEGIN
	DECLARE @aid INT
	DECLARE @bid INT
	DECLARE @c1 VARCHAR(10)

	WHILE @rows > 0
	BEGIN
		SET @aid = (SELECT TOP 1 aid FROM Ta ORDER BY NEWID())
		SET @bid = (SELECT TOP 1 bid FROM Tb ORDER BY NEWID())
		SET @c1 = CONVERT(VARCHAR(40), NEWID())
		INSERT INTO Tc VALUES (@rows, @aid, @bid, @c1)
		SET @rows = @rows - 1
	END
END

EXEC uspInsertInTa 15000
EXEC uspInsertInTb 16000
EXEC uspInsertInTc 14000

DELETE FROM Ta
DELETE FROM Tb
DELETE FROM Tc

SELECT * FROM Ta
SELECT * FROM Tb
SELECT * FROM Tc


-- a. Write queries on Ta such that their execution plans contain the following operators:

-- index seek - retrieves selective rows from the table
-- index scan - a scan touches every row in the table, whether or not it qualifies

-- clustered index scan		-- a Clustered Index Scan is same like a Table Scan operation i.e. entire index is traversed row by row to return the data set
SELECT *
FROM Ta
ORDER BY aid

-- clustered index seek		-- The Clustered Index Seek operator uses the structure of a clustered index to efficiently find either single rows (singleton seek) or specific subsets of rows (range seek)
SELECT *
FROM Ta
WHERE aid BETWEEN 2 AND 4

-- nonclustered index scan   -- Non Clustered Index Scan - because we just need Name, but have no selectivity, the NCI will suffice and is narrower
CREATE NONCLUSTERED INDEX idx_ncl_a2
	ON Ta(a2) INCLUDE (a3)
-- DROP INDEX idx_ncl_a2 ON Ta
SELECT a3
FROM Ta
ORDER BY a2		-- unique

-- nonclustered index seek   -- Non-Clustered Index Seek occurs when Columns part of non-clustered index accessed in query and rows located in the B+ tree
SELECT a3
FROM Ta
WHERE a2 < 200

-- key lookup		-- The key lookup operator occurs when the query optimizer performs an index seek against a specific table and that index does not have all of the columns needed to fulfill the result set
SELECT a2			-- A key lookup occurs when SQL uses a nonclustered index to satisfy all or some of a query's predicates, but it doesn't contain all the information needed to cover the query
FROM Ta
WHERE a2 = 500


-- b. Write a query on table Tb with a WHERE clause of the form WHERE b2=value and analyze its execution plan.
--	   Create a nonclustered index that can speed up the query. Examine the execution plan again.

-- no index: estimated subtree cost: 0.0453264 (clustered index scan)
SELECT *
FROM Tb
WHERE b2 = 3

-- nonclustered index: estimated subtree cost: 0.0032831 (nonclustered index seek - more efficient)
CREATE NONCLUSTERED INDEX idx_ncl_b2
	ON Tb(b2)
-- DROP INDEX idx_ncl_b2 on Tb
SELECT *
FROM Tb
WHERE b2 = 3


-- c. Create a view that joins at least 2 tables. Check whether existing indexes are helpful; if not, reassess existing indexes / examine the
--      cardinality of the tables.

GO
CREATE OR ALTER VIEW vView AS
	SELECT TOP 2000  A.a3, B.b2
	FROM Tc C
		INNER JOIN Ta A on C.aid = A.aid
		INNER JOIN Tb B on C.bid = B.bid
	WHERE B.b2 > 500 AND A.a2 < 50
GO

SELECT * FROM vView

-- the current index, idx_ncl_b2 is not helpful. Estimated subtree cost is the same with or without it: 0.279857
-- cannot be optimized, the index scan is needed because it has to go through all rows to check the where condition

DROP INDEX idx_ncl_a2 ON Ta
DROP INDEX idx_ncl_b2 ON Tb
DROP INDEX idx_ncl_aid ON Tc

--CREATE NONCLUSTERED INDEX idx_ncl_a2
--	ON Ta(a2) INCLUDE (a3)
--CREATE NONCLUSTERED INDEX idx_ncl_b2
--	ON Tb(b2) INCLUDE (bid)
CREATE NONCLUSTERED INDEX  idx_ncl_aid
	ON Tc(aid) INCLUDE(bid)

-- after creating the index idx_ncl_aid the estimated subtree cost reduces to: 0.148239 (half - added a clustered index scan on join)