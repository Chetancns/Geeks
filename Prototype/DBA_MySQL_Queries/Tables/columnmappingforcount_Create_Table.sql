
CREATE TABLE `excelcomparer`.`columnmappingforcount` (
  `Id_Column_Mapping` int unsigned NOT NULL AUTO_INCREMENT,
  `Source_Column` varchar(500) DEFAULT NULL,
  `Destination_Column` varchar(500) DEFAULT NULL,
  `Is_Unique` int DEFAULT '0',
  `is_Flag` int DEFAULT '0',
  PRIMARY KEY (`Id_Column_Mapping`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;