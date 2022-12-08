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
		phone_number VARCHAR(20) NOT NULL,
		name VARCHAR(20) NOT NULL,
		address VARCHAR(20) NOT NULL,
		status BIT NOT NULL DEFAULT '0', -- blocked 1 or not 0 
		birth_date DATE NOT NULL,
		username VARCHAR(20),
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
		stadium_id INT NOT NULL,
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