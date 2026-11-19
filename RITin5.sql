DROP DATABASE IF EXISTS ESMS;
CREATE DATABASE ESMS;
USE ESMS;

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



-- gets the winner+loser name and scores 
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

-- gets the scores of the most recent games in a tournament
DROP PROCEDURE IF EXISTS GetRecentGameScoresTournament;
DELIMITER $$

CREATE PROCEDURE GetRecentGameScoresTournament(
    IN Tournament_ID_Input INT,
    OUT Winner VARCHAR(100),
    OUT Loser VARCHAR(100),
    OUT WinnerScore INT,
    OUT LoserScore INT
) 
BEGIN
    DECLARE M_ID INT;

    SELECT Match_ID INTO M_ID
    FROM matches JOIN TournamentResults USING(Match_ID)
    WHERE Tournament_ID=Tournament_ID_Input 
    AND status="Completed"
    LIMIT 1;	

    CALL GetMatchWinner(M_ID,Winner,Loser,WinnerScore,LoserScore);

END$$

DELIMITER ;




-- ============================================================
-- Esports Organization Database
-- Fictional/sample records created using ChatGPT. 
--
-- Password values are placeholders. Use securely generated
-- password hashes before using real accounts.
-- ============================================================

-- Optional cleanup: uncomment to clear existing sample data.
-- Delete child records before parent records to respect foreign keys.

DELETE FROM TournamentResults;
DELETE FROM Matches;
DELETE FROM TournamentRegistration;
DELETE FROM TeamMembership;
DELETE FROM Tournaments;
DELETE FROM Teams;
DELETE FROM Games;
DELETE FROM Directors;
DELETE FROM Coaches;
DELETE FROM Players;
DELETE FROM UserAccount;

-- 1. USER ACCOUNTS (Passwords are 'pass1', 'pass2', 'pass3', etc. matching the User_ID)
INSERT INTO UserAccount
    (User_ID, UserType, FirstName, LastName, Username, Password)
VALUES
    (1,  'Player',   'Jim',       'Habermas',    'pick1eball4Life',   'f0578f1e7174b1a41c4ea8c6e17f7a8a3b88c92a'),
    (2,  'Player',   'Destiny',   'Patton',      'itsyourdestiny',    '8be52126a6fde450a7162a3651d589bb51e9579d'),
    (3,  'Player',   'Anuj',      'Agrawal',     'aagrandplayer',     'de2a4d5751ab06dc4f987142db57c26d50925c8a'),
    (4,  'Player',   'Anderson',  'Cardenas',    'geekyglasses04',    '2db4c1811f424582a90f8d7ee77995cf018d9443'),
    (5,  'Player',   'Colm',      'Mcternan',    'Crchen59',          '9e5ca6b0ffb417997ffb844c76f9c24bbc20fe88'),
    (6,  'Player',   'Dan',       'Weil',        'dandadan34',        'b8de6df1561cd7ab6af36d0cb706b2168b4f4c69'),
    (7,  'Player',   'Quinn',     'Reed',        'qreed',             '8a337f7233833c6cd96370d64adbd55f49b30db2'),
    (8,  'Player',   'Skyler',    'Martin',      'smartin',           '2c186a6f0dda5aa237254943899d4fee0ab15dd0'),
    (9,  'Player',   'Drew',      'Wilson',      'dwilson',           'e74e5641aa1bea180e9a50cf7f269e6f0e28e341'),
    (10, 'Player',   'Alex',      'Rivera',      'arivera',           '17005c1048dda67c3f735014f33625dfd0c89d32'),
    (11, 'Player',   'Jamie',     'Nguyen',      'jnguyen',           '0808f4f387948ca6e398f4030e8ee19d74c5883e'),
    (12, 'Player',   'Casey',     'Thompson',    'cthompson',         '4e05d4fa6439a3daf2b853e3df1858d42e861df1'),
    (13, 'Coach',    'Robert',    'Kostin',      'costinyosantity',   'e23e98b3ba8e88821c3d15d8584656069e220db8'),
    (14, 'Coach',    'Erik',      'Golen',       'aisupreme',         '55e28fa0e928e7427b2d45301b1953655ec8587d'),
    (15, 'Coach',    'Bryan',     'French',      'frenchfriesrgreat', '9974f6dca69a8f974864ba5d1b7ad655ff6db74c'),
    (16, 'Coach',    'Betty',     'Hillman',     'billsFan1',         '48dba552b48a80df8bfa91f877bcfa029133cdec'),
    (17, 'Coach',    'Sylvia',    'Perez-Hardy', 'datab8sestar',      'c08f0699e04675a0f6d9738502060e5a3e0510e6'),
    (18, 'Coach',    'Lee',       'Foster',      'lfoster',           '5a032830ea6db6e3f7117e2661968e74331f4f3a'),
    (19, 'Director', 'Dan',       'Bogaard',     'shinyHead4ever',    '7c816708ff015453787c83c4d0c00ddf93357fd3'),
    (20, 'Director', 'Matt',      'Huenerfauth', 'Hauntthehouse24',   'afbeceb482e29420c3149552ba94d7ccfa1f058b');

-- 2. ROLE-SPECIFIC RECORDS
INSERT INTO Players (Player_ID, User_ID)
VALUES
    (101, 1), (102, 2), (103, 3), (104, 4),
    (105, 5), (106, 6), (107, 7), (108, 8),
    (109, 9), (110, 10), (111, 11), (112, 12);

INSERT INTO Coaches (Coach_ID, User_ID)
VALUES
    (201, 13), (202, 14), (203, 15),
    (204, 16), (205, 17), (206, 18);

