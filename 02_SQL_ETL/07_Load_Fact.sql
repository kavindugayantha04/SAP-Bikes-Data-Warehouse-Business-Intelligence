USE SAP_Bikes_DW;
GO


/* =========================================================
   1. CLEAR EXISTING FACT DATA
   ========================================================= */

DELETE FROM dw.Fact_Sales;
GO


/* =========================================================
   2. LOAD FACT_SALES
   ========================================================= */

INSERT INTO dw.Fact_Sales
(
    SalesOrderID,
    SalesOrderItem,
    OrderDateKey,
    DeliveryDateKey,
    ProductKey,
    CustomerKey,
    LocationKey,
    EmployeeKey,
    SalesOrg,
    Currency,
    LifecycleStatus,
    BillingStatus,
    DeliveryStatus,
    ItemATPStatus,
    GrossAmount,
    NetAmount,
    TaxAmount,
    Quantity,
    QuantityUnit
)
SELECT
    so.SALESORDERID,

    soi.SALESORDERITEM,

    /* Order Date */
    od.DateKey,

    /* Delivery Date */
    dd.DateKey,

    /* Product */
    p.ProductKey,

    /* Customer */
    c.CustomerKey,

    /* Customer Location */
    l.LocationKey,

    /* Employee who created the sales order */
    e.EmployeeKey,

    so.SALESORG,

    soi.CURRENCY,

    so.LIFECYCLESTATUS,

    so.BILLINGSTATUS,

    so.DELIVERYSTATUS,

    soi.ITEMATPSTATUS,

    soi.GROSSAMOUNT,

    soi.NETAMOUNT,

    soi.TAXAMOUNT,

    soi.QUANTITY,

    soi.QUANTITYUNIT

FROM stg.vw_SalesOrders_Transformed AS so

INNER JOIN stg.vw_SalesOrderItems_Transformed AS soi
    ON so.SALESORDERID = soi.SALESORDERID

/* =========================================================
   Date Dimension
   ========================================================= */

INNER JOIN dw.Dim_Date AS od
    ON od.FullDate = so.CREATED_DATE

LEFT JOIN dw.Dim_Date AS dd
    ON dd.FullDate = soi.DELIVERY_DATE

/* =========================================================
   Product Dimension
   ========================================================= */

INNER JOIN dw.Dim_Product AS p
    ON p.ProductID = soi.PRODUCTID

/* =========================================================
   Customer Dimension
   ========================================================= */

INNER JOIN dw.Dim_Customer AS c
    ON c.PartnerID = so.PARTNERID

/* =========================================================
   Location Dimension
   ========================================================= */

LEFT JOIN dw.Dim_Location AS l
    ON l.AddressID = c.AddressID

/* =========================================================
   Employee Dimension
   ========================================================= */

LEFT JOIN dw.Dim_Employee AS e
    ON e.EmployeeID = so.CREATEDBY;
GO


/* =========================================================
   3. FACT LOAD VALIDATION
   ========================================================= */

SELECT
    COUNT(*) AS TotalFactRows
FROM dw.Fact_Sales;
GO