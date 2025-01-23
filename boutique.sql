-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: boutique
-- ------------------------------------------------------
-- Server version	8.4.3

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

--
-- Table structure for table `ligne_livraison`
--

DROP TABLE IF EXISTS `ligne_livraison`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ligne_livraison` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `montant_total` decimal(38,2) NOT NULL,
  `prix_unitaire` decimal(38,2) NOT NULL,
  `quantite` int NOT NULL,
  `livraison_id` bigint NOT NULL,
  `produit_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKqo5f3ho1csypyj30mqaa4xm11` (`livraison_id`),
  KEY `FK4brabfbsb8kppm507gr5engxs` (`produit_id`),
  CONSTRAINT `FK4brabfbsb8kppm507gr5engxs` FOREIGN KEY (`produit_id`) REFERENCES `Produit` (`id`),
  CONSTRAINT `FKqo5f3ho1csypyj30mqaa4xm11` FOREIGN KEY (`livraison_id`) REFERENCES `livraisons` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ligne_livraison`
--

LOCK TABLES `ligne_livraison` WRITE;
/*!40000 ALTER TABLE `ligne_livraison` DISABLE KEYS */;
INSERT INTO `ligne_livraison` VALUES (1,10000.00,1000.00,10,2,64),(2,5000.00,1000.00,5,3,64),(3,210000.00,35000.00,6,3,25);
/*!40000 ALTER TABLE `ligne_livraison` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lignes_vente`
--

DROP TABLE IF EXISTS `lignes_vente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lignes_vente` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `montant_total` decimal(38,2) NOT NULL,
  `prix_unitaire` decimal(38,2) NOT NULL,
  `quantite` int NOT NULL,
  `produit_id` bigint NOT NULL,
  `vente_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKogcwh5heodtxq8rok172l4nty` (`produit_id`),
  KEY `FK5u3waoonthmakyx51opesgjr6` (`vente_id`),
  CONSTRAINT `FK5u3waoonthmakyx51opesgjr6` FOREIGN KEY (`vente_id`) REFERENCES `ventes` (`id`),
  CONSTRAINT `FKogcwh5heodtxq8rok172l4nty` FOREIGN KEY (`produit_id`) REFERENCES `Produit` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lignes_vente`
--

LOCK TABLES `lignes_vente` WRITE;
/*!40000 ALTER TABLE `lignes_vente` DISABLE KEYS */;
INSERT INTO `lignes_vente` VALUES (1,200.00,100.00,2,1,1),(2,200.00,100.00,2,1,2),(3,1400000.00,35000.00,40,25,3),(4,50000.00,10000.00,5,27,3),(5,625000.00,25000.00,25,14,3),(6,160000.00,80000.00,2,18,4),(7,750000.00,250000.00,3,8,5),(8,175000.00,35000.00,5,25,5),(9,20000.00,1000.00,20,64,6),(10,20000.00,2000.00,10,57,6),(11,800000.00,80000.00,10,18,7),(12,450000.00,15000.00,30,39,7);
/*!40000 ALTER TABLE `lignes_vente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `livraisons`
--

DROP TABLE IF EXISTS `livraisons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `livraisons` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date_livraison` datetime(6) NOT NULL,
  `montant_total` decimal(38,2) NOT NULL,
  `nom_fournisseur` varchar(255) NOT NULL,
  `utilisateur_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKpfby74f5et3f4d93r27xv4bfd` (`utilisateur_id`),
  CONSTRAINT `FKpfby74f5et3f4d93r27xv4bfd` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateurs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `livraisons`
--

LOCK TABLES `livraisons` WRITE;
/*!40000 ALTER TABLE `livraisons` DISABLE KEYS */;
INSERT INTO `livraisons` VALUES (2,'2025-01-21 21:51:26.708375',10000.00,'All-Tech',2),(3,'2025-01-23 16:37:19.387921',215000.00,'KONE IT',2);
/*!40000 ALTER TABLE `livraisons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Produit`
--

DROP TABLE IF EXISTS `Produit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Produit` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `prix_unitaire` decimal(38,2) NOT NULL,
  `quantiteStock` int NOT NULL,
  `seuil_alerte` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Produit`
--

LOCK TABLES `Produit` WRITE;
/*!40000 ALTER TABLE `Produit` DISABLE KEYS */;
INSERT INTO `Produit` VALUES (1,'Rem et quis veniam ','Ipsum inventore qui',100.00,90,10),(2,'Vero hic officia eos','Omnis Nam veniam ci',100.00,38,11),(3,'Ordinateur Portable ecran 17, 2T Disque, 32 G Ram','HP',450000.00,25,5),(4,'Laptop Dell avec processeur i5, 8GB RAM, 256GB SSD','Laptop Dell Inspiron',450000.00,15,5),(5,'Écran LED 24 pouces Full HD, modèle 2023','Écran Samsung 24\"',120000.00,25,10),(6,'Clavier gaming mécanique RGB avec switchs tactiles','Clavier mécanique Logitech',60000.00,30,5),(7,'Souris ergonomique avec capteur 20,000 DPI','Souris gamer Razer DeathAdder',40000.00,50,10),(8,'Casque antibruit Bluetooth avec autonomie 30 heures','Casque Sony WH-1000XM5',250000.00,7,7),(9,'iPad Air 10.9 pouces avec 64GB de stockage','Tablette Apple iPad Air',400000.00,12,5),(10,'Disque dur portable avec connexion USB 3.0','Disque dur externe WD 1TB',50000.00,40,10),(11,'Imprimante laser multifonction pour bureau','Imprimante HP LaserJet Pro',130000.00,8,2),(12,'Clé USB rapide avec cryptage AES intégré','Clé USB SanDisk 128GB',15000.00,100,20),(13,'Téléphone haut de gamme avec triple caméra','Smartphone Samsung Galaxy S23',650000.00,20,5),(14,'Chargeur rapide pour smartphones compatibles Qi','Chargeur sans fil Belkin',25000.00,35,10),(15,'Tapis de souris antidérapant pour gaming','Tapis de souris XXL',10000.00,80,15),(16,'Téléviseur OLED 4K avec Dolby Vision','TV LG OLED 55\"',850000.00,5,2),(17,'Ventilateur sans pale avec technologie Air Multiplier','Ventilateur Dyson Cool',200000.00,10,3),(18,'Caméra HD avec détection de mouvement','Caméra de surveillance Arlo',80000.00,8,8),(19,'Montre connectée avec suivi d’activités et GPS','Smartwatch Garmin Vivoactive',160000.00,15,4),(20,'GPU haut de gamme pour gaming et création','Carte graphique NVIDIA RTX 4070',400000.00,8,3),(21,'Hub USB-C avec ports HDMI, USB 3.0 et Ethernet','Station d’accueil USB-C',60000.00,25,5),(22,'Projecteur Full HD pour home cinéma','Projecteur BenQ',330000.00,6,2),(23,'Routeur Wi-Fi 6 avec portée étendue','Routeur Wi-Fi Netgear',120000.00,18,5),(24,'Laptop professionnel avec processeur i7 et 16GB RAM','Ordinateur Lenovo ThinkPad',700000.00,10,4),(25,'Powerbank compacte avec charge rapide','Batterie externe Anker 20,000mAh',35000.00,11,10),(26,'Enceinte portable étanche avec basses puissantes','Enceinte Bluetooth JBL Flip 6',85000.00,30,5),(27,'Câble HDMI 2.1 compatible 4K/120Hz','Câble HDMI 4K',10000.00,55,10),(28,'Sac à dos avec compartiment pour ordinateur 15 pouces','Sac à dos pour laptop',40000.00,20,5),(29,'Scanner léger et performant pour usage mobile','Scanner portable Epson',75000.00,10,3),(30,'Téléphone abordable avec écran de 5.5 pouces','Téléphone Itel A56',45000.00,50,10),(31,'Chaise avec soutien lombaire ajustable','Chaises de bureau ergonomiques',75000.00,15,4),(32,'Table moderne avec finition en bois','Table de bureau en bois',120000.00,10,2),(33,'Microphone USB de qualité studio pour enregistrement','Microphone Blue Yeti',100000.00,8,3),(34,'Réfrigérateur portable pour bureau ou maison','Mini réfrigérateur',85000.00,12,4),(35,'Lampe éco-énergétique avec intensité réglable','Lampe de bureau LED',25000.00,20,5),(36,'Chaise gaming haut de gamme avec support lombaire','Chaise gamer DXRacer',180000.00,8,3),(37,'Support réglable pour écran de PC','Support pour moniteur',30000.00,25,5),(38,'Abonnement annuel pour une protection optimale','Logiciel antivirus Kaspersky',35000.00,40,10),(39,'Guide complet pour apprendre le langage Java','Livre \"Apprendre Java\"',15000.00,20,10),(40,'Stylo haut de gamme avec finition en métal','Stylo-plume Parker',25000.00,30,5),(41,'Casque audio haute fidélité pour mélomanes','Casque filaire Bose',150000.00,15,4),(42,'Imprimante jet d’encre avec connectivité Wi-Fi','Imprimante Canon Pixma',110000.00,10,3),(43,'Table large pour salle de réunion','Table de réunion',300000.00,5,2),(44,'Onduleur fiable pour protéger vos appareils','Onduleur APC 700VA',60000.00,20,5),(45,'Lecteur compact avec écran intégré','Lecteur DVD portable',80000.00,15,4),(46,'Caméra sportive pour enregistrement en 4K','Caméra GoPro Hero 9',250000.00,10,3),(47,'Version classique du célèbre jeu de société','Jeu de société Monopoly',20000.00,40,10),(48,'Parapluie résistant au vent avec ouverture automatique','Parapluie automatique',10000.00,60,15),(49,'Gants résistants pour travaux manuels','Gants de protection en cuir',15000.00,50,10),(50,'Kit essentiel pour soins d’urgence','Trousse de premiers secours',25000.00,20,5),(51,'Riz basmati parfumé de haute qualité','Riz parfumé 5kg',7500.00,50,10),(52,'Huile de palme rouge 100% naturelle','Huile de palme 1L',1500.00,100,20),(53,'Farine locale idéale pour bouillie ou tô','Farine de maïs 1kg',1200.00,80,15),(54,'Sucre blanc raffiné','Sucre granulé 1kg',1000.00,150,30),(55,'Pain complet frais et riche en fibres','Pain complet',800.00,60,10),(56,'Lait entier en poudre pour enfants et adultes','Lait en poudre 400g',3500.00,40,10),(57,'Beurre naturel pour cuisine ou cosmétique','Beurre de karité 500g',2000.00,20,5),(58,'Poisson fumé traditionnel prêt à cuisiner','Poisson fumé 1kg',5500.00,20,5),(59,'Poulet braisé frais, prêt à consommer','Poulet braisé 1kg',7000.00,15,3),(60,'Tomates rouges cultivées localement','Tomates fraîches 1kg',800.00,100,20),(61,'Oignons rouges savoureux pour cuisine','Oignons rouges 1kg',600.00,120,25),(62,'Piments rouges ou verts locaux','Piment frais 1kg',1200.00,50,10),(63,'Mangues sucrées et juteuses','Mangues fraîches 1kg',1500.00,80,15),(64,'Plantains mûrs ou verts','Bananes plantains 3kg',1000.00,87,20),(65,'Haricots secs de haute qualité','Haricots rouges 1kg',2500.00,60,10),(66,'Eau minérale naturelle en bouteille','Eau minérale 1.5L',500.00,200,40),(67,'Jus d’orange frais sans conservateurs','Jus d’orange 1L',2000.00,50,10),(68,'Yaourt nature frais et onctueux','Yaourt nature 500g',1500.00,40,8),(69,'Fromage artisanal fait avec du lait local','Fromage local 250g',2500.00,25,5),(70,'Vin de palme traditionnel et fermenté','Vin de palme 1L',3000.00,30,5),(71,'Ut irure fuga Conse','Laborum Dolores omn',36.00,20,27);
/*!40000 ALTER TABLE `Produit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utilisateurs`
--

DROP TABLE IF EXISTS `utilisateurs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utilisateurs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date_naissance` date DEFAULT NULL,
  `identifiant` varchar(255) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `numero_matricule` varchar(255) NOT NULL,
  `prenom` varchar(255) NOT NULL,
  `sexe` enum('FEMME','HOMME') NOT NULL,
  `role` enum('ADMIN','GESTIONNAIRE_STOCK','VENDEUR') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKaoudmead16ptqds111rrrgrni` (`identifiant`),
  UNIQUE KEY `UK26fa6nm5ccc7yjbauc274bu07` (`numero_matricule`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utilisateurs`
--

LOCK TABLES `utilisateurs` WRITE;
/*!40000 ALTER TABLE `utilisateurs` DISABLE KEYS */;
INSERT INTO `utilisateurs` VALUES (1,'2025-01-01','enokdev','enokdev','Kone','4574','yacouba','HOMME','ADMIN'),(2,'2020-01-17','admin','$2a$10$Y2AwbpCd9cXApFjPoZJoRObdSTKmM94dqqx1KmFKmeXn3NEMqk3Om','admin','admin','admin','HOMME','ADMIN'),(8,'2004-01-13','root','$2a$10$Y2GWSNbxXp4NMBv1JC8Jl.EE0BA3d05savL4EzgdHCoSHLm0eupE.','KONE','KY2568','YACOUBA','HOMME','VENDEUR'),(9,'2016-01-02','vendeur','$2a$10$SSTW6l2SASXk/azcS8EA5Oyao84EiwWyq.XJq/lgW26GxV.8J2VIW','SANOU','85633','ISSA','HOMME','GESTIONNAIRE_STOCK');
/*!40000 ALTER TABLE `utilisateurs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ventes`
--

DROP TABLE IF EXISTS `ventes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ventes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `date_vente` datetime(6) NOT NULL,
  `montant_total` decimal(38,2) NOT NULL,
  `utilisateur_id` bigint NOT NULL,
  `nom_client` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKk13gvcv3lkesw73akths1xm9` (`utilisateur_id`),
  CONSTRAINT `FKk13gvcv3lkesw73akths1xm9` FOREIGN KEY (`utilisateur_id`) REFERENCES `utilisateurs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ventes`
--

LOCK TABLES `ventes` WRITE;
/*!40000 ALTER TABLE `ventes` DISABLE KEYS */;
INSERT INTO `ventes` VALUES (1,'2025-01-21 17:22:02.640859',200.00,2,'KONE YACOUBA'),(2,'2025-01-21 19:07:06.961012',200.00,2,'DID'),(3,'2025-01-21 19:56:21.839394',2075000.00,2,'Faso TECh'),(4,'2025-01-22 01:02:31.670517',160000.00,2,'Enok'),(5,'2025-01-23 14:48:11.682118',925000.00,2,'IKA'),(6,'2025-01-23 16:19:33.905589',40000.00,2,'BBTS'),(7,'2025-01-23 17:31:48.943797',1250000.00,2,'FASO it');
/*!40000 ALTER TABLE `ventes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-23 18:51:13
