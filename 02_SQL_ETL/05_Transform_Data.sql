/* =========================================================
   SAP Bikes Data Warehouse & BI Project
   ========================================================= */

USE SAP_Bikes_DW;
GO


/* =========================================================
   Transformation 1:
   Sales Orders
   ---------------------------------------------------------
   - Convert CREATEDAT from YYYYMMDD to DATE
   - Convert CHANGEDAT from YYYYMMDD to DATE
   - Preserve financial measures
   - Preserve source values
   - Handle blank NOTEID as NULL
   ========================================================= */

CREATE OR ALTER VIEW stg.vw_SalesOrders_Transformed
AS
SELECT
    SALESORDERID,

    CREATEDBY,

    TRY_CONVERT(DATE, CREATEDAT, 112) AS CREATED_DATE,

    CHANGEDBY,

    TRY_CONVERT(DATE, CHANGEDAT, 112) AS CHANGED_DATE,

    FISCVARIANT,

    FISCALYEARPERIOD,

    NULLIF(LTRIM(RTRIM(NOTEID)), '') AS NOTEID,

    PARTNERID,

    SALESORG,

    UPPER(LTRIM(RTRIM(CURRENCY))) AS CURRENCY,

    GROSSAMOUNT,

    NETAMOUNT,

    TAXAMOUNT,

    LIFECYCLESTATUS,

    BILLINGSTATUS,

    DELIVERYSTATUS

FROM stg.SalesOrders;
GO

SELECT TOP 10 *
FROM stg.vw_SalesOrders_Transformed;
GO


/* =========================================================
   Transformation 3:
   Products
   ---------------------------------------------------------
   - Clean text fields
   - Standardize currency
   - Preserve numeric product attributes
   ========================================================= */

CREATE OR ALTER VIEW stg.vw_Products_Transformed
AS
SELECT
    NULLIF(LTRIM(RTRIM(PRODUCTID)), '') AS PRODUCTID,

    NULLIF(LTRIM(RTRIM(TYPECODE)), '') AS TYPECODE,

    NULLIF(LTRIM(RTRIM(PRODCATEGORYID)), '') AS PRODCATEGORYID,

    NULLIF(LTRIM(RTRIM(CREATEDBY)), '') AS CREATEDBY,

    TRY_CONVERT(DATE, CREATEDAT, 112) AS CREATED_DATE,

    NULLIF(LTRIM(RTRIM(CHANGEDBY)), '') AS CHANGEDBY,

    TRY_CONVERT(DATE, CHANGEDAT, 112) AS CHANGED_DATE,

    NULLIF(LTRIM(RTRIM(SUPPLIER_PARTNERID)), '') AS SUPPLIER_PARTNERID,

    NULLIF(LTRIM(RTRIM(TAXTARIFFCODE)), '') AS TAXTARIFFCODE,

    NULLIF(LTRIM(RTRIM(QUANTITYUNIT)), '') AS QUANTITYUNIT,

    WEIGHTMEASURE,

    NULLIF(LTRIM(RTRIM(WEIGHTUNIT)), '') AS WEIGHTUNIT,

    UPPER(LTRIM(RTRIM(CURRENCY))) AS CURRENCY,

    PRICE,

    WIDTH,

    DEPTH,

    HEIGHT,

    NULLIF(LTRIM(RTRIM(DIMENSIONUNIT)), '') AS DIMENSIONUNIT,

    NULLIF(LTRIM(RTRIM(PRODUCTPICURL)), '') AS PRODUCTPICURL

FROM stg.Products;
GO


SELECT TOP 10 *
FROM stg.vw_Products_Transformed;
GO



/* =========================================================
   Transformation 4:
   Business Partners / Customers
   ---------------------------------------------------------
   - Trim text fields
   - Convert blank values to NULL
   - Standardize currency
   ========================================================= */

CREATE OR ALTER VIEW stg.vw_BusinessPartners_Transformed
AS
SELECT
    NULLIF(LTRIM(RTRIM(PARTNERID)), '') AS PARTNERID,

    NULLIF(LTRIM(RTRIM(PARTNERROLE)), '') AS PARTNERROLE,

    NULLIF(LTRIM(RTRIM(EMAILADDRESS)), '') AS EMAILADDRESS,

    NULLIF(LTRIM(RTRIM(PHONENUMBER)), '') AS PHONENUMBER,

    NULLIF(LTRIM(RTRIM(FAXNUMBER)), '') AS FAXNUMBER,

    NULLIF(LTRIM(RTRIM(WEBADDRESS)), '') AS WEBADDRESS,

    NULLIF(LTRIM(RTRIM(ADDRESSID)), '') AS ADDRESSID,

    NULLIF(LTRIM(RTRIM(COMPANYNAME)), '') AS COMPANYNAME,

    NULLIF(LTRIM(RTRIM(LEGALFORM)), '') AS LEGALFORM,

    NULLIF(LTRIM(RTRIM(CREATEDBY)), '') AS CREATEDBY,

    TRY_CONVERT(DATE, CREATEDAT, 112) AS CREATED_DATE,

    NULLIF(LTRIM(RTRIM(CHANGEDBY)), '') AS CHANGEDBY,

    TRY_CONVERT(DATE, CHANGEDAT, 112) AS CHANGED_DATE,

    UPPER(LTRIM(RTRIM(CURRENCY))) AS CURRENCY

