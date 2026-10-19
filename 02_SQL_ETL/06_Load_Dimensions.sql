USE SAP_Bikes_DW;
GO


/* =========================================================
   1. CLEAR EXISTING DIMENSION DATA
   ---------------------------------------------------------
   Fact_Sales is currently empty, so dimensions can be
   safely reloaded.
   ========================================================= */

DELETE FROM dw.Dim_Customer;
DELETE FROM dw.Dim_Employee;
DELETE FROM dw.Dim_Product;
DELETE FROM dw.Dim_Location;
DELETE FROM dw.Dim_Date;
GO



DBCC CHECKIDENT ('dw.Dim_Customer', RESEED, 0);
DBCC CHECKIDENT ('dw.Dim_Employee', RESEED, 0);
DBCC CHECKIDENT ('dw.Dim_Product', RESEED, 0);
DBCC CHECKIDENT ('dw.Dim_Location', RESEED, 0);
GO


/* =========================================================
   2. LOAD DIM_DATE
   ---------------------------------------------------------
   Source:
   - vw_SalesOrders_Transformed
   - vw_SalesOrderItems_Transformed
   ========================================================= */


   USE SAP_Bikes_DW;
GO

;WITH DateRange AS
(
    SELECT
        MIN(FullDate) AS MinDate,
        MAX(FullDate) AS MaxDate
    FROM
    (
        SELECT CREATED_DATE AS FullDate
        FROM stg.vw_SalesOrders_Transformed
        WHERE CREATED_DATE IS NOT NULL

        UNION ALL

        SELECT DELIVERY_DATE AS FullDate
        FROM stg.vw_SalesOrderItems_Transformed
        WHERE DELIVERY_DATE IS NOT NULL
    ) D
),
Dates AS
(
    SELECT
        MinDate AS FullDate,
        MaxDate
    FROM DateRange
    WHERE MinDate IS NOT NULL
      AND MaxDate IS NOT NULL

    UNION ALL

    SELECT
        DATEADD(DAY, 1, FullDate),
        MaxDate
    FROM Dates
    WHERE FullDate < MaxDate
)
INSERT INTO dw.Dim_Date
(
    DateKey,
    FullDate,
    DayNumber,
    MonthNumber,
    MonthName,
    QuarterNumber,
    QuarterName,
    YearNumber
)
SELECT
    CONVERT(INT, CONVERT(CHAR(8), FullDate, 112)) AS DateKey,
    FullDate,
    DAY(FullDate) AS DayNumber,
    MONTH(FullDate) AS MonthNumber,
    DATENAME(MONTH, FullDate) AS MonthName,
    DATEPART(QUARTER, FullDate) AS QuarterNumber,
    'Q' + CONVERT(VARCHAR(1), DATEPART(QUARTER, FullDate)) AS QuarterName,
    YEAR(FullDate) AS YearNumber
FROM Dates
OPTION (MAXRECURSION 0);
GO

/* =========================================================
   3. LOAD DIM_LOCATION
   ========================================================= */

INSERT INTO dw.Dim_Location
(
    AddressID,
    City,
    PostalCode,
    Street,
    Building,
    Country,
    Region,
    AddressType,
    Latitude,
    Longitude
)
SELECT
    ADDRESSID,
    CITY,
    POSTALCODE,
    STREET,
    BUILDING,
    COUNTRY,
    REGION,
    ADDRESSTYPE,
    LATITUDE,
    LONGITUDE
FROM stg.vw_Addresses_Transformed;
GO


/* =========================================================
   4. LOAD DIM_CUSTOMER
   ========================================================= */

INSERT INTO dw.Dim_Customer
(
    PartnerID,
    PartnerRole,
    CompanyName,
    LegalForm,
    EmailAddress,
    PhoneNumber,
    Currency,
    AddressID
)
SELECT
    PARTNERID,
    PARTNERROLE,
    COMPANYNAME,
    LEGALFORM,
    EMAILADDRESS,
    PHONENUMBER,
    CURRENCY,
    ADDRESSID
