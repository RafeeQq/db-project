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
EXEC createAllTables;
GO
CREATE PROC addAssociationManager
@name VARCHAR(20),
@username VARCHAR(20),
@password VARCHAR(20)
AS
	INSERT INTO SystemUser 
	VALUES (@username,@password)

	INSERT INTO SportsAssociationManager
	VALUES(@name , @username)
GO;

CREATE VIEW clubsWithNoMatches
AS
	SELECT C.name 
	FROM Club AS C 
	WHERE C.id NOT IN (SELECT M.guest_club_id FROM Match M UNION SELECT M.host_club_id FROM Match M) 
GO ;

CREATE PROC  addTicket
@hostClub VARCHAR(20),
@guestClub VARCHAR(20),
@startTime DATETIME 
AS 
	DECLARE @matchID INT
	SELECT @matchID = M.id 
	FROM Match M , Club C1 , Club  C2
	WHERE M.guest_club_id = C2.id AND M.host_club_id = C1.id
	AND C1.name = @hostClub AND C2.name = @guestClub AND M.start_time =@startTime

	INSERT INTO Ticket 
	VALUES (1,@matchID)
GO ;
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
GO;
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
GO;

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
GO;
CREATE FUNCTION matchesRankedByAttendance ()
RETURNS TABLE 
AS 
RETURN (
	SELECT C1.name  AS hostClub, C2.name AS guestClub
	FROM Match M ,Club C1 , Club C2 , Ticket T 
	WHERE M.host_club_id =C1.id AND M.guest_club_id = C2.id 
	AND T.match_id = M.id 
	GROUP BY T.match_id
	HAVING T.status = 0 
	ORDER BY COUNT(*) DESC
)
GO; 
CREATE FUNCTION requestsFromClub
(@stadiumName VARCHAR(20),@clubName VARCHAR(20))
RETURNS TABLE 
AS 
RETURN (
	SELECT C1.name , C2.name
	 FROM Match M , Club  C1 , Club C2 , HostRequest H ,Stadium S ,StadiumManager SM
	 WHERE M.host_club_id =C1.id  AND M.guest_club_id = C2.id  
	 AND M.id = H.match_id AND H.stadium_manager_id = SM.id 
	 AND SM.stadium_id = S.id
	 AND C1.name = @clubName  AND S.name = @stadiumName 
)
 GO;
CREATE VIEW allAssocManagers 
AS 
SELECT SU.username , SU.password ,SAM.name
FROM SportsAssociationManager SAM , SystemUser SU 
WHERE SAM.username = SU.username ;
GO;
CREATE VIEW allStadiumManagers
AS 
SELECT SU.username , SU.password ,SM.name AS stadiumMangerName, S.name as stadiumName
FROM StadiumManager SM , Stadium S , SystemUser SU
WHERE SM.stadium_id = S.id AND SM.username = SU.username 
GO;