FROM stg.BusinessPartners;
GO


SELECT TOP 10 *
FROM stg.vw_BusinessPartners_Transformed;
GO



/* =========================================================
   Transformation 5:
   Addresses / Locations
   ---------------------------------------------------------
   - Trim text fields
   - Convert blank values to NULL
   - Preserve geographic coordinates
   ========================================================= */

CREATE OR ALTER VIEW stg.vw_Addresses_Transformed
AS
SELECT
    NULLIF(LTRIM(RTRIM(ADDRESSID)), '') AS ADDRESSID,

    NULLIF(LTRIM(RTRIM(CITY)), '') AS CITY,

    NULLIF(LTRIM(RTRIM(POSTALCODE)), '') AS POSTALCODE,

    NULLIF(LTRIM(RTRIM(STREET)), '') AS STREET,

    NULLIF(LTRIM(RTRIM(BUILDING)), '') AS BUILDING,

    NULLIF(LTRIM(RTRIM(COUNTRY)), '') AS COUNTRY,

    NULLIF(LTRIM(RTRIM(REGION)), '') AS REGION,

    NULLIF(LTRIM(RTRIM(ADDRESSTYPE)), '') AS ADDRESSTYPE,

    TRY_CONVERT(DATE, VALIDITY_STARTDATE, 112) AS VALIDITY_START_DATE,

    TRY_CONVERT(DATE, VALIDITY_ENDDATE, 112) AS VALIDITY_END_DATE,

    LATITUDE,

    LONGITUDE

FROM stg.Addresses;
GO


SELECT TOP 10 *
FROM stg.vw_Addresses_Transformed;
GO


/* =========================================================
   Transformation 6:
   Employees
   ---------------------------------------------------------
   - Clean name and contact fields
   - Standardize language
   - Convert validity dates
   ========================================================= */

CREATE OR ALTER VIEW stg.vw_Employees_Transformed
AS
SELECT
    NULLIF(LTRIM(RTRIM(EMPLOYEEID)), '') AS EMPLOYEEID,

    NULLIF(LTRIM(RTRIM(NAME_FIRST)), '') AS FIRST_NAME,

    NULLIF(LTRIM(RTRIM(NAME_MIDDLE)), '') AS MIDDLE_NAME,

    NULLIF(LTRIM(RTRIM(NAME_LAST)), '') AS LAST_NAME,

    NULLIF(LTRIM(RTRIM(NAME_INITIALS)), '') AS INITIALS,

    NULLIF(LTRIM(RTRIM(SEX)), '') AS SEX,

    UPPER(NULLIF(LTRIM(RTRIM(LANGUAGE)), '')) AS LANGUAGE_CODE,

    NULLIF(LTRIM(RTRIM(PHONENUMBER)), '') AS PHONENUMBER,

    NULLIF(LTRIM(RTRIM(EMAILADDRESS)), '') AS EMAILADDRESS,

    NULLIF(LTRIM(RTRIM(LOGINNAME)), '') AS LOGINNAME,

    NULLIF(LTRIM(RTRIM(ADDRESSID)), '') AS ADDRESSID,

    TRY_CONVERT(DATE, VALIDITY_STARTDATE, 112) AS VALIDITY_START_DATE,

    TRY_CONVERT(DATE, VALIDITY_ENDDATE, 112) AS VALIDITY_END_DATE

FROM stg.Employees;
GO


SELECT TOP 10 *
FROM stg.vw_Employees_Transformed;
GO



/* =========================================================
   Transformation 7:
   Product Descriptions
   ---------------------------------------------------------
   - Select English description where available
   - Fall back to another available language
   - Convert blank descriptions to NULL
   ========================================================= */

CREATE OR ALTER VIEW stg.vw_ProductDescriptions_Transformed
AS
SELECT
    p.PRODUCTID,

    p.LANGUAGE,

    NULLIF(LTRIM(RTRIM(p.SHORT_DESCR)), '') AS SHORT_DESCRIPTION,

    NULLIF(LTRIM(RTRIM(p.MEDIUM_DESCR)), '') AS MEDIUM_DESCRIPTION,

    NULLIF(LTRIM(RTRIM(p.LONG_DESCR)), '') AS LONG_DESCRIPTION

