-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: u1482641_portal
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.25-MariaDB

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
-- Table structure for table `contact`
--

DROP TABLE IF EXISTS `contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact` (
  `recid` varchar(100) NOT NULL,
  `company_id` varchar(100) DEFAULT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `address_1` varchar(100) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `contact_person` varchar(255) DEFAULT NULL,
  `address_2` varchar(100) DEFAULT NULL,
  `city` varchar(200) DEFAULT NULL,
  `postal_code` varchar(200) DEFAULT NULL,
  `province` varchar(200) DEFAULT NULL,
  `country` varchar(200) DEFAULT NULL,
  `category` varchar(200) DEFAULT NULL,
  `continent` varchar(200) DEFAULT NULL,
  `salesrep` varchar(200) DEFAULT NULL,
  `npwp` varchar(200) DEFAULT NULL,
  `is_oem` int(11) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `consigne_company` varchar(200) DEFAULT NULL,
  `consigne_addreess_1` varchar(200) DEFAULT NULL,
  `consigne_addreess_2` varchar(200) DEFAULT NULL,
  `consigne_city` varchar(200) DEFAULT NULL,
  `consigne_postalcode` varchar(200) DEFAULT NULL,
  `consigne_state` varchar(200) DEFAULT NULL,
  `consigne_country` varchar(200) DEFAULT NULL,
  `destination_port` varchar(200) DEFAULT NULL,
  `shipping_doc` varchar(200) DEFAULT NULL,
  `certificate_code` varchar(200) DEFAULT NULL,
  `license_code` varchar(200) DEFAULT NULL,
  `email_invoice` varchar(200) DEFAULT NULL,
  `email_shipping` varchar(200) DEFAULT NULL,
  `notify` varchar(200) DEFAULT NULL,
  `notify_address_1` varchar(200) DEFAULT NULL,
  `notify_address_2` varchar(200) DEFAULT NULL,
  `notify_city` varchar(200) DEFAULT NULL,
  `notify_postalcode` varchar(200) DEFAULT NULL,
  `notify_state` varchar(200) DEFAULT NULL,
  `notify_country` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact`
--

LOCK TABLES `contact` WRITE;
/*!40000 ALTER TABLE `contact` DISABLE KEYS */;
INSERT INTO `contact` VALUES ('3585ea90-3fb1-46f8-b8df-c0b4d5b3fb3a','QWP1','Quality Works, PT','',NULL,'2023-03-22 06:38:46','Anders Norgaard','','Lamongan','','','Indonesia','','','','',0,'info@q-works.net','http://q-works.net','0321-1234567890',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('98ef44c8-a659-49df-b833-0993bf23ad87','MBA1','Micahel Barou','La Spayola','2023-03-29 05:35:08','2023-03-29 05:34:03','Barou','','Madrid','7777','Spain West','Spain','','','','',0,'spain@gg.com','www.spainwest.com','09223',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('a07d65da-5c30-4138-8c1f-7022ddd61df7','CNP1','Company Name, PT','Address','2023-04-06 06:44:28','2023-03-30 00:25:13','Contact Person','','City','Postal Code','State','Indonesia','','','','',0,'Email@email.com','Website.com','Phone','Consignee','Address 1','','City','Post. Code','State','Country','Dest Port','Ship Doc','Cert Code','License Code','Email@email.com','email@email.com','Notify','Address 1','','City','Post Code','State','Country'),('ff849afa-aa76-49a4-b7a8-2d197e2fc8ba','OGI1','Outdoor Guild Inc','Corporation Trust Center 1209 Orange Street','2023-03-29 08:45:53','2023-03-23 02:50:30','Anders Norgaard','','Wilmington','19801','Delaware','USA','','','','',0,'info@outdoorguild.com','','','1','2','3','4','5','6','7','8','9','109','11','12','13','14','15','16','17','19','18','20');
/*!40000 ALTER TABLE `contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_det_phone`
--

DROP TABLE IF EXISTS `contact_det_phone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_det_phone` (
  `recid` varchar(100) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `phone_number` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NULL DEFAULT NULL,
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `title` varchar(100) DEFAULT NULL,
  `company_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_det_phone`
--

LOCK TABLES `contact_det_phone` WRITE;
/*!40000 ALTER TABLE `contact_det_phone` DISABLE KEYS */;
INSERT INTO `contact_det_phone` VALUES ('155b9a05-67b8-4aee-a08a-d03dd05f8be2','John Coral','+764324244','WhatsApp',NULL,NULL,NULL,'2023-04-03 01:44:51','Mrs.','CNP1'),('dab22a57-f3f7-4024-b5cf-1151db6a6b90','undefined','undefined','undefined',NULL,NULL,NULL,NULL,'',NULL);
/*!40000 ALTER TABLE `contact_det_phone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_counter`
--

DROP TABLE IF EXISTS `document_counter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `document_counter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_doc` varchar(10) NOT NULL,
  `period` varchar(20) NOT NULL COMMENT 'Daily, Monthly, Yearly',
  `counter_no` int(11) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  `prefix_doc` varchar(100) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `document_counter_un` (`type_doc`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_counter`
--

LOCK TABLES `document_counter` WRITE;
/*!40000 ALTER TABLE `document_counter` DISABLE KEYS */;
INSERT INTO `document_counter` VALUES (1,'PO','Monthly',9,NULL,'2023-03-23 06:57:38','admin','2023-04-16 05:43:49',''),(3,'Order','Monthly',27,NULL,'2023-03-30 06:54:17',NULL,'2023-04-10 12:52:37','Q-'),(4,'Receive','Monthly',6,NULL,'2023-03-30 06:54:17',NULL,'2023-04-05 02:35:12','RC-'),(5,'LotNumber','Monthly',3,NULL,'2023-03-30 06:54:17',NULL,'2023-04-06 03:43:31','LO-'),(6,'Shipment','Monthly',59,NULL,'2023-03-30 06:54:17',NULL,'2023-04-11 02:41:53','S-'),(7,'Invoice','Monthly',4,NULL,'2023-03-30 06:54:17',NULL,'2023-04-12 04:08:49','I-');
/*!40000 ALTER TABLE `document_counter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `invoice_no` varchar(100) DEFAULT NULL,
  `company_id` varchar(100) DEFAULT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `revision_date` date DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `rate_usd` decimal(14,2) DEFAULT 0.00,
  `total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `grand_total` decimal(18,2) DEFAULT 0.00,
  `country` varchar(200) DEFAULT NULL,
  `shipping_method` varchar(200) DEFAULT NULL,
  `forwarder` varchar(300) DEFAULT NULL,
  `shipper` varchar(500) DEFAULT NULL,
  `etd` date DEFAULT NULL,
  `eta` date DEFAULT NULL,
  `emkl` varchar(500) DEFAULT NULL,
  `consignee` varchar(500) DEFAULT NULL,
  `notify_party` varchar(500) DEFAULT NULL,
  `port_loading` varchar(500) DEFAULT NULL,
  `port_discharge` varchar(500) DEFAULT NULL,
  `dimension` varchar(100) DEFAULT NULL,
  `departure_note` varchar(500) DEFAULT NULL,
  `sales_rep` varchar(100) DEFAULT NULL,
  `packing_volume` varchar(100) DEFAULT NULL,
  `peb_date` date DEFAULT NULL,
  `peb_no` varchar(100) DEFAULT NULL,
  `kmk_rate` varchar(100) DEFAULT NULL,
  `invoice_bl` varchar(100) DEFAULT NULL,
  `invoice_bl_date` date DEFAULT NULL,
  `payment` decimal(18,2) DEFAULT 0.00,
  `coo` varchar(100) DEFAULT NULL,
  `delivery_in` varchar(100) DEFAULT NULL,
  `delivery_out` varchar(100) DEFAULT NULL,
  `v_legal` varchar(100) DEFAULT NULL,
  `v_legal_paper` varchar(100) DEFAULT NULL,
  `container_no` varchar(100) DEFAULT NULL,
  `seal_no` varchar(100) DEFAULT NULL,
  `shipped_on_board` varchar(100) DEFAULT NULL,
  `awb_no` varchar(100) DEFAULT NULL,
  `awb_date` date DEFAULT NULL,
  `freight` decimal(18,2) DEFAULT 0.00,
  `insurance` decimal(18,2) DEFAULT 0.00,
  `dp_label` varchar(100) DEFAULT NULL,
  `dp_amount` decimal(18,2) DEFAULT 0.00,
  `is_paid` int(11) DEFAULT 0,
  `terms_delivery` varchar(300) DEFAULT NULL,
  `terms_payment` varchar(300) DEFAULT NULL,
  `consignee_address_1` varchar(300) DEFAULT NULL,
  `consignee_address_2` varchar(300) DEFAULT NULL,
  `consignee_city` varchar(100) DEFAULT NULL,
  `consignee_postal_code` varchar(100) DEFAULT NULL,
  `consignee_state` varchar(100) DEFAULT NULL,
  `consignee_country` varchar(100) DEFAULT NULL,
  `consignee_origin` varchar(100) DEFAULT NULL,
  `origin` varchar(100) DEFAULT NULL,
  `notify_address_1` varchar(300) DEFAULT NULL,
  `notify_address_2` varchar(300) DEFAULT NULL,
  `notify_city` varchar(300) DEFAULT NULL,
  `notify_postal_code` varchar(100) DEFAULT NULL,
  `notify_state` varchar(100) DEFAULT NULL,
  `notify_country` varchar(100) DEFAULT NULL,
  `external_note` varchar(500) DEFAULT NULL,
  `internal_note` varchar(500) DEFAULT NULL,
  `paid_date` date DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `bank` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES ('33492df7-93ad-4c6b-9236-5adb1a7a3b78','admin','2023-04-12 04:08:10',NULL,'2023-04-12 04:08:10','I-23040003','OGI1','Outdoor Guild Inc','2023-04-11','0000-00-00','','',0.00,0.00,16000.00,NULL,NULL,NULL,NULL,'0000-00-00','0000-00-00',NULL,'',NULL,'','',NULL,NULL,'','','0000-00-00','','','','0000-00-00',0.00,'','','','',NULL,'','','','','0000-00-00',0.00,0.00,'',0.00,0,NULL,NULL,'','','','',NULL,'',NULL,NULL,'','','',NULL,'','',NULL,NULL,'0000-00-00','',NULL),('bbbffdda-1aa5-4701-853d-f085c22c952d','admin','2023-04-12 04:08:49','admin','2023-04-14 00:26:05','I-23040004','OGI1','Outdoor Guild Inc','2023-04-11','2023-04-14','Shipped','Ini Note invoice',561.00,500000.00,42000.00,'Spain','Air Freight','DHL','DHL','2023-01-14','2023-01-14','EMKL','Alexander Rose Ltd','DHL ','Tanjung Perak','United Kingdom','1000 Ft','Dep Note','John Will 1','561','2023-01-14','2300KPEB','1','INVBL 1','2023-09-14',1000.00,'Coo 1','Dev In 1','Dev Out 1','V Legal 1','PAPER 01','C0011','SO9281','233441','112211342 1','2023-02-14',1.00,1.00,'DP For Ship 1',10000.00,1,'Packing Complete','Payable at Destination','Alexander House','59 Victoria Road','Burgess Hill','RH15 9LE','West Sussex','United Kingdom','United Kingdom','Indonesia','My House','76 Laurence','WestTern','RTE 12','West Ternian','US','This is external Note','This is internal Note','2023-01-14','IDR','Mandiri');
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_det`
--

DROP TABLE IF EXISTS `invoice_det`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_det` (
  `recid` varchar(100) NOT NULL DEFAULT '-',
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `shipment_no` varchar(100) DEFAULT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `qty` decimal(10,0) DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `sub_total` decimal(18,2) DEFAULT NULL,
  `seq` varchar(65) DEFAULT NULL,
  `discount` decimal(18,2) DEFAULT 0.00,
  `customer_sku` varchar(300) DEFAULT NULL,
  `unit` varchar(100) DEFAULT NULL,
  `invoice_no` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_det`
--

LOCK TABLES `invoice_det` WRITE;
/*!40000 ALTER TABLE `invoice_det` DISABLE KEYS */;
INSERT INTO `invoice_det` VALUES ('4890283a-1c05-438d-83b6-7e6efce05c7a','admin','2023-04-14 00:26:05',NULL,'2023-04-14 00:26:05','S-23040058','100019131.CLK.000100019131','Cube Trolley, Beige Ceramic',4,3000,NULL,12.00,'12042023105753554',0.00,'Test 3','Pcs','I-23040004'),('50797380-97c1-465a-a221-2a8294eb36d9','admin','2023-04-14 00:26:05',NULL,'2023-04-14 00:26:05','S-23040058','100022738.000.000','Cambridge Backless Bench 90cm',3,10000,NULL,30.00,'12042023105753552',0.00,'Test','Pcs','I-23040004');
/*!40000 ALTER TABLE `invoice_det` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itemcode`
--

DROP TABLE IF EXISTS `itemcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `itemcode` (
  `RecId` varchar(100) NOT NULL,
  `Creation` varchar(100) DEFAULT NULL,
  `CreationDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `Modify` varchar(100) DEFAULT NULL,
  `ModDate` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `ItemCode` varchar(100) DEFAULT NULL,
  `Description` varchar(100) DEFAULT NULL,
  `Class` varchar(100) DEFAULT NULL,
  `Type` varchar(100) DEFAULT NULL,
  `Unit` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`RecId`),
  KEY `itemcode_itemcode_IDX` (`ItemCode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemcode`
--

LOCK TABLES `itemcode` WRITE;
/*!40000 ALTER TABLE `itemcode` DISABLE KEYS */;
INSERT INTO `itemcode` VALUES ('006780A3-E031-E14F-956A-B5094C50DF22',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100017912','Harmony Chaise, White','Finished Product',NULL,'Pcs'),('01866154-7B68-2540-BA35-68658BFDA1F7',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100015714.BLK.000100015714','Bromo Folding Arm Chair, Charcoal','Finished Product',NULL,'Pcs'),('01A8A75D-1D0C-D14F-8353-00CECBB946A0',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023909.AWI.000','Cambridge Modular Corner Unit, Grade A-Winter','Finished Product',NULL,'Pcs'),('01BF1798-35C1-0E44-ACC7-44974345602D',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100023818.FOS.000100023818','Vera Deepseating Sofa 3 Seater, Grade C- Fossil','Finished Product',NULL,'Pcs'),('0201EA25-E8A9-5847-BCCB-95488D102B74',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100003505.BLK.000100003505','Maya Deck Chair with Integrated Footstool, Charcoal','Finished Product',NULL,'Pcs'),('02A125E6-55A4-1645-9907-AF600FB5CE86',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018335.000.BLK100018335','Otti Square Coffee Table (89x89x37cm), Black','Finished Product',NULL,'Pcs'),('02BAFFC7-EB15-954D-9C68-64F6FE642060',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023964.BLK.BLK','Vera Alu Dining Chair, Wicker Seat - Charcoal-Loom Charcoal','Finished Product',NULL,'Pcs'),('02FA8439-F973-7C43-962A-0B8E76EE8917',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:52','100022638.000.000','Mirror, frame only, 220x40 cm','Finished Product',NULL,'Pcs'),('034BAE71-A9E7-874F-91F7-6672304793C2',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100015453','Jett Coffee Table, frame only','Finished Product',NULL,'Sets'),('0369070B-E421-7C4B-B1A7-C5D48BEE0358',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100010366','Riva Coffee Table 150x80cm','Finished Product',NULL,'Pcs'),('03733B0A-ABD5-2147-A7A0-03ED519B054F',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020715.SAN.000100020715','Vera Modular Medium with Corner Unit, include cushion, Sand','Finished Product',NULL,'Pcs'),('04113F6F-2AD0-6C4D-BFE2-4E18629728DC',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018572.000.HOL100018572.000.000100018572','Cambridge Round Dining Table Ø150cm','Finished Product',NULL,'Pcs'),('05180AED-919E-7246-8184-2342D810B6C7',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021878.ACH.000100021878','Cube Modular Medium, Grade A','Finished Product',NULL,'Pcs'),('055D96F6-8C3D-914A-A3DD-EDDE4CD4047B',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020774.ANT.ANT100020774','i-konic Rope Pendant/Lantern Lamp, Small','Finished Product',NULL,'Pcs'),('06000092-248E-194C-BA76-1165F5D77B75',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016104.000.000100016104','Stockholm Nested Coffee Table','Finished Product',NULL,'Pcs'),('06079964-971C-9F45-BBBE-9EC02A4460A8',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:52','100022585.AOL.000','Vera Modular Medium + Corner Table, Grade A','Finished Product',NULL,'Pcs'),('06349997-DD6D-F44E-A1B1-15491D6264A6',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017977.ROANT.ANT100017977','Salling Rope Chair, Anthracite','Finished Product',NULL,'Pcs'),('066D1581-EDAE-AA40-B8DE-E41E7143D25C',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100003169.BLK.000100003169','Maya Multi Position Recliner, Charcoal','Finished Product',NULL,'Pcs'),('069A9882-9AD1-7A4C-9A0E-4F00EA6CD81D',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021704.000.DAN100021704','MOON solar standing lamp MINI, Dark Anthracite','Finished Product',NULL,'Pcs'),('06A8823E-33F5-3649-A4C0-7B60F8C2FA04',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100002972.000.000100002972','Elements Pedestal Table 80x80cm, Teak Top','Finished Product',NULL,'Pcs'),('083B2682-4CFF-D149-BE5D-A05ECAED4A2F',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100021801.SLA.ANT','Cube Alu Stacking Chair, teak arm, Slate','Finished Product',NULL,'Pcs'),('088EAFC6-2755-3A43-B30E-036A09CEACC5',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022256.ROANT.ANT100022256','Ellen Alu Rope Dining Chair','Finished Product',NULL,'Pcs'),('09021441-1760-8A4B-B545-EA388EB69625',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022459.000.ANT100022459','Cube Alu Side Table 40x40cm, Anthracite','Finished Product',NULL,'Pcs'),('0909D9E6-D44D-BA41-A442-A3D3E90FD8BF',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020129.TAU.TAU100020129','Cambridge Seating Chaise, Frame Only','Finished Product',NULL,'Pcs'),('094B9950-AC79-C746-95C7-F164F2A47E87',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100006075.BLK.000100006075','Stockholm Lounge Chair, Charcoal','Finished Product',NULL,'Pcs'),('0A320729-4A44-3C49-9BE6-468A9F8BDC91',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100021161','Paton SS Floor Standing Lamp','Finished Product',NULL,'Pcs'),('0A8CD720-65C1-A049-98FB-044F36C44274',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100023897.AWI.TAU100023897.AWI.000','Cambridge Modular Arm Unit, Left Grade A-Winter','Finished Product',NULL,'Pcs'),('0B7A23EA-A45E-524A-A9D0-47F8B45F472E',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023781.ANT.000','Mimpi Pouf Medium, Anthracite Ø65','Finished Product',NULL,'Pcs'),('0C3BEBE9-16EF-4A44-8175-586B3A261780',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100007948','Quadro Side Table 50x50','Finished Product',NULL,'Pcs'),('0CE92AA2-DB08-804E-BFF2-EB1E29CE6D5F',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:50:09','100002702','Heritage Ottoman (excl. brass feet)','Finished Product',NULL,'Pcs'),('0D56884B-4326-724F-B162-1077DB8039D6',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023944.000.ANT','Elements Alu Dining Table 160x100, Teak Top','Finished Product',NULL,'Pcs'),('0E2E39EC-9469-1A4D-BCF0-3F3821D4A242',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024102.AWI.000','Maya Modular Extension Unit with Arm Right, Grade A','Finished Product',NULL,'Pcs'),('0E5213B0-9C16-814A-A30A-2083FB0BEDEC',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100020771.AWI.000','Optional Seat Cushion for Vera Chair, Grade A-Winter','Finished Product',NULL,'Pcs'),('0E6EFF53-BD6E-4B4C-BD48-E1F33DC66E43',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100021405','Jett Sofa, Frame + back cushion only','Finished Product',NULL,'Sets'),('0E987CE3-E32A-4D43-ABFA-E6AF4E02EDC9',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021898.BLK.000100021898','Cambridge Sling Arm Chair, Charcoal','Finished Product',NULL,'Pcs'),('0EE1BD8F-2C15-2548-AEF7-D97B7769D9E5',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016166.000.000100016166','Stockholm Extending Table (220-320x95cm)','Finished Product',NULL,'Pcs'),('0F52ABFA-7258-6046-BD1B-80FCDEB08BF8',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019131.CLK.000100019131','Cube Trolley, Beige Ceramic','Finished Product',NULL,'Pcs'),('0F78605C-1012-3748-8711-4F34161FA151',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100002400.BLK.000100002400','Shade for Maya/Frank Lounger, Charcoal','Finished Product',NULL,'Pcs'),('0FACA3A8-3582-A540-9762-E2675A470EFA',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100002635.ANT.000100002635','Maya Rope Dining Chair, Anthracite','Finished Product',NULL,'Pcs'),('10438BE9-1DCE-E843-A1EB-3D6E15875D82',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100021929.000.000','Cambridge Rect Counter Height Table 140x80x90cm','Finished Product',NULL,'Pcs'),('10845F9E-C675-4A43-A86B-AC4AF4A4856E',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100021160','Roped Floor Standing Lamp, Anthra-Navy','Finished Product',NULL,'Pcs'),('10E60C20-F842-744B-A596-5C7168985340',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020710.000.000100020710','Vera Side Table 54x37cm, Low','Finished Product',NULL,'Pcs'),('115343D3-0BC0-F34B-9BDB-DE0E9BA03A73',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:50:09','100020687','Heritage Cushion Chest (excl. brass feet)','Finished Product',NULL,'Pcs'),('115FF79B-2A3F-414A-B983-802EAEFF5754',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024367.000.000','Vera Dining Chair, Round Back','Finished Product',NULL,'Pcs'),('11653651-E49A-2A4C-B35E-C313EF158572',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024475.000.000','Vera Dining Table 160x90cm','Finished Product',NULL,'Pcs'),('118A008C-88CA-B845-84E0-F6C70E692E67',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100012407.TAU.TAUPE100012407','Cambridge Seating Swivel Rocker, Frame Only','Finished Product',NULL,'Pcs'),('11B43C23-9313-4345-AC6C-F27AA8DE5CFD',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022130.000.HOL100022130.000.000','Cambridge Round Bar Height Table Ø93x105cm','Finished Product',NULL,'Pcs'),('12F2C472-72F7-C045-9758-B6A83B0305DA',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020511.000.000100020511','Cambridge Conversation Table Ø115cm','Finished Product',NULL,'Pcs'),('130816A8-A4CA-3F41-BE80-D633AD714A22',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023977.MUS.000','Mimpi Beach Bag, Mustard','Finished Product',NULL,'Pcs'),('1330552C-6089-BF4E-BABC-48551CF28D1E',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 12:47:14','100024531.000.GRE100024531.000','Casita Teak Swivel Chair','Finished Product',NULL,'Pcs'),('13E1792E-3A6D-4446-8C09-B8A440FE36F6',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100011532.000.000100011532','Elements Pedestal Table 80x80cm, Ceramic Top','Finished Product',NULL,'Pcs'),('1413DB47-BABB-3049-926F-665E132CAC9F',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022028','Harmony Chaise, Gray','Finished Product',NULL,'Pcs'),('14305176-9575-B140-A818-E3EAB711919B',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017284.HOL.000100017284.000.000100017284','Vera Dining Table 160x90cm, w. umbrella hole','Finished Product',NULL,'Pcs'),('14B9F080-488C-2340-B7B5-347F20407E88',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100015534.ANT.000100015534','Opti Lounge Chair','Finished Product',NULL,'Pcs'),('15A36649-685E-E747-BEC5-3E4B913FABBF',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018816.000.000100018816','Cambridge Rect Extending Table 212/282x100cm','Finished Product',NULL,'Pcs'),('15DA4BEF-0AB3-C244-A25C-30669EFDEE37',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100003179.BLK.000100003179','Campaign Director\'s Chair, Charcoal','Finished Product',NULL,'Pcs'),('16DD105C-FCF3-5B4A-8C22-04C0F0C2B090',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100006131.BLK.000100006131','Stockholm Dining Chair, Charcoal','Finished Product',NULL,'Pcs'),('171D3141-0058-2D4F-BA53-79C6F004C0BD',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019450.000.000100019450','Cambridge Coffee Table 132x65x47cm','Finished Product',NULL,'Units'),('17B9A48E-350D-B44D-AA41-4BDF7B481B51',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018813.ACH.000100018813','Cube Modular Arm Unit Left, Grade A','Finished Product',NULL,'Pcs'),('17D7A867-E099-954C-BEA1-A3C1875B0FFB',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020689.000.000100020689','Vera Lamp Table 72x72x52 cm','Finished Product',NULL,'Pcs'),('1911D5CC-E16A-1848-B440-625F2FF48C08',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021707.000.000100021707','Cube Modular Corner Table','Finished Product',NULL,'Pcs'),('195A7995-B38A-0F4A-ACAC-571AA5BF0C0D',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016132.000.000100016132','Stockholm Backless Bench','Finished Product',NULL,'Pcs'),('1992A397-491D-5446-A06B-1C8AEFEB01D7',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100011558.000.ANT','Elements Pedestal Folding Table 80x80cm, Teak Top, Coated A','Finished Product',NULL,'Pcs'),('1A9663AE-FE93-F444-89EB-F85A9250C46F',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100004336.BLK.000100004336','Cube Sun Lounger, Charcoal','Finished Product',NULL,'Pcs'),('1B3A47E8-6CB6-C741-BC7C-4EB6C9FD8F98',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023768.000.SAN','Cube Alu Coffee Table 120x80 cm, Sand','Finished Product',NULL,'Pcs'),('1B88FE01-2613-C14B-95D8-B8C6ECDDD444',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020489.NAV.000100020489','Mimpi Pouf, Navy Ø48','Finished Product',NULL,'Pcs'),('1C5B0C61-E8FD-4A49-9BCD-FFCEFCD86C88',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022505.000.000','Stand for Halland Table','Finished Product',NULL,'Pcs'),('1CCEB9A9-EC23-DD46-8D9C-1A4FD6CACAC0',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100012576.000.000100012576','Stockholm Dining Table Teak Top  220x95cm','Finished Product',NULL,'Pcs'),('1CE06608-5897-4E4D-9D0F-355DEEA22244',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100004340.000.000100004340','Cube Dining Table, Teak Top (230x95cm)','Finished Product',NULL,'Pcs'),('1D1A1AA5-C8F6-2942-BED0-2D72582C9AEE',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:48:40','100011309.GRA.ANT100011309','Cube Alu Dining Chair, teak arm, Anthracite','Finished Product',NULL,'Pcs'),('1DB3F763-9EB6-3449-8E60-6A2F31FC9AC1',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100012543.000.000100012543','Optional Bar Shelf for Buffet Table','Finished Product',NULL,'Pcs'),('1E4F061E-534E-D846-9D63-D121F00C1416',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100023543.000.FSC100023543','Note Extending Table, FSC 100%','Finished Product',NULL,'Pcs'),('1ECAD8ED-A8C4-304B-9F8B-504DEEB408BB',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:50:09','100002699','Heritage Lounge Chair (excl. brass feet, coin)','Finished Product',NULL,'Pcs'),('1F5437B5-0D62-904C-A735-FD717F094AC2',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021877.000.000100021877','Cube Modular Extra Large, Grade A','Finished Product',NULL,'Pcs'),('1FE5EC51-5031-0F47-974E-5F8843A8761C',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023358.000.FSC','Note Bench, FSC 100%','Finished Product',NULL,'Pcs'),('2028EC26-F30E-5247-B4BF-D7EDA428B83C',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024142.FOS.ANT','Vera Alu Deepseating 3 Seater, Grade C- Fossil','Finished Product',NULL,'Pcs'),('209C5FF1-3BA8-A443-BB80-F745191DA990',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100019945.HOL.000100019945.000.000100019945','Vera Dining Table 240x100cm. w. umbrella hole','Finished Product',NULL,'Pcs'),('20CC577F-EFDF-1641-BD4F-24A4DF19183F',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100003167.000.HOL100003167.000.000100003167','Maya Dining Table 240x100x74cm','Finished Product',NULL,'Pcs'),('2110C4CD-F0B3-E94C-B8E1-D49B49FE09C3',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022504.000.000','Halland Coffee Table Ø100cm','Finished Product',NULL,'Pcs'),('2161D485-7C02-8A4E-B974-304B29B52C69',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100015212.BLK.000100015212','Bromo Folding Chair, Charcoal','Finished Product',NULL,'Pcs'),('2277110F-404A-974F-8FDF-3DD1B08F9FE4',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021211.65B.BLK100021211','Otti Right Arm Facing Sectional Chaise-Black','Finished Product',NULL,'Pcs'),('2297EE3A-F3F0-794C-9BFE-F57802809B7A',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100009876','Riva Club Chair (No rail behind backrest)','Finished Product',NULL,'Pcs'),('22C5321E-005B-2348-B798-C36EF2D190B4',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023913.DIA.000','Cambridge Modular Wedge Unit, Grade D-Deep Chestnut','Finished Product',NULL,'Pcs'),('22F01347-90A7-7947-8A18-F7D9A8807D8A',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100021642.000.DAN','Ø245mm Steel Plate for Floor Standing Lamp w. SS cover, coated, Dark Anthracite','Finished Product',NULL,'Pcs'),('2313C4D3-4075-E141-BC42-3CB1DE681A29',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100017047','Harmony Bistro Table Base, Gray','Finished Product',NULL,'Pcs'),('232CF79A-ADB7-C44E-A8A2-64B801860302',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024808.000.ANT','Vera Alu Dining Side Chair, Teak Seat Anthracite','Finished Product',NULL,'Pcs'),('23AA71DE-7428-2246-B4A7-7559F41B69BF',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100011326.GRA.ANT100011326','Cube Alu Lounge Chair, teak arm, Anthracite','Finished Product',NULL,'Pcs'),('23CBF788-A2F9-4044-ADB5-7755BBC4A242',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:50:09','100021621.000.HOL100021621.000.000100021621','Maya Extending Table 235/330x100 cm','Finished Product',NULL,'Pcs'),('2449009D-04F0-7F4A-BC51-07ABB2E62B1E',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100024029.000.000','Jeberg Bistro Table 80x80','Finished Product',NULL,'Pcs'),('2489BE5A-B88F-1449-A8F9-054C8FFD4A6B',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100015821.000.000100015821','Cube Small Side Table (40x40x35cm)','Finished Product',NULL,'Pcs'),('248C9AE6-4732-3647-ACC8-1DCED3735324',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018159.000.000100018159','Vera Dining Chair, Slatted Teak Seat','Finished Product',NULL,'Pcs'),('24AE7883-6B16-3147-AFD1-B2B13D687FEE',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018988.000.000100018988','Halland Round Table Ø100cm','Finished Product',NULL,'Pcs'),('250CE5FC-8CB7-7A4E-85D4-0EF8627E91A0',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100013015.BLK.000100013015','Cube Ottoman, Charcoal','Finished Product',NULL,'Pcs'),('253387EE-555D-CA43-A91D-614A7509AB15',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023483','Pevero Butterfly Ext. Table 100x180/240cm','Finished Product',NULL,'Pcs'),('2658E847-0148-D943-B714-0F7E03FE42C9',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020747.000.000100020747','Cube Alu Dining Table, Teak Top 170x90 cm','Finished Product',NULL,'Pcs'),('27381F31-5AB0-884E-A00C-D86B6554E4DB',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 12:47:14','100024737.SLA.ANT100024737.000.ANT100024737.000.000','Cube Fire Table (LPG powered), CSA certified','Finished Product',NULL,'Pcs'),('275ED1AE-3446-5844-9D72-C937B9022999',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018815.ACH.000100018815','Cube Modular Corner Unit, Grade A','Finished Product',NULL,'Pcs'),('277A84E2-4E71-5046-87A8-2F01C7AC33FD',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022225.AGR.000','Cube Modular Panel Unit Left, Grade A-Grey','Finished Product',NULL,'Pcs'),('278C7029-1BE1-4F4F-85A6-F3737E9410BC',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024477.000.000','Vera Round Dining Table Ø120cm','Finished Product',NULL,'Pcs'),('27BD18F2-D875-5749-866E-E2FD104FE9A4',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020598.GRA.000100020598','Campaign Directors Chair, double cross, padded sling, Anthracite','Finished Product',NULL,'Pcs'),('289F904E-DEE9-DC49-A10D-01927D4C0DF7',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100011558.000.000100011558','Elements Pedestal Folding Table 80x80cm, Teak Top','Finished Product',NULL,'Pcs'),('2962CE85-E80B-8F48-BAC3-7AA6DF48B5C1',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018158.000.ANT100018158','Vera Dining Chair, Wicker Seat - Charcoal Loom','Finished Product',NULL,'Sets'),('2999E3DB-FF79-CB47-A01B-59B52C08D131',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020618.BLK.000100020618','Icon Sling Folding Arm Chair, Charcoal','Finished Product',NULL,'Pcs'),('2A9155C8-8DB6-9F48-8742-D4B7DB9DF76B',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023901.AWI.000','Cambridge Modular Arm Unit, Right, Grade A-Winter','Finished Product',NULL,'Pcs'),('2B4E8403-089B-BA4E-A1A6-8604B9279978',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024199.000.000','Jeberg Round Dining Table, Slatted Teak Top Ø132cm','Finished Product',NULL,'Pcs'),('2B5F3A4B-8FE8-D844-9F3F-096A76BCED5E',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100004344.BLK.000100004344','Frank Sun Lounger, Charcoal','Finished Product',NULL,'Pcs'),('2B636E5E-8412-064D-AD27-51032C769ADC',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021643.000.ANT100021643','Ø245 cm Steel Plate for Floor Standing Lamp','Finished Product',NULL,'Pcs'),('2C11F77F-BEED-614B-B157-C9C1AAAD9808',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018275.000.000100018275','Halland Rectangular Table 138x80cm','Finished Product',NULL,'Pcs'),('2CC5866D-B116-084D-BBE7-62AA6730DE31',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100020849.BLK.TPE','Casita 2 seater, right when seated - Taupe','Finished Product',NULL,'Pcs'),('2D6B8A99-E77E-104B-B744-73DACE468B87',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020850.BLK.GRE100020850','Casita 2 seater, Armless','Finished Product',NULL,'Pcs'),('2D85A3C3-D7B6-D943-B960-98FE1271F989',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024093.AWI.000','Maya Modular Arm Unit, Right Grade A','Finished Product',NULL,'Pcs'),('2D900D05-0CFB-E94E-A739-1838CFCD232D',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021120.BLK.BLK100021120','Vera Director\'s Chair, Charcoal','Finished Product',NULL,'Pcs'),('2DCCFB71-6E76-A743-A73C-5D16328EF79C',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023781.NAV.000','Mimpi Pouf Medium, Navy Ø65','Finished Product',NULL,'Pcs'),('2F30AE5B-E75C-0A4B-88D4-5F17AED4C4EA',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100022738.000.000','Cambridge Backless Bench 90cm','Finished Product',NULL,'Pcs'),('2F91242D-4671-3F4C-8F8A-44E922D68F0C',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022491.000.000','Cambridge Counter Height Side Chair','Finished Product',NULL,'Pcs'),('3028CBD0-A4BB-E040-863B-5479FEEA86D7',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024121.ABL.ANT','Vera Alu Modular Corner Unit, Grade A - Black - Rope Black','Finished Product',NULL,'Pcs'),('30CDEAF6-2D06-2D43-9DD4-7E93204A6DC5',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024125.000.ANT','Vera Alu Coffee Table 110x72cm, Low','Finished Product',NULL,'Pcs'),('3173B84E-4DD0-1043-9479-FECD631CB204',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021874.ACH.000100021874','Cube Modular Medium with Corner Table, Grade A','Finished Product',NULL,'Pcs'),('319F8D92-283C-8D47-A80D-5327CF317F0E',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100009750','Riva Dining Table 280x94cm','Finished Product',NULL,'Pcs'),('31D0EB30-F7C4-F843-92ED-05941F03B74B',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:50:09','100002700','Heritage 2 Seater (excl. brass feet)','Finished Product',NULL,'Pcs'),('328284AC-B41C-734F-9757-2C4CCE566EFB',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024500.000.000','Vera Folding Yacht Side Table (60x60x52cm/24x24x20.5\")','Finished Product',NULL,'Pcs'),('32BFEF91-D1C1-E84B-BD4A-5D7617D972CB',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021210.65B.BLK100021210','Otti Right Arm Facing Sectional Sofa-Black','Finished Product',NULL,'Pcs'),('32DA91EB-D754-644C-8CBB-A4C02ABC3A9E',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023913.TAU.SAN','Cambridge Modular Wedge Unit, Frame Only','Finished Product',NULL,'Pcs'),('332DA431-5F18-0845-979B-3B78C2CEBF86',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020617.HOL.ANT100020617','Cube Alu Dining Table, Alu Top 170x90cm (67\"x36\"), Anthracite Top/Charcoal Frame, with umbrella hole','Finished Product',NULL,'Pcs'),('33A7919C-0302-F943-83B2-3773F1C22D81',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023782.NAV.000','Mimpi Pouf Large, Navy Ø125','Finished Product',NULL,'Pcs'),('344DFD30-B3EF-5C49-98B3-0E1248AC5A38',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100004337.BLK.000100004337','Cube Lounge Chair, Charcoal','Finished Product',NULL,'Pcs'),('347C3BA9-FF92-5848-8B0E-D00B31815D02',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019103.REANT.ANT100019103','Glow Rope Pendant/Lantern Lamp, Small','Finished Product',NULL,'Pcs'),('3496FF75-1B9B-0847-8789-208CFCB62AEF',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020772.000.ANT100020772','i-konic teak pendant/lantern lamp, medium (38 cm)','Finished Product',NULL,'Pcs'),('3581AF55-F27F-B74D-A7EF-235FC3E863E2',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023874.HOL.ANT','Elements Alu Dining Table 140x80, Teak Top, w. umbrella hole, Anthracite','Finished Product',NULL,'Pcs'),('360A5146-7E72-1540-A46B-585050CB2717',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017688.000.000100017688','Cambridge Dining Table 220x100cm','Finished Product',NULL,'Pcs'),('37811DA0-72D7-284A-A77E-673981182C54',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100004245.TAU.000100004245','Maya Sling Side Chair, Sand','Finished Product',NULL,'Pcs'),('38A783CD-5117-C84B-89F4-35E6D04F78E5',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024120.STO.ANT','Vera Alu Modular Arm Unit, Right, Grade C - Stone Grey','Finished Product',NULL,'Pcs'),('38F86A49-3572-3E42-A5ED-85D6885FF19E',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100019063.GRA.ANT100021636','Cube Modular Extension Unit, Grade D, Coated','Finished Product',NULL,'Pcs'),('3907389D-1EB9-3145-A667-2C1DC03361F0',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023873.000.ANT','Elements Alu Dining Table 140x80, Teak Top, Anthracite','Finished Product',NULL,'Pcs'),('395959A5-03BF-D542-9CEA-832DA4A1E204',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100025198.000.HOL','Jeberg Bistro Table Ø90cm with umbrella hole','Finished Product',NULL,'Pcs'),('39BFDB65-D6D8-3C46-BBE3-919AF9B3D532',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100007199.BLK.000100007199','Stockholm 3 Seater, Charcoal','Finished Product',NULL,'Pcs'),('39CFD0AE-D486-8D4C-BB22-674F06B1C538',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023801','Campaign Directors Chair, double cross, padded sling, Ocean','Finished Product',NULL,'Pcs'),('39F5F485-9638-0646-9725-B400824F73FB',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100002274.ROANT.000100002274','Ellen Round Tube Rope Chair, Teak Arm','Finished Product',NULL,'Pcs'),('3A12D431-43D2-A140-89FF-502D31F7FC41',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100001728.BLK.000100001728','Frank Sling Dining Side Chair, Charcoal','Finished Product',NULL,'Pcs'),('3ABB2623-9B6B-8C44-9FA9-E7F6005E021D',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022001.000.000100022001','Vera Modular Corner Table','Finished Product',NULL,'Pcs'),('3B189766-FEC0-E741-8AC0-020D00CF9D4A',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016901.000.000100016901','Cambridge Stacking Arm Chair','Finished Product',NULL,'Pcs'),('3B8D36DF-497A-3947-9E0A-A3EDA757918B',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024115.SLA.ANT','Elements Alu Stacking Sun Lounger, Slate','Finished Product',NULL,'Pcs'),('3BA0A60C-0C2C-B74B-BE04-50E001F2062A',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100015454','Jett Sofa','Finished Product',NULL,'Sets'),('3BCB152C-3B10-8240-B744-8C3B8E804F69',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100009507','Riva Sofa 3 Seater','Finished Product',NULL,'Pcs'),('3C2F3440-104F-3B43-A887-C2422B6CB243',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100025176.000.DAN','Ø245mm Steel Plate for Floor Standing Lamp w. Alu cover, coated, Dark Anthracite','Finished Product',NULL,'Pcs'),('3EC61392-0AD2-E146-8BDF-AF1C54694A43',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021984.REANT.ANT100021984','Glow Rope Pendant/Lantern Lamp, Large','Finished Product',NULL,'Pcs'),('3F04513F-F898-6C41-AAC2-F13C3BE748FF',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023895.000.000','Jeberg Round Dining Table Ø150 cm, slatted teak top','Finished Product',NULL,'Pcs'),('3FA56C5D-6BD0-C441-8421-ADE45D89DC0A',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:51','100020379','Plateau XL Module Corner 134cm Incl.4L, BR, AR','Finished Product',NULL,'Pcs'),('402B950B-42B2-2147-A728-0DC82B988C40',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100010305','Plateau L Module end unit L/R / seat/back 112cm Incl. 4L, BR, AR','Finished Product',NULL,'Pcs'),('4042500E-2D40-2448-86ED-6C54C871B5D3',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022177.MUS.GRA100022177','Basket for Quadra sunbed, mustard','Finished Product',NULL,'Pcs'),('4047F27B-B042-B841-81D2-3C4279B8A6AF',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100018158.ROANT.ANT','Vera Dining Chair, Rope Anthracite','Finished Product',NULL,'Sets'),('407186C1-531B-FD4C-95A3-BF0CAC04213B',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021701.000.DAN100021701','MOON stand MAXI for pendant lamp, Dark Anthracite','Finished Product',NULL,'Pcs'),('40899D28-2EEA-DB4D-9FD2-A4D59CE08F5D',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023901.BRI.000','Cambridge Modular Arm Unit, Right, Grade C-Brisa','Finished Product',NULL,'Pcs'),('40AEA2AC-A9D9-BF40-853E-7887A4B95527',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100018967.BRI.TAU','Cambridge Seating 3 Seater with Cushion, Grade C-Brisa','Finished Product',NULL,'Pcs'),('414E59CC-F8DA-874D-99AD-2BE696019854',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100012182','Teak Arm for Soul Chair, sets','Finished Product',NULL,'Sets'),('415CDA4A-3E58-DB43-83BF-41380A3EF7DA',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021794.000.000100021794','Cambridge Bar Stool with Low Back','Finished Product',NULL,'Pcs'),('4294A2A5-7AA2-2A45-BB48-25E41C12663F',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100016724','Harmony Dining Table 100x100cm, Frame Only, Gray','Finished Product',NULL,'Pcs'),('4302F439-677F-EB46-95E1-62BE641317EF',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018348.000.000100018348','Cube Extending Table 230/320x95','Finished Product',NULL,'Pcs'),('445CA665-DBDD-5C4D-8A13-9A322D6F7B25',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020049.000.000100020049','Cube Large Side Table 71x58 cm','Finished Product',NULL,'Pcs'),('449F0769-1082-9A4D-AAAF-002F1C4FAFBC',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100008985','Safari Stacking Chair, Coal','Finished Product',NULL,'Pcs'),('44B173EB-FA9F-2B44-8B94-F05377AA4CD0',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024124.000.ANT','Vera Alu Coffee Table 110x72cm, High','Finished Product',NULL,'Pcs'),('44B9EE90-A5DC-8A40-9C80-6405214ADD59',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016510.BLK.000100016510','Cube Swivel Rocker, Charcoal','Finished Product',NULL,'Pcs'),('451401CE-97CF-C04E-B848-E7186238AF7F',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100010302','Plateau L Module table 112cm, Incl 4L','Finished Product',NULL,'Pcs'),('45B2E03B-53DD-754B-A129-D0C754202ADE',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100002467.BLK.000100002467','Maya Sun Lounger, Charcoal','Finished Product',NULL,'Pcs'),('4620765F-2A66-9C43-8D24-65C11C21AA5D',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017040.000.000100017040','Cambridge Tray Stand','Finished Product',NULL,'Pcs'),('46C1B492-6E10-1448-AC39-06CF92304811',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100015766.000.000100015766','Halland Dining Chair','Finished Product',NULL,'Pcs'),('4784199C-CA31-7E48-87D0-2366164B9029',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024104.AWI.000','Maya Modular Lounge Chair, Grade A','Finished Product',NULL,'Pcs'),('478AE3FA-008F-3441-9697-6DDD725DFE15',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020048.000.000100020048','Cube Coffee Table 120x80 cm','Finished Product',NULL,'Pcs'),('47B06D54-C0DC-AC4E-9511-3795D6850E00',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018270.000.000100018270','Cube Floor Standing Lamp','Finished Product',NULL,'Pcs'),('4812B87E-F3BC-0D46-B3E6-BF375C488936',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020206.NAV.000100020206','Mimpi scatter cushion (40x40 cm), Navy','Finished Product',NULL,'Pcs'),('48840924-8A5B-D049-A633-184D003D0AC0',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021202.000.000100021202','Cube Pendant/Lantern Lamp, Medium 41cm','Finished Product',NULL,'Pcs'),('489CD817-C6D4-C448-BB59-E76AEFF183B9',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:52','100022617.000.000','Cube Modular End Table (with 1 short  leg)','Finished Product',NULL,'Pcs'),('49368B64-C1E3-D946-AC1F-8BB882715A6B',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023956','Ester Lounge Chair with Cushion Grade A','Finished Product',NULL,'Pcs'),('499F1D09-802D-714C-AE3C-B2B075F35BFD',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100025279.000.HOL','Jeberg Bistro Table 80x80 w. umbrella hole','Finished Product',NULL,'Pcs'),('4B1EA90C-F078-2240-A7C8-9BB86419FD8C',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021533.000.000100021533','Maya Counter Height Dining Table 160x90x89cm','Finished Product',NULL,'Pcs'),('4B32B8EF-85EA-3340-918C-C4C7A2D73C39',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100002633.000.000100002633','Frank Teak Arm Chair','Finished Product',NULL,'Pcs'),('4BA16F65-F1DF-9443-AF3B-41341B4FA304',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100017976.000.HOL','Icon Folding Table Ø115 cm, umbrella hole','Finished Product',NULL,'Pcs'),('4BA20B20-6FD6-6E40-9F14-B09C0816E60F',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100018957.CGRA.TAU','Cambridge Seating Reclining Lounge Chair with Cushion Grade C-Graphite','Finished Product',NULL,'Pcs'),('4BC3D8D4-B170-A547-87D7-0A5B25A1268B',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 00:45:16','100001919','Kaffe Stacking Chair','Finished Product',NULL,'Pcs'),('4CF3C0C3-1CEE-DD43-A765-1EC6D6D0E45F',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:50:09','100002703','Heritage Side Table (excl. brass feet)','Finished Product',NULL,'Pcs'),('4DE20A46-78E5-EA4D-894C-C8E678781EA2',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:50:09','100021600.BLK.GRE100021600','Casita 2 seater, left when seated','Finished Product',NULL,'Pcs'),('4DFDD9C1-9A5A-0448-8CD9-91AC9B60E73B',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024117.000.000','Vera Modular End Table','Finished Product',NULL,'Pcs'),('4F22C9F3-F184-ED4B-A7C3-F1A29CD165B1',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018334.000.BLK100018334','Otti Rectangular Coffee Table (135x89x37cm), Black','Finished Product',NULL,'Pcs'),('4FB227A4-24D6-CF48-86C3-A0B6112563D1',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024100.000.000','Maya Modular Corner Table','Finished Product',NULL,'Pcs'),('503272D1-71B1-9F4D-99E0-8F93CC929CA3',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023875.000.ANT','Elements Alu Dining Table 240x100, Teak Top','Finished Product',NULL,'Pcs'),('50FDEA69-F1A1-3347-A2DE-160D5213BFA1',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100013456.DDA.000100013456','Cambridge Buffet Table, Day','Finished Product',NULL,'Pcs'),('5148CFAE-CA81-A64D-9CA5-6E555BDB17BB',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023033.000.000','Plank Dining Table Rustic Teak Top (240x100cm)','Finished Product',NULL,'Pcs'),('516DBAFC-1828-FE42-AF3B-1277A6C3CCFE',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100019948.000.000100019948','Icon Teak Folding Side Chair','Finished Product',NULL,'Pcs'),('52BAC5D5-2774-A847-A8F1-3A6442DDDE25',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020481.BLK.000100020481','Bromo Folding Deck Chair, (Ø34mm)','Finished Product',NULL,'Pcs'),('53D3D22A-F6ED-CE44-ADBA-C956BA97274B',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024732.HOL.ANT','Elements Alu Dutch Extending Table 164/286x100cm - 64/113x39\", umbrella hole','Finished Product',NULL,'Pcs'),('53E7318E-55D8-D34C-BF79-4B5F9DEDB4EE',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023785.000.ANT','Mimpi Tray Ø58cm, Medium, Anthracite','Finished Product',NULL,'Pcs'),('53EBA37C-20A8-E449-A836-E988B15A556F',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:45:15','100002712.BLK.000','Quadro Stacking Chair, Charcoal, w. Teak Arms','Finished Product',NULL,'Pcs'),('5413A6BE-D8CC-3C4D-9000-C7746352C4D1',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023781.ORG.000','Mimpi Pouf Medium Ø65, Orange','Finished Product',NULL,'Pcs'),('546531E1-44EF-C145-912A-531B466952FC',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100011858.SGN.000100011858','Maya Counter Height Wicker Chair','Finished Product',NULL,'Pcs'),('56A2D7D5-1268-714E-A2EF-E3AE42CE4754',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019063.ACH.000100019063','Cube Modular Extension Unit, Grade A','Finished Product',NULL,'Pcs'),('56AED18F-41DF-AC4E-8CC3-30FB5A49975D',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023976.000.000','Croquet Set','Finished Product',NULL,'Pcs'),('56E688E1-5423-684E-BA77-69BD6BBDA638',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022254.BLK.BLK100022254','Ellen Alu Sling Dining Chair, Charcoal','Finished Product',NULL,'Pcs'),('5729AA13-55D1-164D-A978-D4E95BCC5B66',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023784.000.ANT','Mimpi Tray Ø118cm, Large','Finished Product',NULL,'Pcs'),('5729BDF2-44A1-5749-B003-5F537F5E50F0',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024121.STO.ANT','Vera Alu Modular Corner Unit, Grade C - Stone Grey','Finished Product',NULL,'Pcs'),('57585E19-4990-9143-9C91-1092DD4708E4',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017975.000.000100017975','Icon Folding Table 140x78cm','Finished Product',NULL,'Pcs'),('59669F7D-49E6-1044-AA80-31647B581D55',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022496.000.000','Cambridge Dining Table 180x100cm','Finished Product',NULL,'Pcs'),('597CA1E0-2F79-8E4A-A357-5EE7B5AC14C9',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021193.ACH.000100021193','Cushion for Cambridge Seating Sofa 3 Seater, Grade A - Charcoal','Finished Product',NULL,'Units'),('5981B566-38DC-4040-9D76-02B28F691C95',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100002542.000.000100002542','Maya Side Table (50x50x40cm)','Finished Product',NULL,'Pcs'),('5A6BD315-BC99-9349-AC1E-9437C3A029FD',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100018957.BRI.TAU','Cambridge Seating Reclining Lounge Chair with Cushion Grade C-Brisa','Finished Product',NULL,'Pcs'),('5BAD6E73-0ED9-414B-B0DF-7413191D077E',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100003775.000.000100003775','Maya Coffee Table 70x60x45cm','Finished Product',NULL,'Pcs'),('5BF4C18A-477E-8043-A6F1-F0A36D069831',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023901.CNA.000','Cambridge Modular Arm Unit, Right, Grade B-Capt Navy','Finished Product',NULL,'Pcs'),('5BFAB2AB-CAC9-7A48-8C5A-4FCA4CF1F37A',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100021394.BLK.BLK','Cube Alu Sun Lounger, Charcoal','Finished Product',NULL,'Pcs'),('5C1E11AB-9F35-8D49-9175-1C3C4F8EF0B8',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021048.GRA.000100021048','Head Cushion for Bromo Deck Chair, Anthracite','Finished Product',NULL,'Pcs'),('5C5A40B1-4E4C-8A42-BA4B-3616FA061821',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100012296.BLK.000100012296','Maya Counter Height Chair, Charcoal','Finished Product',NULL,'Pcs'),('5C669F39-5E6F-F240-B1CD-323B7FB8876B',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023170','Fiori Swivel Rocker','Finished Product',NULL,'Pcs'),('5C9CE723-2082-7047-81B7-99B89586E290',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021213.65B.BLK100021213','Otti Left Arm Facing Sectional Chaise- Black','Finished Product',NULL,'Pcs'),('5D3BCC81-1B7B-D844-920E-B9B97D3A535F',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023964.BLK.GRE','Vera Alu Dining Chair, Wicker Seat - O. Green-Loom Charcoal','Finished Product',NULL,'Pcs'),('5D95F1F9-5C17-DD43-A5B2-83231764DC4F',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023765.BLK.BLK','Cube Alu Swivel Rocker, Charcoal','Finished Product',NULL,'Pcs'),('5DA101B4-E89E-1C47-9D09-F9AB4ECB4CEA',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023960.000.000','Elements Teak Table 240x100cm','Finished Product',NULL,'Pcs'),('5EF8656D-F485-374F-876A-1D26F510423D',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024090.AWI.000','Maya Modular Arm Unit, Left Grade A','Finished Product',NULL,'Pcs'),('5F06390E-179D-EE47-94FF-58E29BE86456',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022227.ACH.000100022227','Cube Modular Panel Unit Right, Grade A','Finished Product',NULL,'Pcs'),('5F943901-CC7B-F34D-A375-848AE90B25C3',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023963.000.ANT','Vera Alu Dining Chair, Teak Seat','Finished Product',NULL,'Pcs'),('6296AA3D-ECA2-4945-9D5B-A8B8A5B1DF6C',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018349.65B.BLK100018349','Otti Chaise, Black','Finished Product',NULL,'Pcs'),('62C23C04-570C-054C-8108-BEAF1DB525E9',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023247.000.TPE','Casita rect coffee table/ottoman - Taupe','Finished Product',NULL,'Pcs'),('62FE26AA-B63F-E449-94C6-FF2C7675E818',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100015224.000.000100015224','Maya Teak Dining Chair, Stackable','Finished Product',NULL,'Pcs'),('63B092D2-90E1-3E49-87AF-96655941C8ED',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100012407.STO.TAU','Cambridge Seating Swivel Rocker with Cushion, Grade C-Stone Grey','Finished Product',NULL,'Pcs'),('643A20BF-4794-354F-B598-2C5041E17557',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100019913.000.BLK100019913','Otti Round Occasional Table (Ø500mm), Black','Finished Product',NULL,'Pcs'),('647CD469-70DE-AE41-9FF3-E6325E0BBE54',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100017336','Jett Lounge Chair','Finished Product',NULL,'Sets'),('64AE7B2A-B2AC-EB43-8E0F-B98BE2EC1D97',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018321.000.BLK100018321','Otti Rectangular Dining Table (248x110x75cm), Black','Finished Product',NULL,'Pcs'),('64D8DC63-A9FD-C943-A438-7927A0913148',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019394.TAU.TAUPE100019394','Cambridge Seating Ottoman, Frame Only','Finished Product',NULL,'Units'),('653EFDCE-1BBE-854F-B4AF-039D475E0D8D',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021207.65B.BLK100021207','Otti Left Arm Facing Sectional Sofa-Black','Finished Product',NULL,'Pcs'),('658018B6-C11B-2341-9F7D-316103D84C9E',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020958.WHT.000100020958','Icon Sling Folding Side Chair, Chalk','Finished Product',NULL,'Pcs'),('67A41E83-3FC1-7442-9AD6-43BD266121FB',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016900.000.000100016900','Cambridge Side Chair','Finished Product',NULL,'Pcs'),('67EE935B-482C-4E46-86A7-92A0CED372AE',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:50:09','100008562','Quadro Table 150x100cm','Finished Product',NULL,'Pcs'),('6803B50D-5DC2-DF42-B628-956CE30E254E',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023767.CEANT.ANT','Cube Alu Dining Table 230x95cm, Ceramic Top, Anthracite Frame/Anthracite Top','Finished Product',NULL,'Pcs'),('683F1F2C-64C0-434B-B861-7829809A2404',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023867.000.000','Elements Teak Table 160x100cm','Finished Product',NULL,'Pcs'),('68E2C68A-2BFF-7F45-AB21-9A68767DAC48',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023968.000.ANT','Eleanor Dining Chair, anthracite','Finished Product',NULL,'Pcs'),('68F71E5D-6A01-7E43-AA95-36FF7C207B1A',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024118.STO.ANT','Vera Alu Deepseating Lounge Chair, Grade C - Stone Grey','Finished Product',NULL,'Pcs'),('6964F9CB-7A27-DD48-B277-1924B73EA4BB',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020694.HOL.ANT100020694','Cube Alu Dining Table, Slatted Alu Top 230x95 cm, Anthracite Top/Charcoal Frame, with umbrella hole','Finished Product',NULL,'Pcs'),('6AA281E3-F469-0947-ACEB-6BE78F551811',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018501.000.000100018501','Cambridge Bench 160cm','Finished Product',NULL,'Pcs'),('6B449371-6C91-CA4F-9C0E-4EF76AEC7F4A',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022497.000.HOL100022497.000.000','Cambridge Round Dining Table Ø132cm','Finished Product',NULL,'Pcs'),('6C132173-BEFA-454D-8593-960AC79111E5',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024119.STO.ANT','Vera Alu Modular Arm Unit, Left, Grade C - Stone Grey','Finished Product',NULL,'Pcs'),('6C31807D-6537-9647-B5AD-9351BB0DE0BF',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021205.65B.BLK100021205','Otti Three-Seat Sectional Sofa-Black','Finished Product',NULL,'Pcs'),('6CEDA31C-7C92-0E41-A34C-B54432F0FE0A',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023945.HOL.NAV','Elements Alu Dining Table 160x100, Teak Top, w. umbrella hole, Navy','Finished Product',NULL,'Pcs'),('6CF3C424-87EA-5A4F-A045-F05088820BC5',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100022527.WBG.TAU','Ellen Alu Round Tube Club Chair, Linen Coated T','Finished Product',NULL,'Pcs'),('6D242FFD-85A1-124B-A2EE-C493C1FCBB49',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023973.RANT.000','Luna Rug Square (300x300cm/118x118\")','Finished Product',NULL,'Pcs'),('6D2C5489-7438-6C47-B08C-C57AA83794F1',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021705.000.DAN100021705','MOON solar standing lamp MIDI, Dark Anthracite','Finished Product',NULL,'Pcs'),('6D3D7016-79F1-8B48-BE22-ECB3138FA848',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100002540.000.HOL100002540.000.000100002540','Maya Dining Table 90x90x74cm','Finished Product',NULL,'Pcs'),('6D52290F-C4C1-FD4C-90D0-6360988FA48D',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:50:09','100019536','Lilium Lounge Chair, teak/ ss','Finished Product',NULL,'Pcs'),('6D5B747A-D015-DE40-808B-A1228F690985',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023768.000.ANT','Cube Alu Coffee Table 120x80 cm, Anthracite','Finished Product',NULL,'Pcs'),('6D92214E-AF3B-FD46-AF26-847E3B529154',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020133.000.000100020133','Adirondack Side Table','Finished Product',NULL,'Pcs'),('6E5DB69A-C533-B347-8AFD-56F6976503A5',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023248.000.TPE','Casita square coffee table/ottoman - Taupe','Finished Product',NULL,'Pcs'),('6ED003A8-2576-CE4F-B619-BE91F3AA7A27',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020110.BEI.ANT100020110','Opti Round Coffee Table Ø100cm, Ceramic B-A','Finished Product',NULL,'Pcs'),('6EFFBB04-1E54-FF4D-A926-230E54FA8944',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020776.ANT.ANT100020776','i-konic Rope Pendant/Lantern Lamp, Large','Finished Product',NULL,'Pcs'),('6FE39884-A359-1644-B64A-F35C1305F3BE',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023361.000.FSC','Note chair w. armrest, FSC 100%','Finished Product',NULL,'Pcs'),('711AA6E3-665D-7642-A878-3F308CF881D6',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100012039','Riva Side Table Teak Base/Teak Top D480mm','Finished Product',NULL,'Pcs'),('7123CD37-2C08-0246-91EC-84E47D2EECCB',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017976.000.000100017976','Icon Folding Table Ø115 cm','Finished Product',NULL,'Pcs'),('7128855C-4E05-0042-9DF4-B935029A985A',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018320.65B.BLK100018320','Otti Dining Chair, Black','Finished Product',NULL,'Pcs'),('71D34486-0709-544D-9F4F-AC1AA101B8F9',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023965.AWI.ANT','Vera Alu Dining Chair, Upholstered Seat, Grade A','Finished Product',NULL,'Pcs'),('729AC6DE-0A75-5E45-AC8F-9F94A6063DCD',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022129.000.000100022129','Cambridge Backless Bench 150cm','Finished Product',NULL,'Pcs'),('72B4A719-2509-034D-9317-B3EAC9CB74E0',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023905.TAU.SAN','Cambridge Modular Extension Unit, Frame Only','Finished Product',NULL,'Pcs'),('742E1960-D2D5-174F-95B4-582A381CC49C',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021134.HOL.ANT100021134.000.ANT100021134','Opti Dining Table, Teak Top 220x100 cm, with umbrella hole','Finished Product',NULL,'Pcs'),('743372A8-B53C-9C47-936D-A58B10E807AA',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022490.000.000100022490','Cambridge Stool','Finished Product',NULL,'Pcs'),('74571DA6-42CD-E64D-BD4E-40D8BFFE7463',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017030.000.000100017030','Cambridge Cutting Board, 560x380x28mm','Finished Product',NULL,'Pcs'),('74CBEB0A-1E69-D74A-8207-10C3CF4DEB0A',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023772.BLK.000','Cube 3 Seater Sofa, Charcoal','Finished Product',NULL,'Pcs'),('7562814B-CCE2-EE4E-828B-28E567828EF3',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 12:50:09','100023876.HOL.WHT','Elements Alu Dining Table 240x100, Teak Top, w. umbrella hole, White','Finished Product',NULL,'Pcs'),('75EA4928-E7A1-6F49-86D5-6C2E2E519FC5',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023876.HOL.ANT','Elements Alu Dining Table 240x100, Teak Top, w. umbrella hole, Anthracite','Finished Product',NULL,'Pcs'),('7724128C-C8AF-504D-81EA-57E602CC820A',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020400.000.000100020400','Vera Round Dining Table Ø120cm, solid teak top','Finished Product',NULL,'Pcs'),('77299911-D916-EC43-8232-02101209F01A',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023769.000.ANT','Cube Alu Large Side Table 71x58 cm, Anthracite','Finished Product',NULL,'Pcs'),('78A82847-098F-F44A-874D-C9934D47626F',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100023356.WBG.BLK.FSC100023356.000.FSC100023356','Pelagus Lounge Chair, FSC 100%','Finished Product',NULL,'Pcs'),('78AF4047-2704-EF4A-840B-47EAC5554382',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018502.000.000100018502','Cambridge Bench 190cm','Finished Product',NULL,'Pcs'),('78CBDFAB-7CFD-E446-815F-028F5D27C9F9',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021203.000.000100021203','Cube Pendant Lamp, Large 51cm','Finished Product',NULL,'Pcs'),('79298B4E-7CB9-BE4F-9CCC-7635DEB67F4D',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024115.WHT.WHT','Elements Alu Stacking Sun Lounger, Chalk','Finished Product',NULL,'Pcs'),('798B255E-7EA2-B94D-91B0-DE112015ED3B',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020111.WIN.ANT100020111','Opti Dining Table ,Ceramic Top 220x100 cm, W-A','Finished Product',NULL,'Pcs'),('79CF3243-0C49-E247-B151-8FDECF6E8AA5',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100002712.DUN.000100002712','Quadro Stacking Chair, Dune, w. Teak Arms','Finished Product',NULL,'Pcs'),('7A29E053-C6CE-184B-B40E-22F1563CBAA9',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100022518.BLK.000100022518','Ellen Ottoman, Charcoal','Finished Product',NULL,'Pcs'),('7B0F815F-B1A4-424E-BC3C-50FCE554B260',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022498.000.000','Cambridge Round Extending Table 138/183x138cm','Finished Product',NULL,'Pcs'),('7B673A82-657F-9B47-B196-E4F3A8D2B57F',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020762.000.ANT100020762','i-konic Teak Floor Standing Lamp','Finished Product',NULL,'Pcs'),('7B91EE07-8AD5-534A-A292-2B1E96549FE0',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023462.NAV.000','Luna Beach Bag, Navy/White','Finished Product',NULL,'Pcs'),('7C271F51-C3EC-C040-9263-20DD798003FB',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100013456.CEANT.000','Cambridge Buffet Table, Anthracite DT','Finished Product',NULL,'Pcs'),('7C7CBE9D-AAC5-3D4B-B287-116CA72F42EF',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022229.000.HOL','Vera Dining Table solid teak top 160x90cm, with umbrella hole','Finished Product',NULL,'Pcs'),('7C8B792C-59C9-0747-B8D5-5EA2DB37F534',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 00:43:49','100002499','Heritage Teak Swatch with Embedded Logo 58x75x6mm','Finished Product',NULL,'Pcs'),('7D86DB06-3573-2040-B40A-ABA6027FF7B6',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100024040.000.000','Maya Dining Table 90x90x74cm, No umbrella Hole','Finished Product',NULL,'Pcs'),('7E1E9C07-0B8C-7945-BE7D-CE4A0E8E5724',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023977.COP.000','Mimpi Beach Bag, Copper','Finished Product',NULL,'Pcs'),('7E99DF98-8187-FE4E-906B-71750E91A236',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022240.BLK.ANT100022240','Opti Side Chair, Coated','Finished Product',NULL,'Pcs'),('7ECCF3A9-2734-EC41-8C13-3CF28084043D',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017968.ROANT.000100017968','Stockholm Rope Dining Chair','Finished Product',NULL,'Pcs'),('7F2C6B9F-544F-9F4E-8E69-91F4554BDDF5',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100020694.HOL.ANT.ANT',NULL,'Finished Product',NULL,'Pcs'),('8158E265-EB5B-0243-BF11-8B5512C2D409',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100023247.000.GRE100023247','Casita rect coffee table/ottoman - Grey','Finished Product',NULL,'Pcs'),('819BBABB-F059-694A-BA54-CFDD73BF69C3',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023945.HOL.ANT','Elements Alu Dining Table 160x100, Teak Top, w. umbrella hole, Anthracite','Finished Product',NULL,'Pcs'),('81BBCAF8-6CE3-4A48-8A73-1C62225D8F8A',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023896.000.000','Icon Folding Steamer Chair','Finished Product',NULL,'Pcs'),('83206AA7-4688-7048-9EB1-18145CEA6F83',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022499.000.000','Cambridge Oval Extending Table 240/300x100cm','Finished Product',NULL,'Pcs'),('83D45D26-B443-3741-A4CA-125A59F581A9',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100020112.SAN.000','Vera Modular Corner Unit, Grade A-Taupe','Finished Product',NULL,'Pcs'),('84DF4B31-1C50-9449-9A88-4D4A71A3F1B8',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017689.000.000100017689','Cambridge Dining Table 275x100cm','Finished Product',NULL,'Pcs'),('853E085F-1C2A-CA42-AC62-7275321E1559',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:50:09','100002701','Heritage 3 Seater (excl. brass feet)','Finished Product',NULL,'Pcs'),('86790852-4343-AA4E-BB28-481770AC63C3',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100023240.000.000100023240','Elements Pedestal Folding Table 80x80cm, HPL Top','Finished Product',NULL,'Pcs'),('87EB437C-FC2E-F94D-AE31-73BD212A56CE',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021163.ANT.ANT100021163','i-konic Rope Floor Standing Lamp','Finished Product',NULL,'Pcs'),('88C0944B-FDAC-554A-9D7C-C7E42D209EE7',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100022781.000.000100022781','Cambridge Bar Height Side Chair','Finished Product',NULL,'Pcs'),('8961DE69-5F78-2E47-ABBA-EABB9F6310CA',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022503.000.000','Halland Club Chair','Finished Product',NULL,'Pcs'),('8998228B-CF7E-D64B-8FCF-B29DB50806D0',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022495.000.000100022495','Cambridge Bench 135cm','Finished Product',NULL,'Pcs'),('89EA24A8-348E-6542-B7F3-95294F51ED44',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100003526.000.000100003526','Cube Conversation Table (Ø120cm)','Finished Product',NULL,'Pcs'),('8A6E333D-72AB-0548-8B83-3DEA9ECDD022',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016739.CEANT.000100016739','Stockholm Dining Table, Ceramic Top 220x95cm, Anthracite','Finished Product',NULL,'Pcs'),('8AFB7CD8-A2D5-8746-9912-E13227F1A5E6',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024143.000.HOL','Jeberg Round Dining Table, Slatted Teak Top Ø180cm, umbrella hole','Finished Product',NULL,'Pcs'),('8B8211E7-B469-424E-8684-BED660F66CEA',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:50:09','100002706','Heritage Large Coffee Table 64x140cm (excl. brass feet)','Finished Product',NULL,'Pcs'),('8C11150C-C07D-154B-AC66-79821FCF7E95',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018336.000.BLK100018336','Otti Rectangular Side Table (89x61x37cm), Black','Finished Product',NULL,'Pcs'),('8C86CA5D-21A7-6847-A7FC-F68D76897034',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100019063.FOS.000','Cube Modular Extension Unit, Grade C-Fossil','Finished Product',NULL,'Pcs'),('8CFF9C9D-F6EF-CD46-8D8C-F65432FC4785',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023137.000.000','Mirror, frame only, 80x80 cm','Finished Product',NULL,'Pcs'),('8D100D45-EEFE-6B4D-A7A9-395765EF60A2',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024994.000.000','Arch Lamp, Small (s.steel frame)','Finished Product',NULL,'Pcs'),('8DB1C1C0-4E2E-5C41-8196-7C48258D2E61',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016902.000.000100016902','Cambridge Stacking Side Chair','Finished Product',NULL,'Pcs'),('8DF12741-9B50-384B-844C-92B745BFCBA1',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100013365.BLK.000100013365','Frank Ottoman, Charcoal','Finished Product',NULL,'Pcs'),('8E7F0084-1F40-284E-A55D-921ECDDC0D13',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100011127.BLK.000100011127','Ellen Round Tube Sling Chair, Teak Arm, Charcoal','Finished Product',NULL,'Pcs'),('8FC0A9EB-C66B-394A-87EA-D047EB7284BF',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020849.BLK.GRE100020849','Casita 2 seater, right when seated','Finished Product',NULL,'Pcs'),('8FCDB46D-55A5-7045-8ECC-600E3B8D410C',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024995.000.000','Arch Lamp, Medium (s.steel frame)','Finished Product',NULL,'Pcs'),('903E447F-4538-EC42-864C-D1ABAD8AC60E',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100012407.AGR.TAU','Cambridge Seating Swivel Rocker with cushion, Grade A-Grey','Finished Product',NULL,'Pcs'),('90EB7D73-887C-574B-A139-933315AC441C',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019397.000.000100019397','Optional headrest for Cambridge Seating','Finished Product',NULL,'Units'),('9183B8F3-9136-1940-B610-355FAB5D777F',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:52','100022527.BLK.BLK','Ellen Alu Round Tube Club Chair, Charcoal','Finished Product',NULL,'Pcs'),('928513D9-FB69-5C4C-A125-AA3D546C5EF7',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:50:09','100013396.000.HOL100013396.000.000100013396','Maya Extending Table 170/280x100 cm','Finished Product',NULL,'Pcs'),('9293B4E2-2688-4E41-8CD1-A7F31C0A9297',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 12:47:14','100024830.000.000100024830.000.ANT','Vera Pedestal Folding Table with Round Teak Top','Finished Product',NULL,'Pcs'),('93065F8B-B11F-C84D-9315-341DEFF917A2',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100021624.SAN.000','Vera Modular Arm Unit, Right, Grade A-Taupe','Finished Product',NULL,'Pcs'),('93102A30-8F49-2C45-85A5-7714F66531E2',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016898.000.000100016898','Cambridge Arm Chair','Finished Product',NULL,'Pcs'),('9353B82B-4DDB-4146-91B9-02B09F4CEB1C',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:51','100020879','Paton Alu Lantern/Pendant Lamp','Finished Product',NULL,'Pcs'),('93B8B969-CC99-764D-8AD8-F891ED560213',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023978.BLWIN.000','Luna Tote Bag, Charcoal/Winter','Finished Product',NULL,'Pcs'),('94951A63-3795-124E-A912-2C78E49BCFCA',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021637.WHT.WHT100021637','Cube Alu Stackable Sun Lounger, Chalk','Finished Product',NULL,'Pcs'),('950B0C92-CB1B-FF46-B5B0-860E72F3385E',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023776.000.ANT','Cube Dog Bed, Large, Grade A-Charcoal','Finished Product',NULL,'Pcs'),('95952B18-5591-6D4F-A892-DF5F76FCD253',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023868.HOL.000','Elements Teak Table 160x100cm, umbrella hole','Finished Product',NULL,'Pcs'),('963B9F1C-D8BF-E44B-B07C-569EF7E6ADD5',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023876.HOL.NAV','Elements Alu Dining Table 240x100, Teak Top, w. umbrella hole, Navy','Finished Product',NULL,'Pcs'),('982FBAFD-B5C3-8C4F-B423-8B7FDEACF803',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100018813.FOS.000','Cube Modular Arm Unit Left, Grade C-Fossil','Finished Product',NULL,'Pcs'),('98B6BCF1-DEE4-F549-939B-57268DDD9E6A',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022460.000.ANT100022460','Cube Planter Ø48cm','Finished Product',NULL,'Pcs'),('98F25818-EFC0-EB4B-A9CF-630D8A0BE567',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100002336.BLK.000100002336','Maya Ottoman, Charcoal','Finished Product',NULL,'Pcs'),('9AEDF3E1-CBE4-D440-90A4-4081C6FDC692',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100014886.WHT.WHT100014886','Harmony Stackable Chair, White','Finished Product',NULL,'Pcs'),('9B4BAFF6-20DC-A044-82EC-BF4B1E80B974',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100012735.BLK.000100012735','Stockholm Swivel Rocking Lounge Chair, Charcoal','Finished Product',NULL,'Pcs'),('9BA654D0-0051-1048-9410-AAF5681FB6A4',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020132.000.000100020132','Adirondack Footstool','Finished Product',NULL,'Pcs'),('9BC02D75-9C0F-D041-A6CF-72423A5B3512',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019186.HOL.000100019186.000.000100019186','Vera Round Dining Table Ø120cm, w. umbrella hole','Finished Product',NULL,'Pcs'),('9C12BF21-047B-AB48-A995-9ACE395EA99E',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100012232.BLK.000100012232','Stockholm Recliner Lounge Chair, Charcoal','Finished Product',NULL,'Pcs'),('9C798ABD-4ABE-B84C-A75E-956411724397',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100011331.000.ANT100011331','Cube Alu Dining Table, Teak Top 230 x 95 cm','Finished Product',NULL,'Pcs'),('9CA1D86D-06DE-7840-972E-4F6B5B0FCE6E',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:50:09','100002705','Heritage Sunlounger (excl. brass feet)','Finished Product',NULL,'Pcs'),('9F187B0E-558E-574F-94CE-6C144CB866AC',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023905.DIA.000','Cambridge Modular Extension Unit, Grade D-Deep Chestnut','Finished Product',NULL,'Pcs'),('9F47F58F-55F1-7347-993B-9318AEEE602B',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021624.FOS.000100021624','Vera Modular Arm Unit, Right, Grade C-Fossil','Finished Product',NULL,'Pcs'),('A0570951-A90A-5949-8124-720350E72D6A',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023782.SIL.000','Mimpi Pouf, Silver Ø125','Finished Product',NULL,'Pcs'),('A072D330-F770-2748-A48E-D11DBA58FDB7',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100009748','Riva Lounge Chair','Finished Product',NULL,'Pcs'),('A08F85BE-C0EC-CA42-937D-6B34CB077718',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100003166.000.HOL100003166.000.000100003166','Maya Dining Table 160x90x74cm','Finished Product',NULL,'Pcs'),('A0AA0FFB-B8FE-A840-9694-843C7AF8A71C',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023017','Alu Pad for Studio Lounger','Finished Product',NULL,'Sets'),('A0E68F9A-BCB2-D743-B814-C393C1C60109',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023778.000.ANT','Cube Teak Trash Receptacle, Side Opening','Finished Product',NULL,'Pcs'),('A0FFD27C-2DFB-C64C-AD0C-5848723E9CD1',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024476.000.000','Vera Dining Table 240x100cm','Finished Product',NULL,'Pcs'),('A106E059-FF96-AD46-B46B-4EF57480B789',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019185.000.000100019185','Icon Gate Leg Table, Rectangular','Finished Product',NULL,'Pcs'),('A191D0BB-2FFC-8D4D-A4E9-CC84085670B1',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100021801.BLK.ANT','Cube Alu Stacking Chair, teak arm, Charcoal A','Finished Product',NULL,'Pcs'),('A1CF4734-AF7C-A947-B084-082F90F8213A',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024103.AWI.000','Maya Modular Corner Unit, Left Grade A','Finished Product',NULL,'Pcs'),('A2834495-F27B-334F-9CA5-C7BCF237323D',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020046.ROANT.ANT100020046','Stella Dining Chair, Rope Seat, Anthracite','Finished Product',NULL,'Pcs'),('A31FD898-BE4B-7F45-8CD0-5CF3D63DDBAC',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100024030.000.000','Jeberg Bistro Table Ø90cm','Finished Product',NULL,'Pcs'),('A549ACBA-158D-2047-8583-E45C4D974F47',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100007088.BLK.000100007088','Stockholm Sun Lounger, Charcoal','Finished Product',NULL,'Pcs'),('A60BD7F9-98FD-F746-9E95-13B7C03FAF21',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100014851.000.HOL100014851.000.000100014851','Maya Round Dining Table Ø120cm','Finished Product',NULL,'Pcs'),('A60C8627-27A7-1245-BC1B-0005FAC955EE',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020479.000.000100020479','Lilium Armchair, teak/ss','Finished Product',NULL,'Pcs'),('A63CB4B0-5119-4D41-A062-86F3B292B5B6',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022456.000.ANT100022456','Cube Alu Backless Bench','Finished Product',NULL,'Pcs'),('A6615DAF-C58F-284D-BE24-5848B8F6F33B',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018157.ABL.ANT100018157','Vera Dining Chair, Upholstered Seat, Grade A','Finished Product',NULL,'Sets'),('A6B688D7-9DDF-5D41-854E-D428B676622C',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021144.000.000100021144','Ground Spear for Floor Standing Lamp','Finished Product',NULL,'Pcs'),('A6CD5223-410A-EC4D-A7C2-9B473487764D',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020690.000.000100020690','Vera Side Table 72x72cm','Finished Product',NULL,'Pcs'),('A71499AE-A383-6E44-865D-DF9E7563B17F',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024123.000.ANT','Vera Alu Modular End Table','Finished Product',NULL,'Pcs'),('A722C194-1EF5-F644-B499-8A8F38BE32E9',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100011128.BLK.000100011128','Ellen Round Tube Club Chair, Teak Arm, Charcoal','Finished Product',NULL,'Pcs'),('A72D5ABD-2DC1-694B-9EDD-5BEA87BB099C',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023901.DIA.000','Cambridge Modular Arm Unit, Right, Grade D-Deep Chestnut','Finished Product',NULL,'Pcs'),('A773A1DD-F8B3-3C4D-9328-971E556E6EAD',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100021162','Paton SS Lantern/Pendant Lamp','Finished Product',NULL,'Pcs'),('A7B60293-CA23-0B48-84CF-05CFE3567F41',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100012382.000.000100012382','Maya Round Dining Table Ø80cm','Finished Product',NULL,'Pcs'),('A7FD303D-D698-8F49-B9F2-9D2A565CD6E8',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024118.BRI.ANT','Vera Alu Deepseating Lounge Chair, Grade C - Brisa','Finished Product',NULL,'Pcs'),('A962CC8D-797C-E847-8854-B05D5DBAAF9B',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100013347.BLK.000100013347','Frank Lounge Chair, Charcoal','Finished Product',NULL,'Pcs'),('A9F5B152-7767-7449-8E51-07CA4261A6F6',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:50:09','100020779.BLK.000100020779','Maya Bar Height Chair, Charcoal','Finished Product',NULL,'Pcs'),('AAAE8914-6409-B34E-861B-152ED5D5B09A',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:52','100022637.000.000','Mirror, frame only, 220x80 cm','Finished Product',NULL,'Pcs'),('ABB3A115-A655-9843-9F8A-04C27B6F5AF2',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100021159','Roped Lantern/Pendant Lamp, Anthra-Turquoise','Finished Product',NULL,'Pcs'),('ABDCCD33-47E0-7648-A432-63FE4C8836B1',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100015678.BLK.000100015678','Bromo Deck Chair, Charcoal','Finished Product',NULL,'Pcs'),('AC20C354-74A9-B44B-9DEE-3C9D905DCECD',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100024039.000.000','Maya Extending Table 170/280x100 cm, No umbrella Hole','Finished Product',NULL,'Pcs'),('AC28A162-FAF7-5E4F-977D-E050C7C554DD',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020113.FOS.000100020113','Vera Modular Arm Unit, Left, Grade C-Fossil','Finished Product',NULL,'Pcs'),('AD3CEC34-A4A9-A04B-B50F-6DCF31305BFA',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020754.000.ANT100020754','i-konic teak pendant/lantern lamp, small (30 cm)','Finished Product',NULL,'Pcs'),('AD8CF93C-2920-1948-A766-36166BF8288F',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024808.000.NGR','Vera Alu Dining Side Chair, Teak Seat Nimbus Grey','Finished Product',NULL,'Pcs'),('AD92620A-1202-BD41-9E76-D817C262195F',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100022463.000.BLK','Aluminium Cover for Cube Planter, Charcoal','Finished Product',NULL,'Pcs'),('AFE90E6C-A28C-2445-B8E8-C4A8C301EA71',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021876.000.000100021876','Cube Modular Extra Large with Corner Table, Grade A','Finished Product',NULL,'Pcs'),('B0069ED5-304D-AD4F-B0A5-380363E9967C',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021793.000.000100021793','Cambridge Counter Stool with Low Back','Finished Product',NULL,'Pcs'),('B024373E-774E-D34B-BCAB-3237516FCA12',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021362.000.000100021362','Cambridge Cushion Chest','Finished Product',NULL,'Pcs'),('B1B393E4-E6FC-1748-AA84-D063A34A4F99',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021135.000.ANT100021135','Opti Round Coffee Table Ø100cm, Teak Top','Finished Product',NULL,'Pcs'),('B233A352-9122-6B46-AA58-1E22A189B06A',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024996.000.000','Arch Lamp, Large (s.steel frame)','Finished Product',NULL,'Pcs'),('B24D6A53-9480-E04B-82EC-501390372F89',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100023248.000.GRE100023248','Casita square coffee table/ottoman - Grey','Finished Product',NULL,'Pcs'),('B48F5F49-952B-E844-A7E9-CAE7C8B156E7',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017050.000.000100017050','Cambridge Serving Tray Small','Finished Product',NULL,'Pcs'),('B4FCED12-639D-1F47-9100-4CF68CFD5CAB',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100013198.BLK.000100013198','Stockholm Ottoman, Charcoal','Finished Product',NULL,'Pcs'),('B5358FEF-059A-634D-B2D8-551DF1F3E319',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017935.65B.BLK100017935','Otti Lounge Chair, Black','Finished Product',NULL,'Pcs'),('B5B02BF9-DB77-9545-A91E-D10B6526A545',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016315.000.000100016315','Optional Arms for Stockholm Sun Lounger','Finished Product',NULL,'Pcs'),('B6073086-8B3A-764A-8CD1-68C17AC9209C',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100020850.BLK.TAU','Casita 2 seater, Armless - Taupe','Finished Product',NULL,'Pcs'),('B64242BF-3030-AF46-A1E8-DC21A1F1FA75',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100019063.000.000','Cube Modular Extension Unit, Frame only','Finished Product',NULL,'Pcs'),('B7085528-4D89-354F-947B-5DBAB35DAA56',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019130.CLK.000100019130','Cube Sideboard, Beige Ceramic','Finished Product',NULL,'Pcs'),('B720A79E-26B7-794B-8BDD-0716EE489792',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:51','100020875','Rectan Alu Floor Standing Lamp','Finished Product',NULL,'Pcs'),('B7342918-D826-0A4A-82BA-019EF8064613',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019537.000.000100019537','Lilium Table 160, teak/ ss','Finished Product',NULL,'Pcs'),('B8DEA046-6A24-FD42-BDC5-572CD84319F9',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022002.000.000','Cambridge Square Counter Height Table 80x80x90 cm','Finished Product',NULL,'Pcs'),('B8FA13B3-807C-7648-83B2-568D4555DC79',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023969.SLA.ANT','Eleanor Square Dining Table, Ceramic Top 80x80cm (31.5x31.5\")','Finished Product',NULL,'Pcs'),('B9810928-98B0-4B4C-AA01-EC2C550C3773',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021879.ACH.000100021879','Cube Modular Large, Grade A','Finished Product',NULL,'Pcs'),('B98CD758-1443-F64A-8C54-CA9C5533432E',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019184.000.000100019184','Icon Gate Leg Table, Oval 127 x 104  cm','Finished Product',NULL,'Pcs'),('B9DADA60-5FAC-F541-A16F-90B7831E481C',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018779.TAU.TAUPE100018779','Cambridge Seating 2 Seater, Frame Only','Finished Product',NULL,'Pcs'),('BA1CB906-7979-9345-B7E3-51CE1A3FF268',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100021637.WHT.NAV','Cube Alu Stackable Sun Lounger, Chalk Coated N','Finished Product',NULL,'Pcs'),('BC846FC4-2986-5542-9C0F-760E896A27D2',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023359.000.FSC','Note Chair, FSC 100%','Finished Product',NULL,'Pcs'),('BCCB1F5D-CFE7-E444-9B4C-6FEE6BD9D029',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020709.000.000100020709','Vera Coffee Table 110x72cm, Low','Finished Product',NULL,'Pcs'),('BE08EAE9-142F-274C-93C7-1389BF894C01',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 00:43:49','100001797','Kaffe Folding Table','Finished Product',NULL,'Pcs'),('BEBE2E26-E200-1B4A-8E48-986F75C1350B',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020131.000.000100020131','Adirondack Chair','Finished Product',NULL,'Pcs'),('BF19F5C9-A5B3-8744-BE95-2A1A65A03C7B',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100020715.AWI.000','Vera Modular Medium with Corner Unit, include cushion, A-Winter','Finished Product',NULL,'Pcs'),('C13B0973-CD7A-754D-8E68-2D92D57D46AA',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023779.000.ANT','Cube Teak Trash Receptable, Top Opening','Finished Product',NULL,'Pcs'),('C14051CA-7C48-254B-ADDF-FB3621C27CA0',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021190.ACH.000100021190','Cushion for Cambridge Seating Sofa 2 Seater, Grade A-Charcoal','Finished Product',NULL,'Units'),('C34EC5ED-85FC-4647-808F-21820C69373A',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:51','100019535','Lilium Chair, teak / ss','Finished Product',NULL,'Pcs'),('C46B42D4-BBC7-DB49-985A-67519187062D',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024122.000.ANT','Vera Alu Modular Corner Table','Finished Product',NULL,'Pcs'),('C486EFD5-D5EF-1F4E-ABB9-295B4DEC854E',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100002335.BLK.000100002335','Maya Club Chair, Charcoal','Finished Product',NULL,'Pcs'),('C4949EA0-DCB6-8F43-85BA-1309A85DE3A3',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100023164100023164.BLK.000','Derry Sling Dining Chair, Phifer','Finished Product',NULL,'Pcs'),('C4C1F134-9E4E-9143-A788-296398C4C56E',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022502.SGN.000100022502','Maya Bar Height Wicker Chair','Finished Product',NULL,'Pcs'),('C4D2168F-65A0-194F-956B-15468321A537',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100006029.SGN.000100006029','Maya Wicker Dining Chair- Kubu','Finished Product',NULL,'Pcs'),('C4F663AD-1878-264B-A983-1D97FC9CE75A',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:51','100020874','Rectan Alu Lantern/Pendant Lamp','Finished Product',NULL,'Pcs'),('C714D6A5-3A02-184C-A666-3F5197854B56',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024221.ACH.000','Optional Headrest Frame for Cambridge Seating Chair with Cushion Grade A-Charcoal','Finished Product',NULL,'Units'),('C71B2E08-9134-8E43-919A-A76C367C0894',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024199.000.HOL','Jeberg Round Dining Table, Slatted Teak Top Ø132cm w. umbrella hole','Finished Product',NULL,'Pcs'),('C78159F6-B9BE-E84E-808A-8EB4C5104A6E',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017049.000.000100017049','Cambridge Serving Tray Large','Finished Product',NULL,'Pcs'),('C80C6E17-9D10-744B-95F4-794BCAAB5189',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020683.ANT.000100020683','Cube Dining Table, Ceramic Top (230x95cm), Anthracite','Finished Product',NULL,'Pcs'),('C8400907-A9EE-E042-AD49-1E91139527F1',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023901.TAU.SAN','Cambridge Modular Arm Unit, Right, Frame Only','Finished Product',NULL,'Pcs'),('C8556D53-896B-FF4F-86BE-72F0F507AA15',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021700.000.DAN100021700','MOON solar pendant lamp, slewing, Dark Anthracite','Finished Product',NULL,'Pcs'),('C88C3140-C491-4E4D-9954-D646B82AF6F8',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024119.ABL.ANT','Vera Alu Modular Arm Unit, Left, Grade A -  Black - Rope Black','Finished Product',NULL,'Pcs'),('C8EA216B-6A3A-714D-8E41-0290801384E9',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021801.BLK.BLK100021801','Cube Alu Stacking Chair, teak arm, Charcoal','Finished Product',NULL,'Pcs'),('C91F2828-36E3-3043-9CA3-33B6F9664951',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020688.000.000100020688','Vera Square Coffee Table 72x72cm','Finished Product',NULL,'Pcs'),('C936CA15-8D51-B047-8364-DCC7D538E0B1',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100023783.000.GRE100023783','Mimpi Conversation Table Ø120cm, Olive Green','Finished Product',NULL,'Pcs'),('C9D36AF5-127A-A14D-9D0D-0E2352640F4C',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023967.000.ANT','Vera Alu Dining Table, Teak Top 240x100','Finished Product',NULL,'Pcs'),('CAE49E5F-2D9A-E046-9600-5548A3954A3A',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021703.000.DAN100021703','MOON stand MIDI for pendant lamp, Dark Anthracite','Finished Product',NULL,'Pcs'),('CBAD7007-62F0-E54F-A8EA-2CFC027EFBF6',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020775.ANT.ANT100020775','i-konic Rope Pendant/Lantern Lamp, Medium','Finished Product',NULL,'Pcs'),('CC39693E-933F-7A42-9FF3-CAD07DCD9EC1',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023897.000.000','Cambridge Modular Arm Unit, Left Frame Only','Finished Product',NULL,'Pcs'),('CC55714A-46D5-A94B-ADA3-B2BDE757701A',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:52','100022533.BLK.BLK','Ellen Alu Ottoman, Charcoal','Finished Product',NULL,'Pcs'),('CD5BDD0E-14FE-434E-B4B5-3D0A68FFBFEC',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100025117.000.ANT','Opti Dining Table, Teak Top 220x100 cm','Finished Product',NULL,'Pcs'),('CD5EBA28-6B79-5847-AA06-B53709ADEBFA',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024732.HOL.WHT','Elements Alu Dutch Extending Table 164/286x100cm - 64/113x39\", White, umbrella hole','Finished Product',NULL,'Pcs'),('CD97C9AF-B92A-7448-B969-BB5B1745A979',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018814.ACH.000100018814','Cube Modular Arm Unit Right, Grade A','Finished Product',NULL,'Pcs'),('D17500CB-D019-CB4C-A326-D96E81E7F0B3',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100015751.000.000100015751','Cube Backless Bench','Finished Product',NULL,'Pcs'),('D1878ABF-BDD6-8C48-B8AD-C1185B24D4C7',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 12:47:14','100021120.BLK.ANT100021120','Vera Director\'s Chair, Charcoal Coated A','Finished Product',NULL,'Pcs'),('D2D55DEB-DCCE-7643-AC83-0DA9B0BF4677',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021125.WHT.000100021125','Vera Sun Lounger, Chalk','Finished Product',NULL,'Sets'),('D2FEA973-C3A0-324A-8F51-0FBB348AC0DE',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024115.GRA.ANT','Elements Alu Stacking Sun Lounger, Anthracite','Finished Product',NULL,'Pcs'),('D3865B79-A984-734C-85CC-597B0EA57F0A',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100010306','Plateau S Module seat/back /  footstool 90cm Incl.4L, BR','Finished Product',NULL,'Pcs'),('D42514A1-797D-104E-AE64-FD18AFE87D5A',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023552.000.FSC','Note Bench with backrest, FSC 100%','Finished Product',NULL,'Pcs'),('D476A4BA-544B-EA45-AABC-FB0B2FFFFDEE',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:50:09','100002707','Heritage Dining Table 89x220cm (excl. brass feet)','Finished Product',NULL,'Pcs'),('D4C2235C-3F2D-984F-A43E-9EDD2838A813',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100020677.BLK.TPE','Casita Lounge Chair, Alu - Taupe','Finished Product',NULL,'Pcs'),('D56DA74D-3041-9643-B388-DFC4F58E52B6',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100010978.BLK.000100010978','Frank Sling Dining Arm Chair, Charcoal','Finished Product',NULL,'Pcs'),('D69015E5-A2F5-D946-B915-8EB2FAF11B5C',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 00:45:14','100001970','Quadro Stacking Sunlounger excl. Shade, Black','Finished Product',NULL,'Pcs'),('D6A71E86-F1FC-9147-A3B3-7C0584E56404',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019395.ACH.000100019395','Optional Headrest Cushion for Cambridge, Grade A','Finished Product',NULL,'Units'),('D7A4D727-8D1A-5B41-9F23-07A8BAE5E335',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100023360.WBG.BLK.FSC100023360.000.FSC100023360','Pelagus Sunbed, FSC 100%','Finished Product',NULL,'Pcs'),('D8B5593D-CDAA-0A42-AA5E-D4865127CB1E',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023786.000.ANT','Mimpi Tray Ø41cm, Small, Anthracite','Finished Product',NULL,'Pcs'),('D904708D-9AC4-E946-8937-66D0774AD7B5',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100021600.BLK.TPE','Casita 2 seater, left when seated - Taupe','Finished Product',NULL,'Pcs'),('D955BB57-F2D4-374B-B84D-9211D169C95E',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:50:09','100002458.000.000100002458','Maya Balcony Height Table 70x60x65 cm','Finished Product',NULL,'Pcs'),('DA215A00-B963-4947-9670-AD656B4CA42F',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021706.000.DAN100021706','MOON solar standing lamp MAXI, Dark Anthracite','Finished Product',NULL,'Pcs'),('DA8F7AFC-FF8C-DA4A-92BC-E3C1850153F0',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023856.BLK.BLK','Maya Bar Height Side Chair, Charcoal, Coated','Finished Product',NULL,'Pcs'),('DACB5239-05D2-A244-B123-DD51C9A3044A',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100016710','Harmony Dining Table 220x100cm, Frame Only, Gray','Finished Product',NULL,'Pcs'),('DB1FD9E0-1765-894D-B8B8-70EF8F1B6C6C',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100022460.000.BLK','Cube Planter Ø48cm, Charcoal','Finished Product',NULL,'Pcs'),('DB8D89C1-7BB7-0042-B5F2-EA785299C733',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023777.ABL.ANT','Cube Dog Bed, Small, Grade A-Black','Finished Product',NULL,'Pcs'),('DB98DB45-7742-6847-8F24-708AB77558E0',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100019763.000.000100019763','Cambridge Side Table, Low 50x35x29cm','Finished Product',NULL,'Pcs'),('DDEE2490-35F7-ED41-A0AF-D869D0776FD2',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:52','100022618.ACH.000','Cube Modular Small, Grade A','Finished Product',NULL,'Pcs'),('DE05E21F-7245-8940-BEAA-57F26A7919D0',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022241.BLK.ANT100022241','Opti Arm Chair, Coated','Finished Product',NULL,'Pcs'),('DE4B3B2D-CB5C-784A-8479-43EC6E4DF639',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100012784.000.000100012784','Stockholm Coffee Table 150x65cm','Finished Product',NULL,'Pcs'),('DEE51566-4872-9649-A3AC-47568B6D82C8',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100017497.000.000100017497','Chair Stand (suitable for all Icon Folding Chairs)','Finished Product',NULL,'Pcs'),('DFA4D7F6-3AEB-B44D-84ED-6BC91F6B367C',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020708.000.000100020708','Vera Coffee Table, High,  110x72cm','Finished Product',NULL,'Pcs'),('DFAD56C6-B175-6149-8365-F8810D4F624B',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:51','100019538','Lilium Lounge Table, teak/ ss','Finished Product',NULL,'Pcs'),('DFF42020-1E22-0E46-9EE6-61011203942A',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020771.ABL.000100020771','Optional Seat Cushion for Vera Chair, Grade A-Black','Finished Product',NULL,'Pcs'),('E085197A-D03A-7B47-ABED-A712B31B4A8E',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:50:09','100002704','Heritage Small Coffee Table 125x69cm (excl. brass feet)','Finished Product',NULL,'Pcs'),('E1AE3F03-832B-3E49-86CC-525A55F808B9',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023966.000.ANT','Vera Alu Dining Table, Teak Top 160x90cm','Finished Product',NULL,'Pcs'),('E201ED0B-BEE7-9149-B093-D79254321965',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020390.NAV.000100020390','Mimpi crochet scatter cushion (60x60 cm), Navy','Finished Product',NULL,'Pcs'),('E22476BB-B281-2640-B195-E27553B81CE3',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024115.PLT.SAN','Elements Alu Stacking Sun Lounger, Platinum, Coated S','Finished Product',NULL,'Pcs'),('E26ACBA6-198A-3C43-AB72-9AE672D56F11',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021204.000.ANT100021204','Tulip Lantern Lamp','Finished Product',NULL,'Pcs'),('E26D3996-8EBD-744F-9C5A-D95EBAE39D99',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019528.000.000100019528100019528.000.000','Cambridge Side Table 56x56x47cm','Finished Product',NULL,'Pcs'),('E294513C-DAA5-BE41-A0CA-0CD3231AF2B5',NULL,'2023-04-10 00:43:14',NULL,'2023-04-10 12:47:14','100001733.BLK.000100001733','Maya Sling Dining Chair, Charcoal','Finished Product',NULL,'Pcs'),('E34FE3FE-EBB4-504D-8CEF-2961B3141FEB',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021875.ACH.000100021875','Cube Modular Large with Corner Table, Grade A','Finished Product',NULL,'Pcs'),('E4269137-3C14-7D43-B72B-D4CD43E0F889',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100010281','Plateau L Module seat/back / footstool + side table 112cm+4Legs, BR','Finished Product',NULL,'Pcs'),('E4EEB8AC-4149-6049-B5F6-45E3BEF52D6B',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100024120.ABL.ANT','Vera Alu Modular Arm Unit, Right, Grade A - Black - Rope Black','Finished Product',NULL,'Pcs'),('E5A45CDC-7F81-A940-8D22-A17AF1DB3669',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023818.BRI.000','Vera Deepseating Sofa 3 Seater, Grade C- Brisa','Finished Product',NULL,'Pcs'),('E6343DDF-C990-0C4B-97FD-23EA8BE5CCB6',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023569.000.000','Maya Round Dining Table Ø120cm, NO Umbrella Hole','Finished Product',NULL,'Pcs'),('E68A4200-B7D2-C345-96B0-70DE907EE37A',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100019900.NAV.000100019900','Mimpi crochet scatter cushion (50x50 cm), Navy','Finished Product',NULL,'Pcs'),('E69C47C8-598B-A140-9323-629DB461545B',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100022463.000.ANT100022463','Aluminium Cover for Cube Planter','Finished Product',NULL,'Pcs'),('E88FDD1F-726B-5B46-9B36-01C34212C176',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100018158.NAT.ANT','Vera Dining Chair, Wicker Seat - Natural Loom','Finished Product',NULL,'Sets'),('E908FAF2-7BC5-FD40-B909-4E0993429E05',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018967.TAU.TAUPE100018967','Cambridge Seating 3 Seater, Frame Only','Finished Product',NULL,'Pcs'),('E968A08D-682D-D649-91CD-317FBE8E5062',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100018813.CGRA.000','Cube Modular Arm Unit Left, Grade C-Graphite','Finished Product',NULL,'Pcs'),('E995D8F6-45AF-6C46-9235-5714F285E98C',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023781.SIL.000','Mimpi Pouf Medium Ø65, Silver','Finished Product',NULL,'Pcs'),('E9A26B6B-0808-1044-AAD1-C49BD86FF6AA',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100009506','Riva Dining Arm Chair','Finished Product',NULL,'Pcs'),('EA9CFB18-6B53-4041-983D-7B6012AA40D9',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020332.000.000100020332','Cambridge Porch Rocker','Finished Product',NULL,'Pcs'),('EB63DA42-708C-7C43-8EBD-E208C304AE77',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020112.FOS.000100020112','Vera Modular Corner Unit, Grade C-Fossil','Finished Product',NULL,'Pcs'),('EBCACC3D-BEEE-414D-99BE-71B95B61D387',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022003.000.000','Cambridge Square Bar Height Table 80x80x105 cm','Finished Product',NULL,'Pcs'),('EBDF8925-CF72-6747-8DFF-09A68A574CE2',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023768.000.BLK','Cube Alu Coffee Table 120x80 cm, Charcoal','Finished Product',NULL,'Pcs'),('EC9FF64D-CA58-EB40-9FB1-6B3A860C0599',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019168.BLK.000100019168','Opti Deck Chair+footstool','Finished Product',NULL,'Pcs'),('ED203802-0CA5-2B44-83AB-35A266CD816E',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024094.AWI.000','Maya Modular Extension Unit, Grade A','Finished Product',NULL,'Pcs'),('ED3879D0-F926-0B42-B943-28770A077355',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100009747','Riva Sofa 2 Seater','Finished Product',NULL,'Pcs'),('ED76F6F2-0AB8-7342-B369-89616313CF56',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 00:43:50','100009508','Riva Dining Table 220x94cm','Finished Product',NULL,'Pcs'),('EDEB7C8F-7DF7-8940-B3DD-58CF631B02A0',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100022659.BLK.000100022659','Cambridge Sling Side Chair, Charcoal','Finished Product',NULL,'Pcs'),('EE40404D-61DD-544E-B0FD-51CFA10D095F',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100011331.HOL.WHT100011331.000.CLK','Cube Alu Dining Table, Teak Top 230 x 95 cm, white, umbrella hole','Finished Product',NULL,'Pcs'),('EE859099-D032-DE43-871D-627461D595E4',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100018957.FOS.TAU','Cambridge Seating Reclining Lounge Chair with Cushion Grade C-Fossil','Finished Product',NULL,'Pcs'),('EEC17F80-5BF1-C048-91B9-A6C1FE5D4BFA',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:50:09','100002708','Heritage Dining Chair (incl. brass feet & brass coil)','Finished Product',NULL,'Pcs'),('EEE76C9A-F315-6748-9A2C-38828ED7C291',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018957.TAU.TAUPE100018957','Cambridge Seating Reclining Lounge Chair, Frame Only','Finished Product',NULL,'Pcs'),('EF6F2860-5BB5-534B-A47E-D947C036CF3B',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 12:47:14','100025007.000.000100025007.000.ANT','Vera Pedestal Folding Table with Round HPL Top','Finished Product',NULL,'Pcs'),('EF9DFEA5-6FA4-C14D-B75B-507B57C60AA5',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100019529.000.000100019529','Cambridge Lamp Table 56x56x60cm','Finished Product',NULL,'Units'),('F0BF5E72-C06E-2D48-8CB0-DE963E12D4DF',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100010869.ANT.000100010869','Frank Rope Dining Arm Chair','Finished Product',NULL,'Pcs'),('F0D6C7C4-E552-BA44-9F7A-9A348AABC1EE',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100019795.REANT.ANT100019795','Glow Rope Pendant/Lantern Lamp, Medium','Finished Product',NULL,'Pcs'),('F0E99ED2-DD86-E74A-B385-0650A234374E',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 12:47:14','100022639.000.000100022639','Mirror, frame only, 180x50 cm','Finished Product',NULL,'Pcs'),('F139F722-E9C9-614A-8059-C1CB0F6B40F4',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100025148.000.000','Maya Dining Table 240x100x74cm, No umbrella hole','Finished Product',NULL,'Pcs'),('F1CF380C-9124-DE48-981A-A0F70D52FB4C',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100022004.000.000','Cambridge Round Counter Height Table Ø93x90cm','Finished Product',NULL,'Pcs'),('F24E4C72-A055-C24B-8EE3-4252916676C5',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:54','100023967.HOL.ANT','Vera Alu Dining Table, Teak Top 240x100, w. umbrella hole','Finished Product',NULL,'Pcs'),('F254A9F4-3C70-CF44-9D9E-A6AB0CE121C2',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100009258.BLK.000100009258','Cube Dining Chair, Charcoal','Finished Product',NULL,'Pcs'),('F3479855-A502-E445-9CAB-B649F0D3532E',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:52','100017243.000.000','Elements nested 3 side table with, slatted teak top','Finished Product',NULL,'Pcs'),('F3F605D1-605B-3B46-BE04-F83DBCD1FBA0',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100021880.000.000100021880','Cube Modular Half Width End Table (w.1 short leg)','Finished Product',NULL,'Pcs'),('F406A5A2-16D0-F94E-A768-A60B75A22C85',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:52','100021406','Jett Lounge Chair, Frame + Back Cushion Only','Finished Product',NULL,'Sets'),('F4AA8812-B918-F647-98A2-FA6575E51A00',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018272.000.ANT100018272','Cube Pendant/Lantern Lamp, Small 31cm','Finished Product',NULL,'Pcs'),('F64F348A-67E1-EC4B-B65B-EF1D4AE87E56',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100018815.CGRA.000','Cube Modular Corner Unit, Grade C-Graphite','Finished Product',NULL,'Pcs'),('F65A6346-4EC5-6642-8F21-8E0F5A7D8275',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020677.BLK.GRE100020677','Casita Lounge Chair, Alu - Grey','Finished Product',NULL,'Pcs'),('F732220E-2E30-9240-A4CF-BAC1D0332CCE',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100018350.65B.BLK100018350','Otti Sofa, Black','Finished Product',NULL,'Pcs'),('F7F07FA7-3D8F-8742-A1B6-416DA8DFBE97',NULL,'2023-04-10 00:43:17',NULL,'2023-04-10 00:43:53','100023850.BLK.000','Maya Counter Height Side Chair, Charcoal','Finished Product',NULL,'Pcs'),('FA8A5492-F846-6449-8110-ACEA47C555FD',NULL,'2023-04-10 00:43:15',NULL,'2023-04-10 12:47:14','100016618.000.000100016618','Icon Teak Folding Arm Chair','Finished Product',NULL,'Pcs'),('FA98B400-9366-E94A-9D56-34D62E83E8F3',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 00:43:51','100020878','Paton Alu Floor Standing Lamp','Finished Product',NULL,'Pcs'),('FAFE660F-72F7-BF47-929B-FE3F8B544EB1',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020656.000.ANT100020656','Cube Alu Conversation Table (Ø120cm)','Finished Product',NULL,'Pcs'),('FB0735C3-DDEF-444B-8F7A-F21703D117F7',NULL,'2023-04-10 00:43:16',NULL,'2023-04-10 12:47:14','100020773.000.ANT100020773','i-konic teak pendant/lantern lamp, large (50 cm)','Finished Product',NULL,'Pcs'),('FB25FF06-8850-AA42-8FAD-07A40C4EF9CF',NULL,'2023-04-10 00:43:18',NULL,'2023-04-10 00:43:53','100024101.AWI.000','Maya Modular Extension Unit with Arm Left, Grade A','Finished Product',NULL,'Pcs');
/*!40000 ALTER TABLE `itemcode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list`
--

DROP TABLE IF EXISTS `list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `list` (
  `RecId` varchar(100) NOT NULL,
  `Creation` varchar(100) DEFAULT NULL,
  `CreationDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `Modify` varchar(100) DEFAULT NULL,
  `ModDate` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Class` text DEFAULT NULL,
  `Type` text DEFAULT NULL,
  `Unit` text DEFAULT NULL,
  `salutation` text DEFAULT NULL,
  `contact_type` text DEFAULT NULL,
  PRIMARY KEY (`RecId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list`
--

LOCK TABLES `list` WRITE;
/*!40000 ALTER TABLE `list` DISABLE KEYS */;
INSERT INTO `list` VALUES ('1',NULL,'2023-03-20 07:45:06',NULL,'2023-03-29 01:30:47','Advertising\r\nAssembly\r\nAsset\r\nBag\r\nCasting \r\nComponent\r\nConsumable\r\nExport Cost\r\nFabric\r\nFinished Product\r\nFitting\r\nFreight Charges\r\nJigger\r\nOffice\r\nP3K\r\nPackaging Material\r\nPart \r\nPipe Iron\r\nRaw Material\r\nRetribution\r\nSafety\r\nSaw\r\nService\r\nSmall hand tool\r\nSpare Parts\r\nSupporting\r\nTools\r\nTransportation\r\nTravelling\r\nWood','Acrylic\r\nAISI 304\r\nAluminium\r\nArgon & LPG\r\nATK\r\nBag\r\nBrass\r\nBuilding\r\nCarton\r\nCasting\r\nCeramics\r\nChemicals\r\nConsultancy\r\nConsumable\r\nCooper\r\nCopolymer\r\nDacron\r\nFabric\r\nFoam\r\nFurn. Fitting\r\nGalvalum \r\nGlass\r\nGlassform Fibre\r\nGlue\r\nGranit\r\nHigh Pressure Laminate\r\nHPL\r\nHSS\r\nIron\r\nIT Goods\r\nLaser\r\nMachine\r\nMachine Maintenance\r\nMDF\r\nMetal\r\nMIX\r\nNylon (PA)\r\nOak\r\nOffice\r\nOther\r\nPacking\r\nPlant & Machinery\r\nPlywood\r\nPolishing\r\nPolyester \r\nPolyethylene (PE)\r\nPowder Coating\r\nPVC\r\nSafety\r\nSandpaper\r\nSaw\r\nScrew\r\nSmall Hand Tools\r\nSponge\r\nStainless Steel\r\nStainless Steel Coil\r\nSteel\r\nStone\r\nSynthetic\r\nTeak\r\nTimbal\r\nTools\r\nWicker\r\nWIP\r\nZiper\r\nSpare Part\r\nSwatch Material','Bands\r\nBelt\r\nBlades\r\nBottle\r\nBox\r\nBuku\r\nCans\r\nCapsul\r\nCarton\r\nCC\r\ncm²\r\nCoil\r\nCones\r\nCylinder\r\nDay\r\nDelivery\r\nDrum\r\nDZN\r\nFeet\r\nFls\r\ng\r\nGallon\r\nHour\r\nKg\r\nKm\r\nLBR\r\nLin yd\r\nLitre\r\nLM\r\nLoad\r\nLot\r\nLs\r\nLtr\r\nLusin\r\nM\r\nm\'\r\nM^2\r\nM^3\r\nm1\r\nm2\r\nm3\r\nml\r\nmm\r\nMonth\r\nO\'clock\r\nPack\r\nPail\r\nPair\r\nPallet\r\nPce\r\nPcs\r\nPick Up\r\nRim\r\nRolls\r\nSachet\r\nSet\r\nSheet\r\nSite\r\nSpool\r\nSq yd\r\nSTK\r\nStrip\r\nTablet\r\nTank\r\nTitik\r\ntooth\r\nTrip\r\nTruk\r\nTube\r\nUnit\r\nYard\r\nZak','Mr.\r\nMiss\r\nMrs.\r\nDr.\r\ndr.\r\nProf.\r\nH.','Direct\r\nEmail\r\nHome \r\nMain\r\nMobile\r\nWhatsApp\r\nWork\r\nWork fax');
/*!40000 ALTER TABLE `list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lotnumber`
--

DROP TABLE IF EXISTS `lotnumber`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lotnumber` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `lot_number` varchar(100) DEFAULT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `class` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `unit` varchar(100) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `receive_date` date DEFAULT NULL,
  `qty_available` decimal(10,2) DEFAULT 0.00,
  `qty_on_hand` decimal(10,2) DEFAULT 0.00,
  `qty_allocated` decimal(10,2) DEFAULT 0.00,
  `cost` decimal(10,2) DEFAULT 0.00,
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lotnumber`
--

LOCK TABLES `lotnumber` WRITE;
/*!40000 ALTER TABLE `lotnumber` DISABLE KEYS */;
INSERT INTO `lotnumber` VALUES ('014c9256-a53d-46d3-84c3-180b76411fb8','admin','2023-04-06 03:43:31',NULL,'2023-04-06 03:43:31','LO-23040003','DAB3','Description abs3','Assembly','AISI 304','Pcs','Warehouse','2023-04-05',3.00,3.00,0.00,9000.00),('02f7ae95-b15a-4656-a649-bfff4db726e3','admin','2023-04-06 03:21:18',NULL,'2023-04-06 03:21:18','LO-23040001','DAB4','Description abs4','Component','Bag','Pcs',NULL,'2023-04-05',2.00,2.00,0.00,20000.00),('66fa61bb-93c0-4429-9e87-9db5df442abc','admin','2023-04-06 03:43:31',NULL,'2023-04-06 03:43:31','LO-23040002','DAB4','Description abs4','Component','Bag','Pcs','Warehouse','2023-04-05',2.00,2.00,0.00,4000.00);
/*!40000 ALTER TABLE `lotnumber` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_table`
--

DROP TABLE IF EXISTS `master_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_table` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_table`
--

LOCK TABLES `master_table` WRITE;
/*!40000 ALTER TABLE `master_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `master_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `route_name` varchar(100) DEFAULT NULL,
  `seq` int(11) DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `active` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,'Contacts',9,NULL,NULL,NULL,NULL,'Master','contactPage',100,NULL,1),(2,'Sales',NULL,NULL,NULL,NULL,NULL,'Transaction',NULL,NULL,'bx bxs-grid',1),(3,'Purchasing',NULL,NULL,NULL,NULL,NULL,'Transaction',NULL,NULL,'mdi mdi-shopping-search',1),(6,'Warehouse',NULL,NULL,NULL,NULL,NULL,'Transaction',NULL,NULL,'mdi mdi-warehouse',1),(7,'Report',NULL,NULL,NULL,NULL,NULL,'Transaction',NULL,NULL,'ri-bar-chart-grouped-fill',1),(9,'Management',NULL,NULL,NULL,NULL,NULL,'Master',NULL,1,'mdi mdi-hammer-wrench',1),(10,'Setup',NULL,NULL,NULL,NULL,NULL,'Master',NULL,2,'bx bxs-cog',1),(11,'Item Code',9,NULL,NULL,NULL,NULL,'Master','ItemCodePage',1100,NULL,1),(12,'List',10,NULL,NULL,NULL,NULL,'Master','SetupListEdit',1200,NULL,1),(13,'Order',2,NULL,NULL,NULL,NULL,'Transaction','Order',1300,'',1),(14,'Lot Number',6,NULL,NULL,NULL,NULL,'Transaction','LotNumber',NULL,NULL,1),(15,'Purchase Order',3,NULL,NULL,NULL,NULL,'Transaction','PO',NULL,NULL,1),(16,'Receive',6,NULL,NULL,NULL,NULL,'Transaction','Receive',1600,NULL,1),(17,'Shipment',2,NULL,NULL,NULL,NULL,'Transaction','Shipment',1700,'',1),(18,'Invoice',2,NULL,NULL,NULL,NULL,'Transaction','Invoice',1800,'',1);
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_det`
--

DROP TABLE IF EXISTS `order_det`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_det` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `order_no` varchar(100) DEFAULT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `qty` decimal(10,0) DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `sub_total` decimal(18,2) DEFAULT NULL,
  `seq` varchar(65) DEFAULT NULL,
  `discount` decimal(18,2) DEFAULT 0.00,
  `remarks` varchar(300) DEFAULT NULL,
  `customer_sku` varchar(300) DEFAULT NULL,
  `unit` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_det`
--

LOCK TABLES `order_det` WRITE;
/*!40000 ALTER TABLE `order_det` DISABLE KEYS */;
INSERT INTO `order_det` VALUES ('07d4fd9f-769f-422c-a140-6755d67abb66','admin','2023-04-10 12:33:42',NULL,'2023-04-10 12:33:42','Q-23040026','TES1','Test',1,20000,NULL,20000.00,'10042023193229721',0.00,'',NULL,'Blades'),('090163c2-be31-4e76-9747-57f2848f9041','admin','2023-04-10 12:33:42',NULL,'2023-04-10 12:33:42','Q-23040026','TES1','Test',1,1000,NULL,1000.00,'10042023193201647',0.00,'',NULL,'Blades'),('0d48dc86-dbb2-41e7-94e4-679fea0fc3ef','admin','2023-04-10 13:34:01',NULL,'2023-04-10 13:34:01','Q-23040027','100022738.000.000','Cambridge Backless Bench 90cm',1,10000,NULL,10000.00,'10042023195219131',0.00,'','Test','Pcs'),('25ec65d7-1b6a-4cdb-a826-51fdf126f340','admin','2023-04-10 13:34:01',NULL,'2023-04-10 13:34:01','Q-23040027','100019131.CLK.000100019131','Cube Trolley, Beige Ceramic',2,3000,NULL,6000.00,'10042023195231759',0.00,'','Test 3','Pcs'),('621d0f15-d168-4611-a866-a9166b1e412d','admin','2023-04-08 13:50:56',NULL,'2023-04-08 14:10:08','Q-23040021','DAB2','DAB2',1,1000,NULL,1000.00,'08042023204127191',0.00,'','Test','Pcs'),('97c4c2f0-5d26-4584-89e1-5ac795f0bf9e','admin','2023-04-10 12:34:47',NULL,'2023-04-10 12:34:47','Q-23040025','TES1','TES1',1,10000,NULL,10000.00,'10042023193445547',0.00,'',NULL,'Blades'),('c171e919-af80-4510-9d8d-8dab89d30fc4','admin','2023-04-09 06:45:00',NULL,'2023-04-09 06:45:00','Q-23040023','DAB2','DAB2',1,1000,NULL,1000.00,'09042023133209705',0.00,'',NULL,'Pcs'),('e907b81d-184a-4dc1-9c2a-686bb9ffdb5a','admin','2023-04-09 06:24:24',NULL,'2023-04-09 06:24:24','Q-23040022','DAB4','DAB4',1,10000,NULL,10000.00,'09042023125529538',0.00,'',NULL,'Pcs'),('ed448b33-3ee8-430d-b878-594bb7fbabca','admin','2023-04-09 06:45:00',NULL,'2023-04-09 06:45:00','Q-23040023','DAB3','DAB3',2,2000,NULL,4000.00,'09042023133219872',0.00,'',NULL,'Pcs');
/*!40000 ALTER TABLE `order_det` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `order_no` varchar(100) DEFAULT NULL,
  `company_id` varchar(100) DEFAULT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `customer_po` varchar(100) DEFAULT NULL,
  `customer_po_date` date DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `revision_date` date DEFAULT NULL,
  `country` text DEFAULT NULL,
  `order_note` text DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `bank` varchar(100) DEFAULT NULL,
  `payment_term_note` text DEFAULT NULL,
  `incoterm` varchar(100) DEFAULT NULL,
  `rate_usd` decimal(14,2) DEFAULT NULL,
  `order_total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `order_dp` decimal(18,2) DEFAULT 0.00,
  `sales_rep` varchar(100) DEFAULT NULL,
  `order_paid_on` date DEFAULT NULL,
  `grand_total` decimal(18,2) DEFAULT 0.00,
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES ('35077ef0-2834-4fe7-82ff-23126ef34ab1','admin','2023-04-10 12:52:37',NULL,'2023-04-10 12:52:37','Q-23040027','OGI1','Outdoor Guild Inc','2023-04-10','','0000-00-00','','0000-00-00','USA','','','','','',0.00,16000.00,0.00,'','0000-00-00',16000.00);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u1482641_portal`@`%`*/ /*!50003 TRIGGER order_insert
BEFORE INSERT
ON `orders` FOR EACH ROW
set NEW.company_name= (select company_name from contact where company_id = NEW.company_id ) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`u1482641_portal`@`%`*/ /*!50003 TRIGGER order_update
BEFORE UPDATE
ON `orders` FOR EACH ROW SET NEW.company_name=(select company_name from contact where company_id=NEW.company_id ) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `po`
--

DROP TABLE IF EXISTS `po`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `po` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `po_no` varchar(100) DEFAULT NULL,
  `company_id` varchar(100) DEFAULT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `po_date` date DEFAULT NULL,
  `payment_term` varchar(100) DEFAULT NULL,
  `request_by` varchar(100) DEFAULT NULL,
  `goods_for` varchar(100) DEFAULT NULL,
  `ship_to` text DEFAULT NULL,
  `review_by` varchar(100) DEFAULT NULL,
  `approve_by` varchar(100) DEFAULT NULL,
  `initiator` varchar(100) DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `etd` date DEFAULT NULL,
  `eta` date DEFAULT NULL,
  `po_note` text DEFAULT NULL,
  `internal_note` text DEFAULT NULL,
  `payment_term_note` text DEFAULT NULL,
  `revision_date` date DEFAULT NULL,
  `total` decimal(18,2) DEFAULT 0.00,
  `discount` decimal(18,2) DEFAULT 0.00,
  `tax` decimal(18,2) DEFAULT 0.00,
  `tax_percentage` decimal(5,2) DEFAULT 0.00,
  `grand_total` decimal(18,2) DEFAULT 0.00,
  `total_rcv` decimal(18,2) DEFAULT 0.00,
  `discount_rcv` decimal(18,2) DEFAULT 0.00,
  `tax_rcv` decimal(18,2) DEFAULT 0.00,
  `grand_total_rcv` decimal(18,2) DEFAULT NULL,
  `po_source` varchar(100) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `ref_document` varchar(100) DEFAULT NULL,
  `discount_package` decimal(16,2) DEFAULT 0.00,
  `discount_package_rcv` decimal(16,2) DEFAULT 0.00,
  PRIMARY KEY (`recid`),
  UNIQUE KEY `po_un` (`po_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po`
--

LOCK TABLES `po` WRITE;
/*!40000 ALTER TABLE `po` DISABLE KEYS */;
INSERT INTO `po` VALUES ('27fdea82-7a22-495a-82db-29da1927f7ad',NULL,'2023-04-16 05:23:40',NULL,'2023-04-16 05:23:40','23040005','CNP1','Company Name, PT','Contact Person','Email@email.com','0000-00-00','','','','',NULL,NULL,NULL,'','Draft','0000-00-00','0000-00-00',NULL,NULL,NULL,NULL,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,NULL,'',NULL,NULL,0.00,0.00),('6eb3a2ca-eb44-4a6a-8604-88afcfbe2224',NULL,'2023-04-16 05:31:57',NULL,'2023-04-16 05:31:57','23040007','MBA1','Micahel Barou','Barou','spain@gg.com','0000-00-00','7 Days','IT','Test 2','Mantup',NULL,NULL,NULL,'IDR','Draft','2023-03-31','2023-03-29',NULL,NULL,NULL,NULL,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,NULL,'Local',NULL,NULL,0.00,0.00),('702f4d4d-0191-4adc-9420-ed6d23da6b58',NULL,'2023-04-06 03:41:32',NULL,'2023-04-06 03:42:33','23040002','MBA1','Micahel Barou','Barou','spain@gg.com','2023-04-05','7 Days','IT','Office','Mantup',NULL,NULL,NULL,'IDR','Draft','0000-00-00','0000-00-00',NULL,NULL,'Test 2',NULL,7800.00,200.00,0.00,0.00,7800.00,0.00,0.00,0.00,NULL,'Local',NULL,NULL,0.00,0.00),('7d08b952-3bef-4382-ac35-48da62efe4fe',NULL,'2023-04-16 04:27:05',NULL,'2023-04-16 04:27:05','23040004','MBA1','Micahel Barou','Barou','spain@gg.com','2023-04-01','7 Days','IT','Tes','Mantup',NULL,NULL,NULL,'IDR','Draft','2023-04-03','2023-04-02',NULL,NULL,NULL,NULL,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,NULL,'Local',NULL,NULL,0.00,0.00),('7fbcbbbb-53fe-4895-b27c-f57276e11129',NULL,'2023-04-03 08:36:41',NULL,'2023-04-06 01:21:12','23040001','QWP1','Quality Works, PT','Anders Norgaard','info@q-works.net','2023-04-03','30 Days','IT','Welding','',NULL,NULL,NULL,'','Draft','2023-04-06','2023-04-12',NULL,NULL,NULL,NULL,10000.00,0.00,0.00,0.00,10000.00,0.00,0.00,0.00,NULL,'Local',NULL,NULL,0.00,0.00),('9115f37a-bb5f-4666-b85b-307db420fe59',NULL,'2023-04-16 05:38:08',NULL,'2023-04-16 05:38:08','23040008','MBA1','Micahel Barou','Barou','spain@gg.com','0000-00-00','7 Days','3','4','Mantup',NULL,NULL,NULL,'USD','Draft','2023-04-01','2023-04-01',NULL,NULL,NULL,NULL,4860.00,0.00,0.00,1.00,4908.60,0.00,0.00,0.00,NULL,'Local',NULL,NULL,0.00,0.00),('93fceee3-89be-4e0d-8ba1-4d073b4051ae',NULL,'2023-03-24 06:10:40',NULL,'2023-04-03 08:35:23','23030001','QWP1','Quality Works, PT','Anders Norgaard','info@q-works.net','2023-03-24','Cash','IT','Office','Mantup',NULL,NULL,NULL,'IDR','Waiting Approval','0000-00-00','0000-00-00',NULL,NULL,'Test Note 2',NULL,300000.00,0.00,36000.00,12.00,336000.00,NULL,0.00,0.00,NULL,'Local',NULL,NULL,0.00,0.00),('b529cd22-876d-4fd1-bb9b-5f5545ec9ede',NULL,'2023-03-27 06:20:31',NULL,'2023-04-03 08:32:34','23030002','QWP1','Quality Works, PT','Anders Norgaard','info@q-works.net','2023-03-27','14 Days','test','tes','Mantup',NULL,NULL,NULL,'USD','Draft','2023-04-12','2023-04-12',NULL,NULL,NULL,NULL,11000.00,0.00,0.00,0.00,11000.00,NULL,0.00,0.00,NULL,'Import',NULL,NULL,0.00,0.00),('bb78c67b-ed4f-4862-af61-5242cd29a95d',NULL,'2023-04-16 04:19:13',NULL,'2023-04-16 04:25:22','23040003','QWP1','Quality Works, PT','Anders Norgaard','info@q-works.net','0000-00-00','7 Days','IT','Tes','Mantup',NULL,NULL,NULL,'IDR','Draft','2023-04-01','2023-04-01',NULL,NULL,NULL,NULL,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,NULL,'Local',NULL,NULL,0.00,0.00),('cc358b15-b653-471f-a16d-688490ab4568',NULL,'2023-03-30 04:54:36',NULL,'2023-04-03 07:53:36','23030003','MBA1','Micahel Barou','Barou','spain@gg.com','2023-03-29','14 Days','3','Production','Mantup',NULL,NULL,NULL,'IDR','Draft','2023-04-07','2023-04-05',NULL,NULL,'test Note 2',NULL,72000.00,28000.00,7810.00,11.00,78810.00,0.00,0.00,0.00,NULL,'Local',NULL,NULL,1000.00,0.00),('dbcb7c45-b304-40cb-afda-0693f3d6224f',NULL,'2023-04-16 05:30:05',NULL,'2023-04-16 05:30:05','23040006','CNP1','Company Name, PT','Contact Person','Email@email.com','0000-00-00','','','','',NULL,NULL,NULL,'','Draft','0000-00-00','0000-00-00',NULL,NULL,NULL,NULL,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,NULL,'',NULL,NULL,0.00,0.00),('e4c397a6-eb6e-4923-9649-d569686727b8',NULL,'2023-04-16 05:43:49',NULL,'2023-04-16 05:43:49','23040009','QWP1','Quality Works, PT','Anders Norgaard','info@q-works.net','0000-00-00','7 Days','IT','','',NULL,NULL,NULL,'','Draft','0000-00-00','2023-04-11',NULL,NULL,NULL,NULL,12900.00,0.00,257.98,2.00,13156.98,0.00,0.00,0.00,NULL,'Local',NULL,NULL,1.00,0.00);
/*!40000 ALTER TABLE `po` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_det`
--

DROP TABLE IF EXISTS `po_det`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `po_det` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `po_no` varchar(100) DEFAULT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `unit` varchar(100) DEFAULT NULL,
  `qty` decimal(10,0) DEFAULT 0,
  `price` decimal(10,2) DEFAULT 0.00,
  `discount` decimal(18,2) DEFAULT 0.00,
  `line_total` decimal(18,2) DEFAULT 0.00,
  `discount_percentage` decimal(5,2) DEFAULT 0.00,
  `lot_number` varchar(100) DEFAULT NULL,
  `seq` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`recid`),
  KEY `po_det_FK` (`po_no`),
  CONSTRAINT `po_det_FK` FOREIGN KEY (`po_no`) REFERENCES `po` (`po_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_det`
--

LOCK TABLES `po_det` WRITE;
/*!40000 ALTER TABLE `po_det` DISABLE KEYS */;
INSERT INTO `po_det` VALUES ('0ccd7efa-54d2-4f81-a865-f2b2fef0028e',NULL,'2023-04-03 01:28:10',NULL,'2023-04-03 06:25:32','23030003','DAB2','Description abs2','Pcs',3,30000.00,27000.00,63000.00,30.00,NULL,NULL),('179050dd-475a-458f-9922-7ae5ba55fb99',NULL,'2023-04-16 05:31:57',NULL,'2023-04-16 05:31:57','23040007','100023818.FOS.000100023818','Vera Deepseating Sofa 3 Seater, Grade C- Fossil','Pcs',20,2000.00,0.00,39600.00,1.00,NULL,'16042023123153002'),('1c9ed484-d7db-4eb2-a92d-9aafd315226c',NULL,'2023-04-03 01:23:52',NULL,'2023-04-03 04:32:50','23030003','DAB1','Description abs1','Pcs',1,10000.00,1000.00,9000.00,10.00,NULL,NULL),('3e2fa73d-3c23-499f-9270-c95553090841',NULL,'2023-04-16 05:38:08',NULL,'2023-04-16 05:38:08','23040008','100023909.AWI.000','Cambridge Modular Corner Unit, Grade A-Winter','Pcs',2,2000.00,0.00,3960.00,1.00,NULL,'16042023123725052'),('64dbcd64-c852-474d-816e-17d86107306c',NULL,'2023-04-03 08:31:56',NULL,'2023-04-03 08:31:56','23030002','DAB3','Description abs3','Pcs',1,1000.00,0.00,1000.00,0.00,NULL,NULL),('7fdb779d-6d79-4f54-83aa-2d3e3d5fce77',NULL,'2023-04-16 05:43:49',NULL,'2023-04-16 05:43:49','23040009','100015714.BLK.000100015714','Bromo Folding Arm Chair, Charcoal','Pcs',1,10000.00,0.00,9900.00,1.00,NULL,'16042023124326238'),('86cd2ccc-39d2-4563-a0c1-a27812dd3d12',NULL,'2023-04-06 03:42:06',NULL,'2023-04-06 03:43:31','23040002','DAB3','Description abs3','Pcs',2,3000.00,0.00,6000.00,0.00,'LO-23040003',NULL),('9434383d-cd09-4b23-9bdf-2d27cf6aa9ef',NULL,'2023-04-16 05:43:49',NULL,'2023-04-16 05:43:49','23040009','100017912','Harmony Chaise, White','Pcs',3,1000.00,0.00,3000.00,0.00,NULL,'16042023124333409'),('9f48ef7d-d34c-42eb-9139-ef93dd4b3746',NULL,'2023-04-06 03:41:57',NULL,'2023-04-06 03:43:31','23040002','DAB4','Description abs4','Pcs',1,2000.00,200.00,1800.00,10.00,'LO-23040002',NULL),('a9be3723-8cf4-4eca-b3b0-9a85cc6b5837',NULL,'2023-04-16 05:38:08',NULL,'2023-04-16 05:38:08','23040008','100017912','Harmony Chaise, White','Pcs',1,1000.00,0.00,900.00,10.00,NULL,'16042023123717407'),('ac12ad05-cb17-4fc5-b174-8d33340054b5',NULL,'2023-04-03 08:35:23',NULL,'2023-04-03 08:35:23','23030001','DAB1','Description abs1','Pcs',1,300000.00,0.00,300000.00,0.00,NULL,NULL),('acdb0b0a-7e66-41a7-89bd-4fe5a8e8f4d7',NULL,'2023-04-16 05:30:05',NULL,'2023-04-16 05:30:05','23040006','100015714.BLK.000100015714','Bromo Folding Arm Chair, Charcoal','Pcs',1,111111.00,0.00,111111.00,0.00,NULL,'16042023122252613'),('cd7322fb-434f-4f1f-9ac6-6b60ac5f5c16',NULL,'2023-04-03 08:32:12',NULL,'2023-04-03 08:32:12','23030002','DAB4','Description abs4','Pcs',1,10000.00,0.00,10000.00,0.00,NULL,NULL),('d6260dff-7628-4c01-8a0a-91f9aa50b392',NULL,'2023-04-03 08:37:18',NULL,'2023-04-06 03:15:20','23040001','DAB4','Description abs4','Pcs',1,10000.00,0.00,10000.00,0.00,'LO-23040001',NULL),('ebe5cf63-faea-4a25-a5a9-2d0c047767a7',NULL,'2023-04-16 05:31:57',NULL,'2023-04-16 05:31:57','23040007','100017912','Harmony Chaise, White','Pcs',1,100000.00,0.00,100000.00,0.00,NULL,'16042023123140921');
/*!40000 ALTER TABLE `po_det` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_payment`
--

DROP TABLE IF EXISTS `po_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `po_payment` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `po_no` varchar(100) DEFAULT NULL,
  `dated` date DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT 0.00,
  `method` varchar(100) DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `file_upload` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`recid`),
  KEY `po_payment_FK` (`po_no`),
  CONSTRAINT `po_payment_FK` FOREIGN KEY (`po_no`) REFERENCES `po` (`po_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_payment`
--

LOCK TABLES `po_payment` WRITE;
/*!40000 ALTER TABLE `po_payment` DISABLE KEYS */;
INSERT INTO `po_payment` VALUES ('1fe2c7bf-877c-4a54-968d-fdddd45aa579',NULL,'2023-04-06 03:45:14',NULL,'2023-04-06 03:45:14','23040002','2023-04-12',1.00,'DBS - IDR','IDR','test',NULL),('235752d8-1bc5-4005-916d-532f8697d097',NULL,'2023-04-03 04:44:07',NULL,'2023-04-03 04:44:07','23030003','2023-04-12',30000.00,'BCA - IDR','IDR','Test',NULL),('38d1f33d-79a6-4f4c-b257-8a78c078751f',NULL,'2023-03-30 07:37:32',NULL,'2023-03-30 07:37:32','23030001','2023-03-20',500000.00,'BCA - USD','USD','test',NULL),('aaa','admin','2023-03-30 02:30:51','Admin','2023-03-30 02:58:51','23030001','2024-09-01',30000.00,'DBS - USD','IDR','Test Remarks',NULL),('bab89295-2d2c-4ffc-a3e2-e6993a27ff05',NULL,'2023-04-03 04:54:40',NULL,'2023-04-03 04:54:40','23030003','2023-04-04',5000.00,'BCA - IDR','IDR','test 2',NULL),('bae4da59-1b99-46bc-8cbc-cca5e9fad864',NULL,'2023-03-30 08:56:03',NULL,'2023-03-30 08:56:03','23030001','2023-03-28',40000.00,'DBS - IDR','IDR','tes',NULL);
/*!40000 ALTER TABLE `po_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receive`
--

DROP TABLE IF EXISTS `receive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receive` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `po_no` varchar(100) DEFAULT NULL,
  `receive_no` varchar(100) DEFAULT NULL,
  `receive_date` date DEFAULT NULL,
  `delivery_note` varchar(100) DEFAULT NULL,
  `delivery_note_date` varchar(100) DEFAULT NULL,
  `invoice_no` varchar(100) DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `tax_invoice_no` varchar(100) DEFAULT NULL,
  `tax_invoice_date` date DEFAULT NULL,
  `company_name` varchar(300) DEFAULT NULL,
  `total` decimal(18,2) DEFAULT NULL,
  `tax` decimal(18,2) DEFAULT NULL,
  `grand_total` decimal(18,2) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tax_percentage` decimal(5,2) DEFAULT 0.00,
  `company_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receive`
--

LOCK TABLES `receive` WRITE;
/*!40000 ALTER TABLE `receive` DISABLE KEYS */;
INSERT INTO `receive` VALUES ('0225a33a-c041-4015-a3bf-f74eccb88a6d','admin','23040001','RC-23040001-02','2023-04-05','','','Rec 2','0000-00-00',NULL,NULL,'Quality Works, PT',NULL,NULL,NULL,'2023-04-06 03:25:12',NULL,'2023-04-06 03:25:12',0.00,'QWP1'),('41d88f43-faf6-4833-99b2-63edd1293e7c','admin','23040001','RC-23040001-03','2023-04-05','','','','0000-00-00',NULL,NULL,'Quality Works, PT',NULL,NULL,NULL,'2023-04-06 03:32:22',NULL,'2023-04-06 03:32:22',0.00,'QWP1'),('f0ee57d8-7be8-432b-930e-cd67e3505a39','admin','23040002','RC-23040002','2023-04-05','DLV3','','IV01','0000-00-00',NULL,NULL,'Micahel Barou',NULL,NULL,NULL,'2023-04-06 03:43:31',NULL,'2023-04-06 03:43:31',0.00,'MBA1'),('f1c351a1-fd70-4754-9356-28dc566aff0e','admin','23040001','RC-23040001','2023-04-05','','','','0000-00-00',NULL,NULL,'Quality Works, PT',NULL,NULL,NULL,'2023-04-06 03:21:18',NULL,'2023-04-06 03:21:18',0.00,'QWP1');
/*!40000 ALTER TABLE `receive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receive_det`
--

DROP TABLE IF EXISTS `receive_det`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receive_det` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `receive_no` varchar(100) DEFAULT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `description` varchar(300) DEFAULT NULL,
  `category` varchar(300) DEFAULT NULL,
  `lot_number` varchar(300) DEFAULT NULL,
  `qty` int(11) DEFAULT 0,
  `price` decimal(18,2) DEFAULT 0.00,
  `sub_total` decimal(18,2) DEFAULT 0.00,
  `expired_date` date DEFAULT NULL,
  `remarks` varchar(300) DEFAULT NULL,
  `total` decimal(18,2) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receive_det`
--

LOCK TABLES `receive_det` WRITE;
/*!40000 ALTER TABLE `receive_det` DISABLE KEYS */;
INSERT INTO `receive_det` VALUES ('52e7ff2d-dd60-4487-8e72-c2f08c487f44','admin','RC-23040002','DAB3','Description abs3','AISI 304','LO-23040003',3,3000.00,9000.00,'0000-00-00','Tes 2',NULL,'2023-04-06 03:43:31',NULL,'2023-04-06 03:43:31'),('5a4e4a3b-a3cb-4c9c-ac89-35ea4979e749','admin','RC-23040001-03','DAB4','Description abs4','Bag','LO-23040001',5,10000.00,50000.00,'0000-00-00','',NULL,'2023-04-06 03:32:22',NULL,'2023-04-06 03:32:22'),('73d3545c-b32a-423f-9dc1-d59bab11f5a8','admin','RC-23040002','DAB4','Description abs4','Bag','LO-23040002',2,2000.00,4000.00,'0000-00-00','Test 1',NULL,'2023-04-06 03:43:31',NULL,'2023-04-06 03:43:31'),('848853ea-7e43-4a8d-8444-4e2f2fcfa882','admin','RC-23040001-02','DAB4','Description abs4','Bag','',3,10000.00,30000.00,'0000-00-00','',NULL,'2023-04-06 03:25:12',NULL,'2023-04-06 03:25:12'),('89948abd-139a-4a6c-ab99-ea6931c0b81e','admin','RC-23040001','DAB4','Description abs4','Bag','LO-23040001',2,10000.00,20000.00,'0000-00-00','',NULL,'2023-04-06 03:21:18',NULL,'2023-04-06 03:21:18');
/*!40000 ALTER TABLE `receive_det` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `remark` varchar(100) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin',NULL,NULL,NULL,NULL),(2,'operator',NULL,NULL,NULL,NULL),(3,'ppic',NULL,NULL,NULL,NULL),(4,'sales',NULL,NULL,NULL,NULL),(5,'warehouse',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_permission`
--

DROP TABLE IF EXISTS `roles_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `roles_id` int(11) DEFAULT NULL,
  `menu_id` int(11) DEFAULT NULL,
  `can_create` int(11) DEFAULT 0,
  `can_index` int(11) DEFAULT 0,
  `can_edit` int(11) DEFAULT 0,
  `can_delete` int(11) DEFAULT 0,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_permission`
--

LOCK TABLES `roles_permission` WRITE;
/*!40000 ALTER TABLE `roles_permission` DISABLE KEYS */;
INSERT INTO `roles_permission` VALUES (1,1,1,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(2,2,1,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(3,1,2,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(4,2,2,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(5,1,3,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(6,2,3,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(7,1,6,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(8,2,6,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(9,1,7,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(10,2,7,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(11,1,9,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(12,2,9,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(13,1,10,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(14,2,10,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(15,1,11,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(16,2,11,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(17,1,12,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(18,2,12,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(19,1,13,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(20,2,13,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(21,1,14,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(22,2,14,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(23,1,15,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(24,2,15,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(25,1,16,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(26,2,16,1,0,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(32,3,3,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(33,3,15,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(34,3,9,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(35,3,11,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(36,3,1,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(37,4,9,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(38,4,1,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(39,1,17,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48'),(40,1,18,1,1,1,1,NULL,NULL,1,'2023-04-06 04:52:48');
/*!40000 ALTER TABLE `roles_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment`
--

DROP TABLE IF EXISTS `shipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment` (
  `recid` varchar(100) NOT NULL,
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `shipment_no` varchar(100) DEFAULT NULL,
  `company_id` varchar(100) DEFAULT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `shipment_date` date DEFAULT NULL,
  `production_target` date DEFAULT NULL,
  `stuffing_date` date DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `revision_date` date DEFAULT NULL,
  `ship_to` varchar(200) DEFAULT NULL,
  `arrive_remarks` text DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `incoterm` varchar(100) DEFAULT NULL,
  `rate_usd` decimal(14,2) DEFAULT NULL,
  `total` decimal(18,2) NOT NULL DEFAULT 0.00,
  `grand_total` decimal(18,2) DEFAULT 0.00,
  `country` varchar(200) DEFAULT NULL,
  `care_package` tinyint(4) DEFAULT 0,
  `tag_code` varchar(100) DEFAULT NULL,
  `shipment_category` varchar(100) DEFAULT NULL,
  `shipping_method` varchar(200) DEFAULT NULL,
  `forwarder` varchar(300) DEFAULT NULL,
  `vessel` varchar(100) DEFAULT NULL,
  `shipper` varchar(500) DEFAULT NULL,
  `etd` date DEFAULT NULL,
  `eta` date DEFAULT NULL,
  `emkl` varchar(500) DEFAULT NULL,
  `consignee` varchar(500) DEFAULT NULL,
  `notify_party` varchar(500) DEFAULT NULL,
  `port_loading` varchar(500) DEFAULT NULL,
  `port_discharge` varchar(500) DEFAULT NULL,
  `dimension` varchar(100) DEFAULT NULL,
  `departure_note` varchar(500) DEFAULT NULL,
  `sales_rep` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment`
--

LOCK TABLES `shipment` WRITE;
/*!40000 ALTER TABLE `shipment` DISABLE KEYS */;
INSERT INTO `shipment` VALUES ('3285682c-22f1-4fc2-b2fd-81f7ba80eb64','admin','2023-04-11 00:07:10',NULL,'2023-04-11 01:45:42','S-23040058','OGI1','Outdoor Guild Inc','2023-04-10','2023-04-11','2023-04-11','IDR','2023-04-01','Mantup','DO : 411IN2201928','Pending','Remarks Test','FOB Surabaya',1000.00,0.00,16000.00,'USA',1,NULL,'Production','40 Container','PT. DHL GLOBAL FORWARDING (INDONESIA)\nGraha Pena Building 20th floor, Room 2002\nJl. A. Yani No.88 Surabaya 60234','MSC RINI III V.HJ234R','PT Quality Works\nJl. Raya Mantup KM 12.5 Dusun Pucung\nDesa Puter, Kec. Kembangbahu\nLamongan 62282 East Java - Indonesia\nTax Number: 31.542.453.1-645.001','2023-03-01','2023-05-03','Adviant Berkat Mandiri (De Ros Indah Prima)\nJl. Purwodadi I no.55\nSurabaya 60171 ,','Skagerak Denmark A/S\nSlenvej 1, Port 1\n\nRanders No\n 8930 , Denmark','Skagerak Denmark A/S\nSlotspladsen 4\nAalborg,  9000  , Denmark','Tanjung Perak','Aarhus, Denmark','1 x 40 FT',NULL,''),('4a77b83b-faad-4290-a02e-a6e702ea04ec','admin','2023-04-11 02:41:53',NULL,'2023-04-11 03:21:36','S-23040059','OGI1','Outdoor Guild Inc','2023-04-10','2023-04-01','2023-04-12','USD','2023-04-10','Lamongan','Remark Arrival','Pending','Remarks Test','FOB Surabaya',15000.00,0.00,42000.00,'USA',1,NULL,'Prototype','Local Delivery','DHL','MSC RINI III V.HJ234R','Quality Works','2023-04-10','2023-04-11','EMKL Dummy 2','Consignee Dummy','Test NP','Tanjung Perak','Aarhus, Denmark','1 x 40 FT',NULL,'John Doe');
/*!40000 ALTER TABLE `shipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipment_det`
--

DROP TABLE IF EXISTS `shipment_det`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipment_det` (
  `recid` varchar(100) NOT NULL DEFAULT '-',
  `creation` varchar(100) DEFAULT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `modify` varchar(100) DEFAULT NULL,
  `mod_date` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `shipment_no` varchar(100) DEFAULT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `qty` decimal(10,0) DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `currency` varchar(100) DEFAULT NULL,
  `sub_total` decimal(18,2) DEFAULT NULL,
  `seq` varchar(65) DEFAULT NULL,
  `discount` decimal(18,2) DEFAULT 0.00,
  `customer_sku` varchar(300) DEFAULT NULL,
  `unit` varchar(100) DEFAULT NULL,
  `order_no` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`recid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipment_det`
--

LOCK TABLES `shipment_det` WRITE;
/*!40000 ALTER TABLE `shipment_det` DISABLE KEYS */;
INSERT INTO `shipment_det` VALUES ('0aa8dec4-0946-4f7c-97ce-ae8d71c5f15c','admin','2023-04-11 03:21:36',NULL,'2023-04-11 03:21:36','S-23040059','100022738.000.000','Cambridge Backless Bench 90cm',3,10000,NULL,30000.00,'11042023094037910',0.00,'Test','Pcs','Q-23040027'),('2dbb9f0f-a5b0-4e92-a386-7706f1f04d9a','admin','2023-04-11 03:21:36',NULL,'2023-04-11 03:21:36','S-23040059','100019131.CLK.000100019131','Cube Trolley, Beige Ceramic',4,3000,NULL,12000.00,'11042023094037912',0.00,'Test 3','Pcs','Q-23040027'),('abe2d944-5b77-4f08-a9c0-84608c928c451','admin','2023-04-11 00:07:10',NULL,'2023-04-11 01:51:29','S-23040058','100019131.CLK.000100019131','Cube Trolley, Beige Ceramic',2,3000,NULL,6000.00,'11042023070705540',0.00,'Test 3','Pcs','Q-23040027'),('bf174491-1e1e-4349-bb6e-0fc6444d91c40','admin','2023-04-11 00:07:10',NULL,'2023-04-11 01:51:29','S-23040058','100022738.000.000','Cambridge Backless Bench 90cm',1,10000,NULL,10000.00,'11042023070705537',0.00,'Test','Pcs','Q-23040027');
/*!40000 ALTER TABLE `shipment_det` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `active` int(11) NOT NULL DEFAULT 1,
  `lastlogin` timestamp NULL DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `roles` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin','c3284d0f94606de1fd2af172aba15bf3',1,'2020-12-31 17:00:00',NULL,NULL,0,'2023-03-16 03:31:09',1),(3,'operator','operator','c3284d0f94606de1fd2af172aba15bf3',1,'2020-12-31 17:00:00',NULL,NULL,0,'2023-03-16 03:31:09',2);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'u1482641_portal'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-16 12:44:36
