

Select 
'Source' as Title,
concat(IFNULL(source.Payment_id,''),IFNULL(source.contract_no,''),IFNULL(source.ContractType,''),
IFNULL(source.PaymentType,''),
IFNULL(source.CURRENCY_CODE,''),
date_format(STR_TO_DATE(IFNULL(source.Payment_due_date,''), '%m/%d/%Y'),'%d%m%Y'),
UPPER(IFNULL(source.`IS_PAYMENT_DONE?`,'')),
IFNULL(source.Payment_Status,'')) AS Unique_Key,
'Missing Records in Destination' AS Missing_Remark
From tablecompare.source
Where NOT EXISTS
( select 1 from tablecompare.destination
Where 
concat(IFNULL(source.Payment_id,''),IFNULL(source.contract_no,''),IFNULL(source.ContractType,''),
IFNULL(source.PaymentType,''),
IFNULL(source.CURRENCY_CODE,''),
date_format(STR_TO_DATE(IFNULL(source.Payment_due_date,''), '%m/%d/%Y'),'%d%m%Y'),
UPPER(IFNULL(source.`IS_PAYMENT_DONE?`,'')),
IFNULL(source.Payment_Status,''))
	= 
concat(IFNULL(destination.Paymentid,''),IFNULL(destination.contractno,''),
IFNULL(destination.ContractType,''),
IFNULL(destination.PaymentType,''),IFNULL(destination.CURRENCY_CODE,''),
date_format(STR_TO_DATE(IFNULL(destination.Payment_due_date,''), '%m/%d/%Y'),'%d%m%Y'),
(CASE WHEN destination.`IS_PAYMENT_COMPLETE?` = 0 then 'NO' 
WHEN destination.`IS_PAYMENT_COMPLETE?` = 1 then 'YES' ELSE '' END),
IFNULL(destination.Payment_Status,''))
)

UNION ALL

Select 
'Destination' as Title,
concat(IFNULL(destination.Paymentid,''),IFNULL(destination.contractno,''),
IFNULL(destination.ContractType,''),
IFNULL(destination.PaymentType,''),IFNULL(destination.CURRENCY_CODE,''),
date_format(STR_TO_DATE(IFNULL(destination.Payment_due_date,''), '%m/%d/%Y'),'%d%m%Y'),
(CASE WHEN destination.`IS_PAYMENT_COMPLETE?` = 0 then 'NO' 
WHEN destination.`IS_PAYMENT_COMPLETE?` = 1 then 'YES' ELSE '' END),
IFNULL(destination.Payment_Status,''))AS Unique_Key,
'Missing Records in Source' AS Missing_Remark
From tablecompare.destination
Where NOT EXISTS
( select 1 from tablecompare.source
Where 
concat(IFNULL(destination.Paymentid,''),IFNULL(destination.contractno,''),
IFNULL(destination.ContractType,''),
IFNULL(destination.PaymentType,''),IFNULL(destination.CURRENCY_CODE,''),
date_format(STR_TO_DATE(IFNULL(destination.Payment_due_date,''), '%m/%d/%Y'),'%d%m%Y'),
(CASE WHEN destination.`IS_PAYMENT_COMPLETE?` = 0 then 'NO' 
WHEN destination.`IS_PAYMENT_COMPLETE?` = 1 then 'YES' ELSE '' END),
IFNULL(destination.Payment_Status,''))
	= 
concat(IFNULL(source.Payment_id,''),IFNULL(source.contract_no,''),IFNULL(source.ContractType,''),
IFNULL(source.PaymentType,''),
IFNULL(source.CURRENCY_CODE,''),
date_format(STR_TO_DATE(IFNULL(source.Payment_due_date,''), '%m/%d/%Y'),'%d%m%Y'),
UPPER(IFNULL(source.`IS_PAYMENT_DONE?`,'')),
IFNULL(source.Payment_Status,''))
);