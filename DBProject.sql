-- Uncomment to reset database
USE master;
DROP DATABASE Project;

CREATE DATABASE Project;
USE Project;

GO

---------------------------------------- 2.1a -------------------------------------
CREATE PROC createAllTables
AS
	CREATE TABLE SystemUser (
		username VARCHAR(20),
		password VARCHAR(20) NOT NULL,
		CONSTRAINT PK_SystemUser PRIMARY KEY (username)
	);

	CREATE TABLE Stadium (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		location VARCHAR(20) NOT NULL,
		capacity INT NOT NULL,
		status BIT NOT NULL DEFAULT 1, -- unavailable => 0 / available => 1
		CONSTRAINT PK_Stadium PRIMARY KEY (id)
	);

	CREATE TABLE StadiumManager (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		stadium_id INT NOT NULL,
		username VARCHAR(20) NOT NULL,
		CONSTRAINT PK_StadiumManager PRIMARY KEY (id),
		CONSTRAINT FK_StadiumManager_Stadium FOREIGN KEY (stadium_id) REFERENCES Stadium ON DELETE CASCADE,
		CONSTRAINT FK_StadiumManager_SystemUser FOREIGN KEY (username) REFERENCES SystemUser ON DELETE CASCADE
	);

	CREATE TABLE Club (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		location VARCHAR(20) NOT NULL,
		CONSTRAINT PK_Club PRIMARY KEY (id)
	);

	CREATE TABLE ClubRepresentative (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		club_id INT NOT NULL,
		username VARCHAR(20) NOT NULL,
		CONSTRAINT PK_ClubRepresentative PRIMARY KEY (id),
		CONSTRAINT FK_ClubRepresentative_Club FOREIGN KEY (club_id) REFERENCES Club ON DELETE CASCADE,
		CONSTRAINT FK_ClubRepresentative_SystemUser FOREIGN KEY (username) REFERENCES SystemUser ON DELETE CASCADE
	);

	CREATE TABLE Fan (
		national_id VARCHAR(20),
		name VARCHAR(20) NOT NULL,
		birth_date DATETIME NOT NULL,
		address VARCHAR(20) NOT NULL,
		phone_number INT NOT NULL,
		status BIT NOT NULL DEFAULT 1, -- blocked => 0 / not blocked => 1 
		username VARCHAR(20) NOT NULL,
		CONSTRAINT PK_Fan PRIMARY KEY (national_id),
		CONSTRAINT FK_Fan_SystemUser FOREIGN KEY (username) REFERENCES SystemUser ON DELETE CASCADE
	);

	CREATE TABLE SportsAssociationManager (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		username VARCHAR(20) NOT NULL,
		CONSTRAINT PK_SportsAssociationManager PRIMARY KEY (id),
		CONSTRAINT FK_SportsAssociationManager_SystemUser FOREIGN KEY (username) REFERENCES SystemUser ON DELETE CASCADE
	);

	CREATE TABLE SystemAdmin (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		username VARCHAR(20) NOT NULL,
		CONSTRAINT PK_SystemAdmin PRIMARY KEY (id),
		CONSTRAINT FK_SystemAdmin_SystemUser FOREIGN KEY (username) REFERENCES SystemUser ON DELETE CASCADE
	);

	CREATE TABLE Match (
		id INT IDENTITY,
		start_time DATETIME NOT NULL,
		end_time DATETIME NOT NULL,
		host_club_id INT NOT NULL,
		guest_club_id INT NOT NULL,
		stadium_id INT,
		CONSTRAINT PK_MATCH PRIMARY KEY (id),
		CONSTRAINT FK_Match_Host FOREIGN KEY (host_club_id) REFERENCES Club ,
		CONSTRAINT FK_Match_Guest FOREIGN KEY (guest_club_id) REFERENCES Club,
		CONSTRAINT FK_Match_Stadium FOREIGN KEY (stadium_id) REFERENCES Stadium ON DELETE SET NULL
	);

	CREATE TABLE HostRequest (
		id INT IDENTITY,
		club_representative_id INT NOT NULL,
		stadium_manager_id INT NOT NULL,
		match_id INT NOT NULL,
		status VARCHAR(20) CHECK (status IN ('unhandled', 'accepted', 'rejected')) DEFAULT 'unhandled',
		CONSTRAINT PK_HostRequest PRIMARY KEY (id),
		CONSTRAINT FK_HostRequest_ClubRepresentative FOREIGN KEY (club_representative_id) REFERENCES ClubRepresentative ON DELETE CASCADE,
		CONSTRAINT FK_HostRequest_StadiumManager FOREIGN KEY (stadium_manager_id) REFERENCES StadiumManager /*ON DELETE CASCADE*/,
		CONSTRAINT FK_HostRequest_Match FOREIGN KEY (match_id) REFERENCES Match ON DELETE CASCADE
	);

	CREATE TABLE Ticket (
		id INT IDENTITY,
		status BIT NOT NULL DEFAULT 1, -- sold => 0 / available => 1
		match_id INT NOT NULL,
		CONSTRAINT PK_Ticket PRIMARY KEY (id),
		CONSTRAINT FK_Ticket_Match FOREIGN KEY (match_id) REFERENCES Match ON DELETE CASCADE,
	);

	CREATE TABLE TicketBuyingTransactions (
		fan_national_id VARCHAR(20) NOT NULL,
		ticket_id INT NOT NULL,
		CONSTRAINT PK_TicketBuyingTransactions PRIMARY KEY (ticket_id),
		CONSTRAINT FK_TicketBuyingTransactions_Fan FOREIGN KEY (fan_national_id) REFERENCES Fan ON DELETE CASCADE,
		CONSTRAINT FK_TicketBuyingTransactions_Ticket FOREIGN KEY (ticket_id) REFERENCES Ticket ON DELETE CASCADE
	);
