USE SAP_Bikes_DW;
GO

SELECT
    SALESORDERID,
    COUNT(*) AS DuplicateCount
FROM stg.SalesOrders
GROUP BY SALESORDERID
HAVING COUNT(*) > 1;
GO


/* =========================================================
   Check 2: Duplicate Sales Order Items
   ========================================================= */

SELECT
    SALESORDERID,
    SALESORDERITEM,
    COUNT(*) AS DuplicateCount
FROM stg.SalesOrderItems
GROUP BY
    SALESORDERID,
    SALESORDERITEM
HAVING COUNT(*) > 1;
GO


/* =========================================================
   Check 3: Sales Order Items Without a Matching Sales Order
   ========================================================= */

SELECT
    soi.SALESORDERID,
    soi.SALESORDERITEM,
    soi.PRODUCTID
FROM stg.SalesOrderItems soi
LEFT JOIN stg.SalesOrders so
    ON soi.SALESORDERID = so.SALESORDERID
WHERE so.SALESORDERID IS NULL;
GO


/* =========================================================
   Check 4: Sales Order Items Without a Matching Product
   ========================================================= */

SELECT
    soi.SALESORDERID,
    soi.SALESORDERITEM,
    soi.PRODUCTID
FROM stg.SalesOrderItems soi
LEFT JOIN stg.Products p
    ON soi.PRODUCTID = p.PRODUCTID
WHERE p.PRODUCTID IS NULL;
GO


/* =========================================================
   Check 5: Products Without a Matching Product Category
   ========================================================= */

SELECT
    p.PRODUCTID,
    p.PRODCATEGORYID
FROM stg.Products p
LEFT JOIN stg.ProductCategories pc
    ON p.PRODCATEGORYID = pc.PRODCATEGORYID
WHERE pc.PRODCATEGORYID IS NULL;
GO

/* =========================================================
   Check 6: Business Partners Without a Matching Address
   ========================================================= */

SELECT
    bp.PARTNERID,
    bp.COMPANYNAME,
    bp.ADDRESSID
FROM stg.BusinessPartners bp
LEFT JOIN stg.Addresses a
    ON bp.ADDRESSID = a.ADDRESSID
WHERE a.ADDRESSID IS NULL;
GO

/* =========================================================
   Check 7: Employees Without a Matching Address
   ========================================================= */

SELECT
    e.EMPLOYEEID,
    e.NAME_FIRST,
    e.NAME_LAST,
    e.ADDRESSID
FROM stg.Employees e
LEFT JOIN stg.Addresses a
    ON e.ADDRESSID = a.ADDRESSID
WHERE a.ADDRESSID IS NULL;
GO

/* =========================================================
   Check 8: Sales Orders Without Sales Order Items
   ========================================================= */

SELECT
    so.SALESORDERID,
    so.PARTNERID,
    so.CREATEDAT
FROM stg.SalesOrders so
LEFT JOIN stg.SalesOrderItems soi
    ON so.SALESORDERID = soi.SALESORDERID
WHERE soi.SALESORDERID IS NULL;
GO

/* =========================================================
   Check 9: Missing Critical IDs
   ========================================================= */

SELECT
    'SalesOrders' AS TableName,
    'SALESORDERID' AS ColumnName,
    COUNT(*) AS MissingCount
FROM stg.SalesOrders
WHERE SALESORDERID IS NULL
   OR LTRIM(RTRIM(SALESORDERID)) = ''

UNION ALL

SELECT
    'SalesOrderItems',
    'SALESORDERID',
    COUNT(*)
FROM stg.SalesOrderItems
WHERE SALESORDERID IS NULL
   OR LTRIM(RTRIM(SALESORDERID)) = ''

UNION ALL

SELECT
    'SalesOrderItems',
    'PRODUCTID',
    COUNT(*)
FROM stg.SalesOrderItems
WHERE PRODUCTID IS NULL
   OR LTRIM(RTRIM(PRODUCTID)) = ''

UNION ALL

SELECT
    'Products',
    'PRODUCTID',
    COUNT(*)
FROM stg.Products
WHERE PRODUCTID IS NULL
   OR LTRIM(RTRIM(PRODUCTID)) = ''

