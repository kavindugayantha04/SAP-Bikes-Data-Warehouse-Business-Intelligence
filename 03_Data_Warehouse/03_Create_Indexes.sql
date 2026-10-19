USE SAP_Bikes_DW;
GO


/* =========================================================
   1. FACT TABLE FOREIGN KEY INDEXES
   ========================================================= */

CREATE INDEX IX_Fact_Sales_OrderDateKey
ON dw.Fact_Sales (OrderDateKey);
GO


CREATE INDEX IX_Fact_Sales_DeliveryDateKey
ON dw.Fact_Sales (DeliveryDateKey);
GO


CREATE INDEX IX_Fact_Sales_ProductKey
ON dw.Fact_Sales (ProductKey);
GO


CREATE INDEX IX_Fact_Sales_CustomerKey
ON dw.Fact_Sales (CustomerKey);
GO


CREATE INDEX IX_Fact_Sales_LocationKey
ON dw.Fact_Sales (LocationKey);
GO


CREATE INDEX IX_Fact_Sales_EmployeeKey
ON dw.Fact_Sales (EmployeeKey);
GO


/* =========================================================
   2. FACT TABLE ANALYTICAL INDEXES
   ========================================================= */

CREATE INDEX IX_Fact_Sales_SalesOrg
ON dw.Fact_Sales (SalesOrg);
GO


CREATE INDEX IX_Fact_Sales_Currency
ON dw.Fact_Sales (Currency);
GO


CREATE INDEX IX_Fact_Sales_LifecycleStatus
ON dw.Fact_Sales (LifecycleStatus);
GO


CREATE INDEX IX_Fact_Sales_DeliveryStatus
ON dw.Fact_Sales (DeliveryStatus);
GO


/* =========================================================
   3. PRODUCT CATEGORY INDEX
   ========================================================= */

CREATE INDEX IX_Dim_Product_ProductCategoryID
ON dw.Dim_Product (ProductCategoryID);
GO


/* =========================================================
   4. CUSTOMER ADDRESS INDEX
   ========================================================= */

CREATE INDEX IX_Dim_Customer_AddressID
ON dw.Dim_Customer (AddressID);
GO


/* =========================================================
   5. EMPLOYEE ADDRESS INDEX
   ========================================================= */

CREATE INDEX IX_Dim_Employee_AddressID
ON dw.Dim_Employee (AddressID);
GO


USE SAP_Bikes_DW;
GO

SELECT
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType
FROM sys.indexes i
WHERE i.object_id IN
(
    OBJECT_ID('dw.Dim_Date'),
    OBJECT_ID('dw.Dim_Product'),
    OBJECT_ID('dw.Dim_Customer'),
    OBJECT_ID('dw.Dim_Location'),
    OBJECT_ID('dw.Dim_Employee'),
    OBJECT_ID('dw.Fact_Sales')
)
AND i.name IS NOT NULL
ORDER BY TableName, IndexName;