------------------------------------------------------------------------------------

GO

-- Should I remove this line before submitting?
EXEC createAllTables;

GO

---------------------------------------- 2.1b -------------------------------------
CREATE PROC dropAllTables
AS
	DROP TABLE Ticket;
	DROP TABLE SportsAssociationManager;
	DROP TABLE HostRequest;
	DROP TABLE StadiumManager;
	DROP TABLE Fan;
	DROP TABLE TicketBuyingTransactions;
	DROP TABLE Match;
	DROP TABLE Stadium;
	DROP TABLE ClubRepresentative;
	DROP TABLE Club;
	DROP TABLE SystemAdmin;
	DROP TABLE SystemUser;
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.1c -------------------------------------
CREATE PROC dropAllProceduresFunctionsViews --SNAP
AS
	DROP PROC createAllTables;
	DROP PROC dropAllTables;
	DROP PROC clearAllTables;
	
	DROP PROC deleteClub;
	DROP PROC addStadium;
	DROP PROC unblockFan;
	DROP PROC addRepresentative;
	DROP PROC purchaseTicket;
	DROP PROC updateMatchHost;
	
	DROP VIEW allFans;
	DROP VIEW allStadiums;
	DROP VIEW allRequests;
	
	
	DROP FUNCTION viewAvailableStadiumsOn;
	DROP FUNCTION availableMatchesToAttend;
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.1c -------------------------------------
CREATE PROC clearAllTables
AS
	TRUNCATE TABLE Ticket;
	TRUNCATE TABLE SportsAssociationManager;
	TRUNCATE TABLE HostRequest;
	TRUNCATE TABLE StadiumManager;
	TRUNCATE TABLE Fan;
	TRUNCATE TABLE TicketBuyingTransactions;
	TRUNCATE TABLE Match;
	TRUNCATE TABLE Stadium;
	TRUNCATE TABLE ClubRepresentative;
	TRUNCATE TABLE Club;
	TRUNCATE TABLE SystemAdmin;
	TRUNCATE TABLE SystemUser;
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.2a --------------------------------------
CREATE VIEW allAssocManagers 
AS 
	SELECT SU.username, SU.password, SAM.name
	FROM SportsAssociationManager SAM, SystemUser SU 
	WHERE SAM.username = SU.username;
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.2b --------------------------------------
CREATE VIEW allClubRepresentatives
AS
	SELECT CR.username, SU.password, CR.name, C.name AS club_name
	FROM ClubRepresentative CR 
	INNER JOIN Club C ON CR.club_id = C.id
	INNER JOIN SystemUser SU ON SU.username = CR.username;
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.2c --------------------------------------
CREATE VIEW allStadiumManagers
AS 
	SELECT SU.username, SU.password, SM.name AS stadium_manger_name, S.name as stadium_name
	FROM StadiumManager SM , Stadium S , SystemUser SU
	WHERE SM.stadium_id = S.id AND SM.username = SU.username 
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.2d --------------------------------------
CREATE VIEW allFans
AS
	SELECT F.username, SU.password, F.name, F.national_id, F.birth_date, F.status 
	FROM Fan F INNER JOIN SystemUser SU ON F.username = SU.username;
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.2e --------------------------------------
CREATE VIEW allMatches
AS
	(
		SELECT C.name AS host, C2.name AS guest, Match.start_time  
		FROM Club AS C 
		INNER JOIN Match ON C.id = Match.host_club_id 
		INNER JOIN Club AS C2 ON C2.id = Match.guest_club_id
	) UNION (
		SELECT C.name AS host,C2.name AS guest, Match.start_time  
		FROM Club AS C2 
		INNER JOIN Match ON C2.id = Match.guest_club_id 
		INNER JOIN Club AS C ON C.id = Match.host_club_id
	)
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.2f --------------------------------------
CREATE VIEW allTickets
AS
SELECT C1.name AS host_club_name, C2.name AS guest_club_name, Stadium.name, Match.start_time
FROM Ticket
INNER JOIN Match ON Ticket.match_id = Match.id
INNER JOIN Club C1 ON Match.host_club_id = C1.id
INNER JOIN Club C2 ON Match.guest_club_id = C2.id
LEFT OUTER JOIN Stadium ON Match.stadium_id = Stadium.id
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.2g --------------------------------------
CREATE VIEW allCLubs
AS
	SELECT name, location
	FROM Club
