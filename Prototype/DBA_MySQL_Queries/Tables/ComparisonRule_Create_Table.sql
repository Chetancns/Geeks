CREATE TABLE `excelcomparer`.`comparisonrule` (
  `rule_id` int NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(1000) DEFAULT NULL,
  `rule_qry` varchar(10000) DEFAULT NULL,
  `rule_typ` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`rule_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO `comparisonrule` (`rule_id`,`rule_name`,`rule_qry`,`rule_typ`) VALUES (1,'Column Compare',NULL,NULL);
INSERT INTO `comparisonrule` (`rule_id`,`rule_name`,`rule_qry`,`rule_typ`) VALUES (2,'Record Count',NULL,NULL);
INSERT INTO `comparisonrule` (`rule_id`,`rule_name`,`rule_qry`,`rule_typ`) VALUES (3,'Unique Key Missing Records',NULL,NULL);
INSERT INTO `comparisonrule` (`rule_id`,`rule_name`,`rule_qry`,`rule_typ`) VALUES (4,'Final Summary',NULL,NULL);
