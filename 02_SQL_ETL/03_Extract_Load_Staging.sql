/* =========================================================
   SAP Bikes Data Warehouse & BI Project
   File: 03_Extract_Load_Staging.sql
   ========================================================= */


/* =========================================================
   1. Select Database
   ========================================================= */

USE SAP_Bikes_DW;
GO


/* =========================================================
   2. Clear Existing Staging Data
   ========================================================= */

TRUNCATE TABLE stg.Addresses;
GO

TRUNCATE TABLE stg.BusinessPartners;
GO

TRUNCATE TABLE stg.Employees;
GO

TRUNCATE TABLE stg.ProductCategories;
GO

TRUNCATE TABLE stg.ProductCategoryText;
GO

TRUNCATE TABLE stg.ProductTexts;
GO

TRUNCATE TABLE stg.Products;
GO

TRUNCATE TABLE stg.SalesOrders;
GO

TRUNCATE TABLE stg.SalesOrderItems;
GO


/* =========================================================
   3. Load Addresses.csv
   ========================================================= */

BULK INSERT stg.Addresses
FROM 'D:\Sliit\3rd year 1 semester\SAP_Bikes_DWBI_Project\Raw_Data\Addresses.csv'
WITH
(
    DATAFILETYPE = 'char',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


/* =========================================================
   4. Load BusinessPartners.csv
   ========================================================= */

BULK INSERT stg.BusinessPartners
FROM 'D:\Sliit\3rd year 1 semester\SAP_Bikes_DWBI_Project\Raw_Data\BusinessPartners.csv'
WITH
(
    DATAFILETYPE = 'char',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


/* =========================================================
   5. Load Employees.csv
   ========================================================= */

BULK INSERT stg.Employees
FROM 'D:\Sliit\3rd year 1 semester\SAP_Bikes_DWBI_Project\Raw_Data\Employees.csv'
WITH
(
    DATAFILETYPE = 'char',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


/* =========================================================
   6. Load ProductCategories.csv
   ========================================================= */

BULK INSERT stg.ProductCategories
FROM 'D:\Sliit\3rd year 1 semester\SAP_Bikes_DWBI_Project\Raw_Data\ProductCategories.csv'
WITH
(
    DATAFILETYPE = 'char',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


/* =========================================================
   7. Load ProductCategoryText.csv
   ========================================================= */

BULK INSERT stg.ProductCategoryText
FROM 'D:\Sliit\3rd year 1 semester\SAP_Bikes_DWBI_Project\Raw_Data\ProductCategoryText.csv'
WITH
(
    DATAFILETYPE = 'char',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


/* =========================================================
   8. Load ProductTexts.csv
   ========================================================= */

BULK INSERT stg.ProductTexts
FROM 'D:\Sliit\3rd year 1 semester\SAP_Bikes_DWBI_Project\Raw_Data\ProductTexts.csv'
WITH
(
    DATAFILETYPE = 'char',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


/* =========================================================
   9. Load SalesOrders.csv
   ========================================================= */

BULK INSERT stg.SalesOrders
FROM 'D:\Sliit\3rd year 1 semester\SAP_Bikes_DWBI_Project\Raw_Data\SalesOrders.csv'
WITH
(
    DATAFILETYPE = 'char',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


/* =========================================================
   10. Load SalesOrderItems.csv
   ========================================================= */

BULK INSERT stg.SalesOrderItems
FROM 'D:\Sliit\3rd year 1 semester\SAP_Bikes_DWBI_Project\Raw_Data\SalesOrderItems.csv'
WITH
(
    DATAFILETYPE = 'char',
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    FIRSTROW = 2,
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO


/* =========================================================
   11. Load Products.json
   ========================================================= */

INSERT INTO stg.Products
(
    PRODUCTID,
    TYPECODE,
    PRODCATEGORYID,
    CREATEDBY,
    CREATEDAT,
    CHANGEDBY,
    CHANGEDAT,
    SUPPLIER_PARTNERID,
    TAXTARIFFCODE,
    QUANTITYUNIT,
    WEIGHTMEASURE,
    WEIGHTUNIT,
    CURRENCY,
    PRICE,
    WIDTH,
    DEPTH,
    HEIGHT,
    DIMENSIONUNIT,
    PRODUCTPICURL
)
SELECT
    PRODUCTID,
    TYPECODE,
    PRODCATEGORYID,
    CREATEDBY,
    CREATEDAT,
    CHANGEDBY,
    CHANGEDAT,
    SUPPLIER_PARTNERID,
    TAXTARIFFCODE,
    QUANTITYUNIT,
    WEIGHTMEASURE,
    WEIGHTUNIT,
    CURRENCY,
    PRICE,
    WIDTH,
    DEPTH,
    HEIGHT,
    DIMENSIONUNIT,
    PRODUCTPICURL
FROM OPENROWSET
(
    BULK 'D:\Sliit\3rd year 1 semester\SAP_Bikes_DWBI_Project\Raw_Data\Products.json',
    SINGLE_CLOB
) AS ProductFile
CROSS APPLY OPENJSON(ProductFile.BulkColumn)
WITH
(
    PRODUCTID            VARCHAR(30)   '$.PRODUCTID',
    TYPECODE             VARCHAR(20)   '$.TYPECODE',
    PRODCATEGORYID       VARCHAR(20)   '$.PRODCATEGORYID',
    CREATEDBY            VARCHAR(20)   '$.CREATEDBY',
    CREATEDAT            VARCHAR(20)   '$.CREATEDAT',
    CHANGEDBY            VARCHAR(20)   '$.CHANGEDBY',
    CHANGEDAT            VARCHAR(20)   '$.CHANGEDAT',
    SUPPLIER_PARTNERID   VARCHAR(20)   '$.SUPPLIER_PARTNERID',
    TAXTARIFFCODE        VARCHAR(20)   '$.TAXTARIFFCODE',
    QUANTITYUNIT         VARCHAR(20)   '$.QUANTITYUNIT',
    WEIGHTMEASURE        DECIMAL(18,3) '$.WEIGHTMEASURE',
    WEIGHTUNIT           VARCHAR(20)   '$.WEIGHTUNIT',
    CURRENCY              VARCHAR(10)   '$.CURRENCY',
    PRICE                DECIMAL(18,2)  '$.PRICE',
    WIDTH                DECIMAL(18,3)  '$.WIDTH',
    DEPTH                DECIMAL(18,3)  '$.DEPTH',
    HEIGHT               DECIMAL(18,3)  '$.HEIGHT',
    DIMENSIONUNIT        VARCHAR(20)   '$.DIMENSIONUNIT',
    PRODUCTPICURL        VARCHAR(500)  '$.PRODUCTPICURL'
);
GO


/* =========================================================
   12. Final Staging Row Count Validation
   ========================================================= */

SELECT
    'Addresses' AS TableName,
    COUNT(*) AS TotalRows
FROM stg.Addresses

UNION ALL

SELECT
    'BusinessPartners',
    COUNT(*)
FROM stg.BusinessPartners

UNION ALL

SELECT
    'Employees',
    COUNT(*)
FROM stg.Employees

UNION ALL

SELECT
    'ProductCategories',
    COUNT(*)
FROM stg.ProductCategories

UNION ALL

SELECT
    'ProductCategoryText',
    COUNT(*)
FROM stg.ProductCategoryText

UNION ALL

SELECT
    'ProductTexts',
    COUNT(*)
FROM stg.ProductTexts

UNION ALL

SELECT
    'Products',
    COUNT(*)
FROM stg.Products

UNION ALL

SELECT
    'SalesOrders',
    COUNT(*)
FROM stg.SalesOrders

UNION ALL

SELECT
    'SalesOrderItems',
    COUNT(*)
FROM stg.SalesOrderItems;
GO


/* =========================================================
   13. Check Missing Product Category Description
   ========================================================= */

SELECT
    pc.PRODCATEGORYID
FROM stg.ProductCategories pc
LEFT JOIN stg.ProductCategoryText pct
    ON pc.PRODCATEGORYID = pct.PRODCATEGORYID
WHERE pct.PRODCATEGORYID IS NULL;
GO