------------------------------------------------------------------------------------

GO

--------------------------------------- 2.2h ---------------------------------------
CREATE VIEW allStadiums
AS
	SELECT name, location, capacity, status
	FROM Stadium;
------------------------------------------------------------------------------------

GO

--------------------------------------- 2.2i ---------------------------------------
CREATE VIEW allRequests
AS
	SELECT CR.username AS club_representative_username, SM.username AS stadium_manager_username, R.status
	FROM HostRequest R, ClubRepresentative CR, StadiumManager SM
	WHERE R.club_representative_id = CR.id AND R.stadium_manager_id = SM.id
------------------------------------------------------------------------------------

GO

------------------------------------------ I ---------------------------------------
CREATE PROC addAssociationManager
	@name VARCHAR(20),
	@username VARCHAR(20),
	@password VARCHAR(20)
AS
	INSERT INTO SystemUser 
	VALUES (@username, @password)

	INSERT INTO SportsAssociationManager
	VALUES (@name, @username)
------------------------------------------------------------------------------------

GO

----------------------------------------- II --------------------------------------- 
CREATE PROC addNewMatch
	@host VARCHAR(20),
	@guest VARCHAR(20),
	@start_time DATETIME,
	@end_time DATETIME
AS
	DECLARE @host_id INT;
	DECLARE @guest_id INT;

	SELECT @host_id = Club.id
	FROM Club
	WHERE Club.name = @host;

	SELECT @guest_id = Club.id
	FROM Club
	WHERE Club.name = @guest;
	
	INSERT INTO Match VALUES (@start_time, @end_time, @host_id, @guest_id, NULL);
------------------------------------------------------------------------------------

GO

----------------------------------------- III --------------------------------------
CREATE VIEW clubsWithNoMatches
AS
	SELECT C.name 
	FROM Club AS C 
	WHERE C.id NOT IN (SELECT M.guest_club_id FROM Match M UNION SELECT M.host_club_id FROM Match M) 
------------------------------------------------------------------------------------

GO

----------------------------------------- IV ---------------------------------------
CREATE PROC deleteMatch
	@host VARCHAR(20),
	@guest VARCHAR(20)
AS
	DELETE FROM Match 
	WHERE host_club_id = (SELECT id FROM Club WHERE Club.name = @host) 
	AND guest_club_id = (SELECT id FROM Club WHERE Club.name = @guest);
------------------------------------------------------------------------------------

GO

----------------------------------------- V ----------------------------------------
CREATE PROC deleteMatchesOnStadium
	@stadium VARCHAR(20)
AS
	DECLARE @stadium_id INT
	
	SELECT @stadium_id = Stadium.id
	FROM Stadium
	WHERE Stadium.name = @stadium;

	DELETE FROM Match
	WHERE Match.stadium_id = @stadium_id AND start_time > CURRENT_TIMESTAMP;
------------------------------------------------------------------------------------


GO

----------------------------------------- VI ---------------------------------------
CREATE PROC addClub
	@club_name VARCHAR(20),
	@club_location VARCHAR(20)
AS
	INSERT INTO Club VALUES (@club_name, @club_location);
------------------------------------------------------------------------------------

GO

--------------------------------------- VII ---------------------------------------
CREATE PROC  addTicket
	@hostClub VARCHAR(20),
	@guestClub VARCHAR(20),
	@startTime DATETIME 
