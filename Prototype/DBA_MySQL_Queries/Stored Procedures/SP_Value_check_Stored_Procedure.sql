DROP PROCEDURE `excelcomparer`.`SP_Value_check`;

CALL `excelcomparer`.`SP_Value_check`;

DELIMITER //
CREATE PROCEDURE `SP_Value_check`()
BEGIN
declare v_Select text;
declare v_From text;
declare v_Where text;
declare v_unq_col_nm varchar(200);
declare v_col_nm varchar(500);
declare v_is_flag int;
declare v_On_condition text;
declare v_src_col varchar(200);
declare v_dest_col varchar(200);
declare v_Final_qry text;


DECLARE done INT DEFAULT FALSE;


DECLARE cursor_i CURSOR FOR SELECT concat('CONCAT(src.`',source_column,'`,""\) as `src_unq_',source_column,'`,') as src_col , 
source_column,destination_column,is_flag
FROM excelcomparer.columnmapping where coalesce(is_unique,0)=1;


DECLARE cursor_j CURSOR FOR SELECT source_column,destination_column,is_flag
FROM excelcomparer.columnmapping where coalesce(is_unique,0)=0;


DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;


set v_Select = 'select ';
set v_From = ' from excelcomparer.source src inner join excelcomparer.destination dest on ';
set v_Where = ' where (';


  OPEN cursor_i;
  read_loop: LOOP
    FETCH cursor_i INTO v_unq_col_nm,v_src_col,v_dest_col,v_is_flag;
    IF done THEN
      LEAVE read_loop;
    END IF;
    set v_Select = concat(v_Select,v_unq_col_nm);
    
    if v_is_flag = '1' then
        set v_On_condition = concat(' (case when upper(src.`',v_src_col,'`) in (\'YES\',\'TRUE\',\'Y\',\'T\',\'1\') then CONCAT(1,""\) ');
        set v_On_condition = concat(v_On_condition,' else CONCAT(0,""\) end) ');
        set v_On_condition = concat(v_On_condition,' = ');
        set v_On_condition = concat(v_On_condition,' (case when upper(dest.`',v_dest_col,'`) in (\'YES\',\'TRUE\',\'Y\',\'T\',\'1\') then CONCAT(1,""\) ');
        set v_On_condition = concat(v_On_condition,' else CONCAT(0,""\) end) ');
        set v_On_condition = concat(v_On_condition,' and ');
    else
        set v_On_condition = concat('src.`',v_src_col,'` = ','dest.`',v_dest_col, '` and ');
    end if;
    
    set v_From = concat(v_From,v_On_condition);
  END LOOP;
  CLOSE cursor_i; 


SET done = false;
SET v_src_col = '';
SET v_dest_col = '';
SET v_is_flag = null;
  
  OPEN cursor_j;
  read_loop2: LOOP
    FETCH cursor_j INTO v_src_col,v_dest_col,v_is_flag;
    IF done THEN
      LEAVE read_loop2;
    END IF;
    
    set v_Select = concat(v_Select,'CONCAT(src.`',v_src_col,'`,""\) as `src_',v_src_col,'`, CONCAT(dest.`', v_dest_col,'`,""\) as `dest_',v_dest_col,'`,');
    
    if v_is_flag = '1' then
        set v_Where = concat(v_Where,' ((case when upper(src.`',v_src_col,'`) in (\'YES\',\'TRUE\',\'Y\',\'T\',\'1\') then CONCAT(1,""\) ');
        set v_Where = concat(v_Where,' else CONCAT(0,""\) end) ');
        set v_Where = concat(v_Where,' != ');
        set v_Where = concat(v_Where,' (case when upper(dest.`',v_dest_col,'`) in (\'YES\',\'TRUE\',\'Y\',\'T\',\'1\') then CONCAT(1,""\) ');
        set v_Where = concat(v_Where,' else CONCAT(0,""\) end)) ');
        set v_Where = concat(v_Where,' OR ');
        
        set v_Select = concat(v_Select,' (case when (case when upper(src.`',v_src_col,'`) in (\'YES\',\'TRUE\',\'Y\',\'T\',\'1\') then CONCAT(1,""\) ');
        set v_Select = concat(v_Select,' else CONCAT(0,""\) end) ');
        set v_Select = concat(v_Select,' = ');
        set v_Select = concat(v_Select,' (case when upper(dest.`',v_dest_col,'`) in (\'YES\',\'TRUE\',\'Y\',\'T\',\'1\') then CONCAT(1,""\) ');
        set v_Select = concat(v_Select,' else CONCAT(0,""\) end) then \'TRUE\' else \'FALSE\' end) as `match_');
        set v_Select = concat(v_Select, v_src_col,'`,');
    else
        set v_Where = concat (v_Where, '(coalesce(src.`',v_src_col,'`,\'\') != ', 'coalesce(dest.`',v_dest_col, '`,\'\')) OR ');
        set v_Select = concat(v_Select, ' (case when (coalesce(src.`',v_src_col,'`,\'\') = ', 'coalesce(dest.`',v_dest_col, '`,\'\')) then \'TRUE\' else \'FALSE\' end) as `match_',v_src_col,'`,');
    end if;
    
  END LOOP;
  CLOSE cursor_j;


set v_Where = CONCAT(LEFT(TRIM(v_Where), LENGTH(TRIM(v_Where))-2),')');


SET v_Final_qry = concat(LEFT(TRIM(v_Select), LENGTH(TRIM(v_Select))-1),' ' , LEFT(TRIM(v_From), LENGTH(TRIM(v_From))-3), v_Where);


/*SELECT v_Final_qry;*/


SET @t = v_Final_qry;


PREPARE stmt3 FROM @t;
EXECUTE stmt3;
DEALLOCATE PREPARE stmt3;


END //
DELIMITER ;