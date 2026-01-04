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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES (1,'内科','王医生','心血管疾病','主治医师',2),(2,'内科','clouthy','看看你的','医师',7),(3,'皮肤科','罗','院院又长长','院长',8);
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drug`
--

DROP TABLE IF EXISTS `drug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug` (
  `DRUG_ID` int NOT NULL AUTO_INCREMENT COMMENT '药品ID',
  `DRUG_NAME` varchar(100) NOT NULL COMMENT '药品名称',
  `DRUG_CODE` varchar(50) NOT NULL COMMENT '药品编码',
  `DRUG_PRICE` decimal(10,2) NOT NULL COMMENT '单价',
  `DRUG_STOCK` int NOT NULL DEFAULT '0' COMMENT '库存',
  `DRUG_UNIT` varchar(20) NOT NULL COMMENT '单位',
  `DRUG_SPEC` varchar(50) DEFAULT NULL COMMENT '规格',
  PRIMARY KEY (`DRUG_ID`),
  UNIQUE KEY `UK_DRUG_CODE` (`DRUG_CODE`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='药品表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drug`
--

LOCK TABLES `drug` WRITE;
/*!40000 ALTER TABLE `drug` DISABLE KEYS */;
INSERT INTO `drug` VALUES (1,'阿莫西林胶囊','AMXL001',25.50,95,'盒','0.25g*24粒'),(2,'布洛芬缓释胶囊','BLF001',18.00,47,'盒','0.3g*20粒'),(3,'感冒灵颗粒','GML001',15.00,200,'盒','10g*9袋'),(4,'头孢拉定胶囊','TFLD001',32.00,80,'盒','0.25g*24粒'),(5,'维生素C片','WSSC001',5.00,500,'瓶','100片'),(7,'3232','SDSD221',21.00,30,'盒','0.25g*24粒');
/*!40000 ALTER TABLE `drug` ENABLE KEYS */;
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
  `OPD_DOC_ID` int DEFAULT NULL,
  PRIMARY KEY (`OPD_ID`),
  KEY `OPD_PAT_ID` (`OPD_PAT_ID`),
  KEY `opd_doctor_FK` (`OPD_DOC_ID`),
  CONSTRAINT `opd_doctor_FK` FOREIGN KEY (`OPD_DOC_ID`) REFERENCES `doctor` (`doc_id`),
  CONSTRAINT `opd_ibfk_1` FOREIGN KEY (`OPD_PAT_ID`) REFERENCES `patient` (`PAT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='闂ㄨ瘖琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opd`
--

LOCK TABLES `opd` WRITE;
/*!40000 ALTER TABLE `opd` DISABLE KEYS */;
INSERT INTO `opd` VALUES (1,'2025-12-18 15:18:43','2025-12-18 15:18:43','内科',1,3,1),(2,'2025-12-19 09:10:58','2025-12-19 09:10:58','内科',1,2,1),(3,'2025-12-19 10:30:12','2025-12-19 10:30:12','内科',2,1,1),(4,'2025-12-19 10:32:06','2025-12-19 10:32:06','内科',1,3,1),(5,'2025-12-23 01:03:11','2025-12-23 01:03:11','内科',1,3,1),(7,'2025-12-26 06:10:02','2025-12-26 06:10:02','内科',1,3,1),(8,'2025-12-25 22:13:46','2025-12-25 22:13:46','内科',1,3,1),(9,'2025-12-26 17:22:30','2025-12-26 17:22:30','内科',1,2,1),(10,'2025-12-26 09:27:33','2025-12-26 09:27:33','内科',6,3,1),(11,'2025-12-26 09:37:23','2025-12-26 09:37:23','内科',6,3,1),(12,'2025-12-26 10:32:10','2025-12-26 10:32:10','内科',6,3,1),(13,'2025-12-26 16:23:33','2025-12-26 16:23:33','皮肤科',6,1,NULL),(14,'2025-12-26 16:58:27','2025-12-26 16:58:27','内科',6,3,1),(15,'2025-12-26 17:20:23','2025-12-26 17:20:23','内科',6,3,1);
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
  KEY `FK15bfxrixpnr72ud9xhkjms85k` (`VIS_DOC_ID`),
  CONSTRAINT `FK15bfxrixpnr72ud9xhkjms85k` FOREIGN KEY (`VIS_DOC_ID`) REFERENCES `doctor` (`doc_id`),
  CONSTRAINT `opd_visit_history_ibfk_1` FOREIGN KEY (`PAT_ID`) REFERENCES `patient` (`PAT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='闂ㄨ瘖灏辫瘖鍘嗗彶琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opd_visit_history`
--

LOCK TABLES `opd_visit_history` WRITE;
/*!40000 ALTER TABLE `opd_visit_history` DISABLE KEYS */;
INSERT INTO `opd_visit_history` VALUES (1,1,1,'患者主诉头痛、发热','上呼吸道感染','医生A','2025-12-18 15:18:43','医生A','2025-12-18 15:18:43',NULL),(2,1,1,'123123','323232','王医生','2025-12-22 20:36:52','王医生','2025-12-22 20:36:52','123123'),(3,1,1,'123213','232323','王医生','2025-12-23 01:04:38','王医生','2025-12-23 01:04:38','12312313123131'),(4,1,1,'232323','23232','王医生','2025-12-25 22:14:36','王医生','2025-12-25 22:14:36','32323232323232'),(5,1,1,'患者自述头痛发热','上呼吸道感染','Doctor1','2025-12-26 17:22:30','Doctor1','2025-12-26 17:22:30','建议休息'),(6,6,1,'12121221','12121','王医生','2025-12-26 09:28:08','王医生','2025-12-26 09:28:08','212121121'),(7,1,1,'12313','123232','王医生','2025-12-26 09:31:28','王医生','2025-12-26 09:31:28','232323232'),(8,6,1,'123','232323','王医生','2025-12-26 09:38:04','王医生','2025-12-26 09:38:04','21132131313'),(9,6,1,'1231','123132','王医生','2025-12-26 10:33:13','王医生','2025-12-26 10:33:13','123'),(10,6,1,'123123','123123','王医生','2025-12-26 17:21:10','王医生','2025-12-26 17:21:10','12312312312312');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='鎮ｈ?琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'张三','张','三',30,'男','患者','张三','13800138000','A',1),(2,'李四','李','四',25,'女','患者','李四','13900139000','A',NULL),(6,'luozheng','luozheng','luozheng',21,'男','患者','clouthy','13660307778','A',6);
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription` (
  `PRES_ID` int NOT NULL AUTO_INCREMENT COMMENT '处方ID',
  `VIS_ID` int NOT NULL COMMENT '就诊记录ID',
  `PRES_TOTAL_AMOUNT` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '总金额',
  `PRES_STATUS` int NOT NULL DEFAULT '1' COMMENT '状态: 1-已开立, 2-已支付, 3-已发药, 0-已作废',
  `PRES_CREATED_TIME` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开立时间',
  PRIMARY KEY (`PRES_ID`),
  KEY `IDX_PRES_VIS_ID` (`VIS_ID`),
  CONSTRAINT `FK_PRES_VIS` FOREIGN KEY (`VIS_ID`) REFERENCES `opd_visit_history` (`VIS_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='处方主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription`
--

LOCK TABLES `prescription` WRITE;
/*!40000 ALTER TABLE `prescription` DISABLE KEYS */;
INSERT INTO `prescription` VALUES (1,5,51.00,1,'2025-12-26 09:22:29'),(2,8,25.50,1,'2025-12-26 09:38:04'),(3,9,102.00,1,'2025-12-26 10:33:13'),(4,10,130.50,1,'2025-12-26 17:21:10');
/*!40000 ALTER TABLE `prescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescription_detail`
--

DROP TABLE IF EXISTS `prescription_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription_detail` (
  `DETAIL_ID` int NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `PRES_ID` int NOT NULL COMMENT '处方ID',
  `DRUG_ID` int NOT NULL COMMENT '药品ID',
  `DETAIL_QUANTITY` int NOT NULL COMMENT '数量',
  `DETAIL_AMOUNT` decimal(10,2) NOT NULL COMMENT '明细金额',
  PRIMARY KEY (`DETAIL_ID`),
  KEY `IDX_DETAIL_PRES_ID` (`PRES_ID`),
  KEY `IDX_DETAIL_DRUG_ID` (`DRUG_ID`),
  CONSTRAINT `FK_DETAIL_DRUG` FOREIGN KEY (`DRUG_ID`) REFERENCES `drug` (`DRUG_ID`),
  CONSTRAINT `FK_DETAIL_PRES` FOREIGN KEY (`PRES_ID`) REFERENCES `prescription` (`PRES_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='处方明细表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription_detail`
--

LOCK TABLES `prescription_detail` WRITE;
/*!40000 ALTER TABLE `prescription_detail` DISABLE KEYS */;
INSERT INTO `prescription_detail` VALUES (1,1,1,2,51.00),(2,2,1,1,25.50),(3,3,1,4,102.00),(4,4,1,3,76.50),(5,4,2,3,54.00);
/*!40000 ALTER TABLE `prescription_detail` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'patient1@example.com','$2a$10$JuiFIWZB9QRcF/h0qquR.ebE9ic5HrCfdZz.ZLfaB32R/dod3wtPi','13800138000','A','patient1'),(2,'doctor1@example.com','$2a$10$cNurICfz2UvgCvB8jFoQUeFsUTJ0vUqeVlP/OaTmoESfyd.5bIsXi','13900139000','A','doctor1'),(3,'admin1@example.com','$2a$10$FZER7XltF8sVLd3lgVA7geyzFI0WFTsJ2rNuTmAWMCmVz5vCg9a0G','13700137000','A','admin1'),(4,NULL,'$2a$10$A5vG0BGs4SDBVaEIOr/5oOYzrvWUZhVcF/Mwhc8GqaxCk.ec/djh2',NULL,'A','testpatient3'),(5,NULL,'$2a$10$xWlkCOdzT7UNxijWf8ZdaeZ5sSS/jH5A5VJAu.w1wAzCHq0zSva/u',NULL,'A','testpatient4'),(6,NULL,'$2a$10$KFdkPRN1VKHT8VKoA8XD8u7HKugUXo0k8vd53ErA1pljrdVGcJNOa',NULL,'A','lz'),(7,NULL,'$2a$10$RBy23AI2lUj0b8DgwCSAg.L1EiV5DMZBai26kbZfkeVQpxscWzSe2',NULL,'A','doctor2'),(8,NULL,'$2a$10$9GH4Yjq8epnrxkAiZbG3Uu/XyKjeiq12snqtLD9qJRPPabBa2CqlG',NULL,'A','doctor3');
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
INSERT INTO `user_role` VALUES (1,1),(4,1),(5,1),(6,1),(2,2),(7,2),(8,2),(3,3);
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

-- Dump completed on 2026-01-04  0:06:10
