USE SAP_Bikes_DW;
GO


/* =========================================================
   1. DIM_DATE
   ========================================================= */

CREATE TABLE dw.Dim_Date
(
    DateKey         INT            NOT NULL,
    FullDate        DATE           NOT NULL,
    DayNumber       INT            NOT NULL,
    MonthNumber     INT            NOT NULL,
    MonthName       VARCHAR(20)    NOT NULL,
    QuarterNumber   INT            NOT NULL,
    QuarterName     VARCHAR(10)    NOT NULL,
    YearNumber      INT            NOT NULL
);
GO


/* =========================================================
   2. DIM_PRODUCT
   ========================================================= */

CREATE TABLE dw.Dim_Product
(
    ProductKey          INT IDENTITY(1,1) NOT NULL,
    ProductID           VARCHAR(30)       NOT NULL,
    ProductTypeCode     VARCHAR(20)       NULL,
    ProductCategoryID   VARCHAR(20)       NULL,
    CategoryName        VARCHAR(250)      NULL,
    ProductName         VARCHAR(250)      NULL,
    QuantityUnit        VARCHAR(20)       NULL,
    WeightMeasure       DECIMAL(18,3)     NULL,
    WeightUnit          VARCHAR(20)       NULL,
    Currency            VARCHAR(10)       NULL,
    Price               DECIMAL(18,2)     NULL
);
GO


/* =========================================================
   3. DIM_CUSTOMER
   ========================================================= */

CREATE TABLE dw.Dim_Customer
(
    CustomerKey     INT IDENTITY(1,1) NOT NULL,
    PartnerID       VARCHAR(20)       NOT NULL,
    PartnerRole     VARCHAR(20)       NULL,
    CompanyName     VARCHAR(150)      NULL,
    LegalForm       VARCHAR(50)       NULL,
    EmailAddress    VARCHAR(150)      NULL,
    PhoneNumber     VARCHAR(50)       NULL,
    Currency        VARCHAR(10)       NULL,
    AddressID       VARCHAR(20)       NULL
);
GO


/* =========================================================
   4. DIM_LOCATION
   ========================================================= */

CREATE TABLE dw.Dim_Location
(
    LocationKey         INT IDENTITY(1,1) NOT NULL,
    AddressID           VARCHAR(20)       NOT NULL,
    City                VARCHAR(100)      NULL,
    PostalCode          VARCHAR(20)       NULL,
    Street              VARCHAR(150)      NULL,
    Building            VARCHAR(50)       NULL,
    Country             VARCHAR(10)       NULL,
    Region              VARCHAR(20)       NULL,
    AddressType         VARCHAR(20)       NULL,
    Latitude            DECIMAL(12,8)     NULL,
    Longitude           DECIMAL(12,8)     NULL
);
GO


/* =========================================================
   5. DIM_EMPLOYEE
   ========================================================= */

CREATE TABLE dw.Dim_Employee
(
    EmployeeKey     INT IDENTITY(1,1) NOT NULL,
    EmployeeID      VARCHAR(20)       NOT NULL,
    FirstName       VARCHAR(100)      NULL,
    MiddleName      VARCHAR(100)      NULL,
    LastName        VARCHAR(100)      NULL,
    Initials        VARCHAR(20)       NULL,
    Sex             VARCHAR(10)       NULL,
    LanguageCode    VARCHAR(10)       NULL,
    PhoneNumber     VARCHAR(50)       NULL,
    EmailAddress    VARCHAR(150)      NULL,
    LoginName       VARCHAR(100)      NULL,
    AddressID       VARCHAR(20)       NULL
);
GO


/* =========================================================
   6. FACT_SALES
   ========================================================= */

CREATE TABLE dw.Fact_Sales
(
    SalesKey            BIGINT IDENTITY(1,1) NOT NULL,

    -- Business keys
    SalesOrderID        VARCHAR(20)       NOT NULL,
    SalesOrderItem      VARCHAR(20)       NOT NULL,

    -- Dimension foreign keys
    OrderDateKey        INT                NOT NULL,
    DeliveryDateKey     INT                NULL,
    ProductKey          INT                NOT NULL,
    CustomerKey         INT                NOT NULL,
    LocationKey         INT                NULL,
    EmployeeKey         INT                NULL,

    -- Order information
    SalesOrg             VARCHAR(20)       NULL,
    Currency             VARCHAR(10)       NULL,
    LifecycleStatus      VARCHAR(20)       NULL,
    BillingStatus        VARCHAR(20)       NULL,
    DeliveryStatus       VARCHAR(20)       NULL,
    ItemATPStatus        VARCHAR(20)       NULL,

    -- Measures
    GrossAmount          DECIMAL(18,2)     NOT NULL,
    NetAmount            DECIMAL(18,2)     NOT NULL,
    TaxAmount            DECIMAL(18,2)     NOT NULL,
    Quantity             DECIMAL(18,3)     NOT NULL,
    QuantityUnit         VARCHAR(20)       NULL
);
GO


USE SAP_Bikes_DW;
GO

SELECT 
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dw'
ORDER BY TABLE_NAME;