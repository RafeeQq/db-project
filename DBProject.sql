CREATE DATABASE Project;

USE Project;

GO
CREATE PROC createAllTables
AS
	CREATE TABLE SystemUser (
		username VARCHAR(20) PRIMARY KEY,
		password VARCHAR(20) NOT NULL
	);

	CREATE TABLE Stadium (
		id INT IDENTITY PRIMARY KEY,
		status BIT NOT NULL, --not available 0 or available 1
		name VARCHAR(20) NOT NULL,
		location VARCHAR(20) NOT NULL,
		capacity INT NOT NULL
	);

	CREATE TABLE StadiumManager (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		username VARCHAR(20),
		stadium_id INT NOT NULL,
		CONSTRAINT PK_StadiumManager PRIMARY KEY (id, username),
		CONSTRAINT FK_StadiumManager_SystemUser FOREIGN KEY (username) REFERENCES SystemUser,
		CONSTRAINT FK_StadiumManager_Stadium FOREIGN KEY (stadium_id) REFERENCES Stadium
	);

	CREATE TABLE Club (
		id INT PRIMARY KEY IDENTITY,
		name VARCHAR(20) NOT NULL,
		location VARCHAR(20) NOT NULL,
	);

	CREATE TABLE ClubRepresentative (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		username VARCHAR(20),
		club_id INT NOT NULL,
		CONSTRAINT PK_ClubRepresentative PRIMARY KEY (id, username),
		CONSTRAINT FK_ClubRepresentative_SystemUser FOREIGN KEY (username) REFERENCES SystemUser,
		CONSTRAINT FK_ClubRepresentative_Club FOREIGN KEY (club_id) REFERENCES Club
	);

	CREATE TABLE Fan (
		national_id VARCHAR(20),
		phone_number INT NOT NULL,
		name VARCHAR(20) NOT NULL,
		address VARCHAR(20) NOT NULL,
		status BIT NOT NULL DEFAULT '0', -- blocked 1 or not 0 
		birth_date DATETIME NOT NULL,
		username VARCHAR(20),
		password VARCHAR(20),
		CONSTRAINT PK_Fan PRIMARY KEY (national_id, username),
		CONSTRAINT FK_Fan_SystemUser FOREIGN KEY (username) REFERENCES SystemUser
	);

	CREATE TABLE SportsAssociationManager (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		username VARCHAR(20),
		CONSTRAINT PK_SportsAssociationManager PRIMARY KEY (id, username),
		CONSTRAINT FK_SportsAssociationManager_SystemUser FOREIGN KEY (username) REFERENCES SystemUser
	);

	CREATE TABLE SystemAdmin (
		id INT IDENTITY,
		name VARCHAR(20) NOT NULL,
		username VARCHAR(20),
		CONSTRAINT PK_SystemAdmin PRIMARY KEY (id, username),
		CONSTRAINT FK_SystemAdmin_SystemUser FOREIGN KEY (username) REFERENCES SystemUser
	);

	CREATE TABLE Match (
		id INT PRIMARY KEY IDENTITY,
		start_time DATETIME NOT NULL,
		end_time DATETIME NOT NULL,
		stadium_id INT,
		host_id INT NOT NULL,
		guest_id INT NOT NULL,
		CONSTRAINT FK_Match_Stadium FOREIGN KEY (stadium_id) REFERENCES Stadium,
		CONSTRAINT FK_Match_Host FOREIGN KEY (host_id) REFERENCES Club,
		CONSTRAINT FK_Match_Guest FOREIGN KEY (guest_id) REFERENCES Club
	);

	CREATE TABLE HostRequest (
		id INT PRIMARY KEY IDENTITY,
		status VARCHAR(20) CHECK (status IN ('unhandled', 'accepted', 'rejected')),
		match_id INT NOT NULL,
		stadium_manager_id INT NOT NULL,
		stadium_manager_username VARCHAR(20) NOT NULL,
		club_representative_id INT NOT NULL,
		club_representative_username VARCHAR(20) NOT NULL,
		CONSTRAINT FK_HostRequest_Match FOREIGN KEY (match_id) REFERENCES Match,
		CONSTRAINT FK_HostRequest_StadiumManager FOREIGN KEY (stadium_manager_id, stadium_manager_username) REFERENCES StadiumManager,
		CONSTRAINT FK_HostRequest_ClubRepresentative FOREIGN KEY (club_representative_id, club_representative_username) REFERENCES ClubRepresentative
	);

	CREATE TABLE Ticket (
		id INT PRIMARY KEY IDENTITY,
		status BIT NOT NULL, --sold 0 or available 1
		match_id INT NOT NULL,
		fan_id VARCHAR(20),
		fan_username VARCHAR(20),
		CONSTRAINT FK_Ticket_Match FOREIGN KEY (match_id) REFERENCES Match,
		CONSTRAINT FK_Ticket_Fan FOREIGN KEY (fan_id, fan_username) REFERENCES Fan
	);
GO

CREATE PROC dropAllTables
AS
	DROP TABLE Ticket;
	DROP TABLE SportsAssociationManager;
	DROP TABLE HostRequest;
	DROP TABLE StadiumManager;
	DROP TABLE Fan;
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


