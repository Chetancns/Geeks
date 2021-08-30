DROP PROCEDURE IdentifyMismatchColumns;

CALL `excelcomparer`.`IdentifyMismatchColumns`();

DELIMITER //
CREATE PROCEDURE IdentifyMismatchColumns()
BEGIN
	DECLARE selectStatement VARCHAR(5000)  DEFAULT '';
    DECLARE selectStatement2 VARCHAR(5000)  DEFAULT '';
	DECLARE sourceQuery VARCHAR(5000)  DEFAULT '';
	DECLARE destinationQuery VARCHAR(5000) DEFAULT '';
	DECLARE sourceUniqueKey VARCHAR(5000) DEFAULT '';
    DECLARE destinationUniqueKey VARCHAR(5000) DEFAULT '';
    declare v_unq_col_nm varchar(2000);
    declare v_unq_col_nm2 varchar(2000);
    declare v_unq_col_nm3 varchar(7000);
    declare v_unq_col_nm4 varchar(2000);
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE cursor_n CURSOR FOR   SELECT GROUP_CONCAT(' IFNULL(s.`',Source_Column,'`,""\) AS `SRC_UNQ_',Source_Column,'` ') 
	FROM ColumnMapping 
	WHERE Is_Unique = 1 
	GROUP BY Is_Unique
	ORDER BY Id_Column_Mapping;
    
    DECLARE cursor_i CURSOR FOR SELECT 	CASE WHEN is_Flag IS NULL 
			THEN CONCAT('`',DESTINATION_Column,'` AS `',Source_Column,'`') 
			ELSE 
			CONCAT('(CASE WHEN UPPER(`',Destination_Column,'`) = "YES" THEN 1 
            WHEN UPPER(`',Destination_Column,'`) = "NO" THEN 0  
            WHEN UPPER(`',Destination_Column,'`) = "TRUE" THEN 1 
            WHEN UPPER(`',Destination_Column,'`) = "FALSE" THEN 0 
            WHEN UPPER(`',Destination_Column,'`) = "T" THEN 1 
            WHEN UPPER(`',Destination_Column,'`) = "F" THEN 0 
            ELSE CONCAT(`',Destination_Column,'`,""\) END) AS `',Source_Column,'`')
            END
	FROM ColumnMapping 
    WHERE Source_Column <> ''
	ORDER BY Id_Column_Mapping;
    
    DECLARE cursor_j CURSOR FOR SELECT 	CASE WHEN is_Flag IS NULL 
			THEN CONCAT('`',Source_Column,'` AS `',Source_Column,'`') 
			ELSE 
			CONCAT('(CASE WHEN UPPER(`',Source_Column,'`) = "YES" THEN 1 
            WHEN UPPER(`',Source_Column,'`) = "NO" THEN 0  
            WHEN UPPER(`',Source_Column,'`) = "TRUE" THEN 1 
            WHEN UPPER(`',Source_Column,'`) = "FALSE" THEN 0 
            WHEN UPPER(`',Source_Column,'`) = "T" THEN 1 
            WHEN UPPER(`',Source_Column,'`) = "F" THEN 0 
            ELSE CONCAT(`',Source_Column,'`,""\) END) AS `',Source_Column,'`')
            END
	FROM ColumnMapping 
    WHERE Source_Column <> ''
	ORDER BY Id_Column_Mapping;
    
    DECLARE cursor_k CURSOR FOR SELECT 
    CONCAT('CASE WHEN CONCAT(s.`',Source_Column,'`,""\) = CONCAT(d.`',Source_Column,'`,""\) THEN "True" ELSE "False" END AS `',Source_Column,'` ') 
    AS selectStatement 
	FROM ColumnMapping 
    WHERE Source_Column <> ''
	ORDER BY Id_Column_Mapping;
    
     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
     
     OPEN cursor_n;
	  read_loop3: LOOP
		FETCH cursor_n INTO v_unq_col_nm4;
		IF done THEN
		  LEAVE read_loop3;
		END IF;
		set selectStatement2 = concat(selectStatement2,v_unq_col_nm4,",");
	  END LOOP;
	  CLOSE cursor_n;  
      
      SET done = false;
      
     OPEN cursor_i;
	  read_loop: LOOP
		FETCH cursor_i INTO v_unq_col_nm;
		IF done THEN
		  LEAVE read_loop;
		END IF;
		set destinationQuery = concat(destinationQuery,v_unq_col_nm,",");
	  END LOOP;
	  CLOSE cursor_i;  
      
      SET done = false;
      
     OPEN cursor_j;
	  read_loop2: LOOP
		FETCH cursor_j INTO v_unq_col_nm2;
		IF done THEN
		  LEAVE read_loop2;
		END IF;
		set sourceQuery = concat(sourceQuery,v_unq_col_nm2,",");
	  END LOOP;
	  CLOSE cursor_j;
      
      SET done = false;
		
        OPEN cursor_k;
	  read_loop3: LOOP
		FETCH cursor_k INTO v_unq_col_nm3;
		IF done THEN
		  LEAVE read_loop3;
		END IF;
		set selectStatement = concat(selectStatement,v_unq_col_nm3,",");
	  END LOOP;
	  CLOSE cursor_k;
        
	SELECT GROUP_CONCAT('IFNULL(s.`',Source_Column,'`,""\)') INTO sourceUniqueKey 
	FROM ColumnMapping 
	WHERE Is_Unique = 1 
	GROUP BY Is_Unique
	ORDER BY Id_Column_Mapping;
    
    SELECT GROUP_CONCAT('IFNULL(d.`',Source_Column,'`,""\)') INTO destinationUniqueKey 
	FROM ColumnMapping 
	WHERE Is_Unique = 1 
	GROUP BY Is_Unique
	ORDER BY Id_Column_Mapping;

    /*SET @SQLText = CONCAT('Select ',selectStatement2,' concat(',sourceUniqueKey,') AS SOURCE_UNIQUE_KEY, ',
    selectStatement,' 1 FROM (SELECT ',sourceQuery,' 1 FROM excelcomparer.source) S
    INNER JOIN (SELECT ',destinationQuery,' 1 FROM excelcomparer.destination) D
	ON ( concat(',sourceUniqueKey,' ) = concat(',destinationUniqueKey,' )) ');*/
    
    SET @SQLText = CONCAT('Select ',selectStatement2,' ',
    selectStatement,' CONCAT(1,""\) FROM (SELECT ',sourceQuery,' CONCAT(1,""\) FROM excelcomparer.source) S
    INNER JOIN (SELECT ',destinationQuery,' CONCAT(1,""\) FROM excelcomparer.destination) D
	ON ( concat(',sourceUniqueKey,' ) = concat(',destinationUniqueKey,' )) ');
    
    /*SET v_unq_col_nm3 = @SQLText;
    SELECT v_unq_col_nm3;*/
    PREPARE stmt FROM @SQLText;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //
DELIMITER ;


