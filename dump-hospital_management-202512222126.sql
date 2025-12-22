-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: hospital_management
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `admin_name` varchar(50) NOT NULL,
  `admin_role` varchar(50) DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `UK_hawikyhwwfvbnog5byokutpff` (`user_id`),
  CONSTRAINT `FK8ahhk8vqegfrt6pd1p9i03aej` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'李管理员','系统管理员',3);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `doc_id` int NOT NULL AUTO_INCREMENT,
  `doc_dept` varchar(50) NOT NULL,
  `doc_name` varchar(50) NOT NULL,
  `doc_specialty` varchar(100) DEFAULT NULL,
  `doc_title` varchar(50) DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`doc_id`),
  UNIQUE KEY `UK_3q0j5r6i4e9k3afhypo6uljph` (`user_id`),
  CONSTRAINT `FK9roto9ydtnjfkixvexq5vxyl5` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES (1,'内科','王医生','心血管疾病','主治医师',2);
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drug_liquid`
--

DROP TABLE IF EXISTS `drug_liquid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug_liquid` (
  `TRL_ID` int NOT NULL AUTO_INCREMENT COMMENT '鑽?恫浣揑D',
  `TRL_NAME` varchar(100) NOT NULL COMMENT '鑽?恫浣撳悕绉',
  `TRL_START_DATE` datetime NOT NULL COMMENT '寮??鏃ユ湡',
  `TRL_END_DATE` datetime NOT NULL COMMENT '缁撴潫鏃ユ湡',
  `TRL_QTY` double NOT NULL COMMENT '鑽?恫浣撴暟閲',
  `TRL_PRESC_QTY` double NOT NULL COMMENT '澶勬柟鏁伴噺',
  `TRL_NOTE` text COMMENT '澶囨敞',
  `TRL_STATUS` char(1) NOT NULL COMMENT '鐘舵?',
  PRIMARY KEY (`TRL_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='鑽?恫浣撹〃';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drug_liquid`
--

LOCK TABLES `drug_liquid` WRITE;
/*!40000 ALTER TABLE `drug_liquid` DISABLE KEYS */;
INSERT INTO `drug_liquid` VALUES (1,'生理盐水','2025-12-18 15:18:43','2026-01-17 15:18:43',500,100,'静脉注射用','A');
/*!40000 ALTER TABLE `drug_liquid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine`
--

DROP TABLE IF EXISTS `medicine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicine` (
  `MED_ID` int NOT NULL AUTO_INCREMENT COMMENT '鑽?搧ID',
  `MDT_ID` char(10) NOT NULL COMMENT '鑽?搧绫诲瀷ID',
  `MED_NAME` varchar(100) NOT NULL COMMENT '鑽?搧鍚嶇О',
  `MED_STOCK` int NOT NULL COMMENT '鑽?搧搴撳瓨',
  `MED_MIN_STOCK_QTY` float NOT NULL COMMENT '鏈?皬搴撳瓨鏁伴噺',
  `MED_IN_QTY` float NOT NULL COMMENT '鍏ュ簱鏁伴噺',
  `MED_OUT_QTY` float NOT NULL COMMENT '鍑哄簱鏁伴噺',
  `MED_LOCK` int NOT NULL COMMENT '閿佸畾鐘舵?',
  PRIMARY KEY (`MED_ID`),
  KEY `MDT_ID` (`MDT_ID`),
  CONSTRAINT `medicine_ibfk_1` FOREIGN KEY (`MDT_ID`) REFERENCES `medicine_type` (`MDT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='鑽?搧琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicine`
--

