-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: peluqueriadb.cbdiwhfh6ev3.us-east-1.rds.amazonaws.com    Database: PeluqueriaDB
-- ------------------------------------------------------
-- Server version	8.0.43

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `CLIENTE`
--

DROP TABLE IF EXISTS `CLIENTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CLIENTE` (
  `idCLIENTE` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `apellidos` varchar(45) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`idCLIENTE`),
  UNIQUE KEY `uk_cliente_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=801 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `EMPLEADO`
--

DROP TABLE IF EXISTS `EMPLEADO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EMPLEADO` (
  `idEMPLEADO` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `apellido` varchar(45) DEFAULT NULL,
  `email` varchar(80) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `salario` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idEMPLEADO`),
  UNIQUE KEY `uk_empleado_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `LINEA_PRODUCTO`
--

DROP TABLE IF EXISTS `LINEA_PRODUCTO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LINEA_PRODUCTO` (
  `idLineaProducto` int NOT NULL AUTO_INCREMENT,
  `cantidad` int NOT NULL DEFAULT '1',
  `precioUnitarioAplicado` decimal(10,2) DEFAULT NULL,
  `PEDIDO_idPEDIDO` int NOT NULL,
  `PRODUCTO_idPRODUCTO` int NOT NULL,
  PRIMARY KEY (`idLineaProducto`),
  KEY `idx_lp_pedido` (`PEDIDO_idPEDIDO`),
  KEY `idx_lp_producto` (`PRODUCTO_idPRODUCTO`),
  CONSTRAINT `fk_lp_pedido` FOREIGN KEY (`PEDIDO_idPEDIDO`) REFERENCES `PEDIDO` (`idPEDIDO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_lp_producto` FOREIGN KEY (`PRODUCTO_idPRODUCTO`) REFERENCES `PRODUCTO` (`idPRODUCTO`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `LINEA_SERVICIO`
--

DROP TABLE IF EXISTS `LINEA_SERVICIO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LINEA_SERVICIO` (
  `idLineaServicio` int NOT NULL AUTO_INCREMENT,
  `horaInicio` datetime DEFAULT NULL,
  `precioUnitarioAplicado` decimal(10,2) DEFAULT NULL,
  `PEDIDO_idPEDIDO` int NOT NULL,
  `SERVICIO_idSERVICIO` int NOT NULL,
  `EMPLEADO_idEMPLEADO` int NOT NULL,
  PRIMARY KEY (`idLineaServicio`),
  KEY `idx_ls_pedido` (`PEDIDO_idPEDIDO`),
  KEY `idx_ls_servicio` (`SERVICIO_idSERVICIO`),
  KEY `idx_ls_empleado` (`EMPLEADO_idEMPLEADO`),
  CONSTRAINT `fk_ls_empleado` FOREIGN KEY (`EMPLEADO_idEMPLEADO`) REFERENCES `EMPLEADO` (`idEMPLEADO`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ls_pedido` FOREIGN KEY (`PEDIDO_idPEDIDO`) REFERENCES `PEDIDO` (`idPEDIDO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ls_servicio` FOREIGN KEY (`SERVICIO_idSERVICIO`) REFERENCES `SERVICIO` (`idSERVICIO`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=507 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PEDIDO`
--

DROP TABLE IF EXISTS `PEDIDO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PEDIDO` (
  `idPEDIDO` int NOT NULL AUTO_INCREMENT,
  `idCLIENTE` int DEFAULT NULL,
  `fecha` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idPEDIDO`),
  KEY `idx_pedido_cliente` (`idCLIENTE`),
  CONSTRAINT `fk_pedido_cliente` FOREIGN KEY (`idCLIENTE`) REFERENCES `CLIENTE` (`idCLIENTE`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `PRODUCTO`
--

DROP TABLE IF EXISTS `PRODUCTO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PRODUCTO` (
  `idPRODUCTO` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `stock` int DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idPRODUCTO`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `SERVICIO`
--

DROP TABLE IF EXISTS `SERVICIO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SERVICIO` (
  `idSERVICIO` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `duracionMin` int DEFAULT NULL,
  PRIMARY KEY (`idSERVICIO`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TICKET`
--

DROP TABLE IF EXISTS `TICKET`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TICKET` (
  `PEDIDO_idPEDIDO` int NOT NULL,
  `metodoPago` varchar(45) DEFAULT NULL,
  `precioTotal` decimal(10,2) DEFAULT NULL,
  `fechaPago` datetime DEFAULT NULL,
  PRIMARY KEY (`PEDIDO_idPEDIDO`),
  CONSTRAINT `fk_ticket_pedido` FOREIGN KEY (`PEDIDO_idPEDIDO`) REFERENCES `PEDIDO` (`idPEDIDO`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `v_facturacion_empleado_mes`
--

DROP TABLE IF EXISTS `v_facturacion_empleado_mes`;
/*!50001 DROP VIEW IF EXISTS `v_facturacion_empleado_mes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_facturacion_empleado_mes` AS SELECT 
 1 AS `idEMPLEADO`,
 1 AS `empleado`,
 1 AS `mes`,
 1 AS `num_servicios_realizados`,
 1 AS `total_servicios_eur`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_ticket_detalle`
--

DROP TABLE IF EXISTS `v_ticket_detalle`;
/*!50001 DROP VIEW IF EXISTS `v_ticket_detalle`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_ticket_detalle` AS SELECT 
 1 AS `idPedido`,
 1 AS `fecha_reserva`,
 1 AS `fechaPago`,
 1 AS `metodoPago`,
 1 AS `precioTotal`,
 1 AS `idCLIENTE`,
 1 AS `cliente`,
 1 AS `telefono`,
 1 AS `email`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'PeluqueriaDB'
--

--
-- Final view structure for view `v_facturacion_empleado_mes`
--

/*!50001 DROP VIEW IF EXISTS `v_facturacion_empleado_mes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_facturacion_empleado_mes` AS select `e`.`idEMPLEADO` AS `idEMPLEADO`,concat(`e`.`nombre`,' ',`e`.`apellido`) AS `empleado`,date_format(`ls`.`horaInicio`,'%Y-%m') AS `mes`,count(0) AS `num_servicios_realizados`,sum(`ls`.`precioUnitarioAplicado`) AS `total_servicios_eur` from (`LINEA_SERVICIO` `ls` join `EMPLEADO` `e` on((`e`.`idEMPLEADO` = `ls`.`EMPLEADO_idEMPLEADO`))) group by `e`.`idEMPLEADO`,`empleado`,`mes` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_ticket_detalle`
--

/*!50001 DROP VIEW IF EXISTS `v_ticket_detalle`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_ticket_detalle` AS select `t`.`PEDIDO_idPEDIDO` AS `idPedido`,`p`.`fecha` AS `fecha_reserva`,`t`.`fechaPago` AS `fechaPago`,`t`.`metodoPago` AS `metodoPago`,`t`.`precioTotal` AS `precioTotal`,`c`.`idCLIENTE` AS `idCLIENTE`,concat(`c`.`nombre`,' ',`c`.`apellidos`) AS `cliente`,`c`.`telefono` AS `telefono`,`c`.`email` AS `email` from ((`TICKET` `t` join `PEDIDO` `p` on((`p`.`idPEDIDO` = `t`.`PEDIDO_idPEDIDO`))) join `CLIENTE` `c` on((`c`.`idCLIENTE` = `p`.`idCLIENTE`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-15 21:55:45