AS 
	DECLARE @matchID INT
	SELECT @matchID = M.id 
	FROM Match M, Club C1, Club C2
	WHERE M.guest_club_id = C2.id AND M.host_club_id = C1.id
	AND C1.name = @hostClub AND C2.name = @guestClub AND M.start_time = @startTime

	INSERT INTO Ticket 
	VALUES (1, @matchID)
------------------------------------------------------------------------------------

GO

--------------------------------------- VIII ---------------------------------------
-- TODO: Delete everything that references the club.
CREATE PROC deleteClub
	@club_name VARCHAR(20)
AS
	DECLARE @club_id INT;
	SELECT @club_id = id FROM Club WHERE name = @club_name;
	DELETE FROM Match WHERE host_club_id = @club_id OR guest_club_id = @club_id;
	DELETE FROM Club WHERE id = @club_id;
------------------------------------------------------------------------------------

GO

---------------------------------------- IX ----------------------------------------
-- TODO: Should the default for a stadium to be available?
CREATE PROC addStadium
	@stadium_name VARCHAR(20),
	@stadium_location VARCHAR(20),
	@stadium_capacity INT
AS
	INSERT INTO Stadium (name, location, capacity)
	VALUES (@stadium_name, @stadium_location, @stadium_capacity)
------------------------------------------------------------------------------------

GO

---------------------------------------- X ----------------------------------------
CREATE PROC deleteStadium
	@n VARCHAR(20)
AS
	DELETE FROM HostRequest 
	WHERE stadium_manager_id = (
		SELECT id 
		FROM StadiumManager 
		WHERE stadium_id = (
			SELECT id
			FROM Stadium
			WHERE name = @n
		)
	);

	DELETE FROM Stadium WHERE Stadium.name = @n;
------------------------------------------------------------------------------------

GO

---------------------------------------- XI ----------------------------------------
CREATE PROC blockFan
	@national_id VARCHAR(20)
AS
	UPDATE Fan
	SET status = 0
	WHERE @national_id = fan.national_id
------------------------------------------------------------------------------------

GO

---------------------------------------- XII ----------------------------------------
CREATE PROC unblockFan
	@national_id VARCHAR(20)
AS
	UPDATE Fan
	SET status = 1
	WHERE national_id = @national_id;
------------------------------------------------------------------------------------

GO

---------------------------------------- XIII ----------------------------------------
CREATE PROC addRepresentative
	@representive_name VARCHAR(20),
	@club_name VARCHAR(20),
	@username VARCHAR(20),
	@password VARCHAR(20)
AS
	INSERT INTO SystemUser (username, password)
	VALUES (@username, @password);
	
	DECLARE @club_id INT;
	SELECT @club_id = id FROM Club WHERE name = @club_name;
	
	INSERT INTO ClubRepresentative (name, club_id, username)
	VALUES (@representive_name, @club_id, @username);
------------------------------------------------------------------------------------

GO

---------------------------------------- XIV ----------------------------------------
-- TODO: Should you also make sure there are no requests to host matches on that stadium?
CREATE FUNCTION viewAvailableStadiumsOn(@date DATETIME)
RETURNS TABLE
AS
	RETURN
	(
		SELECT S.name, S.location, S.capacity
		FROM Stadium S
		WHERE S.status = 1 AND NOT EXISTS (
			SELECT *
			FROM Match M
			WHERE M.stadium_id = S.id AND M.start_time <= @date AND M.end_time >= @date
		)
	);
------------------------------------------------------------------------------------

GO

---------------------------------------- XV -----------------------------------------
CREATE PROC	addHostRequest
	@clubName VARCHAR(20),
	@stadiumName VARCHAR(20),
	@startTime DATETIME 
AS
	DECLARE @matchID INT
	SELECT @matchID = M.id
	FROM Match M, Club C
	WHERE M.host_club_id = C.id
	AND C.name = @clubName
	AND M.start_time = @startTime ;

	DECLARE @clubRepresentativeID INT 
	SELECT @clubRepresentativeID = CR.id
	FROM Club C , ClubRepresentative CR
	WHERE CR.club_id = C.id AND C.name =@clubName ;

	DECLARE @stadiumManagerID INT 
	SELECT @stadiumManagerID =SM.id
	FROM Stadium S , StadiumManager SM
	WHERE S.id = SM.stadium_id AND S.name =@stadiumName ;

	INSERT INTO HostRequest 
	VALUES (@clubRepresentativeID,@stadiumManagerID,@matchID,'unhandled');
------------------------------------------------------------------------------------

GO