UNION ALL

SELECT
    'Products',
    'PRODCATEGORYID',
    COUNT(*)
FROM stg.Products
WHERE PRODCATEGORYID IS NULL
   OR LTRIM(RTRIM(PRODCATEGORYID)) = ''

UNION ALL

SELECT
    'BusinessPartners',
    'PARTNERID',
    COUNT(*)
FROM stg.BusinessPartners
WHERE PARTNERID IS NULL
   OR LTRIM(RTRIM(PARTNERID)) = '';
GO

/* =========================================================
   Check 10: Invalid Sales Amounts
   ========================================================= */

SELECT
    SALESORDERID,
    GROSSAMOUNT,
    NETAMOUNT,
    TAXAMOUNT
FROM stg.SalesOrders
WHERE GROSSAMOUNT < 0
   OR NETAMOUNT < 0
   OR TAXAMOUNT < 0;
GO

/* =========================================================
   Check 11: Sales Order Amount Consistency
   ========================================================= */

SELECT
    SALESORDERID,
    GROSSAMOUNT,
    NETAMOUNT,
    TAXAMOUNT,
    (NETAMOUNT + TAXAMOUNT) AS CalculatedGrossAmount,
    GROSSAMOUNT - (NETAMOUNT + TAXAMOUNT) AS Difference
FROM stg.SalesOrders
WHERE ABS(GROSSAMOUNT - (NETAMOUNT + TAXAMOUNT)) > 0.01;
GO


/* =========================================================
   Check 12: Sales Order Item Amount Consistency
   ========================================================= */

SELECT
    SALESORDERID,
    SALESORDERITEM,
    GROSSAMOUNT,
    NETAMOUNT,
    TAXAMOUNT,
    (NETAMOUNT + TAXAMOUNT) AS CalculatedGrossAmount,
    GROSSAMOUNT - (NETAMOUNT + TAXAMOUNT) AS Difference
FROM stg.SalesOrderItems
WHERE ABS(GROSSAMOUNT - (NETAMOUNT + TAXAMOUNT)) > 0.01;
GO


/* =========================================================
   Check 13: Invalid Sales Order Item Quantities
   ========================================================= */

SELECT
    SALESORDERID,
    SALESORDERITEM,
    PRODUCTID,
    QUANTITY,
    QUANTITYUNIT
FROM stg.SalesOrderItems
WHERE QUANTITY <= 0;
GO


/* =========================================================
   Missing Values in SalesOrders
   ========================================================= */

SELECT
    'SALESORDERID' AS ColumnName,
    COUNT(*) AS MissingCount
FROM stg.SalesOrders
WHERE SALESORDERID IS NULL

UNION ALL

SELECT
    'CREATEDBY',
    COUNT(*)
FROM stg.SalesOrders
WHERE CREATEDBY IS NULL

UNION ALL

SELECT
    'CREATEDAT',
    COUNT(*)
FROM stg.SalesOrders
WHERE CREATEDAT IS NULL

UNION ALL

SELECT
    'CHANGEDBY',
    COUNT(*)
FROM stg.SalesOrders
WHERE CHANGEDBY IS NULL

UNION ALL

SELECT
    'CHANGEDAT',
    COUNT(*)
FROM stg.SalesOrders
WHERE CHANGEDAT IS NULL

UNION ALL

SELECT
    'FISCVARIANT',
    COUNT(*)
FROM stg.SalesOrders
WHERE FISCVARIANT IS NULL

UNION ALL

SELECT
    'FISCALYEARPERIOD',
    COUNT(*)
FROM stg.SalesOrders
WHERE FISCALYEARPERIOD IS NULL

UNION ALL

SELECT
    'NOTEID',
    COUNT(*)
FROM stg.SalesOrders
WHERE NOTEID IS NULL

UNION ALL

SELECT
    'PARTNERID',
    COUNT(*)
FROM stg.SalesOrders
WHERE PARTNERID IS NULL

UNION ALL

SELECT
    'SALESORG',
    COUNT(*)
FROM stg.SalesOrders
WHERE SALESORG IS NULL

UNION ALL

SELECT
    'CURRENCY',
    COUNT(*)
