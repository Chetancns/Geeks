SELECT
concat(IFNULL(s.Payment_id,''),IFNULL(s.contract_no,''),IFNULL(s.ContractType,''),
IFNULL(s.PaymentType,''),
IFNULL(s.CURRENCY_CODE,''),
IFNULL(s.Payment_due_date,''),
UPPER(IFNULL(s.`IS_PAYMENT_DONE?`,'')),
IFNULL(s.Payment_Status,'')) AS SOURCE_UNIQUE_KEY,
CASE WHEN s.Payment_ID = d.Payment_ID then 'True' else 'FALSE' end as PaymentIDCompare,
CASE WHEN s.Contract_No = d.Contract_No then 'True' else 'FALSE' end as ContractNoCompare,
CASE WHEN s.ContractType = d.ContractType then 'True' else 'FALSE' end as ContractTypeCompare,
CASE WHEN s.PaymentType = d.PaymentType then 'True' else 'FALSE' end as PaymentTypeCompare,
CASE WHEN s.CURRENCY_CODE = d.CURRENCY_CODE then 'True' else 'FALSE' end as CURRENCY_CODECompare,
CASE WHEN s.FX_Rate = d.FX_Rate then 'True' else 'FALSE' end as FX_RateCompare,
CASE WHEN s.`IS_PAYMENT_DONE?` = d.`IS_PAYMENT_DONE?` then 'True' else 'FALSE' end as IS_PAYMENT_DONECompare,
CASE WHEN s.`Cost (USD)` = d.`Cost (USD)` then 'True' else 'FALSE' end as Cost_in_USDCompare,
CASE WHEN s.`Cost (Local)` = d.`Cost (Local)` then 'True' else 'FALSE' end as Cost_in_LocalCompare,
CASE WHEN s.Payment_due_date = d.Payment_due_date then 'True' else 'FALSE' end as Payment_due_dateCompare,
CASE WHEN s.Approval_date = d.Approval_date then 'True' else 'FALSE' end as Approval_dateCompare,
CASE WHEN s.Approver_Name = d.Approver_Name then 'True' else 'FALSE' end as Approver_NameCompare,
CASE WHEN s.Payment_Received_Date = d.Payment_Received_Date then 'True' else 'FALSE' end as Payment_Received_DateCompare,
CASE WHEN s.Cash_localAmt = d.Cash_localAmt then 'True' else 'FALSE' end as Cash_localAmtCompare,
CASE WHEN s.Cash_deducted_amt = d.Cash_deducted_amt then 'True' else 'FALSE' end as Cash_deducted_amtCompare,
CASE WHEN s.Cash_USDAmt = d.Cash_USDAmt then 'True' else 'FALSE' end as Cash_USDAmtCompare,
CASE WHEN s.Balance_Payment_Local = d.Balance_Payment_Local then 'True' else 'FALSE' end as Balance_Payment_LocalCompare,
CASE WHEN s.Balance_Payment_USD = d.Balance_Payment_USD then 'True' else 'FALSE' end as Balance_Payment_USDCompare,
CASE WHEN s.Issue_Date = d.Issue_Date then 'True' else 'FALSE' end as Issue_DateCompare,
CASE WHEN s.Payment_Status = d.Payment_Status then 'True' else 'FALSE' end as Payment_StatusCompare,
CASE WHEN s.Last_UpdatedDate = d.Last_UpdatedDate then 'True' else 'FALSE' end as Last_UpdatedDateCompare,
CASE WHEN null = d.ID then 'True' else 'FALSE' end as IDCompare,
CASE WHEN s.Payment_Comments = d.Payment_Comments then 'True' else 'FALSE' end as Payment_CommentsCompare,
CASE WHEN s.Products = d.Products then 'True' else 'FALSE' end as ProductsCompare
FROM