-------------------------------------- XVI -----------------------------------------
CREATE FUNCTION allUnassignedMatches(@club VARCHAR(20))
RETURNS TABLE
AS
	RETURN (
		SELECT DISTINCT Club.name, Match.start_time
		FROM Match, Club
		WHERE Match.guest_club_id = Club.id 
		AND Match.host_club_id = (SELECT id FROM Club WHERE name = @club) 
		AND Match.stadium_id IS NULL
	);
------------------------------------------------------------------------------------

GO

-------------------------------------- XVII -----------------------------------------
CREATE PROC  addStadiumManager
	@name VARCHAR(20),
	@stadiumName VARCHAR(20),
	@username VARCHAR(20),
	@password VARCHAR(20)
AS 
	DECLARE @stadiumID INT
	SELECT @stadiumID = S.id
	FROM Stadium S 
	WHERE S.name = @stadiumName;

	INSERT INTO SystemUser 
	VALUES(@username, @password);

	INSERT INTO StadiumManager 
	VALUES (@name, @stadiumID, @username);
------------------------------------------------------------------------------------

GO

-------------------------------------- XVIII -----------------------------------------
CREATE FUNCTION allPendingRequests(@m VARCHAR(20))
RETURNS TABLE
AS
	RETURN (
		SELECT ClubRepresentative.name AS club_representative_name, Club.name AS guest_club_name, Match.start_time
		FROM HostRequest
		INNER JOIN ClubRepresentative ON HostRequest.club_representative_id = ClubRepresentative.id
		INNER JOIN Match ON HostRequest.match_id = Match.id
		INNER JOIN Club ON Match.guest_club_id = Club.id
		INNER JOIN StadiumManager ON HostRequest.stadium_manager_id = StadiumManager.id
		WHERE StadiumManager.username = @m
	)
------------------------------------------------------------------------------------

GO

-------------------------------------- XIX -----------------------------------------
CREATE PROC generateTickets
	@match_id INT
AS
	DECLARE @count INT = 0;
	DECLARE @capacity INT;

	SELECT @capacity = S.capacity
	FROM Match M INNER JOIN Stadium S ON M.stadium_id = S.id
	WHERE M.id = @match_id;

	WHILE @count < @capacity
	BEGIN
		INSERT INTO Ticket VALUES (1, @match_id);
		SET @count = @count + 1;
	END;

GO

CREATE PROC acceptRequest
	@stadium_manager_username VARCHAR (20),
	@host_club VARCHAR (20),
	@guest_club VARCHAR (20),
	@date DATETIME
AS
	DECLARE @match_id INT;
	DECLARE @stadium_id INT;

	SELECT @match_id = Match.id
	FROM Match
		INNER JOIN Club C1 ON Match.host_club_id = C1.id
		INNER JOIN Club C2 ON Match.guest_club_id = C2.id
	WHERE Match.start_time = @date 
		AND C1.name = @host_club 
		AND C2.name = @guest_club;
	
	SELECT @stadium_id = stadium_id 
	FROM StadiumManager 
	WHERE username = @stadium_manager_username;

	PRINT @stadium_id;

	UPDATE HostRequest
	SET status = 'accepted'
	WHERE id IN (
		SELECT H.id
		FROM HostRequest H
		INNER JOIN StadiumManager ON HostRequest.stadium_manager_id = StadiumManager.id
		WHERE StadiumManager.username = @stadium_manager_username
		AND H.match_id = @match_id
		AND H.status = 'unhandled'
	);

	UPDATE Match
	SET stadium_id = @stadium_id
	WHERE id = @match_id;

	EXEC generateTickets @match_id
------------------------------------------------------------------------------------

GO

-------------------------------------- XX -----------------------------------------
CREATE PROC rejectRequest
	@m VARCHAR(20),
	@h VARCHAR(20),
	@g VARCHAR(20),
	@d DATETIME
AS
	UPDATE HostRequest
	SET status = 'rejected'
	WHERE id = (
		SELECT H.id
		FROM HostRequest H
		INNER JOIN StadiumManager ON HostRequest.stadium_manager_id = StadiumManager.id
		INNER JOIN Match ON HostRequest.match_id = Match.id
		INNER JOIN Club C1 ON Match.host_club_id = C1.id
		INNER JOIN Club C2 ON Match.guest_club_id = C2.id
		WHERE StadiumManager.username = @m AND Match.start_time = @d AND C1.name = @h AND C2.name = @g /*AND C1 <> C2*/
	);
------------------------------------------------------------------------------------

GO

