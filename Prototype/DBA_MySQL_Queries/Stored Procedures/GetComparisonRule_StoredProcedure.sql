DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetComparisonRuleDetails`()
BEGIN
	SELECT rule_id, rule_name, rule_qry, rule_typ
	FROM excelcomparer.comparisonrule
    ORDER BY rule_id;
END$$
DELIMITER ;