LOCK TABLES `medicine` WRITE;
/*!40000 ALTER TABLE `medicine` DISABLE KEYS */;
INSERT INTO `medicine` VALUES (1,'MT00000001','阿莫西林',1000,100,1000,0,0),(2,'MT00000002','布洛芬',2000,200,2000,0,0);
/*!40000 ALTER TABLE `medicine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medicine_type`
--

DROP TABLE IF EXISTS `medicine_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicine_type` (
  `MDT_ID` char(10) NOT NULL COMMENT '鑽?搧绫诲瀷ID',
  `MDT_NAME` varchar(50) NOT NULL COMMENT '鑽?搧绫诲瀷鍚嶇О',
  PRIMARY KEY (`MDT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='鑽?搧绫诲瀷琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medicine_type`
--

LOCK TABLES `medicine_type` WRITE;
/*!40000 ALTER TABLE `medicine_type` DISABLE KEYS */;
INSERT INTO `medicine_type` VALUES ('MT00000001','抗生素'),('MT00000002','止痛药'),('MT00000003','感冒药');
/*!40000 ALTER TABLE `medicine_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opd`
--

DROP TABLE IF EXISTS `opd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opd` (
  `OPD_ID` int NOT NULL AUTO_INCREMENT COMMENT '鎸傚彿ID',
  `OPD_DATE` datetime NOT NULL COMMENT '鎸傚彿鏃ユ湡',
  `OPD_TIME` datetime NOT NULL COMMENT '鎸傚彿鏃堕棿',
  `OPD_DEPT` varchar(50) NOT NULL COMMENT '鎸傚彿绉戝?',
  `OPD_PAT_ID` int NOT NULL COMMENT '鎮ｈ?ID',
  `OPD_STATS` int NOT NULL DEFAULT '1' COMMENT '挂号状态，1-挂号成功，2-叫号，3-过号',
  PRIMARY KEY (`OPD_ID`),
  KEY `OPD_PAT_ID` (`OPD_PAT_ID`),
  CONSTRAINT `opd_ibfk_1` FOREIGN KEY (`OPD_PAT_ID`) REFERENCES `patient` (`PAT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='闂ㄨ瘖琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opd`
--

LOCK TABLES `opd` WRITE;
/*!40000 ALTER TABLE `opd` DISABLE KEYS */;
INSERT INTO `opd` VALUES (1,'2025-12-18 15:18:43','2025-12-18 15:18:43','内科',1,3),(2,'2025-12-19 09:10:58','2025-12-19 09:10:58','内科',1,2),(3,'2025-12-19 10:30:12','2025-12-19 10:30:12','内科',2,1),(4,'2025-12-19 10:32:06','2025-12-19 10:32:06','内科',1,1);
/*!40000 ALTER TABLE `opd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opd_visit_history`
--

DROP TABLE IF EXISTS `opd_visit_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `opd_visit_history` (
  `VIS_ID` int NOT NULL AUTO_INCREMENT COMMENT '灏辫瘖璁板綍ID',
  `PAT_ID` int NOT NULL COMMENT '鎮ｈ?ID',
  `VIS_DOC_ID` int NOT NULL COMMENT '鍖荤敓ID',
  `VIS_CASE_DESC` text NOT NULL COMMENT '鐥呬緥鎻忚堪',
  `VIS_DIAGNOSIS` varchar(200) NOT NULL COMMENT '璇婃柇缁撴灉',
  `VIS_CREATED_BY` varchar(50) NOT NULL COMMENT '鍒涘缓浜哄憳',
  `VIS_CREATED_DATE` datetime NOT NULL COMMENT '鍒涘缓鏃ユ湡',
  `VIS_LAST_MODIFIED_BY` varchar(50) NOT NULL COMMENT '淇?敼浜哄憳',
  `VIS_LAST_MODIFIED_DATE` datetime NOT NULL COMMENT '淇?敼鏃ユ湡',
  `VIS_NOTE` text COMMENT '澶囨敞',
  PRIMARY KEY (`VIS_ID`),
  KEY `PAT_ID` (`PAT_ID`),
  CONSTRAINT `opd_visit_history_ibfk_1` FOREIGN KEY (`PAT_ID`) REFERENCES `patient` (`PAT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='闂ㄨ瘖灏辫瘖鍘嗗彶琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opd_visit_history`
--

LOCK TABLES `opd_visit_history` WRITE;
/*!40000 ALTER TABLE `opd_visit_history` DISABLE KEYS */;
INSERT INTO `opd_visit_history` VALUES (1,1,1,'患者主诉头痛、发热','上呼吸道感染','医生A','2025-12-18 15:18:43','医生A','2025-12-18 15:18:43',NULL),(2,1,1,'123123','323232','王医生','2025-12-22 20:36:52','王医生','2025-12-22 20:36:52','123123');
/*!40000 ALTER TABLE `opd_visit_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `PAT_ID` int NOT NULL AUTO_INCREMENT COMMENT '鎮ｈ?ID',
  `PAT_NAME` varchar(50) NOT NULL COMMENT '鎮ｈ?濮撳悕',
  `PAT_SURNAME` varchar(50) NOT NULL COMMENT '鎮ｈ?濮撴皬',
  `PAT_FIRSTNAME` varchar(100) NOT NULL COMMENT '鎮ｈ?鍚嶅瓧',
  `PAT_AGE` int NOT NULL COMMENT '鎮ｈ?骞撮緞',
  `PAT_SEX` char(1) NOT NULL COMMENT '鎮ｈ?鎬у埆',
  `PAT_ACTOR` varchar(50) NOT NULL COMMENT '鎮ｈ?瑙掕壊',
  `PAT_CONTACT_PERSON` varchar(50) NOT NULL COMMENT '鑱旂郴浜哄憳',
  `PAT_TEL` varchar(20) NOT NULL COMMENT '鑱旂郴鐢佃瘽',
  `PAT_STATUS` char(1) NOT NULL COMMENT '鎮ｈ?鐘舵?',
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`PAT_ID`),
  KEY `patient_user_FK` (`user_id`),
  CONSTRAINT `patient_user_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='鎮ｈ?琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'张三','张','三',30,'男','患者','张三','13800138000','A',1),(2,'李四','李','四',25,'女','患者','李四','13900139000','A',NULL);
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `UK_iubw515ff0ugtm28p8g3myt0h` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (3,'ROLE_ADMIN'),(2,'ROLE_DOCTOR'),(1,'ROLE_PATIENT');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT 'A',
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK_sb8bbouer5wak8vyiiy4pf2bx` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'patient1@example.com','$2a$10$LcLOTlic7eQ70TDt7grAH.Xfrh0ZI/KYufVrqMG7VCkndjQFBpKEG','13800138000','A','patient1'),(2,'doctor1@example.com','$2a$10$unmhCpL8xeEWliGPmwfatu8TCeIaHj3cEBURrDdJmtgPT2JEzXKjK','13900139000','A','doctor1'),(3,'admin1@example.com','$2a$10$5tbnxcAYzNdSaN37KKbGoe/yeN8WJMGWgCgD8NnliimW9dMn9Yv4G','13700137000','A','admin1');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `FKa68196081fvovjhkek5m97n3y` (`role_id`),
  CONSTRAINT `FK859n2jvi8ivhui0rl0esws6o` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `FKa68196081fvovjhkek5m97n3y` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (1,1),(2,2),(3,3);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'hospital_management'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-22 21:26:04
