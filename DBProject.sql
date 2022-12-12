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
		CONSTRAINT FK_Match_Stadium FOREIGN KEY (stadium_id) REFERENCES Stadium ON DELETE CASCADE
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
	SELECT SU.username , SU.password ,SAM.name
	FROM SportsAssociationManager SAM , SystemUser SU 
	WHERE SAM.username = SU.username ;
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.2b --------------------------------------
CREATE VIEW allClubRepresentatives
AS
	SELECT ClubRepresentative.username, ClubRepresentative.name, Club.name AS represented_club_name
	FROM ClubRepresentative INNER JOIN Club ON ClubRepresentative.club_id = Club.id;
------------------------------------------------------------------------------------

GO

---------------------------------------- 2.2c --------------------------------------
CREATE VIEW allStadiumManagers
AS 
	SELECT SU.username , SU.password ,SM.name AS stadiumMangerName, S.name as stadiumName
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
SELECT C. 
FROM 
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
	@first_club VARCHAR(20),
	@second_club VARCHAR(20),
	@host VARCHAR(20),
	@start_time DATETIME,
	@end_time DATETIME
AS
	DECLARE @first_club_id INT;
	DECLARE @second_club_id INT;
	DECLARE @stadium_id INT;

	SELECT @first_club_id = Club.id
	FROM Club
	WHERE Club.name = @first_club;

	SELECT @second_club_id = Club.id
	FROM Club
	WHERE Club.name = @first_club;
	
	IF @host = @first_club
	BEGIN
		INSERT INTO Match VALUES (@start_time, @end_time, NULL, @first_club_id, @second_club_id);
	END
	ELSE
	BEGIN
		INSERT INTO Match VALUES (@start_time, @end_time, NULL, @second_club_id, @first_club_id);
	END
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
	@first_club VARCHAR(20),
	@second_club VARCHAR(20),
	@host VARCHAR(20)
AS
	DECLARE @first_club_id INT;
	DECLARE @second_club_id INT;
	DECLARE @host_id INT;

	SELECT @first_club_id = Club.id
	FROM Club
	WHERE Club.name = @first_club;

	SELECT @second_club_id = Club.id
	FROM Club
	WHERE Club.name = @first_club;

	SELECT @host_id = Club.id
	FROM Club
	WHERE Club.name = @host;

	IF @host = @first_club
	BEGIN
		DELETE FROM Match 
		WHERE Match.host_id = @first_club_id AND Match.guest_id = @second_club_id;
	END
	ELSE
	BEGIN
		DELETE FROM Match 
		WHERE Match.host_id = @second_club_id AND Match.guest_id = @first_club_id;
	END
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
	FROM Match M , Club C , Stadium S
	WHERE M.host_club_id = C.id AND M.stadium_id = S.id
	AND C.name = @clubName AND S.name =@stadiumName 
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
	VALUES(@username , @password) ;

	INSERT INTO StadiumManager 
	VALUES (@name,@stadiumID,@username);
------------------------------------------------------------------------------------

GO

-------------------------------------- XXI -----------------------------------------
CREATE PROC addFan
	@fan_name VARCHAR(20),
	@national_id_number VARCHAR(20),
	@birth_date DATETIME,
	@address VARCHAR(20),
	@phone_number INT
AS
	INSERT INTO Fan VALUES (@national_id_number, @phone_number, @fan_name, @address, '0', @birth_date, NULL)
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

-------------------------------------- XXVII --------------------------------------
CREATE FUNCTION [clubsNeverPlayed] 
(@clubName VARCHAR(20))
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
CREATE FUNCTION clubsNeverPlayed(@club_name VARCHAR(20))
RETURNS TABLE
AS
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
	('Club 3', 'Germany');

INSERT INTO Stadium VALUES 
	('Stadium 1', 'Egypt', 1000, 1), 
	('Stadium 2', 'Egypt', 2000, 1), 
	('Stadium 3', 'Germany', 2000, 1);

INSERT INTO ClubRepresentative VALUES 
	('CR 1', 1, 'cr1'), 
	('CR 2', 2, 'cr2'), 
	('CR 3', 2, 'cr3');

INSERT INTO StadiumManager VALUES 
	('SM 1', 1, 'sm1'), 
	('SM 2', 2, 'sm2'), 
	('SM 3', 3, 'sm3');

INSERT INTO Fan VALUES
	('id_fan1', 'Fan 1', '1-1-2000', 'Address 1', '0123456789', 1, 'fan1'),
	('id_fan2', 'Fan 2', '1-5-2001', 'Address 2', '0123456789', 1, 'fan2'),
	('id_blocked_fan', 'Blocked Fan', '10-9-2001', 'Address 3', '0123456789', 0, 'blocked_fan');

INSERT INTO Match VALUES 
	('12-14-2022', '12-14-2022', 1, 2, 1), 
	('12-15-2022', '12-15-2022', 2, 3, 2), 
	('12-15-2022', '12-15-2022', 3, 1, NULL);

INSERT INTO HostRequest VALUES 
	(1, 1, 1, 'unhandled'), 
	(2, 2, 2, 'accepted'),
	(3, 3, 3, 'rejected');

INSERT INTO Ticket VALUES
	(1, 1),
	(1, 1),
	(1, 1),
	(1, 2),
	(0, 2),
	(0, 3);

INSERT INTO TicketBuyingTransactions VALUES
	('id_fan1', 5),
	('id_fan2', 6);


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