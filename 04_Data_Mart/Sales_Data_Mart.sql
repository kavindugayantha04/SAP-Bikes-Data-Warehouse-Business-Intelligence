
USE SAP_Bikes_DW;
GO


/* =========================================================
   1. MAIN SALES MANAGEMENT VIEW

   Grain:
   One row per Sales Order Item.
   ========================================================= */

CREATE OR ALTER VIEW dm.vw_Sales_Management
AS
SELECT
    /* Sales Order */
    f.SalesOrderID,
    f.SalesOrderItem,

    /* Date */
    d.FullDate AS OrderDate,
    d.DayNumber,
    d.MonthNumber,
    d.MonthName,
    d.QuarterNumber,
    d.QuarterName,
    d.YearNumber,

    /* Product */
    p.ProductID,
    p.ProductTypeCode,
    p.ProductCategoryID,
    p.CategoryName,
    p.ProductName,

    /* Customer */
    c.PartnerID,
    c.CompanyName,
    c.PartnerRole,

    /* Location */
    l.AddressID,
    l.City,
    l.Region,
    l.Country,

    /* Employee */
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.LoginName,

    /* Sales Attributes */
    f.SalesOrg,
    f.Currency,
    f.LifecycleStatus,
    f.BillingStatus,
    f.DeliveryStatus,
    f.ItemATPStatus,
    f.QuantityUnit,

    /* Measures */
    f.GrossAmount,
    f.NetAmount,
    f.TaxAmount,
    f.Quantity

FROM dw.Fact_Sales AS f

INNER JOIN dw.Dim_Date AS d
    ON f.OrderDateKey = d.DateKey

INNER JOIN dw.Dim_Product AS p
    ON f.ProductKey = p.ProductKey

INNER JOIN dw.Dim_Customer AS c
    ON f.CustomerKey = c.CustomerKey

LEFT JOIN dw.Dim_Location AS l
    ON f.LocationKey = l.LocationKey

LEFT JOIN dw.Dim_Employee AS e
    ON f.EmployeeKey = e.EmployeeKey;
GO


/* =========================================================
   2. TEST THE DATA MART VIEW
   ========================================================= */

SELECT TOP 20 *
FROM dm.vw_Sales_Management;
GO


