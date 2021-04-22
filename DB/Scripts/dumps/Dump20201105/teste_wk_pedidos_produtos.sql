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
-- Table structure for table `pedidos_produtos`
--

DROP TABLE IF EXISTS `pedidos_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedidos_produtos` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `numeropedido` int(10) unsigned NOT NULL,
  `codigoproduto` int(10) unsigned NOT NULL,
  `quantidade` double DEFAULT '0',
  `valorunitario` double DEFAULT '0',
  `valortotal` double DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_pedidosprodutosdados` (`numeropedido`),
  KEY `fk_pedidosprodutosprodutos` (`codigoproduto`),
  CONSTRAINT `fk_pedidosprodutosdados` FOREIGN KEY (`numeropedido`) REFERENCES `pedidos_dados_gerais` (`numero`),
  CONSTRAINT `fk_pedidosprodutosprodutos` FOREIGN KEY (`codigoproduto`) REFERENCES `produtos` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_produtos`
--

LOCK TABLES `pedidos_produtos` WRITE;
/*!40000 ALTER TABLE `pedidos_produtos` DISABLE KEYS */;
INSERT INTO `pedidos_produtos` VALUES (6,21,4,1,2,2),(7,22,11,1,69.9,69.9),(8,22,15,1,120,120),(10,23,13,89,1,89),(12,24,3,1,1.3,1.3),(13,25,5,2,20,40),(14,26,3,1,1.3,1.3),(15,27,4,1,2,2),(16,28,5,1,2,2),(17,29,5,1,2,2),(18,30,4,1,2,2),(19,31,5,1,2,2),(20,32,12,1,59.9,59.9),(21,33,5,1,2,2),(22,34,5,1,2,2),(23,35,21,1,13,13),(24,36,10,1,25.5,25.5),(25,37,10,1,25.5,25.5),(26,38,9,1,23.5,23.5),(27,39,15,1,120,120),(28,40,11,1,69.9,69.9),(36,41,3,1,1.3,1.3),(42,42,3,1,1.3,1.3),(43,42,4,1,2,2),(44,42,5,1,2,2),(46,43,2,1,0.75,0.75),(47,44,4,1,2,2);
/*!40000 ALTER TABLE `pedidos_produtos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-05 23:58:44
