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
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clientes` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nome` varchar(80) NOT NULL,
  `cidade` varchar(40) DEFAULT NULL,
  `uf` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Jose','Guarulhos','SP'),(2,'Maria','Guarulhos','SP'),(3,'João','São Paulo','SP'),(4,'Mario','São Paulo','SP'),(5,'Elias','São Paulo','SP'),(6,'Antonia','Santos','SP'),(7,'Priscila','São Paulo','SP'),(8,'Beatriz','São Paulo','SP'),(9,'Heloisa','Belo Horizonte','MG'),(10,'Ana Carolina','Maringa','PR'),(11,'Carolina','São Paulo','SP'),(12,'Ludimille','São Paulo','SP'),(13,'Carlos','São Paulo','SP'),(14,'Denilson','São Paulo','SP'),(15,'Fernando','São Paulo','SP'),(16,'Moisés','São Paulo','SP'),(17,'Antônio','São Paulo','SP'),(18,'Diego','São Paulo','SP'),(19,'Bruno','São Paulo','SP'),(20,'Fabio','São Paulo','SP');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produtos` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descricao` varchar(80) DEFAULT NULL,
  `precovenda` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Borracha branca pequena',0.5),(2,'Borracha branca média',0.75),(3,'Borracha branca grande',1.3),(4,'Caneta Azul',2),(5,'Caneta Preta',2),(6,'Caneta Vermelha',2),(7,'Régua Acrílico 20cm',5),(8,'Régua Acrílico 30cm',7.5),(9,'Papel A4 Branco 500 fls',23.5),(10,'Papel A4 Branco 500 fls Marca',25.5),(11,'Toner HP Univ Compatível 85A',69.9),(12,'Toner Brother Compatível 450',59.9),(13,'Toner Samsung Compatível D101',89),(14,'Toner Brother Compatível 3472',99.5),(15,'Photocondutor Brother Compatível DR3472',120),(16,'Photocondutor Brother Compatível DR450',90),(17,'Cola branca 100ml',10),(18,'Cola branca 1000ml',23),(19,'Caixa grampo',5.9),(20,'Caixa Clips 5000 uni',15),(21,'Caderno 200 fls 1 mat',13);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_pedido`
--

DROP TABLE IF EXISTS `vw_pedido`;
/*!50001 DROP VIEW IF EXISTS `vw_pedido`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vw_pedido` AS SELECT 
 1 AS `NUMERO`,
 1 AS `EMISSAO`,
 1 AS `CLIENTE`,
 1 AS `NOMECLIENTE`,
 1 AS `CIDADE`,
 1 AS `UF`,
 1 AS `VALORTOTAL`,
 1 AS `PRODID`,
 1 AS `PRODCODIGO`,
 1 AS `PRODDESCRICAO`,
 1 AS `PRODUNITARIO`,
 1 AS `PRODQUANTIDADE`,
 1 AS `PRODTOTAL`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vw_pedido`
--

/*!50001 DROP VIEW IF EXISTS `vw_pedido`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_pedido` AS select `a`.`numero` AS `NUMERO`,`a`.`emissao` AS `EMISSAO`,`a`.`codigo_cli` AS `CLIENTE`,`d`.`nome` AS `NOMECLIENTE`,`d`.`cidade` AS `CIDADE`,`d`.`uf` AS `UF`,`a`.`valortotal` AS `VALORTOTAL`,`b`.`id` AS `PRODID`,`b`.`codigoproduto` AS `PRODCODIGO`,`c`.`descricao` AS `PRODDESCRICAO`,`b`.`quantidade` AS `PRODUNITARIO`,`b`.`valorunitario` AS `PRODQUANTIDADE`,`b`.`valortotal` AS `PRODTOTAL` from (((`pedidos_dados_gerais` `a` join `pedidos_produtos` `b` on((`b`.`numeropedido` = `a`.`numero`))) join `produtos` `c` on((`c`.`codigo` = `b`.`codigoproduto`))) join `clientes` `d` on((`d`.`codigo` = `a`.`codigo_cli`))) order by `a`.`numero`,`b`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-06  0:01:02
