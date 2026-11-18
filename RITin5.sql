DROP DATABASE IF EXISTS ESports
CREATE DATABASE ESports;
USE ESports;

DROP TABLE IF EXISTS UserAccount;
CREATE TABLE UserAccount (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    UserType VARCHAR(10),
    FirstName VARCHAR(25),
    LastName VARCHAR(25),
    Username VARCHAR(40) UNIQUE,
    Password CHAR(255)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Players;
CREATE TABLE Players (
    Player_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES UserAccount(User_ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Coaches;
CREATE TABLE Coaches (
    Coach_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES UserAccount(User_ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Directors;
CREATE TABLE Directors (
    Director_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES UserAccount(User_ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Teams;
CREATE TABLE Teams (
    TeamName VARCHAR(100) PRIMARY KEY,
    Coach_ID INT,
    DateCreated DATE,
    FOREIGN KEY (Coach_ID) REFERENCES Coaches(Coach_ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS TeamMembership;
CREATE TABLE TeamMembership (
    Membership_ID INT PRIMARY KEY AUTO_INCREMENT,
    Player_ID INT NOT NULL,
    TeamName VARCHAR(100) NOT NULL,
    DatePlayerJoined DATE,
    DatePlayerLeft DATE,
    FOREIGN KEY (Player_ID) REFERENCES Players(Player_ID),
    FOREIGN KEY (TeamName) REFERENCES Teams(TeamName)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Games;
CREATE TABLE Games (
    Game_ID INT PRIMARY KEY AUTO_INCREMENT,
    GameName VARCHAR(100)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Tournaments;
CREATE TABLE Tournaments (
    Tournament_ID INT PRIMARY KEY AUTO_INCREMENT,
    Director_ID INT NOT NULL,
    Game_ID INT NOT NULL,
    TournamentName VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(20),
    FOREIGN KEY (Director_ID) REFERENCES Directors(Director_ID),
    FOREIGN KEY (Game_ID) REFERENCES Games(Game_ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Matches;
CREATE TABLE Matches (
    Match_ID INT PRIMARY KEY AUTO_INCREMENT,
    HomeTeamName VARCHAR(100) NOT NULL,
    AwayTeamName VARCHAR(100) NOT NULL,
    Game_ID INT NOT NULL,
    Match_Date DATETIME,
    Status VARCHAR(20),
    FOREIGN KEY (HomeTeamName) REFERENCES Teams(TeamName),
    FOREIGN KEY (AwayTeamName) REFERENCES Teams(TeamName),
    FOREIGN KEY (Game_ID) REFERENCES Games(Game_ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS TournamentResults;
CREATE TABLE TournamentResults ( 
    Match_ID INT PRIMARY KEY,
    Tournament_ID INT NOT NULL,
    AwayTeamScore INT,
    HomeTeamScore INT,
    FOREIGN KEY (Match_ID) REFERENCES Matches(Match_ID),
    FOREIGN KEY (Tournament_ID) REFERENCES Tournaments(Tournament_ID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS TournamentRegistration;
CREATE TABLE TournamentRegistration (
    Registration_ID INT PRIMARY KEY AUTO_INCREMENT,
    Tournament_ID INT NOT NULL,
    TeamName VARCHAR(100) NOT NULL,
    DateRegistered DATE,
    Status VARCHAR(20),
    FOREIGN KEY (Tournament_ID) REFERENCES Tournaments(Tournament_ID),
    FOREIGN KEY (TeamName) REFERENCES Teams(TeamName)
) ENGINE=InnoDB;
CREATE DATABASE IF NOT EXISTS esports;



--gets the winner+loser name and scores 
DROP PROCEDURE IF EXISTS GetMatchWinner;
DELIMITER $$

CREATE PROCEDURE GetMatchWinner(
    IN Match_ID_Input INT,
    OUT Winner VARCHAR(100),
    OUT Loser VARCHAR(100),
    OUT WinnerScore INT,
    OUT LoserScore INT
) 
BEGIN
    DECLARE HomeScore INT;
    DECLARE AwayScore INT;

    -- getting team scores
    SELECT HomeTeamScore INTO HomeScore
    FROM TournamentResults
    WHERE Match_ID=Match_ID_Input;

    SELECT AwayTeamScore INTO AwayScore
    FROM TournamentResults
    WHERE Match_ID=Match_ID_Input;

    -- determining higher score
    IF HomeScore > AwayScore THEN
        SELECT HomeTeamName INTO Winner
        FROM matches
        WHERE Match_ID=Match_ID_Input;
        SELECT AwayTeamName INTO Loser
        FROM matches
        WHERE Match_ID=Match_ID_Input;
        SET WinnerScore = HomeScore;
        SET LoserScore = AwayScore;

    ELSE
        SELECT AwayTeamName INTO Winner
        FROM matches
        WHERE Match_ID=Match_ID_Input;
        SELECT HomeTeamName INTO Loser
        FROM matches
        WHERE Match_ID=Match_ID_Input;
        SET WinnerScore = AwayScore;
        SET LoserScore = HomeScore;
    END IF;

END$$

DELIMITER ;
