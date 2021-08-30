CREATE TABLE excelcomparer.ColumnMapping
(
Id_Column_Mapping INT UNSIGNED NOT NULL AUTO_INCREMENT,
Source_Column VARCHAR(500) DEFAULT NULL,
Destination_Column VARCHAR(500) DEFAULT NULL,
Is_Unique INT DEFAULT 0,
is_Flag INT DEFAULT 0,
primary key (Id_Column_Mapping)
);

/*INSERT INTO ColumnMapping(Source_Column, Destination_Column, Is_Unique)
VALUES("Test1","Test2",1);
INSERT INTO ColumnMapping(Source_Column, Destination_Column, Is_Unique)
VALUES("Test2","Test3",NULL);


SELECT * FROM ColumnMapping;
TRUNCATE table ColumnMapping;*/