(SELECT 
PAYMENT_ID AS Payment_ID,
CONTRACT_NO AS Contract_No,
ContractType AS ContractType,
PaymentType AS PaymentType,
CURRENCY_CODE AS CURRENCY_CODE,
FX_Rate AS FX_Rate,
(CASE 
	WHEN UPPER(`IS_PAYMENT_DONE?`) = "YES" THEN 1 
    WHEN UPPER(`IS_PAYMENT_DONE?`) = "NO" THEN 0 
    WHEN UPPER(`IS_PAYMENT_DONE?`) = "TRUE" THEN 1 
    WHEN UPPER(`IS_PAYMENT_DONE?`) = "FALSE" THEN 0 
    WHEN UPPER(`IS_PAYMENT_DONE?`) = "T" THEN 1 
    WHEN UPPER(`IS_PAYMENT_DONE?`) = "F" THEN 0 
    ELSE `IS_PAYMENT_DONE?`
END) AS `IS_PAYMENT_DONE?`,
`Cost (USD)` AS `Cost (USD)`,
`Cost (Local)` AS `Cost (Local)`,
Payment_due_date AS Payment_due_date,
Approval_date AS Approval_date,
Approver_Name AS Approver_Name,
Payment_Received_Date AS Payment_Received_Date,
Cash_localAmt AS Cash_localAmt,
Cash_deducted_amt AS Cash_deducted_amt,
Cash_USDAmt AS Cash_USDAmt,
Balance_Payment_Local AS Balance_Payment_Local,
Balance_Payment_USD AS Balance_Payment_USD,
Issue_Date AS Issue_Date,
Payment_Status AS Payment_Status,
Last_UpdatedDate AS Last_UpdatedDate,
Payment_Comments AS Payment_Comments,
Products AS Products
FROM tablecompare.source) S

LEFT JOIN

(SELECT 
PAYMENTID AS Payment_ID,
CONTRACTNO AS Contract_No,
ContractType AS ContractType,
PaymentType AS PaymentType,
CURRENCY_CODE AS CURRENCY_CODE,
FX_Rate AS FX_Rate,
(CASE 
	WHEN UPPER(`IS_PAYMENT_COMPLETE?`) = "YES" THEN 1 
    WHEN UPPER(`IS_PAYMENT_COMPLETE?`) = "NO" THEN 0 
    WHEN UPPER(`IS_PAYMENT_COMPLETE?`) = "TRUE" THEN 1 
    WHEN UPPER(`IS_PAYMENT_COMPLETE?`) = "FALSE" THEN 0 
    WHEN UPPER(`IS_PAYMENT_COMPLETE?`) = "T" THEN 1 
    WHEN UPPER(`IS_PAYMENT_COMPLETE?`) = "F" THEN 0 
    ELSE `IS_PAYMENT_COMPLETE?`
END) AS `IS_PAYMENT_DONE?`,
`Cost in USD` AS `Cost (USD)`,
`Cost in Local` AS `Cost (Local)`,
Payment_due_date AS Payment_due_date,
Approval_date AS Approval_date,
Approver_Name AS Approver_Name,
Payment_Received_Date AS Payment_Received_Date,
Cash_localAmt AS Cash_localAmt,
Cash_deducted_amt AS Cash_deducted_amt,
Cash_USDAmt AS Cash_USDAmt,
Balance_Payment_Local AS Balance_Payment_Local,
Balance_Payment_USD AS Balance_Payment_USD,
Issue_Date AS Issue_Date,
Payment_Status AS Payment_Status,
Last_UpdatedDate AS Last_UpdatedDate,
'' AS ID,
Payment_Comments AS Payment_Comments,
Products AS Products
FROM tablecompare.destination) D
ON (
concat(IFNULL(s.Payment_id,''),IFNULL(s.contract_no,''),IFNULL(s.ContractType,''),
IFNULL(s.PaymentType,''),
IFNULL(s.CURRENCY_CODE,''),
IFNULL(s.Payment_due_date,''),
UPPER(IFNULL(s.`IS_PAYMENT_DONE?`,'')),
IFNULL(s.Payment_Status,'')) 
	=
concat(IFNULL(d.Payment_id,''),IFNULL(d.contract_no,''),
IFNULL(d.ContractType,''),
IFNULL(d.PaymentType,''),IFNULL(d.CURRENCY_CODE,''),
IFNULL(d.Payment_due_date,''),
UPPER(IFNULL(d.`IS_PAYMENT_Done?`,'')),IFNULL(d.Payment_Status,''))
);