FROM stg.SalesOrders
WHERE CURRENCY IS NULL

UNION ALL

SELECT
    'GROSSAMOUNT',
    COUNT(*)
FROM stg.SalesOrders
WHERE GROSSAMOUNT IS NULL

UNION ALL

SELECT
    'NETAMOUNT',
    COUNT(*)
FROM stg.SalesOrders
WHERE NETAMOUNT IS NULL

UNION ALL

SELECT
    'TAXAMOUNT',
    COUNT(*)
FROM stg.SalesOrders
WHERE TAXAMOUNT IS NULL

UNION ALL

SELECT
    'LIFECYCLESTATUS',
    COUNT(*)
FROM stg.SalesOrders
WHERE LIFECYCLESTATUS IS NULL

UNION ALL

SELECT
    'BILLINGSTATUS',
    COUNT(*)
FROM stg.SalesOrders
WHERE BILLINGSTATUS IS NULL

UNION ALL

SELECT
    'DELIVERYSTATUS',
    COUNT(*)
FROM stg.SalesOrders
WHERE DELIVERYSTATUS IS NULL;
GO


/* =========================================================

   Missing Values in Products
   ========================================================= */

SELECT
    'PRODUCTID' AS ColumnName,
    COUNT(*) AS MissingCount
FROM stg.Products
WHERE PRODUCTID IS NULL

UNION ALL

SELECT
    'TYPECODE',
    COUNT(*)
FROM stg.Products
WHERE TYPECODE IS NULL

UNION ALL

SELECT
    'PRODCATEGORYID',
    COUNT(*)
FROM stg.Products
WHERE PRODCATEGORYID IS NULL

UNION ALL

SELECT
    'CREATEDBY',
    COUNT(*)
FROM stg.Products
WHERE CREATEDBY IS NULL

UNION ALL

SELECT
    'CREATEDAT',
    COUNT(*)
FROM stg.Products
WHERE CREATEDAT IS NULL

UNION ALL

SELECT
    'CHANGEDBY',
    COUNT(*)
FROM stg.Products
WHERE CHANGEDBY IS NULL

UNION ALL

SELECT
    'CHANGEDAT',
    COUNT(*)
FROM stg.Products
WHERE CHANGEDAT IS NULL

UNION ALL

SELECT
    'SUPPLIER_PARTNERID',
    COUNT(*)
FROM stg.Products
WHERE SUPPLIER_PARTNERID IS NULL

UNION ALL

SELECT
    'TAXTARIFFCODE',
    COUNT(*)
FROM stg.Products
WHERE TAXTARIFFCODE IS NULL

UNION ALL

SELECT
    'QUANTITYUNIT',
    COUNT(*)
FROM stg.Products
WHERE QUANTITYUNIT IS NULL

UNION ALL

SELECT
    'WEIGHTMEASURE',
    COUNT(*)
FROM stg.Products
WHERE WEIGHTMEASURE IS NULL

UNION ALL

SELECT
    'WEIGHTUNIT',
    COUNT(*)
FROM stg.Products
WHERE WEIGHTUNIT IS NULL

UNION ALL

SELECT
    'CURRENCY',
    COUNT(*)
FROM stg.Products
WHERE CURRENCY IS NULL

UNION ALL

SELECT
    'PRICE',
    COUNT(*)
FROM stg.Products
WHERE PRICE IS NULL

UNION ALL

SELECT
    'WIDTH',
    COUNT(*)
FROM stg.Products
WHERE WIDTH IS NULL

UNION ALL

SELECT
    'DEPTH',
    COUNT(*)
FROM stg.Products
WHERE DEPTH IS NULL

UNION ALL

SELECT
    'HEIGHT',
    COUNT(*)
FROM stg.Products
WHERE HEIGHT IS NULL

UNION ALL

SELECT
    'DIMENSIONUNIT',
    COUNT(*)
FROM stg.Products
WHERE DIMENSIONUNIT IS NULL

UNION ALL

SELECT
    'PRODUCTPICURL',
    COUNT(*)
FROM stg.Products
WHERE PRODUCTPICURL IS NULL;
GO