--b
CREATE VIEW allClubRepresentatives
AS
SELECT ClubRepresentative.username,ClubRepresentative.password, ClubRepresentative.name, Club.name AS represented_club_name
FROM ClubRepresentative INNER JOIN Club ON ClubRepresentative.club_id = Club.id;
GO




--e
GO
CREATE VIEW allMatches
AS
(SELECT C.name AS host,C2.name AS guest, Match.start_time  
FROM Club AS C INNER JOIN Match ON C.id = Match.host_id INNER JOIN Club AS C2 ON C2.id = Match.guest_id)
UNION 
(SELECT C.name AS host,C2.name AS guest, Match.start_time  
FROM Club AS C2 INNER JOIN Match ON C2.id = Match.guest_id INNER JOIN Club AS C ON C.id = Match.host_id)

--II
GO 
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
	
INSERT INTO Match VALUES (@start_time, @end_time, NULL, @host_id, @guest_id);
GO

--IV
CREATE PROC deleteMatch
@host VARCHAR(20),
@guest VARCHAR(20)
AS
DECLARE @host_id INT;
DECLARE @guest_id INT;
	SELECT @host_id = Club.id
	FROM Club
	WHERE Club.name = @host_id;

	SELECT @guest_id = Club.id
	FROM Club
	WHERE Club.name = @guest;

	SELECT @host_id = Club.id
	FROM Club
	WHERE Club.name = @guest;

	DELETE FROM Match 
	WHERE Match.host_id = @host_id AND Match.guest_id = @guest_id;

GO

--V
CREATE PROC deleteMatchesOnStadium
@stadium VARCHAR(20)
AS
DECLARE @stadium_id INT
	SELECT @stadium_id = Stadium.id
	FROM Stadium
	WHERE Stadium.name = @stadium;

DELETE FROM Match
WHERE Match.stadium_id = @stadium_id AND start_time > CURRENT_TIMESTAMP;
GO

--VI
CREATE PROC addClub
@club_name VARCHAR(20),
@club_location VARCHAR(20)
AS
INSERT INTO Club VALUES (@club_name, @club_location);
GO

--XVI
CREATE FUNCTION allUnassignedMatches
(@club VARCHAR(20))
RETURNS TABLE
AS 
BEGIN
DECLARE @club_id INT
	SELECT @club_id = Club.id
	FROM Club
	WHERE Club.name = @club
RETURN (SELECT DISTINCT Club.name, Match.start_time
		FROM Match, Club
		WHERE Match.guest_id = Club.id AND Match.host_id = @club_id
			AND Match.stadium_id = NULL);
END
GO
--XXI
CREATE PROC addFan
@fan_name VARCHAR(20),
@username VARCHAR(20),
@password VARCHAR(20),
@national_id_number VARCHAR(20),
@birth_date DATETIME,
@address VARCHAR(20),
@phone_number INT
AS
INSERT INTO Fan VALUES (@national_id_number, @phone_number, @fan_name, @address, '1', @birth_date, @password)
GO


--XXV
CREATE PROC updateMatchHost
@old_host_name VARCHAR(20),
@old_guest_name VARCHAR(20),
@match_date DATETIME
AS
DECLARE @new_host_id INT
DECLARE @new_guest_id INT
	SELECT @new_host_id = Club.id
	FROM Club
	WHERE Club.name = @old_guest_name;

	SELECT @new_guest_id = Club.id
	From Club
	WHERE Club.name = @old_host_name;

UPDATE Match
SET Match.host_id = @new_host_id , Match.guest_id = @new_guest_id
WHERE Match.host_id = @new_guest_id AND Match.guest_id = @new_host_id AND Match.start_time = @match_date;
GO

--XXVI
GO
CREATE VIEW matchesPerTeam
AS
(SELECT Club.name, COUNT(*)
FROM Club INNER JOIN MATCH ON Club.id = Match.host_id
GROUP BY Club.name)
UNION 
(SELECT Club.name, COUNT(*)
FROM Club INNER JOIN MATCH ON Club.id = Match.guest_id
GROUP BY Club.name)
GO

--XXIX
CREATE FUNCTION matchWithHighestAttendance
()
RETURNS TABLE
AS
RETURN(SELECT MAX(X)
		FROM (SELECT X = Host.name, Guest.name, Count(*)
				FROM Club AS Host INNER JOIN Match ON Match.host_id = Host.id
				INNER JOIN Club AS Guest ON Match.guest_id = Guest.id  
				INNER JOIN Ticket ON Ticket.match_id = Match.id
				GROUP BY Host.name, Guest.name
				HAVING Ticket.status = '0'
			)
GO

INSERT INTO Club VALUES ('Tersana', 'Cairo');
INSERT INTO Club VALUES ('Arsenal', 'London');
INSERT INTO SystemUser VALUES ('rafeek' , '1223');
INSERT INTO ClubRepresentative VALUES ('Raf', 'rafeek', 1);

SELECT *
FROM allClubRepresentatives

EXEC dropAllTables
EXEC createAllTables