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

--
-- Dumping routines for database 'teste_wk'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-11-05 23:58:45
