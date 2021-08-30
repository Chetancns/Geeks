DROP PROCEDURE `excelcomparer`.`IdentifyMissingRecords`;

DELIMITER //
CREATE PROCEDURE `excelcomparer`.`IdentifyMissingRecords`()
BEGIN
	DECLARE sourceUniqueKey VARCHAR(5000) DEFAULT '';
    DECLARE destinationUniqueKey VARCHAR(5000) DEFAULT '';
    DECLARE v_Final_qry VARCHAR(5000) DEFAULT'';
    
	SELECT GROUP_CONCAT(CASE WHEN is_Flag IS NULL 
				THEN CONCAT('IFNULL(source.`',Source_Column,'`,""\)') 
			ELSE 
				CONCAT('IFNULL((CASE WHEN UPPER(source.`',Source_Column,'`) = "YES" THEN 1 
                WHEN UPPER(source.`',Source_Column,'`) = "NO" THEN 0  
                WHEN UPPER(source.`',Source_Column,'`) = "TRUE" THEN 1 
                WHEN UPPER(source.`',Source_Column,'`) = "FALSE" THEN 0 
                WHEN UPPER(source.`',Source_Column,'`) = "T" THEN 1 
                WHEN UPPER(source.`',Source_Column,'`) = "F" THEN 0 
                ELSE source.`',Source_Column,'` END),""\)') 
			END) INTO sourceUniqueKey 
	FROM ColumnMapping 
	WHERE Is_Unique = 1 
	GROUP BY Is_Unique
	ORDER BY Id_Column_Mapping;
    
    SELECT GROUP_CONCAT(CASE WHEN is_Flag IS NULL 
			THEN CONCAT('IFNULL(destination.`',Destination_Column,'`,""\)') 
		ELSE 
			CONCAT('IFNULL((CASE WHEN UPPER(destination.`',Destination_Column,'`) = "YES" THEN 1 
            WHEN UPPER(destination.`',Destination_Column,'`) = "NO" THEN 0  
            WHEN UPPER(destination.`',Destination_Column,'`) = "TRUE" THEN 1 
            WHEN UPPER(destination.`',Destination_Column,'`) = "FALSE" THEN 0 
            WHEN UPPER(destination.`',Destination_Column,'`) = "T" THEN 1 
            WHEN UPPER(destination.`',Destination_Column,'`) = "F" THEN 0 
            ELSE destination.`',Destination_Column,'` END),""\)') 
		END) INTO destinationUniqueKey 
	FROM ColumnMapping 
	WHERE Is_Unique = 1 
	GROUP BY Is_Unique
	ORDER BY Id_Column_Mapping;
    
	SET @SQLText = CONCAT('Select "Source" as Title, concat(',sourceUniqueKey,') AS Unique_Key, 
		"Missing Records in Destination" AS Missing_Remark From excelcomparer.source Where NOT EXISTS 
		( select 1 from excelcomparer.destination 
		Where concat(',sourceUniqueKey,') = concat(',destinationUniqueKey,')) 
		UNION ALL 
		Select "Destination" as Title, concat(',destinationUniqueKey,') AS Unique_Key, 
		"Missing Records in Source" AS Missing_Remark From excelcomparer.destination Where NOT EXISTS 
		( select 1 from excelcomparer.source 
		Where concat(',destinationUniqueKey,') = concat(',sourceUniqueKey,')) ');   
        
        /*SET v_Final_qry = @SQLText;
        SELECT v_Final_qry;*/
        
		PREPARE stmt FROM @SQLText;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
END //
DELIMITER ;




CALL `excelcomparer`.`IdentifyMissingRecords`();
