/* =========================================================
   SAP Bikes Data Warehouse & BI Project
   ========================================================= */

USE SAP_Bikes_DW;
GO


/* =========================================================
   1. Addresses
   ========================================================= */

CREATE TABLE stg.Addresses
(
    ADDRESSID           VARCHAR(20),
    CITY                VARCHAR(100),
    POSTALCODE          VARCHAR(20),
    STREET              VARCHAR(150),
    BUILDING            VARCHAR(50),
    COUNTRY             VARCHAR(10),
    REGION              VARCHAR(20),
    ADDRESSTYPE         VARCHAR(20),
    VALIDITY_STARTDATE  VARCHAR(20),
    VALIDITY_ENDDATE    VARCHAR(20),
    LATITUDE            DECIMAL(12,8),
    LONGITUDE           DECIMAL(12,8)
);
GO


/* =========================================================
   2. Business Partners
   ========================================================= */

CREATE TABLE stg.BusinessPartners
(
    PARTNERID        VARCHAR(20),
    PARTNERROLE      VARCHAR(20),
    EMAILADDRESS     VARCHAR(150),
    PHONENUMBER      VARCHAR(50),
    FAXNUMBER        VARCHAR(50),
    WEBADDRESS       VARCHAR(250),
    ADDRESSID        VARCHAR(20),
    COMPANYNAME      VARCHAR(150),
    LEGALFORM        VARCHAR(50),
    CREATEDBY        VARCHAR(20),
    CREATEDAT        VARCHAR(20),
    CHANGEDBY        VARCHAR(20),
    CHANGEDAT        VARCHAR(20),
    CURRENCY         VARCHAR(10)
);
GO


/* =========================================================
   3. Employees
   ========================================================= */

CREATE TABLE stg.Employees
(
    EMPLOYEEID          VARCHAR(20),
    NAME_FIRST          VARCHAR(100),
    NAME_MIDDLE         VARCHAR(100),
    NAME_LAST           VARCHAR(100),
    NAME_INITIALS       VARCHAR(20),
    SEX                 VARCHAR(10),
    LANGUAGE            VARCHAR(10),
    PHONENUMBER         VARCHAR(50),
    EMAILADDRESS        VARCHAR(150),
    LOGINNAME           VARCHAR(100),
    ADDRESSID           VARCHAR(20),
    VALIDITY_STARTDATE  VARCHAR(20),
    VALIDITY_ENDDATE    VARCHAR(20)
);
GO


/* =========================================================
   4. Product Categories
   ========================================================= */

CREATE TABLE stg.ProductCategories
(
    PRODCATEGORYID VARCHAR(20),
    CREATEDBY      VARCHAR(20),
    CREATEDAT      VARCHAR(20)
);
GO


/* =========================================================
   5. Product Category Text
   ========================================================= */

CREATE TABLE stg.ProductCategoryText
(
    PRODCATEGORYID VARCHAR(20),
    LANGUAGE       VARCHAR(10),
    SHORT_DESCR    VARCHAR(150),
    MEDIUM_DESCR   VARCHAR(250),
    LONG_DESCR     VARCHAR(500)
);
GO


/* =========================================================
   6. Product Texts
   ========================================================= */

CREATE TABLE stg.ProductTexts
(
    PRODUCTID       VARCHAR(30),
    LANGUAGE        VARCHAR(10),
    SHORT_DESCR     VARCHAR(150),
    MEDIUM_DESCR    VARCHAR(250),
    LONG_DESCR      VARCHAR(500)
);
GO


/* =========================================================
   7. Sales Orders
   ========================================================= */

CREATE TABLE stg.SalesOrders
(
    SALESORDERID       VARCHAR(20),
    CREATEDBY          VARCHAR(20),
    CREATEDAT          VARCHAR(20),
    CHANGEDBY          VARCHAR(20),
    CHANGEDAT          VARCHAR(20),
    FISCVARIANT        VARCHAR(20),
    FISCALYEARPERIOD   VARCHAR(20),
    NOTEID             VARCHAR(50),
    PARTNERID          VARCHAR(20),
    SALESORG           VARCHAR(20),
    CURRENCY            VARCHAR(10),
    GROSSAMOUNT        DECIMAL(18,2),
    NETAMOUNT          DECIMAL(18,2),
    TAXAMOUNT          DECIMAL(18,2),
    LIFECYCLESTATUS    VARCHAR(20),
    BILLINGSTATUS      VARCHAR(20),
    DELIVERYSTATUS     VARCHAR(20)
);
GO


/* =========================================================
   8. Sales Order Items
   ========================================================= */

CREATE TABLE stg.SalesOrderItems
(
    SALESORDERID      VARCHAR(20),
    SALESORDERITEM    VARCHAR(20),
    PRODUCTID         VARCHAR(30),
    CURRENCY          VARCHAR(10),
    GROSSAMOUNT       DECIMAL(18,2),
    NETAMOUNT         DECIMAL(18,2),
    TAXAMOUNT         DECIMAL(18,2),
    ITEMATPSTATUS     VARCHAR(20),
    QUANTITY          DECIMAL(18,3),
    QUANTITYUNIT      VARCHAR(20),
    DELIVERYDATE      VARCHAR(20)
);
GO


/* =========================================================
   9. Products
   ========================================================= */

CREATE TABLE stg.Products
(
    PRODUCTID            VARCHAR(30),
    TYPECODE             VARCHAR(20),
    PRODCATEGORYID       VARCHAR(20),
    CREATEDBY            VARCHAR(20),
    CREATEDAT            VARCHAR(20),
    CHANGEDBY            VARCHAR(20),
    CHANGEDAT            VARCHAR(20),
    SUPPLIER_PARTNERID   VARCHAR(20),
    TAXTARIFFCODE        VARCHAR(20),
    QUANTITYUNIT         VARCHAR(20),
    WEIGHTMEASURE        DECIMAL(18,3),
    WEIGHTUNIT           VARCHAR(20),
    CURRENCY              VARCHAR(10),
    PRICE                 DECIMAL(18,2),
    WIDTH                DECIMAL(18,3),
    DEPTH                DECIMAL(18,3),
    HEIGHT               DECIMAL(18,3),
    DIMENSIONUNIT        VARCHAR(20),
    PRODUCTPICURL        VARCHAR(500)
);
GO