FROM stg.vw_BusinessPartners_Transformed;
GO


/* =========================================================
   5. LOAD DIM_EMPLOYEE
   ========================================================= */

INSERT INTO dw.Dim_Employee
(
    EmployeeID,
    FirstName,
    MiddleName,
    LastName,
    Initials,
    Sex,
    LanguageCode,
    PhoneNumber,
    EmailAddress,
    LoginName,
    AddressID
)
SELECT
    EMPLOYEEID,
    FIRST_NAME,
    MIDDLE_NAME,
    LAST_NAME,
    INITIALS,
    SEX,
    LANGUAGE_CODE,
    PHONENUMBER,
    EMAILADDRESS,
    LOGINNAME,
    ADDRESSID
FROM stg.vw_Employees_Transformed;
GO


/* =========================================================
   6. LOAD DIM_PRODUCT
   ---------------------------------------------------------
   Product information comes from the transformed
   Products view.

   Product and category descriptions come from their
   respective transformation views.
   ========================================================= */

INSERT INTO dw.Dim_Product
(
    ProductID,
    ProductTypeCode,
    ProductCategoryID,
    CategoryName,
    ProductName,
    QuantityUnit,
    WeightMeasure,
    WeightUnit,
    Currency,
    Price
)
SELECT
    p.PRODUCTID,
    p.TYPECODE,
    p.PRODCATEGORYID,

    cat.CategoryName,

    prod.ProductName,

    p.QUANTITYUNIT,
    p.WEIGHTMEASURE,
    p.WEIGHTUNIT,
    p.CURRENCY,
    p.PRICE

FROM stg.vw_Products_Transformed p

OUTER APPLY
(
    SELECT TOP 1
        COALESCE(
            SHORT_DESCRIPTION,
            MEDIUM_DESCRIPTION,
            LONG_DESCRIPTION
        ) AS CategoryName
    FROM stg.vw_ProductCategoryDescriptions_Transformed c
    WHERE c.PRODCATEGORYID = p.PRODCATEGORYID
    ORDER BY
        CASE
            WHEN UPPER(c.LANGUAGE) = 'EN' THEN 0
            ELSE 1
        END,
        c.LANGUAGE
) cat

OUTER APPLY
(
    SELECT TOP 1
        COALESCE(
            SHORT_DESCRIPTION,
            MEDIUM_DESCRIPTION,
            LONG_DESCRIPTION
        ) AS ProductName
    FROM stg.vw_ProductDescriptions_Transformed d
    WHERE d.PRODUCTID = p.PRODUCTID
    ORDER BY
        CASE
            WHEN UPPER(d.LANGUAGE) = 'EN' THEN 0
            ELSE 1
        END,
        d.LANGUAGE
) prod;
GO


/* =========================================================
   7. DIMENSION LOAD VALIDATION
   ========================================================= */

SELECT
    'Dim_Date' AS TableName,
    COUNT(*) AS TotalRows
FROM dw.Dim_Date

UNION ALL

SELECT
    'Dim_Location',
    COUNT(*)
FROM dw.Dim_Location

UNION ALL

SELECT
    'Dim_Customer',
    COUNT(*)
FROM dw.Dim_Customer

UNION ALL

SELECT
    'Dim_Employee',
    COUNT(*)
FROM dw.Dim_Employee

UNION ALL

SELECT
    'Dim_Product',
    COUNT(*)
FROM dw.Dim_Product;
GO


USE SAP_Bikes_DW;
GO

SELECT
    'Sales Orders - Created Date' AS SourceColumn,
    MIN(CREATED_DATE) AS MinDate,
    MAX(CREATED_DATE) AS MaxDate
FROM stg.vw_SalesOrders_Transformed

UNION ALL

SELECT
    'Sales Order Items - Delivery Date',
    MIN(DELIVERY_DATE),
    MAX(DELIVERY_DATE)
FROM stg.vw_SalesOrderItems_Transformed;
GO