FROM stg.ProductTexts p;
GO


/* =========================================================
   Transformation 8:
   Product Category Descriptions
   ========================================================= */

CREATE OR ALTER VIEW stg.vw_ProductCategoryDescriptions_Transformed
AS
SELECT
    p.PRODCATEGORYID,

    p.LANGUAGE,

    NULLIF(LTRIM(RTRIM(p.SHORT_DESCR)), '') AS SHORT_DESCRIPTION,

    NULLIF(LTRIM(RTRIM(p.MEDIUM_DESCR)), '') AS MEDIUM_DESCRIPTION,

    NULLIF(LTRIM(RTRIM(p.LONG_DESCR)), '') AS LONG_DESCRIPTION

FROM stg.ProductCategoryText p;
GO



USE SAP_Bikes_DW;
GO

SELECT
    DELIVERYDATE,
    COUNT(*) AS TotalRows
FROM stg.SalesOrderItems
GROUP BY DELIVERYDATE
ORDER BY DELIVERYDATE;
GO


USE SAP_Bikes_DW;
GO

SELECT TOP 20
    DELIVERYDATE,
    LEN(DELIVERYDATE) AS DateLength,
    TRY_CONVERT(DATE, DELIVERYDATE, 112) AS ConvertedDate
FROM stg.SalesOrderItems
WHERE DELIVERYDATE IS NOT NULL;
GO


SELECT TOP 20
    SALESORDERID,
    SALESORDERITEM,
    DELIVERY_DATE
FROM stg.vw_SalesOrderItems_Transformed
WHERE DELIVERY_DATE IS NOT NULL;
GO


/* =========================================================
   Transformation 2:
   Sales Order Items
   ---------------------------------------------------------
   - Clean hidden CR/LF characters
   - Convert DELIVERYDATE from YYYYMMDD to DATE
   - Treat 29991212 as NULL
   - Standardize CURRENCY
   - Clean text fields
   - Preserve financial measures and quantity
   ========================================================= */

CREATE OR ALTER VIEW stg.vw_SalesOrderItems_Transformed
AS
SELECT
    soi.SALESORDERID,

    soi.SALESORDERITEM,

    soi.PRODUCTID,

    UPPER(NULLIF(LTRIM(RTRIM(soi.CURRENCY)), '')) AS CURRENCY,

    soi.GROSSAMOUNT,

    soi.NETAMOUNT,

    soi.TAXAMOUNT,

    NULLIF(LTRIM(RTRIM(soi.ITEMATPSTATUS)), '') AS ITEMATPSTATUS,

    soi.QUANTITY,

    NULLIF(LTRIM(RTRIM(soi.QUANTITYUNIT)), '') AS QUANTITYUNIT,

    CASE
        WHEN TRY_CONVERT(
            DATE,
            NULLIF(
                REPLACE(
                    REPLACE(
                        LTRIM(RTRIM(soi.DELIVERYDATE)),
                        CHAR(13),
                        ''
                    ),
                    CHAR(10),
                    ''
                ),
                ''
            ),
            112
        ) = '2999-12-12'
        THEN NULL

        ELSE TRY_CONVERT(
            DATE,
            NULLIF(
                REPLACE(
                    REPLACE(
                        LTRIM(RTRIM(soi.DELIVERYDATE)),
                        CHAR(13),
                        ''
                    ),
                    CHAR(10),
                    ''
                ),
                ''
            ),
            112
        )
    END AS DELIVERY_DATE

FROM stg.SalesOrderItems AS soi;
GO


SELECT TOP 20
    SALESORDERID,
    SALESORDERITEM,
    DELIVERY_DATE
FROM stg.vw_SalesOrderItems_Transformed
WHERE DELIVERY_DATE IS NOT NULL;
GO


SELECT
    COUNT(*) AS TotalItems,
    COUNT(DELIVERY_DATE) AS ValidDeliveryDates,
    COUNT(*) - COUNT(DELIVERY_DATE) AS MissingDeliveryDates
FROM stg.vw_SalesOrderItems_Transformed;
GO


USE SAP_Bikes_DW;
GO

SELECT
    COUNT(*) AS TotalItems,
    COUNT(DELIVERY_DATE) AS ValidDeliveryDates,
    COUNT(*) - COUNT(DELIVERY_DATE) AS MissingDeliveryDates,
    MIN(DELIVERY_DATE) AS MinDeliveryDate,
    MAX(DELIVERY_DATE) AS MaxDeliveryDate
FROM stg.vw_SalesOrderItems_Transformed;
GO