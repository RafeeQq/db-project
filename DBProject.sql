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
		status BIT NOT NULL, -- not available => 0 / available => 1
		CONSTRAINT PK_Stadium PRIMARY KEY (id)
	);

	CREATE TABLE StadiumManager (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		stadium_id INT NOT NULL,
		username VARCHAR(20) NOT NULL,
		CONSTRAINT PK_StadiumManager PRIMARY KEY (id),
		CONSTRAINT FK_StadiumManager_Stadium FOREIGN KEY (stadium_id) REFERENCES Stadium,
		CONSTRAINT FK_StadiumManager_SystemUser FOREIGN KEY (username) REFERENCES SystemUser
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
		CONSTRAINT FK_ClubRepresentative_Club FOREIGN KEY (club_id) REFERENCES Club,
		CONSTRAINT FK_ClubRepresentative_SystemUser FOREIGN KEY (username) REFERENCES SystemUser
	);

	CREATE TABLE Fan (
		national_id VARCHAR(20),
		name VARCHAR(20) NOT NULL,
		birth_date DATE NOT NULL,
		address VARCHAR(20) NOT NULL,
		phone_number VARCHAR(20) NOT NULL,
		status BIT NOT NULL DEFAULT '0', -- blocked => 1 / not blocked => 0 
		username VARCHAR(20) NOT NULL,
		CONSTRAINT PK_Fan PRIMARY KEY (national_id),
		CONSTRAINT FK_Fan_SystemUser FOREIGN KEY (username) REFERENCES SystemUser
	);

	CREATE TABLE SportsAssociationManager (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		username VARCHAR(20) NOT NULL,
		CONSTRAINT PK_SportsAssociationManager PRIMARY KEY (id),
		CONSTRAINT FK_SportsAssociationManager_SystemUser FOREIGN KEY (username) REFERENCES SystemUser
	);

	CREATE TABLE SystemAdmin (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		username VARCHAR(20) NOT NULL,
		CONSTRAINT PK_SystemAdmin PRIMARY KEY (id),
		CONSTRAINT FK_SystemAdmin_SystemUser FOREIGN KEY (username) REFERENCES SystemUser
	);

	CREATE TABLE Match (
		id INT IDENTITY,
		start_time DATETIME NOT NULL,
		end_time DATETIME NOT NULL,
		host_club_id INT NOT NULL,
		guest_club_id INT NOT NULL,
		stadium_id INT NOT NULL,
		CONSTRAINT PK_MATCH PRIMARY KEY (id),
		CONSTRAINT FK_Match_Host FOREIGN KEY (host_club_id) REFERENCES Club,
		CONSTRAINT FK_Match_Guest FOREIGN KEY (guest_club_id) REFERENCES Club,
		CONSTRAINT FK_Match_Stadium FOREIGN KEY (stadium_id) REFERENCES Stadium
	);

	CREATE TABLE HostRequest (
		id INT IDENTITY,
		club_representative_id INT NOT NULL,
		stadium_manager_id INT NOT NULL,
		match_id INT NOT NULL,
		status VARCHAR(20) CHECK (status IN ('unhandled', 'accepted', 'rejected')),
		CONSTRAINT PK_HostRequest PRIMARY KEY (id),
		CONSTRAINT FK_HostRequest_ClubRepresentative FOREIGN KEY (club_representative_id) REFERENCES ClubRepresentative,
		CONSTRAINT FK_HostRequest_StadiumManager FOREIGN KEY (stadium_manager_id) REFERENCES StadiumManager,
		CONSTRAINT FK_HostRequest_Match FOREIGN KEY (match_id) REFERENCES Match
	);

	CREATE TABLE Ticket (
		id INT IDENTITY,
		status BIT NOT NULL, -- sold => 0 / available => 1
		match_id INT NOT NULL,
		CONSTRAINT PK_Ticket PRIMARY KEY (id),
		CONSTRAINT FK_Ticket_Match FOREIGN KEY (match_id) REFERENCES Match,
	);

	CREATE TABLE TicketBuyingTransactions (
		fan_national_id VARCHAR(20) NOT NULL,
		ticket_id INT NOT NULL,
		CONSTRAINT PK_TicketBuyingTransactions PRIMARY KEY (ticket_id),
		CONSTRAINT FK_TicketBuyingTransactions_Fan FOREIGN KEY (fan_national_id) REFERENCES Fan,
		CONSTRAINT FK_TicketBuyingTransactions_Ticket FOREIGN KEY (ticket_id) REFERENCES Ticket
	);
------------------------------------------------------------------------------------

-- TODO: Remove this line before submitting
EXEC createAllTables

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

---------------------------------------- 2.2d --------------------------------------
-- TODO: Should status be returned as a string or as a bit?
CREATE VIEW allFans
AS
	SELECT name, national_id, birth_date, status FROM Fan;
------------------------------------------------------------------------------------

GO

--------------------------------------- 2.2h ---------------------------------------
-- TODO: Should status be returned as a string or as a bit?
CREATE VIEW allStadiums
AS
	SELECT name, location, capacity, status
	FROM Stadium;
------------------------------------------------------------------------------------

GO

--------------------------------------- 2.2i ---------------------------------------
-- TODO: How to represent the status of the request? String?
CREATE VIEW allRequests
AS
	SELECT CR.name AS club_representative_name, SM.name AS stadium_manager_name, R.status
	FROM HostRequest R, ClubRepresentative CR, StadiumManager SM
	WHERE R.club_representative_id = CR.id AND R.stadium_manager_id = SM.id
------------------------------------------------------------------------------------

GO

--------------------------------------- VIII ---------------------------------------
CREATE PROC deleteClub
	@club_name VARCHAR(20)
AS
	DELETE FROM Club WHERE name = @club_name;
------------------------------------------------------------------------------------

GO

---------------------------------------- IX ----------------------------------------
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
	SET status = 0
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
-- TODO: Again, what should date be?
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

---------------------------------------- XXIII --------------------------------------
-- TODO: What exactly is match start date?
CREATE FUNCTION availableMatchesToAttend(@date DATE)
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
-- TODO: Should status 0 be used for sold or for available?
-- TODO: What is date for the match? Is it start datetime?
-- TODO: Ticket Status can be derived from a function?
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
	SELECT @ticket_id = id FROM Ticket WHERE match_id = @match_id AND status = 1;
	
	UPDATE Ticket
	SET status = 0
	WHERE id = @ticket_id;
	
	INSERT INTO TicketBuyingTransactions (fan_national_id, ticket_id)
	VALUES (@fan_national_id, @ticket_id);
------------------------------------------------------------------------------------

GO

---------------------------------------- XXV --------------------------------------
-- TODO: Yet again, what the hell is the date of the match?! Is it the date of the start date or the end date?
-- TODO: Should start time and end time be derived?
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

