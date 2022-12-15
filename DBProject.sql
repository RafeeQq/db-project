CREATE DATABASE Project;

USE Project;

GO
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
GO

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
GO

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
GO

CREATE PROC dropAllProceduresFunctionsViews --SNAP
AS
	DROP PROC createAllTables;
	DROP PROC dropAllTables;
	DROP PROC clearAllTables;
GO

--f
CREATE VIEW allTickets
AS
SELECT C1.name, C2.name, Stadium.name, Match.start_time
FROM Ticket
INNER JOIN Match ON Ticket.match_id = Match.id
INNER JOIN Stadium ON Match.stadium_id = Stadium.id
INNER JOIN Club C1 ON Match.host_club_id = C1.id
INNER JOIN Club C2 ON Match.guest_club_id = C2.id
WHERE C1 <> C2
GO

--g
CREATE VIEW allClubs
AS
SELECT name, location
FROM Clubs
GO

--x
CREATE PROC deleteStadium
@n VARCHAR(20)
AS
DELETE FROM Stadium WHERE @n = Stadium.name
GO

--xi (blocked = 0)
CREATE PROC blockFan
@n VARCHAR(20)
AS
UPDATE Fan
SET status = 0
WHERE @n = fan.national_id
GO

--xviii
CREATE FUNCTION allPendingRequests
(@m VARCHAR(20))
RETURNS TABLE
RETURN (SELECT ClubRepresentative.name, Club.name, Match.start_time
FROM HostRequest
INNER JOIN ClubRepresentative ON HostRequest.club_representative_id = ClubRepresentative.id
INNER JOIN Match ON HostRequest.match_id = Match.id
INNER JOIN Club ON Match.guest_club_id = Club.id
INNER JOIN StadiumManager ON HostRequest.stadium_manager_id = StadiumManager.id
WHERE @m = StadiumManager.id)
GO

CREATE PROC generateTickets
@i INT, @s INT
AS
DECLARE @c INT = 0;
WHILE @c < @s
BEGIN
INSERT INTO TICKETS VALUES (1,@i);
SET @c = @c+1;
END;
GO

--xix
CREATE PROC acceptRequest
@m VARCHAR (20),
@h VARCHAR (20),
@g VARCHAR (20),
@d DATETIME
AS
UPDATE HostRequest
SET status = 'accepted'
WHERE id = (
SELECT id
FROM HostRequest
INNER JOIN StadiumManager ON HostRequest.stadium_manager_id = StadiumManager.id
INNER JOIN Match ON HostRequest.match_id = Match.id
INNER JOIN Club C1 ON Match.host_club_id = C1.id
INNER JOIN Club C2 ON Match.guest_club_id = C2.id
WHERE @m = StadiumManager.username AND @d = Match.start_time AND @h = C1.name AND @g = C2.name
);
--EXEC PROC generateTickets (Match.id, Stadium.capacity)
GO

--xx
CREATE PROC rejectRequest
@m VARCHAR (20),
@h VARCHAR (20),
@g VARCHAR (20),
@d DATETIME
AS
UPDATE HostRequest
SET status = 'rejected'
WHERE id = (
SELECT id
FROM HostRequest
INNER JOIN StadiumManager ON HostRequest.stadium_manager_id = StadiumManager.id
INNER JOIN Match ON HostRequest.match_id = Match.id
INNER JOIN Club C1 ON Match.host_club_id = C1.id
INNER JOIN Club C2 ON Match.guest_club_id = C2.id
WHERE @m = StadiumManager.username AND @d = Match.start_time AND @h = C1.name AND @g = C2.name AND C1 <> C2
);
GO

--xxii
CREATE FUNCTION upcomingMatchesOfClub
(@c VARCHAR(20))
RETURNS TABLE
RETURN (SELECT C1.name, C2.name, Match.start_time, Stadium.name
FROM Match
INNER JOIN Stadium ON Match.stadium_id = Stadium.id
INNER JOIN Club C1 ON C1.id = Match.host_club_id
INNER JOIN Club C2 ON C2.id = Match.guest_club_id
WHERE Match.start_time > CURRENT_TIMESTAMP AND C1.name <> C2.name)
GO

--xxvii
CREATE VIEW clubsNeverMatched
AS
SELECT C1.name, C2.name
FROM Club
WHERE NOT EXISTS (
SELECT C1.name, C2.name
FROM Club C1
INNER JOIN Match ON C1.id = Match.host_club_id
INNER JOIN Club C2 ON Match.guest_club_id = C2.id
);
GO