/* =========================================================
   
   Missing Values in ProductCategoryText
   ========================================================= */

SELECT
    'PRODCATEGORYID' AS ColumnName,
    COUNT(*) AS MissingCount
FROM stg.ProductCategoryText
WHERE PRODCATEGORYID IS NULL

UNION ALL

SELECT
    'LANGUAGE',
    COUNT(*)
FROM stg.ProductCategoryText
WHERE LANGUAGE IS NULL

UNION ALL

SELECT
    'SHORT_DESCR',
    COUNT(*)
FROM stg.ProductCategoryText
WHERE SHORT_DESCR IS NULL

UNION ALL

SELECT
    'MEDIUM_DESCR',
    COUNT(*)
FROM stg.ProductCategoryText
WHERE MEDIUM_DESCR IS NULL

UNION ALL

SELECT
    'LONG_DESCR',
    COUNT(*)
FROM stg.ProductCategoryText
WHERE LONG_DESCR IS NULL;
GO


/* =========================================================
  
   Missing Values in ProductTexts
   ========================================================= */

SELECT
    'PRODUCTID' AS ColumnName,
    COUNT(*) AS MissingCount
FROM stg.ProductTexts
WHERE PRODUCTID IS NULL

UNION ALL

SELECT
    'LANGUAGE',
    COUNT(*)
FROM stg.ProductTexts
WHERE LANGUAGE IS NULL

UNION ALL

SELECT
    'SHORT_DESCR',
    COUNT(*)
FROM stg.ProductTexts
WHERE SHORT_DESCR IS NULL

UNION ALL

SELECT
    'MEDIUM_DESCR',
    COUNT(*)
FROM stg.ProductTexts
WHERE MEDIUM_DESCR IS NULL

UNION ALL

SELECT
    'LONG_DESCR',
    COUNT(*)
FROM stg.ProductTexts
WHERE LONG_DESCR IS NULL;
GO


/* =========================================================
   Missing Values in BusinessPartners
   ========================================================= */

SELECT
    'PARTNERID' AS ColumnName,
    COUNT(*) AS MissingCount
FROM stg.BusinessPartners
WHERE PARTNERID IS NULL

UNION ALL

SELECT
    'PARTNERROLE',
    COUNT(*)
FROM stg.BusinessPartners
WHERE PARTNERROLE IS NULL

UNION ALL

SELECT
    'EMAILADDRESS',
    COUNT(*)
FROM stg.BusinessPartners
WHERE EMAILADDRESS IS NULL

UNION ALL

SELECT
    'PHONENUMBER',
    COUNT(*)
FROM stg.BusinessPartners
WHERE PHONENUMBER IS NULL

UNION ALL

SELECT
    'FAXNUMBER',
    COUNT(*)
FROM stg.BusinessPartners
WHERE FAXNUMBER IS NULL

UNION ALL

SELECT
    'WEBADDRESS',
    COUNT(*)
FROM stg.BusinessPartners
WHERE WEBADDRESS IS NULL

UNION ALL

SELECT
    'ADDRESSID',
    COUNT(*)
FROM stg.BusinessPartners
WHERE ADDRESSID IS NULL

UNION ALL

SELECT
    'COMPANYNAME',
    COUNT(*)
FROM stg.BusinessPartners
WHERE COMPANYNAME IS NULL

UNION ALL

SELECT
    'LEGALFORM',
    COUNT(*)
FROM stg.BusinessPartners
WHERE LEGALFORM IS NULL

UNION ALL

SELECT
    'CREATEDBY',
    COUNT(*)
FROM stg.BusinessPartners
WHERE CREATEDBY IS NULL

UNION ALL

SELECT
    'CREATEDAT',
    COUNT(*)
FROM stg.BusinessPartners
WHERE CREATEDAT IS NULL

UNION ALL

SELECT
    'CHANGEDBY',
    COUNT(*)
FROM stg.BusinessPartners
WHERE CHANGEDBY IS NULL

UNION ALL

SELECT
    'CHANGEDAT',
    COUNT(*)
FROM stg.BusinessPartners
WHERE CHANGEDAT IS NULL

UNION ALL

SELECT
    'CURRENCY',
    COUNT(*)
