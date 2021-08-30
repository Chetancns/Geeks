DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_Record_Count`()
Select * from (
Select 'Source' as 'From',count(*) as `Number of Records`, (Select Count(Source_Column) from columnmappingForCount) as `Column Count`   from source
Union
Select 'Destination' as 'From',count(*) as `Number of Records`, (Select Count(Destination_Column) as `Column Count` from columnmappingForCount) as `Column Count`  from destination) T$$
DELIMITER ;