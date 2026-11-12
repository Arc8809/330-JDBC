
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

-- 1. USER ACCOUNTS
INSERT INTO UserAccount
    (User_ID, UserType, FirstName, LastName, Username, Password)
VALUES
    (1,  'Player',   'Jim',       'Habermas',    'pick1eball4Life',   'REPLACE_WITH_PASSWORD_HASH_01'),
    (2,  'Player',   'Destiny',   'Patton',      'itsyourdestiny',    'REPLACE_WITH_PASSWORD_HASH_02'),
    (3,  'Player',   'Anuj',      'Agrawal',     'aagrandplayer',     'REPLACE_WITH_PASSWORD_HASH_03'),
    (4,  'Player',   'Anderson',  'Cardenas',    'geekyglasses04',    'REPLACE_WITH_PASSWORD_HASH_04'),
    (5,  'Player',   'Colm',      'Mcternan',    'Crchen59',          'REPLACE_WITH_PASSWORD_HASH_05'),
    (6,  'Player',   'Robert',    'Kostin',      'costinyosantity',   'REPLACE_WITH_PASSWORD_HASH_06'),
    (7,  'Player',   'Quinn',     'Reed',        'qreed',             'REPLACE_WITH_PASSWORD_HASH_07'),
    (8,  'Player',   'Skyler',    'Martin',      'smartin',           'REPLACE_WITH_PASSWORD_HASH_08'),
    (9,  'Player',   'Drew',      'Wilson',      'dwilson',           'REPLACE_WITH_PASSWORD_HASH_09'),
    (10, 'Player',   'Alex',      'Rivera',      'arivera',           'REPLACE_WITH_PASSWORD_HASH_10'),
    (11, 'Player',   'Jamie',     'Nguyen',      'jnguyen',           'REPLACE_WITH_PASSWORD_HASH_11'),
    (12, 'Player',   'Casey',     'Thompson',    'cthompson',         'REPLACE_WITH_PASSWORD_HASH_12'),
    (13, 'Coach',    'Dan',       'Bogaard',     'shinyHead4ever',    'REPLACE_WITH_PASSWORD_HASH_13'),
    (14, 'Coach',    'Erik',      'Golen',       'aisupreme',         'REPLACE_WITH_PASSWORD_HASH_14'),
    (15, 'Coach',    'Bryan',     'French',      'frenchfriesrgreat', 'REPLACE_WITH_PASSWORD_HASH_15'),
    (16, 'Coach',    'Betty',     'Hillman',     'billsFan1',         'REPLACE_WITH_PASSWORD_HASH_16'),
    (17, 'Coach',    'Sylvia',    'Perez-Hardy', 'datab8sestar',      'REPLACE_WITH_PASSWORD_HASH_17'),
    (18, 'Coach',    'Lee',       'Foster',      'lfoster',           'REPLACE_WITH_PASSWORD_HASH_18'),
    (19, 'Director', 'Dan',       'Bogaard',     'dandadan34',        'REPLACE_WITH_PASSWORD_HASH_19'),
    (20, 'Director', 'Matt',      'Huenerfauth', 'Hauntthehouse24',   'REPLACE_WITH_PASSWORD_HASH_20');

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
-- GameName references Games.GameName.
INSERT INTO Matches
    (Match_ID, HomeTeamName, AwayTeamName, GameName, Match_Date, Status)
VALUES
    (3001, 'Team Nova',            'Phantom Esports',      'Valorant',
     '2026-09-12 14:00:00', 'Completed'),
    (3002, 'Phantom Esports',      'Team Nova',            'Valorant',
     '2026-09-18 16:00:00', 'Completed'),
    (3003, 'Rift Raiders',         'Blue Nexus',           'League of Legends',
     '2026-12-06 13:00:00', 'Scheduled'),
    (3004, 'Blue Nexus',           'Rift Raiders',         'League of Legends',
     '2026-12-10 15:00:00', 'Scheduled'),
    (3005, 'Payload Pros',         'Overtime & Underpaid', 'Overwatch',
     '2026-10-28 18:00:00', 'Completed'),
    (3006, 'Overtime & Underpaid', 'Payload Pros',         'Overwatch',
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