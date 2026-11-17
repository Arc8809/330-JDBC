DROP DATABASE IF EXISTS ESports
CREATE DATABASE ESports;
USE ESports;

CREATE TABLE UserAccount (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    UserType VARCHAR(10),
    FirstName VARCHAR(25),
    LastName VARCHAR(25),
    Username VARCHAR(40) UNIQUE,
    Password VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE Players (
    Player_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES UserAccount(User_ID)
) ENGINE=InnoDB;


CREATE TABLE Coaches (
    Coach_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES UserAccount(User_ID)
) ENGINE=InnoDB;

CREATE TABLE Directors (
    Director_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES UserAccount(User_ID)
) ENGINE=InnoDB;


CREATE TABLE Teams (
    TeamName VARCHAR(100) PRIMARY KEY,
    Coach_ID INT,
    DateCreated DATE,
    FOREIGN KEY (Coach_ID) REFERENCES Coaches(Coach_ID)
) ENGINE=InnoDB;


CREATE TABLE TeamMembership (
    Membership_ID INT PRIMARY KEY AUTO_INCREMENT,
    Player_ID INT NOT NULL,
    TeamName VARCHAR(100) NOT NULL,
    DatePlayerJoined DATE,
    DatePlayerLeft DATE,
    FOREIGN KEY (Player_ID) REFERENCES Players(Player_ID),
    FOREIGN KEY (TeamName) REFERENCES Teams(TeamName)
) ENGINE=InnoDB;


CREATE TABLE Games (
    Game_ID INT PRIMARY KEY AUTO_INCREMENT,
    GameName VARCHAR(100)
) ENGINE=InnoDB;


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


CREATE TABLE Matches (
    Match_ID INT PRIMARY KEY AUTO_INCREMENT,
    Tournament_ID INT NOT NULL,
    HomeTeamName VARCHAR(100) NOT NULL,
    AwayTeamName VARCHAR(100) NOT NULL,
    Game_ID INT NOT NULL,
    Match_Date DATETIME,
    Status VARCHAR(20),
    FOREIGN KEY (Tournament_ID) REFERENCES Tournaments(Tournament_ID),
    FOREIGN KEY (HomeTeamName) REFERENCES Teams(TeamName),
    FOREIGN KEY (AwayTeamName) REFERENCES Teams(TeamName),
    FOREIGN KEY (Game_ID) REFERENCES Games(Game_ID)
) ENGINE=InnoDB;


CREATE TABLE TournamentResults (
    Match_ID INT PRIMARY KEY,
    AwayTeamScore INT,
    HomeTeamScore INT,
    FOREIGN KEY (Match_ID) REFERENCES Matches(Match_ID)
) ENGINE=InnoDB;


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
USE esports;

DROP TABLE IF EXISTS useraccount;
CREATE TABLE useraccount (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    UserType VARCHAR(10) NOT NULL,
    FirstName VARCHAR(25) NOT NULL,
    LastName VARCHAR(25) NOT NULL,
    Username VARCHAR(40) NOT NULL UNIQUE,
    Password CHAR(40) NOT NULL
);