-------------------------------------- XXI -----------------------------------------
CREATE PROC addFan
	@fan_name VARCHAR(20),
	@username VARCHAR(20),
	@password VARCHAR(20),
	@national_id_number VARCHAR(20),
	@birth_date DATETIME,
	@address VARCHAR(20),
	@phone_number INT
AS
	INSERT INTO SystemUser VALUES (@username, @password);
	INSERT INTO Fan VALUES (@national_id_number, @fan_name, @birth_date, @address, @phone_number, 1, @username)
------------------------------------------------------------------------------------

GO

-------------------------------------- XXII ----------------------------------------
CREATE FUNCTION upcomingMatchesOfClub(@c VARCHAR(20))
RETURNS TABLE
AS
	RETURN (
		SELECT C1.name AS host_club_name, C2.name AS guest_club_name, Match.start_time, Stadium.name AS stadium_name
		FROM Match
		INNER JOIN Stadium ON Match.stadium_id = Stadium.id
		INNER JOIN Club C1 ON C1.id = Match.host_club_id
		INNER JOIN Club C2 ON C2.id = Match.guest_club_id
		WHERE Match.start_time > CURRENT_TIMESTAMP AND C1.name <> C2.name
	)
------------------------------------------------------------------------------------

GO

---------------------------------------- XXIII --------------------------------------
CREATE FUNCTION availableMatchesToAttend(@date DATETIME)
RETURNS TABLE
AS
	RETURN (
		SELECT HC.name AS host_club_name, GC.name AS guest_club_name, M.start_time, S.name as stadium_name
		FROM Match M
		INNER JOIN Club HC ON M.host_club_id = HC.id
		INNER JOIN Club GC ON M.guest_club_id = GC.id
		INNER JOIN Stadium S ON M.stadium_id = S.id 
		WHERE M.start_time >= @date AND EXISTS (
			SELECT *
			FROM Ticket T
			WHERE T.match_id = M.id AND T.status = 1
		)
	);
------------------------------------------------------------------------------------

GO

---------------------------------------- XXIV --------------------------------------
CREATE PROC purchaseTicket
	@fan_national_id VARCHAR(20),
	@host_club_name VARCHAR(20),
	@guest_club_name VARCHAR(20),
	@match_start_time DATETIME
AS
	DECLARE @match_id INT;
	
	SELECT @match_id = id 
	FROM Match 
	WHERE host_club_id = (SELECT id FROM Club WHERE name = @host_club_name)
	AND guest_club_id = (SELECT id FROM Club WHERE name = @guest_club_name) 
	AND start_time = @match_start_time;
	
	DECLARE @ticket_id INT;
	SELECT TOP 1 @ticket_id = id FROM Ticket WHERE match_id = @match_id AND status = 1;
	
	UPDATE Ticket
	SET status = 0
	WHERE id = @ticket_id;
	
	INSERT INTO TicketBuyingTransactions (fan_national_id, ticket_id)
	VALUES (@fan_national_id, @ticket_id);
------------------------------------------------------------------------------------

GO

---------------------------------------- XXV --------------------------------------
CREATE PROC updateMatchHost
	@host_club_name VARCHAR(20),
	@guest_club_name VARCHAR(20),
	@match_start_time DATETIME
AS
	DECLARE @host_club_id INT;
	SELECT @host_club_id = id FROM Club WHERE name = @host_club_name;
	
	DECLARE @guest_club_id INT;
	SELECT @guest_club_id = id FROM Club WHERE name = @guest_club_name;

	UPDATE Match
	SET host_club_id = @guest_club_id, guest_club_id = @host_club_id
	WHERE id = (
		SELECT id FROM Match
		WHERE host_club_id = @host_club_id AND guest_club_id = @guest_club_id AND start_time = @match_start_time
	);
------------------------------------------------------------------------------------	

GO

-------------------------------------- XXVI --------------------------------------
CREATE VIEW matchesPerTeam
AS
(
	SELECT Club.name, COUNT(*) AS number_of_matches 
	FROM Club INNER JOIN MATCH ON Club.id = Match.host_club_id
	GROUP BY Club.name
) UNION (
	SELECT Club.name, COUNT(*) AS number_of_matches
	FROM Club INNER JOIN MATCH ON Club.id = Match.guest_club_id
	GROUP BY Club.name
)
------------------------------------------------------------------------------------

GO

-------------------------------------- XXVII --------------------------------------
CREATE VIEW clubsNeverMatched
AS
	SELECT C1.name AS first_club_name, C2.name AS second_club_name
	FROM Club C1, Club C2
	WHERE NOT EXISTS (
		SELECT *
		FROM Match M
		WHERE M.host_club_id = C1.id AND M.guest_club_id = C2.id
		OR M.host_club_id = C2.id AND M.guest_club_id = C2.id
	);
