CREATE DATABASE  IF NOT EXISTS `teste_wk` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `teste_wk`;
-- MySQL dump 10.13  Distrib 5.7.12, for Win32 (AMD64)
--
-- Host: localhost    Database: teste_wk
-- ------------------------------------------------------
-- Server version	5.7.17-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pedidos_dados_gerais`
--

DROP TABLE IF EXISTS `pedidos_dados_gerais`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedidos_dados_gerais` (
  `numero` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `codigo_cli` int(10) unsigned NOT NULL,
  `emissao` date DEFAULT NULL,
  `valortotal` double DEFAULT '0',
  PRIMARY KEY (`numero`),
  KEY `fk_pedidos_clientes` (`codigo_cli`),
  KEY `idx_pv` (`numero`,`codigo_cli`),
  CONSTRAINT `fk_pedidos_clientes` FOREIGN KEY (`codigo_cli`) REFERENCES `clientes` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_dados_gerais`
--

LOCK TABLES `pedidos_dados_gerais` WRITE;
/*!40000 ALTER TABLE `pedidos_dados_gerais` DISABLE KEYS */;
INSERT INTO `pedidos_dados_gerais` VALUES (1,5,'2020-02-11',1.3),(11,3,'2020-11-05',0),(12,3,'2020-11-05',0),(13,3,'2020-11-05',0),(14,2,'2020-11-05',0.75),(15,2,'2020-11-05',1.3),(16,3,'2020-11-05',23.5),(17,3,'2020-11-05',2),(18,3,'2020-11-05',0.75),(19,2,'2020-11-05',2),(21,2,'2020-11-05',2),(22,3,'2020-11-05',189.9),(23,5,'2020-11-05',91),(24,3,'2020-11-05',1.3),(25,2,'2020-11-05',40),(26,5,'2020-11-05',1.3),(27,5,'2020-11-05',2),(28,3,'2020-11-05',2),(29,4,'2020-11-05',2),(30,3,'2020-11-05',2),(31,2,'2020-11-05',2),(32,9,'2020-11-05',59.9),(33,4,'2020-11-05',2),(34,4,'2020-11-05',2),(35,5,'2020-11-05',13),(36,16,'2020-11-05',25.5),(37,5,'2020-11-05',25.5),(38,9,'2020-11-05',23.5),(39,12,'2020-11-05',120),(40,4,'2020-11-05',69.9),(41,4,'2020-11-05',1.3),(42,4,'2020-11-05',5.3),(43,4,'2020-11-05',0.75),(44,5,'2020-11-05',2);
/*!40000 ALTER TABLE `pedidos_dados_gerais` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-05 23:58:45
