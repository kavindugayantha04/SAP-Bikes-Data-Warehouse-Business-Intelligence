
USE SAP_Bikes_DW;
GO


/* =========================================================
   1. ROW COUNT VALIDATION
   ========================================================= */

SELECT 'Dim_Date' AS TableName, COUNT(*) AS TotalRows
FROM dw.Dim_Date

UNION ALL

SELECT 'Dim_Location', COUNT(*)
FROM dw.Dim_Location

UNION ALL

SELECT 'Dim_Customer', COUNT(*)
FROM dw.Dim_Customer

UNION ALL

SELECT 'Dim_Employee', COUNT(*)
FROM dw.Dim_Employee

UNION ALL

SELECT 'Dim_Product', COUNT(*)
FROM dw.Dim_Product

UNION ALL

SELECT 'Fact_Sales', COUNT(*)
FROM dw.Fact_Sales;
GO


/* =========================================================
   2. FACT DUPLICATE VALIDATION
   ---------------------------------------------------------
   One fact row should represent one Sales Order Item.
   ========================================================= */

SELECT
    SalesOrderID,
    SalesOrderItem,
    COUNT(*) AS DuplicateCount
FROM dw.Fact_Sales
GROUP BY
    SalesOrderID,
    SalesOrderItem
HAVING COUNT(*) > 1;
GO


/* =========================================================
   3. FACT → PRODUCT FOREIGN KEY VALIDATION
   ========================================================= */

SELECT COUNT(*) AS InvalidProductKeys
FROM dw.Fact_Sales f
LEFT JOIN dw.Dim_Product p
    ON f.ProductKey = p.ProductKey
WHERE p.ProductKey IS NULL;
GO


/* =========================================================
   4. FACT → CUSTOMER FOREIGN KEY VALIDATION
   ========================================================= */

SELECT COUNT(*) AS InvalidCustomerKeys
FROM dw.Fact_Sales f
LEFT JOIN dw.Dim_Customer c
    ON f.CustomerKey = c.CustomerKey
WHERE c.CustomerKey IS NULL;
GO


/* =========================================================
   5. FACT → ORDER DATE VALIDATION
   ========================================================= */

SELECT COUNT(*) AS InvalidOrderDateKeys
FROM dw.Fact_Sales f
LEFT JOIN dw.Dim_Date d
    ON f.OrderDateKey = d.DateKey
WHERE d.DateKey IS NULL;
GO


/* =========================================================
   6. FACT → DELIVERY DATE VALIDATION
   ---------------------------------------------------------
   DeliveryDateKey may legitimately be NULL.
   ========================================================= */

SELECT COUNT(*) AS InvalidDeliveryDateKeys
FROM dw.Fact_Sales f
LEFT JOIN dw.Dim_Date d
    ON f.DeliveryDateKey = d.DateKey
WHERE f.DeliveryDateKey IS NOT NULL
  AND d.DateKey IS NULL;
GO


/* =========================================================
   7. FACT → LOCATION VALIDATION
   ---------------------------------------------------------
   LocationKey may be NULL.
   ========================================================= */

SELECT COUNT(*) AS InvalidLocationKeys
FROM dw.Fact_Sales f
LEFT JOIN dw.Dim_Location l
    ON f.LocationKey = l.LocationKey
WHERE f.LocationKey IS NOT NULL
  AND l.LocationKey IS NULL;
GO


/* =========================================================
   8. FACT → EMPLOYEE VALIDATION
   ---------------------------------------------------------
   EmployeeKey may be NULL.
   ========================================================= */

SELECT COUNT(*) AS InvalidEmployeeKeys
FROM dw.Fact_Sales f
LEFT JOIN dw.Dim_Employee e
    ON f.EmployeeKey = e.EmployeeKey
WHERE f.EmployeeKey IS NOT NULL
  AND e.EmployeeKey IS NULL;
GO


/* =========================================================
   9. SOURCE VS FACT ROW COUNT
   ========================================================= */

SELECT
    (
        SELECT COUNT(*)
        FROM stg.vw_SalesOrderItems_Transformed
    ) AS TransformedItemRows,

    (
        SELECT COUNT(*)
        FROM dw.Fact_Sales
    ) AS FactRows;
GO


/* =========================================================
   10. SOURCE VS FACT FINANCIAL TOTALS
   ========================================================= */

SELECT
    'GrossAmount' AS Measure,
    (
        SELECT SUM(GROSSAMOUNT)
        FROM stg.vw_SalesOrderItems_Transformed
    ) AS SourceTotal,
    (
        SELECT SUM(GrossAmount)
        FROM dw.Fact_Sales
    ) AS FactTotal

UNION ALL

SELECT
    'NetAmount',
    (
        SELECT SUM(NETAMOUNT)
        FROM stg.vw_SalesOrderItems_Transformed
    ),
    (
        SELECT SUM(NetAmount)
        FROM dw.Fact_Sales
    )

UNION ALL

SELECT
    'TaxAmount',
    (
        SELECT SUM(TAXAMOUNT)
        FROM stg.vw_SalesOrderItems_Transformed
    ),
    (
        SELECT SUM(TaxAmount)
        FROM dw.Fact_Sales
    )

UNION ALL

SELECT
    'Quantity',
    (
        SELECT SUM(QUANTITY)
        FROM stg.vw_SalesOrderItems_Transformed
    ),
    (
        SELECT SUM(Quantity)
        FROM dw.Fact_Sales
    );
GO


/* =========================================================
   11. NULL DELIVERY DATE VALIDATION
   ========================================================= */

SELECT
    COUNT(*) AS MissingDeliveryDateRows
FROM dw.Fact_Sales
WHERE DeliveryDateKey IS NULL;
GO