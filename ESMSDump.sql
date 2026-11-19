-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: esms
-- ------------------------------------------------------
-- Server version	9.7.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'acf290a4-9fea-11f1-a429-6c240873d472:1-1852';

--
-- Table structure for table `coaches`
--

DROP TABLE IF EXISTS `coaches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coaches` (
  `Coach_ID` int NOT NULL AUTO_INCREMENT,
  `User_ID` int NOT NULL,
  PRIMARY KEY (`Coach_ID`),
  KEY `User_ID` (`User_ID`),
  CONSTRAINT `coaches_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `useraccount` (`User_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coaches`
--

LOCK TABLES `coaches` WRITE;
/*!40000 ALTER TABLE `coaches` DISABLE KEYS */;
INSERT INTO `coaches` VALUES (201,13),(202,14),(203,15),(204,16),(205,17),(206,18);
/*!40000 ALTER TABLE `coaches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `directors`
--

DROP TABLE IF EXISTS `directors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `directors` (
  `Director_ID` int NOT NULL AUTO_INCREMENT,
  `User_ID` int NOT NULL,
  PRIMARY KEY (`Director_ID`),
  KEY `User_ID` (`User_ID`),
  CONSTRAINT `directors_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `useraccount` (`User_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=303 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `directors`
--

LOCK TABLES `directors` WRITE;
/*!40000 ALTER TABLE `directors` DISABLE KEYS */;
INSERT INTO `directors` VALUES (301,19),(302,20);
/*!40000 ALTER TABLE `directors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `games`
--

DROP TABLE IF EXISTS `games`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `games` (
  `Game_ID` int NOT NULL AUTO_INCREMENT,
  `GameName` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Game_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `games`
--

LOCK TABLES `games` WRITE;
/*!40000 ALTER TABLE `games` DISABLE KEYS */;
INSERT INTO `games` VALUES (1,'Valorant'),(2,'League of Legends'),(3,'Overwatch'),(4,'Call of Duty'),(5,'GeoGuessr'),(6,'Tetris'),(7,'Super Smash Bros');
/*!40000 ALTER TABLE `games` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matches` (
  `Match_ID` int NOT NULL AUTO_INCREMENT,
  `HomeTeamName` varchar(100) NOT NULL,
  `AwayTeamName` varchar(100) NOT NULL,
  `Game_ID` int NOT NULL,
  `Match_Date` datetime DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Match_ID`),
  KEY `HomeTeamName` (`HomeTeamName`),
  KEY `AwayTeamName` (`AwayTeamName`),
  KEY `Game_ID` (`Game_ID`),
  CONSTRAINT `matches_ibfk_1` FOREIGN KEY (`HomeTeamName`) REFERENCES `teams` (`TeamName`),
  CONSTRAINT `matches_ibfk_2` FOREIGN KEY (`AwayTeamName`) REFERENCES `teams` (`TeamName`),
  CONSTRAINT `matches_ibfk_3` FOREIGN KEY (`Game_ID`) REFERENCES `games` (`Game_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3007 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matches`
--

LOCK TABLES `matches` WRITE;
/*!40000 ALTER TABLE `matches` DISABLE KEYS */;
INSERT INTO `matches` VALUES (3001,'Team Nova','Phantom Esports',1,'2026-09-12 14:00:00','Completed'),(3002,'Phantom Esports','Team Nova',1,'2026-09-18 16:00:00','Completed'),(3003,'Rift Raiders','Blue Nexus',2,'2026-12-06 13:00:00','Scheduled'),(3004,'Blue Nexus','Rift Raiders',2,'2026-12-10 15:00:00','Scheduled'),(3005,'Payload Pros','Overtime & Underpaid',3,'2026-10-28 18:00:00','Completed'),(3006,'Overtime & Underpaid','Payload Pros',3,'2026-11-12 18:00:00','Scheduled');
/*!40000 ALTER TABLE `matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `players` (
  `Player_ID` int NOT NULL AUTO_INCREMENT,
  `User_ID` int NOT NULL,
  PRIMARY KEY (`Player_ID`),
  KEY `User_ID` (`User_ID`),
  CONSTRAINT `players_ibfk_1` FOREIGN KEY (`User_ID`) REFERENCES `useraccount` (`User_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `players`
--

LOCK TABLES `players` WRITE;
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` VALUES (101,1),(102,2),(103,3),(104,4),(105,5),(106,6),(107,7),(108,8),(109,9),(110,10),(111,11),(112,12);
/*!40000 ALTER TABLE `players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teammembership`
--

DROP TABLE IF EXISTS `teammembership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teammembership` (
  `Membership_ID` int NOT NULL AUTO_INCREMENT,
  `Player_ID` int NOT NULL,
  `TeamName` varchar(100) NOT NULL,
  `DatePlayerJoined` date DEFAULT NULL,
  `DatePlayerLeft` date DEFAULT NULL,
  PRIMARY KEY (`Membership_ID`),
  KEY `Player_ID` (`Player_ID`),
  KEY `TeamName` (`TeamName`),
  CONSTRAINT `teammembership_ibfk_1` FOREIGN KEY (`Player_ID`) REFERENCES `players` (`Player_ID`),
  CONSTRAINT `teammembership_ibfk_2` FOREIGN KEY (`TeamName`) REFERENCES `teams` (`TeamName`)
) ENGINE=InnoDB AUTO_INCREMENT=1013 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teammembership`
--

LOCK TABLES `teammembership` WRITE;
/*!40000 ALTER TABLE `teammembership` DISABLE KEYS */;
INSERT INTO `teammembership` VALUES (1001,101,'Team Nova','2025-08-20',NULL),(1002,102,'Team Nova','2025-08-20',NULL),(1003,103,'Phantom Esports','2025-09-05',NULL),(1004,104,'Phantom Esports','2025-09-05',NULL),(1005,105,'Rift Raiders','2025-08-25',NULL),(1006,106,'Rift Raiders','2025-08-25',NULL),(1007,107,'Blue Nexus','2025-10-08',NULL),(1008,108,'Blue Nexus','2025-10-08',NULL),(1009,109,'Payload Pros','2025-09-18',NULL),(1010,110,'Payload Pros','2025-09-18',NULL),(1011,111,'Overtime & Underpaid','2025-10-12',NULL),(1012,112,'Overtime & Underpaid','2025-10-12',NULL);
/*!40000 ALTER TABLE `teammembership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `TeamName` varchar(100) NOT NULL,
  `Coach_ID` int DEFAULT NULL,
  `DateCreated` date DEFAULT NULL,
  PRIMARY KEY (`TeamName`),
  KEY `Coach_ID` (`Coach_ID`),
  CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`Coach_ID`) REFERENCES `coaches` (`Coach_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES ('Blue Nexus',204,'2025-10-05'),('Overtime & Underpaid',206,'2025-10-10'),('Payload Pros',205,'2025-09-12'),('Phantom Esports',202,'2025-09-01'),('Rift Raiders',203,'2025-08-20'),('Team Nova',201,'2024-08-15');
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tournamentregistration`
--

DROP TABLE IF EXISTS `tournamentregistration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tournamentregistration` (
  `Registration_ID` int NOT NULL AUTO_INCREMENT,
  `Tournament_ID` int NOT NULL,
  `TeamName` varchar(100) NOT NULL,
  `DateRegistered` date DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Registration_ID`),
  KEY `Tournament_ID` (`Tournament_ID`),
  KEY `TeamName` (`TeamName`),
  CONSTRAINT `tournamentregistration_ibfk_1` FOREIGN KEY (`Tournament_ID`) REFERENCES `tournaments` (`Tournament_ID`),
  CONSTRAINT `tournamentregistration_ibfk_2` FOREIGN KEY (`TeamName`) REFERENCES `teams` (`TeamName`)
) ENGINE=InnoDB AUTO_INCREMENT=2009 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tournamentregistration`
--

LOCK TABLES `tournamentregistration` WRITE;
/*!40000 ALTER TABLE `tournamentregistration` DISABLE KEYS */;
INSERT INTO `tournamentregistration` VALUES (2001,501,'Team Nova','2026-08-15','Accepted'),(2002,501,'Phantom Esports','2026-08-16','Accepted'),(2003,502,'Rift Raiders','2026-10-20','Accepted'),(2004,502,'Blue Nexus','2026-10-21','Pending'),(2005,503,'Payload Pros','2026-10-01','Accepted'),(2006,503,'Overtime & Underpaid','2026-10-02','Accepted'),(2007,504,'Team Nova','2026-11-01','Accepted'),(2008,505,'Overtime & Underpaid','2026-11-02','Accepted');
/*!40000 ALTER TABLE `tournamentregistration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tournamentresults`
--

DROP TABLE IF EXISTS `tournamentresults`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tournamentresults` (
  `Match_ID` int NOT NULL,
  `Tournament_ID` int NOT NULL,
  `AwayTeamScore` int DEFAULT NULL,
  `HomeTeamScore` int DEFAULT NULL,
  PRIMARY KEY (`Match_ID`),
  KEY `Tournament_ID` (`Tournament_ID`),
  CONSTRAINT `tournamentresults_ibfk_1` FOREIGN KEY (`Match_ID`) REFERENCES `matches` (`Match_ID`),
  CONSTRAINT `tournamentresults_ibfk_2` FOREIGN KEY (`Tournament_ID`) REFERENCES `tournaments` (`Tournament_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tournamentresults`
--

LOCK TABLES `tournamentresults` WRITE;
/*!40000 ALTER TABLE `tournamentresults` DISABLE KEYS */;
INSERT INTO `tournamentresults` VALUES (3001,501,1,2),(3002,501,2,3),(3005,503,1,3);
/*!40000 ALTER TABLE `tournamentresults` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tournaments`
--

DROP TABLE IF EXISTS `tournaments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tournaments` (
  `Tournament_ID` int NOT NULL AUTO_INCREMENT,
  `Director_ID` int NOT NULL,
  `Game_ID` int NOT NULL,
  `TournamentName` varchar(50) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Tournament_ID`),
  KEY `Director_ID` (`Director_ID`),
  KEY `Game_ID` (`Game_ID`),
  CONSTRAINT `tournaments_ibfk_1` FOREIGN KEY (`Director_ID`) REFERENCES `directors` (`Director_ID`),
  CONSTRAINT `tournaments_ibfk_2` FOREIGN KEY (`Game_ID`) REFERENCES `games` (`Game_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=506 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tournaments`
--

LOCK TABLES `tournaments` WRITE;
/*!40000 ALTER TABLE `tournaments` DISABLE KEYS */;
INSERT INTO `tournaments` VALUES (501,301,1,'2026 Valorant Fall Championship','2026-09-10','2026-09-20','Completed'),(502,302,2,'League of Legends Winter Invitational','2026-12-05','2026-12-12','Registration Open'),(503,301,3,'Overwatch Community Cup','2026-10-25','2026-11-15','In Progress'),(504,302,5,'World Travel Championship','2026-12-05','2026-12-12','Registration Open'),(505,301,7,'Super Smash Competition','2026-12-15','2026-12-20','Registration Open');
/*!40000 ALTER TABLE `tournaments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `useraccount`
--

DROP TABLE IF EXISTS `useraccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `useraccount` (
  `User_ID` int NOT NULL AUTO_INCREMENT,
  `UserType` varchar(10) DEFAULT NULL,
  `FirstName` varchar(25) DEFAULT NULL,
  `LastName` varchar(25) DEFAULT NULL,
  `Username` varchar(40) DEFAULT NULL,
  `Password` char(255) DEFAULT NULL,
  PRIMARY KEY (`User_ID`),
  UNIQUE KEY `Username` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `useraccount`
--

LOCK TABLES `useraccount` WRITE;
/*!40000 ALTER TABLE `useraccount` DISABLE KEYS */;
INSERT INTO `useraccount` VALUES (1,'Player','Jim','Habermas','pick1eball4Life','f0578f1e7174b1a41c4ea8c6e17f7a8a3b88c92a'),(2,'Player','Destiny','Patton','itsyourdestiny','8be52126a6fde450a7162a3651d589bb51e9579d'),(3,'Player','Anuj','Agrawal','aagrandplayer','de2a4d5751ab06dc4f987142db57c26d50925c8a'),(4,'Player','Anderson','Cardenas','geekyglasses04','2db4c1811f424582a90f8d7ee77995cf018d9443'),(5,'Player','Colm','Mcternan','Crchen59','9e5ca6b0ffb417997ffb844c76f9c24bbc20fe88'),(6,'Player','Dan','Weil','dandadan34','b8de6df1561cd7ab6af36d0cb706b2168b4f4c69'),(7,'Player','Quinn','Reed','qreed','8a337f7233833c6cd96370d64adbd55f49b30db2'),(8,'Player','Skyler','Martin','smartin','2c186a6f0dda5aa237254943899d4fee0ab15dd0'),(9,'Player','Drew','Wilson','dwilson','e74e5641aa1bea180e9a50cf7f269e6f0e28e341'),(10,'Player','Alex','Rivera','arivera','17005c1048dda67c3f735014f33625dfd0c89d32'),(11,'Player','Jamie','Nguyen','jnguyen','0808f4f387948ca6e398f4030e8ee19d74c5883e'),(12,'Player','Casey','Thompson','cthompson','4e05d4fa6439a3daf2b853e3df1858d42e861df1'),(13,'Coach','Robert','Kostin','costinyosantity','e23e98b3ba8e88821c3d15d8584656069e220db8'),(14,'Coach','Erik','Golen','aisupreme','55e28fa0e928e7427b2d45301b1953655ec8587d'),(15,'Coach','Bryan','French','frenchfriesrgreat','9974f6dca69a8f974864ba5d1b7ad655ff6db74c'),(16,'Coach','Betty','Hillman','billsFan1','48dba552b48a80df8bfa91f877bcfa029133cdec'),(17,'Coach','Sylvia','Perez-Hardy','datab8sestar','c08f0699e04675a0f6d9738502060e5a3e0510e6'),(18,'Coach','Lee','Foster','lfoster','5a032830ea6db6e3f7117e2661968e74331f4f3a'),(19,'Director','Dan','Bogaard','shinyHead4ever','7c816708ff015453787c83c4d0c00ddf93357fd3'),(20,'Director','Matt','Huenerfauth','Hauntthehouse24','afbeceb482e29420c3149552ba94d7ccfa1f058b');
/*!40000 ALTER TABLE `useraccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'esms'
--
/*!50003 DROP PROCEDURE IF EXISTS `GetMatchWinner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMatchWinner`(
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

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetRecentGameScoresTournament` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetRecentGameScoresTournament`(
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
    ORDER BY Match_Date DESC
    LIMIT 1;	

    CALL GetMatchWinner(M_ID,Winner,Loser,WinnerScore,LoserScore);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-18 22:23:34