------------------------------------------------------------------------------------

GO

-------------------------------------- XXVIII --------------------------------------
CREATE FUNCTION clubsNeverPlayed(@clubName VARCHAR(20))
RETURNS TABLE 
AS
RETURN (
	SELECT C.name 
	FROM Club  C 
	WHERE C.name <> @clubName
	AND NOT EXISTS 
	(
		SELECT * 
		FROM Match  M , Club  C1 , Club C2 
		WHERE M.host_club_id = C1.id AND M.guest_club_id = C2.id AND 
		(C1.name = C.name AND C2.name = @clubName ) 
		OR (C1.name = @clubName AND C2.name =C.name)
	)
)
------------------------------------------------------------------------------------

GO

---------------------------------------- XXIX --------------------------------------
CREATE FUNCTION matchWithHighestAttendance()
RETURNS TABLE
AS
	RETURN (
		SELECT C1.name AS host_club, C2.name AS guest_club
		FROM Match M, Club C1, Club C2, Ticket T 
		WHERE M.host_club_id = C1.id
			AND M.guest_club_id = C2.id 
			AND T.match_id = M.id
		GROUP BY T.match_id, C1.name, C2.name
		HAVING COUNT(T.id) >= ALL (
			SELECT COUNT(T.id)
			FROM Match M INNER JOIN Ticket T ON T.match_id = M.id
			WHERE T.status = 0
			GROUP BY M.id
		)
	)
------------------------------------------------------------------------------------

GO

----------------------------------------- XXX --------------------------------------
CREATE FUNCTION matchesRankedByAttendance()
RETURNS TABLE 
AS 
	RETURN (
		SELECT TOP 100 PERCENT C1.name AS host_club, C2.name AS guest_club
		FROM Match M, Club C1, Club C2, Ticket T 
		WHERE M.host_club_id = C1.id
			AND M.guest_club_id = C2.id 
			AND T.match_id = M.id 
			AND T.status = 0
		GROUP BY T.match_id, C1.name, C2.name
		ORDER BY COUNT(*) DESC
	)
------------------------------------------------------------------------------------

GO

---------------------------------------- XXXI --------------------------------------
CREATE FUNCTION requestsFromClub
(@stadiumName VARCHAR(20),@clubName VARCHAR(20))
RETURNS TABLE 
AS 
RETURN (
	SELECT C1.name AS host_club_name, C2.name AS guest_club_name
	FROM Match M, Club  C1, Club C2, HostRequest H, Stadium S, StadiumManager SM
	WHERE M.host_club_id = C1.id  AND M.guest_club_id = C2.id  
	AND M.id = H.match_id AND H.stadium_manager_id = SM.id 
	AND SM.stadium_id = S.id
	AND C1.name = @clubName AND S.name = @stadiumName 
)
------------------------------------------------------------------------------------

GO


--############## Testing (DONT FORGET TO REMOVE BEFORE SUBMITTING ) ################

INSERT INTO SystemUser VALUES 
	('cr1', 'pass_cr1'), 
	('sm1', 'pass_sm1'), 
	('cr2', 'pass_cr2'), 
	('sm2', 'pass_sm2'), 
	('cr3', 'pass_cr3'), 
	('sm3', 'pass_sm3'),
	('cr4', 'pass_cr4'),
	('fan1', 'pass_fan1'),
	('fan2', 'pass_fan2'),
	('blocked_fan', 'pass_blocked_fan'),
	('sa1', 'pass_sa1'),
	('sa2', 'pass_sa2'),
	('sam1', 'pass_sam1'),
	('sam2', 'pass_sam2');
	
INSERT INTO SystemAdmin VALUES
	('SA 1', 'sa1'),
	('SA 2', 'sa2');

INSERT INTO SportsAssociationManager VALUES
	('SAM 1', 'sam1'),
	('SAM 2', 'sam2');

INSERT INTO Club VALUES 
	('Club 1', 'Egypt'), 
	('Club 2', 'Egypt'), 
	('Club 3', 'Germany'),
	('Club 4', 'Japan');

INSERT INTO Stadium VALUES 
	('Stadium 1', 'Egypt', 5, 1), 
	('Stadium 2', 'Egypt', 3, 1), 
	('Stadium 3', 'Germany', 2, 1), 
	('Stadium 4', 'Poland', 2, 0);