INSERT INTO Directors (Director_ID, User_ID)
VALUES
    (301, 19), (302, 20);

-- 3. GAMES
INSERT INTO Games (Game_ID, GameName)
VALUES
    (1, 'Valorant'),
    (2, 'League of Legends'),
    (3, 'Overwatch'),
    (4, 'Call of Duty'),
    (5, 'GeoGuessr'),
    (6, 'Tetris'),
    (7, 'Super Smash Bros');

-- 4. TEAMS
-- TeamName is the primary key in the supplied ERD.
INSERT INTO Teams (TeamName, Coach_ID, DateCreated)
VALUES
    ('Team Nova',              201, '2024-08-15'),
    ('Phantom Esports',        202, '2025-09-01'),
    ('Rift Raiders',           203, '2025-08-20'),
    ('Blue Nexus',             204, '2025-10-05'),
    ('Payload Pros',           205, '2025-09-12'),
    ('Overtime & Underpaid',   206, '2025-10-10');

-- 5. TEAM MEMBERSHIPS
-- DatePlayerLeft is NULL for current team members.
INSERT INTO TeamMembership
    (Membership_ID, Player_ID, TeamName, DatePlayerJoined, DatePlayerLeft)
VALUES
    (1001, 101, 'Team Nova',            '2025-08-20', NULL),
    (1002, 102, 'Team Nova',            '2025-08-20', NULL),
    (1003, 103, 'Phantom Esports',      '2025-09-05', NULL),
    (1004, 104, 'Phantom Esports',      '2025-09-05', NULL),
    (1005, 105, 'Rift Raiders',         '2025-08-25', NULL),
    (1006, 106, 'Rift Raiders',         '2025-08-25', NULL),
    (1007, 107, 'Blue Nexus',           '2025-10-08', NULL),
    (1008, 108, 'Blue Nexus',           '2025-10-08', NULL),
    (1009, 109, 'Payload Pros',         '2025-09-18', NULL),
    (1010, 110, 'Payload Pros',         '2025-09-18', NULL),
    (1011, 111, 'Overtime & Underpaid', '2025-10-12', NULL),
    (1012, 112, 'Overtime & Underpaid', '2025-10-12', NULL);

-- 6. TOURNAMENTS
-- Tournament IDs are unique. Dates/statuses are aligned with the
-- project timeline (current sample date: November 2026).
INSERT INTO Tournaments
    (Tournament_ID, Director_ID, Game_ID, TournamentName,
     StartDate, EndDate, Status)
VALUES
    (501, 301, 1, '2026 Valorant Fall Championship',
     '2026-09-10', '2026-09-20', 'Completed'),
    (502, 302, 2, 'League of Legends Winter Invitational',
     '2026-12-05', '2026-12-12', 'Registration Open'),
    (503, 301, 3, 'Overwatch Community Cup',
     '2026-10-25', '2026-11-15', 'In Progress'),
    (504, 302, 5, 'World Travel Championship',
     '2026-12-05', '2026-12-12', 'Registration Open'),
    (505, 301, 7, 'Super Smash Competition',
     '2026-12-15', '2026-12-20', 'Registration Open');

-- 7. TOURNAMENT REGISTRATIONS
INSERT INTO TournamentRegistration
    (Registration_ID, Tournament_ID, TeamName, DateRegistered, Status)
VALUES
    (2001, 501, 'Team Nova',            '2026-08-15', 'Accepted'),
    (2002, 501, 'Phantom Esports',      '2026-08-16', 'Accepted'),
    (2003, 502, 'Rift Raiders',         '2026-10-20', 'Accepted'),
    (2004, 502, 'Blue Nexus',           '2026-10-21', 'Pending'),
    (2005, 503, 'Payload Pros',         '2026-10-01', 'Accepted'),
    (2006, 503, 'Overtime & Underpaid', '2026-10-02', 'Accepted'),
    (2007, 504, 'Team Nova',            '2026-11-01', 'Accepted'),
    (2008, 505, 'Overtime & Underpaid', '2026-11-02', 'Accepted');

-- 8. MATCHES
-- HomeTeamName and AwayTeamName reference Teams.TeamName.
-- Game_ID references Games.GameName.
INSERT INTO Matches
    (Match_ID, HomeTeamName, AwayTeamName, Game_ID, Match_Date, Status)
VALUES
    (3001, 'Team Nova',            'Phantom Esports',      1,
     '2026-09-12 14:00:00', 'Completed'),
    (3002, 'Phantom Esports',      'Team Nova',            1,
     '2026-09-18 16:00:00', 'Completed'),
    (3003, 'Rift Raiders',         'Blue Nexus',           2,
     '2026-12-06 13:00:00', 'Scheduled'),
    (3004, 'Blue Nexus',           'Rift Raiders',         2,
     '2026-12-10 15:00:00', 'Scheduled'),
    (3005, 'Payload Pros',         'Overtime & Underpaid', 3,
     '2026-10-28 18:00:00', 'Completed'),
    (3006, 'Overtime & Underpaid', 'Payload Pros',         3,
     '2026-11-12 18:00:00', 'Scheduled');

-- 9. TOURNAMENT RESULTS
-- Only completed matches have result records in this sample.
INSERT INTO TournamentResults
    (Match_ID, Tournament_ID, AwayTeamScore, HomeTeamScore)
VALUES
    (3001, 501, 1, 2),
    (3002, 501, 2, 3),
    (3005, 503, 1, 3);

-- END OF SAMPLE DATA
