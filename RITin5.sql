// SQL population

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
    FROM results
    WHERE Match_ID=Match_ID_Input;

    SELECT AwayTeamScore INTO AwayScore
    FROM results
    WHERE Match_ID=Match_ID_Input;

    -- determining higher score
    IF HomeScore > AwayScore THEN
        SELECT HomeTeamName INTO Winner
        FROM match
        WHERE Match_ID=Match_ID_Input;
        SELECT AwayTeamName INTO Loser
        FROM match
        WHERE Match_ID=Match_ID_Input;
        WinnerScore = HomeScore;
        LoserScore = AwayScore;

    ELSE
        SELECT AwayTeamName INTO Winner
        FROM match
        WHERE Match_ID=Match_ID_Input;
        SELECT HomeTeamName INTO Loser
        FROM match
        WHERE Match_ID=Match_ID_Input;
        WinnerScore = AwayScore;
        LoserScore = HomeScore;
    END IF;

END$$

DELIMITER ;