FROM stg.BusinessPartners
WHERE CURRENCY IS NULL;
GO


/* =========================================================
 
   Missing Values in Addresses
   ========================================================= */

SELECT
    'ADDRESSID' AS ColumnName,
    COUNT(*) AS MissingCount
FROM stg.Addresses
WHERE ADDRESSID IS NULL

UNION ALL

SELECT
    'CITY',
    COUNT(*)
FROM stg.Addresses
WHERE CITY IS NULL

UNION ALL

SELECT
    'POSTALCODE',
    COUNT(*)
FROM stg.Addresses
WHERE POSTALCODE IS NULL

UNION ALL

SELECT
    'STREET',
    COUNT(*)
FROM stg.Addresses
WHERE STREET IS NULL

UNION ALL

SELECT
    'BUILDING',
    COUNT(*)
FROM stg.Addresses
WHERE BUILDING IS NULL

UNION ALL

SELECT
    'COUNTRY',
    COUNT(*)
FROM stg.Addresses
WHERE COUNTRY IS NULL

UNION ALL

SELECT
    'REGION',
    COUNT(*)
FROM stg.Addresses
WHERE REGION IS NULL

UNION ALL

SELECT
    'ADDRESSTYPE',
    COUNT(*)
FROM stg.Addresses
WHERE ADDRESSTYPE IS NULL

UNION ALL

SELECT
    'VALIDITY_STARTDATE',
    COUNT(*)
FROM stg.Addresses
WHERE VALIDITY_STARTDATE IS NULL

UNION ALL

SELECT
    'VALIDITY_ENDDATE',
    COUNT(*)
FROM stg.Addresses
WHERE VALIDITY_ENDDATE IS NULL

UNION ALL

SELECT
    'LATITUDE',
    COUNT(*)
FROM stg.Addresses
WHERE LATITUDE IS NULL

UNION ALL

SELECT
    'LONGITUDE',
    COUNT(*)
FROM stg.Addresses
WHERE LONGITUDE IS NULL;
GO



/* =========================================================
   Missing Values in Employees
   ========================================================= */

SELECT
    'EMPLOYEEID' AS ColumnName,
    COUNT(*) AS MissingCount
FROM stg.Employees
WHERE EMPLOYEEID IS NULL

UNION ALL

SELECT
    'NAME_FIRST',
    COUNT(*)
FROM stg.Employees
WHERE NAME_FIRST IS NULL

UNION ALL

SELECT
    'NAME_MIDDLE',
    COUNT(*)
FROM stg.Employees
WHERE NAME_MIDDLE IS NULL

UNION ALL

SELECT
    'NAME_LAST',
    COUNT(*)
FROM stg.Employees
WHERE NAME_LAST IS NULL

UNION ALL

SELECT
    'NAME_INITIALS',
    COUNT(*)
FROM stg.Employees
WHERE NAME_INITIALS IS NULL

UNION ALL

SELECT
    'SEX',
    COUNT(*)
FROM stg.Employees
WHERE SEX IS NULL

UNION ALL

SELECT
    'LANGUAGE',
    COUNT(*)
FROM stg.Employees
WHERE LANGUAGE IS NULL

UNION ALL

SELECT
    'PHONENUMBER',
    COUNT(*)
FROM stg.Employees
WHERE PHONENUMBER IS NULL

UNION ALL

SELECT
    'EMAILADDRESS',
    COUNT(*)
FROM stg.Employees
WHERE EMAILADDRESS IS NULL

UNION ALL

SELECT
    'LOGINNAME',
    COUNT(*)
FROM stg.Employees
WHERE LOGINNAME IS NULL

UNION ALL

SELECT
    'ADDRESSID',
    COUNT(*)
FROM stg.Employees
WHERE ADDRESSID IS NULL

UNION ALL

SELECT
    'VALIDITY_STARTDATE',
    COUNT(*)
FROM stg.Employees
WHERE VALIDITY_STARTDATE IS NULL

UNION ALL

SELECT
    'VALIDITY_ENDDATE',
    COUNT(*)
FROM stg.Employees
WHERE VALIDITY_ENDDATE IS NULL;
GO