INSERT INTO ClubRepresentative VALUES 
	('CR 1', 1, 'cr1'), 
	('CR 2', 2, 'cr2'), 
	('CR 3', 3, 'cr3'),
	('CR 4', 4, 'cr4');

INSERT INTO StadiumManager VALUES 
	('SM 1', 1, 'sm1'), 
	('SM 2', 2, 'sm2'), 
	('SM 3', 3, 'sm3');

INSERT INTO Fan VALUES
	('id_fan1', 'Fan 1', '1-1-2000', 'Address 1', '0123456789', 1, 'fan1'),
	('id_fan2', 'Fan 2', '1-5-2001', 'Address 2', '0123456789', 1, 'fan2'),
	('id_blocked_fan', 'Blocked Fan', '10-9-2001', 'Address 3', '0123456789', 0, 'blocked_fan');

INSERT INTO Match VALUES 
	('12-14-2022 09:00:00', '12-14-2022 10:30:00', 1, 2, 1), 
	('12-15-2022 05:00:00', '12-15-2022 06:30:00', 2, 3, 2), 
	('12-15-2022 21:00:00', '12-15-2022 22:30:00', 3, 1, NULL),
	('12-1-2022 21:00:00', '12-1-2022 22:30:00', 4, 1, 4);

INSERT INTO HostRequest VALUES 
	(1, 1, 1, 'unhandled'), 
	(2, 2, 2, 'accepted'),
	(3, 3, 3, 'rejected');

INSERT INTO Ticket VALUES
	(1, 1),
	(1, 1),
	(0, 1),
	(1, 2),
	(0, 2),
	(1, 4),
	(1, 4),
	(1, 4),
	(1, 4);

INSERT INTO TicketBuyingTransactions VALUES
	('id_fan1', 5),
	('id_fan2', 3);


SELECT * FROM allFans;
SELECT * FROM allStadiums;
SELECT * FROM allRequests;

EXEC addStadium 'Stadium 4', "Egypt", 1000;
SELECT * FROM Stadium;

EXEC deleteClub "Club 3";
SELECT * FROM Club;

EXEC unblockFan "id_blocked_fan";

EXEC addRepresentative 'CR 4', 'Club 3', 'cr4', 'pass_cr4';
SELECT * FROM ClubRepresentative;

-- TODO: Test remaining procedures and functions.

INSERT INTO Club VALUES ('Tersana', 'Cairo');
INSERT INTO Club VALUES ('Arsenal', 'London');
INSERT INTO SystemUser VALUES ('rafeek' , '1223');
INSERT INTO ClubRepresentative VALUES ('Raf', 'rafeek', 1);

SELECT *
FROM allClubRepresentatives

SELECT * FROM allAssocManagers;
SELECT * FROM allClubRepresentatives;
SELECT * FROM allStadiumManagers;
SELECT * FROM allFans;
SELECT * FROM allMatches;
SELECT * FROM allTickets;
SELECT * FROM allCLubs;
SELECT * FROM allStadiums;
SELECT * FROM allRequests;

EXEC addAssociationManager 'SAM 3', 'sam3', 'pass_sam3'
EXEC addNewMatch 'Club 1', 'Club 3', '12-18-2022 05:00:00', '12-18-2022 06:30:00'

SELECT * FROM clubsWithNoMatches;

EXEC deleteMatch 'Club 1', 'Club 3'
EXEC addClub 'Club 4', 'Poland'

SELECT * FROM Match

EXEC deleteMatchesOnStadium 'Stadium 2'
EXEC addTicket 'Club 2', 'Club 3', '2022-12-15 05:00:00';
EXEC deleteClub 'Club 1'
EXEC addStadium 'Stadium 4', 'UK', 4;
EXEC deleteStadium 'Stadium 1'
EXEC blockFan 'id_fan1'
EXEC unblockFan 'id_fan1'
EXEC addRepresentative 'CR4', 'Club 4', 'cr4', 'pass_cr4'

SELECT * FROM viewAvailableStadiumsOn('2022-12-15 04:30:00');

EXEC addHostRequest 'Club 4', 'Stadium 2', '12-1-2022 21:00:00'
SELECT * FROM dbo.allUnassignedMatches('Club 3') 
EXEC addStadiumManager 'SM 4', 'Stadium 4', 'sm4', 'pass_sm4'
SELECT * FROM allPendingRequests('sm1')

EXEC addHostRequest 'Club 3', 'Stadium 3', '12-15-2022 21:00:00'
EXEC acceptRequest 'sm1', 'Club 3', 'Club 1', '12-15-2022 21:00:00'
SELECT * FROM Match